-- Ministry of Health and Family Welfare pilot.
--
-- Modeled: G.S.R. 11(E) corrects G.S.R. 10(E) (Drugs and Cosmetics Act
-- section citation typo, verified_by 'research-agent-quoted').
--
-- Real leads found but NOT modeled here (draft-to-final rule-making is a
-- legally distinct mechanism from a corrigendum, not a same-shape pair):
--   - G.S.R. 810(E) is a corrigendum to draft G.S.R. 587(E), which was then
--     finalized as G.S.R. 50(E) — a three-notification chain.
--   - G.S.R. 743(E) finalizes draft G.S.R. 270(E) under Drugs and Cosmetics
--     Act sections 12/33 (Medical Devices (Second Amendment) Rules, 2026).
--   Neither draft notification's own gazette page was independently found;
--   their existence is corroborated only by citation in the later text.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('health-family-welfare', 'Ministry of Health and Family Welfare', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('drugs-cosmetics-act-1940', 'Drugs and Cosmetics Act, 1940', 1940);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mohfw-corrections', 'MoHFW notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mohfw-gsr-10-2025', 'MoHFW', 'G.S.R. 10(E)', 2025, 'so-only', '2025-01-04', 'G.S.R. 10(E)', 'health-family-welfare', 'drugs-cosmetics-act-1940', 'mohfw-corrections'),
  ('mohfw-gsr-11-2025', 'MoHFW', 'G.S.R. 11(E)', 2025, 'so-only', '2025-01-06', 'G.S.R. 11(E)', 'health-family-welfare', 'drugs-cosmetics-act-1940', 'mohfw-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mohfw-gsr-11-2025', 'mohfw-gsr-10-2025', 'corrigendum', 'research-agent-quoted', '2026-09-03');
