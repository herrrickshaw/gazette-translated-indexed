-- Ministry of Minority Affairs. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3 note-chains).
--
-- 2 brand-new note-chains found (Haj Committee Rules, 2002 — a rules
-- instrument distinct from the already-modeled Act-composition chain;
-- Haj Committee Act s.41 Schedule/Zones, also genuinely distinct), plus
-- 2 new nodes extending the already-modeled Haj Committee composition
-- chain, one of which (S.O. 2828(E), 2023) exposed a REAL GAP IN THE
-- MINISTRY'S OWN RECORD-KEEPING: it is a genuine amendment sitting
-- chronologically between two already-modeled links, but the Ministry's
-- own later Notes consistently omit it from their historical recitals —
-- modeled here as a real edge off its actual target (S.O. 1564(E))
-- rather than silently smoothed into the linear sequence the other Notes
-- describe.
--
-- Real leads NOT modeled: a Recruitment Rules supersession (target cited
-- by title/year only); three Waqf-reform Act-commencement notifications
-- (Waqf Amendment Act 2025, Mussalman Wakf Repeal Act 2025, Umeed Rules)
-- that cite an Act number rather than another gazette notification; a
-- Hindi Salahkar Samiti reconstitution citing a real file number whose
-- own gazette record wasn't located this pass; a CCS Conduct/CCA Rules
-- adoption notice citing rules by title/year only.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('minority-affairs', 'Ministry of Minority Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('central-waqf-council-rules-1998', 'Central Waqf Council Rules, 1998', 1998),
  ('central-waqf-council-recruitment-rules-2014', 'Central Waqf Council (Group A/B/C) Recruitment Rules, 2014', 2014),
  ('haj-committee-act-2002', 'Haj Committee Act, 2002 (Haj Committee of India composition)', 2002),
  ('haj-committee-rules-2002', 'Haj Committee Rules, 2002', 2002),
  ('haj-committee-act-2002-schedule-zones', 'Haj Committee Act, 2002 — section 41 Schedule (Zones)', 2002);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('central-waqf-council-rules-amendments', 'Central Waqf Council Rules, 1998 and its amendments', 'active'),
  ('central-waqf-council-recruitment-amendments', 'Central Waqf Council Recruitment Rules and its amendments', 'active'),
  ('haj-committee-composition', 'Haj Committee of India composition', 'active'),
  ('haj-committee-rules-amendments', 'Haj Committee Rules, 2002 and its amendments', 'active'),
  ('haj-committee-schedule-zones-amendments', 'Haj Committee Act Schedule (Zones) amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: six-node chain (unchanged)
  ('moma-gsr-593-1998', 'MoMA', 'G.S.R. 593(E)', 1998, 'so-only', '1998-09-30', 'G.S.R. 593(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-240-2012', 'MoMA', 'G.S.R. 240(E)', 2012, 'so-only', '2012-03-22', 'G.S.R. 240(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-693-2014', 'MoMA', 'G.S.R. 693(E)', 2014, 'so-only', '2014-09-25', 'G.S.R. 693(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-532-2015', 'MoMA', 'G.S.R. 532(E)', 2015, 'so-only', '2015-07-02', 'G.S.R. 532(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-344-2022', 'MoMA', 'G.S.R. 344(E)', 2022, 'so-only', '2022-05-09', 'G.S.R. 344(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-753-2026', 'MoMA', 'G.S.R. 753(E)', 2026, 'so-only', '2026-08-18', 'G.S.R. 753(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  -- Pair 2: three-node chain (unchanged)
  ('moma-gsr-363-2014', 'MoMA', 'G.S.R. 363(E)', 2014, 'so-only', '2014-05-28', 'G.S.R. 363(E)', 'minority-affairs', 'central-waqf-council-recruitment-rules-2014', 'central-waqf-council-recruitment-amendments'),
  ('moma-gsr-617-2016', 'MoMA', 'G.S.R. 617(E)', 2016, 'so-only', '2016-06-22', 'G.S.R. 617(E)', 'minority-affairs', 'central-waqf-council-recruitment-rules-2014', 'central-waqf-council-recruitment-amendments'),
  ('moma-gsr-754-2026', 'MoMA', 'G.S.R. 754(E)', 2026, 'so-only', '2026-08-18', 'G.S.R. 754(E)', 'minority-affairs', 'central-waqf-council-recruitment-rules-2014', 'central-waqf-council-recruitment-amendments'),
  -- Pair 3: Haj Committee composition, now 8-node chain (2 new nodes)
  ('moma-so-1564-2022', 'MoMA', 'S.O. 1564(E)', 2022, 'so-only', '2022-04-01', 'S.O. 1564(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-1912-2022', 'MoMA', 'S.O. 1912(E)', 2022, 'so-only', '2022-04-21', 'S.O. 1912(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-2234-2022', 'MoMA', 'S.O. 2234(E)', 2022, 'so-only', '2022-05-12', 'S.O. 2234(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-2828-2023', 'MoMA', 'S.O. 2828(E)', 2023, 'so-only', '2023-06-28', 'S.O. 2828(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-1183-2024', 'MoMA', 'S.O. 1183(E)', 2024, 'so-only', '2024-03-07', 'S.O. 1183(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-4171-2024', 'MoMA', 'S.O. 4171(E)', 2024, 'so-only', '2024-09-23', 'S.O. 4171(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-4368-2024', 'MoMA', 'S.O. 4368(E)', 2024, 'so-only', '2024-10-08', 'S.O. 4368(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-5055-2024', 'MoMA', 'S.O. 5055(E)', 2024, 'so-only', '2024-11-25', 'S.O. 5055(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  -- Haj Committee Rules, 2002 (distinct rules instrument)
  ('moma-gsr-801-2002', 'MoMA', 'G.S.R. 801(E)', 2002, 'so-only', '2002-12-05', 'G.S.R. 801(E)', 'minority-affairs', 'haj-committee-rules-2002', 'haj-committee-rules-amendments'),
  ('moma-gsr-369-2024', 'MoMA', 'G.S.R. 369(E)', 2024, 'so-only', '2024-07-03', 'G.S.R. 369(E)', 'minority-affairs', 'haj-committee-rules-2002', 'haj-committee-rules-amendments'),
  ('moma-gsr-170-2025', 'MoMA', 'G.S.R. 170(E)', 2025, 'so-only', '2025-03-11', 'G.S.R. 170(E)', 'minority-affairs', 'haj-committee-rules-2002', 'haj-committee-rules-amendments'),
  -- Haj Committee Act Schedule (Zones)
  ('moma-so-1267-2002', 'MoMA', 'S.O. 1267(E)', 2002, 'so-only', '2002-12-05', 'S.O. 1267(E)', 'minority-affairs', 'haj-committee-act-2002-schedule-zones', 'haj-committee-schedule-zones-amendments'),
  ('moma-so-132-2003',  'MoMA', 'S.O. 132(E)',  2003, 'so-only', '2003-02-04', 'S.O. 132(E)',  'minority-affairs', 'haj-committee-act-2002-schedule-zones', 'haj-committee-schedule-zones-amendments'),
  ('moma-so-3834-2020', 'MoMA', 'S.O. 3834(E)', 2020, 'so-only', '2020-10-27', 'S.O. 3834(E)', 'minority-affairs', 'haj-committee-act-2002-schedule-zones', 'haj-committee-schedule-zones-amendments'),
  ('moma-so-1129-2025', 'MoMA', 'S.O. 1129(E)', 2025, 'so-only', '2025-03-11', 'S.O. 1129(E)', 'minority-affairs', 'haj-committee-act-2002-schedule-zones', 'haj-committee-schedule-zones-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moma-gsr-240-2012', 'moma-gsr-593-1998', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-693-2014', 'moma-gsr-240-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-532-2015', 'moma-gsr-693-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-344-2022', 'moma-gsr-532-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-753-2026', 'moma-gsr-344-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-617-2016', 'moma-gsr-363-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-754-2026', 'moma-gsr-617-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-1912-2022', 'moma-so-1564-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-2234-2022', 'moma-so-1912-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-2828-2023', 'moma-so-1564-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-1183-2024', 'moma-so-2234-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-4171-2024', 'moma-so-1183-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-4368-2024', 'moma-so-4171-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-5055-2024', 'moma-so-4368-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-369-2024', 'moma-gsr-801-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-170-2025', 'moma-gsr-369-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-132-2003',  'moma-so-1267-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-3834-2020', 'moma-so-132-2003',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-1129-2025', 'moma-so-3834-2020', 'amends', 'research-agent-quoted', '2026-09-04');
