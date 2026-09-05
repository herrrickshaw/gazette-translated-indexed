# Gazette Trail

A citation index for Indian gazette notifications: what a notification amends,
what amended it before, and what it will be superseded by next — none of which
is visible when you read a single notification on its own.

**Scope:** 53 central Government of India ministries/departments modeled, plus
3 honestly abandoned (documented, not silently dropped — see
`docs/MINISTRY_COVERAGE_PLAN.md` for the full list and the reasoning behind
each abandonment). 2,591 notifications, 2,113 cross-references, 141 tests, all
built against real quoted primary-source text — no synthetic fixtures. See
`docs/MINISTRY_COVERAGE_PLAN.md` for how coverage was first built out batch by
batch, and `docs/DEPTH_PASS_PLAN.md` for the subsequent depth pass that took
every ministry from a bounded first coverage to substantially deeper linkage.

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

# 2. load the schema + every ministry's seed data (one file per ministry, db/seed_*.sql)
sqlite3 gazette.db < db/schema.sql
for f in db/seed_*.sql; do sqlite3 gazette.db < "$f"; done
sqlite3 gazette.db "PRAGMA foreign_key_check;"   # should print nothing

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

# 3. run the full test suite (141 tests, one file per template/ministry-module,
#    each built against real quoted notification text)
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

## How extraction works

Real Indian gazette drafting turns out to follow a small number of recurring
sentence shapes across ministries, once you've seen enough real examples. Five
shared templates live in `extract/common_templates.py`, each one written only
after 2+ independent ministries confirmed the same shape — never designed
speculatively from a single example:

- **amendment-in-notification** — "hereby makes the following amendment[s] in
  the notification ... Ministry of X ... vide number \<citation\>, dated ..."
- **corrigendum-substitution** — "In the notification ... Ministry of X ...
  number \<citation\> ... for [old] read [new]"
- **supersession-preamble** — "in supersession of the notification ... vide
  number \<citation\> ... except as respects things done or omitted to be done
  before such supersession" — does *not* anchor on a ministry name, since the
  superseded notification is often issued by a different ministry entirely
- **bare-citation-reference** — a citation with no ministry-name anchor at all
  ("vide notification number X", "In the Notification X") — a tight 60-char
  window since there's no ministry name to help narrow the scan
- **note-chain** — a trailing "Note[:.-]" (also "Footnote:") clause naming an
  instrument's own full amendment history, in order

A ministry whose real text doesn't fit any shared template gets its own
module instead (e.g. `extract/railways_patterns.py`, whose citation appears
*before* the ministry name rather than after) — see `extract/common_templates.py`'s
own docstring for the full evidence trail behind each template, and any
`extract/*_patterns.py` module for a ministry-specific shape.

## Data quality discipline

- Every citation traces to a real, quoted primary-source notification with a
  URL. Nothing is invented to complete a chain — a genuinely incomplete chain
  (a missing intermediate amendment) is left incomplete, with the gap
  documented in that seed file's header comment, rather than bridged.
- `cross_reference.verified_by` tracks provenance per row, never smoothed to
  look uniform: `primary-source-*` tiers (hand-verified or fetched directly
  from egazette.gov.in) rank above `research-agent-quoted` (a research agent
  found and quoted the real primary text via a third-party tracker).
- A citation form the schema/extractor doesn't yet represent (a bare
  notification/file number, an Act/Regulation number instead of a G.S.R./S.O.)
  is documented as deliberately unmodeled in that ministry's seed file, not
  silently dropped or forced through a mismatched pattern.
- `docs/MINISTRY_COVERAGE_PLAN.md` records which ministries were fully
  abandoned (checked and found to have nothing linkable) versus modeled, and
  why.
