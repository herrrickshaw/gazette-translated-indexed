-- Ministry of Social Justice and Empowerment pilot. Three real note-chains
-- researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04. Pair 3's Note clause is the real evidence for the "S.O. No.
-- NNNN(E)" citation variant (see extract/citation_patterns.py and
-- tests/test_so_no_variant.py). Pair 2 is a 12-node chain, the longest S.O.
-- (as opposed to G.S.R.) chain modeled so far.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('social-justice-and-empowerment', 'Ministry of Social Justice and Empowerment', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('rpwd-rules-2017', 'Rights of Persons with Disabilities Rules, 2017 (rule 41, National Fund Governing Body)', 2017),
  ('manual-scavengers-act-2013', 'Prohibition of Employment as Manual Scavengers and their Rehabilitation Act, 2013 (s.29, Central Monitoring Committee)', 2013),
  ('rehabilitation-council-act-1992', 'Rehabilitation Council of India Act, 1992 (s.3, General Council)', 1992);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('national-fund-disabilities-governing-body', 'National Fund for Persons with Disabilities Governing Body membership', 'active'),
  ('manual-scavengers-monitoring-committee', 'Manual Scavengers Act Central Monitoring Committee membership', 'active'),
  ('rehabilitation-council-general-council', 'Rehabilitation Council of India General Council membership', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: three-node chain
  ('sje-so-3322-2017', 'Social Justice', 'S.O. 3322(E)', 2017, 'so-only', '2017-10-13', 'S.O. 3322(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017', 'national-fund-disabilities-governing-body'),
  ('sje-so-4877-2022', 'Social Justice', 'S.O. 4877(E)', 2022, 'so-only', '2022-10-13', 'S.O. 4877(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017', 'national-fund-disabilities-governing-body'),
  ('sje-so-3383-2026', 'Social Justice', 'S.O. 3383(E)', 2026, 'so-only', '2026-06-16', 'S.O. 3383(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017', 'national-fund-disabilities-governing-body'),
  -- Pair 2: twelve-node chain (principal + 10 listed amendments + current)
  ('sje-so-89-2014',    'Social Justice', 'S.O. 89(E)',   2014, 'so-only', '2014-01-13', 'S.O. 89(E)',   'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-605-2014',   'Social Justice', 'S.O. 605(E)',  2014, 'so-only', '2014-02-28', 'S.O. 605(E)',  'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-2008-2014',  'Social Justice', 'S.O. 2008(E)', 2014, 'so-only', '2014-08-07', 'S.O. 2008(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-476-2017',   'Social Justice', 'S.O. 476(E)',  2017, 'so-only', '2017-02-16', 'S.O. 476(E)',  'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-1389-2017',  'Social Justice', 'S.O. 1389(E)', 2017, 'so-only', '2017-05-02', 'S.O. 1389(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-888-2018',   'Social Justice', 'S.O. 888(E)',  2018, 'so-only', '2018-03-01', 'S.O. 888(E)',  'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-3338-2023',  'Social Justice', 'S.O. 3338(E)', 2023, 'so-only', '2023-07-26', 'S.O. 3338(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-4379-2023',  'Social Justice', 'S.O. 4379(E)', 2023, 'so-only', '2023-10-09', 'S.O. 4379(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-1510-2024',  'Social Justice', 'S.O. 1510(E)', 2024, 'so-only', '2024-03-21', 'S.O. 1510(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-93-2025',    'Social Justice', 'S.O. 93(E)',   2025, 'so-only', '2025-01-03', 'S.O. 93(E)',   'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-1352-2025',  'Social Justice', 'S.O. 1352(E)', 2025, 'so-only', '2025-03-21', 'S.O. 1352(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-3793-2025',  'Social Justice', 'S.O. 3793(E)', 2025, 'so-only', '2025-08-13', 'S.O. 3793(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  -- Pair 3: three-node chain, second citation uses the "S.O. No." form
  ('sje-so-1102-2002', 'Social Justice', 'S.O. 1102(E)', 2002, 'so-only', '2002-10-21', 'S.O. 1102(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  ('sje-so-1436-2025', 'Social Justice', 'S.O. 1436(E)', 2025, 'so-only', '2025-03-26', 'S.O. 1436(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  ('sje-so-4285-2025', 'Social Justice', 'S.O. 4285(E)', 2025, 'so-only', '2025-09-08', 'S.O. 4285(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('sje-so-4877-2022', 'sje-so-3322-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-3383-2026', 'sje-so-4877-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-605-2014',  'sje-so-89-2014',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-2008-2014', 'sje-so-605-2014',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-476-2017',  'sje-so-2008-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1389-2017', 'sje-so-476-2017',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-888-2018',  'sje-so-1389-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-3338-2023', 'sje-so-888-2018',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-4379-2023', 'sje-so-3338-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1510-2024', 'sje-so-4379-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-93-2025',   'sje-so-1510-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1352-2025', 'sje-so-93-2025',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-3793-2025', 'sje-so-1352-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1436-2025', 'sje-so-1102-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-4285-2025', 'sje-so-1436-2025', 'amends', 'research-agent-quoted', '2026-09-04');
