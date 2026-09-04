-- Ministry of Housing and Urban Affairs (MoHUA). Deepened 2026-09-04
-- (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded
-- pass (3 pairs/chains).
--
-- Original pilot notes retained: S.O. 4041(E) corrects S.O. 3379(E), a
-- Directorate of Estates notification, verified_by
-- 'research-agent-quoted-uncorroborated' — the WEAKEST corroboration in
-- this project (rests solely on gazettetracker.com's Full Text; this pass
-- did not find independent corroboration either, so the tier is left as
-- is rather than quietly upgraded).
--
-- 3 new subject areas found this pass, ~20 new edges: the other SIX UT/
-- State RERA (General) Rules amendments made in the same 1 July 2026 batch
-- as the already-modeled Ladakh pair (identical template, all citing their
-- 2016 principal by number in a trailing Note); an NCR Planning Board Act
-- Schedule amendment citing a 2013 erstwhile-Ministry-of-Urban-Development
-- notification; and the Metro Railways (Construction of Works) Act, 1978
-- Schedule-alignment series — a large previously-unmodeled subject area
-- where each project's alignment notification cites the omnibus Act-
-- extension notification for its metropolitan area (`cites`) and later
-- alterations amend the alignment notification (`amends`). Pune Metro is
-- the richest thread: a root (S.O. 2732(E), 2014) with three branches, and
-- S.O. 180(E)'s own recital is an explicit primary-source note-chain
-- naming the whole Phase-1 lineage.
--
-- Dates are each notification's own internal date; gazette publish dates
-- where different are recorded in the research log, not here.
--
-- REAL CITATION COLLISION found and correctly kept distinct: this file's
-- S.O. 2979(E) [2013-10-01, NCR Planning Board Schedule, erstwhile
-- Ministry of Urban Development] is unrelated to Power's S.O. 2979(E)
-- [2026-06-10, TFL programme, see db/seed_power.sql] — same displayed
-- citation, thirteen years apart, distinct ministry-prefixed gazette_ids.
--
-- Real leads NOT modeled: a cross-ministry citation (G.S.R. 772(E) cites a
-- Cabinet Secretariat S.O. 4040(E) constituting the new Department of
-- Capital Development) — the Cabinet Secretariat is not a ministry row in
-- this project, deferred rather than mis-attributed; DDA inquiry-and-
-- penalties Rules, 2026 whose own text never cites the related
-- commencement S.O. by number; a Hindi Salahkar Samiti reconstitution
-- and a Rajghat Samadhi Committee "in continuation of" series, both
-- citing pre-coverage targets by bare Resolution/file number not
-- independently openable this pass; one Directorate of Estates
-- notification whose Full Text extraction returned empty.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('housing-and-urban-affairs', 'Ministry of Housing and Urban Affairs', 'Directorate of Estates');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('mohua-notifications-general', 'MoHUA notifications (various subject matter)', NULL),
  ('ladakh-rera-general-rules-2020', 'Ladakh Real Estate (Regulation and Development) (General) Rules, 2020', 2020),
  ('rera-act-2016', 'Real Estate (Regulation and Development) Act, 2016 — Central Advisory Council', 2016),
  ('ut-rera-general-rules-2016', 'UT/State Real Estate (Regulation and Development) (General) Rules, 2016 (six UTs/States)', 2016),
  ('ncr-planning-board-act-1985-schedule', 'National Capital Region Planning Board Act, 1985 — Schedule', 1985),
  ('metro-railways-procedure-of-claims-rules-2017', 'Metro Railways (Procedure of Claims) Rules, 2017', 2017),
  ('metro-railways-act-1978-schedule', 'Metro Railways (Construction of Works) Act, 1978 — Schedule alignments', 1978);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mohua-corrections', 'MoHUA notification corrigenda', 'active'),
  ('mohua-ladakh-rera-rules', 'Ladakh RERA General Rules and its amendments', 'active'),
  ('mohua-rera-cac-membership', 'RERA Central Advisory Council membership notifications', 'active'),
  ('mohua-ut-rera-jan-vishwas-2026', 'Six UT/State RERA General Rules Jan Vishwas 2026 penalty-clause amendments', 'active'),
  ('mohua-ncr-schedule-amendment', 'NCR Planning Board Act Schedule amendment', 'active'),
  ('mohua-metro-claims-rules-amendment', 'Metro Railways (Procedure of Claims) Rules amendment', 'active'),
  ('mohua-metro-bangalore', 'Bangalore Metro Phase-3 alignment', 'active'),
  ('mohua-metro-thane', 'Thane Integral Ring Metro alignment', 'active'),
  ('mohua-metro-mumbai-line3', 'Mumbai Metro Line-3 renaming', 'active'),
  ('mohua-metro-bhopal-indore', 'Bhopal and Indore Metro alignments', 'active'),
  ('mohua-metro-nagpur', 'Nagpur Metro alignment amendments', 'active'),
  ('mohua-metro-mumbai-line5', 'Mumbai Metro Line-5/5A alignment amendment', 'active'),
  ('mohua-metro-pune', 'Pune Metro alignment hub (root + three branches)', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mohua-so-3379-2026', 'MoHUA', 'S.O. 3379(E)', 2026, 'so-only', '2026-06-24', 'S.O. 3379(E)', 'housing-and-urban-affairs', 'mohua-notifications-general', 'mohua-corrections'),
  ('mohua-so-4041-2026', 'MoHUA', 'S.O. 4041(E)', 2026, 'so-only', '2026-07-23', 'S.O. 4041(E)', 'housing-and-urban-affairs', 'mohua-notifications-general', 'mohua-corrections'),
  ('mohua-gsr-619-2020', 'MoHUA', 'G.S.R. 619(E)', 2020, 'so-only', '2020-10-08', 'G.S.R. 619(E)', 'housing-and-urban-affairs', 'ladakh-rera-general-rules-2020', 'mohua-ladakh-rera-rules'),
  ('mohua-gsr-559-2026', 'MoHUA', 'G.S.R. 559(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 559(E)', 'housing-and-urban-affairs', 'ladakh-rera-general-rules-2020', 'mohua-ladakh-rera-rules'),
  ('mohua-so-2666-2017', 'MoHUA', 'S.O. 2666(E)', 2017, 'so-only', '2017-11-20', 'S.O. 2666(E)', 'housing-and-urban-affairs', 'rera-act-2016', 'mohua-rera-cac-membership'),
  ('mohua-so-3184-2022', 'MoHUA', 'S.O. 3184(E)', 2022, 'so-only', '2022-07-13', 'S.O. 3184(E)', 'housing-and-urban-affairs', 'rera-act-2016', 'mohua-rera-cac-membership'),
  ('mohua-so-1713-2026', 'MoHUA', 'S.O. 1713(E)', 2026, 'so-only', '2026-04-02', 'S.O. 1713(E)', 'housing-and-urban-affairs', 'rera-act-2016', 'mohua-rera-cac-membership'),
  -- Six UT/State RERA General Rules, Jan Vishwas 2026 batch (same day as the Ladakh pair)
  ('mohua-gsr-1024-2016', 'MoHUA', 'G.S.R. 1024(E)', 2016, 'so-only', '2016-10-31', 'G.S.R. 1024(E)', 'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-558-2026',  'MoHUA', 'G.S.R. 558(E)',  2026, 'so-only', '2026-07-01', 'G.S.R. 558(E)',  'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-1085-2016', 'MoHUA', 'G.S.R. 1085(E)', 2016, 'so-only', '2016-11-24', 'G.S.R. 1085(E)', 'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-553-2026',  'MoHUA', 'G.S.R. 553(E)',  2026, 'so-only', '2026-07-01', 'G.S.R. 553(E)',  'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-1020-2016', 'MoHUA', 'G.S.R. 1020(E)', 2016, 'so-only', '2016-10-31', 'G.S.R. 1020(E)', 'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-554-2026',  'MoHUA', 'G.S.R. 554(E)',  2026, 'so-only', '2026-07-01', 'G.S.R. 554(E)',  'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-1021-2016', 'MoHUA', 'G.S.R. 1021(E)', 2016, 'so-only', '2016-10-31', 'G.S.R. 1021(E)', 'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-555-2026',  'MoHUA', 'G.S.R. 555(E)',  2026, 'so-only', '2026-07-01', 'G.S.R. 555(E)',  'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-1023-2016', 'MoHUA', 'G.S.R. 1023(E)', 2016, 'so-only', '2016-10-31', 'G.S.R. 1023(E)', 'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-557-2026',  'MoHUA', 'G.S.R. 557(E)',  2026, 'so-only', '2026-07-01', 'G.S.R. 557(E)',  'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-1022-2016', 'MoHUA', 'G.S.R. 1022(E)', 2016, 'so-only', '2016-10-31', 'G.S.R. 1022(E)', 'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  ('mohua-gsr-556-2026',  'MoHUA', 'G.S.R. 556(E)',  2026, 'so-only', '2026-07-01', 'G.S.R. 556(E)',  'housing-and-urban-affairs', 'ut-rera-general-rules-2016', 'mohua-ut-rera-jan-vishwas-2026'),
  -- NCR Planning Board Act Schedule (S.O. 2979(E) collides with Power's, kept distinct)
  ('mohua-so-2979-2013', 'MoHUA', 'S.O. 2979(E)', 2013, 'so-only', '2013-10-01', 'S.O. 2979(E)', 'housing-and-urban-affairs', 'ncr-planning-board-act-1985-schedule', 'mohua-ncr-schedule-amendment'),
  ('mohua-so-3607-2026', 'MoHUA', 'S.O. 3607(E)', 2026, 'so-only', '2026-07-02', 'S.O. 3607(E)', 'housing-and-urban-affairs', 'ncr-planning-board-act-1985-schedule', 'mohua-ncr-schedule-amendment'),
  -- Metro Railways (Procedure of Claims) Rules
  ('mohua-gsr-353-2017', 'MoHUA', 'G.S.R. 353(E)', 2017, 'so-only', '2017-04-11', 'G.S.R. 353(E)', 'housing-and-urban-affairs', 'metro-railways-procedure-of-claims-rules-2017', 'mohua-metro-claims-rules-amendment'),
  ('mohua-gsr-402-2025', 'MoHUA', 'G.S.R. 402(E)', 2025, 'so-only', '2025-06-19', 'G.S.R. 402(E)', 'housing-and-urban-affairs', 'metro-railways-procedure-of-claims-rules-2017', 'mohua-metro-claims-rules-amendment'),
  -- Metro Railways Act Schedule alignments: shared 2009 Act-extension notification
  ('mohua-so-2625-2009', 'MoHUA', 'S.O. 2625(E)', 2009, 'so-only', '2009-10-16', 'S.O. 2625(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-bangalore'),
  ('mohua-so-1930-2025', 'MoHUA', 'S.O. 1930(E)', 2025, 'so-only', '2025-04-25', 'S.O. 1930(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-bangalore'),
  ('mohua-so-1848-2025', 'MoHUA', 'S.O. 1848(E)', 2025, 'so-only', '2025-04-24', 'S.O. 1848(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-thane'),
  ('mohua-so-2813-2013', 'MoHUA', 'S.O. 2813(E)', 2013, 'so-only', '2013-09-18', 'S.O. 2813(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-mumbai-line3'),
  ('mohua-so-4018-2024', 'MoHUA', 'S.O. 4018(E)', 2024, 'so-only', '2024-09-19', 'S.O. 4018(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-mumbai-line3'),
  ('mohua-so-4683-2020', 'MoHUA', 'S.O. 4683(E)', 2020, 'so-only', '2020-12-12', 'S.O. 4683(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-bhopal-indore'),
  ('mohua-so-3587-2024', 'MoHUA', 'S.O. 3587',    2024, 'bare',    '2024-08-22', 'S.O. 3587',    'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-bhopal-indore'),
  ('mohua-so-3588-2024', 'MoHUA', 'S.O. 3588(E)', 2024, 'so-only', '2024-08-22', 'S.O. 3588(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-bhopal-indore'),
  ('mohua-so-2731-2014', 'MoHUA', 'S.O. 2731(E)', 2014, 'so-only', '2014-10-20', 'S.O. 2731(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-nagpur'),
  ('mohua-so-3915-2023', 'MoHUA', 'S.O. 3915(E)', 2023, 'so-only', '2023-08-29', 'S.O. 3915(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-nagpur'),
  ('mohua-so-2061-2025', 'MoHUA', 'S.O. 2061(E)', 2025, 'so-only', '2025-05-08', 'S.O. 2061(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-nagpur'),
  ('mohua-so-2126-2019', 'MoHUA', 'S.O. 2126(E)', 2019, 'so-only', '2019-06-26', 'S.O. 2126(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-mumbai-line5'),
  ('mohua-so-4792-2026', 'MoHUA', 'S.O. 4792(E)', 2026, 'so-only', '2026-08-28', 'S.O. 4792(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-mumbai-line5'),
  -- Pune Metro hub
  ('mohua-so-2732-2014', 'MoHUA', 'S.O. 2732(E)', 2014, 'so-only', '2014-10-20', 'S.O. 2732(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-95-2018',   'MoHUA', 'S.O. 95(E)',   2018, 'so-only', '2018-01-05', 'S.O. 95(E)',   'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-3706-2019', 'MoHUA', 'S.O. 3706(E)', 2019, 'so-only', '2019-10-14', 'S.O. 3706(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-2819-2020', 'MoHUA', 'S.O. 2819(E)', 2020, 'so-only', '2020-08-19', 'S.O. 2819(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-2220-2024', 'MoHUA', 'S.O. 2220',    2024, 'bare',    '2024-06-07', 'S.O. 2220',    'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-372-2025',  'MoHUA', 'S.O. 372(E)',  2025, 'so-only', '2025-01-21', 'S.O. 372(E)',  'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-180-2026',  'MoHUA', 'S.O. 180(E)',  2026, 'so-only', '2026-01-13', 'S.O. 180(E)',  'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-2657-2026', 'MoHUA', 'S.O. 2657(E)', 2026, 'so-only', '2026-05-25', 'S.O. 2657(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-2065-2019', 'MoHUA', 'S.O. 2065(E)', 2019, 'so-only', '2019-06-25', 'S.O. 2065(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune'),
  ('mohua-so-1778-2024', 'MoHUA', 'S.O. 1778(E)', 2024, 'so-only', '2024-04-24', 'S.O. 1778(E)', 'housing-and-urban-affairs', 'metro-railways-act-1978-schedule', 'mohua-metro-pune');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mohua-so-4041-2026', 'mohua-so-3379-2026', 'corrigendum', 'research-agent-quoted-uncorroborated', '2026-09-03'),
  ('mohua-gsr-559-2026', 'mohua-gsr-619-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-3184-2022', 'mohua-so-2666-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-1713-2026', 'mohua-so-3184-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Six UT/State RERA amendments
  ('mohua-gsr-558-2026', 'mohua-gsr-1024-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-gsr-553-2026', 'mohua-gsr-1085-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-gsr-554-2026', 'mohua-gsr-1020-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-gsr-555-2026', 'mohua-gsr-1021-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-gsr-557-2026', 'mohua-gsr-1023-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-gsr-556-2026', 'mohua-gsr-1022-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- NCR Planning Board Schedule
  ('mohua-so-3607-2026', 'mohua-so-2979-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Metro Railways (Procedure of Claims) Rules
  ('mohua-gsr-402-2025', 'mohua-gsr-353-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Metro Railways Act Schedule alignments
  ('mohua-so-1930-2025', 'mohua-so-2625-2009', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-1848-2025', 'mohua-so-2625-2009', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-4018-2024', 'mohua-so-2813-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-3587-2024', 'mohua-so-4683-2020', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-3588-2024', 'mohua-so-4683-2020', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-2061-2025', 'mohua-so-2731-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-2061-2025', 'mohua-so-3915-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-4792-2026', 'mohua-so-2126-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-4792-2026', 'mohua-so-2625-2009', 'cites',  'research-agent-quoted', '2026-09-04'),
  -- Pune Metro hub
  ('mohua-so-95-2018',   'mohua-so-2732-2014', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-3706-2019', 'mohua-so-95-2018',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-2819-2020', 'mohua-so-95-2018',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-2220-2024', 'mohua-so-3706-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-2220-2024', 'mohua-so-2819-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-372-2025',  'mohua-so-3706-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-372-2025',  'mohua-so-2819-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-180-2026',  'mohua-so-3706-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-180-2026',  'mohua-so-2819-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-180-2026',  'mohua-so-2732-2014', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-180-2026',  'mohua-so-95-2018',   'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-180-2026',  'mohua-so-2220-2024', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-180-2026',  'mohua-so-372-2025',  'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-2657-2026', 'mohua-so-2732-2014', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mohua-so-1778-2024', 'mohua-so-2065-2019', 'amends', 'research-agent-quoted', '2026-09-04');
