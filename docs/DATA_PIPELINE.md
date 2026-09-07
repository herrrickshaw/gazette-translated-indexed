# Data pipeline: integration, extraction, and staying current

Every script that touches this project's data already exists — `ingest/`,
`extract/`, `verify/`, `render/`. What doesn't exist is a single model
connecting them end to end, and a way to notice a new gazette notification
without a person deciding to go look. This document maps what's here today,
names the real gaps, and proposes a model that closes them without breaking
the one rule the rest of this project enforces everywhere: **machines
propose, people confirm.** Nothing below automates a cross-reference into
existence without a human reading the primary text first.

## Current state: six stages, five of them scriptable, one that must stay human

| Stage | What runs today | Automated? |
|---|---|---|
| 1. Freshness detection | `ingest/freshness_check.py` — per-ministry high-water mark (`MAX(publish_date)` in the DB) vs. gazettetracker.com's listing page for that ministry's slug | Scriptable, but must be run by hand — no scheduler calls it |
| 2. Fetch official source | `ingest/egazette.py` — deterministic `egazette.gov.in/WriteReadData/<year>/<id>.pdf` URL, cached, curl-fallback for the TLS chain issue | Scriptable |
| 3. Extract text | `ingest/pdf_text.py` (PyMuPDF) → `data/raw_md/<id>.md`; `ingest/ocr_fallback.py` flags (never blocks on) scanned PDFs via the Colab OCR endpoint | Scriptable |
| 4. Candidate cross-references | `extract/<ministry>_patterns.py` (37 ministry-specific modules) or generic `extract/citation_patterns.py`, or `ingest/mistral_extract.py` for a first LLM pass on new/unmodeled text | Scriptable — produces *candidates only* |
| 5. Human verification | `verify/review_queue.py` — accept/reject per candidate; nothing reaches `cross_reference` unverified | **Must stay human** |
| 6. Publish / re-derive | `render/llm_export.py` (JSONL corpus), `render/bulk_translate.py` + `render/load_translations.py` (translated summaries), `render/pages.py` (HTML) | Scriptable, checkpointed |

