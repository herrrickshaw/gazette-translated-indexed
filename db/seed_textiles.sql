-- Ministry of Textiles pilot. Three real pairs researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04.
--
-- Pair 1 — S.O. 3189(E) supersedes Notification No. 2/TDRO/8/2003 (Hank
-- Yarn packing notification under the Textiles (Development and
-- Regulation) Order, 2001) — DEFERRED, not modeled. Same reason as
-- Commerce/DGFT and Defence's Army honorary-rank pair this batch: the
-- principal notification is cited by a bare "Notification No.
-- X/TDRO/Y/YYYY" form, not G.S.R./S.O./S.R.O., which this schema's
-- extractors don't recognize — a real citation, honestly left unmodeled
-- rather than forced.
--
-- Pairs 2/3 below ARE modeled via the note-chain template
-- (extract.common_templates.find_note_chain, already tested).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('textiles', 'Ministry of Textiles', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('cotton-bales-quality-control-order-2023', 'Cotton Bales (Quality Control) Order, 2023', 2023),
  ('ropes-cordages-quality-control-order-2024', 'Ropes and Cordages (Quality Control) Order, 2024', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('textiles-cotton-bales-order', 'Cotton Bales (Quality Control) Order, its amendments, and its rescission', 'superseded'),
  ('textiles-ropes-cordages-order', 'Ropes and Cordages (Quality Control) Order and its amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 2: six-node chain ending in rescission of the whole Order
  ('textiles-so-948-2023',  'Textiles', 'S.O. 948(E)',  2023, 'so-only', '2023-02-28', 'S.O. 948(E)',  'textiles', 'cotton-bales-quality-control-order-2023', 'textiles-cotton-bales-order'),
  ('textiles-so-3557-2023', 'Textiles', 'S.O. 3557(E)', 2023, 'so-only', '2023-08-07', 'S.O. 3557(E)', 'textiles', 'cotton-bales-quality-control-order-2023', 'textiles-cotton-bales-order'),
  ('textiles-so-3830-2023', 'Textiles', 'S.O. 3830(E)', 2023, 'so-only', '2023-08-28', 'S.O. 3830(E)', 'textiles', 'cotton-bales-quality-control-order-2023', 'textiles-cotton-bales-order'),
  ('textiles-so-3469-2024', 'Textiles', 'S.O. 3469(E)', 2024, 'so-only', '2024-08-13', 'S.O. 3469(E)', 'textiles', 'cotton-bales-quality-control-order-2023', 'textiles-cotton-bales-order'),
  ('textiles-so-2996-2025', 'Textiles', 'S.O. 2996(E)', 2025, 'so-only', '2025-07-03', 'S.O. 2996(E)', 'textiles', 'cotton-bales-quality-control-order-2023', 'textiles-cotton-bales-order'),
  ('textiles-so-2956-2026', 'Textiles', 'S.O. 2956(E)', 2026, 'so-only', '2026-06-09', 'S.O. 2956(E)', 'textiles', 'cotton-bales-quality-control-order-2023', 'textiles-cotton-bales-order'),
  -- Pair 3: two-node chain
  ('textiles-so-4327-2024', 'Textiles', 'S.O. 4327(E)', 2024, 'so-only', '2024-10-03', 'S.O. 4327(E)', 'textiles', 'ropes-cordages-quality-control-order-2024', 'textiles-ropes-cordages-order'),
  ('textiles-so-2871-2026', 'Textiles', 'S.O. 2871(E)', 2026, 'so-only', '2026-06-05', 'S.O. 2871(E)', 'textiles', 'ropes-cordages-quality-control-order-2024', 'textiles-ropes-cordages-order');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('textiles-so-3557-2023', 'textiles-so-948-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('textiles-so-3830-2023', 'textiles-so-3557-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('textiles-so-3469-2024', 'textiles-so-3830-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('textiles-so-2996-2025', 'textiles-so-3469-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('textiles-so-2956-2026', 'textiles-so-2996-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('textiles-so-2871-2026', 'textiles-so-4327-2024', 'amends', 'research-agent-quoted', '2026-09-04');
