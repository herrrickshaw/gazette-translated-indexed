-- Ministry of Power pilot.
--
-- Modeled: S.O. 3520(E) amends S.O. 5852(E), a notification declaring
-- transmission asset centres protected systems under IT Act, 2000 section
-- 70 (verified_by 'research-agent-quoted').
--
-- Also modeled (2026-09-04): S.O. 2978(E) repeals S.O. 1034(E) (Standards
-- and Labelling Programme for Tubular Fluorescent Lamps) — the first
-- 'repeals' relation_type, distinct from 'rescinds' (Communications) in the
-- exact statutory verb used, both meaning "this no longer has effect".
-- S.O. 2979(E)/S.O. 1033(E) is the parallel companion pair, same repeal
-- action under a different tariff item — not modeled this pass, real.
-- G.S.R. 259(E) amends G.S.R. 211(E) directly (JERC Salary/Allowances
-- Rules, 2007); the intermediate G.S.R. 488(E) amendment is real but this
-- session never captured its exact date, so no edge is asserted through it.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('power', 'Ministry of Power', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('it-act-2000-s70', 'Information Technology Act, 2000 — section 70 (protected systems)', 2000),
  ('standards-labelling-tfl-programme', 'Standards and Labelling Programme for Tubular Fluorescent Lamps', NULL),
  ('electricity-act-2003-s89', 'Electricity Act, 2003 — section 89 (JERC conditions of service)', 2003);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('power-protected-systems', 'Ministry of Power protected-system notifications and amendments', 'active'),
  ('power-tfl-standards', 'Tubular Fluorescent Lamp standards programme and its repeal', 'superseded'),
  ('power-jerc-rules', 'JERC (Union Territories) conditions-of-service rules and amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('power-so-5852-2022', 'Power', 'S.O. 5852(E)', 2022, 'so-only', '2022-12-13', 'S.O. 5852(E)', 'power', 'it-act-2000-s70', 'power-protected-systems'),
  ('power-so-3520-2026', 'Power', 'S.O. 3520(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3520(E)', 'power', 'it-act-2000-s70', 'power-protected-systems'),
  ('power-so-1034-2018', 'Power', 'S.O. 1034(E)', 2018, 'so-only', '2018-03-09', 'S.O. 1034(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards'),
  ('power-so-2978-2026', 'Power', 'S.O. 2978(E)', 2026, 'so-only', '2026-06-10', 'S.O. 2978(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards'),
  ('power-gsr-211-2007', 'Power', 'G.S.R. 211(E)', 2007, 'so-only', '2007-03-19', 'G.S.R. 211(E)', 'power', 'electricity-act-2003-s89', 'power-jerc-rules'),
  ('power-gsr-259-2026', 'Power', 'G.S.R. 259(E)', 2026, 'so-only', '2026-04-08', 'G.S.R. 259(E)', 'power', 'electricity-act-2003-s89', 'power-jerc-rules');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('power-so-3520-2026', 'power-so-5852-2022', 'amends', 'research-agent-quoted', '2026-09-03'),
  ('power-so-2978-2026', 'power-so-1034-2018', 'repeals', 'research-agent-quoted', '2026-09-04'),
  ('power-gsr-259-2026', 'power-gsr-211-2007', 'amends', 'research-agent-quoted', '2026-09-04');
