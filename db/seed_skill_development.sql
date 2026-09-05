-- Ministry of Skill Development and Entrepreneurship. Deepened 2026-09-04
-- (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded
-- pass (3 pairs). The tracker holds only 17 MSDE items (2023-2026); the
-- pre-2023 links below were read from the official gazette PDFs via the
-- archive.org egazette mirror (every egazette.gov.in WriteReadData URL
-- for a pre-2023 id returned HTML; the mirror served all twelve).
--
-- 5 new chains/pairs:
--   A. Apprenticeship Rules, 1992 — an 9-node note-chain back to the bare
--      principal G.S.R. 356 [1992-07-15], every link quoted from its own
--      trailing Note ("last amended vide"); 2017 alone had at least six
--      amendments (186(E) is "Second", 1525(E) "Sixth").
--   B. Credit Guarantee Fund Scheme for Skill Development — the previously
--      deferred bare-form lead, now a 3-node chain (2015 principal; a 2024
--      amendment; a 2026 merged scheme superseding both), source and 2024
--      target sharing the identical file number, date-qualified.
--   C. Common Norms for Skill Development Schemes — a 7-node bare chain
--      (2015 principal + six numbered amendments 2016-2026); each
--      amendment's preamble amends the principal by number and date, so
--      modeled as a hub, except the Fifth which amends the Fourth by
--      number and date. Intermediates cited elsewhere by date only carry
--      no edge. Three of the numbers are the same string "(Vol. IV)".
--   D. NCVET constitution (MSDE Resolution SD-17/113/2017-E&PW,
--      2018-12-05) supersedes, in its CLOSING paragraph rather than a
--      preamble, the Ministry of Labour's 1956 NCVT Resolution (dated
--      "21st/24th August, 1956" — 21 Aug used) and the Finance Ministry's
--      2013 NSDA notification — two cross-ministry targets filed under
--      the existing 'labour-and-employment' and 'finance-other-
--      departments' ministry rows.
--   F. NSDA's 2018 awarding-body recognition cites the Finance Ministry's
--      2013 NSQF notification by number and date (printed "-Investment"
--      there, "-Invt" on the original).
--
-- DEFERRED pending the same issuer-taxonomy decision as Petroleum's PNGRB
-- regulations (real, fully quoted in the research log, NOT modeled): the
-- NCVET-issued Part III s.4 notifications — NSQF 2023 (F. No. 22001/01/
-- 2023/NCVET, superseding the 2013 NSQF and citing the 2018
-- constitution) and six NCVET guidelines citing SD-17/113/2017-E&PW.
-- Their issuer in the text is the Council, which the tracker indexes
-- separately.
--
-- Real leads NOT modeled: seven Recruitment Rules supersessions citing
-- 1999-2014 predecessors by title only; G.S.R. 130(E)'s own supersession
-- of the Indian Skill Development Rules, 2017 (title only); a CGFSSD
-- reference to "Notification No. 74 (01)/PFC-II/2024 dated 20.11.2015"
-- that matches nothing in the 2015 principal (likely a wrong number —
-- no node created); an Apprentices Act commencement notification citing
-- an Act; an Aadhaar notification citing a MeitY letter.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('skill-development-entrepreneurship', 'Ministry of Skill Development and Entrepreneurship', NULL),
  ('labour-and-employment', 'Ministry of Labour and Employment', NULL),
  ('finance-other-departments', 'Ministry of Finance', 'Department of Economic Affairs; Department of Expenditure; Department of Financial Services; DIPAM');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('msde-recruitment-rules-2025', 'MSDE recruitment rules (corrected 2025)', 2025),
  ('apprentices-act-1961', 'Apprentices Act, 1961', 1961),
  ('apprenticeship-rules-1992', 'Apprenticeship Rules, 1992', 1992),
  ('cgfssd-scheme-2015', 'Credit Guarantee Fund Scheme for Skill Development, 2015', 2015),
  ('common-norms-skill-development-2015', 'Common Norms for Skill Development Schemes, 2015', 2015),
  ('ncvet-constitution-resolution-2018', 'National Council for Vocational Education and Training — constitution Resolution, 2018', 2018),
  ('ncvt-resolution-1956', 'Ministry of Labour Resolution constituting the National Council for Vocational Training, 1956', 1956),
  ('nsda-notification-2013', 'National Skill Development Agency notification, 2013 (Finance, DEA)', 2013),
  ('nsqf-notification-2013', 'National Skill Qualification Framework notification, 2013 (Finance, DEA)', 2013);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('msde-recruitment-rules-corrigendum', 'Corrigendum to an MSDE recruitment rules notification', 'active'),
  ('apprentices-act-industry-coverage', 'Apprentices Act industry-coverage notification and its supersession', 'superseded'),
  ('central-apprenticeship-council', 'Central Apprenticeship Council reconstitution', 'superseded'),
  ('apprenticeship-rules-1992-amendments', 'Apprenticeship Rules, 1992 note-chain (1992-2025)', 'active'),
  ('cgfssd-scheme-chain', 'CGFSSD scheme: principal, 2024 amendment, 2026 merged supersession (bare file numbers)', 'active'),
  ('common-norms-amendments', 'Common Norms for Skill Development Schemes — six numbered amendments (bare)', 'active'),
  ('ncvet-constitution-supersessions', 'NCVET constitution superseding NCVT (Labour, 1956) and NSDA (Finance, 2013)', 'active'),
  ('nsda-awarding-body-cites-nsqf', 'NSDA awarding-body recognition citing the 2013 NSQF notification', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: G.S.R. 744(E) corrects G.S.R. 130(E)
  ('msde-gsr-130-2025', 'MSDE', 'G.S.R. 130(E)', 2025, 'so-only', '2025-02-11', 'G.S.R. 130(E)', 'skill-development-entrepreneurship', 'msde-recruitment-rules-2025', 'msde-recruitment-rules-corrigendum'),
  ('msde-gsr-744-2025', 'MSDE', 'G.S.R. 744(E)', 2025, 'so-only', '2025-10-08', 'G.S.R. 744(E)', 'skill-development-entrepreneurship', 'msde-recruitment-rules-2025', 'msde-recruitment-rules-corrigendum'),
  -- Pair 2: cross-ministry supersession
  ('mole-gsr-479-1999', 'Labour', 'G.S.R. 479(E)', 1999, 'so-only', '1999-06-30', 'G.S.R. 479(E)', 'labour-and-employment', 'apprentices-act-1961', 'apprentices-act-industry-coverage'),
  ('msde-so-4072-2025', 'MSDE', 'S.O. 4072(E)', 2025, 'so-only', '2025-09-03', 'S.O. 4072(E)', 'skill-development-entrepreneurship', 'apprentices-act-1961', 'apprentices-act-industry-coverage'),
  -- Pair 3
  ('msde-so-1348-2019', 'MSDE', 'S.O. 1348(E)', 2019, 'so-only', '2019-03-08', 'S.O. 1348(E)', 'skill-development-entrepreneurship', 'apprentices-act-1961', 'central-apprenticeship-council'),
  ('msde-so-4560-2024', 'MSDE', 'S.O. 4560(E)', 2024, 'so-only', '2024-10-16', 'S.O. 4560(E)', 'skill-development-entrepreneurship', 'apprentices-act-1961', 'central-apprenticeship-council'),
  -- A. Apprenticeship Rules, 1992 note-chain
  ('msde-gsr-356-1992',  'MSDE', 'G.S.R. 356',     1992, 'bare',    '1992-07-15', 'G.S.R. 356',     'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-198-2016',  'MSDE', 'G.S.R. 198(E)',  2016, 'so-only', '2016-02-22', 'G.S.R. 198(E)',  'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-186-2017',  'MSDE', 'G.S.R. 186(E)',  2017, 'so-only', '2017-03-02', 'G.S.R. 186(E)',  'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-1139-2017', 'MSDE', 'G.S.R. 1139(E)', 2017, 'so-only', '2017-09-07', 'G.S.R. 1139(E)', 'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-1525-2017', 'MSDE', 'G.S.R. 1525(E)', 2017, 'so-only', '2017-12-20', 'G.S.R. 1525(E)', 'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-686-2019',  'MSDE', 'G.S.R. 686(E)',  2019, 'so-only', '2019-09-25', 'G.S.R. 686(E)',  'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-818-2022',  'MSDE', 'G.S.R. 818(E)',  2022, 'so-only', '2022-11-15', 'G.S.R. 818(E)',  'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-254-2024',  'MSDE', 'G.S.R. 254(E)',  2024, 'so-only', '2024-04-19', 'G.S.R. 254(E)',  'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  ('msde-gsr-610-2025',  'MSDE', 'G.S.R. 610(E)',  2025, 'so-only', '2025-09-03', 'G.S.R. 610(E)',  'skill-development-entrepreneurship', 'apprenticeship-rules-1992', 'apprenticeship-rules-1992-amendments'),
  -- B. CGFSSD (bare; same file number 2024/2026, date-qualified)
  ('msde-file-8-8-2014-2015', 'MSDE', 'No. 8-8/2014-SD&E (Vol. II)', 2015, 'bare', '2015-11-20', 'No. 8-8/2014-SD&E (Vol. II)', 'skill-development-entrepreneurship', 'cgfssd-scheme-2015', 'cgfssd-scheme-chain'),
  ('msde-file-sl11-2024', 'MSDE', 'No. SL-11/01/2023-T&P', 2024, 'bare', '2024-07-09', 'No. SL-11/01/2023-T&P', 'skill-development-entrepreneurship', 'cgfssd-scheme-2015', 'cgfssd-scheme-chain'),
  ('msde-file-sl11-2026', 'MSDE', 'No. SL-11/01/2023-T&P', 2026, 'bare', '2026-07-09', 'No. SL-11/01/2023-T&P', 'skill-development-entrepreneurship', 'cgfssd-scheme-2015', 'cgfssd-scheme-chain'),
  -- C. Common Norms (bare)
  ('msde-file-h22011-2015',    'MSDE', 'Notification No. H-22011/2/2014-SDE-I', 2015, 'bare', '2015-07-15', 'Notification No. H-22011/2/2014-SDE-I', 'skill-development-entrepreneurship', 'common-norms-skill-development-2015', 'common-norms-amendments'),
  ('msde-file-h22011-2016',    'MSDE', 'H-22011/2/2014-SDE', 2016, 'bare', '2016-05-20', 'H-22011/2/2014-SDE', 'skill-development-entrepreneurship', 'common-norms-skill-development-2015', 'common-norms-amendments'),
  ('msde-file-h22011-2017',    'MSDE', 'F. No. H-22011/2/2014-SDE-I', 2017, 'bare', '2017-02-28', 'F. No. H-22011/2/2014-SDE-I', 'skill-development-entrepreneurship', 'common-norms-skill-development-2015', 'common-norms-amendments'),
  ('msde-file-h22011-2018',    'MSDE', 'F. No. H-22011/2/2014-SDE-III', 2018, 'bare', '2018-12-31', 'F. No. H-22011/2/2014-SDE-III', 'skill-development-entrepreneurship', 'common-norms-skill-development-2015', 'common-norms-amendments'),
  ('msde-file-h22011-2020',    'MSDE', 'F.No. H-22011/2/2014-SDE (Vol-IV)', 2020, 'bare', '2020-11-11', 'F.No. H-22011/2/2014-SDE (Vol-IV)', 'skill-development-entrepreneurship', 'common-norms-skill-development-2015', 'common-norms-amendments'),
  ('msde-file-h22011-2021',    'MSDE', 'No. H-22011/2/2014-SDE (Vol. IV)', 2021, 'bare', '2021-01-01', 'No. H-22011/2/2014-SDE (Vol. IV)', 'skill-development-entrepreneurship', 'common-norms-skill-development-2015', 'common-norms-amendments'),
  ('msde-file-h22011-2026',    'MSDE', 'F. No. H-22011/2/2014-SDE (Vol. IV)-Part(3)', 2026, 'bare', '2026-02-23', 'F. No. H-22011/2/2014-SDE (Vol. IV)-Part(3)', 'skill-development-entrepreneurship', 'common-norms-skill-development-2015', 'common-norms-amendments'),
  -- D. NCVET constitution and its two cross-ministry targets
  ('msde-res-sd17-2018', 'MSDE', 'No. SD-17/113/2017-E&PW', 2018, 'bare', '2018-12-05', 'No. SD-17/113/2017-E&PW', 'skill-development-entrepreneurship', 'ncvet-constitution-resolution-2018', 'ncvet-constitution-supersessions'),
  ('mole-res-tr-ep-24-56-1956', 'Labour', 'Resolution No. TR/EP-24/56', 1956, 'bare', '1956-08-21', 'Resolution No. TR/EP-24/56', 'labour-and-employment', 'ncvt-resolution-1956', 'ncvet-constitution-supersessions'),
  ('mof-file-14-27-2012-ec-2013', 'MoF', 'No. 14/27/2012-EC', 2013, 'bare', '2013-06-06', 'No. 14/27/2012-EC', 'finance-other-departments', 'nsda-notification-2013', 'ncvet-constitution-supersessions'),
  -- F. NSDA cites the 2013 NSQF notification (Finance, DEA)
  ('mof-file-8-6-2013-invt-2013', 'MoF', 'No. 8/6/2013-Invt.', 2013, 'bare', '2013-12-27', 'No. 8/6/2013-Invt.', 'finance-other-departments', 'nsqf-notification-2013', 'nsda-awarding-body-cites-nsqf'),
  ('msde-file-f4300-2018', 'MSDE', 'No. F.4300/02/2013-NSDA', 2018, 'bare', '2018-11-27', 'No. F.4300/02/2013-NSDA', 'skill-development-entrepreneurship', 'nsqf-notification-2013', 'nsda-awarding-body-cites-nsqf');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('msde-gsr-744-2025', 'msde-gsr-130-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('msde-so-4072-2025', 'mole-gsr-479-1999', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('msde-so-4560-2024', 'msde-so-1348-2019', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- A. Apprenticeship Rules, 1992
  ('msde-gsr-198-2016',  'msde-gsr-356-1992',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-gsr-186-2017',  'msde-gsr-198-2016',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-gsr-1139-2017', 'msde-gsr-186-2017',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-gsr-1525-2017', 'msde-gsr-1139-2017', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-gsr-686-2019',  'msde-gsr-1525-2017', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-gsr-818-2022',  'msde-gsr-686-2019',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('msde-gsr-254-2024',  'msde-gsr-818-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('msde-gsr-610-2025',  'msde-gsr-254-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- B. CGFSSD
  ('msde-file-sl11-2024', 'msde-file-8-8-2014-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('msde-file-sl11-2026', 'msde-file-sl11-2024',     'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('msde-file-sl11-2026', 'msde-file-8-8-2014-2015', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- C. Common Norms (hub on the principal; Fifth amends the Fourth by number)
  ('msde-file-h22011-2016', 'msde-file-h22011-2015', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-file-h22011-2017', 'msde-file-h22011-2015', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-file-h22011-2018', 'msde-file-h22011-2015', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-file-h22011-2020', 'msde-file-h22011-2015', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-file-h22011-2021', 'msde-file-h22011-2020', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('msde-file-h22011-2026', 'msde-file-h22011-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- D. NCVET constitution
  ('msde-res-sd17-2018', 'mole-res-tr-ep-24-56-1956',  'supersedes', 'primary-source-egazette', '2026-09-04'),
  ('msde-res-sd17-2018', 'mof-file-14-27-2012-ec-2013', 'supersedes', 'primary-source-egazette', '2026-09-04'),
  -- F. NSDA cites NSQF 2013
  ('msde-file-f4300-2018', 'mof-file-8-6-2013-invt-2013', 'cites', 'primary-source-egazette', '2026-09-04');
