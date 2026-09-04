-- Ministry of Development of North Eastern Region (DoNER) pilot. The
-- tracker lists only 1 total notification for this ministry, researched
-- via gazettetracker.com (Full Text section, primary), 2026-09-04. It is
-- a real double-target supersession, fully covered by the existing
-- generic supersession-preamble template (no dedicated extractor module
-- needed).
--
-- The two superseded targets (S.O. 3972(E)/2018, S.O. 342(E)/2020) are
-- not themselves indexed on gazettetracker.com — their citations and
-- dates are taken from the citing document's own primary text, the same
-- standard used for every other real citation in this project.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('doner', 'Ministry of Development of North Eastern Region', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('north-eastern-council-act-1971-membership', 'North Eastern Council Act, 1971 — Council membership', 1971);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('nec-membership-supersession', 'North Eastern Council membership supersession', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('doner-so-3972-2018', 'DoNER', 'S.O. 3972(E)', 2018, 'so-only', '2018-08-13', 'S.O. 3972(E)', 'doner', 'north-eastern-council-act-1971-membership', 'nec-membership-supersession'),
  ('doner-so-342-2020',  'DoNER', 'S.O. 342(E)',  2020, 'so-only', '2020-01-24', 'S.O. 342(E)',  'doner', 'north-eastern-council-act-1971-membership', 'nec-membership-supersession'),
  ('doner-so-713-2024',  'DoNER', 'S.O. 713(E)',  2024, 'so-only', '2024-02-14', 'S.O. 713(E)',  'doner', 'north-eastern-council-act-1971-membership', 'nec-membership-supersession');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('doner-so-713-2024', 'doner-so-3972-2018', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('doner-so-713-2024', 'doner-so-342-2020',  'supersedes', 'research-agent-quoted', '2026-09-04');
