-- Ministry of Food Processing Industries pilot. One usable real pair
-- researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04, modeled via extract/food_processing_patterns.py
-- (amendment-in-notification template). This is a genuinely small
-- ministry — only 6 notifications total in the tracker's listing.
--
-- Two further real leads (Multi Tasking Staff and Staff Car Driver
-- Recruitment Rules, both superseding name-only 1994-era rules with no
-- citation number) and one bare-form lead ("Notification no.
-- A-26011/4/97-F&VP(Admn)") are deliberately not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('food-processing-industries', 'Ministry of Food Processing Industries', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('niftem-act-2021', 'National Institutes of Food Technology, Entrepreneurship and Management Act, 2021 (Council membership)', 2021);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('niftem-council-membership', 'NIFTEM Council membership', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mofpi-so-5577-2025', 'MoFPI', 'S.O. 5577(E)', 2025, 'so-only', '2025-12-03', 'S.O. 5577(E)', 'food-processing-industries', 'niftem-act-2021', 'niftem-council-membership'),
  ('mofpi-so-4784-2026', 'MoFPI', 'S.O. 4784(E)', 2026, 'so-only', '2026-08-27', 'S.O. 4784(E)', 'food-processing-industries', 'niftem-act-2021', 'niftem-council-membership');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mofpi-so-4784-2026', 'mofpi-so-5577-2025', 'amends', 'research-agent-quoted', '2026-09-04');
