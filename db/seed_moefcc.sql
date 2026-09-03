-- Third-ministry pilot: Ministry of Environment, Forest and Climate Change.
--
-- Provenance, recorded per-row rather than assumed uniform:
--   'spot-checked'       — independently re-fetched and confirmed against
--                          the source page during this session (Pair A only)
--   'research-agent-quoted' — a research agent quoted primary "Full Text"
--                          from gazettetracker.com; not independently
--                          re-fetched by this session. Real, not fabricated,
--                          but one tier below spot-checked.
--
-- Drafting convention differs from both CBIC's and MoRTH's: "In the
-- notification of the Government of India in the Ministry of Environment,
-- Forest and Climate Change [vide] number <citation>, dated <date> ... for
-- [old text] read [new text]" — a corrigendum-by-textual-substitution
-- template, not a supersession or a single "hereby makes the following
-- amendment" clause.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('environment-forest-climate-change', 'Ministry of Environment, Forest and Climate Change', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('moefcc-notifications-general', 'MoEFCC notifications (various subject matter)', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('moefcc-corrections', 'MoEFCC notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('moefcc-so-3252-2022', 'MoEFCC', 'S.O. 3252(E)', 2022, 'so-only', '2022-07-22', 'S.O. 3252(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-so-3182-2023', 'MoEFCC', 'S.O. 3182(E)', 2023, 'so-only', '2023-07-18', 'S.O. 3182(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-so-5254-2022', 'MoEFCC', 'S.O. 5254(E)', 2022, 'so-only', '2022-11-04', 'S.O. 5254(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-so-4101-2023', 'MoEFCC', 'S.O. 4101(E)', 2023, 'so-only', '2023-09-18', 'S.O. 4101(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-gsr-766-2018', 'MoEFCC', 'G.S.R. 766(E)', 2018, 'so-only', '2018-08-10', 'G.S.R. 766(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-gsr-731-2024', 'MoEFCC', 'G.S.R. 731(E)', 2024, 'so-only', '2024-11-26', 'G.S.R. 731(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moefcc-so-3182-2023', 'moefcc-so-3252-2022', 'corrigendum', 'spot-checked',          '2026-09-03'),
  ('moefcc-so-4101-2023', 'moefcc-so-5254-2022', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  ('moefcc-gsr-731-2024', 'moefcc-gsr-766-2018', 'corrigendum', 'research-agent-quoted', '2026-09-03');
