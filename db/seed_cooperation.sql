-- Ministry of Cooperation. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original 2-pair pass. The
-- ministry's ENTIRE tracked gazette history (19 notifications total) was
-- reviewed this pass.
--
-- Real extension: the Tribhuvan Sahkari University Executive Council
-- chain has a third link (S.O. 3739(E)), confirmed via its own Note
-- naming both S.O. 3247(E) (principal) and S.O. 2048(E) (already known).
--
-- Real sibling discovery: G.S.R. 427(E) (2020, already modeled under
-- Agriculture's ministry_id — see db/seed_agriculture.sql) turns out to
-- have constituted BOTH the NCDC General Council (superseded by the
-- already-known G.S.R. 93(E)) AND the NCDC Board of Management
-- (superseded by a newly-found G.S.R. 92(E), same date) — two independent
-- real supersession edges from the same real target notification.
--
-- One new Multi-State Cooperative Societies Act, 2002 chain (Second
-- Schedule amendments).
--
-- Two further real leads are deliberately NOT modeled: a Tribhuvan
-- Sahkari University Statutes amendment (S.O. 676(E)) whose OWN text
-- names its target only by title, never by citation number — the target
-- (S.O. 3087(E)) is only known because the agent independently opened
-- that document's own separate page, which this project's standard does
-- not treat as sufficient (the CITING document itself must state the
-- citation, an inference from context is not the same as a quote — the
-- same standard just applied to Communications' TRAI Recruitment Rules
-- supersession this same batch); and a Hindi-version corrigendum whose
-- Full Text could not be extracted at all (masthead only), so its content
-- is genuinely unverified rather than just weakly cited.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('cooperation', 'Ministry of Cooperation', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('ncdc-act-1962-general-council', 'National Cooperative Development Corporation Act, 1962 — General Council', 1962),
  ('ncdc-act-1962-board-of-management', 'National Cooperative Development Corporation Act, 1962 — Board of Management', 1962),
  ('tribhuvan-sahkari-university-statutes-2025', 'Tribhuvan Sahkari University Statutes, 2025 — Executive Council', 2025),
  ('mscs-act-2002-second-schedule', 'Multi-State Co-operative Societies Act, 2002 — Second Schedule', 2002);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('ncdc-general-council-chain', 'NCDC General Council membership: supersession then amendment', 'active'),
  ('ncdc-board-of-management-chain', 'NCDC Board of Management membership supersession', 'superseded'),
  ('tribhuvan-university-executive-council', 'Tribhuvan Sahkari University Executive Council membership', 'active'),
  ('mscs-second-schedule-amendments', 'MSCS Act Second Schedule amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: NCDC General Council chain, unchanged
  ('moa-gsr-427-2020', 'Agriculture', 'G.S.R. 427(E)', 2020, 'so-only', '2020-07-01', 'G.S.R. 427(E)', 'agriculture-and-farmers-welfare', 'ncdc-act-1962-general-council', 'ncdc-general-council-chain'),
  ('moc-gsr-93-2024',  'Cooperation', 'G.S.R. 93(E)',  2024, 'so-only', '2024-02-02', 'G.S.R. 93(E)',  'cooperation', 'ncdc-act-1962-general-council', 'ncdc-general-council-chain'),
  ('moc-gsr-275-2024', 'Cooperation', 'G.S.R. 275(E)', 2024, 'so-only', '2024-05-16', 'G.S.R. 275(E)', 'cooperation', 'ncdc-act-1962-general-council', 'ncdc-general-council-chain'),
  -- New: NCDC Board of Management, sibling supersession of the SAME G.S.R. 427(E)
  ('moc-gsr-92-2024', 'Cooperation', 'G.S.R. 92(E)', 2024, 'so-only', '2024-02-02', 'G.S.R. 92(E)', 'cooperation', 'ncdc-act-1962-board-of-management', 'ncdc-board-of-management-chain'),
  -- Pair 2: Tribhuvan Executive Council, now a 3-node chain
  ('moc-so-3247-2025', 'Cooperation', 'S.O. 3247(E)', 2025, 'so-only', '2025-07-16', 'S.O. 3247(E)', 'cooperation', 'tribhuvan-sahkari-university-statutes-2025', 'tribhuvan-university-executive-council'),
  ('moc-so-2048-2026', 'Cooperation', 'S.O. 2048(E)', 2026, 'so-only', '2026-04-22', 'S.O. 2048(E)', 'cooperation', 'tribhuvan-sahkari-university-statutes-2025', 'tribhuvan-university-executive-council'),
  ('moc-so-3739-2026', 'Cooperation', 'S.O. 3739(E)', 2026, 'so-only', '2026-07-09', 'S.O. 3739(E)', 'cooperation', 'tribhuvan-sahkari-university-statutes-2025', 'tribhuvan-university-executive-council'),
  -- New: MSCS Act Second Schedule chain
  ('moc-so-1396-2023', 'Cooperation', 'S.O. 1396(E)', 2023, 'so-only', '2023-03-21', 'S.O. 1396(E)', 'cooperation', 'mscs-act-2002-second-schedule', 'mscs-second-schedule-amendments'),
  ('moc-so-3003-2025', 'Cooperation', 'S.O. 3003(E)', 2025, 'so-only', '2025-07-02', 'S.O. 3003(E)', 'cooperation', 'mscs-act-2002-second-schedule', 'mscs-second-schedule-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moc-gsr-93-2024',  'moa-gsr-427-2020', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('moc-gsr-275-2024', 'moc-gsr-93-2024',  'amends',     'research-agent-quoted', '2026-09-04'),
  ('moc-gsr-92-2024',  'moa-gsr-427-2020', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('moc-so-2048-2026', 'moc-so-3247-2025', 'amends',     'research-agent-quoted', '2026-09-04'),
  ('moc-so-3739-2026', 'moc-so-2048-2026', 'amends',     'research-agent-quoted', '2026-09-04'),
  ('moc-so-3003-2025', 'moc-so-1396-2023', 'amends',     'research-agent-quoted', '2026-09-04');
