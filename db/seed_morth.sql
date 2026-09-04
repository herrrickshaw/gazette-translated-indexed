-- Ministry of Road Transport and Highways. Deepened 2026-09-04 (depth
-- pass — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass
-- (3 corrigendum pairs, all National Highways Act s.3A/3D land-
-- acquisition).
--
-- Second-ministry pilot seed retained below for the original 3 pairs.
--
-- 5 further new subject areas found this pass, all under the Central
-- Motor Vehicles Rules, 1989 or its adjacent rule-families, all following
-- a draft-to-final rulemaking preamble (`cites`) — Automated Testing
-- Station norms; the Vehicle Scrapping Facility Rules, 2021 (a 5-node
-- chain with two independent draft->final cycles, cross-confirmed by a
-- trailing Note in the second draft); the Third Party Insurance Base
-- Premium and Liability Rules, 2022; a new "Category L2-5" vehicle class
-- (Eighth Amendment Rules, 2024); and a rule 81 registration-fee table
-- amendment (Third Amendment Rules, 2025).
--
-- Real leads NOT modeled: a 2022 Vehicle Scrapping Facility Rules
-- amendment cited only by year inside G.S.R. 57(E)'s own text, no number
-- given; a CMVR Ninth Amendment Rules, 2026 and Twelfth Amendment Rules,
-- 2026 (G.S.R. 712(E)), both real but not opened for exact quotes this
-- pass; National Highways Fee (Determination of Rates and Collection)
-- Rules toll notifications, seen but not confirmed to be amendment chains
-- rather than one-off per-stretch fee notices.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('road-transport-highways', 'Ministry of Road Transport and Highways', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('nh-act-1956-s3a', 'National Highways Act, 1956 — section 3A/3D land acquisition', 1956),
  ('cmvr-1989-ats-norms', 'Central Motor Vehicles Rules, 1989 — Automated Testing Station norms', 1989),
  ('mv-scrapping-facility-rules-2021', 'Motor Vehicles (Registration and Functions of Vehicle Scrapping Facility) Rules, 2021', 2021),
  ('mv-third-party-insurance-rules-2022', 'Motor Vehicles (Third Party Insurance Base Premium and Liability) Rules, 2022', 2022),
  ('cmvr-1989-category-l2-5', 'Central Motor Vehicles Rules, 1989 — "Category L2-5" vehicle class', 1989),
  ('cmvr-1989-rule81-fee-table', 'Central Motor Vehicles Rules, 1989 — rule 81 registration-fee table', 1989);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('morth-land-acquisition-corrections', 'MoRTH land-acquisition notifications and their corrigenda', 'active'),
  ('cmvr-ats-norms-amendment', 'CMVR Automated Testing Station norms amendment', 'active'),
  ('mv-scrapping-facility-amendments', 'Vehicle Scrapping Facility Rules and its amendments', 'active'),
  ('mv-third-party-insurance-amendment', 'Third Party Insurance Base Premium Rules amendment', 'active'),
  ('cmvr-category-l2-5-amendment', 'CMVR "Category L2-5" vehicle-class insertion', 'active'),
  ('cmvr-rule81-fee-amendment', 'CMVR rule 81 registration-fee table amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('morth-so-4872-2025', 'National Highways Act 1956', 'S.O. 4872(E)', 2025, 'so-only', '2025-10-24', 'S.O. 4872(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-4848-2026', 'National Highways Act 1956', 'S.O. 4848(E)', 2026, 'so-only', '2026-09-01', 'S.O. 4848(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-732-2025',  'National Highways Act 1956', 'S.O. 732(E)',  2025, 'so-only', '2025-02-11', 'S.O. 732(E)',  'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-2432-2025', 'National Highways Act 1956', 'S.O. 2432(E)', 2025, 'so-only', '2025-05-30', 'S.O. 2432(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-1265-2018', 'National Highways Act 1956', 'S.O. 1265(E)', 2018, 'so-only', '2018-03-16', 'S.O. 1265(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-4689-2024', 'National Highways Act 1956', 'S.O. 4689(E)', 2024, 'so-only', '2024-10-25', 'S.O. 4689(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  -- CMVR Automated Testing Station norms
  ('morth-gsr-815-2023', 'MoRTH', 'G.S.R. 815(E)', 2023, 'so-only', '2023-11-03', 'G.S.R. 815(E)', 'road-transport-highways', 'cmvr-1989-ats-norms', 'cmvr-ats-norms-amendment'),
  ('morth-gsr-195-2024', 'MoRTH', 'G.S.R. 195(E)', 2024, 'so-only', '2024-03-14', 'G.S.R. 195(E)', 'road-transport-highways', 'cmvr-1989-ats-norms', 'cmvr-ats-norms-amendment'),
  -- Vehicle Scrapping Facility Rules, 2021 (5-node chain)
  ('morth-gsr-653-2021', 'MoRTH', 'G.S.R. 653(E)', 2021, 'so-only', '2021-09-23', 'G.S.R. 653(E)', 'road-transport-highways', 'mv-scrapping-facility-rules-2021', 'mv-scrapping-facility-amendments'),
  ('morth-gsr-57-2024',  'MoRTH', 'G.S.R. 57(E)',  2024, 'so-only', '2024-01-19', 'G.S.R. 57(E)',  'road-transport-highways', 'mv-scrapping-facility-rules-2021', 'mv-scrapping-facility-amendments'),
  ('morth-gsr-212-2024', 'MoRTH', 'G.S.R. 212(E)', 2024, 'so-only', '2024-03-15', 'G.S.R. 212(E)', 'road-transport-highways', 'mv-scrapping-facility-rules-2021', 'mv-scrapping-facility-amendments'),
  ('morth-gsr-548-2025', 'MoRTH', 'G.S.R. 548(E)', 2025, 'so-only', '2025-08-13', 'G.S.R. 548(E)', 'road-transport-highways', 'mv-scrapping-facility-rules-2021', 'mv-scrapping-facility-amendments'),
  ('morth-gsr-700-2025', 'MoRTH', 'G.S.R. 700(E)', 2025, 'so-only', '2025-09-19', 'G.S.R. 700(E)', 'road-transport-highways', 'mv-scrapping-facility-rules-2021', 'mv-scrapping-facility-amendments'),
  -- Third Party Insurance Base Premium Rules, 2022
  ('morth-gsr-394-2022', 'MoRTH', 'G.S.R. 394(E)', 2022, 'so-only', '2022-05-25', 'G.S.R. 394(E)', 'road-transport-highways', 'mv-third-party-insurance-rules-2022', 'mv-third-party-insurance-amendment'),
  ('morth-gsr-441-2023', 'MoRTH', 'G.S.R. 441(E)', 2023, 'so-only', '2023-06-14', 'G.S.R. 441(E)', 'road-transport-highways', 'mv-third-party-insurance-rules-2022', 'mv-third-party-insurance-amendment'),
  ('morth-gsr-32-2024',  'MoRTH', 'G.S.R. 32(E)',  2024, 'so-only', '2024-01-05', 'G.S.R. 32(E)',  'road-transport-highways', 'mv-third-party-insurance-rules-2022', 'mv-third-party-insurance-amendment'),
  -- CMVR "Category L2-5" (Eighth Amendment Rules, 2024)
  ('morth-gsr-150-2024', 'MoRTH', 'G.S.R. 150(E)', 2024, 'so-only', '2024-02-29', 'G.S.R. 150(E)', 'road-transport-highways', 'cmvr-1989-category-l2-5', 'cmvr-category-l2-5-amendment'),
  ('morth-gsr-354-2024', 'MoRTH', 'G.S.R. 354(E)', 2024, 'so-only', '2024-06-26', 'G.S.R. 354(E)', 'road-transport-highways', 'cmvr-1989-category-l2-5', 'cmvr-category-l2-5-amendment'),
  -- CMVR rule 81 fee table (Third Amendment Rules, 2025)
  ('morth-gsr-124-2025', 'MoRTH', 'G.S.R. 124(E)', 2025, 'so-only', '2025-02-07', 'G.S.R. 124(E)', 'road-transport-highways', 'cmvr-1989-rule81-fee-table', 'cmvr-rule81-fee-amendment'),
  ('morth-gsr-568-2025', 'MoRTH', 'G.S.R. 568(E)', 2025, 'so-only', '2025-08-20', 'G.S.R. 568(E)', 'road-transport-highways', 'cmvr-1989-rule81-fee-table', 'cmvr-rule81-fee-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('morth-so-4848-2026', 'morth-so-4872-2025', 'corrigendum', 'primary-source-full-text', '2026-09-03'),
  ('morth-so-2432-2025', 'morth-so-732-2025',  'corrigendum', 'search-index-excerpt',      '2026-09-03'),
  ('morth-so-4689-2024', 'morth-so-1265-2018', 'corrigendum', 'search-index-excerpt',      '2026-09-03'),
  ('morth-gsr-195-2024', 'morth-gsr-815-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-212-2024', 'morth-gsr-57-2024',  'cites', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-212-2024', 'morth-gsr-653-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-548-2025', 'morth-gsr-212-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-548-2025', 'morth-gsr-653-2021', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-700-2025', 'morth-gsr-548-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-700-2025', 'morth-gsr-653-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-32-2024', 'morth-gsr-394-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-32-2024', 'morth-gsr-441-2023', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-354-2024', 'morth-gsr-150-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('morth-gsr-568-2025', 'morth-gsr-124-2025', 'cites', 'research-agent-quoted', '2026-09-04');
