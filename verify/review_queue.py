"""
Human-in-the-loop review of auto-suggested cross-references.

    python3 -m verify.review_queue --db gazette.db

Lists every cross_reference row with verified_by IS NULL (i.e. proposed by
extract.cross_ref but not yet confirmed by a person), and for each one asks
accept / reject / skip. Machines propose, people confirm — nothing here
goes live unverified.
"""
from __future__ import annotations

import argparse
import sqlite3
from datetime import datetime, timezone


def pending(conn: sqlite3.Connection) -> list[sqlite3.Row]:
    conn.row_factory = sqlite3.Row
    return conn.execute(
        'SELECT * FROM cross_reference WHERE verified_by IS NULL ORDER BY ref_id'
    ).fetchall()


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
            conn.execute(
                'UPDATE cross_reference SET verified_by = ?, verified_at = ? WHERE ref_id = ?',
                (reviewer, datetime.now(timezone.utc).isoformat(timespec='seconds'), row['ref_id']),
            )
        elif answer == 'r':
            conn.execute('DELETE FROM cross_reference WHERE ref_id = ?', (row['ref_id'],))
        # 's' (or anything else): leave pending, move on
    conn.commit()


def main() -> int:
    ap = argparse.ArgumentParser(description='Review auto-suggested cross-references')
    ap.add_argument('--db', required=True)
    ap.add_argument('--reviewer', default='cli-reviewer')
    args = ap.parse_args()

    conn = sqlite3.connect(args.db)
    try:
        review(conn, args.reviewer)
    finally:
        conn.close()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
