-- Ministry of Labour and Employment pilot.
--
-- Modeled: S.O. 4573(E) corrects wording in S.O. 2455(E), a Code on Wages,
-- 2019 compoundable-offences notification (verified_by 'research-agent-quoted').
--
-- Real leads found but NOT modeled here (different anchor shape — cites a
-- named Scheme directly, not "the notification ... in the Ministry of X"):
--   - G.S.R. 703(E) (4 Aug 2026) corrects the Employees' Provident Funds
--     Scheme, 2026, published vide G.S.R. 525(E), dated 29 Jun 2026.
--   - G.S.R. 704(E) (4 Aug 2026) corrects the Employees' Pension Scheme,
--     2026, published vide G.S.R. 527(E), dated 29 Jun 2026.
--   A fourth candidate (G.S.R. 706(E) on the EDLI Scheme) was flagged by
--   the research agent as seen but NOT independently confirmed — correctly
--   excluded rather than guessed, and excluded here too.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('labour-and-employment', 'Ministry of Labour and Employment', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('code-on-wages-2019', 'Code on Wages, 2019', 2019);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('labour-corrections', 'Ministry of Labour and Employment notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('labour-so-2455-2026', 'Labour', 'S.O. 2455(E)', 2026, 'so-only', '2026-05-12', 'S.O. 2455(E)', 'labour-and-employment', 'code-on-wages-2019', 'labour-corrections'),
  ('labour-so-4573-2026', 'Labour', 'S.O. 4573(E)', 2026, 'so-only', '2026-08-19', 'S.O. 4573(E)', 'labour-and-employment', 'code-on-wages-2019', 'labour-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('labour-so-4573-2026', 'labour-so-2455-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03');
