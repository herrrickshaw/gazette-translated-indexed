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
