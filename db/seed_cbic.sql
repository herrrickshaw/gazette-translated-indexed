-- Verified CBIC seed data: the 31 notifications superseded by No. 45/2025-Customs
-- (transcribed from that notification's own preamble), 45/2025-Customs itself,
-- and its first amendment, No. 02/2026-Customs.
--
-- Depth pass (2026-09-05): both previously-NULL G.S.R. numbers confirmed from
-- primary egazette PDFs (45/2025-Customs = G.S.R. 781(E); 02/2026-Customs =
-- G.S.R. 83(E)) -- see below. 02/2026 was NOT the first amendment of
-- 45/2025 as originally modeled: a 31 Oct 2025 corrigendum (G.S.R. 807(E))
-- and No. 48/2025-Customs (G.S.R. 847(E), 14 Nov 2025) both preceded it.
-- The full amendment/corrigendum history of 45/2025 through 8 Jul 2026 is
-- now modeled (thread customs-45-2025-amendment-history), plus three
-- further real chains found in the same pass: the last amendments to
-- No. 50/2017-Customs before its 2025 supersession, two anti-dumping-duty
-- sunset-clause extension chains, and No. 44/2025-Customs (45/2025's
-- companion exemption notification, sharing its preamble list) with its
-- own corrigendum.
--
-- Deferred, not modeled this pass (real but title-only or not independently
-- read): the 2026 Baggage Rules supersession cluster (Baggage Rules 2016,
-- Passenger's Baggage Regulations 1966, Baggage Transit Regulations 1967,
-- Customs Baggage Declaration Regulations 2013 -- all cited by title only,
-- no No./G.S.R.); the Courier Import/Export Regulations 1998/2010
-- principals (same reason); several CVD amendments known only from the
-- CBIC index, not read in primary text.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('finance-revenue-cbic', 'Ministry of Finance', 'Department of Revenue (CBIC)');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('customs-act-1962-s25-1', 'Customs Act, 1962 — section 25(1) duty exemptions', 1962);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('customs-duty-exemptions', 'Customs duty exemption notifications under section 25(1)', 'active');

-- gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id
INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('cus-3-1957',   'Customs', '3',        1957, 'bare',         '1957-01-08', 'G.S.R. 98(E)',   'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-80-1970',  'Customs', '80',       1970, 'bare',         '1970-08-29', 'G.S.R. 1246(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-207-89',   'Customs', '207/89',   1989, '2-digit-year', '1989-07-17', 'G.S.R. 702(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-326-1993', 'Customs', '326',      1993, 'bare',         '1993-12-23', 'G.S.R. 912(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-104-1994', 'Customs', '104/1994', 1994, '4-digit-year', '1994-03-16', 'G.S.R. 319(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-146-1994', 'Customs', '146/1994', 1994, '4-digit-year', '1994-07-13', 'G.S.R. 575(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-147-1994', 'Customs', '147/1994', 1994, '4-digit-year', '1994-07-13', 'G.S.R. 576(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-148-1994', 'Customs', '148/1994', 1994, '4-digit-year', '1994-07-13', 'G.S.R. 577(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-152-1994', 'Customs', '152/1994', 1994, '4-digit-year', '1994-07-13', 'G.S.R. 581(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-154-1994', 'Customs', '154/1994', 1994, '4-digit-year', '1994-07-13', 'G.S.R. 583(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-39-1996',  'Customs', '39/1996',  1996, '4-digit-year', '1996-07-23', 'G.S.R. 291(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-50-1996',  'Customs', '50/1996',  1996, '4-digit-year', '1996-07-23', 'G.S.R. 302(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-51-1996',  'Customs', '51/1996',  1996, '4-digit-year', '1996-07-23', 'G.S.R. 303(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-25-1998',  'Customs', '25/1998',  1998, '4-digit-year', '1998-06-02', 'G.S.R. 290(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-121-2003', 'Customs', '121/2003', 2003, '4-digit-year', '2003-08-01', 'G.S.R. 623(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-81-2005',  'Customs', '81/2005',  2005, '4-digit-year', '2005-09-08', 'G.S.R. 569(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-130-2010', 'Customs', '130/2010', 2010, '4-digit-year', '2010-12-23', 'G.S.R. 1008(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-5-2017',   'Customs', '5/2017',   2017, '4-digit-year', '2017-02-02', 'G.S.R. 89(E)',   'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-16-2017',  'Customs', '16/2017',  2017, '4-digit-year', '2017-04-20', 'G.S.R. 394(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-29-2017',  'Customs', '29/2017',  2017, '4-digit-year', '2017-06-30', 'G.S.R. 764(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-30-2017',  'Customs', '30/2017',  2017, '4-digit-year', '2017-06-30', 'G.S.R. 765(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-32-2017',  'Customs', '32/2017',  2017, '4-digit-year', '2017-06-30', 'G.S.R. 767(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-36-2017',  'Customs', '36/2017',  2017, '4-digit-year', '2017-06-30', 'G.S.R. 771(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-37-2017',  'Customs', '37/2017',  2017, '4-digit-year', '2017-06-30', 'G.S.R. 772(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-41-2017',  'Customs', '41/2017',  2017, '4-digit-year', '2017-06-30', 'G.S.R. 776(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-50-2017',  'Customs', '50/2017',  2017, '4-digit-year', '2017-06-30', 'G.S.R. 785(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-86-2017',  'Customs', '86/2017',  2017, '4-digit-year', '2017-11-14', 'G.S.R. 1404(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-19-2019',  'Customs', '19/2019',  2019, '4-digit-year', '2019-07-06', 'G.S.R. 476(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-32-2019',  'Customs', '32/2019',  2019, '4-digit-year', '2019-09-30', 'G.S.R. 726(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-57-2022',  'Customs', '57/2022',  2022, '4-digit-year', '2022-11-17', 'G.S.R. 822(E)',  'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  ('cus-1-2025',   'Customs', '1/2025',   2025, '4-digit-year', '2025-01-16', 'G.S.R. 63(E)',   'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  -- the consolidating instrument itself
  ('cus-45-2025',  'Customs', '45/2025',  2025, '4-digit-year', '2025-10-24', 'G.S.R. 781(E)',   'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  -- G.S.R. confirmed 2026-09-05 from egazette.gov.in/WriteReadData/2026/269755.pdf
  ('cus-2-2026',   'Customs', '2/2026',   2026, '4-digit-year', '2026-02-01', 'G.S.R. 83(E)',    'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions');

-- Cross-references: source = the notification performing the action, target = the one acted on.
INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at)
SELECT 'cus-45-2025', gazette_id, 'supersedes', 'primary-source-preamble', '2026-09-03'
FROM gazette_notification
WHERE gazette_id IN (
  'cus-3-1957','cus-80-1970','cus-207-89','cus-326-1993','cus-104-1994','cus-146-1994',
  'cus-147-1994','cus-148-1994','cus-152-1994','cus-154-1994','cus-39-1996','cus-50-1996',
  'cus-51-1996','cus-25-1998','cus-121-2003','cus-81-2005','cus-130-2010','cus-5-2017',
  'cus-16-2017','cus-29-2017','cus-30-2017','cus-32-2017','cus-36-2017','cus-37-2017',
  'cus-41-2017','cus-50-2017','cus-86-2017','cus-19-2019','cus-32-2019','cus-57-2022','cus-1-2025'
);

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at)
VALUES ('cus-2-2026', 'cus-45-2025', 'amends', 'primary-source-egazette', '2026-09-05');

-- New threads found in the 2026-09-05 depth pass:
INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('customs-45-2025-amendment-history', 'No. 45/2025-Customs and its full amendment/corrigendum history', 'active'),
  ('customs-50-2017-amendments', 'No. 50/2017-Customs amendments before its 2025 supersession', 'superseded'),
  ('customs-add-sunset-extensions', 'Anti-dumping duty sunset-clause extensions (66/2021 and 60/2021-ADD chains)', 'active'),
  ('customs-44-2025-companion', 'No. 44/2025-Customs (companion exemption notification to 45/2025) and its corrigendum', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('cus-corr-45-2025-a', 'Customs', 'Corrigendum', 2025, 'bare', '2025-10-31', 'G.S.R. 807(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-48-2025', 'Customs', '48/2025', 2025, '4-digit-year', '2025-11-14', 'G.S.R. 847(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-6-2026', 'Customs', '06/2026', 2026, '4-digit-year', '2026-03-12', 'G.S.R. 181(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-14-2026', 'Customs', '14/2026', 2026, '4-digit-year', '2026-04-30', 'G.S.R. 330(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-15-2026', 'Customs', '15/2026', 2026, '4-digit-year', '2026-05-12', 'G.S.R. 358(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-corr-14-2026', 'Customs', 'Corrigendum', 2026, 'bare', '2026-05-19', 'G.S.R. 375(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-corr-45-2025-b', 'Customs', 'Corrigendum', 2026, 'bare', '2026-06-12', 'G.S.R. 476(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-25-2026', 'Customs', '25/2026', 2026, '4-digit-year', '2026-07-08', 'G.S.R. 600(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-45-2025-amendment-history'),
  ('cus-31-2025', 'Customs', '31/2025', 2025, '4-digit-year', '2025-05-30', 'G.S.R. 355(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-50-2017-amendments'),
  ('cus-39-2025', 'Customs', '39/2025', 2025, '4-digit-year', '2025-09-17', 'G.S.R. 643(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-50-2017-amendments'),
  ('cus-40-2025', 'Customs', '40/2025', 2025, '4-digit-year', '2025-09-25', 'G.S.R. 717(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-50-2017-amendments'),
  ('cus-66-2021-add', 'Customs', '66/2021 (ADD)', 2021, '4-digit-year', '2021-11-11', 'S.O. 790(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-add-sunset-extensions'),
  ('cus-30-2025-add', 'Customs', '30/2025 (ADD)', 2025, '4-digit-year', '2025-10-27', 'G.S.R. 793(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-add-sunset-extensions'),
  ('cus-19-2026-add', 'Customs', '19/2026 (ADD)', 2026, '4-digit-year', '2026-07-31', 'G.S.R. 693(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-add-sunset-extensions'),
  ('cus-60-2021-add', 'Customs', '60/2021 (ADD)', 2021, '4-digit-year', '2021-10-14', 'G.S.R. 739(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-add-sunset-extensions'),
  ('cus-6-2026-add', 'Customs', '06/2026 (ADD)', 2026, '4-digit-year', '2026-04-30', 'G.S.R. 331(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-add-sunset-extensions'),
  ('cus-17-2026-add', 'Customs', '17/2026 (ADD)', 2026, '4-digit-year', '2026-07-10', 'G.S.R. 612(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-add-sunset-extensions'),
  ('cus-11-2018', 'Customs', '11/2018', 2018, '4-digit-year', '2018-02-02', 'G.S.R. 114(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-44-2025-companion'),
  ('cus-8-2020', 'Customs', '8/2020', 2020, '4-digit-year', '2020-02-02', 'G.S.R. 68(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-44-2025-companion'),
  ('cus-11-2021', 'Customs', '11/2021', 2021, '4-digit-year', '2021-02-01', 'G.S.R. 69(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-44-2025-companion'),
  ('cus-44-2025', 'Customs', '44/2025', 2025, '4-digit-year', '2025-10-24', 'G.S.R. 782(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-44-2025-companion'),
  ('cus-corr-44-2025', 'Customs', 'Corrigendum', 2025, 'bare', '2025-10-31', 'G.S.R. 808(E)', 'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-44-2025-companion');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('cus-corr-45-2025-a', 'cus-45-2025', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('cus-48-2025', 'cus-45-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-6-2026', 'cus-45-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-corr-14-2026', 'cus-14-2026', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('cus-14-2026', 'cus-45-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-15-2026', 'cus-45-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-corr-45-2025-b', 'cus-45-2025', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('cus-25-2026', 'cus-45-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-31-2025', 'cus-50-2017', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-39-2025', 'cus-50-2017', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-39-2025', 'cus-31-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('cus-40-2025', 'cus-50-2017', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-40-2025', 'cus-39-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('cus-30-2025-add', 'cus-66-2021-add', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-19-2026-add', 'cus-66-2021-add', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-19-2026-add', 'cus-30-2025-add', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('cus-6-2026-add', 'cus-60-2021-add', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-17-2026-add', 'cus-60-2021-add', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-17-2026-add', 'cus-6-2026-add', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('cus-44-2025', 'cus-11-2018', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-44-2025', 'cus-8-2020', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-44-2025', 'cus-11-2021', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('cus-44-2025', 'cus-45-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('cus-corr-44-2025', 'cus-44-2025', 'corrigendum', 'research-agent-quoted', '2026-09-05');