Stages 2–4 and 6 are each individually automatable — none of them decide
what's true, they just fetch, transcribe, or propose. Stage 5 is the one
place a decision about the historical record gets made, and every design
doc in this repo (`MINISTRY_COVERAGE_PLAN.md`, `DEPTH_PASS_PLAN.md`,
`ingest/mistral_extract.py`'s own docstring) draws that line deliberately.
A pipeline model has to make stages 2–4 and 6 run without asking, and make
stage 5 easier to keep up with — never skip it.

## Three real gaps, not hypothetical ones

**Gap 1 — freshness detection depends on one third-party aggregator.**
**RESOLVED** — `ingest/egazette_search.py` now exists. `freshness_check.py`
only ever asks gazettetracker.com. That's a reasonable choice for
session-to-session convenience (already-parseable HTML, per-ministry
pages, not rate-limited per this project's own findings) but it's a
single point of failure for "did anything new get published" — if the
tracker's markup changes or it misses an item, this project never finds
out. The official source has an equivalent, live and verified: this
project's own `sushant354/egazette` research (surfaced while looking for
prior art) pointed at `egazette.gov.in`'s ASP.NET WebForms search, but the
actual working shape, reverse-engineered and confirmed live, turned out
to be "Search by Ministry" (`SearchMinistry.aspx`, month/year granularity,
a 607-option `ddlMinistry` dropdown scraped live rather than hardcoded)
and "Search by Publish Date" (`SearchPublishDate.aspx`, a from/to date
range across all ministries) — both a 3-request stateful POST flow (GET
the menu → POST to pick the search mode → POST the actual query), reached
via `SearchMenu.aspx`'s several distinct submit buttons rather than one
generic `SearchCategory.aspx` form. A real limitation was hit and
documented rather than worked around blindly: `SearchPublishDate.aspx`'s
15-row-per-page GridView pagination 500s on every postback variant tried,
so `search_by_publish_date()` is a single-page spot-check only.
`search_by_ministry_since()` avoids the problem entirely by querying one
ministry, one month at a time — comfortably under the 15-row cap for any
already-modeled ministry — and is the function a real freshness-check
integration should use. This is a **second, authoritative freshness
source**, not a replacement: gazettetracker.com is faster to parse and already
working, egazette.gov.in is authoritative but slower to query. Running
both and diffing the two result sets turns "the tracker might have missed
something" from an unfalsifiable worry into a checkable fact.

**Gap 2 — a new notification's existence and its citations are one
undifferentiated step.** Today, a notification only enters `gazette.db`
as part of modeling its cross-references (a `db/seed_<ministry>.sql`
row). But `db/crud.py`'s `create_notification()` already supports
registering a bare row — `gazette_id`, `series`, `number`,
`publish_date`, `gsr_or_so`, `pdf_url`, with `ministry_id` and every
citation-graph field left `NULL` — independent of whether anyone has
found what it cites yet. There's no reason "we know this notification
exists" has to wait for "we've verified what it amends." Splitting these
means freshness detection can register every new item immediately
(cheap, mechanical, no judgment call) while cross-reference modeling
proceeds at its own human-reviewed pace, exactly as it does today.

**Gap 3 — nothing connects a database change to the export/translation
layer.** `render/llm_export.py`, `render/bulk_translate.py`, and
`render/load_translations.py` are each independently re-runnable and
each checkpointed (bulk_translate.py already skips any `gazette_id`
already present in its output file), but nothing *tells* a person to
re-run them after a seed-file update or a `verify.review_queue` session.
A newly-verified notification can sit with no English export line and no
translated summary for an arbitrary amount of time, purely because
re-running three commands isn't anyone's job. The checkpointing that
makes this cheap already exists — what's missing is the trigger.

## Proposed model

```
                    ┌─────────────────────────────────────────┐
                    │  Stage 1: Freshness (read-only, safe     │
                    │  to run unattended)                      │
                    │                                           │
                    │  gazettetracker.com per-ministry listing  │
                    │  egazette.gov.in SearchCategory.aspx      │
                    │  (by ministry + date range)                │
                    │                                           │
                    │  -> diff both against MAX(publish_date)   │
                    │     already in gazette_notification        │
                    │  -> flag items in one source but not the  │
                    │     other (tracker-staleness signal)       │
                    └───────────────────┬───────────────────────┘
                                         │ new gazette_ids
                                         v
                    ┌─────────────────────────────────────────┐
                    │  Stage 2: Register (mechanical, safe)     │
                    │                                           │
                    │  create_notification() bare row per new   │
                    │  id -- series/number/date/gsr_or_so/      │
                    │  pdf_url only, ministry_id/instrument_id/ │
                    │  thread_id left NULL                       │
                    └───────────────────┬───────────────────────┘
                                         │
                                         v
                    ┌─────────────────────────────────────────┐
                    │  Stage 3: Fetch + extract (mechanical)     │
                    │                                           │
                    │  ingest.egazette (PDF) -> ingest.pdf_text  │
                    │  (.md, OCR-flagged not blocked)            │
                    └───────────────────┬───────────────────────┘
                                         │
                                         v
                    ┌─────────────────────────────────────────┐
                    │  Stage 4: Candidates (mechanical,          │
                    │  proposes only)                            │
                    │                                           │
                    │  extract/<ministry>_patterns.py, or        │
                    │  citation_patterns.py generic fallback,    │
                    │  or ingest.mistral_extract for a first     │
                    │  LLM pass -- writes UNVERIFIED              │
                    │  cross_reference rows only                 │
                    └───────────────────┬───────────────────────┘
                                         │
                                         v
                    ┌─────────────────────────────────────────┐
                    │  Stage 5: HUMAN REVIEW -- never automated │
                    │                                           │
                    │  verify.review_queue: accept / reject /   │
                    │  skip, same as today                       │
                    └───────────────────┬───────────────────────┘
                                         │ verified rows land
                                         v
                    ┌─────────────────────────────────────────┐
                    │  Stage 6: Refresh export + translations   │
                    │  (mechanical, incremental)                 │
                    │                                           │
                    │  llm_export -> bulk_translate (skips       │
                    │  already-done ids) -> load_translations    │
                    └─────────────────────────────────────────┘
```

### What changes, concretely

1. **`ingest/freshness_check.py` grows a second source — DONE.**
   `ingest/egazette_search.py` provides `list_ministries()` (the live
   607-option dropdown), `search_by_ministry_since(ministry_value, since,
   until)` (one ministry across a date range, month-by-month under the
   hood, deduped, flagging any month that hit the 15-row page cap), and
   `search_by_publish_date()` (an all-ministries single-page spot-check).
   `db/egazette_ministry_map.py` maps 52 of this project's 53 modeled
   `ministry_id`s to their `ddlMinistry` value by exact name match
   (whitespace-normalized — the live dropdown has at least one entry with
   a doubled space); the one exception, `atomic-energy`, has no matching
   entry at all and is mapped to two related official names instead
   ("Ministry of Atomic Energy" and "PMO --> Department of Atomic
   Energy") — both queried and merged, documented in that file. Wired into
   `check_ministry()`: it now reports the real three-way diff this section
   originally proposed — items both sources agree are new (no label),
   items only the tracker has (`tracker_only` — expected, the tracker
   updates faster), and items only the official source has
   (`official_only` — the signal worth watching for). Verified live:
   Ministry of Power's check found 11 new items, 10 confirmed by both
   sources and 1 tracker-only; no `official_only` case has been observed
   yet, but the code path for it (and its report label) exists and is
   exercised by the "only tracker" branch's mirror image in
   `check_ministry()`. `--tracker-only` restores the original
   single-source behavior. One practical cost: a ministry whose
   high-water mark is old iterates one live query per month since then
   (confirmed: `atomic-energy`'s ~16-month-old mark took ~2 minutes across
   two dropdown values) — fine for a periodic job, worth knowing before
   running `--ministry` on a long-stale one interactively.

2. **A new `ingest/register_new.py`** (or a `--register` flag on
   `freshness_check.py`) calls `create_notification()` for every
   genuinely new `gazette_id` from Stage 1 — no ministry/instrument/thread
   linkage yet, just `pdf_url` set to `ingest.egazette.gazette_id_to_pdf_url()`
   so the row is immediately fetchable. This is the one new piece of
   write logic this model needs; everything else is orchestration of code
   that already exists.

3. **A thin orchestration entrypoint** (e.g. `pipeline_refresh.sh` or a
   `render/refresh.py`) that, after any `verify.review_queue` session or
   seed-file update, runs `llm_export` → `bulk_translate --langs
   <all 9>` → `load_translations` in sequence. Because `bulk_translate.py`
   already checkpoints by `gazette_id`, this is cheap to run after *every*
   verification session rather than on a fixed schedule — it only ever
   processes what's actually new.

4. **Scheduling stays split by risk.** Stage 1 (read-only network calls,
   writes nothing) is the only stage safe to put on an unattended
   schedule — a weekly `launchd` job matches the batch-oriented,
   human-paced cadence this project already uses for depth passes, rather
   than a daily job that would just accumulate an unreviewed backlog
   faster than anyone verifies it. Stage 2 (bare-row registration) is
   mechanical enough to run right after Stage 1 in the same job — it
   creates no citation-graph claims, only records that a notification
   exists. Stages 3–4 (fetch + candidate generation) are worth running
   on the same schedule too, since they also only produce proposals. Stage
   5 stays manual, triggered whenever a person sits down with
   `verify.review_queue`. Stage 6 runs right after Stage 5, not on a timer.
   **No scheduler gets installed as part of writing this document** —
   that's a standing-configuration change and should be a separate,
   explicit decision.

### What this model deliberately does not do

- It does not let Stage 4's candidates reach `cross_reference` without
  Stage 5. `ingest/mistral_extract.py` and every `extract/*_patterns.py`
  module already enforce this by construction (they return candidate
  dataclasses, never touch the database) — the new orchestration doesn't
  change that contract.
- It does not treat gazettetracker.com's coverage as ground truth, or
  egazette.gov.in's as a full replacement for it — both stay in the loop,
  precisely so a gap in one is visible against the other.
- It does not attempt "all ministries, all history" in one pass. Same
  discipline as `MINISTRY_COVERAGE_PLAN.md`: freshness detection runs
  per already-modeled ministry (using `db/tracker_slugs.py`'s existing
  `MINISTRY_TRACKER_SLUGS` mapping), not as a blind full-corpus crawl.

## Prior art: Querido Diário's architecture

[Querido Diário](https://github.com/okfn-brasil/querido-diario) (Open
Knowledge Brasil, MIT, 1,300+ stars, Digital Public Good-recognized) is
the most mature civic-tech gazette project found while researching
whether other countries have gazette-tracking gaps similar to this
project's own (see the cross-country research this session). It doesn't
do citation-chain tracking -- Brazil's ~5,570 municipalities each publish
independently, so its whole problem is closer to this project's `ingest/`
layer than to `extract/`'s citation graph -- but its architecture is a
useful reference precisely because that ingestion problem is harder than
India's: one central portal (egazette.gov.in) vs. thousands of
independent municipal publishers with no shared format. It's split into
separate repos by stage, each independently maintained:

- **`censo-querido-diario`** -- a crowdsourced *census*, run once, up
  front, before any scraping: where does each of ~5,570 municipalities
  actually publish its gazette? This is a step this project has never
  needed (egazette.gov.in is the one authoritative source for all 53
  modeled ministries), but it's exactly the missing piece the earlier
  cross-country research flagged for Nigeria, Pakistan, and
  Bangladesh -- countries with no confirmed single searchable portal --
  and for India's *state* gazettes specifically (`ramSeraph/indian_gazettes`
  scrapes state gazettes without, as far as could be determined, first
  mapping which of India's states publish where in a structured way).
- **`querido-diario`** -- the scrapers themselves (Scrapy, one spider per
  municipality), generated from a shared template
  (`scrapy genspider -t qdtemplate`) rather than written from scratch
  each time -- the same instinct behind this project's shared
  `extract/common_templates.py`, just applied to *fetching* instead of
  *citation extraction*.
- **`querido-diario-data-processing`** -- normalizes whatever closed
  format each municipality happens to publish in (PDF, proprietary CMS
  exports, etc.) into usable text, as its own separate stage rather than
  bolted onto the scraper -- roughly this project's `ingest/pdf_text.py`
  role, but built to handle far more format variety since there's no
  single publisher to standardize against.
- **`querido-diario-backend` / `querido-diario-api` / `querido-diario-frontend`**
  -- search index, public API, and UI as three separate repos -- a
  heavier separation than this project needs at its current scale
  (`render/pages.py` and `render/llm_export.py` cover the equivalent
  ground in one repo), but the boundary itself (index/store, API, UI)
  mirrors the current db/ + render/ split.
- **`querido-diario-toolbox`** -- a separate library specifically for
  *other people* to run their own analysis on the collected data, kept
  apart from the ingestion pipeline itself -- closest existing analog
  here is `render/llm_export.py`'s JSONL export, though that's one
  format rather than a toolbox.

Nothing here changes this project's current design -- India's single
authoritative portal makes the census step unnecessary today -- but the
census-before-scraping pattern is the concrete piece to reach for first
if this project (or a sibling one) ever takes on a source with no single
searchable index, exactly the situation the cross-country research found
for Nigeria, Pakistan, Bangladesh, and India's own state gazettes.

## Open follow-ups (not started)

- ~~Writing `ingest/register_new.py` (Gap 2)~~ -- done (2026-09-07): it
  registers a bare notification row for every genuinely new gazette_id a
  freshness check turns up, keyed by the official egazette.gov.in id, per
  the design above.
- Deciding on and installing an actual schedule (launchd, matching this
  environment's existing convention for other recurring jobs) — needs an
  explicit go-ahead before anything gets installed, since a standing
  scheduled job is persistent configuration.
