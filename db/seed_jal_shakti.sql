-- Ministry of Jal Shakti pilot. Three real pairs researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04.
--
-- Pairs 1/2: amendment-in-notification template (extract/jal_shakti_patterns.py),
-- notably needing TWO ministry-name variants — the current "Ministry of
-- Jal Shakti" and its pre-2019 predecessor "Ministry of Water Resources,
-- River Development, and Ganga Rejuvenation", since a 2025 amendment
-- still cites the erstwhile name verbatim.
--
-- Pair 3 is the longest chain in this project: 36 nodes / 35 edges, the
-- Ravi and Beas Waters Tribunal's near-annual deadline-extension history
-- from 1986 to 2026, all quoted verbatim in one real Note clause and
-- generated programmatically from that quote to avoid transcription
-- error across so many rows. Node 2 (S.O. 3234, 1996) is a bare form
-- with no "(E)" suffix — modeled per the established WCD/DoPT/DST
-- precedent.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('jal-shakti', 'Ministry of Jal Shakti', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('dam-safety-act-2021-national-committee', 'Dam Safety Act, 2021 — National Committee on Dam Safety', 2021),
  ('clean-ganga-mission-schedule-2016', 'National Mission for Clean Ganga schedule notification, 2016', 2016),
  ('ravi-beas-tribunal-1986', 'Inter-State River Water Disputes Act, 1956 — Ravi and Beas Waters Tribunal', 1986);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('dam-safety-committee-amendment', 'National Committee on Dam Safety composition amendment', 'active'),
  ('clean-ganga-schedule-amendment', 'National Mission for Clean Ganga schedule amendment', 'active'),
  ('ravi-beas-tribunal-extensions', 'Ravi and Beas Waters Tribunal deadline extensions, 1986-2026', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain
  ('js-so-3395-2025', 'Jal Shakti', 'S.O. 3395(E)', 2025, 'so-only', '2025-07-24', 'S.O. 3395(E)', 'jal-shakti', 'dam-safety-act-2021-national-committee', 'dam-safety-committee-amendment'),
  ('js-so-4675-2025', 'Jal Shakti', 'S.O. 4675(E)', 2025, 'so-only', '2025-10-14', 'S.O. 4675(E)', 'jal-shakti', 'dam-safety-act-2021-national-committee', 'dam-safety-committee-amendment'),
  -- Pair 2: two-node chain, self-citation is bare (no "(E)")
  ('js-so-3187-2016', 'Jal Shakti', 'S.O. 3187(E)', 2016, 'so-only', '2016-10-07', 'S.O. 3187(E)', 'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  ('js-so-3845-2025', 'Jal Shakti', 'S.O. 3845',    2025, 'bare',    '2025-08-19', 'S.O. 3845',    'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  -- Pair 3: 36-node Ravi and Beas Waters Tribunal chain
  ('js-so-169-tribunal', 'Jal Shakti', 'S.O. 169(E)', 1986, 'so-only', '1986-04-02', 'S.O. 169(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-3234-tribunal', 'Jal Shakti', 'S.O. 3234', 1996, 'bare', '1996-11-23', 'S.O. 3234', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-666-tribunal', 'Jal Shakti', 'S.O. 666(E)', 2003, 'so-only', '2003-06-10', 'S.O. 666(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-905-tribunal', 'Jal Shakti', 'S.O. 905(E)', 2003, 'so-only', '2003-08-05', 'S.O. 905(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-889-tribunal', 'Jal Shakti', 'S.O. 889(E)', 2004, 'so-only', '2004-08-05', 'S.O. 889(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-166-tribunal', 'Jal Shakti', 'S.O. 166(E)', 2005, 'so-only', '2005-02-04', 'S.O. 166(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1093-tribunal', 'Jal Shakti', 'S.O. 1093(E)', 2005, 'so-only', '2005-08-04', 'S.O. 1093(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-133-tribunal', 'Jal Shakti', 'S.O. 133(E)', 2006, 'so-only', '2006-02-03', 'S.O. 133(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1218-tribunal', 'Jal Shakti', 'S.O. 1218(E)', 2006, 'so-only', '2006-07-28', 'S.O. 1218(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-104-tribunal', 'Jal Shakti', 'S.O. 104(E)', 2007, 'so-only', '2007-02-02', 'S.O. 104(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1112-tribunal', 'Jal Shakti', 'S.O. 1112(E)', 2007, 'so-only', '2007-07-06', 'S.O. 1112(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-212-tribunal', 'Jal Shakti', 'S.O. 212(E)', 2008, 'so-only', '2008-01-30', 'S.O. 212(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1700-tribunal', 'Jal Shakti', 'S.O. 1700(E)', 2008, 'so-only', '2008-07-16', 'S.O. 1700(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-397-tribunal', 'Jal Shakti', 'S.O. 397(E)', 2009, 'so-only', '2009-02-04', 'S.O. 397(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1812-tribunal', 'Jal Shakti', 'S.O. 1812(E)', 2009, 'so-only', '2009-07-23', 'S.O. 1812(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-203-tribunal', 'Jal Shakti', 'S.O. 203(E)', 2010, 'so-only', '2010-01-29', 'S.O. 203(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1920-tribunal', 'Jal Shakti', 'S.O. 1920(E)', 2010, 'so-only', '2010-08-05', 'S.O. 1920(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-250-tribunal', 'Jal Shakti', 'S.O. 250(E)', 2011, 'so-only', '2011-02-04', 'S.O. 250(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1803-tribunal', 'Jal Shakti', 'S.O. 1803(E)', 2011, 'so-only', '2011-08-05', 'S.O. 1803(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-216-tribunal', 'Jal Shakti', 'S.O. 216(E)', 2012, 'so-only', '2012-02-03', 'S.O. 216(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-1736-tribunal', 'Jal Shakti', 'S.O. 1736(E)', 2012, 'so-only', '2012-08-03', 'S.O. 1736(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-317-tribunal', 'Jal Shakti', 'S.O. 317(E)', 2013, 'so-only', '2013-02-04', 'S.O. 317(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2310-tribunal', 'Jal Shakti', 'S.O. 2310(E)', 2013, 'so-only', '2013-07-29', 'S.O. 2310(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2002-tribunal', 'Jal Shakti', 'S.O. 2002(E)', 2014, 'so-only', '2014-08-06', 'S.O. 2002(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2176-tribunal', 'Jal Shakti', 'S.O. 2176(E)', 2015, 'so-only', '2015-08-10', 'S.O. 2176(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2571-tribunal', 'Jal Shakti', 'S.O. 2571(E)', 2016, 'so-only', '2016-08-01', 'S.O. 2571(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2458-tribunal', 'Jal Shakti', 'S.O. 2458(E)', 2017, 'so-only', '2017-08-03', 'S.O. 2458(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-3949-tribunal', 'Jal Shakti', 'S.O. 3949(E)', 2018, 'so-only', '2018-08-09', 'S.O. 3949(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2754-tribunal', 'Jal Shakti', 'S.O. 2754(E)', 2019, 'so-only', '2019-08-01', 'S.O. 2754(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2443-tribunal', 'Jal Shakti', 'S.O. 2443(E)', 2020, 'so-only', '2020-07-27', 'S.O. 2443(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-3597-tribunal', 'Jal Shakti', 'S.O. 3597(E)', 2021, 'so-only', '2021-09-03', 'S.O. 3597(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-3696-tribunal', 'Jal Shakti', 'S.O. 3696(E)', 2022, 'so-only', '2022-08-04', 'S.O. 3696(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-2768-tribunal', 'Jal Shakti', 'S.O. 2768(E)', 2023, 'so-only', '2023-06-26', 'S.O. 2768(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-3114-tribunal', 'Jal Shakti', 'S.O. 3114(E)', 2024, 'so-only', '2024-08-05', 'S.O. 3114(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-3056-tribunal', 'Jal Shakti', 'S.O. 3056(E)', 2025, 'so-only', '2025-07-09', 'S.O. 3056(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  ('js-so-3024-tribunal', 'Jal Shakti', 'S.O. 3024(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3024(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('js-so-4675-2025', 'js-so-3395-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3845-2025', 'js-so-3187-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3234-tribunal', 'js-so-169-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-666-tribunal', 'js-so-3234-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-905-tribunal', 'js-so-666-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-889-tribunal', 'js-so-905-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-166-tribunal', 'js-so-889-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1093-tribunal', 'js-so-166-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-133-tribunal', 'js-so-1093-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1218-tribunal', 'js-so-133-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-104-tribunal', 'js-so-1218-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1112-tribunal', 'js-so-104-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-212-tribunal', 'js-so-1112-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1700-tribunal', 'js-so-212-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-397-tribunal', 'js-so-1700-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1812-tribunal', 'js-so-397-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-203-tribunal', 'js-so-1812-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1920-tribunal', 'js-so-203-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-250-tribunal', 'js-so-1920-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1803-tribunal', 'js-so-250-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-216-tribunal', 'js-so-1803-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-1736-tribunal', 'js-so-216-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-317-tribunal', 'js-so-1736-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2310-tribunal', 'js-so-317-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2002-tribunal', 'js-so-2310-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2176-tribunal', 'js-so-2002-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2571-tribunal', 'js-so-2176-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2458-tribunal', 'js-so-2571-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3949-tribunal', 'js-so-2458-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2754-tribunal', 'js-so-3949-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2443-tribunal', 'js-so-2754-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3597-tribunal', 'js-so-2443-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3696-tribunal', 'js-so-3597-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2768-tribunal', 'js-so-3696-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3114-tribunal', 'js-so-2768-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3056-tribunal', 'js-so-3114-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3024-tribunal', 'js-so-3056-tribunal', 'amends', 'research-agent-quoted', '2026-09-04');
