-- Ministry of Tribal Affairs pilot. The ministry's own gazettetracker.com
-- listing has only 2 notifications total; one real amendment pair exists
-- between them, researched 2026-09-04 and modeled via
-- extract/tribal_affairs_patterns.py (corrigendum-substitution template).
--
-- A second real lead (a Scheduled Castes/Scheduled Tribes Orders
-- (Amendment) Act corrigendum) was found but is issued by the Ministry of
-- LAW AND JUSTICE, not Tribal Affairs, and cites only an Act number ("6 of
-- 2024") — both the wrong ministry and a bare/unusable citation form
-- consistent with Law and Justice's full abandonment this project already
-- recorded (see GATES.md history) — not modeled here either.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('tribal-affairs', 'Ministry of Tribal Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('ncst-chairperson-appointment', 'National Commission for Scheduled Tribes Chairperson/Member appointment', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('ncst-chairperson-membership', 'NCST Chairperson/Member appointment and its amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mota-so-3786-2021', 'MoTA', 'S.O. 3786(E)', 2021, 'so-only', '2021-09-15', 'S.O. 3786(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-3566-2023', 'MoTA', 'S.O. 3566(E)', 2023, 'so-only', '2023-08-08', 'S.O. 3566(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mota-so-3566-2023', 'mota-so-3786-2021', 'amends', 'research-agent-quoted', '2026-09-04');
