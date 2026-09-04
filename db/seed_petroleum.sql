-- Ministry of Petroleum and Natural Gas. Deepened 2026-09-04 (depth pass
-- — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (2
-- chains). Everything below read from gazettetracker.com Full Text, with
-- the key items cross-checked against the official egazette.gov.in PDFs.
--
-- CORRECTIONS to the first pass:
--   - The draft G.S.R. 781(E) is dated 3 SEPTEMBER 2026, not 3 August: the
--     official PDF (WriteReadData/2026/275979.pdf) reads "New Delhi, the
--     3rd September, 2026". The aggregator carries two pages for the same
--     file-id, one transcribing "3rd August" — a transcription error.
--     Still a draft (not finalized as of 2026-09-04), still `cites`.
--   - The Petroleum Rules, 2002 chain was missing an intermediate: the
--     draft's and final's own Notes both say "last amended vide G.S.R.
--     196(E), dated the 17th March, 2021" — inserted, and G.S.R. 154(E)
--     re-parented onto it. G.S.R. 154(E) also has its own draft precursor
--     (G.S.R. 814(E), 2023-10-31), modeled `cites`.
--   - The 26-year gap in the Petroleum Products Order chain is what the
--     primary text says: G.S.R. 730(E)'s own Note enumerates only G.S.R.
--     870(E) between the 1999 principal and itself. Left as is.
--
-- 11 further new subject threads: two 12-node Essential Commodities Act
-- Order note-chains (LPG Order 2000; Motor Spirit & HSD Order 2005), the
-- MS&HSD Order's companion ethanol-blending supersession, Lubricating
-- Oils Order 1987, two brand-new 2026 Orders and their amendments, the
-- Oilfields Act Schedule 9-notification chain (no principal notification
-- — the principal is an Act, inserted by Act 39 of 1969), a Petroleum
-- Act s.12 validity extension (modeled `cites`; "extends the validity of"
-- is a real shape with no dedicated relation_type yet), OIDB PF Rules,
-- three bare-file-number Resolution citations (closing the deferred
-- OMC-PNG Resolution lead), and five Petroleum and Minerals Pipelines
-- (ARUL) Act reference pairs — one corrigendum, four s.3(1)->s.6(1)
-- declaration citations (~700 of this ministry's 1,081 tracked items are
-- ARUL pipeline notices; the aggregator titles several "Erratum" whose
-- Full Text is a declaration — titles lie, Full Text used).
--
-- REAL CITATION COLLISIONS, all kept as distinct rows:
--   - G.S.R. 730(E): 2007-11-22 (LPG Order amendment) vs 2026-08-13
--     (Petroleum Products Order amendment, already seeded).
--   - G.S.R. 781(E): 2013-12-16 (LPG Order amendment) vs 2026-09-03
--     (draft Petroleum Rules, already seeded).
--   - 814(E): G.S.R. 814(E) 2004-12-16 (Oilfields Schedule), G.S.R. 814(E)
--     2023-10-31 (draft Petroleum Rules), AND S.O. 814(E) 2023-02-16 (ARUL
--     s.3(1)) — same number, two of them in the same year across series.
--
-- DEFERRED pending a taxonomy decision (real, fully transcribed in the
-- research log, NOT modeled here): Petroleum and Natural Gas Regulatory
-- Board regulations (Natural Gas Pipeline Tariff 2008 — a 19-item
-- footnote chain; T4S CGD 2008; ERDMP 2010; Affiliate Code 2008; T4S PI
-- 2020; T4S Refineries 2023; one bare corrigendum). Their issuer in the
-- text is the Board itself (Part III s.4), which gazettetracker indexes as
-- a separate entity — modeling them under this ministry_id would
-- mis-attribute the issuer, and this project has no regulator-issuer row.
--
-- Other real leads NOT modeled: G.S.R. 888(E) (Petroleum and Natural Gas
-- Rules, 2025) supersedes the 1949 and 1959 Rules by title only; S.O.
-- 1411(E) and G.S.R. 474(E) cite the 1999/2005 Orders by title only; a
-- cross-ministry cite from S.O. 3544(E) to a Cabinet Secretariat
-- Allocation of Business notification (no such ministry row, deferred as
-- for MoHUA); five commencement notifications citing Acts, not
-- notifications; a PESO circular cited by S.O. 1630(E).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('petroleum-and-natural-gas', 'Ministry of Petroleum and Natural Gas', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('petroleum-products-maintenance-order-1999', 'Petroleum Products (Maintenance of Production, Storage and Supply) Order, 1999', 1999),
  ('petroleum-rules-2002', 'Petroleum Rules, 2002', 2002),
  ('lpg-supply-distribution-order-2000', 'Liquefied Petroleum Gas (Regulation of Supply and Distribution) Order, 2000', 2000),
  ('ms-hsd-order-2005', 'Motor Spirit and High Speed Diesel (Regulation of Supply, Distribution and Prevention of Malpractices) Order, 2005', 2005),
  ('ms-hsd-order-2005-ethanol-directive', 'MS&HSD Order, 2005 para 6 — ethanol-blending directive', 2005),
  ('lubricating-oils-greases-order-1987', 'Lubricating Oils and Greases (Processing, Supply and Distribution Regulation) Order, 1987', 1987),
  ('natural-gas-supply-regulation-order-2026', 'Natural Gas (Supply Regulation) Order, 2026', 2026),
  ('pipelines-distribution-order-2026', 'Natural Gas and Petroleum Products Distribution (Through Laying, Building, Operation and Expansion of Pipelines and Other Facilities) Order, 2026', 2026),
  ('oilfields-act-1948-schedule', 'Oilfields (Regulation and Development) Act, 1948 — Schedule (s.6A(4) amendments)', 1948),
  ('petroleum-act-1934-s12-kerosene-exemption', 'Petroleum Act, 1934 s.12 — PDS kerosene storage exemption', 1934),
  ('oidb-staff-pf-rules-2013', 'Oil Industry Development Board Staff Provident Fund Rules, 2013', 2013),
  ('transportation-fuel-marketing-authorisation-resolution', 'Resolution on authorisation to market transportation fuels (OMC-PNG)', 2002),
  ('pm-ji-van-yojana-2019', 'Pradhan Mantri JI-VAN Yojana, 2019', 2019),
  ('ms-hsd-temporary-regulation-order-2026', 'MS/HSD (Temporary Regulation of Supply through Retail Outlets) Order, 2026', 2026),
  ('arul-act-1962-pipelines', 'Petroleum and Minerals Pipelines (Acquisition of Right of User in Land) Act, 1962 — s.3(1)/s.6(1) notices', 1962);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('petroleum-products-maintenance-order-amendments', 'Petroleum Products Maintenance Order and its amendments', 'active'),
  ('petroleum-rules-2002-amendments', 'Petroleum Rules, 2002 and its amendments (draft precursors, one pending draft)', 'active'),
  ('lpg-order-2000-amendments', 'LPG Order, 2000 — 12-node note-chain', 'active'),
  ('ms-hsd-order-2005-amendments', 'MS&HSD Order, 2005 — 12-node note-chain', 'active'),
  ('ethanol-blending-directive-supersession', 'Ethanol-blending directive supersession', 'superseded'),
  ('lubricating-oils-order-amendments', 'Lubricating Oils and Greases Order and its amendments', 'active'),
  ('natural-gas-supply-order-2026-amendment', 'Natural Gas (Supply Regulation) Order, 2026 amendment', 'active'),
  ('pipelines-distribution-order-2026-amendments', 'Pipelines Distribution Order, 2026 and its amendments', 'active'),
  ('oilfields-schedule-amendments', 'Oilfields Act Schedule amendment chain (2004-2026)', 'active'),
  ('kerosene-exemption-validity-extension', 'PDS kerosene storage exemption validity extension', 'active'),
  ('oidb-pf-rules-amendment', 'OIDB Staff PF Rules amendment', 'active'),
  ('fuel-marketing-resolution-chain', 'Transportation-fuel marketing authorisation Resolutions (bare file numbers)', 'active'),
  ('pm-ji-van-amendment', 'PM JI-VAN Yojana amendment (bare file-number target)', 'active'),
  ('arul-pipelines-references', 'ARUL Act pipeline notices: corrigendum and s.3(1)->s.6(1) citations', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Petroleum Products Order, 1999 (unchanged; gap is what the text says)
  ('mopng-gsr-272-1999', 'MoPNG', 'G.S.R. 272(E)', 1999, 'so-only', '1999-04-16', 'G.S.R. 272(E)', 'petroleum-and-natural-gas', 'petroleum-products-maintenance-order-1999', 'petroleum-products-maintenance-order-amendments'),
  ('mopng-gsr-870-2000', 'MoPNG', 'G.S.R. 870(E)', 2000, 'so-only', '2000-11-15', 'G.S.R. 870(E)', 'petroleum-and-natural-gas', 'petroleum-products-maintenance-order-1999', 'petroleum-products-maintenance-order-amendments'),
  ('mopng-gsr-730-2026', 'MoPNG', 'G.S.R. 730(E)', 2026, 'so-only', '2026-08-13', 'G.S.R. 730(E)', 'petroleum-and-natural-gas', 'petroleum-products-maintenance-order-1999', 'petroleum-products-maintenance-order-amendments'),
  -- Petroleum Rules, 2002 (intermediate inserted; draft precursor; corrected draft date)
  ('mopng-gsr-204-2002', 'MoPNG', 'G.S.R. 204(E)', 2002, 'so-only', '2002-03-13', 'G.S.R. 204(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments'),
  ('mopng-gsr-196-2021', 'MoPNG', 'G.S.R. 196(E)', 2021, 'so-only', '2021-03-17', 'G.S.R. 196(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments'),
  ('mopng-gsr-814-2023', 'MoPNG', 'G.S.R. 814(E)', 2023, 'so-only', '2023-10-31', 'G.S.R. 814(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments'),
  ('mopng-gsr-154-2024', 'MoPNG', 'G.S.R. 154(E)', 2024, 'so-only', '2024-03-04', 'G.S.R. 154(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments'),
  ('mopng-gsr-781-2026', 'MoPNG', 'G.S.R. 781(E)', 2026, 'so-only', '2026-09-03', 'G.S.R. 781(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments'),
  -- LPG Order, 2000 — 12-node chain
  ('mopng-gsr-487-2000', 'MoPNG', 'G.S.R. 487(E)', 2000, 'so-only', '2000-04-26', 'G.S.R. 487(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-177-2002', 'MoPNG', 'G.S.R. 177(E)', 2002, 'so-only', '2002-03-06', 'G.S.R. 177(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-730-2007', 'MoPNG', 'G.S.R. 730(E)', 2007, 'so-only', '2007-11-22', 'G.S.R. 730(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-655-2009', 'MoPNG', 'G.S.R. 655(E)', 2009, 'so-only', '2009-09-10', 'G.S.R. 655(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-452-2010', 'MoPNG', 'G.S.R. 452(E)', 2010, 'so-only', '2010-05-26', 'G.S.R. 452(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-718-2011', 'MoPNG', 'G.S.R. 718(E)', 2011, 'so-only', '2011-09-26', 'G.S.R. 718(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-647-2012', 'MoPNG', 'G.S.R. 647(E)', 2012, 'so-only', '2012-08-22', 'G.S.R. 647(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-791-2012', 'MoPNG', 'G.S.R. 791(E)', 2012, 'so-only', '2012-10-25', 'G.S.R. 791(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-781-2013', 'MoPNG', 'G.S.R. 781(E)', 2013, 'so-only', '2013-12-16', 'G.S.R. 781(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-721-2014', 'MoPNG', 'G.S.R. 721(E)', 2014, 'so-only', '2014-10-14', 'G.S.R. 721(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-so-1333-2026', 'MoPNG', 'S.O. 1333(E)',  2026, 'so-only', '2026-03-14', 'S.O. 1333(E)',  'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  ('mopng-gsr-406-2026', 'MoPNG', 'G.S.R. 406(E)', 2026, 'so-only', '2026-05-25', 'G.S.R. 406(E)', 'petroleum-and-natural-gas', 'lpg-supply-distribution-order-2000', 'lpg-order-2000-amendments'),
  -- MS&HSD Order, 2005 — 12-node chain
  ('mopng-gsr-729-2005', 'MoPNG', 'G.S.R. 729(E)', 2005, 'so-only', '2005-12-19', 'G.S.R. 729(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-18-2007',  'MoPNG', 'G.S.R. 18(E)',  2007, 'so-only', '2007-01-12', 'G.S.R. 18(E)',  'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-1-2008',   'MoPNG', 'G.S.R. 1(E)',   2008, 'so-only', '2008-12-31', 'G.S.R. 1(E)',   'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-352-2014', 'MoPNG', 'G.S.R. 352(E)', 2014, 'so-only', '2014-05-06', 'G.S.R. 352(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-621-2015', 'MoPNG', 'G.S.R. 621(E)', 2015, 'so-only', '2015-08-10', 'G.S.R. 621(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-728-2017', 'MoPNG', 'G.S.R. 728(E)', 2017, 'so-only', '2017-06-29', 'G.S.R. 728(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-395-2019', 'MoPNG', 'G.S.R. 395(E)', 2019, 'so-only', '2019-05-30', 'G.S.R. 395(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-830-2019', 'MoPNG', 'G.S.R. 830(E)', 2019, 'so-only', '2019-11-08', 'G.S.R. 830(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-903-2019', 'MoPNG', 'G.S.R. 903(E)', 2019, 'so-only', '2019-12-10', 'G.S.R. 903(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-78-2020',  'MoPNG', 'G.S.R. 78(E)',  2020, 'so-only', '2020-02-03', 'G.S.R. 78(E)',  'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-203-2021', 'MoPNG', 'G.S.R. 203(E)', 2021, 'so-only', '2021-03-22', 'G.S.R. 203(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  ('mopng-gsr-208-2024', 'MoPNG', 'G.S.R. 208(E)', 2024, 'so-only', '2024-03-15', 'G.S.R. 208(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005', 'ms-hsd-order-2005-amendments'),
  -- Ethanol-blending directive supersession
  ('mopng-so-2133-2021', 'MoPNG', 'S.O. 2133(E)', 2021, 'so-only', '2021-06-02', 'S.O. 2133(E)', 'petroleum-and-natural-gas', 'ms-hsd-order-2005-ethanol-directive', 'ethanol-blending-directive-supersession'),
  ('mopng-so-860-2026',  'MoPNG', 'S.O. 860(E)',  2026, 'so-only', '2026-02-17', 'S.O. 860(E)',  'petroleum-and-natural-gas', 'ms-hsd-order-2005-ethanol-directive', 'ethanol-blending-directive-supersession'),
  -- Lubricating Oils Order, 1987
  ('mopng-gsr-233-1987', 'MoPNG', 'G.S.R. 233(E)', 1987, 'so-only', '1987-03-20', 'G.S.R. 233(E)', 'petroleum-and-natural-gas', 'lubricating-oils-greases-order-1987', 'lubricating-oils-order-amendments'),
  ('mopng-gsr-770-2021', 'MoPNG', 'G.S.R. 770(E)', 2021, 'so-only', '2021-10-26', 'G.S.R. 770(E)', 'petroleum-and-natural-gas', 'lubricating-oils-greases-order-1987', 'lubricating-oils-order-amendments'),
  ('mopng-gsr-176-2024', 'MoPNG', 'G.S.R. 176(E)', 2024, 'so-only', '2024-03-12', 'G.S.R. 176(E)', 'petroleum-and-natural-gas', 'lubricating-oils-greases-order-1987', 'lubricating-oils-order-amendments'),
  -- Natural Gas (Supply Regulation) Order, 2026
  ('mopng-so-1232-2026', 'MoPNG', 'S.O. 1232(E)', 2026, 'so-only', '2026-03-09', 'S.O. 1232(E)', 'petroleum-and-natural-gas', 'natural-gas-supply-regulation-order-2026', 'natural-gas-supply-order-2026-amendment'),
  ('mopng-so-3647-2026', 'MoPNG', 'S.O. 3647(E)', 2026, 'so-only', '2026-07-04', 'S.O. 3647(E)', 'petroleum-and-natural-gas', 'natural-gas-supply-regulation-order-2026', 'natural-gas-supply-order-2026-amendment'),
  -- Pipelines Distribution Order, 2026
  ('mopng-so-1536-2026', 'MoPNG', 'S.O. 1536(E)', 2026, 'so-only', '2026-03-24', 'S.O. 1536(E)', 'petroleum-and-natural-gas', 'pipelines-distribution-order-2026', 'pipelines-distribution-order-2026-amendments'),
  ('mopng-so-2193-2026', 'MoPNG', 'S.O. 2193(E)', 2026, 'so-only', '2026-05-04', 'S.O. 2193(E)', 'petroleum-and-natural-gas', 'pipelines-distribution-order-2026', 'pipelines-distribution-order-2026-amendments'),
  ('mopng-so-3001-2026', 'MoPNG', 'S.O. 3001(E)', 2026, 'so-only', '2026-06-10', 'S.O. 3001(E)', 'petroleum-and-natural-gas', 'pipelines-distribution-order-2026', 'pipelines-distribution-order-2026-amendments'),
  -- Oilfields Act Schedule chain (principal is an Act, not a notification)
  ('mopng-gsr-814-2004', 'MoPNG', 'G.S.R. 814(E)', 2004, 'so-only', '2004-12-16', 'G.S.R. 814(E)', 'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-gsr-559-2007', 'MoPNG', 'G.S.R. 559(E)', 2007, 'so-only', '2007-08-20', 'G.S.R. 559(E)', 'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-so-615-2009',  'MoPNG', 'S.O. 615(E)',  2009, 'so-only', '2009-08-28', 'S.O. 615(E)',  'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-so-173-2016',  'MoPNG', 'S.O. 173(E)',  2016, 'so-only', '2016-01-15', 'S.O. 173(E)',  'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-so-367-2019',  'MoPNG', 'S.O. 367(E)',  2019, 'so-only', '2019-01-14', 'S.O. 367(E)',  'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-so-1597-2019', 'MoPNG', 'S.O. 1597(E)', 2019, 'so-only', '2019-04-11', 'S.O. 1597(E)', 'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-so-4382-2021', 'MoPNG', 'S.O. 4382(E)', 2021, 'so-only', '2021-10-20', 'S.O. 4382(E)', 'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-so-2376-2026', 'MoPNG', 'S.O. 2376(E)', 2026, 'so-only', '2026-05-08', 'S.O. 2376(E)', 'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  ('mopng-so-2860-2026', 'MoPNG', 'S.O. 2860(E)', 2026, 'so-only', '2026-06-04', 'S.O. 2860(E)', 'petroleum-and-natural-gas', 'oilfields-act-1948-schedule', 'oilfields-schedule-amendments'),
  -- Petroleum Act s.12 kerosene exemption validity extension
  ('mopng-so-1630-2026', 'MoPNG', 'S.O. 1630(E)', 2026, 'so-only', '2026-03-29', 'S.O. 1630(E)', 'petroleum-and-natural-gas', 'petroleum-act-1934-s12-kerosene-exemption', 'kerosene-exemption-validity-extension'),
  ('mopng-so-2854-2026', 'MoPNG', 'S.O. 2854(E)', 2026, 'so-only', '2026-06-04', 'S.O. 2854(E)', 'petroleum-and-natural-gas', 'petroleum-act-1934-s12-kerosene-exemption', 'kerosene-exemption-validity-extension'),
  -- OIDB Staff PF Rules, 2013
  ('mopng-gsr-49-2013',  'MoPNG', 'G.S.R. 49(E)',  2013, 'so-only', '2013-01-29', 'G.S.R. 49(E)',  'petroleum-and-natural-gas', 'oidb-staff-pf-rules-2013', 'oidb-pf-rules-amendment'),
  ('mopng-gsr-249-2024', 'MoPNG', 'G.S.R. 249(E)', 2024, 'so-only', '2024-04-22', 'G.S.R. 249(E)', 'petroleum-and-natural-gas', 'oidb-staff-pf-rules-2013', 'oidb-pf-rules-amendment'),
  -- Transportation-fuel marketing Resolutions (bare file numbers)
  ('mopng-res-p23015-2002', 'MoPNG', 'Resolution No. P-23015/1/2001-Mkt.', 2002, 'bare', '2002-03-08', 'Resolution No. P-23015/1/2001-Mkt.', 'petroleum-and-natural-gas', 'transportation-fuel-marketing-authorisation-resolution', 'fuel-marketing-resolution-chain'),
  ('mopng-res-p12029-2019', 'MoPNG', 'Resolution No. P-12029(11)/2/2018-OMC-PNG', 2019, 'bare', '2019-11-08', 'Resolution No. P-12029(11)/2/2018-OMC-PNG', 'petroleum-and-natural-gas', 'transportation-fuel-marketing-authorisation-resolution', 'fuel-marketing-resolution-chain'),
  ('mopng-res-m12043-2026', 'MoPNG', 'F. No. M-12043(11)/56/2025-OMC-PNG', 2026, 'bare', '2026-08-10', 'F. No. M-12043(11)/56/2025-OMC-PNG', 'petroleum-and-natural-gas', 'transportation-fuel-marketing-authorisation-resolution', 'fuel-marketing-resolution-chain'),
  ('mopng-gsr-474-2026', 'MoPNG', 'G.S.R. 474(E)', 2026, 'so-only', '2026-06-11', 'G.S.R. 474(E)', 'petroleum-and-natural-gas', 'ms-hsd-temporary-regulation-order-2026', 'fuel-marketing-resolution-chain'),
  -- PM JI-VAN Yojana (bare file-number target)
  ('mopng-file-p13032-2019', 'MoPNG', 'No. P-13032(17)/40/2017-CC', 2019, 'bare', '2019-03-07', 'No. P-13032(17)/40/2017-CC', 'petroleum-and-natural-gas', 'pm-ji-van-yojana-2019', 'pm-ji-van-amendment'),
  ('mopng-so-3544-2024', 'MoPNG', 'S.O. 3544(E)', 2024, 'so-only', '2024-08-21', 'S.O. 3544(E)', 'petroleum-and-natural-gas', 'pm-ji-van-yojana-2019', 'pm-ji-van-amendment'),
  -- ARUL Act pipeline notices
  ('mopng-so-3244-2022', 'MoPNG', 'S.O. 3244(E)', 2022, 'so-only', '2022-07-15', 'S.O. 3244(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-3963-2023', 'MoPNG', 'S.O. 3963(E)', 2023, 'so-only', '2023-08-31', 'S.O. 3963(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-2299-2021', 'MoPNG', 'S.O. 2299(E)', 2021, 'so-only', '2021-05-24', 'S.O. 2299(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-814-2023',  'MoPNG', 'S.O. 814(E)',  2023, 'so-only', '2023-02-16', 'S.O. 814(E)',  'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-4093-2023', 'MoPNG', 'S.O. 4093(E)', 2023, 'so-only', '2023-09-13', 'S.O. 4093(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-2291-2021', 'MoPNG', 'S.O. 2291(E)', 2021, 'so-only', '2021-05-20', 'S.O. 2291(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-813-2023',  'MoPNG', 'S.O. 813(E)',  2023, 'so-only', '2023-02-16', 'S.O. 813(E)',  'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-3856-2023', 'MoPNG', 'S.O. 3856(E)', 2023, 'so-only', '2023-08-28', 'S.O. 3856(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-3719-2022', 'MoPNG', 'S.O. 3719(E)', 2022, 'so-only', '2022-08-04', 'S.O. 3719(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-5490-2025', 'MoPNG', 'S.O. 5490(E)', 2025, 'so-only', '2025-11-28', 'S.O. 5490(E)', 'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-512-2022',  'MoPNG', 'S.O. 512(E)',  2022, 'so-only', '2022-02-04', 'S.O. 512(E)',  'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references'),
  ('mopng-so-120-2026',  'MoPNG', 'S.O. 120(E)',  2026, 'so-only', '2026-01-07', 'S.O. 120(E)',  'petroleum-and-natural-gas', 'arul-act-1962-pipelines', 'arul-pipelines-references');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mopng-gsr-870-2000', 'mopng-gsr-272-1999', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-730-2026', 'mopng-gsr-870-2000', 'amends', 'primary-source-egazette', '2026-09-04'),
  -- Petroleum Rules, 2002
  ('mopng-gsr-196-2021', 'mopng-gsr-204-2002', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-154-2024', 'mopng-gsr-196-2021', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-154-2024', 'mopng-gsr-814-2023', 'cites',  'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-781-2026', 'mopng-gsr-154-2024', 'cites',  'primary-source-egazette', '2026-09-04'),
  -- LPG Order, 2000
  ('mopng-gsr-177-2002', 'mopng-gsr-487-2000', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-730-2007', 'mopng-gsr-177-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-655-2009', 'mopng-gsr-730-2007', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-452-2010', 'mopng-gsr-655-2009', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-718-2011', 'mopng-gsr-452-2010', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-647-2012', 'mopng-gsr-718-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-791-2012', 'mopng-gsr-647-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-781-2013', 'mopng-gsr-791-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-721-2014', 'mopng-gsr-781-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-1333-2026', 'mopng-gsr-721-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-406-2026', 'mopng-so-1333-2026', 'amends', 'primary-source-egazette', '2026-09-04'),
  -- MS&HSD Order, 2005
  ('mopng-gsr-18-2007',  'mopng-gsr-729-2005', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-1-2008',   'mopng-gsr-18-2007',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-352-2014', 'mopng-gsr-1-2008',   'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-621-2015', 'mopng-gsr-352-2014', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-728-2017', 'mopng-gsr-621-2015', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-395-2019', 'mopng-gsr-728-2017', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-830-2019', 'mopng-gsr-395-2019', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-903-2019', 'mopng-gsr-830-2019', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-78-2020',  'mopng-gsr-903-2019', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-203-2021', 'mopng-gsr-78-2020',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-gsr-208-2024', 'mopng-gsr-203-2021', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-860-2026',  'mopng-so-2133-2021', 'supersedes', 'primary-source-egazette', '2026-09-04'),
  -- Lubricating Oils Order, 1987
  ('mopng-gsr-770-2021', 'mopng-gsr-233-1987', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-176-2024', 'mopng-gsr-770-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- 2026 Orders
  ('mopng-so-3647-2026', 'mopng-so-1232-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-2193-2026', 'mopng-so-1536-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-3001-2026', 'mopng-so-2193-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Oilfields Act Schedule
  ('mopng-gsr-559-2007', 'mopng-gsr-814-2004', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-615-2009',  'mopng-gsr-559-2007', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-173-2016',  'mopng-so-615-2009',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-367-2019',  'mopng-so-173-2016',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-1597-2019', 'mopng-so-367-2019',  'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-4382-2021', 'mopng-so-1597-2019', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-2376-2026', 'mopng-so-4382-2021', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('mopng-so-2860-2026', 'mopng-so-2376-2026', 'amends', 'primary-source-egazette', '2026-09-04'),
  -- Kerosene exemption validity extension
  ('mopng-so-2854-2026', 'mopng-so-1630-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- OIDB PF Rules
  ('mopng-gsr-249-2024', 'mopng-gsr-49-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Resolutions (bare)
  ('mopng-res-m12043-2026', 'mopng-res-p12029-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-474-2026', 'mopng-res-p12029-2019', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-474-2026', 'mopng-res-p23015-2002', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-3544-2024', 'mopng-file-p13032-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- ARUL Act pipeline notices
  ('mopng-so-3963-2023', 'mopng-so-3244-2022', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-4093-2023', 'mopng-so-2299-2021', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-4093-2023', 'mopng-so-814-2023',  'cites', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-3856-2023', 'mopng-so-2291-2021', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-3856-2023', 'mopng-so-813-2023',  'cites', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-5490-2025', 'mopng-so-3719-2022', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mopng-so-120-2026',  'mopng-so-512-2022',  'cites', 'research-agent-quoted', '2026-09-04');
