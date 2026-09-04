-- Ministry of Corporate Affairs. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass. Both known
-- Companies Rules chains confirmed to have no further amendments beyond
-- what was already modeled.
--
-- A large number of further real pairs/chains found across many rule
-- families: Companies (Incorporation) Rules, Companies (Registered
-- Valuers and Valuation) Rules (a full 7-node chain), Companies (Removal
-- of Names) Rules (a full 9-node chain), a Section 458/76A delegation-of-
-- power series (7 real pairs, one a double-target supersession), an LLP
-- Act delegation series, and the IEPFA membership chain (6 nodes).
--
-- Two real leads are explicitly NOT modeled because the research agent's
-- own report flagged them as sourced from the site's AI-generated
-- "Detailed Summary" rather than confirmed in Full Text (the page's
-- extraction was truncated before reaching the citation) — Companies
-- (Accounting Standards) Rules amendment, and the S.O. 698(E) double
-- supersession under Companies Act s.454 — consistent with this
-- project's rule to never treat the summary as a primary source.
--
-- The CSR Policy Rules chain is modeled only up to its last FULLY quoted
-- link (G.S.R. 895(E), 2018) — the Note continues further (a real G.S.R.
-- 526(E) is named but its date was cut off mid-quote by page truncation,
-- and the current 2026 amendment's own predecessor was only named via
-- summary) — left honestly incomplete rather than bridged with an
-- unconfirmed link.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('corporate-affairs', 'Ministry of Corporate Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('companies-act-2013', 'Companies Act, 2013', 2013),
  ('companies-incorporation-rules-2014', 'Companies (Incorporation) Rules, 2014', 2014),
  ('companies-csr-policy-rules-2014', 'Companies (Corporate Social Responsibility Policy) Rules, 2014', 2014),
  ('companies-registered-valuers-rules-2017', 'Companies (Registered Valuers and Valuation) Rules, 2017', 2017),
  ('companies-removal-of-names-rules-2016', 'Companies (Removal of Names of Companies from the Register) Rules, 2016', 2016),
  ('llp-act-2008', 'Limited Liability Partnership Act, 2008', 2008),
  ('iepfa-membership', 'Investor Education and Protection Fund Authority membership', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mca-corrections', 'MCA notification corrigenda', 'active'),
  ('mca-incorporation-rules-amendments', 'Companies (Incorporation) Rules and its amendments', 'active'),
  ('mca-csr-policy-rules-amendments', 'Companies (CSR Policy) Rules and its amendments (partial chain)', 'active'),
  ('mca-registered-valuers-rules-amendments', 'Companies (Registered Valuers and Valuation) Rules and its amendments', 'active'),
  ('mca-removal-of-names-rules-amendments', 'Companies (Removal of Names) Rules and its amendments', 'active'),
  ('mca-s458-delegation-series', 'Companies Act s.458 delegation-of-power amendments (2026-02-10 batch)', 'active'),
  ('mca-llp-delegation-series', 'LLP Act delegation-of-power amendments and supersession', 'active'),
  ('mca-date-substitution-series', 'Companies Act commencement date-substitution pairs (2025-12-30 batch)', 'active'),
  ('mca-iepfa-membership', 'IEPFA membership and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mca-gsr-703-2025', 'MCA', 'G.S.R. 703(E)', 2025, 'so-only', '2025-09-22', 'G.S.R. 703(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-849-2025', 'MCA', 'G.S.R. 849(E)', 2025, 'so-only', '2025-11-17', 'G.S.R. 849(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-268-2014', 'MCA', 'G.S.R. 268(E)', 2014, 'so-only', '2014-03-31', 'G.S.R. 268(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-360-2025', 'MCA', 'G.S.R. 360(E)', 2025, 'so-only', '2025-05-30', 'G.S.R. 360(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-300-2026', 'MCA', 'G.S.R. 300(E)', 2026, 'so-only', '2026-04-21', 'G.S.R. 300(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-259-2014', 'MCA', 'G.S.R. 259(E)', 2014, 'so-only', '2014-03-31', 'G.S.R. 259(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-412-2024', 'MCA', 'G.S.R. 412(E)', 2024, 'so-only', '2024-07-16', 'G.S.R. 412(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-943-2025', 'MCA', 'G.S.R. 943(E)', 2025, 'so-only', '2025-12-31', 'G.S.R. 943(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  -- Companies (Incorporation) Rules chain
  ('mca-gsr-250-2014', 'MCA', 'G.S.R. 250(E)', 2014, 'so-only', '2014-03-31', 'G.S.R. 250(E)', 'corporate-affairs', 'companies-incorporation-rules-2014', 'mca-incorporation-rules-amendments'),
  ('mca-gsr-426-2025', 'MCA', 'G.S.R. 426(E)', 2025, 'so-only', '2025-06-27', 'G.S.R. 426(E)', 'corporate-affairs', 'companies-incorporation-rules-2014', 'mca-incorporation-rules-amendments'),
  ('mca-gsr-579-2025', 'MCA', 'G.S.R. 579(E)', 2025, 'so-only', '2025-08-26', 'G.S.R. 579(E)', 'corporate-affairs', 'companies-incorporation-rules-2014', 'mca-incorporation-rules-amendments'),
  -- CSR Policy Rules chain, partial (real, truncated beyond G.S.R. 895(E))
  ('mca-gsr-129-2014', 'MCA', 'G.S.R. 129(E)', 2014, 'so-only', '2014-02-27', 'G.S.R. 129(E)', 'corporate-affairs', 'companies-csr-policy-rules-2014', 'mca-csr-policy-rules-amendments'),
  ('mca-gsr-644-2014', 'MCA', 'G.S.R. 644(E)', 2014, 'so-only', '2014-09-12', 'G.S.R. 644(E)', 'corporate-affairs', 'companies-csr-policy-rules-2014', 'mca-csr-policy-rules-amendments'),
  ('mca-gsr-43-2015',  'MCA', 'G.S.R. 43(E)',  2015, 'so-only', '2015-01-19', 'G.S.R. 43(E)',  'corporate-affairs', 'companies-csr-policy-rules-2014', 'mca-csr-policy-rules-amendments'),
  ('mca-gsr-540-2016', 'MCA', 'G.S.R. 540(E)', 2016, 'so-only', '2016-05-23', 'G.S.R. 540(E)', 'corporate-affairs', 'companies-csr-policy-rules-2014', 'mca-csr-policy-rules-amendments'),
  ('mca-gsr-895-2018', 'MCA', 'G.S.R. 895(E)', 2018, 'so-only', '2018-09-19', 'G.S.R. 895(E)', 'corporate-affairs', 'companies-csr-policy-rules-2014', 'mca-csr-policy-rules-amendments'),
  -- Companies (Registered Valuers and Valuation) Rules chain
  ('mca-gsr-1316-2017', 'MCA', 'G.S.R. 1316(E)', 2017, 'so-only', '2017-10-18', 'G.S.R. 1316(E)', 'corporate-affairs', 'companies-registered-valuers-rules-2017', 'mca-registered-valuers-rules-amendments'),
  ('mca-gsr-155-2018',  'MCA', 'G.S.R. 155(E)',  2018, 'so-only', '2018-02-09', 'G.S.R. 155(E)',  'corporate-affairs', 'companies-registered-valuers-rules-2017', 'mca-registered-valuers-rules-amendments'),
  ('mca-gsr-559-2018',  'MCA', 'G.S.R. 559(E)',  2018, 'so-only', '2018-06-13', 'G.S.R. 559(E)',  'corporate-affairs', 'companies-registered-valuers-rules-2017', 'mca-registered-valuers-rules-amendments'),
  ('mca-gsr-925-2018',  'MCA', 'G.S.R. 925(E)',  2018, 'so-only', '2018-09-25', 'G.S.R. 925(E)',  'corporate-affairs', 'companies-registered-valuers-rules-2017', 'mca-registered-valuers-rules-amendments'),
  ('mca-gsr-1108-2018', 'MCA', 'G.S.R. 1108(E)', 2018, 'so-only', '2018-11-13', 'G.S.R. 1108(E)', 'corporate-affairs', 'companies-registered-valuers-rules-2017', 'mca-registered-valuers-rules-amendments'),
  ('mca-gsr-831-2022',  'MCA', 'G.S.R. 831(E)',  2022, 'so-only', '2022-11-21', 'G.S.R. 831(E)',  'corporate-affairs', 'companies-registered-valuers-rules-2017', 'mca-registered-valuers-rules-amendments'),
  ('mca-gsr-432-2026',  'MCA', 'G.S.R. 432(E)',  2026, 'so-only', '2026-06-01', 'G.S.R. 432(E)',  'corporate-affairs', 'companies-registered-valuers-rules-2017', 'mca-registered-valuers-rules-amendments'),
  -- Companies (Removal of Names) Rules chain
  ('mca-gsr-1174-2016', 'MCA', 'G.S.R. 1174(E)', 2016, 'so-only', '2016-12-26', 'G.S.R. 1174(E)', 'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-355-2017',  'MCA', 'G.S.R. 355(E)',  2017, 'so-only', '2017-04-12', 'G.S.R. 355(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-350-2019',  'MCA', 'G.S.R. 350(E)',  2019, 'so-only', '2019-05-08', 'G.S.R. 350(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-420-2020',  'MCA', 'G.S.R. 420(E)',  2020, 'so-only', '2020-06-29', 'G.S.R. 420(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-436-2022',  'MCA', 'G.S.R. 436(E)',  2022, 'so-only', '2022-06-09', 'G.S.R. 436(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-658-2022',  'MCA', 'G.S.R. 658(E)',  2022, 'so-only', '2022-08-24', 'G.S.R. 658(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-298-2023',  'MCA', 'G.S.R. 298(E)',  2023, 'so-only', '2023-04-17', 'G.S.R. 298(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-354-2023',  'MCA', 'G.S.R. 354(E)',  2023, 'so-only', '2023-05-10', 'G.S.R. 354(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  ('mca-gsr-940-2025',  'MCA', 'G.S.R. 940(E)',  2025, 'so-only', '2025-12-31', 'G.S.R. 940(E)',  'corporate-affairs', 'companies-removal-of-names-rules-2016', 'mca-removal-of-names-rules-amendments'),
  -- Section 458 delegation series (2026-02-10 batch)
  ('mca-so-3557-2015', 'MCA', 'S.O. 3557(E)', 2015, 'so-only', '2015-12-31', 'S.O. 3557(E)', 'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-701-2026',  'MCA', 'S.O. 701(E)',  2026, 'so-only', '2026-02-10', 'S.O. 701(E)',  'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-891-2015',  'MCA', 'S.O. 891(E)',  2015, 'so-only', '2015-03-31', 'S.O. 891(E)',  'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-699-2026',  'MCA', 'S.O. 699(E)',  2026, 'so-only', '2026-02-10', 'S.O. 699(E)',  'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-1354-2014', 'MCA', 'S.O. 1354(E)', 2014, 'so-only', '2014-05-21', 'S.O. 1354(E)', 'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-700-2026',  'MCA', 'S.O. 700(E)',  2026, 'so-only', '2026-02-10', 'S.O. 700(E)',  'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-2938-2017', 'MCA', 'S.O. 2938(E)', 2017, 'so-only', '2017-09-06', 'S.O. 2938(E)', 'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-707-2026',  'MCA', 'S.O. 707(E)',  2026, 'so-only', '2026-02-10', 'S.O. 707(E)',  'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-4090-2016', 'MCA', 'S.O. 4090(E)', 2016, 'so-only', '2016-12-19', 'S.O. 4090(E)', 'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  ('mca-so-709-2026',  'MCA', 'S.O. 709(E)',  2026, 'so-only', '2026-02-10', 'S.O. 709(E)',  'corporate-affairs', 'companies-act-2013', 'mca-s458-delegation-series'),
  -- LLP Act delegation series
  ('mca-so-623-2022',  'MCA', 'S.O. 623(E)',  2022, 'so-only', '2022-02-11', 'S.O. 623(E)',  'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  ('mca-so-697-2026',  'MCA', 'S.O. 697(E)',  2026, 'so-only', '2026-02-10', 'S.O. 697(E)',  'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  ('mca-so-622-2022',  'MCA', 'S.O. 622(E)',  2022, 'so-only', '2022-02-11', 'S.O. 622(E)',  'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  ('mca-so-696-2026',  'MCA', 'S.O. 696(E)',  2026, 'so-only', '2026-02-10', 'S.O. 696(E)',  'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  ('mca-so-4851-2025', 'MCA', 'S.O. 4851(E)', 2025, 'so-only', '2025-10-23', 'S.O. 4851(E)', 'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  ('mca-so-6114-2025', 'MCA', 'S.O. 6114(E)', 2025, 'so-only', '2025-12-30', 'S.O. 6114(E)', 'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  ('mca-so-4849-2025', 'MCA', 'S.O. 4849(E)', 2025, 'so-only', '2025-10-23', 'S.O. 4849(E)', 'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  ('mca-so-6113-2025', 'MCA', 'S.O. 6113(E)', 2025, 'so-only', '2025-12-30', 'S.O. 6113(E)', 'corporate-affairs', 'llp-act-2008', 'mca-llp-delegation-series'),
  -- Date-substitution series
  ('mca-so-4852-2025', 'MCA', 'S.O. 4852(E)', 2025, 'so-only', '2025-10-23', 'S.O. 4852(E)', 'corporate-affairs', 'companies-act-2013', 'mca-date-substitution-series'),
  ('mca-so-6115-2025', 'MCA', 'S.O. 6115(E)', 2025, 'so-only', '2025-12-30', 'S.O. 6115(E)', 'corporate-affairs', 'companies-act-2013', 'mca-date-substitution-series'),
  ('mca-so-4850-2025', 'MCA', 'S.O. 4850(E)', 2025, 'so-only', '2025-10-23', 'S.O. 4850(E)', 'corporate-affairs', 'companies-act-2013', 'mca-date-substitution-series'),
  ('mca-so-6112-2025', 'MCA', 'S.O. 6112(E)', 2025, 'so-only', '2025-12-30', 'S.O. 6112(E)', 'corporate-affairs', 'companies-act-2013', 'mca-date-substitution-series'),
  -- IEPFA membership chain
  ('mca-so-1647-2016', 'MCA', 'S.O. 1647(E)', 2016, 'so-only', '2016-05-02', 'S.O. 1647(E)', 'corporate-affairs', 'iepfa-membership', 'mca-iepfa-membership'),
  ('mca-so-3756-2017', 'MCA', 'S.O. 3756(E)', 2017, 'so-only', '2017-11-28', 'S.O. 3756(E)', 'corporate-affairs', 'iepfa-membership', 'mca-iepfa-membership'),
  ('mca-so-2282-2020', 'MCA', 'S.O. 2282(E)', 2020, 'so-only', '2020-07-08', 'S.O. 2282(E)', 'corporate-affairs', 'iepfa-membership', 'mca-iepfa-membership'),
  ('mca-so-3455-2024', 'MCA', 'S.O. 3455(E)', 2024, 'so-only', '2024-08-13', 'S.O. 3455(E)', 'corporate-affairs', 'iepfa-membership', 'mca-iepfa-membership'),
  ('mca-so-4333-2024', 'MCA', 'S.O. 4333(E)', 2024, 'so-only', '2024-10-03', 'S.O. 4333(E)', 'corporate-affairs', 'iepfa-membership', 'mca-iepfa-membership'),
  ('mca-so-158-2026',  'MCA', 'S.O. 158(E)',  2026, 'so-only', '2026-01-08', 'S.O. 158(E)',  'corporate-affairs', 'iepfa-membership', 'mca-iepfa-membership');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mca-gsr-849-2025', 'mca-gsr-703-2025', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  ('mca-gsr-360-2025', 'mca-gsr-268-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-300-2026', 'mca-gsr-360-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-412-2024', 'mca-gsr-259-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-943-2025', 'mca-gsr-412-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-426-2025', 'mca-gsr-250-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-579-2025', 'mca-gsr-426-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-644-2014', 'mca-gsr-129-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-43-2015',  'mca-gsr-644-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-540-2016', 'mca-gsr-43-2015',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-895-2018', 'mca-gsr-540-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-155-2018',  'mca-gsr-1316-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-559-2018',  'mca-gsr-155-2018',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-925-2018',  'mca-gsr-559-2018',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-1108-2018', 'mca-gsr-925-2018',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-831-2022',  'mca-gsr-1108-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-432-2026',  'mca-gsr-831-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-355-2017', 'mca-gsr-1174-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-350-2019', 'mca-gsr-355-2017',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-420-2020', 'mca-gsr-350-2019',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-436-2022', 'mca-gsr-420-2020',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-658-2022', 'mca-gsr-436-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-298-2023', 'mca-gsr-658-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-354-2023', 'mca-gsr-298-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-940-2025', 'mca-gsr-354-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-701-2026', 'mca-so-3557-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-699-2026', 'mca-so-891-2015',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-700-2026', 'mca-so-1354-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-707-2026', 'mca-so-2938-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-709-2026', 'mca-so-4090-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-697-2026', 'mca-so-623-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-696-2026', 'mca-so-622-2022', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-6114-2025', 'mca-so-4851-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-6113-2025', 'mca-so-4849-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-6115-2025', 'mca-so-4852-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-6112-2025', 'mca-so-4850-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-3756-2017', 'mca-so-1647-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-2282-2020', 'mca-so-3756-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-3455-2024', 'mca-so-2282-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-4333-2024', 'mca-so-3455-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-so-158-2026',  'mca-so-4333-2024', 'amends', 'research-agent-quoted', '2026-09-04');
