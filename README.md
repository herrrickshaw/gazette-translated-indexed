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

# 2. load the schema + verified seed data
sqlite3 gazette.db < db/schema.sql
sqlite3 gazette.db < db/seed_cbic.sql

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
