-- Ministry of Social Justice and Empowerment (Department of Social Justice
-- and Empowerment; Department of Empowerment of Persons with Disabilities
-- (Divyangjan) — both under one tracker slug). Deepened 2026-09-04 (depth
-- pass — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3
-- note-chains). All 87 tracked notifications read (Full Text; six official
-- egazette PDFs where the tracker text was garbled or truncated, Hindi
-- column checked too). Nothing follows S.O. 3793(E) in the Manual
-- Scavengers chain; the National Fund chain's S.O. 3383(E) is the latest.
--
-- Headline: the Rights of Persons with Disabilities Rules, 2017 (G.S.R.
-- 591(E)) accessibility-standards amendment series — a 15-node amends
-- chain reconstructed from each notification's own "last amended vide"
-- Note, with eleven number-confirmed draft->final `cites` pairs. The
-- existing RCI General Council chain gained S.O. 2240(E) [2021] and S.O.
-- 333(E) [2024] (its 2002-2025 gap is only partly closed — no Note
-- enumerates the full history), and S.O. 1436(E) turns out to be a
-- PARTIAL SUPERSESSION of S.O. 333(E) (one member removed) as well as an
-- amendment — both edges kept.
--
-- REAL PRIMARY-TEXT ANOMALIES kept as printed, not repaired:
--   - G.S.R. 849(E) (final rural-sector standards) cites its draft as
--     "G.S.R. 407(E) dated 21st June 2023" in both language columns of
--     the official PDF; 407(E) is the health-care draft dated 1 June per
--     G.S.R. 598(E), and the rural draft was actually G.S.R. 529(E).
--     Modeled as printed (849 cites 407), flagged.
--   - G.S.R. 358(E) cites its draft as "G.S.R. 89 I" in English; the
--     Hindi column reads "सा.का.नि 89 (अ.)" = 89(E). Modeled 358 cites
--     89(E) on the Hindi column's authority ('title-date' tier).
--   - G.S.R. 343(E) cites its draft with no number in either column —
--     deferred (by subject it is G.S.R. 90(E), not asserted).
--   - National Trust Board: S.O. 5380(E)'s date is "9th November, 2022"
--     in S.O. 5709(E) and "17th November, 2022" in S.O. 5476(E), each
--     consistent across both language columns of its own PDF — the 2022
--     document itself is unreachable; 2022-11-09 (the most recently read
--     source) is used and the conflict recorded. S.O. 5709(E)'s preamble
--     amends the 2019 principal directly and its Note omits S.O. 5476(E)
--     — modeled as written.
--   - Draft Notes are sometimes stale (G.S.R. 455(E) and 913(E) name a
--     superseded "last amended"); drafts carry no amends edge here.
--   - Citation dates drift to gazette dates (219(E) cited as 19 Mar, own
--     18 Mar; 4285(E) cited as 23 Sep, own 8 Sep).
--
-- Bare-form (file-number) material modeled where the citing text gives
-- number and date: the National Commission for Safai Karamcharis
-- Resolution of 12 Feb 2025 (cites three older numbered Resolutions and
-- is in turn cited by the 2026 appointment); a Hindi Salahakar Samiti
-- supersession in which source and target share the identical file
-- number (date-qualified ids); a Transgender Advisory Committee "even
-- number" cite.
--
-- Real leads NOT modeled: the NCSK Resolution "dated 03.02.2022" cited by
-- date only; a Transgender Advisory Committee reference to a notification
-- "dated 27.03.2026" that matches no document's own or gazette date; ten
-- companion Aadhaar notifications with no supersession clause; National
-- Trust Rules/Regulations amended by title only (S.O. 5447(E)); RPwD Act
-- Schedule amendment and Transgender Amendment Act commencement (statute
-- targets); several scheme Aadhaar notifications citing only a DBT
-- Mission Office Memorandum.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('social-justice-and-empowerment', 'Ministry of Social Justice and Empowerment', 'Department of Social Justice and Empowerment; Department of Empowerment of Persons with Disabilities');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('rpwd-rules-2017', 'Rights of Persons with Disabilities Rules, 2017 (rule 41, National Fund Governing Body)', 2017),
  ('manual-scavengers-act-2013', 'Prohibition of Employment as Manual Scavengers and their Rehabilitation Act, 2013 (s.29, Central Monitoring Committee)', 2013),
  ('rehabilitation-council-act-1992', 'Rehabilitation Council of India Act, 1992 (s.3, General Council)', 1992),
  ('rpwd-rules-2017-accessibility-standards', 'Rights of Persons with Disabilities Rules, 2017 — rule 15 accessibility standards and other amendments (G.S.R. 591(E))', 2017),
  ('rpwd-act-2016-s60-central-advisory-board', 'Rights of Persons with Disabilities Act, 2016 s.60 — Central Advisory Board on Disability', 2016),
  ('commission-of-inquiry-sc-converts', 'Commissions of Inquiry Act, 1952 s.3 — Commission on SC status of converts', 2022),
  ('national-trust-act-1999-board', 'National Trust Act, 1999 s.3(4) — Board', 1999),
  ('aadhaar-s7-depwd-schemes-2017', 'Aadhaar Act, 2016 s.7 — DEPwD scheme notifications (ADIP, DDRC, DDRS, scholarships)', 2017),
  ('ncsk-resolutions', 'National Commission for Safai Karamcharis — constitution/tenure Resolutions', 2004),
  ('sje-hindi-salahakar-samiti', 'MoSJE Hindi Salahakar Samiti Resolution', 2022),
  ('transgender-advisory-committee-2025', 'Transgender Persons Advisory Committee (Jane Kaushik) notifications', 2025);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('national-fund-disabilities-governing-body', 'National Fund for Persons with Disabilities Governing Body membership', 'active'),
  ('manual-scavengers-monitoring-committee', 'Manual Scavengers Act Central Monitoring Committee membership', 'active'),
  ('rehabilitation-council-general-council', 'Rehabilitation Council of India General Council membership (6 nodes, one partial supersession)', 'active'),
  ('rpwd-rules-accessibility-amendments', 'RPwD Rules, 2017 accessibility-standards amendment series with draft->final cites', 'active'),
  ('central-advisory-board-disability', 'Central Advisory Board on Disability composition', 'active'),
  ('commission-of-inquiry-tenure-recitals', 'Commission of Inquiry tenure extensions citing all predecessors', 'active'),
  ('national-trust-board-amendments', 'National Trust Board composition amendments (date conflict recorded)', 'active'),
  ('depwd-aadhaar-supersessions', 'Four 2024 Aadhaar s.7 notifications superseding 2017 predecessors', 'superseded'),
  ('ncsk-resolution-cites', 'NCSK Resolutions cited by number and date', 'active'),
  ('sje-hindi-samiti-supersession', 'Hindi Salahakar Samiti reconstitution (same file number, date-qualified)', 'active'),
  ('transgender-advisory-committee-cites', 'Transgender Advisory Committee even-number cite', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1 (unchanged)
  ('sje-so-3322-2017', 'Social Justice', 'S.O. 3322(E)', 2017, 'so-only', '2017-10-13', 'S.O. 3322(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017', 'national-fund-disabilities-governing-body'),
  ('sje-so-4877-2022', 'Social Justice', 'S.O. 4877(E)', 2022, 'so-only', '2022-10-13', 'S.O. 4877(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017', 'national-fund-disabilities-governing-body'),
  ('sje-so-3383-2026', 'Social Justice', 'S.O. 3383(E)', 2026, 'so-only', '2026-06-16', 'S.O. 3383(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017', 'national-fund-disabilities-governing-body'),
  -- Pair 2: twelve-node chain (unchanged)
  ('sje-so-89-2014',    'Social Justice', 'S.O. 89(E)',   2014, 'so-only', '2014-01-13', 'S.O. 89(E)',   'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-605-2014',   'Social Justice', 'S.O. 605(E)',  2014, 'so-only', '2014-02-28', 'S.O. 605(E)',  'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-2008-2014',  'Social Justice', 'S.O. 2008(E)', 2014, 'so-only', '2014-08-07', 'S.O. 2008(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-476-2017',   'Social Justice', 'S.O. 476(E)',  2017, 'so-only', '2017-02-16', 'S.O. 476(E)',  'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-1389-2017',  'Social Justice', 'S.O. 1389(E)', 2017, 'so-only', '2017-05-02', 'S.O. 1389(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-888-2018',   'Social Justice', 'S.O. 888(E)',  2018, 'so-only', '2018-03-01', 'S.O. 888(E)',  'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-3338-2023',  'Social Justice', 'S.O. 3338(E)', 2023, 'so-only', '2023-07-26', 'S.O. 3338(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-4379-2023',  'Social Justice', 'S.O. 4379(E)', 2023, 'so-only', '2023-10-09', 'S.O. 4379(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-1510-2024',  'Social Justice', 'S.O. 1510(E)', 2024, 'so-only', '2024-03-21', 'S.O. 1510(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-93-2025',    'Social Justice', 'S.O. 93(E)',   2025, 'so-only', '2025-01-03', 'S.O. 93(E)',   'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-1352-2025',  'Social Justice', 'S.O. 1352(E)', 2025, 'so-only', '2025-03-21', 'S.O. 1352(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  ('sje-so-3793-2025',  'Social Justice', 'S.O. 3793(E)', 2025, 'so-only', '2025-08-13', 'S.O. 3793(E)', 'social-justice-and-empowerment', 'manual-scavengers-act-2013', 'manual-scavengers-monitoring-committee'),
  -- Pair 3: RCI General Council, now 6 nodes
  ('sje-so-1102-2002', 'Social Justice', 'S.O. 1102(E)', 2002, 'so-only', '2002-10-21', 'S.O. 1102(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  ('sje-so-2240-2021', 'Social Justice', 'S.O. 2240(E)', 2021, 'so-only', '2021-06-10', 'S.O. 2240(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  ('sje-so-333-2024',  'Social Justice', 'S.O. 333(E)',  2024, 'so-only', '2024-01-24', 'S.O. 333(E)',  'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  ('sje-so-1436-2025', 'Social Justice', 'S.O. 1436(E)', 2025, 'so-only', '2025-03-26', 'S.O. 1436(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  ('sje-so-4285-2025', 'Social Justice', 'S.O. 4285(E)', 2025, 'so-only', '2025-09-08', 'S.O. 4285(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  ('sje-so-5517-2025', 'Social Justice', 'S.O. 5517(E)', 2025, 'so-only', '2025-12-01', 'S.O. 5517(E)', 'social-justice-and-empowerment', 'rehabilitation-council-act-1992', 'rehabilitation-council-general-council'),
  -- RPwD Rules, 2017 accessibility-standards series
  ('sje-gsr-591-2017', 'Social Justice', 'G.S.R. 591(E)', 2017, 'so-only', '2017-06-15', 'G.S.R. 591(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-290-2023', 'Social Justice', 'G.S.R. 290(E)', 2023, 'so-only', '2023-04-13', 'G.S.R. 290(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-335-2023', 'Social Justice', 'G.S.R. 335(E)', 2023, 'so-only', '2023-04-28', 'G.S.R. 335(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-357-2023', 'Social Justice', 'G.S.R. 357(E)', 2023, 'so-only', '2023-05-10', 'G.S.R. 357(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-407-2023', 'Social Justice', 'G.S.R. 407(E)', 2023, 'so-only', '2023-06-01', 'G.S.R. 407(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-413-2023', 'Social Justice', 'G.S.R. 413(E)', 2023, 'so-only', '2023-06-05', 'G.S.R. 413(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-504-2023', 'Social Justice', 'G.S.R. 504(E)', 2023, 'so-only', '2023-07-13', 'G.S.R. 504(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-517-2023', 'Social Justice', 'G.S.R. 517(E)', 2023, 'so-only', '2023-07-17', 'G.S.R. 517(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-528-2023', 'Social Justice', 'G.S.R. 528(E)', 2023, 'so-only', '2023-07-21', 'G.S.R. 528(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-598-2023', 'Social Justice', 'G.S.R. 598(E)', 2023, 'so-only', '2023-08-09', 'G.S.R. 598(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-688-2023', 'Social Justice', 'G.S.R. 688(E)', 2023, 'so-only', '2023-09-21', 'G.S.R. 688(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-849-2023', 'Social Justice', 'G.S.R. 849(E)', 2023, 'so-only', '2023-11-16', 'G.S.R. 849(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-892-2023', 'Social Justice', 'G.S.R. 892(E)', 2023, 'so-only', '2023-12-06', 'G.S.R. 892(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-912-2023', 'Social Justice', 'G.S.R. 912(E)', 2023, 'so-only', '2023-12-18', 'G.S.R. 912(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-07-2024',  'Social Justice', 'G.S.R. 07(E)',  2024, 'so-only', '2024-01-02', 'G.S.R. 07(E)',  'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-70-2024',  'Social Justice', 'G.S.R. 70(E)',  2024, 'so-only', '2024-01-25', 'G.S.R. 70(E)',  'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-89-2024',  'Social Justice', 'G.S.R. 89(E)',  2024, 'so-only', '2024-02-01', 'G.S.R. 89(E)',  'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-114-2024', 'Social Justice', 'G.S.R. 114(E)', 2024, 'so-only', '2024-02-15', 'G.S.R. 114(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-175-2024', 'Social Justice', 'G.S.R. 175(E)', 2024, 'so-only', '2024-03-08', 'G.S.R. 175(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-219-2024', 'Social Justice', 'G.S.R. 219(E)', 2024, 'so-only', '2024-03-18', 'G.S.R. 219(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-334-2024', 'Social Justice', 'G.S.R. 334(E)', 2024, 'so-only', '2024-03-22', 'G.S.R. 334(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-343-2024', 'Social Justice', 'G.S.R. 343(E)', 2024, 'so-only', '2024-06-20', 'G.S.R. 343(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-358-2024', 'Social Justice', 'G.S.R. 358(E)', 2024, 'so-only', '2024-06-25', 'G.S.R. 358(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-361-2024', 'Social Justice', 'G.S.R. 361(E)', 2024, 'so-only', '2024-07-02', 'G.S.R. 361(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-455-2024', 'Social Justice', 'G.S.R. 455(E)', 2024, 'so-only', '2024-07-29', 'G.S.R. 455(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  ('sje-gsr-649-2024', 'Social Justice', 'G.S.R. 649(E)', 2024, 'so-only', '2024-10-16', 'G.S.R. 649(E)', 'social-justice-and-empowerment', 'rpwd-rules-2017-accessibility-standards', 'rpwd-rules-accessibility-amendments'),
  -- Central Advisory Board on Disability
  ('sje-so-3550-2017', 'Social Justice', 'S.O. 3550(E)', 2017, 'so-only', '2017-11-08', 'S.O. 3550(E)', 'social-justice-and-empowerment', 'rpwd-act-2016-s60-central-advisory-board', 'central-advisory-board-disability'),
  ('sje-so-2668-2022', 'Social Justice', 'S.O. 2668(E)', 2022, 'so-only', '2022-06-09', 'S.O. 2668(E)', 'social-justice-and-empowerment', 'rpwd-act-2016-s60-central-advisory-board', 'central-advisory-board-disability'),
  ('sje-so-4874-2022', 'Social Justice', 'S.O. 4874(E)', 2022, 'so-only', '2022-10-12', 'S.O. 4874(E)', 'social-justice-and-empowerment', 'rpwd-act-2016-s60-central-advisory-board', 'central-advisory-board-disability'),
  ('sje-so-5095-2025', 'Social Justice', 'S.O. 5095(E)', 2025, 'so-only', '2025-10-06', 'S.O. 5095(E)', 'social-justice-and-empowerment', 'rpwd-act-2016-s60-central-advisory-board', 'central-advisory-board-disability'),
  -- Commission of Inquiry tenure recitals
  ('sje-so-4742-2022', 'Social Justice', 'S.O. 4742(E)', 2022, 'so-only', '2022-10-06', 'S.O. 4742(E)', 'social-justice-and-empowerment', 'commission-of-inquiry-sc-converts', 'commission-of-inquiry-tenure-recitals'),
  ('sje-so-4780-2024', 'Social Justice', 'S.O. 4780(E)', 2024, 'so-only', '2024-10-30', 'S.O. 4780(E)', 'social-justice-and-empowerment', 'commission-of-inquiry-sc-converts', 'commission-of-inquiry-tenure-recitals'),
  ('sje-so-5000-2025', 'Social Justice', 'S.O. 5000(E)', 2025, 'so-only', '2025-11-04', 'S.O. 5000(E)', 'social-justice-and-empowerment', 'commission-of-inquiry-sc-converts', 'commission-of-inquiry-tenure-recitals'),
  ('sje-so-1818-2026', 'Social Justice', 'S.O. 1818(E)', 2026, 'so-only', '2026-04-09', 'S.O. 1818(E)', 'social-justice-and-empowerment', 'commission-of-inquiry-sc-converts', 'commission-of-inquiry-tenure-recitals'),
  -- National Trust Board (S.O. 5380(E) date conflict recorded in header)
  ('sje-so-1700-2019', 'Social Justice', 'S.O. 1700(E)', 2019, 'so-only', '2019-05-03', 'S.O. 1700(E)', 'social-justice-and-empowerment', 'national-trust-act-1999-board', 'national-trust-board-amendments'),
  ('sje-so-5380-2022', 'Social Justice', 'S.O. 5380(E)', 2022, 'so-only', '2022-11-09', 'S.O. 5380(E)', 'social-justice-and-empowerment', 'national-trust-act-1999-board', 'national-trust-board-amendments'),
  ('sje-so-5476-2023', 'Social Justice', 'S.O. 5476(E)', 2023, 'so-only', '2023-12-26', 'S.O. 5476(E)', 'social-justice-and-empowerment', 'national-trust-act-1999-board', 'national-trust-board-amendments'),
  ('sje-so-5709-2025', 'Social Justice', 'S.O. 5709(E)', 2025, 'so-only', '2025-12-05', 'S.O. 5709(E)', 'social-justice-and-empowerment', 'national-trust-act-1999-board', 'national-trust-board-amendments'),
  -- DEPwD Aadhaar s.7 supersessions
  ('sje-so-711-2017',  'Social Justice', 'S.O. 711(E)',  2017, 'so-only', '2017-03-03', 'S.O. 711(E)',  'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  ('sje-so-1259-2024', 'Social Justice', 'S.O. 1259(E)', 2024, 'so-only', '2024-02-29', 'S.O. 1259(E)', 'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  ('sje-so-1342-2017', 'Social Justice', 'S.O. 1342(E)', 2017, 'so-only', '2017-04-27', 'S.O. 1342(E)', 'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  ('sje-so-1261-2024', 'Social Justice', 'S.O. 1261(E)', 2024, 'so-only', '2024-02-29', 'S.O. 1261(E)', 'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  ('sje-so-1135-2017', 'Social Justice', 'S.O. 1135(E)', 2017, 'so-only', '2017-03-31', 'S.O. 1135(E)', 'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  ('sje-so-1263-2024', 'Social Justice', 'S.O. 1263(E)', 2024, 'so-only', '2024-02-29', 'S.O. 1263(E)', 'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  ('sje-so-728-2017',  'Social Justice', 'S.O. 728(E)',  2017, 'so-only', '2017-03-03', 'S.O. 728(E)',  'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  ('sje-so-1271-2024', 'Social Justice', 'S.O. 1271(E)', 2024, 'so-only', '2024-02-29', 'S.O. 1271(E)', 'social-justice-and-empowerment', 'aadhaar-s7-depwd-schemes-2017', 'depwd-aadhaar-supersessions'),
  -- NCSK Resolutions (bare)
  ('sje-res-17015-18-2003-2004', 'Social Justice', 'Resolution No. 17015/18/2003-SCD-VI', 2004, 'bare', '2004-09-09', 'Resolution No. 17015/18/2003-SCD-VI', 'social-justice-and-empowerment', 'ncsk-resolutions', 'ncsk-resolution-cites'),
  ('sje-res-17015-17-2008-2009', 'Social Justice', 'Resolution No. 17015/17/2008-RIC', 2009, 'bare', '2009-03-02', 'Resolution No. 17015/17/2008-RIC', 'social-justice-and-empowerment', 'ncsk-resolutions', 'ncsk-resolution-cites'),
  ('sje-res-17015-1-2017-2018', 'Social Justice', 'Resolution No. 17015/1/2017-RI Cell', 2018, 'bare', '2018-07-13', 'Resolution No. 17015/1/2017-RI Cell', 'social-justice-and-empowerment', 'ncsk-resolutions', 'ncsk-resolution-cites'),
  ('sje-res-n16-5-2021-2025', 'Social Justice', 'Resolution No. N-16/5/2021-PLAN', 2025, 'bare', '2025-02-12', 'Resolution No. N-16/5/2021-PLAN', 'social-justice-and-empowerment', 'ncsk-resolutions', 'ncsk-resolution-cites'),
  ('sje-file-w1-2026', 'Social Justice', 'F. No. W/1/2026-SCD-VI', 2026, 'bare', '2026-02-24', 'F. No. W/1/2026-SCD-VI', 'social-justice-and-empowerment', 'ncsk-resolutions', 'ncsk-resolution-cites'),
  -- Hindi Salahakar Samiti (same file number reused; date-qualified ids)
  ('sje-res-e11015-2022', 'Social Justice', 'Resolution No. E.11015/1/2018-Hindi', 2022, 'bare', '2022-06-08', 'Resolution No. E.11015/1/2018-Hindi', 'social-justice-and-empowerment', 'sje-hindi-salahakar-samiti', 'sje-hindi-samiti-supersession'),
  ('sje-res-e11015-2025', 'Social Justice', 'Resolution No. E.11015/1/2018-Hindi', 2025, 'bare', '2025-08-22', 'Resolution No. E.11015/1/2018-Hindi', 'social-justice-and-empowerment', 'sje-hindi-salahakar-samiti', 'sje-hindi-samiti-supersession'),
  -- Transgender Advisory Committee (even-number cite)
  ('sje-file-dp16-2025', 'Social Justice', 'F. No. DP-16/1/2024-DP', 2025, 'bare', '2025-12-23', 'F. No. DP-16/1/2024-DP', 'social-justice-and-empowerment', 'transgender-advisory-committee-2025', 'transgender-advisory-committee-cites'),
  ('sje-file-dp16-2026', 'Social Justice', 'F. No. DP-16/1/2024-DP', 2026, 'bare', '2026-06-08', 'F. No. DP-16/1/2024-DP', 'social-justice-and-empowerment', 'transgender-advisory-committee-2025', 'transgender-advisory-committee-cites');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('sje-so-4877-2022', 'sje-so-3322-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-3383-2026', 'sje-so-4877-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-605-2014',  'sje-so-89-2014',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-2008-2014', 'sje-so-605-2014',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-476-2017',  'sje-so-2008-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1389-2017', 'sje-so-476-2017',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-888-2018',  'sje-so-1389-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-3338-2023', 'sje-so-888-2018',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-4379-2023', 'sje-so-3338-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1510-2024', 'sje-so-4379-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-93-2025',   'sje-so-1510-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1352-2025', 'sje-so-93-2025',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-3793-2025', 'sje-so-1352-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- RCI General Council (extended; 1436 is also a partial supersession of 333)
  ('sje-so-2240-2021', 'sje-so-1102-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-333-2024',  'sje-so-2240-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1436-2025', 'sje-so-1102-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1436-2025', 'sje-so-333-2024',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-4285-2025', 'sje-so-1436-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-5517-2025', 'sje-so-4285-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- RPwD Rules accessibility series: amends chain per each Note's "last amended vide"
  ('sje-gsr-413-2023', 'sje-gsr-591-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-504-2023', 'sje-gsr-413-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-517-2023', 'sje-gsr-504-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-528-2023', 'sje-gsr-517-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-598-2023', 'sje-gsr-528-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-849-2023', 'sje-gsr-598-2023', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('sje-gsr-07-2024',  'sje-gsr-849-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-114-2024', 'sje-gsr-07-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-175-2024', 'sje-gsr-114-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-334-2024', 'sje-gsr-175-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-343-2024', 'sje-gsr-334-2024', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('sje-gsr-358-2024', 'sje-gsr-343-2024', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('sje-gsr-361-2024', 'sje-gsr-358-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-649-2024', 'sje-gsr-361-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- draft -> final cites (number-confirmed unless noted)
  ('sje-gsr-504-2023', 'sje-gsr-357-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-517-2023', 'sje-gsr-335-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-528-2023', 'sje-gsr-290-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-598-2023', 'sje-gsr-407-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-849-2023', 'sje-gsr-407-2023', 'cites', 'primary-source-egazette', '2026-09-04'),
  ('sje-gsr-07-2024',  'sje-gsr-688-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-114-2024', 'sje-gsr-892-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-175-2024', 'sje-gsr-912-2023', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-334-2024', 'sje-gsr-70-2024',  'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-358-2024', 'sje-gsr-89-2024',  'cites', 'primary-source-egazette-hindi-column', '2026-09-04'),
  ('sje-gsr-361-2024', 'sje-gsr-219-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-gsr-649-2024', 'sje-gsr-455-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Central Advisory Board on Disability
  ('sje-so-2668-2022', 'sje-so-3550-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-4874-2022', 'sje-so-2668-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-5095-2025', 'sje-so-4874-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Commission of Inquiry
  ('sje-so-4780-2024', 'sje-so-4742-2022', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-5000-2025', 'sje-so-4742-2022', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-5000-2025', 'sje-so-4780-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1818-2026', 'sje-so-4742-2022', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1818-2026', 'sje-so-4780-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1818-2026', 'sje-so-5000-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- National Trust Board
  ('sje-so-5380-2022', 'sje-so-1700-2019', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('sje-so-5476-2023', 'sje-so-5380-2022', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('sje-so-5709-2025', 'sje-so-1700-2019', 'amends', 'primary-source-egazette', '2026-09-04'),
  -- DEPwD Aadhaar supersessions
  ('sje-so-1259-2024', 'sje-so-711-2017',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1261-2024', 'sje-so-1342-2017', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1263-2024', 'sje-so-1135-2017', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('sje-so-1271-2024', 'sje-so-728-2017',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- NCSK Resolutions
  ('sje-res-n16-5-2021-2025', 'sje-res-17015-18-2003-2004', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-res-n16-5-2021-2025', 'sje-res-17015-17-2008-2009', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-res-n16-5-2021-2025', 'sje-res-17015-1-2017-2018', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('sje-file-w1-2026', 'sje-res-n16-5-2021-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Hindi Salahakar Samiti
  ('sje-res-e11015-2025', 'sje-res-e11015-2022', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- Transgender Advisory Committee
  ('sje-file-dp16-2026', 'sje-file-dp16-2025', 'cites', 'research-agent-quoted', '2026-09-04');
