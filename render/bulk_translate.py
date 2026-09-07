"""
Translate the whole corpus's one-line summary into a set of priority
languages, checkpointed so a long-running or interrupted job can resume
without re-translating what's already done.

    python3 -m render.bulk_translate --backend krutrim --langs hi,bn,mr,te,ta,gu,kn,ml,pa
    python3 -m render.bulk_translate --langs hi,bn,mr,te,ta,gu,kn,ml,pa --db gazette.db --out data/translations
    python3 -m render.bulk_translate --backend libretranslate --langs ur,fr,es,ar,zh,ru,pt,de,ja

Scope decision: only `summary` (render.llm_export's generated one-sentence
description -- the line a reader scans to judge relevance in a search
result), not the full four-field record. The corpus has 2,591
notifications; translating ministry+instrument+thread+summary for all of
them in even 5 languages is ~52,000 calls. summary-only cuts that to
~13,000. A reader who lands on a specific notification already gets the
full record translated live via `render.translate`; this script is for
bulk *search-result* coverage, not per-record depth.

Language choice: TOP_LANGUAGES covers every language KRUTRIM_CODES
supports (Hindi, Bengali, Marathi, Telugu, Tamil, Gujarati, Kannada,
Malayalam, Punjabi), ordered by native speakers in India per the 2011
Census -- the first 5 alone already cover roughly 60% of the population;
the full 9 push well past that. Krutrim's coverage is the ceiling here,
not the target: Odia is larger by speaker count than some languages in
this list but isn't in KRUTRIM_CODES, so it stays out of bulk translation
until a backend supports it. Urdu -- also larger than several
TOP_LANGUAGES entries -- is covered separately, via --backend
libretranslate (see below), since Krutrim doesn't reach it either.

Backend: --backend krutrim is the recommended choice for TOP_LANGUAGES --
a self-hosted CTranslate2 server (~/krutrim-translate/server.py) covering
all 9 with no per-call quota, confirmed running at ~0.1-0.2s/call on CPU
(no GPU needed). --backend gemini is capped at Google AI Studio's
free-tier quota of 20 requests/day *per model* -- confirmed by exhausting
it on two different model names in the same day while running this exact
job. --backend libretranslate (self-hosted, `libretranslate --port 5001
--load-only en,ur,fr,es,ar,zh,ru,pt,de,ja`, Argos Translate models) is
the *complementary* run this project actually uses for the languages
Krutrim doesn't cover: Urdu, plus the 8-of-11 foreign-language tier
(French, Spanish, Arabic, Chinese, Russian, Portuguese, German,
Japanese) -- confirmed live for the full 2,591-notification corpus in
all 9, zero failures. Not a fallback for TOP_LANGUAGES; a second,
disjoint language set.

Checkpointing: each language writes to its own JSONL file
(<out>/<lang>.jsonl), one line per successfully translated notification.
On (re)start, gazette_ids already present in that file are skipped, so an
interrupted run -- or one that hits a rate-limit wall -- picks up exactly
where it left off rather than re-spending calls. A record that fails after
its own retries is logged to <out>/<lang>.failed.jsonl (gazette_id + error)
and the run continues; it is not counted as done, so a later run retries
it automatically.
"""
from __future__ import annotations

import argparse
import json
import sqlite3
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from render.llm_export import build_record  # noqa: E402
from render.translate import (  # noqa: E402
    KRUTRIM_CODES,
    LIBRETRANSLATE_CODES,
    SUPPORTED_LANGUAGES,
    translate_record,
    translate_record_krutrim,
    translate_record_libretranslate,
)

# Every language KRUTRIM_CODES supports, ordered by native speakers in
# India (2011 Census): Hindi, Bengali, Marathi, Telugu, Tamil, Gujarati,
# Kannada, Malayalam, Punjabi.
TOP_LANGUAGES = ["hi", "bn", "mr", "te", "ta", "gu", "kn", "ml", "pa"]

FIELDS = ("summary",)

BACKEND_FNS = {
    "krutrim": translate_record_krutrim,
    "libretranslate": translate_record_libretranslate,
}


