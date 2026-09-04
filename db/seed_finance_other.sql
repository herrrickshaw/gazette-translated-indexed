-- Ministry of Finance — departments OTHER than Revenue/CBIC (already
-- modeled separately, see db/seed_cbic.sql). Two real pairs researched
-- via gazettetracker.com (Full Text section, primary), 2026-09-04,
-- modeled via extract/finance_other_patterns.py (corrigendum-
-- substitution) and the note-chain template.
--
-- A separate ministry_id from CBIC's ('finance-revenue-cbic'), since the
-- schema stores one department string per ministry_id row and these are
-- a genuinely different department scope (Economic Affairs / Expenditure
-- / Financial Services / DIPAM) under the same real "Ministry of Finance".
--
-- Pair 2's Note lists 18 intervening amendments between the 2019
-- principal and the current 2026 notification, but only the FIRST (item
-- i) and LAST (item xviii) were individually transcribed this session —
-- the other 16 are real but not captured, so this is modeled as a
-- genuinely PARTIAL chain (three separate nodes: principal, first
-- amendment, last-before-current — with no edge bridging the 16-item
-- gap between the first and last), the same discipline used for every
-- other incomplete chain in this project.
--
-- A third real lead (a cross-department DEA-amends-DFS notification) is
-- bare "Notification No." form on both ends and is deliberately not
-- modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('finance-other-departments', 'Ministry of Finance', 'Department of Economic Affairs; Department of Expenditure; Department of Financial Services; DIPAM');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('pfms-aadhaar-authentication-rules', 'Public Financial Management System Aadhaar-authentication rules', NULL),
  ('fema-non-debt-instruments-rules-2019', 'FEMA (Non-debt Instruments) Rules, 2019', 2019);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('pfms-aadhaar-corrigendum', 'PFMS Aadhaar-authentication rules corrigendum', 'active'),
  ('fema-non-debt-instruments-amendments', 'FEMA Non-debt Instruments Rules and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain
  ('mof-gsr-859-2025', 'MoF', 'G.S.R. 859(E)', 2025, 'so-only', '2025-11-21', 'G.S.R. 859(E)', 'finance-other-departments', 'pfms-aadhaar-authentication-rules', 'pfms-aadhaar-corrigendum'),
  ('mof-gsr-580-2026', 'MoF', 'G.S.R. 580(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 580(E)', 'finance-other-departments', 'pfms-aadhaar-authentication-rules', 'pfms-aadhaar-corrigendum'),
  -- Pair 2: genuinely partial chain (principal, first amendment, last-before-current, current)
  ('mof-so-3732-2019', 'MoF', 'S.O. 3732(E)', 2019, 'so-only', '2019-10-17', 'S.O. 3732(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-4355-2019', 'MoF', 'S.O. 4355(E)', 2019, 'so-only', '2019-12-05', 'S.O. 4355(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-3030-2026', 'MoF', 'S.O. 3030(E)', 2026, 'so-only', '2026-06-12', 'S.O. 3030(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-4870-2026', 'MoF', 'S.O. 4870(E)', 2026, 'so-only', '2026-09-02', 'S.O. 4870(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mof-gsr-580-2026', 'mof-gsr-859-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-4355-2019', 'mof-so-3732-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-4870-2026', 'mof-so-3030-2026', 'amends', 'research-agent-quoted', '2026-09-04');
