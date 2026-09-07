-- Gazette Trail schema. SQLite: relational, foreign-key-heavy, small writes
-- over time — the shape CROSS_REFERENCE needs (it points at two rows of the
-- same table), not the analytical/reference-table shape DuckDB is used for
-- elsewhere in this environment.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS ministry (
    ministry_id   TEXT PRIMARY KEY,   -- e.g. 'finance-revenue-cbic'
    name          TEXT NOT NULL,      -- e.g. 'Ministry of Finance'
    department    TEXT                -- e.g. 'Department of Revenue (CBIC)'
);

CREATE TABLE IF NOT EXISTS act_or_rule (
    instrument_id TEXT PRIMARY KEY,   -- e.g. 'customs-act-1962-s25-1'
    title         TEXT NOT NULL,
    year          INTEGER
);

CREATE TABLE IF NOT EXISTS subject_thread (
    thread_id        TEXT PRIMARY KEY,  -- e.g. 'customs-duty-exemptions'
    subject_summary  TEXT NOT NULL,
    status           TEXT NOT NULL DEFAULT 'active'  -- active | superseded
);

CREATE TABLE IF NOT EXISTS gazette_notification (
    gazette_id     TEXT PRIMARY KEY,     -- e.g. 'no-45-2025-customs'
    series         TEXT NOT NULL,        -- e.g. 'Customs', 'Central Tax'
    number         TEXT NOT NULL,        -- e.g. '45', '207/89'
    year           INTEGER,              -- NULL for bare pre-1994 numbers
    numbering_form TEXT NOT NULL,        -- 'bare' | '2-digit-year' | '4-digit-year'
    publish_date   TEXT NOT NULL,        -- ISO 'YYYY-MM-DD'
    gsr_or_so      TEXT,                 -- e.g. 'G.S.R. 98(E)' — NULL if unconfirmed
    subject        TEXT,
    ministry_id    TEXT REFERENCES ministry(ministry_id),
    instrument_id  TEXT REFERENCES act_or_rule(instrument_id),
    thread_id      TEXT REFERENCES subject_thread(thread_id),
    pdf_url        TEXT,
    ocr_status     TEXT NOT NULL DEFAULT 'not_needed',  -- not_needed | needs_ocr | ocr_done
    archived_at    TEXT                  -- ISO datetime; NULL = active. Soft delete: db/crud.py
                                          -- never stores the PDF itself here — pdf_url is the
                                          -- egazette.gov.in path, the bytes live outside the repo
                                          -- (and outside this table) because the source is public.
);

CREATE TABLE IF NOT EXISTS cross_reference (
    ref_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    source_gazette_id  TEXT NOT NULL REFERENCES gazette_notification(gazette_id),
    target_gazette_id  TEXT NOT NULL REFERENCES gazette_notification(gazette_id),
    relation_type      TEXT NOT NULL,   -- amends | supersedes | corrigendum | rescinds | repeals | cites
    verified_by        TEXT,            -- reviewer id/name, NULL until verified
    verified_at        TEXT,            -- ISO datetime, NULL until verified
    archived_at        TEXT,            -- ISO datetime; NULL = active. Soft delete: db/crud.py
    UNIQUE(source_gazette_id, target_gazette_id, relation_type)
);

CREATE INDEX IF NOT EXISTS idx_cross_ref_source ON cross_reference(source_gazette_id);
CREATE INDEX IF NOT EXISTS idx_cross_ref_target ON cross_reference(target_gazette_id);
CREATE INDEX IF NOT EXISTS idx_notification_thread ON gazette_notification(thread_id);

-- Cached translations of a notification's *generated* text (ministry name,
-- instrument title, thread summary, one-line summary -- see
-- render/llm_export.py's build_record) into another language. Never the
-- notification's own legal text -- see render/translate.py's module
-- docstring for why. One row per (gazette_id, lang); a NULL field means
-- that field hasn't been translated for that language yet (e.g. the bulk
-- job in render/bulk_translate.py only populates `summary`), not that the
-- language itself is unsupported for this notification. render/query_translation.py
-- is the read/fill path: it serves from this table first and translates
-- on demand (backend-permitting) to fill gaps, so a query gets faster and
-- more complete over time instead of re-translating from scratch each time.
CREATE TABLE IF NOT EXISTS notification_translation (
    gazette_id     TEXT NOT NULL REFERENCES gazette_notification(gazette_id),
    lang           TEXT NOT NULL,   -- code from render/translate.py's SUPPORTED_LANGUAGES
    ministry       TEXT,
    instrument     TEXT,
    thread         TEXT,
    summary        TEXT,
    backend        TEXT NOT NULL,   -- 'gemini' | 'libretranslate' | 'krutrim' -- whichever wrote the newest field
    translated_at  TEXT NOT NULL,   -- ISO datetime of the last write to this row
    PRIMARY KEY (gazette_id, lang)
);

CREATE INDEX IF NOT EXISTS idx_translation_lang ON notification_translation(lang);

-- Coverage ledger: which (ministry, date-range) windows this project has
-- actually searched via ingest.egazette_search or gazettetracker.com, and
-- what each search found. This is deliberately NOT a record of what's
-- modeled (gazette_notification/cross_reference already track that) -- it
-- answers "have we looked here at all" and "what came back", so a later
-- session can see at a glance which date ranges have never been checked
-- by either source and are worth cross-referencing against a completely
-- different one (a ministry's own website, PIB releases, an official
-- gazette index) instead of re-polling the same two sources again. See
-- ingest/coverage_ledger.py.
CREATE TABLE IF NOT EXISTS extraction_coverage (
    coverage_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    ministry_id         TEXT NOT NULL REFERENCES ministry(ministry_id),
    source              TEXT NOT NULL,   -- 'egazette_search' | 'gazettetracker'
    date_from           TEXT NOT NULL,   -- ISO 'YYYY-MM-DD', inclusive
    date_to             TEXT NOT NULL,   -- ISO 'YYYY-MM-DD', inclusive
    gazette_ids_found   TEXT NOT NULL,   -- JSON array of gazette_ids this scan returned (may be [])
    possibly_truncated  TEXT,            -- JSON array of [year, month] pairs that hit a page cap, or NULL
    failed_months       TEXT,            -- JSON array of [year, month] pairs never successfully searched
                                          -- (network/server errors survived MONTH_RETRIES attempts each), or
                                          -- NULL -- these months are NOT covered despite falling inside
                                          -- [date_from, date_to]; see ingest/coverage_ledger.py
    checked_at          TEXT NOT NULL    -- ISO datetime this scan was run
);

CREATE INDEX IF NOT EXISTS idx_coverage_ministry ON extraction_coverage(ministry_id);
CREATE INDEX IF NOT EXISTS idx_coverage_dates ON extraction_coverage(date_from, date_to);