def _all_notifications(conn: sqlite3.Connection) -> list[dict]:
    conn.row_factory = sqlite3.Row
    rows = conn.execute(
        """
        SELECT g.*, m.name AS ministry_name, a.title AS instrument_title, t.subject_summary AS thread_summary
        FROM gazette_notification g
        LEFT JOIN ministry m ON m.ministry_id = g.ministry_id
        LEFT JOIN act_or_rule a ON a.instrument_id = g.instrument_id
        LEFT JOIN subject_thread t ON t.thread_id = g.thread_id
        ORDER BY g.gazette_id
        """
    ).fetchall()
    return [dict(r) for r in rows]


def _done_ids(path: Path) -> set[str]:
    if not path.exists():
        return set()
    done = set()
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                done.add(json.loads(line)["gazette_id"])
            except (json.JSONDecodeError, KeyError):
                continue
    return done


def run(db: str, out_dir: str, langs: list[str], delay: float, backend: str) -> None:
    conn = sqlite3.connect(db)
    records = [build_record(conn, notif) for notif in _all_notifications(conn)]
    conn.close()

    out_path = Path(out_dir)
    out_path.mkdir(parents=True, exist_ok=True)
    backend_fn = BACKEND_FNS.get(backend)

    for lang in langs:
        lang_name = SUPPORTED_LANGUAGES[lang]
        out_file = out_path / f"{lang}.jsonl"
        fail_file = out_path / f"{lang}.failed.jsonl"
        done = _done_ids(out_file)
        remaining = [r for r in records if r["gazette_id"] not in done]
        print(f"[{lang}] {lang_name} ({backend}): {len(done)} already done, {len(remaining)} remaining", flush=True)

        with open(out_file, "a", encoding="utf-8") as out_f, open(fail_file, "a", encoding="utf-8") as fail_f:
            for i, record in enumerate(remaining, 1):
                try:
                    if backend_fn is not None:
                        translated = backend_fn(record, lang=lang, fields=FIELDS)
                    else:
                        translated = translate_record(record, lang=lang, fields=FIELDS)
                    out_f.write(json.dumps(translated, ensure_ascii=False) + "\n")
                    out_f.flush()
                except Exception as e:  # noqa: BLE001 -- one bad record must not kill the whole run
                    fail_f.write(json.dumps({"gazette_id": record["gazette_id"], "error": str(e)}) + "\n")
                    fail_f.flush()
                    print(f"[{lang}] FAILED {record['gazette_id']}: {e}", flush=True)
                if i % 25 == 0 or i == len(remaining):
                    print(f"[{lang}] {i}/{len(remaining)}", flush=True)
                if delay:
                    time.sleep(delay)

    print("done", flush=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--langs", default=",".join(TOP_LANGUAGES),
                         help=f"comma-separated language codes, default: {','.join(TOP_LANGUAGES)}")
    parser.add_argument("--backend", choices=["gemini", "libretranslate", "krutrim"], default="gemini")
    parser.add_argument("--db", default="gazette.db")
    parser.add_argument("--out", default="data/translations")
    parser.add_argument("--delay", type=float, default=None,
                         help="seconds to sleep between calls; default 1.5 for gemini (proactive quota throttle), "
                              "0 for krutrim/libretranslate (self-hosted, no shared quota to protect)")
    args = parser.parse_args()

    langs = [c.strip() for c in args.langs.split(",") if c.strip()]
    valid = {
        "krutrim": KRUTRIM_CODES,
        "libretranslate": LIBRETRANSLATE_CODES,
    }.get(args.backend, SUPPORTED_LANGUAGES)
    for c in langs:
        if c not in valid:
            parser.error(f"unsupported language code {c!r} for --backend {args.backend}; choose from {sorted(valid)}")

    delay = args.delay if args.delay is not None else (0.0 if args.backend in ("krutrim", "libretranslate") else 1.5)
    run(args.db, args.out, langs, delay, args.backend)


if __name__ == "__main__":
    main()
