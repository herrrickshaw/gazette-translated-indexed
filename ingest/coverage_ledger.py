"""
Track which (ministry, date-range) windows this project has actually
searched via ingest.egazette_search, and what each search found -- a
coverage ledger, not a citation model.

    python3 -m ingest.coverage_ledger --db gazette.db --ministry steel --since 2020-01-01
    python3 -m ingest.coverage_ledger --db gazette.db --render                     # markdown, all ministries
    python3 -m ingest.coverage_ledger --db gazette.db --render --ministry steel
    python3 -m ingest.coverage_ledger --db gazette.db --render --out docs/EXTRACTION_COVERAGE.md

Why this exists: freshness checks and depth-pass research agents both run
date-range searches against egazette.gov.in and gazettetracker.com, but
neither records WHICH windows were actually checked -- only what ended up
modeled. Two problems follow from that gap: (1) a later session has no way
to tell "has anyone already searched Ministry X for 2015-2018" without
re-running the search, and (2), more importantly, there is no record of
which date ranges have NEVER been checked at all -- exactly the gap worth
cross-referencing against a different source entirely (a ministry's own
website, PIB releases, an official gazette index) rather than re-polling
the same two sources this project already relies on.

This module never touches cross_reference or gazette_notification -- it
only logs "this window was searched, here is what came back" to
extraction_coverage. Modeling a citation from what a search finds stays a
separate, human-reviewed step, same as everywhere else in this project.
"""
from __future__ import annotations

import argparse
import json
import sqlite3
import sys
from datetime import date, datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from db.egazette_ministry_map import EGAZETTE_MINISTRY_VALUES  # noqa: E402
from ingest.egazette_search import search_by_ministry_since  # noqa: E402

SOURCE_EGAZETTE_SEARCH = "egazette_search"


