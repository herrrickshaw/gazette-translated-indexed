"""
Register a bare gazette_notification row for every genuinely new
notification a freshness check turns up -- decoupled from modeling what
it cites (docs/DATA_PIPELINE.md's Gap 2: "a new notification's existence
and its citation graph are currently one undifferentiated step").

    python3 -m ingest.register_new --db gazette.db --ministry steel
    python3 -m ingest.register_new --db gazette.db                     # every mapped ministry

Design:

- Runs ingest.freshness_check.check_ministry() per ministry (the same
  tracker + official-source diff freshness_check.py's own CLI reports),
  then attempts to register every item not already in the database. This
  never writes a cross_reference row -- registering "this notification
  exists" is a smaller, safer act than modeling what it cites, and stays
  that way on purpose (see ingest/freshness_check.py's module docstring).

- **gazette_id**: the OFFICIAL egazette.gov.in id (e.g.
  "CG-DL-E-05092026-276018"), not a hand-picked human slug like this
  project's existing seed files use ("steel-so-3716-2024"). A human slug
  requires a person to decide it, and this script never invents identity
  information it doesn't have. A later depth pass that goes on to model
  this notification's citations should enrich this SAME row via
  db/crud.py's update_notification() -- not create a second,
  differently-keyed row for the same real-world notification.

- **series/number/gsr_or_so/numbering_form/year**: derived mechanically,
  never guessed. The official PDF is fetched (ingest.egazette) and its
  text extracted (ingest.pdf_text); its own G.S.R./S.O./S.R.O.
  self-citation is taken as the first match
  extract.citation_patterns.find_gazette_citations() finds -- the same
  convention ingest/parse_manifest.py's self_citation check already
  relies on elsewhere in this project. `series` is filled from whichever
  single series label this ministry's already-modeled data uses
  consistently; `numbering_form` is always 'so-only' for this path (the
  established convention this project already uses for every ministry
  outside CBIC: `number` IS the G.S.R./S.O./S.R.O. citation, not a
  separate internal series/number scheme).

- **finance-revenue-cbic (CBIC) is refused outright.** Its "No.
  X/YYYY-Customs" numbering is a real internal citation distinct from its
  gazette number, and this script has no ministry-specific extractor to
  derive it -- see extract/citation_patterns.py.

- **A ministry whose modeled data uses more than one series label is
  refused too** (chemicals-and-fertilizers, commerce-and-industry,
  health-family-welfare, railways, road-transport-highways as of this
  writing -- see extract/citation_patterns.py's own multi-series
  ministries) -- pass --series explicitly to resolve which sub-body's
  label applies to a specific run, rather than guessing.

- **A notification this script cannot confidently populate is skipped,
  not half-registered.** A scanned PDF (LikelyScannedError), a fetch
  failure, or text with no findable self-citation are all reported with
  a specific status rather than creating a row with an invented `number`
  (a NOT NULL column) -- "report honestly rather than force it," the
  same discipline every other module in this project already follows.
"""
from __future__ import annotations

import argparse
import sqlite3
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from db.crud import NotificationFields, create_notification, get_notification  # noqa: E402
from db.tracker_slugs import MINISTRY_TRACKER_SLUGS  # noqa: E402
from extract.citation_patterns import find_gazette_citations  # noqa: E402
from ingest.egazette import fetch, gazette_id_to_pdf_url  # noqa: E402
from ingest.freshness_check import check_ministry  # noqa: E402
from ingest.pdf_text import LikelyScannedError, extract_text  # noqa: E402

CBIC_MINISTRY_ID = "finance-revenue-cbic"


def series_for_ministry(conn: sqlite3.Connection, ministry_id: str) -> str:
    """The single series label this ministry's already-modeled data uses,
    or raises ValueError if there's none yet or more than one (ambiguous
    -- caller must pass series explicitly rather than guess)."""
    rows = conn.execute(
        "SELECT DISTINCT series FROM gazette_notification WHERE ministry_id = ?", (ministry_id,)
    ).fetchall()
    values = {r[0] for r in rows}
    if not values:
        raise ValueError(f"no existing series value for ministry_id={ministry_id!r}; pass series explicitly")
    if len(values) > 1:
        raise ValueError(f"ambiguous series for ministry_id={ministry_id!r}: {sorted(values)}; pass series explicitly")
    return values.pop()


def register_item(conn: sqlite3.Connection, item: dict, ministry_id: str, series: str | None = None) -> dict:
    """item: a freshness_check.check_ministry() new_items entry --
    {'gazette_id', 'date' (ISO string), 'url', ...}. Returns
    {'gazette_id', 'status'}; status is 'registered', 'already_registered',
    or a 'skipped_<reason>' -- never raises for an ordinary "couldn't
    derive this one" case."""
    gazette_id = item["gazette_id"]
    if get_notification(conn, gazette_id) is not None:
        return {"gazette_id": gazette_id, "status": "already_registered"}
    if ministry_id == CBIC_MINISTRY_ID:
        return {"gazette_id": gazette_id, "status": "skipped_cbic_numbering_not_derivable"}

    try:
        resolved_series = series or series_for_ministry(conn, ministry_id)
    except ValueError as e:
        return {"gazette_id": gazette_id, "status": f"skipped_ambiguous_series: {e}"}

    try:
        pdf_path = fetch(gazette_id)
        text = extract_text(pdf_path)
    except LikelyScannedError:
        return {"gazette_id": gazette_id, "status": "skipped_needs_ocr"}
    except Exception as e:  # noqa: BLE001 -- network/PDF failures are reported, not fatal to the batch
        return {"gazette_id": gazette_id, "status": f"skipped_fetch_failed: {e}"}

    citations = find_gazette_citations(text)
    if not citations:
        return {"gazette_id": gazette_id, "status": "skipped_no_self_citation_found"}
    number = citations[0].normalized

    publish_date = item["date"]
    year = int(publish_date[:4])
    fields = NotificationFields(
        year=year, gsr_or_so=number, ministry_id=ministry_id, pdf_url=gazette_id_to_pdf_url(gazette_id),
    )
    create_notification(conn, gazette_id, resolved_series, number, publish_date, "so-only", fields)
    return {"gazette_id": gazette_id, "status": "registered"}


def register_for_ministry(conn: sqlite3.Connection, ministry_id: str, series: str | None = None) -> list[dict]:
    result = check_ministry(conn, ministry_id, do_extract=False)
    if result["status"] != "ok":
        return [{"gazette_id": None, "status": f"freshness_check_failed: {result['status']}"}]
    return [register_item(conn, item, ministry_id, series) for item in result["new_items"]]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--db", default="gazette.db")
    parser.add_argument("--ministry", default=None, help="ministry_id to register for (default: all mapped ministries)")
    parser.add_argument("--series", default=None, help="override the auto-detected series label (required for ambiguous ministries)")
    args = parser.parse_args()

    conn = sqlite3.connect(args.db)
    conn.execute("PRAGMA foreign_keys = ON")
    ministry_ids = [args.ministry] if args.ministry else sorted(MINISTRY_TRACKER_SLUGS.keys())

    counts: dict[str, int] = {}
    for mid in ministry_ids:
        for outcome in register_for_ministry(conn, mid, args.series):
            counts[outcome["status"]] = counts.get(outcome["status"], 0) + 1
            if outcome["status"] not in ("already_registered",):
                print(f"[{mid}] {outcome['gazette_id']}: {outcome['status']}")
    conn.commit()
    conn.close()

    print("\nSummary:", file=sys.stderr)
    for status, n in sorted(counts.items()):
        print(f"  {status}: {n}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
