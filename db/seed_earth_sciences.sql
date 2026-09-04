-- Ministry of Earth Sciences pilot. One real pair researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04, modeled via
-- extract/earth_sciences_patterns.py (amendment-in-notification template,
-- no new code needed).
--
-- Two further real leads are NOT modeled: a Group 'A' Recruitment Rules
-- supersession whose target ("...Recruitment Rules, 2012") carries no
-- G.S.R./S.O. number anywhere in the text, and a Scientist 'B' Recruitment
-- Rules supersession whose target is cited as "G.S.R. 137 RRs" — a real
-- number, but not in the "NNNN(E)" form this project's citation regex
-- recognizes. Neither is forced.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('earth-sciences', 'Ministry of Earth Sciences', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('national-antarctic-committee', 'National Committee on Antarctic Governance — expert member nomination', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('antarctic-committee-membership', 'National Antarctic Committee expert-member nominations', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('moes-so-3508-2023', 'MoES', 'S.O. 3508(E)', 2023, 'so-only', '2023-08-07', 'S.O. 3508(E)', 'earth-sciences', 'national-antarctic-committee', 'antarctic-committee-membership'),
  ('moes-so-4331-2026', 'MoES', 'S.O. 4331(E)', 2026, 'so-only', '2026-08-05', 'S.O. 4331(E)', 'earth-sciences', 'national-antarctic-committee', 'antarctic-committee-membership');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moes-so-4331-2026', 'moes-so-3508-2023', 'amends', 'research-agent-quoted', '2026-09-04');
