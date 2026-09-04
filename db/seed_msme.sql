-- Ministry of Micro, Small and Medium Enterprises (MSME) pilot. Two
-- usable real pairs researched via gazettetracker.com (Full Text section,
-- primary), 2026-09-04, modeled via extract/msme_patterns.py (amendment-
-- in-notification template) and the existing note-chain template.
--
-- A third real lead (a Recruitment Rules corrigendum) cites its target as
-- "GSR 381" — a real number missing the "(E)" suffix this project's
-- citation regex requires — and is deliberately not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('msme', 'Ministry of Micro, Small and Medium Enterprises', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('msme-classification-notification-2020', 'MSME classification financial-limits notification, 2020', 2020),
  ('kvic-act-1956', 'Khadi and Village Industries Commission Act, 1956 (membership notification)', 1956);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('msme-classification-limits', 'MSME classification financial limits and their amendments', 'active'),
  ('kvic-membership', 'Khadi and Village Industries Commission membership', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain
  ('msme-so-2119-2020', 'MSME', 'S.O. 2119(E)', 2020, 'so-only', '2020-06-26', 'S.O. 2119(E)', 'msme', 'msme-classification-notification-2020', 'msme-classification-limits'),
  ('msme-so-1364-2025', 'MSME', 'S.O. 1364(E)', 2025, 'so-only', '2025-03-21', 'S.O. 1364(E)', 'msme', 'msme-classification-notification-2020', 'msme-classification-limits'),
  -- Pair 2: three-node chain
  ('msme-so-3193-2022', 'MSME', 'S.O. 3193(E)', 2022, 'so-only', '2022-07-14', 'S.O. 3193(E)', 'msme', 'kvic-act-1956', 'kvic-membership'),
  ('msme-so-5403-2022', 'MSME', 'S.O. 5403(E)', 2022, 'so-only', '2022-11-21', 'S.O. 5403(E)', 'msme', 'kvic-act-1956', 'kvic-membership'),
  ('msme-so-3820-2023', 'MSME', 'S.O. 3820(E)', 2023, 'so-only', '2023-08-28', 'S.O. 3820(E)', 'msme', 'kvic-act-1956', 'kvic-membership');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('msme-so-1364-2025', 'msme-so-2119-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('msme-so-5403-2022', 'msme-so-3193-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('msme-so-3820-2023', 'msme-so-5403-2022', 'amends', 'research-agent-quoted', '2026-09-04');
