-- Ministry of Labour and Employment. Deepened 2026-09-04 (depth pass —
-- see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (1 pair).
--
-- All three deferred leads from the first pass are now CONFIRMED via
-- primary text fetched directly from egazette.gov.in (gazettetracker.com's
-- Full Text/Summary panels are login-walled site-wide, confirmed this
-- pass). ONE CITATION CORRECTION: the third lead was previously
-- mis-recorded as "G.S.R. 706(E)" — its real, primary-text-confirmed
-- number is G.S.R. 705(E) (703/704/705 are a same-day sequential block,
-- gazette issue Nos. 639/640/641; 706 does not exist in this set) — the
-- same kind of correction already applied to Ayush's S.O.221(E)/G.S.R.
-- 221(E) case earlier in this project.
--
-- 9 further new pairs/chains found: a second corrigendum to the EPS
-- Scheme (making G.S.R. 527(E) a small hub); a 3-generation EPF
-- inspection-charge chain (bare pre-2001 numbering for its oldest links);
-- Aadhaar-authentication and 12%-contribution-rate supersessions; a
-- Hindi-text-only corrigendum to the Social Security Central Rules; a
-- Code on Social Security enforcement corrigendum that also cites an
-- unrelated exception-carve-out notification; and two Directorate General
-- of Mines Safety byelaw rescissions — this project's first `rescinds`
-- pairs for this ministry.
--
-- REAL EXTRACTION GAP found (not fixed this batch, flagged for later):
-- G.S.R. 748(E) and G.S.R. 446(E) are entirely Hindi-language documents
-- with no English rendering — real, valid corrigenda the current
-- English-only extract/labour_patterns.py would silently miss.
--
-- Real leads NOT modeled: G.S.R. 525(E)/526(E)/527(E) each supersede a
-- named pre-2026 Scheme (1952/1976/1971&1995) by title only, no number;
-- S.O. 4710(E)/S.O. 4711(E) are a substantively linked companion pair
-- (bonus-calculation) but neither cites the other's number anywhere in
-- its own text, so no cross_reference is modeled for it.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('labour-and-employment', 'Ministry of Labour and Employment', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('code-on-wages-2019', 'Code on Wages, 2019', 2019),
  ('epf-scheme-2026', 'Employees'' Provident Funds Scheme, 2026', 2026),
  ('eps-scheme-2026', 'Employees'' Pension Scheme, 2026', 2026),
  ('edli-scheme-2026', 'Employees'' Deposit-Linked Insurance Scheme, 2026', 2026),
  ('epf-inspection-charge-rates', 'EPF/EDLI exempted-establishment inspection-charge rates', 1998),
  ('shram-suvidha-portal-aadhaar-authentication', 'Shram Suvidha Portal Aadhaar-authentication notification', 2026),
  ('epf-contribution-rate-css-2020', 'Code on Social Security, 2020 — EPF employer contribution rate', 2020),
  ('social-security-central-rules-2026', 'Social Security (Central) Rules, 2026', 2026),
  ('css-2020-enforcement-so-5319', 'Code on Social Security, 2020 — enforcement notification S.O. 5319(E)', 2020),
  ('metalliferous-mines-regulations-1961-gas-testing', 'Metalliferous Mines Regulations, 1961 — Gas Testing Certificate byelaws', 1961),
  ('coal-mines-regulations-2017-byelaws', 'Coal Mines Regulations, 2017 — byelaws', 2017);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('labour-corrections', 'Ministry of Labour and Employment notification corrigenda', 'active'),
  ('epf-scheme-2026-corrigendum', 'EPF Scheme, 2026 corrigendum', 'active'),
  ('eps-scheme-2026-corrigenda', 'EPS Scheme, 2026 — two independent corrigenda', 'active'),
  ('edli-scheme-2026-corrigendum', 'EDLI Scheme, 2026 corrigendum', 'active'),
  ('epf-inspection-charge-chain', 'EPF/EDLI inspection-charge rate chain', 'active'),
  ('shram-suvidha-aadhaar-supersession', 'Shram Suvidha Portal Aadhaar-authentication supersession', 'active'),
  ('epf-contribution-rate-supersession', 'EPF employer contribution-rate supersession', 'active'),
  ('social-security-rules-hindi-corrigendum', 'Social Security Central Rules Hindi-text corrigendum', 'active'),
  ('css-enforcement-corrigendum', 'Code on Social Security enforcement corrigendum and cross-citation', 'active'),
  ('dgms-gas-testing-rescission', 'DGMS Gas Testing Certificate byelaws rescission', 'superseded'),
  ('dgms-coal-mines-rescission', 'DGMS Coal Mines Regulations byelaws rescission', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('labour-so-2455-2026', 'Labour', 'S.O. 2455(E)', 2026, 'so-only', '2026-05-12', 'S.O. 2455(E)', 'labour-and-employment', 'code-on-wages-2019', 'labour-corrections'),
  ('labour-so-4573-2026', 'Labour', 'S.O. 4573(E)', 2026, 'so-only', '2026-08-19', 'S.O. 4573(E)', 'labour-and-employment', 'code-on-wages-2019', 'labour-corrections'),
  -- EPF/EPS/EDLI Scheme 2026 corrigenda
  ('labour-gsr-525-2026', 'Labour', 'G.S.R. 525(E)', 2026, 'so-only', '2026-06-29', 'G.S.R. 525(E)', 'labour-and-employment', 'epf-scheme-2026', 'epf-scheme-2026-corrigendum'),
  ('labour-gsr-703-2026', 'Labour', 'G.S.R. 703(E)', 2026, 'so-only', '2026-08-04', 'G.S.R. 703(E)', 'labour-and-employment', 'epf-scheme-2026', 'epf-scheme-2026-corrigendum'),
  ('labour-gsr-527-2026', 'Labour', 'G.S.R. 527(E)', 2026, 'so-only', '2026-06-29', 'G.S.R. 527(E)', 'labour-and-employment', 'eps-scheme-2026', 'eps-scheme-2026-corrigenda'),
  ('labour-gsr-704-2026', 'Labour', 'G.S.R. 704(E)', 2026, 'so-only', '2026-08-04', 'G.S.R. 704(E)', 'labour-and-employment', 'eps-scheme-2026', 'eps-scheme-2026-corrigenda'),
  ('labour-gsr-748-2026', 'Labour', 'G.S.R. 748(E)', 2026, 'so-only', '2026-08-20', 'G.S.R. 748(E)', 'labour-and-employment', 'eps-scheme-2026', 'eps-scheme-2026-corrigenda'),
  ('labour-gsr-526-2026', 'Labour', 'G.S.R. 526(E)', 2026, 'so-only', '2026-06-29', 'G.S.R. 526(E)', 'labour-and-employment', 'edli-scheme-2026', 'edli-scheme-2026-corrigendum'),
  ('labour-gsr-705-2026', 'Labour', 'G.S.R. 705(E)', 2026, 'so-only', '2026-08-04', 'G.S.R. 705(E)', 'labour-and-employment', 'edli-scheme-2026', 'edli-scheme-2026-corrigendum'),
  -- EPF inspection-charge rate chain
  ('labour-so-1436-1998', 'Labour', 'S.O. 1436', 1998, 'bare', '1998-07-09', 'S.O. 1436', 'labour-and-employment', 'epf-inspection-charge-rates', 'epf-inspection-charge-chain'),
  ('labour-so-238-1998',  'Labour', 'S.O. 238',  1998, 'bare', '1998-01-11', 'S.O. 238',  'labour-and-employment', 'epf-inspection-charge-rates', 'epf-inspection-charge-chain'),
  ('labour-so-2701-2026', 'Labour', 'S.O. 2701(E)', 2026, 'so-only', '2026-05-29', 'S.O. 2701(E)', 'labour-and-employment', 'epf-inspection-charge-rates', 'epf-inspection-charge-chain'),
  ('labour-so-4602-2026', 'Labour', 'S.O. 4602(E)', 2026, 'so-only', '2026-08-20', 'S.O. 4602(E)', 'labour-and-employment', 'epf-inspection-charge-rates', 'epf-inspection-charge-chain'),
  -- Shram Suvidha Portal Aadhaar authentication
  ('labour-so-2523-2026', 'Labour', 'S.O. 2523(E)', 2026, 'so-only', '2026-05-15', 'S.O. 2523(E)', 'labour-and-employment', 'shram-suvidha-portal-aadhaar-authentication', 'shram-suvidha-aadhaar-supersession'),
  ('labour-so-4831-2026', 'Labour', 'S.O. 4831(E)', 2026, 'so-only', '2026-08-24', 'S.O. 4831(E)', 'labour-and-employment', 'shram-suvidha-portal-aadhaar-authentication', 'shram-suvidha-aadhaar-supersession'),
  -- EPF contribution rate
  ('labour-so-320-1997', 'Labour', 'S.O. 320(E)', 1997, 'so-only', '1997-04-09', 'S.O. 320(E)', 'labour-and-employment', 'epf-contribution-rate-css-2020', 'epf-contribution-rate-supersession'),
  ('labour-so-3582-2026', 'Labour', 'S.O. 3582(E)', 2026, 'so-only', '2026-07-01', 'S.O. 3582(E)', 'labour-and-employment', 'epf-contribution-rate-css-2020', 'epf-contribution-rate-supersession'),
  -- Social Security Central Rules Hindi-text corrigendum
  ('labour-gsr-344-2026', 'Labour', 'G.S.R. 344(E)', 2026, 'so-only', '2026-05-08', 'G.S.R. 344(E)', 'labour-and-employment', 'social-security-central-rules-2026', 'social-security-rules-hindi-corrigendum'),
  ('labour-gsr-446-2026', 'Labour', 'G.S.R. 446(E)', 2026, 'so-only', '2026-06-05', 'G.S.R. 446(E)', 'labour-and-employment', 'social-security-central-rules-2026', 'social-security-rules-hindi-corrigendum'),
  -- Code on Social Security enforcement corrigendum
  ('labour-so-5319-2025', 'Labour', 'S.O. 5319(E)', 2025, 'so-only', '2025-11-21', 'S.O. 5319(E)', 'labour-and-employment', 'css-2020-enforcement-so-5319', 'css-enforcement-corrigendum'),
  ('labour-so-5936-2025', 'Labour', 'S.O. 5936(E)', 2025, 'so-only', '2025-12-19', 'S.O. 5936(E)', 'labour-and-employment', 'css-2020-enforcement-so-5319', 'css-enforcement-corrigendum'),
  ('labour-so-2060-2023', 'Labour', 'S.O. 2060(E)', 2023, 'so-only', '2023-05-03', 'S.O. 2060(E)', 'labour-and-employment', 'css-2020-enforcement-so-5319', 'css-enforcement-corrigendum'),
  -- DGMS rescissions
  ('labour-gsr-492-2025', 'Labour', 'G.S.R. 492(E)', 2025, 'so-only', '2025-07-22', 'G.S.R. 492(E)', 'labour-and-employment', 'metalliferous-mines-regulations-1961-gas-testing', 'dgms-gas-testing-rescission'),
  ('labour-gsr-188-2026', 'Labour', 'G.S.R. 188(E)', 2026, 'so-only', '2026-03-16', 'G.S.R. 188(E)', 'labour-and-employment', 'metalliferous-mines-regulations-1961-gas-testing', 'dgms-gas-testing-rescission'),
  ('labour-gsr-491-2025', 'Labour', 'G.S.R. 491(E)', 2025, 'so-only', '2025-07-22', 'G.S.R. 491(E)', 'labour-and-employment', 'coal-mines-regulations-2017-byelaws', 'dgms-coal-mines-rescission'),
  ('labour-gsr-187-2026', 'Labour', 'G.S.R. 187(E)', 2026, 'so-only', '2026-03-16', 'G.S.R. 187(E)', 'labour-and-employment', 'coal-mines-regulations-2017-byelaws', 'dgms-coal-mines-rescission');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('labour-so-4573-2026', 'labour-so-2455-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  ('labour-gsr-703-2026', 'labour-gsr-525-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('labour-gsr-704-2026', 'labour-gsr-527-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('labour-gsr-748-2026', 'labour-gsr-527-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('labour-gsr-705-2026', 'labour-gsr-526-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('labour-so-2701-2026', 'labour-so-1436-1998', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('labour-so-2701-2026', 'labour-so-238-1998',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('labour-so-4602-2026', 'labour-so-2701-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('labour-so-4831-2026', 'labour-so-2523-2026', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('labour-so-3582-2026', 'labour-so-320-1997',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('labour-gsr-446-2026', 'labour-gsr-344-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('labour-so-5936-2025', 'labour-so-5319-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('labour-so-5936-2025', 'labour-so-2060-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('labour-gsr-188-2026', 'labour-gsr-492-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('labour-gsr-187-2026', 'labour-gsr-491-2025', 'rescinds', 'research-agent-quoted', '2026-09-04');
