# Gazette Trail

A citation index for Indian central-government gazette notifications: what a notification amends,
what amended it before, and what supersedes it next -- none of which is visible when you read a
single notification on its own. It extracts G.S.R./S.O./S.R.O. and CBIC `No. X/YYYY-Customs`
citations from official text, stores notifications and cross-references in SQLite, and renders a
compendium view, an LLM-ready JSONL corpus and per-language summaries. Piloted on CBIC customs
notifications, now covering 53 ministries.

> Status: active. Every row traces to quoted primary-source text; the index is a research aid, not
> legal advice -- always confirm against the official gazette (egazette.gov.in). No licence file yet --
> all rights reserved.

New to the repo? See [How to use this repo with AI](HOW_TO_USE_WITH_AI.md).

## What it does
- Fetches official gazette PDFs from egazette.gov.in by gazette ID and extracts text (`ingest/`).
- Finds citations and relation phrases ("in supersession of", "further amend", Note chains) with
  ministry-specific and shared drafting-template matchers (`extract/`).
- Stores notifications and cross-references with per-row provenance (`verified_by`) in SQLite (`db/`).
- Renders a notification's lineage as an HTML fragment and exports the whole graph as JSONL (`render/`).
- Checks modeled ministries for newer notifications than the database holds (`ingest/freshness_check.py`).
- Translates the index's own summaries into 22 Eighth Schedule languages plus a foreign tier (`render/translate.py`).

## Quick start
```bash
git clone https://github.com/herrrickshaw/gazette-translated-indexed.git
cd gazette-translated-indexed
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
sqlite3 gazette.db < db/schema.sql
for f in db/seed_*.sql; do sqlite3 gazette.db < "$f"; done
sqlite3 gazette.db "PRAGMA foreign_key_check;"   # should print nothing
python3 -m render.pages --db gazette.db --notification "45/2025-Customs" > out.html
```

## How it works
| Stage | Module | Output |
|---|---|---|
| fetch PDF by ID | `ingest/egazette.py`, `ingest/egazette_search.py` | cached PDF (gitignored `data/raw/`) |
| PDF to text (OCR opt-in) | `ingest/pdf_text.py`, `ingest/ocr_fallback.py` | `data/raw_md/<id>.md` |
| citation regexes | `extract/citation_patterns.py` | `Citation` / `GazetteCitation` |
| relation phrases (CBIC) | `extract/cross_ref.py` | candidate links for review |
| shared drafting templates | `extract/common_templates.py` | `TemplateLink` lists |
| per-ministry matchers | `extract/*_patterns.py` | target citations per notification |
| seed data | `db/seed_<ministry>.sql` | `gazette.db` |
| all reads/writes | `db/crud.py` | notifications, cross-references, lineage |
| review of suggestions | `verify/review_queue.py` | queue of unverified candidates |
| output | `render/pages.py`, `render/llm_export.py` | HTML, `data/exports/llm_corpus.jsonl` |

Run each stage as `python3 -m <module>`. Common commands:
```bash
python3 -m ingest.egazette CG-DL-E-03092026-275956 --extract        # fetch + transcript
python3 -m ingest.pdf_text data/raw/some.pdf > data/raw_md/some.md   # local PDF
python3 -m ingest.parse_manifest data/manifest/collected_ids.csv --pdf-dir "$PDF_DIR" \
    --report data/manifest/parse_report.md --update-db gazette.db   # bulk check vs official PDFs
python3 -m verify.review_queue --db gazette.db                       # review auto-suggested links
python3 -m render.llm_export --db gazette.db > data/exports/llm_corpus.jsonl   # see docs/LLM_CORPUS.md
python3 -m ingest.freshness_check --db gazette.db --extract          # never writes to the db
```
All reads/writes to `gazette_notification` and `cross_reference` go through `db/crud.py`, not raw SQL. It
never stores PDF bytes (only `pdf_url`) and has two delete modes: `archive_*`/`restore_*` (soft) and
`hard_delete_*` (refuses while cross-references point at the row, unless `cascade=True`).

OCR is opt-in and only used for scanned PDFs, through the existing `~/ocr` Unlimited-OCR client
(`ingest/ocr_fallback.py`); it needs `UNLIMITED_OCR_URL` pointing at a running endpoint. When that is down,
ingestion marks the document `needs_ocr` instead of failing.

### How extraction works
Real gazette drafting follows a few recurring sentence shapes. Five shared templates live in
`extract/common_templates.py`, each written only after two or more independent ministries confirmed it:

- **amendment-in-notification** -- "hereby makes the following [further] amendment[s] in the notification ... Ministry of X ... vide number <citation>"
- **corrigendum-substitution** -- "In the notification ... Ministry of X ... number <citation> ... for [old] read [new]"
- **supersession-preamble** -- "in supersession of ... vide number <citation> ... except as respects things done"; not anchored on a ministry name, since the superseded notification is often another ministry's
- **bare-citation-reference** -- "vide notification number X" with no ministry anchor; tight 60-character window
- **note-chain** -- a trailing "Note[:.-]" (also "Footnote:") clause listing an instrument's amendment history

