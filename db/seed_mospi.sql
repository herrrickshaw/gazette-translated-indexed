-- Ministry of Statistics and Programme Implementation (MoSPI) pilot. Two
-- real corrigenda researched via gazettetracker.com (Full Text section,
-- primary), 2026-09-04, modeled via extract/mospi_patterns.py
-- (bare-citation-reference template — see that module's docstring for why
-- no ministry-name anchor is needed or present in this ministry's real
-- text).
--
-- A third real lead (S.O. 4544(E)) cites its target only by date and File
-- No., no S.O. number in the amending text itself, and a fourth (a
-- corrigendum cited as "No. U-11014/9/2023-NAD-2B") is bare-form-only —
-- both deliberately not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('statistics-and-programme-implementation', 'Ministry of Statistics and Programme Implementation', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('assse-jurisdiction-notification-2026', 'ASSSE jurisdiction notification, 2026', 2026),
  ('regional-office-designation-notification-2026', 'Regional-office designation notification, 2026', 2026);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('assse-jurisdiction-corrigendum', 'ASSSE jurisdiction corrigendum', 'active'),
  ('regional-office-designation-corrigendum', 'Regional-office designation corrigendum', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mospi-so-1398-2026', 'MoSPI', 'S.O. 1398(E)', 2026, 'so-only', '2026-03-16', 'S.O. 1398(E)', 'statistics-and-programme-implementation', 'assse-jurisdiction-notification-2026', 'assse-jurisdiction-corrigendum'),
  ('mospi-so-1767-2026', 'MoSPI', 'S.O. 1767(E)', 2026, 'so-only', '2026-04-01', 'S.O. 1767(E)', 'statistics-and-programme-implementation', 'assse-jurisdiction-notification-2026', 'assse-jurisdiction-corrigendum'),
  ('mospi-so-174-2026',  'MoSPI', 'S.O. 174(E)',  2026, 'so-only', '2026-01-12', 'S.O. 174(E)',  'statistics-and-programme-implementation', 'regional-office-designation-notification-2026', 'regional-office-designation-corrigendum'),
  ('mospi-so-949-2026',  'MoSPI', 'S.O. 949(E)',  2026, 'so-only', '2026-01-30', 'S.O. 949(E)',  'statistics-and-programme-implementation', 'regional-office-designation-notification-2026', 'regional-office-designation-corrigendum');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mospi-so-1767-2026', 'mospi-so-1398-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mospi-so-949-2026',  'mospi-so-174-2026',  'corrigendum', 'research-agent-quoted', '2026-09-04');
