-- Department of Space (ISRO) pilot. The tracker lists only 2 total
-- notifications for this department; one real, note-chain-shaped
-- amendment exists, researched via gazettetracker.com (Full Text
-- section, primary), 2026-09-04.
--
-- The Note names a 39-link amendment history back to the 1976 principal
-- rules, printed as a table (Notification No. / Date / S.O. No. / Date
-- columns) rather than the usual numbered prose list every other
-- note-chain in this project uses.
--
-- Depth pass (2026-09-05): the "Login to read full text" gate on
-- gazettetracker turned out to be CSS-only — the full 39-row table was
-- already present server-side. Column semantics are now resolved: col 1/2
-- = the internal file number and its signing date; col 3/4 = the S.O.
-- number assigned on Gazette publication and that Gazette's own date.
-- Full table (transcribed from the 2025 notification's own Note, PyMuPDF
-- text layer of egazette.gov.in/WriteReadData/2025/268792.pdf), verified
-- against two of its own rows independently re-fetched as their own
-- primary documents (rows 36 and 38, now modeled below as their own
-- nodes/edges):
--
-- Sl | Notification No.         | Date       | S.O. No.  | Date
--  1 | 2/10(32)/76-I             | 10.02.1977 | 780       | 12.03.1977
--  2 | 2/10(32)/76-I             | 16.05.1977 | 2127      | 25.06.1977
--  3 | 2/10(27)/76-I             | 01.08.1977 | 2709      | 27.08.1977
--  4 | 2/7(5)/77-I               | 15.02.1978 | 585       | 25.02.1978
--  5 | 2/7(5)/77-I               | 27.05.1978 | 1780      | 17.06.1978
--  6 | 2/9(12)/74-III            | 16.03.1979 | 1178      | 07.04.1979
--  7 | 9/4(1)/80-III             | 26.05.1980 | 1684      | 21.06.1980
--  8 | 9/4(1)/80-III             | 05.09.1980 | 2586      | 27.09.1980
--  9 | 9/4(1)/80-III             | 13.10.1980 | 3299      | 29.11.1980
-- 10 | 9/4(1)/80-III             | 13.10.1980 | 3300      | 29.11.1980  -- twin same-day amendments, not a dup
-- 11 | 9/4(1)/80-III             | 20.12.1980 | 215       | 17.01.1981
-- 12 | 2/8(1)/81-I               | 28.08.1981 | 2592      | 03.10.1981
-- 13 | 2/8(1)/81-I               | 16.07.1982 | 3113      | 04.09.1982
-- 14 | 2/9(1)/83-I(V)            | 29.07.1985 | 4280      | 14.09.1985
-- 15 | 2/5(1)/85-V               | 02.01.1986 | 510       | 08.02.1986
-- 16 | 2/9(1)/83-I(V)            | 02.01.1986 | 511       | 08.02.1986
-- 17 | 2/5(1)/86-V               | 17.03.1986 | 1309      | 29.03.1986
-- 18 | 2/5(2)/86-V               | 20.10.1986 | 3874      | 15.11.1986
-- 19 | 2/5(1)/90-VI              | 01.01.1991 | 99        | 09.02.1991
-- 20 | 2/5(2)/86-V(VI)(Vol.III)  | 15.11.1991 | 334       | 01.02.1992
-- 21 | 2/5(1)/91-VI              | 23.10.1992 | 2891      | 21.11.1992
-- 22 | 2/5(1)/95-V               | 24.03.1995 | 1029      | 15.04.1995
-- 23 | 2/5(1)/91-V               | 12.10.1995 | 2856      | 28.10.1995
-- 24 | 2/5(1)/91-V               | 27.03.1996 | 1241      | 20.04.1996
-- 25 | 2/5(1)/95-V (2018/2019 printings; 2025 printing has "98-V" —
--    | flagged collision, 2-of-3 sources favor 95-V, kept as printed
--    | in the citing 2025 doc but noted)          | 23.12.1997 | 83 | 10.01.1998
-- 26 | 2/5(1)/98-V               | 30.06.2000 | 1763      | 05.08.2000
-- 27 | 2/5(1)/98-V               | 27.12.2000 | 34        | 13.01.2001
-- 28 | 2/5(1)/98-V               | 24.01.2001 | 254       | 10.02.2001
-- 29 | 2/5(1)/98-V               | 18.03.2004 | 804       | 28.03.2004
-- 30 | 4/5/1/2004-V              | 22.06.2005 | 2489      | 16.07.2005
-- 31 | 4/5/1/2004-V              | 31.01.2006 | 544       | 11.02.2006
-- 32 | 4/5/1/2004-V              | 20.11.2007 | 3434      | 08.12.2007
-- 33 | 4/5/1/2004-V              | 01.09.2008 | 2760      | 04.10.2008
-- 34 | 4/5/1/2004-V              | 21.05.2009 | 1538(E)   | 23.06.2009
-- 35 | E.14015/1/2012-IV         | 06.03.2013 | 830(E)    | 26.03.2013
-- 36 | E.14015/1/2012-IV         | 04.10.2017 | 424(E)    | 30.01.2018  -- modeled below (dos-so-424-2018)
-- 37 | E.14015/1/2012-IV         | 25.01.2019 | 229       | 16.02.2019
-- 38 | E.14015/1/2012-IV         | 29.10.2019 | 4235(E)   | 22.11.2019  -- modeled below (dos-so-4235-2019)
-- 39 | E.14015/1/2012-IV         | 25.04.2022 | 2018(E)   | 29.04.2022  -- not independently located
--
-- Rows 1-35, 37, 39 rest on this Note's own citation only (not
-- individually re-fetched as separate primary documents — most
-- pre-2010s ones aren't practically locatable without exact archive
-- IDs) so are documented here in full rather than turned into 37
-- individually-modeled nodes; only rows 36 and 38 were independently
-- pulled as their own official PDFs and are modeled as real edges below,
-- the same "transcribe in full, model what's independently verified"
-- discipline used for the CSB Rules footnote (Textiles) and the RPF
-- Rules chain (Railways).
--
-- Also found: `publish_date` on S.O. 5979(E) was the notification's
-- SIGNING date (15 Dec 2025); the Gazette's own issue date is 24 Dec
-- 2025 (Gazette No. 5780) — corrected below. The tracker's other listed
-- item is a separate, unrelated file-number-only notification (National
-- Space Day declaration, F. No. DS_5-18013/8/2023-V, 13 Oct 2023, no
-- S.O./G.S.R. at all, cites nothing) — checked, not modeled (no edge).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('department-of-space', 'Department of Space', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('dos-employees-cca-rules-1976', 'Department of Space Employees'' (Classification, Control and Appeal) Rules, 1976', 1976);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('dos-cca-rules-amendments', 'Department of Space Employees'' CCA Rules and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('dos-so-270-1976',  'DoS', 'S.O. 270(E)',  1976, 'so-only', '1976-04-01', 'S.O. 270(E)',  'department-of-space', 'dos-employees-cca-rules-1976', 'dos-cca-rules-amendments'),
  -- publish_date corrected 2026-09-05: 2025-12-24 (Gazette No. 5780 issue date), not the 15 Dec signing date
  ('dos-so-5979-2025', 'DoS', 'S.O. 5979(E)', 2025, 'so-only', '2025-12-24', 'S.O. 5979(E)', 'department-of-space', 'dos-employees-cca-rules-1976', 'dos-cca-rules-amendments'),
  ('dos-so-424-2018',  'DoS', 'S.O. 424(E)',  2018, 'so-only', '2018-01-30', 'S.O. 424(E)',  'department-of-space', 'dos-employees-cca-rules-1976', 'dos-cca-rules-amendments'),
  ('dos-so-4235-2019', 'DoS', 'S.O. 4235(E)', 2019, 'so-only', '2019-11-22', 'S.O. 4235(E)', 'department-of-space', 'dos-employees-cca-rules-1976', 'dos-cca-rules-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('dos-so-5979-2025', 'dos-so-270-1976', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dos-so-424-2018',  'dos-so-270-1976', 'amends', 'primary-source-egazette', '2026-09-05'),
  ('dos-so-4235-2019', 'dos-so-270-1976', 'amends', 'primary-source-egazette', '2026-09-05');
