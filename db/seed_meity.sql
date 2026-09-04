-- Ministry of Electronics and Information Technology (MeitY). Deepened
-- 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the
-- original bounded pass (1 pair).
--
-- The already-modeled G.S.R. 120(E)/148(E) corrigendum turned out to sit
-- at the end of a longer real chain: the IT (Intermediary Guidelines and
-- Digital Media Ethics Code) Rules, 2021 principal (G.S.R. 139(E)) with
-- three further amendments before G.S.R. 120(E) itself. The previously
-- deferred G.S.R. 892(E)/G.S.R. 846(E) lead is now closed and extended
-- into a draft-to-final chain (the DPDP Rules, 2025's own draft, G.S.R.
-- 02(E)). 5 further new subject threads found, the richest a 13-node
-- Electronics & IT Goods (Compulsory Registration) Order, 2021 chain, and
-- two examples of a "Note:"-trailer amendment-in-notification shape for
-- Recruitment Rules (Staff Car Drivers; STQC Directorate) — two
-- independent real confirmations of a template this project had deferred
-- designing a dedicated extractor for.
--
-- Real leads NOT modeled: six Recruitment Rules supersessions whose
-- targets are cited by title/year only (including one naming the
-- pre-reorganization "Department of Information Technology" under the
-- erstwhile "Ministry of Communications and Information Technology" —
-- a real historical department-name variant, not an error); Aadhaar-
-- authentication notifications citing only rule numbers and an internal
-- MeitY-UIDAI letter number; a 4-notification Online Gaming Act, 2025
-- commencement cluster, each citing only the parent Act.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('electronics-and-information-technology', 'Ministry of Electronics and Information Technology', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('it-intermediary-guidelines-rules', 'Information Technology (Intermediary Guidelines and Digital Media Ethics Code) Rules', 2021),
  ('dpdp-rules-2025', 'Digital Personal Data Protection Rules, 2025', 2025),
  ('electronics-it-goods-registration-order-2021', 'Electronics and Information Technology Goods (Requirement of Compulsory Registration) Order, 2021', 2021),
  ('it-act-2000-s69a-designated-officer', 'Information Technology Act, 2000 — s.69A Designated Officer', 2000),
  ('meity-staff-car-drivers-recruitment-rules', 'MeitY Staff Car Drivers Recruitment Rules', 2018),
  ('stqc-directorate-recruitment-rules', 'STQC Directorate Joint/Deputy Director Recruitment Rules', 2021);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('meity-corrections', 'MeitY notification corrigenda', 'active'),
  ('it-intermediary-guidelines-amendments', 'IT Intermediary Guidelines and Digital Media Ethics Code Rules and its amendments', 'active'),
  ('dpdp-rules-draft-final', 'DPDP Rules, 2025 draft-to-final and corrigendum', 'active'),
  ('electronics-registration-order-amendments', 'Electronics & IT Goods Compulsory Registration Order and its amendments', 'active'),
  ('it-act-designated-officer-supersession', 's.69A Designated Officer supersession series', 'superseded'),
  ('staff-car-drivers-recruitment-amendment', 'Staff Car Drivers Recruitment Rules amendment', 'active'),
  ('stqc-recruitment-amendment', 'STQC Directorate Recruitment Rules amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- IT Intermediary Guidelines Rules — extended to a 6-node chain
  ('meity-gsr-139-2021', 'MeitY', 'G.S.R. 139(E)', 2021, 'so-only', '2021-02-25', 'G.S.R. 139(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'it-intermediary-guidelines-amendments'),
  ('meity-gsr-794-2022', 'MeitY', 'G.S.R. 794(E)', 2022, 'so-only', '2022-10-28', 'G.S.R. 794(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'it-intermediary-guidelines-amendments'),
  ('meity-gsr-275-2023', 'MeitY', 'G.S.R. 275(E)', 2023, 'so-only', '2023-04-06', 'G.S.R. 275(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'it-intermediary-guidelines-amendments'),
  ('meity-gsr-775-2025', 'MeitY', 'G.S.R. 775(E)', 2025, 'so-only', '2025-10-22', 'G.S.R. 775(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'it-intermediary-guidelines-amendments'),
  ('meity-gsr-120-2026', 'MeitY', 'G.S.R. 120(E)', 2026, 'so-only', '2026-02-10', 'G.S.R. 120(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'it-intermediary-guidelines-amendments'),
  ('meity-gsr-148-2026', 'MeitY', 'G.S.R. 148(E)', 2026, 'so-only', '2026-02-26', 'G.S.R. 148(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'it-intermediary-guidelines-amendments'),
  -- DPDP Rules, 2025 draft-to-final and corrigendum
  ('meity-gsr-02-2025',  'MeitY', 'G.S.R. 02(E)',  2025, 'so-only', '2025-01-03', 'G.S.R. 02(E)',  'electronics-and-information-technology', 'dpdp-rules-2025', 'dpdp-rules-draft-final'),
  ('meity-gsr-846-2025', 'MeitY', 'G.S.R. 846(E)', 2025, 'so-only', '2025-11-13', 'G.S.R. 846(E)', 'electronics-and-information-technology', 'dpdp-rules-2025', 'dpdp-rules-draft-final'),
  ('meity-gsr-892-2025', 'MeitY', 'G.S.R. 892(E)', 2025, 'so-only', '2025-12-10', 'G.S.R. 892(E)', 'electronics-and-information-technology', 'dpdp-rules-2025', 'dpdp-rules-draft-final'),
  -- Electronics & IT Goods Compulsory Registration Order, 2021 — 13-node chain
  ('meity-so-1248-2021', 'MeitY', 'S.O. 1248(E)', 2021, 'so-only', '2021-03-18', 'S.O. 1248(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-1353-2021', 'MeitY', 'S.O. 1353(E)', 2021, 'so-only', '2021-03-25', 'S.O. 1353(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-2844-2021', 'MeitY', 'S.O. 2844(E)', 2021, 'so-only', '2021-07-01', 'S.O. 2844(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-1929-2023', 'MeitY', 'S.O. 1929(E)', 2023, 'so-only', '2023-04-26', 'S.O. 1929(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-1652-2024', 'MeitY', 'S.O. 1652(E)', 2024, 'so-only', '2024-04-09', 'S.O. 1652(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-4378-2024', 'MeitY', 'S.O. 4378(E)', 2024, 'so-only', '2024-10-09', 'S.O. 4378(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-1363-2025', 'MeitY', 'S.O. 1363(E)', 2025, 'so-only', '2025-03-20', 'S.O. 1363(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-4362-2025', 'MeitY', 'S.O. 4362(E)', 2025, 'so-only', '2025-09-22', 'S.O. 4362(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-4997-2025', 'MeitY', 'S.O. 4997(E)', 2025, 'so-only', '2025-10-29', 'S.O. 4997(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-352-2026',  'MeitY', 'S.O. 352(E)',  2026, 'so-only', '2026-01-22', 'S.O. 352(E)',  'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-1246-2026', 'MeitY', 'S.O. 1246(E)', 2026, 'so-only', '2026-03-10', 'S.O. 1246(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-2204-2026', 'MeitY', 'S.O. 2204(E)', 2026, 'so-only', '2026-05-05', 'S.O. 2204(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  ('meity-so-4182-2026', 'MeitY', 'S.O. 4182(E)', 2026, 'so-only', '2026-07-26', 'S.O. 4182(E)', 'electronics-and-information-technology', 'electronics-it-goods-registration-order-2021', 'electronics-registration-order-amendments'),
  -- IT Act s.69A Designated Officer supersession series
  ('meity-so-2056-2025', 'MeitY', 'S.O. 2056(E)', 2025, 'so-only', '2025-05-08', 'S.O. 2056(E)', 'electronics-and-information-technology', 'it-act-2000-s69a-designated-officer', 'it-act-designated-officer-supersession'),
  ('meity-so-4769-2025', 'MeitY', 'S.O. 4769(E)', 2025, 'so-only', '2025-10-21', 'S.O. 4769(E)', 'electronics-and-information-technology', 'it-act-2000-s69a-designated-officer', 'it-act-designated-officer-supersession'),
  ('meity-so-5199-2025', 'MeitY', 'S.O. 5199(E)', 2025, 'so-only', '2025-11-17', 'S.O. 5199(E)', 'electronics-and-information-technology', 'it-act-2000-s69a-designated-officer', 'it-act-designated-officer-supersession'),
  -- Staff Car Drivers Recruitment Rules
  ('meity-gsr-1031-2018', 'MeitY', 'G.S.R. 1031(E)', 2018, 'so-only', '2018-10-09', 'G.S.R. 1031(E)', 'electronics-and-information-technology', 'meity-staff-car-drivers-recruitment-rules', 'staff-car-drivers-recruitment-amendment'),
  ('meity-gsr-594-2025',  'MeitY', 'G.S.R. 594(E)',  2025, 'so-only', '2025-08-28', 'G.S.R. 594(E)',  'electronics-and-information-technology', 'meity-staff-car-drivers-recruitment-rules', 'staff-car-drivers-recruitment-amendment'),
  -- STQC Directorate Recruitment Rules
  ('meity-gsr-468-2021', 'MeitY', 'G.S.R. 468(E)', 2021, 'so-only', '2021-07-01', 'G.S.R. 468(E)', 'electronics-and-information-technology', 'stqc-directorate-recruitment-rules', 'stqc-recruitment-amendment'),
  ('meity-gsr-826-2025', 'MeitY', 'G.S.R. 826(E)', 2025, 'so-only', '2025-11-06', 'G.S.R. 826(E)', 'electronics-and-information-technology', 'stqc-directorate-recruitment-rules', 'stqc-recruitment-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('meity-gsr-148-2026', 'meity-gsr-120-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  -- IT Intermediary Guidelines Rules chain
  ('meity-gsr-794-2022', 'meity-gsr-139-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-gsr-275-2023', 'meity-gsr-794-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-gsr-775-2025', 'meity-gsr-275-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-gsr-120-2026', 'meity-gsr-775-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- DPDP Rules
  ('meity-gsr-892-2025', 'meity-gsr-846-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('meity-gsr-846-2025', 'meity-gsr-02-2025',  'cites', 'research-agent-quoted', '2026-09-04'),
  -- Electronics & IT Goods Compulsory Registration Order
  ('meity-so-1353-2021', 'meity-so-1248-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-2844-2021', 'meity-so-1353-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-1929-2023', 'meity-so-2844-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-1652-2024', 'meity-so-1929-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-4378-2024', 'meity-so-1652-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-1363-2025', 'meity-so-4378-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-4362-2025', 'meity-so-1363-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-4997-2025', 'meity-so-4362-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-352-2026',  'meity-so-4997-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-1246-2026', 'meity-so-352-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-2204-2026', 'meity-so-1246-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-4182-2026', 'meity-so-2204-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- IT Act s.69A Designated Officer
  ('meity-so-4769-2025', 'meity-so-2056-2025', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('meity-so-5199-2025', 'meity-so-4769-2025', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- Recruitment Rules
  ('meity-gsr-594-2025', 'meity-gsr-1031-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('meity-gsr-826-2025', 'meity-gsr-468-2021',  'amends', 'research-agent-quoted', '2026-09-04');
