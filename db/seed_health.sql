-- Ministry of Health and Family Welfare. Deepened 2026-09-04 (depth pass
-- — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass
-- (1 pair). gazettetracker.com's "Cite This Gazette" widget was found to
-- be unreliable on this ministry's amendment notifications (it sometimes
-- prints the *target/principal*'s number instead of the citing
-- document's own number) — every citation below was taken from the
-- operative "S.O. ___(E).—"/"G.S.R. ___(E).—" opening line of the Full
-- Text body itself, never the citation widget, matching the discipline
-- already used for the Ayush G.S.R. 221(E) correction.
--
-- One deferred lead from the first pass is now CLOSED: the G.S.R. 587(E)
-- draft's own gazette page was found, completing the draft->corrigendum
-- ->final chain (G.S.R. 587(E) -> G.S.R. 810(E) corrigendum -> G.S.R.
-- 50(E) final).
--
-- 6 further new subject threads found: two independent National Medical
-- Commission Act appointment "hubs" (S.O. 3260(E) and its sibling S.O.
-- 3261(E), each with multiple genuinely independent paragraph-tracked
-- amendment sub-chains from one principal); the PCPNDT Act Central
-- Supervisory Board's ~30-year note-chain (S.O. 85(E)); the National
-- Commission for Allied and Healthcare Professions Act chain (S.O.
-- 1248(E)); a CDSCO Drugs Inspectors corrigendum; and a Transplantation
-- of Human Organs and Tissues Act rescission.
--
-- Real leads NOT modeled: the G.S.R. 743(E)/draft G.S.R. 270(E) pair
-- (Medical Devices Second Amendment Rules, 2026) — the draft's own page
-- still not independently found, gazettetracker's anonymous search being
-- rate-limited; several further draft->final Schedule-amendment pairs
-- (Pregabalin, Folic Acid, Schedule B/B1, Schedule K) spotted in listings
-- but not opened for exact quotes this pass — flagged as high-confidence
-- candidates for a future pass, not modeled without primary-text quotes.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('health-family-welfare', 'Ministry of Health and Family Welfare', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('drugs-cosmetics-act-1940', 'Drugs and Cosmetics Act, 1940', 1940),
  ('new-drugs-clinical-trials-rules-2019-ba-be', 'New Drugs and Clinical Trials Rules, 2019 — BA/BE export-purpose studies amendment', 2019),
  ('nmc-act-2019-appointment-hub-3260', 'National Medical Commission Act, 2019 — appointment notification S.O. 3260(E)', 2019),
  ('nmc-act-2019-appointment-hub-3261', 'National Medical Commission Act, 2019 — appointment notification S.O. 3261(E)', 2019),
  ('pcpndt-act-1994-central-supervisory-board', 'Pre-conception and Pre-Natal Diagnostic Techniques Act, 1994 — Central Supervisory Board', 1994),
  ('nca-hp-act-2021-commission', 'National Commission for Allied and Healthcare Professions Act, 2021 — Commission composition', 2021),
  ('transplantation-human-organs-act-1994', 'Transplantation of Human Organs and Tissues Act, 1994', 1994);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mohfw-corrections', 'MoHFW notification corrigenda', 'active'),
  ('new-drugs-ba-be-draft-final', 'New Drugs and Clinical Trials Rules BA/BE amendment: draft, corrigendum, final', 'active'),
  ('nmc-hub-3260-amendments', 'NMC appointment hub S.O. 3260(E) — three independent paragraph-tracked sub-chains', 'active'),
  ('nmc-hub-3261-amendments', 'NMC appointment hub S.O. 3261(E) — sibling notification', 'active'),
  ('pcpndt-csb-note-chain', 'PCPNDT Central Supervisory Board note-chain', 'active'),
  ('nca-hp-commission-amendments', 'National Commission for Allied and Healthcare Professions composition amendments', 'active'),
  ('cdsco-drugs-inspectors-corrigendum', 'CDSCO Drugs Inspectors (Medical Devices) corrigendum', 'active'),
  ('transplantation-act-rescission', 'Transplantation of Human Organs and Tissues Act rescission', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mohfw-gsr-10-2025', 'MoHFW', 'G.S.R. 10(E)', 2025, 'so-only', '2025-01-04', 'G.S.R. 10(E)', 'health-family-welfare', 'drugs-cosmetics-act-1940', 'mohfw-corrections'),
  ('mohfw-gsr-11-2025', 'MoHFW', 'G.S.R. 11(E)', 2025, 'so-only', '2025-01-06', 'G.S.R. 11(E)', 'health-family-welfare', 'drugs-cosmetics-act-1940', 'mohfw-corrections'),
  -- New Drugs and Clinical Trials Rules BA/BE amendment: draft -> corrigendum -> final
  ('mohfw-gsr-587-2025', 'MoHFW', 'G.S.R. 587(E)', 2025, 'so-only', '2025-08-27', 'G.S.R. 587(E)', 'health-family-welfare', 'new-drugs-clinical-trials-rules-2019-ba-be', 'new-drugs-ba-be-draft-final'),
  ('mohfw-gsr-810-2025', 'MoHFW', 'G.S.R. 810(E)', 2025, 'so-only', '2025-10-31', 'G.S.R. 810(E)', 'health-family-welfare', 'new-drugs-clinical-trials-rules-2019-ba-be', 'new-drugs-ba-be-draft-final'),
  ('mohfw-gsr-50-2026',  'MoHFW', 'G.S.R. 50(E)',  2026, 'so-only', '2026-01-21', 'G.S.R. 50(E)',  'health-family-welfare', 'new-drugs-clinical-trials-rules-2019-ba-be', 'new-drugs-ba-be-draft-final'),
  -- NMC appointment hub S.O. 3260(E)
  ('mohfw-so-3260-2020', 'MoHFW', 'S.O. 3260(E)', 2020, 'so-only', '2020-09-24', 'S.O. 3260(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3260', 'nmc-hub-3260-amendments'),
  ('mohfw-so-3088-2025', 'MoHFW', 'S.O. 3088(E)', 2025, 'so-only', '2025-07-11', 'S.O. 3088(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3260', 'nmc-hub-3260-amendments'),
  ('mohfw-so-4203-2025', 'MoHFW', 'S.O. 4203(E)', 2025, 'so-only', '2025-09-17', 'S.O. 4203(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3260', 'nmc-hub-3260-amendments'),
  ('mohfw-so-2036-2021', 'MoHFW', 'S.O. 2036(E)', 2021, 'so-only', '2021-05-28', 'S.O. 2036(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3260', 'nmc-hub-3260-amendments'),
  ('mohfw-so-947-2026',  'MoHFW', 'S.O. 947(E)',  2026, 'so-only', '2026-02-19', 'S.O. 947(E)',  'health-family-welfare', 'nmc-act-2019-appointment-hub-3260', 'nmc-hub-3260-amendments'),
  ('mohfw-so-10-2023',   'MoHFW', 'S.O. 10(E)',   2023, 'so-only', '2023-01-02', 'S.O. 10(E)',   'health-family-welfare', 'nmc-act-2019-appointment-hub-3260', 'nmc-hub-3260-amendments'),
  ('mohfw-so-3925-2025', 'MoHFW', 'S.O. 3925(E)', 2025, 'so-only', '2025-08-27', 'S.O. 3925(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3260', 'nmc-hub-3260-amendments'),
  -- NMC appointment hub S.O. 3261(E) (sibling)
  ('mohfw-so-3261-2020', 'MoHFW', 'S.O. 3261(E)', 2020, 'so-only', '2020-09-24', 'S.O. 3261(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3261', 'nmc-hub-3261-amendments'),
  ('mohfw-so-2008-2021', 'MoHFW', 'S.O. 2008(E)', 2021, 'so-only', '2021-05-24', 'S.O. 2008(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3261', 'nmc-hub-3261-amendments'),
  ('mohfw-so-4359-2025', 'MoHFW', 'S.O. 4359(E)', 2025, 'so-only', '2025-09-17', 'S.O. 4359(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3261', 'nmc-hub-3261-amendments'),
  ('mohfw-so-3924-2025', 'MoHFW', 'S.O. 3924(E)', 2025, 'so-only', '2025-08-27', 'S.O. 3924(E)', 'health-family-welfare', 'nmc-act-2019-appointment-hub-3261', 'nmc-hub-3261-amendments'),
  -- PCPNDT Central Supervisory Board note-chain
  ('mohfw-so-85-1997',   'MoHFW', 'S.O. 85(E)',   1997, 'so-only', '1997-02-05', 'S.O. 85(E)',   'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  ('mohfw-so-4354-2022', 'MoHFW', 'S.O. 4354(E)', 2022, 'so-only', '2022-09-14', 'S.O. 4354(E)', 'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  ('mohfw-so-2937-2024', 'MoHFW', 'S.O. 2937(E)', 2024, 'so-only', '2024-07-15', 'S.O. 2937(E)', 'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  ('mohfw-so-4841-2025', 'MoHFW', 'S.O. 4841(E)', 2025, 'so-only', '2025-10-22', 'S.O. 4841(E)', 'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  ('mohfw-so-5449-2025', 'MoHFW', 'S.O. 5449(E)', 2025, 'so-only', '2025-11-20', 'S.O. 5449(E)', 'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  ('mohfw-so-410-2026',  'MoHFW', 'S.O. 410(E)',  2026, 'so-only', '2026-01-16', 'S.O. 410(E)',  'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  ('mohfw-so-1987-2026', 'MoHFW', 'S.O. 1987(E)', 2026, 'so-only', '2026-04-21', 'S.O. 1987(E)', 'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  ('mohfw-so-2336-2026', 'MoHFW', 'S.O. 2336(E)', 2026, 'so-only', '2026-05-06', 'S.O. 2336(E)', 'health-family-welfare', 'pcpndt-act-1994-central-supervisory-board', 'pcpndt-csb-note-chain'),
  -- National Commission for Allied and Healthcare Professions
  ('mohfw-so-1248-2024', 'MoHFW', 'S.O. 1248(E)', 2024, 'so-only', '2024-03-11', 'S.O. 1248(E)', 'health-family-welfare', 'nca-hp-act-2021-commission', 'nca-hp-commission-amendments'),
  ('mohfw-so-1066-2025', 'MoHFW', 'S.O. 1066(E)', 2025, 'so-only', '2025-02-28', 'S.O. 1066(E)', 'health-family-welfare', 'nca-hp-act-2021-commission', 'nca-hp-commission-amendments'),
  ('mohfw-so-4636-2025', 'MoHFW', 'S.O. 4636(E)', 2025, 'so-only', '2025-10-08', 'S.O. 4636(E)', 'health-family-welfare', 'nca-hp-act-2021-commission', 'nca-hp-commission-amendments'),
  ('mohfw-so-850-2026',  'MoHFW', 'S.O. 850(E)',  2026, 'so-only', '2026-02-17', 'S.O. 850(E)',  'health-family-welfare', 'nca-hp-act-2021-commission', 'nca-hp-commission-amendments'),
  ('mohfw-so-4340-2026', 'MoHFW', 'S.O. 4340(E)', 2026, 'so-only', '2026-07-23', 'S.O. 4340(E)', 'health-family-welfare', 'nca-hp-act-2021-commission', 'nca-hp-commission-amendments'),
  -- CDSCO Drugs Inspectors corrigendum
  ('mohfw-so-2945-2026', 'MoHFW', 'S.O. 2945(E)', 2026, 'so-only', '2026-06-03', 'S.O. 2945(E)', 'health-family-welfare', 'drugs-cosmetics-act-1940', 'cdsco-drugs-inspectors-corrigendum'),
  ('mohfw-so-3617-2026', 'MoHFW', 'S.O. 3617(E)', 2026, 'so-only', '2026-07-02', 'S.O. 3617(E)', 'health-family-welfare', 'drugs-cosmetics-act-1940', 'cdsco-drugs-inspectors-corrigendum'),
  -- Transplantation of Human Organs and Tissues Act rescission
  ('mohfw-so-1372-2024', 'MoHFW', 'S.O. 1372(E)', 2024, 'so-only', '2024-03-15', 'S.O. 1372(E)', 'health-family-welfare', 'transplantation-human-organs-act-1994', 'transplantation-act-rescission'),
  ('mohfw-so-2969-2026', 'MoHFW', 'S.O. 2969(E)', 2026, 'so-only', '2026-06-10', 'S.O. 2969(E)', 'health-family-welfare', 'transplantation-human-organs-act-1994', 'transplantation-act-rescission');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mohfw-gsr-11-2025', 'mohfw-gsr-10-2025', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  -- New Drugs BA/BE draft/corrigendum/final
  ('mohfw-gsr-810-2025', 'mohfw-gsr-587-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-gsr-50-2026', 'mohfw-gsr-587-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-gsr-50-2026', 'mohfw-gsr-810-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- NMC hub S.O. 3260(E) — three independent tracks
  ('mohfw-so-3088-2025', 'mohfw-so-3260-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-4203-2025', 'mohfw-so-3088-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-2036-2021', 'mohfw-so-3260-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-947-2026',  'mohfw-so-2036-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-3925-2025', 'mohfw-so-3260-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-3925-2025', 'mohfw-so-10-2023',   'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- NMC hub S.O. 3261(E) sibling
  ('mohfw-so-2008-2021', 'mohfw-so-3261-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-4359-2025', 'mohfw-so-2008-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-3924-2025', 'mohfw-so-3261-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- PCPNDT CSB note-chain
  ('mohfw-so-4354-2022', 'mohfw-so-85-1997',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-2937-2024', 'mohfw-so-4354-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-4841-2025', 'mohfw-so-2937-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-5449-2025', 'mohfw-so-4841-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-410-2026',  'mohfw-so-5449-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-1987-2026', 'mohfw-so-410-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-2336-2026', 'mohfw-so-1987-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- National Commission for Allied and Healthcare Professions
  ('mohfw-so-1066-2025', 'mohfw-so-1248-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-4636-2025', 'mohfw-so-1066-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-850-2026',  'mohfw-so-4636-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohfw-so-4340-2026', 'mohfw-so-850-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- CDSCO Drugs Inspectors
  ('mohfw-so-3617-2026', 'mohfw-so-2945-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- Transplantation of Human Organs and Tissues Act
  ('mohfw-so-2969-2026', 'mohfw-so-1372-2024', 'rescinds', 'research-agent-quoted', '2026-09-04');