A ministry whose text fits none gets its own module (e.g. `extract/railways_patterns.py`, where the citation
precedes the ministry name). The docstring of `extract/common_templates.py` holds the evidence trail.

## Reading it in another language
`render/translate.py` translates one notification's *data* (ministry, instrument, thread summary, generated
summary sentence) -- not its legal text, which the government publishes (often bilingually; tracked by the
`primary-source-egazette-hindi-column` tier of `verified_by`). Numbers, dates and gazette IDs are never touched;
English originals stay as `<field>_en`.
```bash
python3 -m render.translate cus-45-2025 --lang hi --db gazette.db
python3 -m render.translate cus-45-2025 --lang-name Swahili --db gazette.db
python3 -m render.translate --list-languages
```
Coverage: all 22 Eighth Schedule languages, a foreign tier (French, Spanish, Arabic, Chinese, Russian, Portuguese,
German, Japanese, Sinhala, Burmese, Tibetan), or any language via `--lang-name`.

**Sample translation** -- No. 45/2025-Customs's generated summary, live
  output from six of the twenty-two languages:

  | Language | Translation |
  |---|---|
  | English (source) | Customs 45/2025 (G.S.R. 781(E), 2025-10-24) supersedes 31 notifications; amended by 6 notifications; corrigendum issued by 2 notifications; cited by 1 notification. |
  | Telugu | కస్టమ్స్ 45/2025 (G.S.R. 781(E), 2025-10-24) 31 నోటిఫికేషన్‌లను అధిగమిస్తుంది; 6 నోటిఫికేషన్‌ల ద్వారా సవరించబడింది; 2 నోటిఫికేషన్‌ల ద్వారా కొరిజెండమ్ జారీ చేయబడింది; 1 నోటిఫికేషన్ ద్వారా ప్రస్తావించబడింది. |
  | Punjabi | ਕਸਟਮਜ਼ 45/2025 (ਜੀ.ਐੱਸ.ਆਰ. 781(ਈ), 2025-10-24) 31 ਨੋਟੀਫਿਕੇਸ਼ਨਾਂ ਦੀ ਥਾਂ ਲੈਂਦਾ ਹੈ; 6 ਨੋਟੀਫਿਕੇਸ਼ਨਾਂ ਦੁਆਰਾ ਸੋਧਿਆ ਗਿਆ; 2 ਨੋਟੀਫਿਕੇਸ਼ਨਾਂ ਦੁਆਰਾ ਸ਼ੁੱਧੀ-ਪੱਤਰ ਜਾਰੀ ਕੀਤਾ ਗਿਆ; 1 ਨੋਟੀਫਿਕੇਸ਼ਨ ਦੁਆਰਾ ਹਵਾਲਾ ਦਿੱਤਾ ਗਿਆ। |
  | Kannada | ಕಸ್ಟಮ್ಸ್ 45/2025 (G.S.R. 781(E), 2025-10-24) 31 ಅಧಿಸೂಚನೆಗಳನ್ನು ಅತಿಕ್ರಮಿಸುತ್ತದೆ; 6 ಅಧಿಸೂಚನೆಗಳಿಂದ ತಿದ್ದುಪಡಿ ಮಾಡಲಾಗಿದೆ; 2 ಅಧಿಸೂಚನೆಗಳಿಂದ ಶುದ್ಧಿಪತ್ರ ಹೊರಡಿಸಲಾಗಿದೆ; 1 ಅಧಿಸೂಚನೆಯಲ್ಲಿ ಉಲ್ಲೇಖಿಸಲಾಗಿದೆ. |
  | Urdu | کسٹمز 45/2025 (G.S.R. 781(E)، 2025-10-24) 31 نوٹیفکیشنز کو منسوخ کرتا ہے؛ 6 نوٹیفکیشنز کے ذریعے ترمیم شدہ؛ 2 نوٹیفکیشنز کے ذریعے تصحیح نامہ جاری کیا گیا؛ 1 نوٹیفکیشن میں اس کا حوالہ دیا گیا۔ |
  | Tamil | சுங்கம் 45/2025 (G.S.R. 781(E), 2025-10-24) 31 அறிவிக்கைகளை ரத்து செய்து மாற்றீடு செய்கிறது; 6 அறிவிக்கைகளால் திருத்தப்பட்டுள்ளது; 2 அறிவிக்கைகள் மூலம் பிழைதிருத்தம் வெளியிடப்பட்டுள்ளது; 1 அறிவிக்கையில் மேற்கோள் காட்டப்பட்டுள்ளது. |
  | Marathi | सीमा शुल्क ४५/२०२५ (जी.एस.आर. ७८१(ई), २०२५-१०-२४) हे ३१ अधिसूचनांचे अधिक्रमण करते; ६ अधिसूचनांद्वारे सुधारित; २ अधिसूचनांद्वारे शुद्धिपत्रक जारी; १ अधिसूचनेत उद्धृत. |

  (Live output, one Gemini call per row -- not hand-translated. Regenerate with
  `python3 -m render.translate cus-45-2025 --lang <code> --db gazette.db`.)

