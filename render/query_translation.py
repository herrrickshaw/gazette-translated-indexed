"""
Look up a notification's translation by the identifier a reader actually has
in hand -- series + number (e.g. "Customs" + "45/2025"), or gazette_id -- and
a language preference. Serves from the notification_translation cache table
and fills any missing field on demand (persisting it back), so a query gets
faster and more complete the more it's used instead of re-translating from
scratch every time.

    python3 -m render.query_translation --series Customs --number 45/2025 --lang hi
    python3 -m render.query_translation --gazette-id cus-45-2025 --lang mr
    python3 -m render.query_translation --gazette-id cus-45-2025 --languages   # what's cached, no translation
    python3 -m render.query_translation --series Customs --number 45/2025 --lang si --no-fill

Backend is picked automatically per language via render.translate.resolve_backend
(krutrim -> libretranslate -> gemini, whichever actually covers the requested
code) -- the caller doesn't need to know which self-hosted service covers
which language. Pass --backend to force one explicitly (e.g. to compare
quality, or because a specific service is known to be down).

This is a read path for the *data* this project generates (ministry name,
instrument title, thread summary, one-line summary) -- never the
notification's own legal text. See render/translate.py's module docstring.
"""
from __future__ import annotations

import argparse
import json
import sqlite3
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from db.crud import get_notification, get_notification_by_number  # noqa: E402
from render.llm_export import build_record  # noqa: E402
from render.translate import (  # noqa: E402
    BACKEND_FNS,
    SUPPORTED_LANGUAGES,
    TRANSLATABLE_FIELDS,
    resolve_backend,
)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def get_cached_translation(conn: sqlite3.Connection, gazette_id: str, lang: str) -> dict | None:
    conn.row_factory = sqlite3.Row
    row = conn.execute(
        "SELECT * FROM notification_translation WHERE gazette_id = ? AND lang = ?",
        (gazette_id, lang),
    ).fetchone()
    return dict(row) if row else None


def list_cached_languages(conn: sqlite3.Connection, gazette_id: str) -> list[str]:
    conn.row_factory = sqlite3.Row
    rows = conn.execute(
        "SELECT lang FROM notification_translation WHERE gazette_id = ? ORDER BY lang",
        (gazette_id,),
    ).fetchall()
    return [r["lang"] for r in rows]


def upsert_translation(conn: sqlite3.Connection, gazette_id: str, lang: str,
                        fields: dict[str, str], backend: str) -> None:
    """Merge `fields` into the (gazette_id, lang) row -- an existing field not
    present in `fields` is left untouched, so filling in `summary` today
    doesn't wipe out a `ministry` translated yesterday."""
    existing = get_cached_translation(conn, gazette_id, lang) or {}
    merged = {f: existing.get(f) for f in TRANSLATABLE_FIELDS}
    merged.update(fields)
    conn.execute(
        """
        INSERT INTO notification_translation (gazette_id, lang, ministry, instrument, thread, summary, backend, translated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(gazette_id, lang) DO UPDATE SET
            ministry = excluded.ministry, instrument = excluded.instrument,
            thread = excluded.thread, summary = excluded.summary,
            backend = excluded.backend, translated_at = excluded.translated_at
        """,
        (gazette_id, lang, merged["ministry"], merged["instrument"], merged["thread"], merged["summary"],
         backend, _now()),
    )
    conn.commit()


def _fetch_record_for_query(conn: sqlite3.Connection, gazette_id: str) -> dict:
    conn.row_factory = sqlite3.Row
    notif = conn.execute(
        """
        SELECT g.*, m.name AS ministry_name, a.title AS instrument_title, t.subject_summary AS thread_summary
        FROM gazette_notification g
        LEFT JOIN ministry m ON m.ministry_id = g.ministry_id
        LEFT JOIN act_or_rule a ON a.instrument_id = g.instrument_id
        LEFT JOIN subject_thread t ON t.thread_id = g.thread_id
        WHERE g.gazette_id = ?
        """,
        (gazette_id,),
    ).fetchone()
    if notif is None:
        raise LookupError(f"no notification found for gazette_id {gazette_id!r}")
    return build_record(conn, dict(notif))


