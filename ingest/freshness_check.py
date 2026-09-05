"""
Check already-modeled ministries for gazette notifications newer than
what's in the database, and flag likely candidates for a depth-pass-style
follow-up -- this never writes to the database itself.

    python3 -m ingest.freshness_check --db gazette.db                    # all 53 ministries
    python3 -m ingest.freshness_check --db gazette.db --ministry steel   # one ministry
    python3 -m ingest.freshness_check --db gazette.db --extract          # also run each new
                                                                          # item through the
                                                                          # Mistral extractor

Design: for each ministry, take MAX(publish_date) already in the DB as a
high-water mark, fetch gazettetracker.com's listing page 1 for that
ministry (most-recent-first, not rate-limited per this project's own
findings), and report every item newer than the mark. With --extract,
each new item's Full Text is pulled (curl, never WebFetch -- this
project's token-efficiency policy) and run through
ingest.mistral_extract for a first-pass read: does it look like it cites
something already in this ministry's corpus?

This intentionally stops at a report, the same "candidate, not verifier"
line drawn everywhere else in this project (extract/cross_ref.py's regex
candidates, ingest/mistral_extract.py's model candidates): a human or a
Claude session decides what's real and writes the seed-file update, same
discipline as the depth-pass batches, just triggered incrementally
instead of by a scheduled full sweep. Output is a markdown report, not a
seed-file diff -- turning a flagged item into an actual modeled
cross-reference still means reading its primary text and quoting it,
exactly like every other row in this project.
"""
from __future__ import annotations

import argparse
import json
import re
import sqlite3
import subprocess
import sys
from dataclasses import dataclass
from datetime import date, datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from db.tracker_slugs import MINISTRY_TRACKER_SLUGS  # noqa: E402

BROWSE_ITEM_RE = re.compile(
    r'<time class="browse-item-date">([^<]+)</time>.*?'
    r'<a href="(https://gazettetracker\.com/g/([A-Za-z0-9-]+))">([^<]+)</a>',
    re.DOTALL,
)


@dataclass
class TrackerItem:
    gazette_id: str
    url: str
    title: str
    date: date


def _parse_tracker_date(raw: str) -> date:
    return datetime.strptime(raw.strip(), "%d %b %Y").date()


def fetch_listing(slug: str, page: int = 1, timeout: int = 20) -> list[TrackerItem]:
    """Fetch one gazettetracker.com listing page. curl, not WebFetch -- see module docstring."""
    url = f"https://gazettetracker.com/ministry/{slug}?page={page}"
    result = subprocess.run(["curl", "-s", "--max-time", str(timeout), url], capture_output=True, text=True)
    items = []
    for m in BROWSE_ITEM_RE.finditer(result.stdout):
        raw_date, item_url, gazette_id, title = m.groups()
        try:
            items.append(TrackerItem(gazette_id=gazette_id, url=item_url, title=title.strip(), date=_parse_tracker_date(raw_date)))
        except ValueError:
            continue  # unparseable date -- skip rather than guess
    return items


def high_water_mark(conn: sqlite3.Connection, ministry_id: str) -> date | None:
    row = conn.execute(
        "SELECT MAX(publish_date) FROM gazette_notification WHERE ministry_id = ? AND archived_at IS NULL",
        (ministry_id,),
    ).fetchone()
    if row is None or row[0] is None:
        return None
    return datetime.strptime(row[0], "%Y-%m-%d").date()


def fetch_fulltext(gazette_url: str, timeout: int = 20) -> str:
    """curl + trafilatura, per this project's extraction-before-reading policy."""
    result = subprocess.run(["curl", "-s", "--max-time", str(timeout), gazette_url], capture_output=True, text=True)
    trafilatura = subprocess.run(
        ["trafilatura"], input=result.stdout, capture_output=True, text=True, timeout=timeout
    )
    return trafilatura.stdout.strip()


def check_ministry(conn: sqlite3.Connection, ministry_id: str, do_extract: bool) -> dict:
    slug = MINISTRY_TRACKER_SLUGS.get(ministry_id)
    if not slug:
        return {"ministry_id": ministry_id, "status": "no_slug_mapped", "new_items": []}
    mark = high_water_mark(conn, ministry_id)
    if mark is None:
        return {"ministry_id": ministry_id, "status": "no_existing_data", "new_items": []}
    try:
        items = fetch_listing(slug)
    except Exception as e:
        return {"ministry_id": ministry_id, "status": f"fetch_failed: {e}", "new_items": []}
    new_items = [i for i in items if i.date > mark]
    result = {"ministry_id": ministry_id, "status": "ok", "high_water_mark": mark.isoformat(), "new_items": []}
    for item in new_items:
        entry = {"gazette_id": item.gazette_id, "title": item.title, "date": item.date.isoformat(), "url": item.url}
        if do_extract:
            try:
                from ingest.mistral_extract import extract_candidates

                text = fetch_fulltext(item.url)
                entry["candidates"] = extract_candidates(text) if text else []
            except Exception as e:
                entry["candidates_error"] = str(e)
        result["new_items"].append(entry)
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--db", default="gazette.db")
    parser.add_argument("--ministry", default=None, help="ministry_id to check (default: all mapped ministries)")
    parser.add_argument("--extract", action="store_true", help="also run each new item through the Mistral extractor")
    args = parser.parse_args()

    conn = sqlite3.connect(args.db)
    ministry_ids = [args.ministry] if args.ministry else sorted(MINISTRY_TRACKER_SLUGS.keys())

    total_new = 0
    print("# Freshness check\n")
    for mid in ministry_ids:
        result = check_ministry(conn, mid, args.extract)
        if result["status"] != "ok":
            print(f"- **{mid}**: {result['status']}")
            continue
        if not result["new_items"]:
            continue
        total_new += len(result["new_items"])
        print(f"## {mid} (high-water mark: {result['high_water_mark']})\n")
        for item in result["new_items"]:
            print(f"- [{item['date']}] {item['title']}\n  {item['url']}")
            if "candidates" in item and item["candidates"]:
                print(f"  candidates: {json.dumps(item['candidates'], ensure_ascii=False)}")
        print()
    print(f"\n{total_new} new item(s) found across {len(ministry_ids)} ministry(ies) checked.", file=sys.stderr)


if __name__ == "__main__":
    main()
