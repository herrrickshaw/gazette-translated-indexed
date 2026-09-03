-- Ministry of Power pilot.
--
-- Modeled: S.O. 3520(E) amends S.O. 5852(E), a notification declaring
-- transmission asset centres protected systems under IT Act, 2000 section
-- 70 (verified_by 'research-agent-quoted').
--
-- Real leads found but NOT modeled here (amendment-history citations on a
-- named Rules instrument, and a repeal chain — different shapes):
--   - S.O. 2978(E)/S.O. 2979(E) (10 Jun 2026) repeal S.O. 1034(E)/S.O.
--     1033(E) (9 Mar 2018) — Standards and Labelling Programme for Tubular
--     Fluorescent Lamps, with a prior amendment history (S.O. 1930(E),
--     S.O. 2789(E)) noted for one of them.
--   - G.S.R. 259(E) (8 Apr 2026) amends the JERC (Salary, Allowances...)
--     Rules, 2007 (G.S.R. 211(E)), previously amended by G.S.R. 488(E).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('power', 'Ministry of Power', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('it-act-2000-s70', 'Information Technology Act, 2000 — section 70 (protected systems)', 2000);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('power-protected-systems', 'Ministry of Power protected-system notifications and amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('power-so-5852-2022', 'Power', 'S.O. 5852(E)', 2022, 'so-only', '2022-12-13', 'S.O. 5852(E)', 'power', 'it-act-2000-s70', 'power-protected-systems'),
  ('power-so-3520-2026', 'Power', 'S.O. 3520(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3520(E)', 'power', 'it-act-2000-s70', 'power-protected-systems');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('power-so-3520-2026', 'power-so-5852-2022', 'amends', 'research-agent-quoted', '2026-09-03');
