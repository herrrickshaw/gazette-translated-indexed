# Gazette Trail

A citation index for Indian gazette notifications: what a notification amends,
what amended it before, and what it will be superseded by next — none of which
is visible when you read a single notification on its own.

Pilot scope: Ministry of Finance, Department of Revenue (CBIC) — Customs
notifications. See `../` conversation history for the four published demo
pages this pipeline now generates data for.

## Setup

```bash
python3 -m venv ~/.venvs/gazette-trail
source ~/.venvs/gazette-trail/bin/activate
pip install -r requirements.txt
```

## Pipeline

```bash
# 0. fetch the official PDF straight from egazette.gov.in by gazette ID
#    (deterministic URL: WriteReadData/<year>/<file-id>.pdf — no login, no aggregator;
#     --extract also writes the transcript to data/raw_md/<id>.md)
python3 -m ingest.egazette CG-DL-E-03092026-275956 --extract

# 1. or extract text from a PDF you already have
python3 -m ingest.pdf_text data/raw/some-notification.pdf > data/raw_md/some-notification.md

# 0b. bulk: fetch every ID in a manifest (one column of gazette IDs), then parse
#     the official PDFs against what the index claims and upgrade provenance on
#     evidence. data/manifest/collected_ids.csv is the first bounded run: every
#     ID discovered during the design sessions, PDFs kept outside the repo.
tail -n +2 data/manifest/collected_ids.csv | cut -d, -f1 \
  | xargs python3 -m ingest.egazette --out "$PDF_DIR"
python3 -m ingest.parse_manifest data/manifest/collected_ids.csv \
  --pdf-dir "$PDF_DIR" --report data/manifest/parse_report.md --update-db gazette.db

# 2. load the schema + verified seed data
sqlite3 gazette.db < db/schema.sql
sqlite3 gazette.db < db/seed_cbic.sql

# 2b. all reads/writes to gazette_notification and cross_reference go through
#     db/crud.py — not raw SQL. It never stores a PDF's bytes (pdf_url only,
#     since every gazette here is a public document, re-fetchable by ID) and
#     Delete has two real modes: archive_*/restore_* (soft — the row and
#     everything pointing at it stay valid, it just drops out of default
#     listings) and hard_delete_* (refuses if cross_reference rows still
#     reference it, unless cascade=True). See db/crud.py's own docstring.
python3 -c "
import sqlite3
from db.crud import list_notifications, get_lineage
conn = sqlite3.connect('gazette.db'); conn.execute('PRAGMA foreign_keys = ON')
for n in list_notifications(conn, ministry_id='power'):
    print(n['gsr_or_so'], n['publish_date'])
print(get_lineage(conn, 'power-so-5852-2022'))
"

# 3. run the extractor's test suite against the 31-entry gold-standard set
pytest tests/

# 4. review any newly auto-suggested cross-references
python3 -m verify.review_queue --db gazette.db

# 5. regenerate a page from the database
python3 -m render.pages --db gazette.db --notification "45/2025-Customs" > out.html
```

OCR is opt-in and only invoked for scanned (non-digital-native) PDFs, via the
existing `~/ocr` Unlimited-OCR client — see `ingest/ocr_fallback.py`. It
requires `UNLIMITED_OCR_URL` to point at a running endpoint (typically a
Colab GPU notebook); when that endpoint isn't up, ingestion marks the
document `needs_ocr` instead of failing.

## What's real vs. scaffolded

- The CBIC seed data (31 predecessor notifications, 45/2025-Customs,
  02/2026-Customs) is transcribed from primary-source notification text,
  verified during the design conversation — not synthetic.
- The extractor's regex patterns are written against, and tested against,
  those same 31 real entries.
- No other ministry has real ingestion code yet. Extending to a new ministry
  means writing and testing its own `extract/citation_patterns.py` rules —
  the patterns CBIC uses do not reliably transfer to other ministries'
  drafting conventions.