def _now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def record_coverage(
    conn: sqlite3.Connection, ministry_id: str, source: str,
    date_from: date, date_to: date, gazette_ids: list[str],
    possibly_truncated: list[tuple[int, int]] | None = None,
    failed_months: list[tuple[int, int]] | None = None,
) -> int:
    """Log one coverage entry. Never deduplicates against a prior entry
    for the same window -- re-checking a window and recording it again is
    itself useful evidence (e.g. "still exhausted as of this later date").
    `failed_months` names any (year, month) inside [date_from, date_to]
    that was never actually searched (retries exhausted) -- present so the
    ledger doesn't silently claim full coverage for a window that has real
    holes in it (see ingest.egazette_search.search_by_ministry_since)."""
    cur = conn.execute(
        """INSERT INTO extraction_coverage
           (ministry_id, source, date_from, date_to, gazette_ids_found, possibly_truncated, failed_months, checked_at)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
        (ministry_id, source, date_from.isoformat(), date_to.isoformat(),
         json.dumps(sorted(gazette_ids)),
         json.dumps(possibly_truncated) if possibly_truncated else None,
         json.dumps(failed_months) if failed_months else None, _now()),
    )
    conn.commit()
    return cur.lastrowid


def scan_and_record(
    conn: sqlite3.Connection, ministry_id: str, since: date, until: date | None = None,
) -> dict:
    """Run ingest.egazette_search.search_by_ministry_since() for every
    ddlMinistry value this ministry maps to (db/egazette_ministry_map.py
    -- some ministries, e.g. atomic-energy, appear under more than one
    historical name), and log ONE coverage row covering the full
    requested window. One row per requested window, not one per internal
    month-chunk -- the ledger tracks what was asked for, not
    search_by_ministry_since()'s own chunking to stay under the site's
    page-size cap. A month that fails outright for a dropdown value
    (network/server error surviving retries) is recorded in
    `failed_months` rather than aborting the whole scan -- a long
    multi-year window is many independent requests, and one bad month
    used to take every already-fetched month down with it."""
    values = EGAZETTE_MINISTRY_VALUES.get(ministry_id)
    if not values:
        raise ValueError(f"no egazette.gov.in ddlMinistry value mapped for {ministry_id!r}")
    until = until or date.today()
    all_ids: set[str] = set()
    all_truncated: list[tuple[int, int]] = []
    all_failed: list[tuple[int, int]] = []
    for value in values:
        results, truncated, failed = search_by_ministry_since(value, since, until)
        all_ids.update(r.gazette_id for r in results)
        all_truncated.extend(truncated)
        all_failed.extend(failed)
    coverage_id = record_coverage(
        conn, ministry_id, SOURCE_EGAZETTE_SEARCH, since, until,
        sorted(all_ids), all_truncated or None, sorted(set(all_failed)) or None,
    )
    return {
        "coverage_id": coverage_id, "ministry_id": ministry_id,
        "date_from": since.isoformat(), "date_to": until.isoformat(),
        "gazette_ids_found": sorted(all_ids), "possibly_truncated": all_truncated,
        "failed_months": sorted(set(all_failed)),
    }


def render_ledger(conn: sqlite3.Connection, ministry_id: str | None = None) -> str:
    """Date-wise markdown table of every recorded coverage window, oldest
    first per ministry -- what's been checked, by which source, and how
    many gazettes it found. Meant to be read alongside a ministry's own
    gazette_notification span (see docs/HISTORICAL_COVERAGE.md) to spot
    date ranges that have never been searched by anything this project
    has, and are worth checking against an outside source instead."""
    conn.row_factory = sqlite3.Row
    query = (
        "SELECT c.*, m.name AS ministry_name FROM extraction_coverage c "
        "JOIN ministry m ON m.ministry_id = c.ministry_id"
    )
    params: tuple = ()
    if ministry_id:
        query += " WHERE c.ministry_id = ?"
        params = (ministry_id,)
    query += " ORDER BY c.ministry_id, c.date_from"
    rows = conn.execute(query, params).fetchall()

    lines = [
        "| Ministry | Source | Date range | Gazettes found | Possibly truncated | Failed months (not covered) | Checked at |",
        "|---|---|---|---:|---|---|---|",
    ]
    for row in rows:
        ids = json.loads(row["gazette_ids_found"])
        truncated = json.loads(row["possibly_truncated"]) if row["possibly_truncated"] else []
        failed = json.loads(row["failed_months"]) if row["failed_months"] else []
        lines.append(
            f"| {row['ministry_name']} | {row['source']} | {row['date_from']}..{row['date_to']} | "
            f"{len(ids)} | {('yes: ' + str(truncated)) if truncated else 'no'} | "
            f"{str(failed) if failed else 'none'} | {row['checked_at']} |"
        )
    if len(lines) == 2:
        lines.append("| *(no coverage recorded yet)* | | | | | | |")
    return "\n".join(lines)


def _build_parser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--db", default="gazette.db")
    ap.add_argument("--ministry", default=None, help="ministry_id to scan+record, or to filter --render by")
    ap.add_argument("--since", default=None, help="YYYY-MM-DD, start of the scan window (required with --ministry, unless --render)")
    ap.add_argument("--until", default=None, help="YYYY-MM-DD, default today")
    ap.add_argument("--render", action="store_true", help="print the ledger as markdown instead of scanning")
    ap.add_argument("--out", default=None, help="write the rendered ledger to this file instead of stdout (only with --render)")
    return ap


def main() -> int:
    args = _build_parser().parse_args()
    conn = sqlite3.connect(args.db)

    if args.render:
        table = render_ledger(conn, args.ministry)
        if args.out:
            Path(args.out).write_text(
                f"# Extraction coverage ledger\n\n"
                f"Regenerated by `python3 -m ingest.coverage_ledger --render` -- "
                f"see that module's docstring for what this tracks and why.\n\n{table}\n"
            )
            print(f"wrote {args.out}", file=sys.stderr)
        else:
            print(table)
        return 0

    if not args.ministry or not args.since:
        print("--ministry and --since are required unless --render is given", file=sys.stderr)
        return 2
    since = datetime.strptime(args.since, "%Y-%m-%d").date()
    until = datetime.strptime(args.until, "%Y-%m-%d").date() if args.until else None
    result = scan_and_record(conn, args.ministry, since, until)
    print(f"[{args.ministry}] {result['date_from']}..{result['date_to']}: "
          f"{len(result['gazette_ids_found'])} gazette(s) found (coverage_id={result['coverage_id']})")
    if result["possibly_truncated"]:
        print(f"WARNING: possibly-truncated months (hit the page cap): {result['possibly_truncated']}", file=sys.stderr)
    if result["failed_months"]:
        print(f"WARNING: months that failed after retries (not covered at all): {result['failed_months']}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
