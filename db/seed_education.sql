-- Ministry of Education pilot. Both departments (School Education and
-- Literacy, Higher Education) share ONE real ministry — the 2020 merger
-- of the erstwhile Ministry of Human Resource Development — and one
-- gazettetracker.com listing, so results from two separate research
-- passes (one per department) are folded into a single ministry_id here
-- rather than double-counted, per this project's own stated exception in
-- docs/MINISTRY_COVERAGE_PLAN.md.
--
-- Six real pairs researched via gazettetracker.com (Full Text section,
-- primary), 2026-09-04, modeled via extract/education_patterns.py
-- (combining amendment-in-notification under both the current and
-- pre-2020 ministry names, plus corrigendum-substitution) and the
-- note-chain template.
--
-- One further real lead (CIET/NCERT Recruitment Rules supersession) cites
-- its target only as "...Recruitment Rules, 2005" — no year-adjacent
-- citation number of any kind, not even a bare form — deliberately not
-- modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('education', 'Ministry of Education', 'Department of School Education and Literacy; Department of Higher Education');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('architects-act-1972-council-rules', 'Architects Act, 1972 — Council of Architecture foreign-qualification rules', 1972),
  ('spa-act-2014-governing-council', 'School of Planning and Architecture Act, 2014 — Governing Council', 2014),
  ('punjab-reorganisation-act-1966-university', 'Punjab Reorganisation Act, 1966 — Punjab University notification', 1966),
  ('rte-rules-2010', 'Right of Children to Free and Compulsory Education Rules, 2010', 2010),
  ('ncte-act-1993-general-body', 'National Council for Teacher Education Act, 1993 — General Body', 1993);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('coa-foreign-qualification-amendments', 'Council of Architecture foreign-qualification rules and its amendments', 'active'),
  ('spa-governing-council-amendments', 'School of Planning and Architecture Governing Council amendments', 'active'),
  ('punjab-university-rescission', 'Punjab University notification rescission', 'superseded'),
  ('rte-rules-amendments', 'RTE Rules, 2010 and its amendments', 'active'),
  ('ncte-general-body-amendment', 'NCTE General Body amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1 (Higher Ed): three-node chain
  ('moe-gsr-68-1973',  'MoE', 'G.S.R. 68(E)',  1973, 'so-only', '1973-02-21', 'G.S.R. 68(E)',  'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  ('moe-so-2994-2025', 'MoE', 'S.O. 2994(E)', 2025, 'so-only', '2025-07-03', 'S.O. 2994(E)', 'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  ('moe-so-4861-2025', 'MoE', 'S.O. 4861(E)', 2025, 'so-only', '2025-10-24', 'S.O. 4861(E)', 'education', 'architects-act-1972-council-rules', 'coa-foreign-qualification-amendments'),
  -- Pair 2 (Higher Ed): three-node chain
  ('moe-so-3239-2018', 'MoE', 'S.O. 3239(E)', 2018, 'so-only', '2018-07-03', 'S.O. 3239(E)', 'education', 'spa-act-2014-governing-council', 'spa-governing-council-amendments'),
  ('moe-so-5378-2024', 'MoE', 'S.O. 5378(E)', 2024, 'so-only', '2024-12-11', 'S.O. 5378(E)', 'education', 'spa-act-2014-governing-council', 'spa-governing-council-amendments'),
  ('moe-so-4659-2025', 'MoE', 'S.O. 4659(E)', 2025, 'so-only', '2025-10-09', 'S.O. 4659(E)', 'education', 'spa-act-2014-governing-council', 'spa-governing-council-amendments'),
  -- Pair 3 (Higher Ed): two-node chain, rescission
  ('moe-so-5023-2025', 'MoE', 'S.O. 5023(E)', 2025, 'so-only', '2025-11-04', 'S.O. 5023(E)', 'education', 'punjab-reorganisation-act-1966-university', 'punjab-university-rescission'),
  ('moe-so-5063-2025', 'MoE', 'S.O. 5063(E)', 2025, 'so-only', '2025-11-07', 'S.O. 5063(E)', 'education', 'punjab-reorganisation-act-1966-university', 'punjab-university-rescission'),
  -- Pair 4 (School Ed): three-node chain
  ('moe-gsr-301-2010',  'MoE', 'G.S.R. 301(E)',  2010, 'so-only', '2010-04-08', 'G.S.R. 301(E)',  'education', 'rte-rules-2010', 'rte-rules-amendments'),
  ('moe-gsr-1302-2017', 'MoE', 'G.S.R. 1302(E)', 2017, 'so-only', '2017-10-17', 'G.S.R. 1302(E)', 'education', 'rte-rules-2010', 'rte-rules-amendments'),
  ('moe-gsr-777-2024',  'MoE', 'G.S.R. 777(E)',  2024, 'so-only', '2024-12-16', 'G.S.R. 777(E)',  'education', 'rte-rules-2010', 'rte-rules-amendments'),
  -- Pair 5 (School Ed): two-node chain
  ('moe-so-980-2020',  'MoE', 'S.O. 980(E)',  2020, 'so-only', '2020-03-04', 'S.O. 980(E)',  'education', 'ncte-act-1993-general-body', 'ncte-general-body-amendment'),
  ('moe-so-2247-2024', 'MoE', 'S.O. 2247(E)', 2024, 'so-only', '2024-06-10', 'S.O. 2247(E)', 'education', 'ncte-act-1993-general-body', 'ncte-general-body-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moe-so-2994-2025', 'moe-gsr-68-1973',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-4861-2025', 'moe-so-2994-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-5378-2024', 'moe-so-3239-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-4659-2025', 'moe-so-5378-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-5063-2025', 'moe-so-5023-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-1302-2017', 'moe-gsr-301-2010',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-gsr-777-2024',  'moe-gsr-1302-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moe-so-2247-2024', 'moe-so-980-2020', 'amends', 'research-agent-quoted', '2026-09-04');
