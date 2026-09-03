-- Verified CBIC seed data: the 31 notifications superseded by No. 45/2025-Customs
-- (transcribed from that notification's own preamble), 45/2025-Customs itself,
-- and its first amendment, No. 02/2026-Customs. No other ministry/notification
-- data is seeded here — see README "What's real vs. scaffolded".

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
  ('cus-45-2025',  'Customs', '45/2025',  2025, '4-digit-year', '2025-10-24', NULL,              'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions'),
  -- its first amendment (G.S.R. not independently confirmed — left NULL, not guessed)
  ('cus-2-2026',   'Customs', '2/2026',   2026, '4-digit-year', '2026-02-01', NULL,              'finance-revenue-cbic', 'customs-act-1962-s25-1', 'customs-duty-exemptions');

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
VALUES ('cus-2-2026', 'cus-45-2025', 'amends', 'secondary-source-corroborated-3x', '2026-09-03');
