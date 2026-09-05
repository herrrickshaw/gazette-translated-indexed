"""
Export the citation graph as an LLM-ready JSONL corpus, one notification
per line, each record self-contained (ministry/instrument/thread context
plus one-hop lineage inlined) so a retriever or an LLM reading a single
line doesn't need a join to make sense of it.

    python3 -m render.llm_export --db gazette.db > data/llm_corpus.jsonl
    python3 -m render.llm_export --db gazette.db --ministry textiles > textiles.jsonl

Why this exists: the database (schema.sql + db/crud.py) is relational and
built for exact lookups and writes -- the right shape for the seed files
and the CLI pipeline, but not what a RAG system or an LLM doing citation
QA wants to read. This is a read-only projection, not a new source of
truth; nothing here is written back to the database.

Record shape:
{
  "gazette_id": "...", "series": "...", "number": "...", "year": 2025,
  "publish_date": "2025-10-24", "gsr_or_so": "G.S.R. 781(E)",
  "ministry": "Ministry of Finance", "instrument": "...", "thread": "...",
  "amends": [...], "amended_by": [...], "supersedes": [...], ... one key
    per relation_type actually present, each a list of
    {"gazette_id", "number", "publish_date", "gsr_or_so"},
  "summary": "No. 45/2025-Customs (G.S.R. 781(E), 2025-10-24) supersedes
    31 notifications; amended by 5 notifications; corrigendum issued by 2
    notifications." -- one plain-English sentence per relation direction,
    for keyword/semantic retrieval without re-deriving it from the lists.
}
"""
from __future__ import annotations

import argparse
import json
import sqlite3
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from db.crud import get_lineage  # noqa: E402

# points_at rows describe THIS node acting on the target: "amends" means
# this node amends the target. pointed_at_by rows describe the reverse: a
# relation_type of "amends" there means the source amends THIS node, i.e.
# this node was amended -- hence the "_by" suffix on every reverse key.
REVERSE_SUFFIX = "_by"

# forward phrasing is the relation_type verb as-is ("amends", "cites", ...);
# reverse phrasing needs its own past-participle form for a readable sentence
REVERSE_PHRASING = {
    "amends": "amended by", "supersedes": "superseded by", "corrigendum": "corrigendum issued by",
    "rescinds": "rescinded by", "repeals": "repealed by", "cites": "cited by",
}


def _peer_summary(conn: sqlite3.Connection, gazette_id: str) -> dict:
    row = conn.execute(
        "SELECT number, publish_date, gsr_or_so FROM gazette_notification WHERE gazette_id = ?",
        (gazette_id,),
    ).fetchone()
    return {"gazette_id": gazette_id, "number": row[0], "publish_date": row[1], "gsr_or_so": row[2]}


def build_record(conn: sqlite3.Connection, notif: dict) -> dict:
    lineage = get_lineage(conn, notif["gazette_id"])
    record = {
        "gazette_id": notif["gazette_id"],
        "series": notif["series"],
        "number": notif["number"],
        "year": notif["year"],
        "publish_date": notif["publish_date"],
        "gsr_or_so": notif["gsr_or_so"],
        "ministry": notif.get("ministry_name"),
        "instrument": notif.get("instrument_title"),
        "thread": notif.get("thread_summary"),
    }
    by_relation: dict[str, list[dict]] = {}
    for ref in lineage["points_at"]:
        key = ref["relation_type"]
        by_relation.setdefault(key, []).append(_peer_summary(conn, ref["target_gazette_id"]))
    for ref in lineage["pointed_at_by"]:
        key = ref["relation_type"] + REVERSE_SUFFIX
        by_relation.setdefault(key, []).append(_peer_summary(conn, ref["source_gazette_id"]))
    record.update(by_relation)

    label = f"{notif['series']} {notif['number']} ({notif['gsr_or_so'] or 'no G.S.R./S.O. confirmed'}, {notif['publish_date']})"
    clauses = []
    for key, vals in by_relation.items():
        phrase = REVERSE_PHRASING[key[: -len(REVERSE_SUFFIX)]] if key.endswith(REVERSE_SUFFIX) else key
        clauses.append(f"{phrase} {len(vals)} notification{'s' if len(vals) != 1 else ''}")
    record["summary"] = f"{label} " + ("; ".join(clauses) + "." if clauses else "has no recorded cross-references.")
    return record


def export(conn: sqlite3.Connection, ministry_id: str | None = None):
    conn.row_factory = sqlite3.Row
    query = """
        SELECT g.*, m.name AS ministry_name, a.title AS instrument_title, t.subject_summary AS thread_summary
        FROM gazette_notification g
        LEFT JOIN ministry m ON m.ministry_id = g.ministry_id
        LEFT JOIN act_or_rule a ON a.instrument_id = g.instrument_id
        LEFT JOIN subject_thread t ON t.thread_id = g.thread_id
        WHERE g.archived_at IS NULL
    """
    params = ()
    if ministry_id:
        query += " AND g.ministry_id = ?"
        params = (ministry_id,)
    query += " ORDER BY g.gazette_id"
    for row in conn.execute(query, params):
        yield build_record(conn, dict(row))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--db", default="gazette.db")
    parser.add_argument("--ministry", default=None, help="ministry_id to filter to (default: all)")
    args = parser.parse_args()

    conn = sqlite3.connect(args.db)
    conn.execute("PRAGMA foreign_keys = ON")
    count = 0
    for record in export(conn, ministry_id=args.ministry):
        print(json.dumps(record, ensure_ascii=False))
        count += 1
    print(f"{count} record(s) exported.", file=sys.stderr)


if __name__ == "__main__":
    main()
