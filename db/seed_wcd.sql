-- Ministry of Women and Child Development pilot — previously fully
-- deferred (one lead cited a 1979 "then Department of Social Welfare",
-- which the ministry-name scope guard on the other two templates can't
-- match; the other was a Note-chain, which didn't have a template yet).
-- find_note_chain has no ministry-name parameter at all — it matches on
-- "note" and citation syntax alone — so the department-rename problem
-- turned out not to block this template; only the missing tool did.
--
-- Depth pass (2026-09-05): gazettetracker's own tracked corpus is thin (11
-- items); the real expansion came from wcd.gov.in's own consolidated
-- legislation PDFs and archive.org's `in.gazette.central.e.*` mirror.
-- Three new subject threads added: the Juvenile Justice (Care and
-- Protection of Children) Rules 2007->2011->2016->2022 repeal/amendment
-- chain, a POCSO Rules 2020 corrigendum, and the Adoption
-- Guidelines/Regulations 2015->2017 supersession. A Hindi Advisory
-- Committee resolution chain was also found, disambiguated by date since
-- it reuses one File Number as its standing identifier across successive
-- resolutions (unlike S.O./G.S.R. serials).
--
-- Deferred, not modeled this pass (title-only targets, real but failing
-- the "by number and/or date" rule even where the target is independently
-- identifiable): POCSO Rules 2020's repeal of the 2012 Rules (G.S.R.
-- 823(E)); the 2022 Adoption Regulations' supersession of the 2017
-- Regulations (G.S.R. 3(E)); the 2015 Adoption Guidelines' supersession of
-- the 2011 Guidelines (target has no number/date anywhere, not just
-- title-only). Also deferred: two WCD-issued commencement notifications
-- (S.O. 4127(E)/2022, S.O. 1776(E)/2006) that cite Acts published by the
-- Ministry of LAW AND JUSTICE by full number+date — not modeled, applying
-- the same precedent already recorded in seed_tribal_affairs.sql (Law and
-- Justice is out of scope for this project); a body-closure notification
-- citing only "Gazette Notification dated 16.06.2021" with no number,
-- not locatable in the Extraordinary-series sources this pass searched.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('women-child-development', 'Ministry of Women and Child Development', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('charitable-endowments-act-1890', 'Charitable Endowments Act, 1890 — National Children''s Fund', 1890),
  ('ncpcr-rules-2006', 'National Commission for Protection of Child Rights Rules, 2006', 2006),
  ('jj-care-protection-children-rules', 'Juvenile Justice (Care and Protection of Children) Rules', NULL),
  ('pocso-rules-2020', 'Protection of Children from Sexual Offences Rules, 2020', 2020),
  ('adoption-guidelines-regulations', 'Adoption Guidelines/Regulations (Central Adoption Resource Authority)', NULL),
  ('hindi-advisory-committee-resolution', 'Hindi Advisory Committee of the Ministry, membership resolution', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('wcd-national-childrens-fund', 'National Children''s Fund notification and its amendments', 'active'),
  ('wcd-ncpcr-rules-amendments', 'NCPCR Rules and their amendments', 'active'),
  ('wcd-jj-rules-chain', 'Juvenile Justice (Care and Protection of Children) Rules repeal/amendment chain, 2007-2022', 'superseded'),
  ('wcd-pocso-rules-corrigendum', 'POCSO Rules, 2020 and its Hindi-text corrigendum', 'active'),
  ('wcd-adoption-guidelines-regulations', 'Adoption Guidelines 2015 superseded by Adoption Regulations 2017', 'superseded'),
  ('wcd-hindi-advisory-committee', 'Hindi Advisory Committee membership resolutions', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- National Children's Fund chain: S.O. 120(E) [1979, "then Dept. of Social
  -- Welfare" — a real ministry-reorganization case, kept as printed] ->
  -- S.O. 2071 [1980, bare form, pre-dates the modern citation convention] ->
  -- S.O. 1311(E) [2004] -> S.O. 4423(E) [2026, current]
  ('wcd-so-120-1979', 'WCD', 'S.O. 120(E)', 1979, 'so-only', '1979-03-02', 'S.O. 120(E)', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  ('wcd-so-2071-1980', 'WCD', 'S.O. 2071', 1980, 'bare', '1980-07-28', 'S.O. 2071', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  ('wcd-so-1311-2004', 'WCD', 'S.O. 1311(E)', 2004, 'so-only', '2004-11-24', 'S.O. 1311(E)', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  ('wcd-so-4423-2026', 'WCD', 'S.O. 4423(E)', 2026, 'so-only', '2026-06-08', 'S.O. 4423(E)', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  -- NCPCR Rules chain: 450(E) [2006] -> 517(E) [2012] -> 207(E) [Mar 2014]
  -- -> 315(E) [May 2014] -> 613(E) [2021] -> 75(E) [2026, current]. No
  -- founding G.S.R. was captured for the 2006 principal rules themselves —
  -- the chain starts at its first named amendment, not a fabricated origin.
  ('wcd-gsr-450-2006', 'WCD', 'G.S.R. 450(E)', 2006, 'so-only', '2006-07-31', 'G.S.R. 450(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-517-2012', 'WCD', 'G.S.R. 517(E)', 2012, 'so-only', '2012-06-29', 'G.S.R. 517(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-207-2014', 'WCD', 'G.S.R. 207(E)', 2014, 'so-only', '2014-03-24', 'G.S.R. 207(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-315-2014', 'WCD', 'G.S.R. 315(E)', 2014, 'so-only', '2014-05-06', 'G.S.R. 315(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-613-2021', 'WCD', 'G.S.R. 613(E)', 2021, 'so-only', '2021-09-03', 'G.S.R. 613(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-75-2026', 'WCD', 'G.S.R. 75(E)', 2026, 'so-only', '2026-01-30', 'G.S.R. 75(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  -- Juvenile Justice (Care and Protection of Children) Rules chain
  ('wcd-gsr-679-2007', 'WCD', 'G.S.R. 679(E)', 2007, 'so-only', '2007-10-26', 'G.S.R. 679(E)', 'women-child-development', 'jj-care-protection-children-rules', 'wcd-jj-rules-chain'),
  -- cited only via the 2016 Rules' own repeal clause, not independently located
  ('wcd-gsr-903-2011', 'WCD', 'G.S.R. 903(E)', 2011, 'so-only', '2011-12-26', 'G.S.R. 903(E)', 'women-child-development', 'jj-care-protection-children-rules', 'wcd-jj-rules-chain'),
  -- own primary text prints "G.S.R. 898.-" without "(E)"; the 2022 Note calls it "GSR 898(E)" -- same instrument, both forms real
  ('wcd-gsr-898-2016', 'WCD', 'G.S.R. 898', 2016, 'bare', '2016-09-21', 'G.S.R. 898', 'women-child-development', 'jj-care-protection-children-rules', 'wcd-jj-rules-chain'),
  ('wcd-gsr-678-2022', 'WCD', 'G.S.R. 678(E)', 2022, 'so-only', '2022-09-01', 'G.S.R. 678(E)', 'women-child-development', 'jj-care-protection-children-rules', 'wcd-jj-rules-chain'),
  -- POCSO Rules 2020 corrigendum
  ('wcd-gsr-165-2020', 'WCD', 'G.S.R. 165(E)', 2020, 'so-only', '2020-03-09', 'G.S.R. 165(E)', 'women-child-development', 'pocso-rules-2020', 'wcd-pocso-rules-corrigendum'),
  ('wcd-gsr-188-2020', 'WCD', 'G.S.R. 188(E)', 2020, 'so-only', '2020-03-17', 'G.S.R. 188(E)', 'women-child-development', 'pocso-rules-2020', 'wcd-pocso-rules-corrigendum'),
  -- Adoption Guidelines/Regulations supersession
  ('wcd-so-1945-2015', 'WCD', 'S.O. 1945(E)', 2015, 'so-only', '2015-07-17', 'S.O. 1945(E)', 'women-child-development', 'adoption-guidelines-regulations', 'wcd-adoption-guidelines-regulations'),
  ('wcd-gsr-3-2017', 'WCD', 'G.S.R. 3(E)', 2017, 'so-only', '2017-01-04', 'G.S.R. 3(E)', 'women-child-development', 'adoption-guidelines-regulations', 'wcd-adoption-guidelines-regulations'),
  -- Hindi Advisory Committee resolutions -- same File No. reused across dated resolutions, disambiguate by date
  -- 2025 predecessor cited only by number+date in the 2026 text, not independently located
  ('wcd-ol-11011-1-2015-2025', 'WCD', 'F. No. O.L. 11011/1/2015', 2025, 'bare', '2025-09-06', NULL, 'women-child-development', 'hindi-advisory-committee-resolution', 'wcd-hindi-advisory-committee'),
  ('wcd-ol-11011-1-2015-2026', 'WCD', 'F. No. O.L. 11011/1/2015', 2026, 'bare', '2026-07-03', NULL, 'women-child-development', 'hindi-advisory-committee-resolution', 'wcd-hindi-advisory-committee');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('wcd-so-2071-1980', 'wcd-so-120-1979', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-so-1311-2004', 'wcd-so-2071-1980', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-so-4423-2026', 'wcd-so-1311-2004', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-517-2012', 'wcd-gsr-450-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-207-2014', 'wcd-gsr-517-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-315-2014', 'wcd-gsr-207-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-613-2021', 'wcd-gsr-315-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-75-2026', 'wcd-gsr-613-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-898-2016', 'wcd-gsr-679-2007', 'repeals', 'research-agent-quoted', '2026-09-05'),
  ('wcd-gsr-898-2016', 'wcd-gsr-903-2011', 'repeals', 'research-agent-quoted', '2026-09-05'),
  ('wcd-gsr-903-2011', 'wcd-gsr-679-2007', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('wcd-gsr-678-2022', 'wcd-gsr-898-2016', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('wcd-gsr-188-2020', 'wcd-gsr-165-2020', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('wcd-gsr-3-2017', 'wcd-so-1945-2015', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('wcd-ol-11011-1-2015-2026', 'wcd-ol-11011-1-2015-2025', 'amends', 'research-agent-quoted', '2026-09-05');
