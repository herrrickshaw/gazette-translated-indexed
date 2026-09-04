-- Ministry of Home Affairs. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (1 pair).
--
-- Both deferred leads from the first pass are now confirmed: S.O. 4583(E)
-- is a real one-to-many notification (rescinds two orders outright,
-- disapplies a third in specific states/UTs, modeled `cites` for the
-- scoped disapplication since it is neither a full rescission nor an
-- amendment); the "Amendment to Resolution" bare-file-number shape is
-- confirmed real and now has TWO independent instances (a Parliamentary
-- Committee Resolution corrigendum and an Inter-State Council Secretariat
-- supersession).
--
-- 13 further new pairs/chains found across Citizenship/CAA, FCRA/FCRR (a
-- rich Note-chain — the concrete example this project needed to confirm
-- the trailing-Note template design), three separate "Immigration and
-- Foreigners" instruments (Rules, and two distinct Orders one digit
-- apart), five standalone corrigenda, and a genuinely novel "Whereas...
-- Whereas..." UAPA Tribunal-confirmation preamble citing two prior
-- notifications.
--
-- REAL DATA-QUALITY FLAGS carried over from the research pass (not
-- modeling issues, provenance notes): gazettetracker.com's own subject
-- line for one corrigendum called it a match for the already-modeled
-- S.O. 3987(E), but its Full Text's actual target is the unrelated S.O.
-- 3986(E) (a mountaineering-peaks schedule, one digit apart, different
-- subject) — modeled per Full Text, not the site's own label. Two 2026
-- Citizenship Rules amendments (G.S.R. 323(E), G.S.R. 369(E)) share the
-- identical short title "Citizenship (Amendment) Rules, 2026" — a
-- title collision, not a number collision. G.S.R. 369(E)'s own trailing
-- Note omits G.S.R. 323(E) (which predates it) from its recited history —
-- a real gap in the Ministry's own drafting, not bridged here; 323(E) is
-- modeled as a parallel direct amendment to the principal rather than
-- forced into 369(E)'s incomplete chain.
--
-- Real leads NOT modeled: a CRPF Sub-Inspector Recruitment Rules
-- supersession whose target is cited by title/year only; multiple NIA
-- Special Court designations with no cross-reference language at all;
-- S.O. 1730(E) (a 2019 LTTE ban), mentioned only in embedded witness
-- testimony rather than the citing document's own operative preamble.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('home-affairs', 'Ministry of Home Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('mha-notifications-general', 'MHA notifications (various subject matter)', NULL),
  ('mha-immigration-posts-order', 'Immigration posts list Order (S.O. 3987(E) instrument)', NULL),
  ('mha-mountaineering-peaks-schedule', 'Mountaineering peaks/restricted-area schedule Order', NULL),
  ('citizenship-act-1955-s6b-caa', 'Citizenship Act, 1955 s.6B — CAA disapplication/rescission', 1955),
  ('foreign-contribution-regulation-rules-2011', 'Foreign Contribution (Regulation) Rules, 2011', 2011),
  ('fcra-compounding-offences-notification', 'FCRA compounding-of-offences notification', 2022),
  ('citizenship-rules-2009', 'Citizenship Rules, 2009', 2009),
  ('immigration-foreigners-rules-2025', 'Immigration and Foreigners Rules, 2025', 2025),
  ('inter-state-council-secretariat-notification', 'Inter-State Council Secretariat notification', 2019),
  ('parliamentary-committee-resolution-hindi', 'Parliamentary Standing Committee member Resolution (Hindi text)', 2025),
  ('uapa-tribunal-confirmation-lte', 'UAPA Tribunal confirmation — LTTE ban', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mha-amendments', 'MHA notification amendments', 'active'),
  ('mha-immigration-posts-corrigenda', 'Immigration posts list corrigenda', 'active'),
  ('mha-caa-disapplication-rescission', 'CAA-related disapplication and rescission (S.O. 4583(E))', 'active'),
  ('mha-corrigenda-standalone', 'Standalone MHA corrigendum pairs', 'active'),
  ('mha-mountaineering-peaks-corrigendum', 'Mountaineering peaks schedule corrigendum', 'active'),
  ('fcrr-2011-amendments', 'Foreign Contribution (Regulation) Rules, 2011 and its amendments', 'active'),
  ('fcra-compounding-amendments', 'FCRA compounding-of-offences notification and its amendments', 'active'),
  ('citizenship-rules-2009-amendments', 'Citizenship Rules, 2009 and its amendments', 'active'),
  ('immigration-foreigners-rules-amendment', 'Immigration and Foreigners Rules, 2025 amendment', 'active'),
  ('inter-state-council-supersession', 'Inter-State Council Secretariat notification supersession', 'superseded'),
  ('parliamentary-resolution-corrigendum', 'Parliamentary Committee Resolution Hindi-text corrigendum', 'active'),
  ('uapa-tribunal-lte-confirmation', 'UAPA Tribunal confirmation citing two prior notifications', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mha-so-3987-2025', 'MHA', 'S.O. 3987(E)', 2025, 'so-only', '2025-09-01', 'S.O. 3987(E)', 'home-affairs', 'mha-immigration-posts-order', 'mha-amendments'),
  ('mha-so-3778-2026', 'MHA', 'S.O. 3778(E)', 2026, 'so-only', '2026-07-10', 'S.O. 3778(E)', 'home-affairs', 'mha-immigration-posts-order', 'mha-amendments'),
  ('mha-so-4087-2025', 'MHA', 'S.O. 4087(E)', 2025, 'so-only', '2025-09-09', 'S.O. 4087(E)', 'home-affairs', 'mha-immigration-posts-order', 'mha-immigration-posts-corrigenda'),
  -- S.O. 4583(E) one-to-many disapplication/rescission
  ('mha-so-1231-2024', 'MHA', 'S.O. 1231(E)', 2024, 'so-only', '2024-03-11', 'S.O. 1231(E)', 'home-affairs', 'citizenship-act-1955-s6b-caa', 'mha-caa-disapplication-rescission'),
  ('mha-so-941-2026',  'MHA', 'S.O. 941(E)',  2026, 'so-only', '2026-02-20', 'S.O. 941(E)',  'home-affairs', 'citizenship-act-1955-s6b-caa', 'mha-caa-disapplication-rescission'),
  ('mha-so-1110-2026', 'MHA', 'S.O. 1110(E)', 2026, 'so-only', '2026-03-02', 'S.O. 1110(E)', 'home-affairs', 'citizenship-act-1955-s6b-caa', 'mha-caa-disapplication-rescission'),
  ('mha-so-4583-2026', 'MHA', 'S.O. 4583(E)', 2026, 'so-only', '2026-08-19', 'S.O. 4583(E)', 'home-affairs', 'citizenship-act-1955-s6b-caa', 'mha-caa-disapplication-rescission'),
  -- Standalone corrigendum pairs
  ('mha-so-5401-2023', 'MHA', 'S.O. 5401(E)', 2023, 'so-only', '2023-12-21', 'S.O. 5401(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-so-147-2024',  'MHA', 'S.O. 147(E)',  2024, 'so-only', '2024-01-11', 'S.O. 147(E)',  'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-so-2696-2023', 'MHA', 'S.O. 2696(E)', 2023, 'so-only', '2023-06-20', 'S.O. 2696(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-so-3477-2023', 'MHA', 'S.O. 3477(E)', 2023, 'so-only', '2023-07-26', 'S.O. 3477(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-gsr-388-2023', 'MHA', 'G.S.R. 388(E)', 2023, 'so-only', '2023-05-25', 'G.S.R. 388(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-gsr-581-2023', 'MHA', 'G.S.R. 581(E)', 2023, 'so-only', '2023-07-31', 'G.S.R. 581(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-gsr-03-2025',  'MHA', 'G.S.R. 03(E)',  2025, 'so-only', '2025-01-03', 'G.S.R. 03(E)',  'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-gsr-118-2025', 'MHA', 'G.S.R. 118(E)', 2025, 'so-only', '2025-02-04', 'G.S.R. 118(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-gsr-856-2023', 'MHA', 'G.S.R. 856(E)', 2023, 'so-only', '2023-11-21', 'G.S.R. 856(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  ('mha-gsr-133-2025', 'MHA', 'G.S.R. 133(E)', 2025, 'so-only', '2025-02-12', 'G.S.R. 133(E)', 'home-affairs', 'mha-notifications-general', 'mha-corrigenda-standalone'),
  -- Mountaineering peaks corrigendum (distinct from S.O. 3987(E))
  ('mha-so-3986-2025', 'MHA', 'S.O. 3986(E)', 2025, 'so-only', '2025-09-01', 'S.O. 3986(E)', 'home-affairs', 'mha-mountaineering-peaks-schedule', 'mha-mountaineering-peaks-corrigendum'),
  ('mha-so-4104-2025', 'MHA', 'S.O. 4104(E)', 2025, 'so-only', '2025-09-10', 'S.O. 4104(E)', 'home-affairs', 'mha-mountaineering-peaks-schedule', 'mha-mountaineering-peaks-corrigendum'),
  -- FCRR 2011 (12-node note-chain)
  ('mha-gsr-349-2011', 'MHA', 'G.S.R. 349(E)', 2011, 'so-only', '2011-04-29', 'G.S.R. 349(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-292-2012', 'MHA', 'G.S.R. 292(E)', 2012, 'so-only', '2012-04-12', 'G.S.R. 292(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-966-2015', 'MHA', 'G.S.R. 966(E)', 2015, 'so-only', '2015-12-14', 'G.S.R. 966(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-199-2019', 'MHA', 'G.S.R. 199(E)', 2019, 'so-only', '2019-03-07', 'G.S.R. 199(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-659-2019', 'MHA', 'G.S.R. 659(E)', 2019, 'so-only', '2019-09-16', 'G.S.R. 659(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-695-2020', 'MHA', 'G.S.R. 695(E)', 2020, 'so-only', '2020-11-10', 'G.S.R. 695(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-17-2021',  'MHA', 'G.S.R. 17(E)',  2021, 'so-only', '2021-01-11', 'G.S.R. 17(E)',  'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-506-2022', 'MHA', 'G.S.R. 506(E)', 2022, 'so-only', '2022-07-01', 'G.S.R. 506(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-683-2023', 'MHA', 'G.S.R. 683(E)', 2023, 'so-only', '2023-09-22', 'G.S.R. 683(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-790-2024', 'MHA', 'G.S.R. 790(E)', 2024, 'so-only', '2024-12-31', 'G.S.R. 790(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-gsr-342-2025', 'MHA', 'G.S.R. 342(E)', 2025, 'so-only', '2025-05-26', 'G.S.R. 342(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  ('mha-so-3272-2026', 'MHA', 'S.O. 3272(E)', 2026, 'so-only', '2026-06-22', 'S.O. 3272(E)', 'home-affairs', 'foreign-contribution-regulation-rules-2011', 'fcrr-2011-amendments'),
  -- FCRA compounding-of-offences notification
  ('mha-so-3025-2022', 'MHA', 'S.O. 3025(E)', 2022, 'so-only', '2022-07-01', 'S.O. 3025(E)', 'home-affairs', 'fcra-compounding-offences-notification', 'fcra-compounding-amendments'),
  ('mha-so-778-2023',  'MHA', 'S.O. 778(E)',  2023, 'so-only', '2023-02-20', 'S.O. 778(E)',  'home-affairs', 'fcra-compounding-offences-notification', 'fcra-compounding-amendments'),
  ('mha-so-3287-2026', 'MHA', 'S.O. 3287(E)', 2026, 'so-only', '2026-06-22', 'S.O. 3287(E)', 'home-affairs', 'fcra-compounding-offences-notification', 'fcra-compounding-amendments'),
  -- Citizenship Rules, 2009 (hub, with a documented real gap — see header)
  ('mha-gsr-124-2009',  'MHA', 'G.S.R. 124(E)',  2009, 'so-only', '2009-02-25', 'G.S.R. 124(E)',  'home-affairs', 'citizenship-rules-2009', 'citizenship-rules-2009-amendments'),
  ('mha-gsr-1158-2018', 'MHA', 'G.S.R. 1158(E)', 2018, 'so-only', '2018-12-03', 'G.S.R. 1158(E)', 'home-affairs', 'citizenship-rules-2009', 'citizenship-rules-2009-amendments'),
  ('mha-gsr-172-2024',  'MHA', 'G.S.R. 172(E)',  2024, 'so-only', '2024-03-11', 'G.S.R. 172(E)',  'home-affairs', 'citizenship-rules-2009', 'citizenship-rules-2009-amendments'),
  ('mha-gsr-323-2026',  'MHA', 'G.S.R. 323(E)',  2026, 'so-only', '2026-04-30', 'G.S.R. 323(E)',  'home-affairs', 'citizenship-rules-2009', 'citizenship-rules-2009-amendments'),
  ('mha-gsr-369-2026',  'MHA', 'G.S.R. 369(E)',  2026, 'so-only', '2026-05-18', 'G.S.R. 369(E)',  'home-affairs', 'citizenship-rules-2009', 'citizenship-rules-2009-amendments'),
  ('mha-gsr-742-2026',  'MHA', 'G.S.R. 742(E)',  2026, 'so-only', '2026-08-19', 'G.S.R. 742(E)',  'home-affairs', 'citizenship-rules-2009', 'citizenship-rules-2009-amendments'),
  -- Immigration and Foreigners Rules, 2025 (third distinct MHA immigration instrument)
  ('mha-gsr-596-2025', 'MHA', 'G.S.R. 596(E)', 2025, 'so-only', '2025-09-01', 'G.S.R. 596(E)', 'home-affairs', 'immigration-foreigners-rules-2025', 'immigration-foreigners-rules-amendment'),
  ('mha-gsr-424-2026', 'MHA', 'G.S.R. 424(E)', 2026, 'so-only', '2026-06-01', 'G.S.R. 424(E)', 'home-affairs', 'immigration-foreigners-rules-2025', 'immigration-foreigners-rules-amendment'),
  -- Inter-State Council Secretariat (bare file-number supersession)
  ('mha-file-1-7-2019-isc', 'MHA', 'No. 1/7/2019-ISC', 2022, 'bare', '2022-05-19', 'No. 1/7/2019-ISC', 'home-affairs', 'inter-state-council-secretariat-notification', 'inter-state-council-supersession'),
  ('mha-gsr-692-2024', 'MHA', 'G.S.R. 692(E)', 2024, 'so-only', '2024-11-08', 'G.S.R. 692(E)', 'home-affairs', 'inter-state-council-secretariat-notification', 'inter-state-council-supersession'),
  -- Parliamentary Committee Resolution (bare file-number, same string reused for source+target)
  ('mha-res-11026-01-2024-orig', 'MHA', 'F. No. 11026/01/2024-Raj.Bha.(H.S.S.)', 2025, 'bare', '2025-06-10', 'F. No. 11026/01/2024-Raj.Bha.(H.S.S.)', 'home-affairs', 'parliamentary-committee-resolution-hindi', 'parliamentary-resolution-corrigendum'),
  ('mha-res-11026-01-2024-corr', 'MHA', 'F. No. 11026/01/2024-Raj.Bha.(H.S.S.)', 2025, 'bare', '2025-06-20', 'F. No. 11026/01/2024-Raj.Bha.(H.S.S.)', 'home-affairs', 'parliamentary-committee-resolution-hindi', 'parliamentary-resolution-corrigendum'),
  -- UAPA Tribunal confirmation (LTTE)
  ('mha-so-1983-2024', 'MHA', 'S.O. 1983(E)', 2024, 'so-only', '2024-05-14', 'S.O. 1983(E)', 'home-affairs', 'uapa-tribunal-confirmation-lte', 'uapa-tribunal-lte-confirmation'),
  ('mha-so-2196-2024', 'MHA', 'S.O. 2196(E)', 2024, 'so-only', '2024-06-05', 'S.O. 2196(E)', 'home-affairs', 'uapa-tribunal-confirmation-lte', 'uapa-tribunal-lte-confirmation'),
  ('mha-so-5269-2024', 'MHA', 'S.O. 5269(E)', 2024, 'so-only', '2024-12-04', 'S.O. 5269(E)', 'home-affairs', 'uapa-tribunal-confirmation-lte', 'uapa-tribunal-lte-confirmation');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mha-so-3778-2026', 'mha-so-3987-2025', 'amends', 'research-agent-quoted', '2026-09-03'),
  ('mha-so-4087-2025', 'mha-so-3987-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- S.O. 4583(E) one-to-many
  ('mha-so-4583-2026', 'mha-so-1231-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mha-so-4583-2026', 'mha-so-941-2026',  'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('mha-so-4583-2026', 'mha-so-1110-2026', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  -- Standalone corrigenda
  ('mha-so-147-2024',  'mha-so-5401-2023', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mha-so-3477-2023', 'mha-so-2696-2023', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-581-2023', 'mha-gsr-388-2023', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-118-2025', 'mha-gsr-03-2025',  'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-133-2025', 'mha-gsr-856-2023', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- Mountaineering peaks corrigendum
  ('mha-so-4104-2025', 'mha-so-3986-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- FCRR 2011 chain
  ('mha-gsr-292-2012', 'mha-gsr-349-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-966-2015', 'mha-gsr-292-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-199-2019', 'mha-gsr-966-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-659-2019', 'mha-gsr-199-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-695-2020', 'mha-gsr-659-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-17-2021',  'mha-gsr-695-2020', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-506-2022', 'mha-gsr-17-2021',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-683-2023', 'mha-gsr-506-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-790-2024', 'mha-gsr-683-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-342-2025', 'mha-gsr-790-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-so-3272-2026', 'mha-gsr-342-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- FCRA compounding-of-offences
  ('mha-so-778-2023',  'mha-so-3025-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-so-3287-2026', 'mha-so-778-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- Citizenship Rules, 2009 (hub with a documented gap — 323 not chained via 369)
  ('mha-gsr-1158-2018', 'mha-gsr-124-2009',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-172-2024',  'mha-gsr-1158-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-323-2026',  'mha-gsr-124-2009',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-369-2026',  'mha-gsr-172-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mha-gsr-742-2026',  'mha-gsr-369-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- Immigration and Foreigners Rules, 2025
  ('mha-gsr-424-2026', 'mha-gsr-596-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Inter-State Council Secretariat
  ('mha-gsr-692-2024', 'mha-file-1-7-2019-isc', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- Parliamentary Committee Resolution
  ('mha-res-11026-01-2024-corr', 'mha-res-11026-01-2024-orig', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- UAPA Tribunal confirmation
  ('mha-so-5269-2024', 'mha-so-1983-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mha-so-5269-2024', 'mha-so-2196-2024', 'cites', 'research-agent-quoted', '2026-09-04');
