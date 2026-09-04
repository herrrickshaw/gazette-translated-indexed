"""
Human-in-the-loop review of auto-suggested cross-references.

    python3 -m verify.review_queue --db gazette.db

Lists every cross_reference row with verified_by IS NULL (i.e. proposed by
extract.cross_ref but not yet confirmed by a person), and for each one asks
accept / reject / skip. Machines propose, people confirm — nothing here
goes live unverified.

Goes through db.crud rather than its own SQL — this module used to run
UPDATE/DELETE directly; that logic now lives once, in crud.py, alongside
create/read/archive/hard-delete for the same tables.
"""
from __future__ import annotations

import argparse
import sqlite3

from db.crud import hard_delete_cross_reference, list_cross_references, verify_cross_reference


def pending(conn: sqlite3.Connection) -> list[dict]:
    return list_cross_references(conn, unverified_only=True)


def review(conn: sqlite3.Connection, reviewer: str) -> None:
    rows = pending(conn)
    if not rows:
        print('Nothing pending review.')
        return
    print(f'{len(rows)} candidate link(s) pending review.\n')
    for row in rows:
        print(f'[{row["ref_id"]}] {row["source_gazette_id"]} '
              f'--{row["relation_type"]}--> {row["target_gazette_id"]}')
        answer = input('  accept / reject / skip? [a/r/s] ').strip().lower()
        if answer == 'a':
            verify_cross_reference(conn, row['ref_id'], verified_by=reviewer)
        elif answer == 'r':
            hard_delete_cross_reference(conn, row['ref_id'])
        # 's' (or anything else): leave pending, move on
    conn.commit()


def main() -> int:
    ap = argparse.ArgumentParser(description='Review auto-suggested cross-references')
    ap.add_argument('--db', required=True)
    ap.add_argument('--reviewer', default='cli-reviewer')
    args = ap.parse_args()

    conn = sqlite3.connect(args.db)
    conn.execute('PRAGMA foreign_keys = ON')
    try:
        review(conn, args.reviewer)
    finally:
        conn.close()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
