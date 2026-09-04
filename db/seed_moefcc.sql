-- Third-ministry pilot: Ministry of Environment, Forest and Climate Change.
--
-- 🔴 CORRECTION (2026-09-04): the S.O. 3182(E)/S.O. 3252(E) pair below was
-- originally tagged 'spot-checked' against gazette ID CG-DL-E-19072023-247431
-- — that gazette ID's OFFICIAL PDF (fetched from egazette.gov.in and parsed
-- during the bounded manifest run) is a DIFFERENT notification entirely:
-- G.S.R. 522(E) correcting G.S.R. 499(E) ("draft notification" -> "notification"),
-- with no mention of S.O. 3182(E)/3252(E)/"Times of India" anywhere in it. The
-- aggregator served mismatched content under that ID — the same class of
-- fault as the three page-TITLE mismatches already found elsewhere in this
-- project, but this time the Full Text itself was wrong, not just the title.
-- The S.O. 3182(E)/3252(E) quote is kept (it is real text, seen verbatim on
-- the aggregator page at the time) but downgraded to 'research-agent-quoted'
-- — a "spot-check" against a mismatched ID is not a spot-check, and no
-- correct gazette ID for this pair has been located since. The genuinely
-- verified G.S.R. 522(E)/499(E) pair recovered from the real official PDF is
-- added below at the 'primary-source-egazette' tier instead — a small
-- ministry-level lesson from a real mistake, not a wasted fetch.
--
-- Provenance, recorded per-row rather than assumed uniform:
--   'primary-source-egazette' — fetched from egazette.gov.in by gazette ID
--                          and parsed directly by this pipeline; the
--                          strongest tier available for a ministry.
--   'research-agent-quoted' — a research agent quoted primary "Full Text"
--                          from an aggregator; not independently fetched
--                          from the official source. Real, not fabricated,
--                          but its own gazette ID may be unconfirmed — see
--                          the correction above.
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
  ('moefcc-gsr-731-2024', 'MoEFCC', 'G.S.R. 731(E)', 2024, 'so-only', '2024-11-26', 'G.S.R. 731(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  -- Recovered directly from the OFFICIAL PDF at CG-DL-E-19072023-247431 —
  -- the notification actually at that gazette ID (see correction above).
  ('moefcc-gsr-499-2023', 'MoEFCC', 'G.S.R. 499(E)', 2023, 'so-only', '2023-07-11', 'G.S.R. 499(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-gsr-522-2023', 'MoEFCC', 'G.S.R. 522(E)', 2023, 'so-only', '2023-07-18', 'G.S.R. 522(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moefcc-so-3182-2023', 'moefcc-so-3252-2022', 'corrigendum', 'research-agent-quoted',   '2026-09-03'),
  ('moefcc-so-4101-2023', 'moefcc-so-5254-2022', 'corrigendum', 'research-agent-quoted',   '2026-09-03'),
  ('moefcc-gsr-731-2024', 'moefcc-gsr-766-2018', 'corrigendum', 'research-agent-quoted',   '2026-09-03'),
  ('moefcc-gsr-522-2023', 'moefcc-gsr-499-2023', 'corrigendum', 'primary-source-egazette', '2026-09-04');