Backends: Gemini by default (`GEMINI_API_KEY`; free-tier quota 20 requests/day per model), and two self-hosted
backends with no quota for bulk work -- together translating the whole summary corpus into 18 languages:
`--backend krutrim` (Hindi, Bengali, Marathi, Telugu, Tamil, Gujarati, Kannada, Malayalam, Punjabi; Krutrim
Community License, attribution required; CTranslate2 on CPU) and `--backend libretranslate` (AGPL; Urdu plus
French, Spanish, Arabic, Chinese, Russian, Portuguese, German, Japanese). AI4Bharat/IndicTrans2 via
`transformers` was tried first and abandoned as incompatible (see the `render/translate.py` docstring and
`notebooks/serve_indictrans2_colab.ipynb`). The other 12 Eighth Schedule languages are reachable only through
Gemini's per-record path. NLLB-200 is CC-BY-NC-4.0 and deliberately not adopted. `render/pages.py
--translate-widget` instead adds Google's page-translate widget to a rendered page (off by default).

## Repository layout
| Path | Purpose |
|---|---|
| `ingest/` | fetch, search, text extraction, manifest parsing, freshness check, credential lookup |
| `extract/` | citation regexes, shared templates, one `*_patterns.py` per ministry |
| `db/` | `schema.sql`, `seed_<ministry>.sql` (53), `crud.py`, ministry/slug maps |
| `render/` | HTML pages, JSONL export, translation (`translate`, `bulk_translate`, `query_translation`, `load_translations`) |
| `verify/` | review queue for suggested cross-references |
| `data/` | `manifest/` (tracked ID list + parse report), `raw_md/` (tracked transcripts); `raw/`, `exports/`, `translations/` are gitignored |
| `docs/` | coverage plans, data pipeline, LLM corpus schema |
| `tests/` | pytest suite, one file per template/ministry module plus golden extraction baseline |

## Data sources
| Source | What is taken | Access route | Licence / caveat |
|---|---|---|---|
| egazette.gov.in | official gazette PDFs | direct `WriteReadData/<year>/<file-id>.pdf` URL, via `curl` (Python `ssl` cannot verify its chain; TLS verification is never disabled) | public government documents; fetch politely, no documented rate limit |
| gazettetracker.com | listings used by `freshness_check` | HTTP | third-party aggregator; an aggregator ID once served the wrong content (see `data/manifest/collected_ids.csv` notes) |

## Configuration
`GEMINI_API_KEY`, `LIBRETRANSLATE_URL` (default `http://127.0.0.1:5001`), `KRUTRIM_URL` (default
`http://127.0.0.1:5002`), `MISTRAL_API_KEY`, `MISTRAL_COLAB_URL`, `UNLIMITED_OCR_URL` are read from the
environment, then from `~/.config/market-secrets/credentials.env` (`ingest/credentials.py`). All are optional,
and none is ever committed.

## Testing
```bash
pip install pytest ruff
pytest -q        # offline: no test contacts egazette.gov.in or any translation service
ruff check .
```
`tests/test_golden_extraction.py` compares every extractor's output on synthetic text with a stored baseline.

## Limitations and known issues
- Every citation traces to quoted primary-source text; a genuinely incomplete chain stays incomplete, with the
  gap noted in that seed file's header, never bridged.
- `cross_reference.verified_by` is never smoothed: `primary-source-*` tiers rank above `research-agent-quoted`.
- Citation forms the schema does not represent (bare file numbers, Act/Regulation numbers) are documented as
  unmodeled in the ministry's seed file, not forced through a mismatched pattern.
- `docs/MINISTRY_COVERAGE_PLAN.md` lists 3 abandoned ministries and why; `docs/DEPTH_PASS_PLAN.md` the depth pass.
- `SearchPublishDate.aspx` returns at most 15 rows per page and pagination failed server-side, so
  `search_by_publish_date()` is a single-page spot-check; use `search_by_ministry_since()` for coverage.
- Seeding every `db/seed_*.sql` currently yields 2,637 notifications and 2,150 cross-references across 53
  ministries (earlier README figures of 2,591 / 2,113 were out of date).
- The six-language sample above is live Gemini output; verify before relying on any translation.

## Related repositories
None required. `CLAUDE.md` documents the shared source-fetching rules used when collecting primary documents.

## Licence
No licence file yet -- all rights reserved.
