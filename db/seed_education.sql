-- Ministry of Education. Both departments (School Education and Literacy,
-- Higher Education) share ONE real ministry — the 2020 merger of the
-- erstwhile Ministry of Human Resource Development — and one
-- gazettetracker.com listing, so results from separate research passes
-- are folded into a single ministry_id here rather than double-counted,
-- per this project's own stated exception in docs/MINISTRY_COVERAGE_PLAN.md.
--
-- Deepened 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond
-- the original bounded pass (6 pairs). gazettetracker.com's anonymous
-- search hit a rate-limit wall this pass; the project's own documented
-- fallback (ingest/egazette.py, fetching directly from egazette.gov.in by
-- deterministic gazette-ID -> PDF URL) was used instead for primary text,
-- with gazettetracker's un-rate-limited per-ministry browse pages used
-- only to find candidate gazette IDs to target.
--
-- Two existing chains turned out longer than first modeled (2 new
-- intermediate nodes inserted into each, replacing the old direct edges):
-- the Council of Architecture foreign-qualification thread and the NCTE
-- General Body thread. 4 further new subject threads found: University
-- Grants Commission Recruitment Rules, 2016 (a hub — two independent
-- Schedule-entry amendments both citing the same immediate predecessor);
-- a second, parallel Punjab University Act rescission cycle one week
-- before the already-modeled one; RTE Act, 2009 s.33 Committee (a
-- distinct S.O.-numbered instrument from the already-modeled G.S.R.-
-- numbered RTE Rules, 2010 thread); and Council of Architecture Rules,
-- 1973 (distinct from the Council's foreign-qualification G.S.R.68(E)
-- thread — a related but separate real instrument issued one day earlier
-- under an adjacent G.S.R. number, flagged as an easy-to-conflate-but-not-
-- actually-colliding pair, not a true citation collision).
--
-- One date is a documented partial fact, not a full primary-text quote:
-- GSR 412(E)'s own Foot Note gives only "of January, 1975" with no day;
-- 1975-01-01 is used as a placeholder day, flagged here per this
-- project's discipline around any date not fully stated in source text.
--
-- Real leads NOT modeled: NCTE (Recognition Norms and Procedure)
-- Regulations, 2014 (5-node chain, but every link is File-Number only);
-- AICTE Grant of Approvals Guidelines (same, File-Number only); Delhi
-- University Statutes, 1922 Vice-Chancellor tenure amendment (File-Number
-- only); the already-known CIET/NCERT Recruitment Rules, 2005 lead (now
-- confirmed sourced from G.S.R. 783(E), 2024-12-11, but the 2005 target
-- still carries no citation number of any kind).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('education', 'Ministry of Education', 'Department of School Education and Literacy; Department of Higher Education');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('architects-act-1972-council-rules', 'Architects Act, 1972 — Council of Architecture foreign-qualification rules', 1972),
  ('spa-act-2014-governing-council', 'School of Planning and Architecture Act, 2014 — Governing Council', 2014),
  ('punjab-reorganisation-act-1966-university', 'Punjab Reorganisation Act, 1966 — Punjab University notification', 1966),
  ('rte-rules-2010', 'Right of Children to Free and Compulsory Education Rules, 2010', 2010),
  ('ncte-act-1993-general-body', 'National Council for Teacher Education Act, 1993 — General Body', 1993),
  ('ugc-recruitment-rules-2016', 'University Grants Commission Recruitment Rules, 2016', 2016),
  ('rte-act-2009-s33-committee', 'Right of Children to Free and Compulsory Education Act, 2009 — s.33 Committee', 2009),
  ('architects-act-1972-council-rules-1973', 'Architects Act, 1972 — Council of Architecture Rules, 1973 (general procedural/eligibility rules)', 1972);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('coa-foreign-qualification-amendments', 'Council of Architecture foreign-qualification rules and its amendments', 'active'),
  ('spa-governing-council-amendments', 'School of Planning and Architecture Governing Council amendments', 'active'),
  ('punjab-university-rescission', 'Punjab University notification rescission', 'superseded'),
  ('punjab-university-rescission-2', 'Punjab University notification rescission — a second, parallel cycle one week earlier', 'superseded'),
  ('rte-rules-amendments', 'RTE Rules, 2010 and its amendments', 'active'),
  ('ncte-general-body-amendment', 'NCTE General Body amendment', 'active'),
  ('ugc-recruitment-rules-amendments', 'UGC Recruitment Rules, 2016 amendments — two independent Schedule-entry amendments', 'active'),
  ('rte-act-s33-committee-amendment', 'RTE Act s.33 Committee amendment', 'active'),
  ('coa-rules-1973-amendments', 'Council of Architecture Rules, 1973 and its long amendment history', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1 (Higher Ed): five-node chain (2 new intermediate nodes)
  ('moe-gsr-68-1973',  'MoE', 'G.S.R. 68(E)',  1973, 'so-only', '1973-02-21', 'G.S.R. 68(E)',  'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  ('moe-so-4038-2020', 'MoE', 'S.O. 4038(E)', 2020, 'so-only', '2020-11-10', 'S.O. 4038(E)', 'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  ('moe-so-3211-2024', 'MoE', 'S.O. 3211(E)', 2024, 'so-only', '2024-08-08', 'S.O. 3211(E)', 'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  ('moe-so-2994-2025', 'MoE', 'S.O. 2994(E)', 2025, 'so-only', '2025-07-03', 'S.O. 2994(E)', 'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  ('moe-so-4861-2025', 'MoE', 'S.O. 4861(E)', 2025, 'so-only', '2025-10-24', 'S.O. 4861(E)', 'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  -- Pair 2 (Higher Ed): three-node chain (unchanged)
  ('moe-so-3239-2018', 'MoE', 'S.O. 3239(E)', 2018, 'so-only', '2018-07-03', 'S.O. 3239(E)', 'education', 'spa-act-2014-governing-council', 'spa-governing-council-amendments'),
  ('moe-so-5378-2024', 'MoE', 'S.O. 5378(E)', 2024, 'so-only', '2024-12-11', 'S.O. 5378(E)', 'education', 'spa-act-2014-governing-council', 'spa-governing-council-amendments'),
  ('moe-so-4659-2025', 'MoE', 'S.O. 4659(E)', 2025, 'so-only', '2025-10-09', 'S.O. 4659(E)', 'education', 'spa-act-2014-governing-council', 'spa-governing-council-amendments'),
  -- Pair 3 (Higher Ed): two-node chain, rescission (unchanged)
  ('moe-so-5023-2025', 'MoE', 'S.O. 5023(E)', 2025, 'so-only', '2025-11-04', 'S.O. 5023(E)', 'education', 'punjab-reorganisation-act-1966-university', 'punjab-university-rescission'),
  ('moe-so-5063-2025', 'MoE', 'S.O. 5063(E)', 2025, 'so-only', '2025-11-07', 'S.O. 5063(E)', 'education', 'punjab-reorganisation-act-1966-university', 'punjab-university-rescission'),
  -- Pair 3b (Higher Ed): a second, parallel rescission cycle one week earlier
  ('moe-so-4933-2025', 'MoE', 'S.O. 4933(E)', 2025, 'so-only', '2025-10-28', 'S.O. 4933(E)', 'education', 'punjab-reorganisation-act-1966-university', 'punjab-university-rescission-2'),
  ('moe-so-5022-2025', 'MoE', 'S.O. 5022(E)', 2025, 'so-only', '2025-11-04', 'S.O. 5022(E)', 'education', 'punjab-reorganisation-act-1966-university', 'punjab-university-rescission-2'),
  -- Pair 4 (School Ed): three-node chain (unchanged)
  ('moe-gsr-301-2010',  'MoE', 'G.S.R. 301(E)',  2010, 'so-only', '2010-04-08', 'G.S.R. 301(E)',  'education', 'rte-rules-2010', 'rte-rules-amendments'),
  ('moe-gsr-1302-2017', 'MoE', 'G.S.R. 1302(E)', 2017, 'so-only', '2017-10-17', 'G.S.R. 1302(E)', 'education', 'rte-rules-2010', 'rte-rules-amendments'),
  ('moe-gsr-777-2024',  'MoE', 'G.S.R. 777(E)',  2024, 'so-only', '2024-12-16', 'G.S.R. 777(E)',  'education', 'rte-rules-2010', 'rte-rules-amendments'),
  -- Pair 5 (School Ed): four-node chain (2 new intermediate nodes)
  ('moe-so-980-2020',  'MoE', 'S.O. 980(E)',  2020, 'so-only', '2020-03-04', 'S.O. 980(E)',  'education', 'ncte-act-1993-general-body', 'ncte-general-body-amendment'),
  ('moe-so-3043-2023', 'MoE', 'S.O. 3043(E)', 2023, 'so-only', '2023-07-10', 'S.O. 3043(E)', 'education', 'ncte-act-1993-general-body', 'ncte-general-body-amendment'),
  ('moe-so-2247-2024', 'MoE', 'S.O. 2247(E)', 2024, 'so-only', '2024-06-10', 'S.O. 2247(E)', 'education', 'ncte-act-1993-general-body', 'ncte-general-body-amendment'),
  ('moe-so-4174-2024', 'MoE', 'S.O. 4174(E)', 2024, 'so-only', '2024-09-23', 'S.O. 4174(E)', 'education', 'ncte-act-1993-general-body', 'ncte-general-body-amendment'),
  -- UGC Recruitment Rules, 2016: hub (two independent amendments to G.S.R.105(E))
  ('moe-gsr-839-2016', 'MoE', 'G.S.R. 839(E)', 2016, 'so-only', '2016-08-26', 'G.S.R. 839(E)', 'education', 'ugc-recruitment-rules-2016', 'ugc-recruitment-rules-amendments'),
  ('moe-gsr-105-2018', 'MoE', 'G.S.R. 105(E)', 2018, 'so-only', '2018-02-01', 'G.S.R. 105(E)', 'education', 'ugc-recruitment-rules-2016', 'ugc-recruitment-rules-amendments'),
  ('moe-gsr-289-2024', 'MoE', 'G.S.R. 289(E)', 2024, 'so-only', '2024-05-22', 'G.S.R. 289(E)', 'education', 'ugc-recruitment-rules-2016', 'ugc-recruitment-rules-amendments'),
  ('moe-gsr-29-2025',  'MoE', 'G.S.R. 29(E)',  2025, 'so-only', '2025-01-13', 'G.S.R. 29(E)',  'education', 'ugc-recruitment-rules-2016', 'ugc-recruitment-rules-amendments'),
  -- RTE Act, 2009 s.33 Committee
  ('moe-so-2977-2017', 'MoE', 'S.O. 2977(E)', 2017, 'so-only', '2017-09-08', 'S.O. 2977(E)', 'education', 'rte-act-2009-s33-committee', 'rte-act-s33-committee-amendment'),
  ('moe-so-4702-2023', 'MoE', 'S.O. 4702(E)', 2023, 'so-only', '2023-10-20', 'S.O. 4702(E)', 'education', 'rte-act-2009-s33-committee', 'rte-act-s33-committee-amendment'),
  -- Council of Architecture Rules, 1973 (11-node chain, mostly pre-1994 bare numbering)
  ('moe-gsr-67-1973',   'MoE', 'G.S.R. 67(E)',   1973, 'so-only', '1973-02-20', 'G.S.R. 67(E)',   'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-1104-1973', 'MoE', 'GSR 1104',       1973, 'bare',    '1973-09-26', 'GSR 1104',       'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-543-1973',  'MoE', 'GSR 543(E)',     1973, 'so-only', '1973-12-31', 'GSR 543(E)',     'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-412-1975',  'MoE', 'GSR 412(E)',     1975, 'so-only', '1975-01-01', 'GSR 412(E)',     'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-669-1977',  'MoE', 'GSR 669',        1977, 'bare',    '1977-05-04', 'GSR 669',        'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-751-1987',  'MoE', 'GSR 751',        1987, 'bare',    '1987-10-10', 'GSR 751',        'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-192-1998',  'MoE', 'GSR 192',        1998, 'bare',    '1998-09-15', 'GSR 192',        'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-14-2002',   'MoE', 'GSR 14',         2002, 'bare',    '2002-01-03', 'GSR 14',         'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-173-2014',  'MoE', 'GSR 173',        2014, 'bare',    '2014-08-06', 'GSR 173',        'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-623-2023',  'MoE', 'G.S.R. 623(E)',  2023, 'so-only', '2023-08-24', 'G.S.R. 623(E)',  'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments'),
  ('moe-gsr-512-2024',  'MoE', 'G.S.R. 512(E)',  2024, 'so-only', '2024-08-16', 'G.S.R. 512(E)',  'education', 'architects-act-1972-council-rules-1973', 'coa-rules-1973-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moe-so-4038-2020', 'moe-gsr-68-1973',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-3211-2024', 'moe-so-4038-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-2994-2025', 'moe-so-3211-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-4861-2025', 'moe-so-2994-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-5378-2024', 'moe-so-3239-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-4659-2025', 'moe-so-5378-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-5063-2025', 'moe-so-5023-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-5022-2025', 'moe-so-4933-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-1302-2017', 'moe-gsr-301-2010',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-777-2024',  'moe-gsr-1302-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-3043-2023', 'moe-so-980-2020',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-2247-2024', 'moe-so-3043-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-4174-2024', 'moe-so-2247-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-105-2018', 'moe-gsr-839-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-289-2024', 'moe-gsr-105-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-29-2025',  'moe-gsr-105-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-4702-2023', 'moe-so-2977-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-1104-1973', 'moe-gsr-67-1973',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-543-1973',  'moe-gsr-1104-1973', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-412-1975',  'moe-gsr-543-1973',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-669-1977',  'moe-gsr-412-1975',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-751-1987',  'moe-gsr-669-1977',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-192-1998',  'moe-gsr-751-1987',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-14-2002',   'moe-gsr-192-1998',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-173-2014',  'moe-gsr-14-2002',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-623-2023',  'moe-gsr-173-2014',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-512-2024',  'moe-gsr-623-2023',  'amends', 'research-agent-quoted', '2026-09-04');
