-- Ministry of Jal Shakti. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3 pairs/
-- chains, one already the longest in this project: the 36-node Ravi and
-- Beas Waters Tribunal chain, unchanged this batch).
--
-- 9 further real subject threads found, several matching the Ravi-Beas
-- shape: Krishna Water Disputes Tribunal (a ~19-node near-annual
-- deadline-extension chain, comparable in scale to Ravi-Beas), Mahadayi
-- Water Disputes Tribunal (14 nodes), Mahanadi Water Disputes Tribunal (4
-- nodes, two independent relation types from one principal), Vansadhara
-- Water Disputes Tribunal (a genuinely novel "implements the award"
-- relation), Brahmaputra Board's High Powered Review Board (a rare
-- explicit "in supersession of" naming two historical predecessors), the
-- Ganga Flood Control Board and Ganga Flood Control Commission (two
-- legally distinct 1972 instruments issued the same day, easy to
-- conflate), and the National Dam Safety Authority (Functions and
-- Powers) Rules 2022 (a statutory-rules instrument, distinct from the
-- already-modeled National Committee on Dam Safety composition thread —
-- same Act, two different bodies). The already-modeled Clean Ganga
-- schedule thread (S.O. 3187(E)) turned out to have 3 further real
-- intermediate amendments, extending it to a 6-node chain.
--
-- SITE-QUIRK WARNINGS carried over from the research pass (not modeling
-- issues, just provenance notes): gazettetracker.com's own "Cite this
-- gazette" citation box mislabeled at least two pages with the wrong S.O.
-- number (the tribunal's constituting number instead of the page's own
-- notification number) — every citation below was taken from the Full
-- Text body's own operative line, never the citation box. The Ganga Flood
-- Control Commission's 11 May 2026 amendment was found indexed three
-- times under three different Gazette IDs (identical text, different
-- scrape dates) — modeled here as ONE node.
--
-- A REAL GENUINELY PARTIAL CHAIN, same discipline as this project's other
-- undocumented-gap cases: the Krishna WDT chain runs through an
-- unnumbered "Ministry of Water Resources order dated 5 February 2014"
-- that carries no G.S.R./S.O./bare number of any kind in any of the four
-- primary texts examined — the chain is modeled as two unlinked segments
-- either side of that real but unciteable gap, rather than bridging it
-- with an inferred edge.
--
-- A REAL FILE-NUMBER REUSE, not a true citation collision: "F. No.
-- A-50013/354/2024-E-III" is the citation for THREE separate real
-- Resolutions (Ganga Flood Control Board, twice, and the Ganga Flood
-- Control Commission, once) — Resolutions don't carry G.S.R./S.O. numbers,
-- so the file number alone cannot disambiguate; distinct gazette_id
-- suffixes by date+subject are used here instead.
--
-- Real leads NOT modeled: the unnumbered 5 Feb 2014 MoWR order (above);
-- Resolution No. 47/7/84 FC (Ganga Flood Control Commission's own prior
-- amendment) — seen only in the site's Detailed Summary, not confirmed in
-- Full Text, per this project's summary-vs-primary-text rule; assorted
-- litigant-filing dates (SLPs, State applications) embedded in the
-- tribunal chains, correctly excluded as they carry no gazette citation.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('jal-shakti', 'Ministry of Jal Shakti', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('dam-safety-act-2021-national-committee', 'Dam Safety Act, 2021 — National Committee on Dam Safety', 2021),
  ('clean-ganga-mission-schedule-2016', 'River Ganga (Rejuvenation, Protection and Management) Authorities Order, 2016 — National Mission for Clean Ganga schedule', 2016),
  ('ravi-beas-tribunal-1986', 'Inter-State River Water Disputes Act, 1956 — Ravi and Beas Waters Tribunal', 1986),
  ('krishna-water-disputes-tribunal-2004', 'Inter-State River Water Disputes Act, 1956 — Krishna Water Disputes Tribunal (KWDT-II)', 2004),
  ('mahadayi-water-disputes-tribunal-2010', 'Inter-State River Water Disputes Act, 1956 — Mahadayi Water Disputes Tribunal', 2010),
  ('mahanadi-water-disputes-tribunal-2018', 'Inter-State River Water Disputes Act, 1956 — Mahanadi Water Disputes Tribunal', 2018),
  ('vansadhara-water-disputes-tribunal-2010', 'Inter-State River Water Disputes Act, 1956 — Vansadhara Water Disputes Tribunal', 2010),
  ('brahmaputra-board-high-powered-review-board', 'Brahmaputra Board — High Powered Review Board', 1982),
  ('ganga-flood-control-board-1972', 'Ganga Flood Control Board, Resolution No. FC-47(2)/72', 1972),
  ('ganga-flood-control-commission-1972', 'Ganga Flood Control Commission, Resolution No. FC-47(3)/72', 1972),
  ('national-dam-safety-authority-rules-2022', 'National Dam Safety Authority (Functions and Powers) Rules, 2022', 2022);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('dam-safety-committee-amendment', 'National Committee on Dam Safety composition amendment', 'active'),
  ('clean-ganga-schedule-amendment', 'River Ganga Authorities Order, 2016 and its amendments (6-node chain)', 'active'),
  ('ravi-beas-tribunal-extensions', 'Ravi and Beas Waters Tribunal deadline extensions, 1986-2026', 'active'),
  ('krishna-wdt-extensions', 'Krishna Water Disputes Tribunal deadline-extension chain, 2004-2026', 'active'),
  ('mahadayi-wdt-extensions', 'Mahadayi Water Disputes Tribunal deadline-extension chain, 2010-2026', 'active'),
  ('mahanadi-wdt-amendments', 'Mahanadi Water Disputes Tribunal — extension and Chairman-substitution', 'active'),
  ('vansadhara-wdt-implementation', 'Vansadhara Water Disputes Tribunal award publication and implementation', 'active'),
  ('brahmaputra-hprb-reconstitution', 'Brahmaputra Board High Powered Review Board reconstitution', 'active'),
  ('ganga-flood-control-board-amendments', 'Ganga Flood Control Board resolution amendments', 'active'),
  ('ganga-flood-control-commission-amendments', 'Ganga Flood Control Commission resolution amendment', 'active'),
  ('national-dam-safety-authority-rules-amendment', 'National Dam Safety Authority (Functions and Powers) Rules amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: unchanged
  ('js-so-3395-2025', 'Jal Shakti', 'S.O. 3395(E)', 2025, 'so-only', '2025-07-24', 'S.O. 3395(E)', 'jal-shakti', 'dam-safety-act-2021-national-committee', 'dam-safety-committee-amendment'),
  ('js-so-4675-2025', 'Jal Shakti', 'S.O. 4675(E)', 2025, 'so-only', '2025-10-14', 'S.O. 4675(E)', 'jal-shakti', 'dam-safety-act-2021-national-committee', 'dam-safety-committee-amendment'),
  -- Clean Ganga schedule: extended to a 6-node chain
  ('js-so-3187-2016', 'Jal Shakti', 'S.O. 3187(E)', 2016, 'so-only', '2016-10-07', 'S.O. 3187(E)', 'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  ('js-so-1793-2019', 'Jal Shakti', 'S.O. 1793(E)', 2019, 'so-only', '2019-05-22', 'S.O. 1793(E)', 'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  ('js-so-137-2024',  'Jal Shakti', 'S.O. 137(E)',  2024, 'so-only', '2024-01-10', 'S.O. 137(E)',  'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  ('js-so-3845-2025', 'Jal Shakti', 'S.O. 3845',    2025, 'bare',    '2025-08-19', 'S.O. 3845',    'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  ('js-so-2337-2026', 'Jal Shakti', 'S.O. 2337(E)', 2026, 'so-only', '2026-05-07', 'S.O. 2337(E)', 'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  ('js-so-4427-2026', 'Jal Shakti', 'S.O. 4427(E)', 2026, 'so-only', '2026-08-07', 'S.O. 4427(E)', 'jal-shakti', 'clean-ganga-mission-schedule-2016', 'clean-ganga-schedule-amendment'),
  -- Ravi and Beas Waters Tribunal: unchanged 36-node chain
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
  ('js-so-3024-tribunal', 'Jal Shakti', 'S.O. 3024(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3024(E)', 'jal-shakti', 'ravi-beas-tribunal-1986', 'ravi-beas-tribunal-extensions'),
  -- Krishna Water Disputes Tribunal (partial chain, real unciteable gap)
  ('js-kwdt-451-2004',  'Jal Shakti', 'S.O. 451(E)',  2004, 'so-only', '2004-04-02', 'S.O. 451(E)',  'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-653-2012',  'Jal Shakti', 'S.O. 653(E)',  2012, 'so-only', '2012-03-29', 'S.O. 653(E)',  'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2339-2012', 'Jal Shakti', 'S.O. 2339(E)', 2012, 'so-only', '2012-09-28', 'S.O. 2339(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-916-2013',  'Jal Shakti', 'S.O. 916(E)',  2013, 'so-only', '2013-04-02', 'S.O. 916(E)',  'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2939-2013', 'Jal Shakti', 'S.O. 2939(E)', 2013, 'so-only', '2013-09-27', 'S.O. 2939(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-3515-2013', 'Jal Shakti', 'S.O. 3515(E)', 2013, 'so-only', '2013-11-27', 'S.O. 3515(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  -- [real unciteable gap: unnumbered MoWR order dated 2014-02-05 — not modeled, see header]
  ('js-kwdt-1290-2014', 'Jal Shakti', 'S.O. 1290(E)', 2014, 'so-only', '2014-05-15', 'S.O. 1290(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2462-2016', 'Jal Shakti', 'S.O. 2462(E)', 2016, 'so-only', '2016-07-18', 'S.O. 2462(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2459-2017', 'Jal Shakti', 'S.O. 2459(E)', 2017, 'so-only', '2017-07-31', 'S.O. 2459(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-3950-2018', 'Jal Shakti', 'S.O. 3950(E)', 2018, 'so-only', '2018-08-09', 'S.O. 3950(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-3146-2019', 'Jal Shakti', 'S.O. 3146(E)', 2019, 'so-only', '2019-08-29', 'S.O. 3146(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2412-2020', 'Jal Shakti', 'S.O. 2412(E)', 2020, 'so-only', '2020-07-23', 'S.O. 2412(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2890-2021', 'Jal Shakti', 'S.O. 2890(E)', 2021, 'so-only', '2021-07-20', 'S.O. 2890(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2916-2022', 'Jal Shakti', 'S.O. 2916(E)', 2022, 'so-only', '2022-06-27', 'S.O. 2916(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-2994-2023', 'Jal Shakti', 'S.O. 2994(E)', 2023, 'so-only', '2023-07-06', 'S.O. 2994(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-4375-2023', 'Jal Shakti', 'S.O. 4375(E)', 2023, 'so-only', '2023-10-06', 'S.O. 4375(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-1507-2024', 'Jal Shakti', 'S.O. 1507(E)', 2024, 'so-only', '2024-03-21', 'S.O. 1507(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-3221-2025', 'Jal Shakti', 'S.O. 3221(E)', 2025, 'so-only', '2025-07-10', 'S.O. 3221(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  ('js-kwdt-3039-2026', 'Jal Shakti', 'S.O. 3039(E)', 2026, 'so-only', '2026-06-12', 'S.O. 3039(E)', 'jal-shakti', 'krishna-water-disputes-tribunal-2004', 'krishna-wdt-extensions'),
  -- Mahadayi Water Disputes Tribunal
  ('js-mwdt-2786-2010', 'Jal Shakti', 'S.O. 2786(E)', 2010, 'so-only', '2010-11-16', 'S.O. 2786(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-2908-2014', 'Jal Shakti', 'S.O. 2908(E)', 2014, 'so-only', '2014-11-13', 'S.O. 2908(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-2686-2016', 'Jal Shakti', 'S.O. 2686(E)', 2016, 'so-only', '2016-08-11', 'S.O. 2686(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-2332-2017', 'Jal Shakti', 'S.O. 2332(E)', 2017, 'so-only', '2017-07-24', 'S.O. 2332(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-768-2020',  'Jal Shakti', 'S.O. 768(E)',  2020, 'so-only', '2020-02-17', 'S.O. 768(E)',  'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-888-2020',  'Jal Shakti', 'S.O. 888(E)',  2020, 'so-only', '2020-02-27', 'S.O. 888(E)',  'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-2830-2020', 'Jal Shakti', 'S.O. 2830(E)', 2020, 'so-only', '2020-08-17', 'S.O. 2830(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-2889-2021', 'Jal Shakti', 'S.O. 2889(E)', 2021, 'so-only', '2021-07-20', 'S.O. 2889(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-3348-2022', 'Jal Shakti', 'S.O. 3348(E)', 2022, 'so-only', '2022-07-21', 'S.O. 3348(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-3305-2023', 'Jal Shakti', 'S.O. 3305(E)', 2023, 'so-only', '2023-07-21', 'S.O. 3305(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-3501-2024', 'Jal Shakti', 'S.O. 3501(E)', 2024, 'so-only', '2024-08-19', 'S.O. 3501(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-975-2025',  'Jal Shakti', 'S.O. 975(E)',  2025, 'so-only', '2025-02-25', 'S.O. 975(E)',  'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-3628-2025', 'Jal Shakti', 'S.O. 3628(E)', 2025, 'so-only', '2025-08-05', 'S.O. 3628(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  ('js-mwdt-3499-2026', 'Jal Shakti', 'S.O. 3499(E)', 2026, 'so-only', '2026-06-29', 'S.O. 3499(E)', 'jal-shakti', 'mahadayi-water-disputes-tribunal-2010', 'mahadayi-wdt-extensions'),
  -- Mahanadi Water Disputes Tribunal
  ('js-manadi-1114-2018', 'Jal Shakti', 'S.O. 1114(E)', 2018, 'so-only', '2018-03-12', 'S.O. 1114(E)', 'jal-shakti', 'mahanadi-water-disputes-tribunal-2018', 'mahanadi-wdt-amendments'),
  ('js-manadi-2176-2021', 'Jal Shakti', 'S.O. 2176(E)', 2021, 'so-only', '2021-06-03', 'S.O. 2176(E)', 'jal-shakti', 'mahanadi-water-disputes-tribunal-2018', 'mahanadi-wdt-amendments'),
  ('js-manadi-5379-2024', 'Jal Shakti', 'S.O. 5379(E)', 2024, 'so-only', '2024-12-12', 'S.O. 5379(E)', 'jal-shakti', 'mahanadi-water-disputes-tribunal-2018', 'mahanadi-wdt-amendments'),
  ('js-manadi-1858-2026', 'Jal Shakti', 'S.O. 1858(E)', 2026, 'so-only', '2026-04-10', 'S.O. 1858(E)', 'jal-shakti', 'mahanadi-water-disputes-tribunal-2018', 'mahanadi-wdt-amendments'),
  -- Vansadhara Water Disputes Tribunal
  ('js-vansa-465-2010',  'Jal Shakti', 'S.O. 465(E)',  2010, 'so-only', '2010-02-24', 'S.O. 465(E)',  'jal-shakti', 'vansadhara-water-disputes-tribunal-2010', 'vansadhara-wdt-implementation'),
  ('js-vansa-1666-2026', 'Jal Shakti', 'S.O. 1666(E)', 2026, 'so-only', '2026-03-30', 'S.O. 1666(E)', 'jal-shakti', 'vansadhara-water-disputes-tribunal-2010', 'vansadhara-wdt-implementation'),
  ('js-vansa-4580-2026', 'Jal Shakti', 'S.O. 4580(E)', 2026, 'so-only', '2026-08-10', 'S.O. 4580(E)', 'jal-shakti', 'vansadhara-water-disputes-tribunal-2010', 'vansadhara-wdt-implementation'),
  -- Brahmaputra Board High Powered Review Board (bare pre-1994 numbering)
  ('js-brahma-2-17-80-fc', 'Jal Shakti', 'No. 2(17)/80-FC', 1982, 'bare', '1982-03-19', 'No. 2(17)/80-FC', 'jal-shakti', 'brahmaputra-board-high-powered-review-board', 'brahmaputra-hprb-reconstitution'),
  ('js-brahma-23-8-92-er', 'Jal Shakti', 'No. 23/8/92-E.R.', 1992, 'bare', '1992-10-01', 'No. 23/8/92-E.R.', 'jal-shakti', 'brahmaputra-board-high-powered-review-board', 'brahmaputra-hprb-reconstitution'),
  ('js-brahma-a50013-48-2025', 'Jal Shakti', 'No. A-50013/48/2025-E-III', 2026, 'bare', '2026-05-08', 'No. A-50013/48/2025-E-III', 'jal-shakti', 'brahmaputra-board-high-powered-review-board', 'brahmaputra-hprb-reconstitution'),
  -- Ganga Flood Control Board (1972 constitution + 2 amendments, same file number reused)
  ('js-gfcb-fc-47-2-72', 'Jal Shakti', 'Resolution No. FC-47(2)/72', 1972, 'bare', '1972-04-18', 'Resolution No. FC-47(2)/72', 'jal-shakti', 'ganga-flood-control-board-1972', 'ganga-flood-control-board-amendments'),
  ('js-gfcb-a50013-354-2024-dec', 'Jal Shakti', 'A-50013/354/2024-E-III', 2024, 'bare', '2024-12-10', 'A-50013/354/2024-E-III', 'jal-shakti', 'ganga-flood-control-board-1972', 'ganga-flood-control-board-amendments'),
  ('js-gfcb-a50013-354-2026-may', 'Jal Shakti', 'A-50013/354/2024-E-III', 2026, 'bare', '2026-05-11', 'A-50013/354/2024-E-III', 'jal-shakti', 'ganga-flood-control-board-1972', 'ganga-flood-control-board-amendments'),
  -- Ganga Flood Control Commission (distinct 1972 instrument; deferred prior 1988 link)
  ('js-gfcc-fc-47-3-72', 'Jal Shakti', 'Resolution No. FC-47(3)/72', 1972, 'bare', '1972-04-18', 'Resolution No. FC-47(3)/72', 'jal-shakti', 'ganga-flood-control-commission-1972', 'ganga-flood-control-commission-amendments'),
  ('js-gfcc-a50013-354-2026-may', 'Jal Shakti', 'A-50013/354/2024-E-III', 2026, 'bare', '2026-05-11', 'A-50013/354/2024-E-III', 'jal-shakti', 'ganga-flood-control-commission-1972', 'ganga-flood-control-commission-amendments'),
  -- National Dam Safety Authority (Functions and Powers) Rules, 2022
  ('js-gsr-135-2022', 'Jal Shakti', 'G.S.R. 135(E)', 2022, 'so-only', '2022-02-17', 'G.S.R. 135(E)', 'jal-shakti', 'national-dam-safety-authority-rules-2022', 'national-dam-safety-authority-rules-amendment'),
  ('js-gsr-842-2023', 'Jal Shakti', 'G.S.R. 842(E)', 2023, 'so-only', '2023-11-14', 'G.S.R. 842(E)', 'jal-shakti', 'national-dam-safety-authority-rules-2022', 'national-dam-safety-authority-rules-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('js-so-4675-2025', 'js-so-3395-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Clean Ganga schedule 6-node chain (replaces the old direct 3187->3845 edge)
  ('js-so-1793-2019', 'js-so-3187-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-137-2024',  'js-so-1793-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-3845-2025', 'js-so-137-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-2337-2026', 'js-so-3845-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-so-4427-2026', 'js-so-2337-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Ravi-Beas (unchanged, 35 edges)
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
  ('js-so-3024-tribunal', 'js-so-3056-tribunal', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Krishna WDT (two segments either side of the real unciteable gap)
  ('js-kwdt-653-2012', 'js-kwdt-451-2004', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2339-2012', 'js-kwdt-653-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-916-2013', 'js-kwdt-2339-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2939-2013', 'js-kwdt-916-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-3515-2013', 'js-kwdt-2939-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2462-2016', 'js-kwdt-1290-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2459-2017', 'js-kwdt-2462-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-3950-2018', 'js-kwdt-2459-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-3146-2019', 'js-kwdt-3950-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2412-2020', 'js-kwdt-3146-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2890-2021', 'js-kwdt-2412-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2916-2022', 'js-kwdt-2890-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-2994-2023', 'js-kwdt-2916-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-1507-2024', 'js-kwdt-2994-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-3221-2025', 'js-kwdt-1507-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-3039-2026', 'js-kwdt-3221-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-4375-2023', 'js-kwdt-451-2004', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('js-kwdt-4375-2023', 'js-kwdt-2994-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Mahadayi WDT
  ('js-mwdt-2908-2014', 'js-mwdt-2786-2010', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-2686-2016', 'js-mwdt-2908-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-2332-2017', 'js-mwdt-2686-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-768-2020',  'js-mwdt-2332-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-888-2020',  'js-mwdt-2786-2010', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-2830-2020', 'js-mwdt-768-2020',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-2889-2021', 'js-mwdt-2830-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-3348-2022', 'js-mwdt-2889-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-3305-2023', 'js-mwdt-3348-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-3501-2024', 'js-mwdt-3305-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-975-2025',  'js-mwdt-3501-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-3628-2025', 'js-mwdt-975-2025',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-mwdt-3499-2026', 'js-mwdt-3628-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Mahanadi WDT
  ('js-manadi-2176-2021', 'js-manadi-1114-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-manadi-5379-2024', 'js-manadi-1114-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-manadi-1858-2026', 'js-manadi-2176-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Vansadhara WDT
  ('js-vansa-1666-2026', 'js-vansa-465-2010',  'cites', 'research-agent-quoted', '2026-09-04'),
  ('js-vansa-4580-2026', 'js-vansa-465-2010',  'cites', 'research-agent-quoted', '2026-09-04'),
  ('js-vansa-4580-2026', 'js-vansa-1666-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Brahmaputra Board HPRB
  ('js-brahma-a50013-48-2025', 'js-brahma-2-17-80-fc',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('js-brahma-a50013-48-2025', 'js-brahma-23-8-92-er',  'cites', 'research-agent-quoted', '2026-09-04'),
  -- Ganga Flood Control Board
  ('js-gfcb-a50013-354-2024-dec', 'js-gfcb-fc-47-2-72', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('js-gfcb-a50013-354-2026-may', 'js-gfcb-a50013-354-2024-dec', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Ganga Flood Control Commission
  ('js-gfcc-a50013-354-2026-may', 'js-gfcc-fc-47-3-72', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- National Dam Safety Authority Rules
  ('js-gsr-842-2023', 'js-gsr-135-2022', 'amends', 'research-agent-quoted', '2026-09-04');
