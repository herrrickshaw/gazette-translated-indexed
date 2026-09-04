-- Ministry of Rural Development pilot. Three real MGNREGA note-chains
-- researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04, all under the Mahatma Gandhi National Rural Employment
-- Guarantee Act, 2005 (42 of 2005) but two different subjects (Schedule I
-- paragraph amendments vs. the wage-rate Schedule under s.6(1)).
--
-- Pairs 1/2 form a genuinely PARTIAL chain, not a full one: S.O. 4288(E)'s
-- own Note names its immediate predecessor as S.O. 3622(E), and S.O.
-- 3622(E)'s own Note names ITS immediate predecessor as S.O. 3126(E) — both
-- edges are directly evidenced. Both Notes ALSO name S.O. 323(E) (2007) as
-- Schedule I's very first amendment, but neither quote bridges the 15-year
-- gap between S.O. 323(E) (2007) and S.O. 3126(E) (2022) — real
-- intervening amendments plainly exist (Schedule I is amended often) but
-- were not individually captured this session, so no edge asserts a direct
-- 323(E)-to-3126(E) relationship. S.O. 323(E) is recorded as a real,
-- dated fact (the chain's documented origin point) without inventing the
-- missing intermediate links.
--
-- Pair 3 IS a complete chain: a 14-node Note (principal + 12 named
-- amendments + the current notification), the longest S.O.-numbered
-- chain modeled in this project so far.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('rural-development', 'Ministry of Rural Development', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('mgnrega-2005-schedule-1', 'MGNREGA, 2005 — Schedule I', 2005),
  ('mgnrega-2005-wage-schedule', 'MGNREGA, 2005 — wage-rate Schedule, s.6(1)', 2005);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mgnrega-schedule-1-amendments', 'MGNREGA Schedule I paragraph amendments', 'active'),
  ('mgnrega-wage-rate-schedule', 'MGNREGA annual wage-rate Schedule', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pairs 1/2: documented origin point (real, dated, but not bridged
  -- forward) plus the two directly-evidenced edges
  ('mord-so-323-2007',  'Rural Development', 'S.O. 323(E)',  2007, 'so-only', '2007-03-06', 'S.O. 323(E)',  'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  ('mord-so-3126-2022', 'Rural Development', 'S.O. 3126(E)', 2022, 'so-only', '2022-07-07', 'S.O. 3126(E)', 'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  ('mord-so-3622-2025', 'Rural Development', 'S.O. 3622(E)', 2025, 'so-only', '2025-08-06', 'S.O. 3622(E)', 'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  ('mord-so-4288-2025', 'Rural Development', 'S.O. 4288(E)', 2025, 'so-only', '2025-09-23', 'S.O. 4288(E)', 'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  -- Pair 3: fourteen-node chain
  ('mord-so-463-2013',  'Rural Development', 'S.O. 463(E)',  2013, 'so-only', '2013-02-26', 'S.O. 463(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-400-2014',  'Rural Development', 'S.O. 400(E)',  2014, 'so-only', '2014-02-13', 'S.O. 400(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-2118-2014', 'Rural Development', 'S.O. 2118(E)', 2014, 'so-only', '2014-08-22', 'S.O. 2118(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-890-2015',  'Rural Development', 'S.O. 890(E)',  2015, 'so-only', '2015-03-31', 'S.O. 890(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1205-2016', 'Rural Development', 'S.O. 1205(E)', 2016, 'so-only', '2016-03-23', 'S.O. 1205(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-666-2017',  'Rural Development', 'S.O. 666(E)',  2017, 'so-only', '2017-02-28', 'S.O. 666(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1406-2018', 'Rural Development', 'S.O. 1406(E)', 2018, 'so-only', '2018-03-28', 'S.O. 1406(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1424-2019', 'Rural Development', 'S.O. 1424(E)', 2019, 'so-only', '2019-03-26', 'S.O. 1424(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1203-2020', 'Rural Development', 'S.O. 1203(E)', 2020, 'so-only', '2020-03-23', 'S.O. 1203(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1206-2021', 'Rural Development', 'S.O. 1206(E)', 2021, 'so-only', '2021-03-15', 'S.O. 1206(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1427-2022', 'Rural Development', 'S.O. 1427(E)', 2022, 'so-only', '2022-03-28', 'S.O. 1427(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1425-2023', 'Rural Development', 'S.O. 1425(E)', 2023, 'so-only', '2023-03-24', 'S.O. 1425(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1562-2024', 'Rural Development', 'S.O. 1562(E)', 2024, 'so-only', '2024-03-27', 'S.O. 1562(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1463-2025', 'Rural Development', 'S.O. 1463(E)', 2025, 'so-only', '2025-03-27', 'S.O. 1463(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mord-so-3622-2025', 'mord-so-3126-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-4288-2025', 'mord-so-3622-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-400-2014',  'mord-so-463-2013',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-2118-2014', 'mord-so-400-2014',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-890-2015',  'mord-so-2118-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1205-2016', 'mord-so-890-2015',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-666-2017',  'mord-so-1205-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1406-2018', 'mord-so-666-2017',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1424-2019', 'mord-so-1406-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1203-2020', 'mord-so-1424-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1206-2021', 'mord-so-1203-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1427-2022', 'mord-so-1206-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1425-2023', 'mord-so-1427-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1562-2024', 'mord-so-1425-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1463-2025', 'mord-so-1562-2024', 'amends', 'research-agent-quoted', '2026-09-04');
