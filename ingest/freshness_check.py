"""
Check already-modeled ministries for gazette notifications newer than
what's in the database, and flag likely candidates for a depth-pass-style
follow-up -- this never writes to the database itself.

    python3 -m ingest.freshness_check --db gazette.db                    # all 53 ministries
    python3 -m ingest.freshness_check --db gazette.db --ministry steel   # one ministry
    python3 -m ingest.freshness_check --db gazette.db --extract          # also run each new
                                                                          # item through the
                                                                          # Mistral extractor
    python3 -m ingest.freshness_check --db gazette.db --tracker-only     # skip the official-source query

Design: for each ministry, take MAX(publish_date) already in the DB as a
high-water mark, then query TWO independent sources for anything newer --
gazettetracker.com's listing page 1 for that ministry (most-recent-first,
not rate-limited per this project's own findings) via `fetch_listing()`,
and egazette.gov.in's own "Search by Ministry" via
`ingest.egazette_search.search_by_ministry_since()` (see
`db/egazette_ministry_map.py` for the ministry_id -> official dropdown
value mapping) via `fetch_official()`. `check_ministry()` reports a
three-way diff, not just a union: items **both** sources agree are new
(the common case -- most confidence), items **only the tracker** has
(expected sometimes -- the tracker updates faster than a from-scratch
official-site query), and items **only the official source** has --
the signal actually worth watching for, since it means the third-party
aggregator missed something this project would otherwise never notice.
`docs/DATA_PIPELINE.md`'s Gap 1 describes the reasoning behind running
both rather than trusting either alone. `--tracker-only` restores the
original single-source behavior (e.g. if egazette.gov.in is unreachable).

With --extract, each new item's Full Text is pulled (curl, never
WebFetch -- this project's token-efficiency policy; only tracker items
have a fetchable "Full Text" browser page today) and run through
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
from db.egazette_ministry_map import EGAZETTE_MINISTRY_VALUES  # noqa: E402
from ingest.egazette import gazette_id_to_pdf_url  # noqa: E402
from ingest.egazette_search import EGazetteSearchError, search_by_ministry_since  # noqa: E402

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


def fetch_official(
    ministry_id: str, since: date, until: date | None = None,
) -> tuple[list[TrackerItem], list[tuple[int, int]], list[tuple[int, int]]]:
    """Query egazette.gov.in directly for one ministry via
    `ingest.egazette_search.search_by_ministry_since()`, merging across
    every dropdown value `db/egazette_ministry_map.py` lists for this
    ministry_id (some ministries, e.g. atomic-energy, appear under more
    than one historical name). Returns results reshaped into the same
    `TrackerItem` shape `fetch_listing()` uses -- `url` is the deterministic
    official PDF URL (`ingest.egazette.gazette_id_to_pdf_url`), not a
    tracker page -- plus the list of (year, month) that hit the site's
    15-row page cap and may be incomplete, plus the list of (year, month)
    that failed outright after retries and were not searched at all (see
    `ingest.egazette_search.search_by_ministry_since`'s docstring for both)."""
    values = EGAZETTE_MINISTRY_VALUES.get(ministry_id)
    if not values:
        raise EGazetteSearchError(f'no egazette.gov.in ddlMinistry value mapped for {ministry_id!r}')
    by_id: dict[str, TrackerItem] = {}
    all_truncated: list[tuple[int, int]] = []
    all_failed: list[tuple[int, int]] = []
    for value in values:
        results, truncated, failed = search_by_ministry_since(value, since, until)
        all_truncated.extend(truncated)
        all_failed.extend(failed)
        for r in results:
            by_id[r.gazette_id] = TrackerItem(
                gazette_id=r.gazette_id,
                url=gazette_id_to_pdf_url(r.gazette_id),
                title=r.subject,
                date=r.publish_date,
            )
    return sorted(by_id.values(), key=lambda i: i.date), sorted(set(all_truncated)), sorted(set(all_failed))


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


def check_ministry(conn: sqlite3.Connection, ministry_id: str, do_extract: bool, tracker_only: bool = False) -> dict:
    slug = MINISTRY_TRACKER_SLUGS.get(ministry_id)
    if not slug:
        return {"ministry_id": ministry_id, "status": "no_slug_mapped", "new_items": []}
    mark = high_water_mark(conn, ministry_id)
    if mark is None:
        return {"ministry_id": ministry_id, "status": "no_existing_data", "new_items": []}

    try:
        tracker_items = fetch_listing(slug)
        tracker_new = {i.gazette_id: i for i in tracker_items if i.date > mark}
        tracker_status = "ok"
    except Exception as e:
        tracker_new = {}
        tracker_status = f"tracker_fetch_failed: {e}"

    official_new: dict[str, TrackerItem] = {}
    truncated_months: list[tuple[int, int]] = []
    failed_months: list[tuple[int, int]] = []
    official_status = "skipped"
    if not tracker_only:
        try:
            official_items, truncated_months, failed_months = fetch_official(ministry_id, mark)
            official_new = {i.gazette_id: i for i in official_items if i.date > mark}
            official_status = "ok"
        except Exception as e:
            official_status = f"official_fetch_failed: {e}"

    if tracker_status != "ok" and official_status not in ("ok", "skipped"):
        return {"ministry_id": ministry_id, "status": f"{tracker_status}; {official_status}", "new_items": []}

    both_ids = tracker_new.keys() & official_new.keys()
    only_tracker_ids = tracker_new.keys() - official_new.keys()
    only_official_ids = official_new.keys() - tracker_new.keys()
    merged = {**tracker_new, **official_new}  # official's url (a real PDF link) wins on overlap

    result = {
        "ministry_id": ministry_id, "status": "ok", "high_water_mark": mark.isoformat(),
        "tracker_status": tracker_status, "official_status": official_status,
        "truncated_months": truncated_months, "failed_months": failed_months, "new_items": [],
    }
    for gazette_id in sorted(merged, key=lambda g: merged[g].date):
        item = merged[gazette_id]
        source = "both" if gazette_id in both_ids else ("tracker_only" if gazette_id in only_tracker_ids else "official_only")
        entry = {"gazette_id": item.gazette_id, "title": item.title, "date": item.date.isoformat(),
                 "url": item.url, "source": source}
        if do_extract and gazette_id in tracker_new:  # only tracker items have a Full Text page to pull
            try:
                from ingest.mistral_extract import extract_candidates

                text = fetch_fulltext(tracker_new[gazette_id].url)
                entry["candidates"] = extract_candidates(text) if text else []
            except Exception as e:
                entry["candidates_error"] = str(e)
        result["new_items"].append(entry)
    return result


_SOURCE_LABEL = {"both": "", "tracker_only": " (tracker only)", "official_only": " (**official source only** -- tracker may have missed this)"}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--db", default="gazette.db")
    parser.add_argument("--ministry", default=None, help="ministry_id to check (default: all mapped ministries)")
    parser.add_argument("--extract", action="store_true", help="also run each new item through the Mistral extractor")
    parser.add_argument("--tracker-only", action="store_true",
                         help="skip the egazette.gov.in official-source query (original single-source behavior)")
    args = parser.parse_args()

    conn = sqlite3.connect(args.db)
    ministry_ids = [args.ministry] if args.ministry else sorted(MINISTRY_TRACKER_SLUGS.keys())

    total_new = 0
    total_official_only = 0
    print("# Freshness check\n")
    for mid in ministry_ids:
        result = check_ministry(conn, mid, args.extract, tracker_only=args.tracker_only)
        if result["status"] != "ok":
            print(f"- **{mid}**: {result['status']}")
            continue
        if result.get("official_status", "").startswith("official_fetch_failed"):
            print(f"- **{mid}**: {result['official_status']} (tracker-only result below)")
        if result.get("truncated_months"):
            print(f"- **{mid}**: possibly-truncated official-source months (hit the page cap): "
                  f"{result['truncated_months']}")
        if result.get("failed_months"):
            print(f"- **{mid}**: official-source months that failed after retries (not searched at all): "
                  f"{result['failed_months']}")
        if not result["new_items"]:
            continue
        total_new += len(result["new_items"])
        total_official_only += sum(1 for item in result["new_items"] if item["source"] == "official_only")
        print(f"## {mid} (high-water mark: {result['high_water_mark']})\n")
        for item in result["new_items"]:
            print(f"- [{item['date']}] {item['title']}{_SOURCE_LABEL[item['source']]}\n  {item['url']}")
            if "candidates" in item and item["candidates"]:
                print(f"  candidates: {json.dumps(item['candidates'], ensure_ascii=False)}")
        print()
    print(f"\n{total_new} new item(s) found across {len(ministry_ids)} ministry(ies) checked "
          f"({total_official_only} seen only by the official source).", file=sys.stderr)


if __name__ == "__main__":
    main()
