-- Department of Space (ISRO) pilot. The tracker lists only 2 total
-- notifications for this department; one real, note-chain-shaped
-- amendment exists, researched via gazettetracker.com (Full Text
-- section, primary), 2026-09-04.
--
-- The Note names a 39-link amendment history back to the 1976 principal
-- rules, printed as a table (Notification No. / Date / S.O. No. / Date
-- columns) rather than the usual numbered prose list every other
-- note-chain in this project uses. Only ONE example row was quoted
-- verbatim (row 39), and its column semantics are genuinely ambiguous
-- from that single row (two dates, unclear which is the S.O.'s own date
-- vs. a signing/file date) — so this is modeled as a real, honestly
-- PARTIAL chain: only the two fully-unambiguous endpoints (the 1976
-- principal and the 2025 notification citing it) are linked directly.
-- The 39 intervening amendments are real but not individually
-- transcribed this session, so no edge bridges the 49-year gap between
-- them — the same discipline used for Agriculture's and Rural
-- Development's partial chains.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('department-of-space', 'Department of Space', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('dos-employees-cca-rules-1976', 'Department of Space Employees'' (Classification, Control and Appeal) Rules, 1976', 1976);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('dos-cca-rules-amendments', 'Department of Space Employees'' CCA Rules and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('dos-so-270-1976',  'DoS', 'S.O. 270(E)',  1976, 'so-only', '1976-04-01', 'S.O. 270(E)',  'department-of-space', 'dos-employees-cca-rules-1976', 'dos-cca-rules-amendments'),
  ('dos-so-5979-2025', 'DoS', 'S.O. 5979(E)', 2025, 'so-only', '2025-12-15', 'S.O. 5979(E)', 'department-of-space', 'dos-employees-cca-rules-1976', 'dos-cca-rules-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('dos-so-5979-2025', 'dos-so-270-1976', 'amends', 'research-agent-quoted', '2026-09-04');