def _split_cached_and_missing(record: dict, cached: dict, lang: str,
                               fields: tuple[str, ...]) -> tuple[dict, list[str]]:
    """Returns (out, missing): `out` is `record` plus '<field>_en' originals and
    any already-cached translations already filled in; `missing` lists the
    fields that still need a live translation."""
    out = dict(record)
    out["lang"] = lang
    missing = []
    for field in fields:
        value = record.get(field)
        if not value:
            continue
        out[f"{field}_en"] = value
        if cached.get(field):
            out[field] = cached[field]
        else:
            missing.append(field)
    return out, missing


def _fill_and_cache(conn: sqlite3.Connection, gazette_id: str, lang: str, record: dict,
                     missing: list[str], backend: str | None) -> dict[str, str]:
    """Translates `missing` fields live and persists the result; returns just
    the newly-filled fields (empty dict if the backend produced nothing)."""
    used_backend = backend or resolve_backend(lang)
    fresh = BACKEND_FNS[used_backend](record, lang=lang, fields=tuple(missing))
    new_fields = {f: fresh[f] for f in missing if fresh.get(f)}
    if new_fields:
        upsert_translation(conn, gazette_id, lang, new_fields, used_backend)
    return new_fields


def get_translation(conn: sqlite3.Connection, gazette_id: str, lang: str,
                     fields: tuple[str, ...] = TRANSLATABLE_FIELDS,
                     fill_missing: bool = True, backend: str | None = None) -> dict:
    """Returns the notification's record (render.llm_export.build_record shape)
    with `fields` translated into `lang`, plus '<field>_en' originals -- served
    from notification_translation where already cached, translated live (and
    cached back) for whatever's missing, unless fill_missing=False."""
    if lang not in SUPPORTED_LANGUAGES:
        raise ValueError(f"unsupported language code {lang!r}; choose from {sorted(SUPPORTED_LANGUAGES)}")

    record = _fetch_record_for_query(conn, gazette_id)
    cached = get_cached_translation(conn, gazette_id, lang) or {}
    out, missing = _split_cached_and_missing(record, cached, lang, fields)

    if missing and fill_missing:
        new_fields = _fill_and_cache(conn, gazette_id, lang, record, missing, backend)
        out.update(new_fields)
        out["_translated_live"] = sorted(new_fields)
    elif missing:
        out["_not_cached"] = missing

    return out


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--gazette-id", help="internal id, e.g. cus-45-2025")
    parser.add_argument("--series", help='e.g. "Customs" -- use with --number instead of --gazette-id')
    parser.add_argument("--number", help='e.g. "45/2025" -- use with --series instead of --gazette-id')
    parser.add_argument("--lang", choices=sorted(SUPPORTED_LANGUAGES), help="language preference")
    parser.add_argument("--backend", choices=sorted(BACKEND_FNS), help="force a backend instead of auto-picking one")
    parser.add_argument("--no-fill", action="store_true", help="only read the cache; never translate live")
    parser.add_argument("--languages", action="store_true", help="list cached languages for this notification and exit")
    parser.add_argument("--db", default="gazette.db")
    args = parser.parse_args()

    if not args.gazette_id and not (args.series and args.number):
        parser.error("pass --gazette-id, or both --series and --number")
    if not args.languages and not args.lang:
        parser.error("--lang is required unless --languages")

    conn = sqlite3.connect(args.db)
    if args.gazette_id:
        notif = get_notification(conn, args.gazette_id)
        gazette_id = args.gazette_id
    else:
        notif = get_notification_by_number(conn, args.series, args.number)
        gazette_id = notif["gazette_id"] if notif else None
    if notif is None:
        identifier = f"gazette_id {args.gazette_id!r}" if args.gazette_id else f"{args.series!r} {args.number!r}"
        raise SystemExit(f"no notification found for {identifier}")

    if args.languages:
        cached = list_cached_languages(conn, gazette_id)
        print(f"gazette_id: {gazette_id}")
        print(f"cached languages ({len(cached)}): {', '.join(cached) if cached else '(none yet)'}")
        print(f"any of the {len(SUPPORTED_LANGUAGES)} SUPPORTED_LANGUAGES can still be requested live with --lang")
        return

    translated = get_translation(conn, gazette_id, args.lang, fill_missing=not args.no_fill, backend=args.backend)
    print(json.dumps(translated, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
