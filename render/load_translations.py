"""
Load render/bulk_translate.py's checkpointed JSONL output into the
notification_translation table, so render/query_translation.py can serve
those translations from the database instead of the loose files.

    python3 -m render.load_translations --db gazette.db --dir data/translations
    python3 -m render.load_translations --dir data/translations --langs hi,bn

Safe to re-run at any point during or after a bulk_translate.py run --
upsert_translation() merges by field, so loading a partial hi.jsonl now and
the completed one later never loses or duplicates anything. The backend
name embedded in bulk_translate.py's own output isn't recorded per-line, so
this infers it from which file it's reading (--backend, defaulting to
'krutrim' -- the one bulk_translate.py's own default recommends).
"""
from __future__ import annotations

import argparse
import json
import sqlite3
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from render.query_translation import upsert_translation  # noqa: E402
from render.translate import TRANSLATABLE_FIELDS  # noqa: E402


def load_file(conn: sqlite3.Connection, path: Path, lang: str, backend: str) -> tuple[int, int]:
    loaded, skipped = 0, 0
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                skipped += 1
                continue
            gazette_id = rec.get("gazette_id")
            fields = {field: rec[field] for field in TRANSLATABLE_FIELDS if rec.get(field) and rec.get(f"{field}_en")}
            if not gazette_id or not fields:
                skipped += 1
                continue
            upsert_translation(conn, gazette_id, lang, fields, backend)
            loaded += 1
    return loaded, skipped


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--db", default="gazette.db")
    parser.add_argument("--dir", default="data/translations")
    parser.add_argument("--langs", help="comma-separated language codes; default: every *.jsonl file found in --dir")
    parser.add_argument("--backend", default="krutrim", help="backend name to record for these rows (default: krutrim)")
    args = parser.parse_args()

    in_dir = Path(args.dir)
    if args.langs:
        files = [(code, in_dir / f"{code}.jsonl") for code in args.langs.split(",") if code.strip()]
    else:
        files = [(p.stem, p) for p in sorted(in_dir.glob("*.jsonl")) if not p.stem.endswith(".failed")]

    conn = sqlite3.connect(args.db)
    total_loaded = total_skipped = 0
    for lang, path in files:
        if not path.exists():
            print(f"[{lang}] {path} not found, skipping")
            continue
        loaded, skipped = load_file(conn, path, lang, args.backend)
        total_loaded += loaded
        total_skipped += skipped
        print(f"[{lang}] loaded {loaded}, skipped {skipped} (from {path})")
    conn.close()
    print(f"total: loaded {total_loaded}, skipped {total_skipped}")


if __name__ == "__main__":
    main()
