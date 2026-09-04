-- Ministry of Cooperation pilot. Two real pairs (one a 3-node
-- cross-ministry chain) researched via gazettetracker.com (Full Text
-- section, primary), 2026-09-04, modeled via extract/cooperation_patterns.py
-- (amendment-in-notification + supersession-preamble combined).
--
-- Pair 1's principal notification (G.S.R. 427(E)) was itself issued by
-- the Ministry of Agriculture and Farmers Welfare in 2020, before the
-- Ministry of Cooperation existed as a separate ministry (created 2021)
-- — modeled under that ministry_id (already defined in
-- db/seed_agriculture.sql) rather than invented as a Cooperation row, the
-- same cross-ministry pattern already used for External Affairs and
-- Skill Development's supersessions.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('cooperation', 'Ministry of Cooperation', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('ncdc-act-1962-general-council', 'National Cooperative Development Corporation Act, 1962 — General Council', 1962),
  ('tribhuvan-sahkari-university-statutes-2025', 'Tribhuvan Sahkari University Statutes, 2025 — Executive Council', 2025);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('ncdc-general-council-chain', 'NCDC General Council membership: supersession then amendment', 'active'),
  ('tribhuvan-university-executive-council', 'Tribhuvan Sahkari University Executive Council membership', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: three-node chain, first node under Agriculture (pre-dates Cooperation as a separate ministry)
  ('moa-gsr-427-2020', 'Agriculture', 'G.S.R. 427(E)', 2020, 'so-only', '2020-07-01', 'G.S.R. 427(E)', 'agriculture-and-farmers-welfare', 'ncdc-act-1962-general-council', 'ncdc-general-council-chain'),
  ('moc-gsr-93-2024',  'Cooperation', 'G.S.R. 93(E)',  2024, 'so-only', '2024-02-02', 'G.S.R. 93(E)',  'cooperation', 'ncdc-act-1962-general-council', 'ncdc-general-council-chain'),
  ('moc-gsr-275-2024', 'Cooperation', 'G.S.R. 275(E)', 2024, 'so-only', '2024-05-16', 'G.S.R. 275(E)', 'cooperation', 'ncdc-act-1962-general-council', 'ncdc-general-council-chain'),
  -- Pair 2: two-node chain
  ('moc-so-3247-2025', 'Cooperation', 'S.O. 3247(E)', 2025, 'so-only', '2025-07-16', 'S.O. 3247(E)', 'cooperation', 'tribhuvan-sahkari-university-statutes-2025', 'tribhuvan-university-executive-council'),
  ('moc-so-2048-2026', 'Cooperation', 'S.O. 2048(E)', 2026, 'so-only', '2026-04-22', 'S.O. 2048(E)', 'cooperation', 'tribhuvan-sahkari-university-statutes-2025', 'tribhuvan-university-executive-council');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moc-gsr-93-2024',  'moa-gsr-427-2020', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('moc-gsr-275-2024', 'moc-gsr-93-2024',  'amends',     'research-agent-quoted', '2026-09-04'),
  ('moc-so-2048-2026', 'moc-so-3247-2025', 'amends',     'research-agent-quoted', '2026-09-04');
