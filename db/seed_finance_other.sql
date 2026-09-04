-- Ministry of Finance — departments OTHER than Revenue/CBIC (already
-- modeled separately, see db/seed_cbic.sql). Deepened 2026-09-04 (depth
-- pass — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass
-- (2 pairs). A separate ministry_id from CBIC's ('finance-revenue-cbic'),
-- since the schema stores one department string per ministry_id row and
-- these are a genuinely different department scope (Economic Affairs /
-- Expenditure / Financial Services / DIPAM) under the same real
-- "Ministry of Finance".
--
-- Both items flagged in the first pass are now closed:
--   - The FEMA (Non-debt Instruments) Rules, 2019 chain's 16-item gap is
--     fully closed with the complete real 18-item Note list (20-node
--     chain total: principal + 18 + current).
--   - The cross-department DEA<->DFS "Investment Pattern" lead, previously
--     bare-form and deferred, is now a fully quoted 5-node bare-numbering
--     note-chain (file numbers, no G.S.R./S.O. anywhere in this thread).
--
-- 14 further new subject threads found across DEA/DFS/DIPAM: Government
-- Savings Promotion General Rules, National Savings Scheme Rules
-- (1987 AND 1992, two genuinely distinct instruments), National Savings
-- Recurring Deposit Scheme, Securities Contracts (Regulation) Rules
-- (partial chain, same discipline as FEMA), Insurance Ombudsman Rules,
-- LIC General Rules 1956 (15-node chain, fully quoted, pre-1994 bare
-- numbering throughout its early history), Banking Regulation (Companies)
-- Rules 1949 and (Co-operative Societies) Rules 1966 (both pre-1994 bare
-- numbering chains), Debts Recovery Tribunals fee-refund rules, Recovery
-- of Debts and Bankruptcy Act DRT-jurisdiction (a hub: 2 independent
-- amendments both targeting the same principal directly, not each other),
-- Actuaries Act Tribunal Presiding Officer, a DRAT continuation order
-- (modeled `cites`, not `amends` — it extends an authorization rather
-- than amending rule text), Indian Insurance Companies (Foreign
-- Investment) Rules (chain plus its own draft precursor, `cites`), a DFS
-- rescission of an inadvertently-uploaded duplicate notification, and a
-- DIPAM SUUTI Body of Persons partial supersession.
--
-- REAL CITATION COLLISION: this file's G.S.R. 488(E) [2023-07-03,
-- Government Savings Promotion General Rules] is UNRELATED to Power's
-- G.S.R. 488(E) [2021-07-13, JERC chain, see db/seed_power.sql] — same
-- displayed citation, different real documents, kept as distinct rows
-- (gazette_id prefixed by ministry) per this project's established
-- collision-handling discipline.
--
-- One row's year is a documented judgment call, not a literal primary-text
-- quote: S.O. 5902(E)'s own citing document (S.O. 34(E)) gives only
-- "16th December" with no year in its Full Text; 2025 is inferred from
-- context (S.O. 34(E) itself is signed 31 Dec 2025) rather than fabricated
-- outright, flagged here per the same discipline used for other
-- observed-but-unresolved date oddities in this project.
--
-- Real leads NOT modeled: a corrigendum whose target citation appears only
-- in a login-gated page title, not Full Text; a draft Insurance Rules,
-- 2026 (supersedes the 1939 Rules by name only, no number, still a draft);
-- a draft Insurance Ombudsman (Amendment) Rules, 2025 (not yet effective);
-- a Delegation of Financial Powers Rules, 2024 repeal clause not reached
-- within the sampled text; four Jan Vishwas Act commencement notifications
-- that cite a Schedule serial number, not another gazette notification,
-- and so do not fit this schema's notification-to-notification model.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('finance-other-departments', 'Ministry of Finance', 'Department of Economic Affairs; Department of Expenditure; Department of Financial Services; DIPAM');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('pfms-aadhaar-authentication-rules', 'Public Financial Management System Aadhaar-authentication rules', NULL),
  ('fema-non-debt-instruments-rules-2019', 'FEMA (Non-debt Instruments) Rules, 2019', 2019),
  ('dea-dfs-investment-pattern-notification', 'Cross-department Investment Pattern notification (DFS-originated, DEA-amended)', NULL),
  ('govt-savings-promotion-general-rules-2018', 'Government Savings Promotion General Rules, 2018', 2018),
  ('national-savings-scheme-rules-1992', 'National Savings Scheme Rules, 1992', 1992),
  ('national-savings-scheme-rules-1987', 'National Savings Scheme Rules, 1987', 1987),
  ('national-savings-recurring-deposit-scheme-2019', 'National Savings Recurring Deposit Scheme, 2019', 2019),
  ('securities-contracts-regulation-rules-1957', 'Securities Contracts (Regulation) Rules, 1957', 1957),
  ('insurance-ombudsman-rules-2017', 'Insurance Ombudsman Rules, 2017', 2017),
  ('lic-general-rules-1956', 'Life Insurance Corporation General Rules, 1956', 1956),
  ('banking-regulation-companies-rules-1949', 'Banking Regulation (Companies) Rules, 1949', 1949),
  ('banking-regulation-cooperative-societies-rules-1966', 'Banking Regulation (Co-operative Societies) Rules, 1966', 1966),
  ('drt-refund-court-fees-rules-2013', 'Debts Recovery Tribunals (Refund of Court Fees) Rules, 2013', 2013),
  ('rdb-act-1993-drt-jurisdiction', 'Recovery of Debts and Bankruptcy Act, 1993 — DRT jurisdiction notification', 1993),
  ('actuaries-act-2006-tribunal-presiding-officer', 'Actuaries Act, 2006 — Tribunal Presiding Officer notification', 2006),
  ('rdb-act-1993-drat-continuation-order', 'Recovery of Debts and Bankruptcy Act, 1993 — DRAT continuation order', 1993),
  ('indian-insurance-companies-foreign-investment-rules-2015', 'Indian Insurance Companies (Foreign Investment) Rules, 2015', 2015),
  ('dfs-duplicate-notification-rescission', 'DFS notification rescinded as inadvertently uploaded with incorrect content', NULL),
  ('dipam-suuti-body-of-persons', 'DIPAM — SUUTI Body of Persons constitution', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('pfms-aadhaar-corrigendum', 'PFMS Aadhaar-authentication rules corrigendum', 'active'),
  ('fema-non-debt-instruments-amendments', 'FEMA Non-debt Instruments Rules and its amendments', 'active'),
  ('dea-dfs-investment-pattern-chain', 'Cross-department Investment Pattern notification chain', 'active'),
  ('govt-savings-promotion-amendments', 'Government Savings Promotion General Rules and its amendments', 'active'),
  ('nss-1992-amendments', 'National Savings Scheme Rules, 1992 and its amendments', 'active'),
  ('nss-1987-supersession', 'National Savings Scheme Rules, 1987 supersession', 'superseded'),
  ('nsrds-2019-amendments', 'National Savings Recurring Deposit Scheme, 2019 and its amendments', 'active'),
  ('scr-rules-1957-amendments', 'Securities Contracts (Regulation) Rules, 1957 amendments', 'active'),
  ('insurance-ombudsman-amendments', 'Insurance Ombudsman Rules, 2017 and its amendments', 'active'),
  ('lic-general-rules-amendments', 'LIC General Rules, 1956 and its amendments', 'active'),
  ('banking-regulation-companies-amendments', 'Banking Regulation (Companies) Rules, 1949 and its amendments', 'active'),
  ('banking-regulation-cooperative-amendments', 'Banking Regulation (Co-operative Societies) Rules, 1966 and its amendments', 'active'),
  ('drt-fee-refund-amendment', 'Debts Recovery Tribunals fee-refund rules amendment', 'active'),
  ('rdb-drt-jurisdiction-hub', 'DRT jurisdiction notification, amended independently by two later notifications', 'active'),
  ('actuaries-tribunal-officer-amendment', 'Actuaries Act Tribunal Presiding Officer amendment', 'active'),
  ('rdb-drat-continuation', 'DRAT continuation order', 'active'),
  ('insurance-foreign-investment-amendments', 'Indian Insurance Companies (Foreign Investment) Rules and its amendments', 'active'),
  ('dfs-duplicate-rescission', 'DFS duplicate-upload rescission', 'superseded'),
  ('dipam-suuti-body-supersession', 'DIPAM SUUTI Body of Persons partial supersession', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- PFMS (unchanged)
  ('mof-gsr-859-2025', 'MoF', 'G.S.R. 859(E)', 2025, 'so-only', '2025-11-21', 'G.S.R. 859(E)', 'finance-other-departments', 'pfms-aadhaar-authentication-rules', 'pfms-aadhaar-corrigendum'),
  ('mof-gsr-580-2026', 'MoF', 'G.S.R. 580(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 580(E)', 'finance-other-departments', 'pfms-aadhaar-authentication-rules', 'pfms-aadhaar-corrigendum'),
  -- FEMA Non-debt Instruments Rules, 2019 (20-node chain, gap closed)
  ('mof-so-3732-2019', 'MoF', 'S.O. 3732(E)', 2019, 'so-only', '2019-10-17', 'S.O. 3732(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-4355-2019', 'MoF', 'S.O. 4355(E)', 2019, 'so-only', '2019-12-05', 'S.O. 4355(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-1278-2020', 'MoF', 'S.O. 1278(E)', 2020, 'so-only', '2020-04-22', 'S.O. 1278(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-1374-2020', 'MoF', 'S.O. 1374(E)', 2020, 'so-only', '2020-04-27', 'S.O. 1374(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-2442-2020', 'MoF', 'S.O. 2442(E)', 2020, 'so-only', '2020-07-27', 'S.O. 2442(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-4441-2020', 'MoF', 'S.O. 4441(E)', 2020, 'so-only', '2020-12-08', 'S.O. 4441(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-3206-2021', 'MoF', 'S.O. 3206(E)', 2021, 'so-only', '2021-08-09', 'S.O. 3206(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-3411-2021', 'MoF', 'S.O. 3411(E)', 2021, 'so-only', '2021-08-19', 'S.O. 3411(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-4091-2021', 'MoF', 'S.O. 4091(E)', 2021, 'so-only', '2021-10-05', 'S.O. 4091(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-4242-2021', 'MoF', 'S.O. 4242(E)', 2021, 'so-only', '2021-10-12', 'S.O. 4242(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-1802-2022', 'MoF', 'S.O. 1802(E)', 2022, 'so-only', '2022-04-12', 'S.O. 1802(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-332-2024',  'MoF', 'S.O. 332(E)',  2024, 'so-only', '2024-01-24', 'S.O. 332(E)',  'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-1361-2024', 'MoF', 'S.O. 1361(E)', 2024, 'so-only', '2024-03-14', 'S.O. 1361(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-1722-2024', 'MoF', 'S.O. 1722(E)', 2024, 'so-only', '2024-04-16', 'S.O. 1722(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-3492-2024', 'MoF', 'S.O. 3492(E)', 2024, 'so-only', '2024-08-16', 'S.O. 3492(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-2549-2025', 'MoF', 'S.O. 2549(E)', 2025, 'so-only', '2025-06-11', 'S.O. 2549(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-2174-2026', 'MoF', 'S.O. 2174(E)', 2026, 'so-only', '2026-05-02', 'S.O. 2174(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-2186-2026', 'MoF', 'S.O. 2186(E)', 2026, 'so-only', '2026-05-02', 'S.O. 2186(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-3030-2026', 'MoF', 'S.O. 3030(E)', 2026, 'so-only', '2026-06-12', 'S.O. 3030(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  ('mof-so-4870-2026', 'MoF', 'S.O. 4870(E)', 2026, 'so-only', '2026-09-03', 'S.O. 4870(E)', 'finance-other-departments', 'fema-non-debt-instruments-rules-2019', 'fema-non-debt-instruments-amendments'),
  -- Cross-department Investment Pattern chain (bare, no G.S.R./S.O.)
  ('mof-invpat-2015-03', 'MoF', 'No. 11/14/2013-PR', NULL, 'bare', '2015-03-02', 'No. 11/14/2013-PR', 'finance-other-departments', 'dea-dfs-investment-pattern-notification', 'dea-dfs-investment-pattern-chain'),
  ('mof-invpat-2019-02', 'MoF', 'No. 11/14/2013-PR', NULL, 'bare', '2019-02-12', 'No. 11/14/2013-PR', 'finance-other-departments', 'dea-dfs-investment-pattern-notification', 'dea-dfs-investment-pattern-chain'),
  ('mof-invpat-2019-12', 'MoF', 'No. 10/41/2018-PM (Part-2)', NULL, 'bare', '2019-12-11', 'No. 10/41/2018-PM (Part-2)', 'finance-other-departments', 'dea-dfs-investment-pattern-notification', 'dea-dfs-investment-pattern-chain'),
  ('mof-invpat-2021-03', 'MoF', 'No. 1/8/2021-PM', NULL, 'bare', '2021-03-15', 'No. 1/8/2021-PM', 'finance-other-departments', 'dea-dfs-investment-pattern-notification', 'dea-dfs-investment-pattern-chain'),
  ('mof-invpat-2026-09', 'MoF', 'F. No. 1/8/2021-PM-Part(1)', NULL, 'bare', '2026-09-02', 'F. No. 1/8/2021-PM-Part(1)', 'finance-other-departments', 'dea-dfs-investment-pattern-notification', 'dea-dfs-investment-pattern-chain'),
  -- Government Savings Promotion General Rules, 2018
  ('mof-gsr-1003-2018', 'MoF', 'G.S.R. 1003(E)', 2018, 'so-only', '2018-10-05', 'G.S.R. 1003(E)', 'finance-other-departments', 'govt-savings-promotion-general-rules-2018', 'govt-savings-promotion-amendments'),
  ('mof-gsr-238-2023',  'MoF', 'G.S.R. 238(E)',  2023, 'so-only', '2023-03-31', 'G.S.R. 238(E)',  'finance-other-departments', 'govt-savings-promotion-general-rules-2018', 'govt-savings-promotion-amendments'),
  ('mof-gsr-488-2023',  'MoF', 'G.S.R. 488(E)',  2023, 'so-only', '2023-07-03', 'G.S.R. 488(E)',  'finance-other-departments', 'govt-savings-promotion-general-rules-2018', 'govt-savings-promotion-amendments'),
  ('mof-gsr-214-2025',  'MoF', 'G.S.R. 214(E)',  2025, 'so-only', '2025-04-02', 'G.S.R. 214(E)',  'finance-other-departments', 'govt-savings-promotion-general-rules-2018', 'govt-savings-promotion-amendments'),
  -- National Savings Scheme Rules, 1992
  ('mof-gsr-763-1992', 'MoF', 'G.S.R. 763(E)', 1992, 'so-only', '1992-09-15', 'G.S.R. 763(E)', 'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  ('mof-gsr-46-2000',  'MoF', 'G.S.R. 46(E)',  2000, 'so-only', '2000-01-15', 'G.S.R. 46(E)',  'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  ('mof-gsr-541-2000', 'MoF', 'G.S.R. 541(E)', 2000, 'so-only', '2000-06-14', 'G.S.R. 541(E)', 'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  ('mof-gsr-154-2001', 'MoF', 'G.S.R. 154(E)', 2001, 'so-only', '2001-03-01', 'G.S.R. 154(E)', 'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  ('mof-gsr-162-2002', 'MoF', 'G.S.R. 162(E)', 2002, 'so-only', '2002-03-01', 'G.S.R. 162(E)', 'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  ('mof-gsr-710-2002', 'MoF', 'G.S.R. 710(E)', 2002, 'so-only', '2002-10-17', 'G.S.R. 710(E)', 'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  ('mof-gsr-178-2003', 'MoF', 'G.S.R. 178(E)', 2003, 'so-only', '2003-03-01', 'G.S.R. 178(E)', 'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  ('mof-gsr-537-2024', 'MoF', 'G.S.R. 537(E)', 2024, 'so-only', '2024-09-05', 'G.S.R. 537(E)', 'finance-other-departments', 'national-savings-scheme-rules-1992', 'nss-1992-amendments'),
  -- National Savings Scheme Rules, 1987 (supersession)
  ('mof-gsr-177-2003', 'MoF', 'G.S.R. 177(E)', 2003, 'so-only', '2003-03-01', 'G.S.R. 177(E)', 'finance-other-departments', 'national-savings-scheme-rules-1987', 'nss-1987-supersession'),
  ('mof-gsr-538-2024', 'MoF', 'G.S.R. 538(E)', 2024, 'so-only', '2024-09-05', 'G.S.R. 538(E)', 'finance-other-departments', 'national-savings-scheme-rules-1987', 'nss-1987-supersession'),
  -- National Savings Recurring Deposit Scheme, 2019
  ('mof-gsr-918-2019', 'MoF', 'G.S.R. 918(E)', 2019, 'so-only', '2019-12-12', 'G.S.R. 918(E)', 'finance-other-departments', 'national-savings-recurring-deposit-scheme-2019', 'nsrds-2019-amendments'),
  ('mof-gsr-285-2020', 'MoF', 'G.S.R. 285(E)', 2020, 'so-only', '2020-05-05', 'G.S.R. 285(E)', 'finance-other-departments', 'national-savings-recurring-deposit-scheme-2019', 'nsrds-2019-amendments'),
  ('mof-gsr-330-2023', 'MoF', 'G.S.R. 330(E)', 2023, 'so-only', '2023-04-27', 'G.S.R. 330(E)', 'finance-other-departments', 'national-savings-recurring-deposit-scheme-2019', 'nsrds-2019-amendments'),
  ('mof-gsr-621-2023', 'MoF', 'G.S.R. 621(E)', 2023, 'so-only', '2023-08-23', 'G.S.R. 621(E)', 'finance-other-departments', 'national-savings-recurring-deposit-scheme-2019', 'nsrds-2019-amendments'),
  ('mof-gsr-818-2023', 'MoF', 'G.S.R. 818(E)', 2023, 'so-only', '2023-11-03', 'G.S.R. 818(E)', 'finance-other-departments', 'national-savings-recurring-deposit-scheme-2019', 'nsrds-2019-amendments'),
  -- Securities Contracts (Regulation) Rules, 1957 (partial chain + 2 direct edges)
  ('mof-sro-576-1957', 'MoF', 'S.R.O. 576', 1957, 'bare', '1957-02-21', 'S.R.O. 576', 'finance-other-departments', 'securities-contracts-regulation-rules-1957', 'scr-rules-1957-amendments'),
  ('mof-gsr-664-2017', 'MoF', 'G.S.R. 664(E)', 2017, 'so-only', '2017-06-27', 'G.S.R. 664(E)', 'finance-other-departments', 'securities-contracts-regulation-rules-1957', 'scr-rules-1957-amendments'),
  ('mof-gsr-318-2025', 'MoF', 'G.S.R. 318(E)', 2025, 'so-only', '2025-05-19', 'G.S.R. 318(E)', 'finance-other-departments', 'securities-contracts-regulation-rules-1957', 'scr-rules-1957-amendments'),
  ('mof-gsr-518-2024', 'MoF', 'G.S.R. 518(E)', 2024, 'so-only', '2024-08-28', 'G.S.R. 518(E)', 'finance-other-departments', 'securities-contracts-regulation-rules-1957', 'scr-rules-1957-amendments'),
  ('mof-gsr-184-2026', 'MoF', 'G.S.R. 184(E)', 2026, 'so-only', '2026-03-13', 'G.S.R. 184(E)', 'finance-other-departments', 'securities-contracts-regulation-rules-1957', 'scr-rules-1957-amendments'),
  -- Insurance Ombudsman Rules, 2017
  ('mof-gsr-413-2017', 'MoF', 'G.S.R. 413(E)', 2017, 'so-only', '2017-04-25', 'G.S.R. 413(E)', 'finance-other-departments', 'insurance-ombudsman-rules-2017', 'insurance-ombudsman-amendments'),
  ('mof-gsr-785-2018', 'MoF', 'G.S.R. 785(E)', 2018, 'so-only', '2018-08-20', 'G.S.R. 785(E)', 'finance-other-departments', 'insurance-ombudsman-rules-2017', 'insurance-ombudsman-amendments'),
  ('mof-gsr-147-2021', 'MoF', 'G.S.R. 147(E)', 2021, 'so-only', '2021-03-02', 'G.S.R. 147(E)', 'finance-other-departments', 'insurance-ombudsman-rules-2017', 'insurance-ombudsman-amendments'),
  ('mof-gsr-334-2021', 'MoF', 'G.S.R. 334(E)', 2021, 'so-only', '2021-05-18', 'G.S.R. 334(E)', 'finance-other-departments', 'insurance-ombudsman-rules-2017', 'insurance-ombudsman-amendments'),
  ('mof-gsr-828-2023', 'MoF', 'G.S.R. 828(E)', 2023, 'so-only', '2023-11-09', 'G.S.R. 828(E)', 'finance-other-departments', 'insurance-ombudsman-rules-2017', 'insurance-ombudsman-amendments'),
  -- LIC General Rules, 1956 (15-node chain, fully quoted)
  ('mof-sro-1889a-1956', 'MoF', 'S.R.O. 1889A', 1956, 'bare', '1956-08-28', 'S.R.O. 1889A', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-317-1958',   'MoF', 'G.S.R. 317',   1958, 'bare', '1958-04-30', 'G.S.R. 317',   'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-1101-1958',  'MoF', 'G.S.R. 1101',  1958, 'bare', '1958-11-08', 'G.S.R. 1101',  'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-1568-1964',  'MoF', 'G.S.R. 1568',  1964, 'bare', '1964-10-23', 'G.S.R. 1568',  'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-1094-1965',  'MoF', 'G.S.R. 1094',  1965, 'bare', '1965-07-22', 'G.S.R. 1094',  'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-1116-1988',  'MoF', 'G.S.R. 1116',  1988, 'bare', '1988-12-02', 'G.S.R. 1116',  'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-278-1997',   'MoF', 'G.S.R. 278(E)', 1997, 'so-only', '1997-05-28', 'G.S.R. 278(E)', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-474-2004',   'MoF', 'G.S.R. 474(E)', 2004, 'so-only', '2004-07-23', 'G.S.R. 474(E)', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-669-2006',   'MoF', 'G.S.R. 669(E)', 2006, 'so-only', '2006-10-26', 'G.S.R. 669(E)', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-2-2012',     'MoF', 'G.S.R. 2',     2012, 'bare', '2012-01-03', 'G.S.R. 2',     'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-199-2015',   'MoF', 'G.S.R. 199',   2015, 'bare', '2015-10-14', 'G.S.R. 199',   'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-96-2020',    'MoF', 'G.S.R. 96(E)', 2020, 'so-only', '2020-02-10', 'G.S.R. 96(E)', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-460-2021',   'MoF', 'G.S.R. 460(E)', 2021, 'so-only', '2021-06-30', 'G.S.R. 460(E)', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-171-2022',   'MoF', 'G.S.R. 171(E)', 2022, 'so-only', '2022-03-03', 'G.S.R. 171(E)', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  ('mof-gsr-59-2026',    'MoF', 'G.S.R. 59(E)', 2026, 'so-only', '2026-01-27', 'G.S.R. 59(E)', 'finance-other-departments', 'lic-general-rules-1956', 'lic-general-rules-amendments'),
  -- Banking Regulation (Companies) Rules, 1949 (bare pre-1994 chain)
  ('mof-f4-55-f1-49',   'MoF', 'F.4(55)-F-1/49',   1949, 'bare', '1949-03-26', 'F.4(55)-F-1/49',   'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f4-93-f1-50',   'MoF', 'F.4(93)-F.1/50',   1951, 'bare', '1951-04-20', 'F.4(93)-F.1/50',   'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-d6037-f1-52',   'MoF', 'D.6037-F.1/52',    1952, 'bare', '1952-11-17', 'D.6037-F.1/52',    'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f4-6-f1-54',    'MoF', 'F.4(6)-F.1/54',    1954, 'bare', '1954-11-24', 'F.4(6)-F.1/54',    'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f4-86-bc-10',   'MoF', 'F.4(86)-BC/10',    1961, 'bare', '1961-06-23', 'F.4(86)-BC/10',    'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f16-1-bc-63',   'MoF', 'F.16(1)-BC/63',    1964, 'bare', '1964-05-20', 'F.16(1)-BC/63',    'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f16-6-bc-64',   'MoF', 'F.16(6)-BC/64',    1965, 'bare', '1965-07-03', 'F.16(6)-BC/64',    'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f16-1-bc-69',   'MoF', 'F.16(1)-BC/69',    1969, 'bare', '1969-02-01', 'F.16(1)-BC/69',    'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f3-4-74-bo1',   'MoF', 'F.3/4/74-BO.1',    1975, 'bare', '1975-11-15', 'F.3/4/74-BO.1',    'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-f1-16-84-boi',  'MoF', 'F.1/16/84-B.O.I',  1985, 'bare', '1985-03-29', 'F.1/16/84-B.O.I',  'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  ('mof-gsr-890-2025',  'MoF', 'G.S.R. 890(E)',    2025, 'so-only', '2025-12-10', 'G.S.R. 890(E)', 'finance-other-departments', 'banking-regulation-companies-rules-1949', 'banking-regulation-companies-amendments'),
  -- Banking Regulation (Co-operative Societies) Rules, 1966 (bare pre-1994 chain)
  ('mof-gsr-1837-1966', 'MoF', 'G.S.R. 1837',       1966, 'bare', '1966-12-03', 'G.S.R. 1837',       'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  ('mof-f101-66-sb',    'MoF', 'F.101/66-SB',       1967, 'bare', '1967-10-18', 'F.101/66-SB',       'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  ('mof-f18-9-68-sb',   'MoF', 'F.18/No.9/68-SB',   1969, 'bare', '1969-10-30', 'F.18/No.9/68-SB',   'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  ('mof-f1-26-71-ac2',  'MoF', 'F.1-26/71/AC-II',   1974, 'bare', '1974-05-23', 'F.1-26/71/AC-II',   'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  ('mof-8-18-77-ac',    'MoF', '8/18/77-AC',        1979, 'bare', '1979-01-31', '8/18/77-AC',        'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  ('mof-8-9-80-ac',     'MoF', '8(9)/80-AC',        1983, 'bare', '1983-02-07', '8(9)/80-AC',        'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  ('mof-f1-22-84-boi',  'MoF', 'F.1/22/84-B.O-I',   1985, 'bare', '1985-03-29', 'F.1/22/84-B.O-I',   'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  ('mof-gsr-891-2025',  'MoF', 'G.S.R. 891(E)',     2025, 'so-only', '2025-12-10', 'G.S.R. 891(E)',  'finance-other-departments', 'banking-regulation-cooperative-societies-rules-1966', 'banking-regulation-cooperative-amendments'),
  -- Debts Recovery Tribunals (Refund of Court Fees) Rules, 2013
  ('mof-gsr-311-2013', 'MoF', 'G.S.R. 311(E)', 2013, 'so-only', '2013-05-15', 'G.S.R. 311(E)', 'finance-other-departments', 'drt-refund-court-fees-rules-2013', 'drt-fee-refund-amendment'),
  ('mof-gsr-372-2026', 'MoF', 'G.S.R. 372(E)', 2026, 'so-only', '2026-05-19', 'G.S.R. 372(E)', 'finance-other-departments', 'drt-refund-court-fees-rules-2013', 'drt-fee-refund-amendment'),
  -- Recovery of Debts and Bankruptcy Act, 1993 — DRT jurisdiction hub
  ('mof-so-4312-2018', 'MoF', 'S.O. 4312(E)', 2018, 'so-only', '2018-09-06', 'S.O. 4312(E)', 'finance-other-departments', 'rdb-act-1993-drt-jurisdiction', 'rdb-drt-jurisdiction-hub'),
  ('mof-so-2478-2019', 'MoF', 'S.O. 2478(E)', 2019, 'so-only', '2019-07-11', 'S.O. 2478(E)', 'finance-other-departments', 'rdb-act-1993-drt-jurisdiction', 'rdb-drt-jurisdiction-hub'),
  ('mof-so-1796-2024', 'MoF', 'S.O. 1796(E)', 2024, 'so-only', '2024-04-25', 'S.O. 1796(E)', 'finance-other-departments', 'rdb-act-1993-drt-jurisdiction', 'rdb-drt-jurisdiction-hub'),
  -- Actuaries Act, 2006 — Tribunal Presiding Officer
  ('mof-so-1654-2026', 'MoF', 'S.O. 1654(E)', 2026, 'so-only', '2026-03-30', 'S.O. 1654(E)', 'finance-other-departments', 'actuaries-act-2006-tribunal-presiding-officer', 'actuaries-tribunal-officer-amendment'),
  ('mof-so-2670-2026', 'MoF', 'S.O. 2670(E)', 2026, 'so-only', '2026-05-27', 'S.O. 2670(E)', 'finance-other-departments', 'actuaries-act-2006-tribunal-presiding-officer', 'actuaries-tribunal-officer-amendment'),
  -- DRAT continuation order (cites)
  ('mof-so-1058-2024', 'MoF', 'S.O. 1058(E)', 2024, 'so-only', '2024-03-05', 'S.O. 1058(E)', 'finance-other-departments', 'rdb-act-1993-drat-continuation-order', 'rdb-drat-continuation'),
  ('mof-so-3872-2026', 'MoF', 'S.O. 3872(E)', 2026, 'so-only', '2026-07-14', 'S.O. 3872(E)', 'finance-other-departments', 'rdb-act-1993-drat-continuation-order', 'rdb-drat-continuation'),
  -- Indian Insurance Companies (Foreign Investment) Rules, 2015 (chain + draft precursor)
  ('mof-gsr-115-2015', 'MoF', 'G.S.R. 115(E)', 2015, 'so-only', '2015-02-19', 'G.S.R. 115(E)', 'finance-other-departments', 'indian-insurance-companies-foreign-investment-rules-2015', 'insurance-foreign-investment-amendments'),
  ('mof-gsr-534-2015', 'MoF', 'G.S.R. 534(E)', 2015, 'so-only', '2015-07-03', 'G.S.R. 534(E)', 'finance-other-departments', 'indian-insurance-companies-foreign-investment-rules-2015', 'insurance-foreign-investment-amendments'),
  ('mof-gsr-314-2016', 'MoF', 'G.S.R. 314(E)', 2016, 'so-only', '2016-03-16', 'G.S.R. 314(E)', 'finance-other-departments', 'indian-insurance-companies-foreign-investment-rules-2015', 'insurance-foreign-investment-amendments'),
  ('mof-gsr-619-2019', 'MoF', 'G.S.R. 619(E)', 2019, 'so-only', '2019-09-02', 'G.S.R. 619(E)', 'finance-other-departments', 'indian-insurance-companies-foreign-investment-rules-2015', 'insurance-foreign-investment-amendments'),
  ('mof-gsr-337-2021', 'MoF', 'G.S.R. 337(E)', 2021, 'so-only', '2021-05-19', 'G.S.R. 337(E)', 'finance-other-departments', 'indian-insurance-companies-foreign-investment-rules-2015', 'insurance-foreign-investment-amendments'),
  ('mof-gsr-591-2025', 'MoF', 'G.S.R. 591(E)', 2025, 'so-only', '2025-08-29', 'G.S.R. 591(E)', 'finance-other-departments', 'indian-insurance-companies-foreign-investment-rules-2015', 'insurance-foreign-investment-amendments'),
  ('mof-gsr-928-2025', 'MoF', 'G.S.R. 928(E)', 2025, 'so-only', '2025-12-30', 'G.S.R. 928(E)', 'finance-other-departments', 'indian-insurance-companies-foreign-investment-rules-2015', 'insurance-foreign-investment-amendments'),
  -- DFS duplicate-upload rescission (year on the target is a documented inference, see header comment)
  ('mof-so-5902-2025', 'MoF', 'S.O. 5902(E)', 2025, 'so-only', '2025-12-16', 'S.O. 5902(E)', 'finance-other-departments', 'dfs-duplicate-notification-rescission', 'dfs-duplicate-rescission'),
  ('mof-so-34-2026',   'MoF', 'S.O. 34(E)',   2026, 'so-only', '2026-01-05', 'S.O. 34(E)',   'finance-other-departments', 'dfs-duplicate-notification-rescission', 'dfs-duplicate-rescission'),
  -- DIPAM SUUTI Body of Persons
  ('mof-so-3467-2021', 'MoF', 'S.O. 3467(E)', 2021, 'so-only', '2021-11-09', 'S.O. 3467(E)', 'finance-other-departments', 'dipam-suuti-body-of-persons', 'dipam-suuti-body-supersession'),
  ('mof-so-4336-2024', 'MoF', 'S.O. 4336(E)', 2024, 'so-only', '2024-10-04', 'S.O. 4336(E)', 'finance-other-departments', 'dipam-suuti-body-of-persons', 'dipam-suuti-body-supersession');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mof-gsr-580-2026', 'mof-gsr-859-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- FEMA chain (19 edges)
  ('mof-so-4355-2019', 'mof-so-3732-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-1278-2020', 'mof-so-4355-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-1374-2020', 'mof-so-1278-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-2442-2020', 'mof-so-1374-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-4441-2020', 'mof-so-2442-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-3206-2021', 'mof-so-4441-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-3411-2021', 'mof-so-3206-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-4091-2021', 'mof-so-3411-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-4242-2021', 'mof-so-4091-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-1802-2022', 'mof-so-4242-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-332-2024',  'mof-so-1802-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-1361-2024', 'mof-so-332-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-1722-2024', 'mof-so-1361-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-3492-2024', 'mof-so-1722-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-2549-2025', 'mof-so-3492-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-2174-2026', 'mof-so-2549-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-2186-2026', 'mof-so-2174-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-3030-2026', 'mof-so-2186-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-4870-2026', 'mof-so-3030-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Investment Pattern chain
  ('mof-invpat-2019-02', 'mof-invpat-2015-03', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-invpat-2019-12', 'mof-invpat-2019-02', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-invpat-2021-03', 'mof-invpat-2019-12', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-invpat-2026-09', 'mof-invpat-2021-03', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Government Savings Promotion General Rules, 2018
  ('mof-gsr-238-2023', 'mof-gsr-1003-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-488-2023', 'mof-gsr-238-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-214-2025', 'mof-gsr-488-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- National Savings Scheme Rules, 1992
  ('mof-gsr-46-2000',  'mof-gsr-763-1992', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-541-2000', 'mof-gsr-46-2000',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-154-2001', 'mof-gsr-541-2000', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-162-2002', 'mof-gsr-154-2001', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-710-2002', 'mof-gsr-162-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-178-2003', 'mof-gsr-710-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-537-2024', 'mof-gsr-178-2003', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- National Savings Scheme Rules, 1987
  ('mof-gsr-538-2024', 'mof-gsr-177-2003', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- National Savings Recurring Deposit Scheme, 2019
  ('mof-gsr-285-2020', 'mof-gsr-918-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-330-2023', 'mof-gsr-285-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-621-2023', 'mof-gsr-330-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-818-2023', 'mof-gsr-621-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Securities Contracts (Regulation) Rules, 1957
  ('mof-gsr-664-2017', 'mof-sro-576-1957', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-318-2025', 'mof-gsr-664-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-518-2024', 'mof-sro-576-1957', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-184-2026', 'mof-sro-576-1957', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Insurance Ombudsman Rules, 2017
  ('mof-gsr-785-2018', 'mof-gsr-413-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-147-2021', 'mof-gsr-785-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-334-2021', 'mof-gsr-147-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-828-2023', 'mof-gsr-334-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- LIC General Rules, 1956
  ('mof-gsr-317-1958',  'mof-sro-1889a-1956', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-1101-1958', 'mof-gsr-317-1958',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-1568-1964', 'mof-gsr-1101-1958',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-1094-1965', 'mof-gsr-1568-1964',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-1116-1988', 'mof-gsr-1094-1965',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-278-1997',  'mof-gsr-1116-1988',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-474-2004',  'mof-gsr-278-1997',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-669-2006',  'mof-gsr-474-2004',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-2-2012',    'mof-gsr-669-2006',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-199-2015',  'mof-gsr-2-2012',     'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-96-2020',   'mof-gsr-199-2015',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-460-2021',  'mof-gsr-96-2020',    'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-171-2022',  'mof-gsr-460-2021',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-59-2026',   'mof-gsr-171-2022',   'amends', 'research-agent-quoted', '2026-09-04'),
  -- Banking Regulation (Companies) Rules, 1949
  ('mof-f4-93-f1-50',  'mof-f4-55-f1-49',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-d6037-f1-52',  'mof-f4-93-f1-50',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f4-6-f1-54',   'mof-d6037-f1-52',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f4-86-bc-10',  'mof-f4-6-f1-54',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f16-1-bc-63',  'mof-f4-86-bc-10',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f16-6-bc-64',  'mof-f16-1-bc-63',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f16-1-bc-69',  'mof-f16-6-bc-64',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f3-4-74-bo1',  'mof-f16-1-bc-69',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f1-16-84-boi', 'mof-f3-4-74-bo1',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-890-2025', 'mof-f1-16-84-boi', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Banking Regulation (Co-operative Societies) Rules, 1966
  ('mof-f101-66-sb',   'mof-gsr-1837-1966', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f18-9-68-sb',  'mof-f101-66-sb',    'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f1-26-71-ac2', 'mof-f18-9-68-sb',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-8-18-77-ac',   'mof-f1-26-71-ac2',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-8-9-80-ac',    'mof-8-18-77-ac',    'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-f1-22-84-boi', 'mof-8-9-80-ac',     'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-891-2025', 'mof-f1-22-84-boi',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- Debts Recovery Tribunals fee-refund rules
  ('mof-gsr-372-2026', 'mof-gsr-311-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- DRT jurisdiction hub (both amend the principal directly)
  ('mof-so-2478-2019', 'mof-so-4312-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-so-1796-2024', 'mof-so-4312-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Actuaries Act Tribunal Presiding Officer
  ('mof-so-2670-2026', 'mof-so-1654-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- DRAT continuation order
  ('mof-so-3872-2026', 'mof-so-1058-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Indian Insurance Companies (Foreign Investment) Rules, 2015
  ('mof-gsr-534-2015', 'mof-gsr-115-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-314-2016', 'mof-gsr-534-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-619-2019', 'mof-gsr-314-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-337-2021', 'mof-gsr-619-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-928-2025', 'mof-gsr-337-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mof-gsr-928-2025', 'mof-gsr-591-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- DFS duplicate rescission
  ('mof-so-34-2026', 'mof-so-5902-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  -- DIPAM SUUTI Body of Persons
  ('mof-so-4336-2024', 'mof-so-3467-2021', 'supersedes', 'research-agent-quoted', '2026-09-04');
