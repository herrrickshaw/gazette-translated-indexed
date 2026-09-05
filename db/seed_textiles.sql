-- Ministry of Textiles. Coverage-plan pilot (2026-09-04) then depth pass
-- (2026-09-05): 145-item corpus (3 listing pages) fully read via gazettetracker
-- Full Text + 9 egazette PDF cross-checks. Went from 8 notifications / 6
-- cross-references to 73 notifications / 61 cross-references across 18
-- subject threads (2 original + 16 new).
--
-- Deferred, not modeled (documented, not a research gap):
-- - S.O. 3189(E) supersedes Notification No. 2/TDRO/8/2003 (Hank Yarn
--   packing, Textiles Development and Regulation Order 2001) and its four
--   amendments (04/06/2010, 05/2015, 06/2018, 7/2019) -- confirmed via the
--   Textile Commissioner's own PDF that ALL of these are Part I Section 1
--   notifications, which carry no S.O./G.S.R. number at all. Not a gap to
--   close; there is no number to find.
-- - S.O. 4634(E) "in supersession of the Medical Textiles (Quality Control)
--   Order, 2023" -- names the target by title only, no number/date, though
--   the target (S.O. 4247(E), modeled below) is unambiguous in-corpus.
-- - S.O. 4553(E) "supersession of the Notification No Jute(Mktg)/139/2021
--   dated 05-10-2023" -- file-number-only; date is suspect (a 2021-series
--   file number "dated" the same day as the citing notification itself).
-- - PLI Scheme for Textiles and RoSCTL amendment chains -- real, multi-node,
--   but Part I Section 1 file-number-only citations throughout (no
--   S.O./G.S.R. anywhere in either chain).
-- - Three "Order of even number dated D" stock-limit citations were
--   resolved by matching the cited date against this ministry's own
--   in-corpus signing dates (not modeled as bare/file-number nodes).
--
-- Real corrections/notes from this pass:
-- - Year-rollover hazard: several Kolkata Jute Commissioner and BIC Estate
--   Officer notifications are signed in December but carry the following
--   calendar year's S.O. serial (gazetted in January). `year` follows the
--   gazette/serial year; `publish_date` is the signing date the citing text
--   actually quotes.
-- - A real S.O. 4327(E) number collision across years: 2024 (Ropes and
--   Cordages QC Order, already modeled) vs 2026 (Central Silk-worm Seed
--   Committee re-constitution, not modeled -- no useful edge found).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('textiles', 'Ministry of Textiles', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('cotton-bales-quality-control-order-2023', 'Cotton Bales (Quality Control) Order, 2023', 2023),
  ('ropes-cordages-quality-control-order-2024', 'Ropes and Cordages (Quality Control) Order, 2024', 2024),
  ('medical-textiles-quality-control-order-2023', 'Medical Textiles (Quality Control) Order, 2023', 2023),
  ('jpm-reservation-order', 'Jute Packaging Materials (Compulsory Use in Packing Commodities) Reservation Order', NULL),
  ('jute-jute-textiles-control-order-2016', 'Jute and Jute Textiles Control Order, 2016', 2016),
  ('public-premises-act-1971-s3', 'Public Premises (Eviction of Unauthorised Occupants) Act, 1971 -- section 3 Estate Officer appointment', 1971),
  ('national-jute-board-act-2008-s3', 'National Jute Board Act, 2008 -- section 3 Board constitution', 2008),
  ('geo-textiles-quality-control-order-2022', 'Geo Textiles (Quality Control) Order, 2022', 2022),
  ('agro-textiles-quality-control-order-2023', 'Agro Textiles (Quality Control) Order, 2023', 2023),
  ('protective-textiles-quality-control-order-2023', 'Protective Textiles (Quality Control) Order, 2023', 2023),
  ('viscose-staple-fibres-quality-control-order', 'Viscose Staple Fibres (Quality Control) Order', NULL),
  ('central-silk-board-rules-1955', 'Central Silk Board Rules, 1955', 1955);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('textiles-cotton-bales-order', 'Cotton Bales (Quality Control) Order, its amendments, and its rescission', 'superseded'),
  ('textiles-ropes-cordages-order', 'Ropes and Cordages (Quality Control) Order and its amendment', 'active'),
  ('textiles-medical-textiles-qc', 'Medical Textiles (Quality Control) Order and its amendments/successor', 'active'),
  ('textiles-jpm-reservation-order', 'Jute Packaging Materials reservation order: extensions and re-issues', 'active'),
  ('textiles-jute-stock-limit-2025-26', 'Raw jute stock-limit orders, Jute Commissioner, 2025-26 season', 'superseded'),
  ('textiles-jute-stock-limit-2025', 'Raw jute stock-limit orders, Jute Commissioner, 2025 season', 'superseded'),
  ('textiles-raw-jute-min-price-2023-24', 'Minimum price of raw jute, 2023-24 season', 'active'),
  ('textiles-bic-estate-officer', 'Estate Officer appointments under the Public Premises Act for BIC-related premises', 'active'),
  ('textiles-njb-nominations', 'National Jute Board nominations/reconstitution', 'active'),
  ('textiles-geo-textiles-qco', 'Geo Textiles (Quality Control) Order and its amendment', 'active'),
  ('textiles-agro-textiles-qco', 'Agro Textiles (Quality Control) Order and its amendment', 'active'),
  ('textiles-protective-textiles-qco', 'Protective Textiles (Quality Control) Order and related orders', 'active'),
  ('textiles-viscose-staple-fibres-qco', 'Viscose Staple Fibres quality control -- rescission', 'superseded'),
  ('textiles-jute-hearing-order-corrigendum', 'Jute Commissioner hearing order and its corrigendum', 'active'),
  ('textiles-central-silk-board-rules', 'Central Silk Board Rules, 1955 amendments', 'active'),
  ('textiles-jute-bag-price-fixation', 'Jute bag ex-factory price fixation, arrear revisions', 'active'),
  ('textiles-jute-dealer-registration', 'Jute dealer/trader registration directive', 'active'),
  ('textiles-jute-loomtex-hearing', 'Jute Loomtex hearing order citing Jute QCO', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('textiles-so-4247-2023', 'Textiles', 'S.O. 4247(E)', 2023, 'so-only', '2023-09-27', 'S.O. 4247(E)', 'textiles', 'medical-textiles-quality-control-order-2023', 'textiles-medical-textiles-qc'),
  ('textiles-so-830-2024', 'Textiles', 'S.O. 830(E)', 2024, 'so-only', '2024-02-22', 'S.O. 830(E)', 'textiles', 'medical-textiles-quality-control-order-2023', 'textiles-medical-textiles-qc'),
  ('textiles-so-4634-2024', 'Textiles', 'S.O. 4634(E)', 2024, 'so-only', '2024-10-23', 'S.O. 4634(E)', 'textiles', 'medical-textiles-quality-control-order-2023', 'textiles-medical-textiles-qc'),
  ('textiles-so-4-2025', 'Textiles', 'S.O. 04(E)', 2025, 'so-only', '2025-01-01', 'S.O. 04(E)', 'textiles', 'medical-textiles-quality-control-order-2023', 'textiles-medical-textiles-qc'),
  ('textiles-so-3526-2025', 'Textiles', 'S.O. 3526(E)', 2025, 'so-only', '2025-07-30', 'S.O. 3526(E)', 'textiles', 'medical-textiles-quality-control-order-2023', 'textiles-medical-textiles-qc'),
  ('textiles-so-1532-2023', 'Textiles', 'S.O. 1532(E)', 2023, 'so-only', '2023-03-31', 'S.O. 1532(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-295-2022', 'Textiles', 'S.O. 295(E)', 2022, 'so-only', '2022-01-19', 'S.O. 295(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-4226-2023', 'Textiles', 'S.O. 4226(E)', 2023, 'so-only', '2023-09-26', 'S.O. 4226(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-5459-2023', 'Textiles', 'S.O. 5459(E)', 2023, 'so-only', '2023-12-26', 'S.O. 5459(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-2500-2024', 'Textiles', 'S.O. 2500(E)', 2024, 'so-only', '2024-06-28', 'S.O. 2500(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-4319-2024', 'Textiles', 'S.O. 4319(E)', 2024, 'so-only', '2024-10-01', 'S.O. 4319(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-5653-2024', 'Textiles', 'S.O. 5653(E)', 2024, 'so-only', '2024-12-31', 'S.O. 5653(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-1649-2025', 'Textiles', 'S.O. 1649(E)', 2025, 'so-only', '2025-04-08', 'S.O. 1649(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-1830-2025', 'Textiles', 'S.O. 1830(E)', 2025, 'so-only', '2025-04-22', 'S.O. 1830(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-2902-2025', 'Textiles', 'S.O. 2902(E)', 2025, 'so-only', '2025-06-30', 'S.O. 2902(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-4501-2025', 'Textiles', 'S.O. 4501(E)', 2025, 'so-only', '2025-10-01', 'S.O. 4501(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-6138-2025', 'Textiles', 'S.O. 6138(E)', 2025, 'so-only', '2025-12-31', 'S.O. 6138(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-845-2026', 'Textiles', 'S.O. 845(E)', 2026, 'so-only', '2026-02-16', 'S.O. 845(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-3585-2026', 'Textiles', 'S.O. 3585(E)', 2026, 'so-only', '2026-07-01', 'S.O. 3585(E)', 'textiles', 'jpm-reservation-order', 'textiles-jpm-reservation-order'),
  ('textiles-so-4577-2025', 'Textiles', 'S.O. 4577(E)', 2025, 'so-only', '2025-09-24', 'S.O. 4577(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025-26'),
  ('textiles-so-5-2026', 'Textiles', 'S.O. 5(E)', 2026, 'so-only', '2025-12-18', 'S.O. 5(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025-26'),
  ('textiles-so-310-2026', 'Textiles', 'S.O. 310(E)', 2026, 'so-only', '2026-01-19', 'S.O. 310(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025-26'),
  ('textiles-so-1007-2026', 'Textiles', 'S.O. 1007(E)', 2026, 'so-only', '2026-02-24', 'S.O. 1007(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025-26'),
  ('textiles-so-1493-2026', 'Textiles', 'S.O. 1493(E)', 2026, 'so-only', '2026-03-20', 'S.O. 1493(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025-26'),
  ('textiles-so-2050-2026', 'Textiles', 'S.O. 2050(E)', 2026, 'so-only', '2026-04-20', 'S.O. 2050(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025-26'),
  ('textiles-so-3705-2026', 'Textiles', 'S.O. 3705(E)', 2026, 'so-only', '2026-07-08', 'S.O. 3705(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025-26'),
  ('textiles-so-2317-2025', 'Textiles', 'S.O. 2317(E)', 2025, 'so-only', '2025-05-20', 'S.O. 2317(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025'),
  ('textiles-so-3532-2025', 'Textiles', 'S.O. 3532(E)', 2025, 'so-only', '2025-06-16', 'S.O. 3532(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025'),
  ('textiles-so-3533-2025', 'Textiles', 'S.O. 3533(E)', 2025, 'so-only', '2025-07-25', 'S.O. 3533(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-stock-limit-2025'),
  ('textiles-so-4553-2023', 'Textiles', 'S.O. 4553(E)', 2023, 'so-only', '2023-10-05', 'S.O. 4553(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-raw-jute-min-price-2023-24'),
  ('textiles-so-4707-2023', 'Textiles', 'S.O. 4707(E)', 2023, 'so-only', '2023-10-19', 'S.O. 4707(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-raw-jute-min-price-2023-24'),
  ('textiles-so-190-2021', 'Textiles', 'S.O. 190(E)', 2021, 'so-only', '2021-01-13', 'S.O. 190(E)', 'textiles', 'public-premises-act-1971-s3', 'textiles-bic-estate-officer'),
  ('textiles-so-4550-2022', 'Textiles', 'S.O. 4550(E)', 2022, 'so-only', '2022-08-30', 'S.O. 4550(E)', 'textiles', 'public-premises-act-1971-s3', 'textiles-bic-estate-officer'),
  ('textiles-so-4632-2023', 'Textiles', 'S.O. 4632(E)', 2023, 'so-only', '2023-10-20', 'S.O. 4632(E)', 'textiles', 'public-premises-act-1971-s3', 'textiles-bic-estate-officer'),
  ('textiles-so-33-2024', 'Textiles', 'S.O. 33(E)', 2024, 'so-only', '2023-12-29', 'S.O. 33(E)', 'textiles', 'public-premises-act-1971-s3', 'textiles-bic-estate-officer'),
  ('textiles-so-3444-2024', 'Textiles', 'S.O. 3444(E)', 2024, 'so-only', '2024-08-07', 'S.O. 3444(E)', 'textiles', 'public-premises-act-1971-s3', 'textiles-bic-estate-officer'),
  ('textiles-so-3535-2025', 'Textiles', 'S.O. 3535(E)', 2025, 'so-only', '2025-07-26', 'S.O. 3535(E)', 'textiles', 'public-premises-act-1971-s3', 'textiles-bic-estate-officer'),
  ('textiles-so-768-2021', 'Textiles', 'S.O. 768(E)', 2021, 'so-only', '2021-02-19', 'S.O. 768(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-3375-2020', 'Textiles', 'S.O. 3375(E)', 2020, 'so-only', '2020-09-29', 'S.O. 3375(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-4904-2022', 'Textiles', 'S.O. 4904(E)', 2022, 'so-only', '2022-10-17', 'S.O. 4904(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-3839-2023', 'Textiles', 'S.O. 3839(E)', 2023, 'so-only', '2023-08-28', 'S.O. 3839(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-152-2024', 'Textiles', 'S.O. 152(E)', 2024, 'so-only', '2024-01-11', 'S.O. 152(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-3642-2024', 'Textiles', 'S.O. 3642(E)', 2024, 'so-only', '2024-08-28', 'S.O. 3642(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-5325-2024', 'Textiles', 'S.O. 5325(E)', 2024, 'so-only', '2024-12-10', 'S.O. 5325(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-712-2025', 'Textiles', 'S.O. 712(E)', 2025, 'so-only', '2025-02-11', 'S.O. 712(E)', 'textiles', 'national-jute-board-act-2008-s3', 'textiles-njb-nominations'),
  ('textiles-so-1706-2023', 'Textiles', 'S.O. 1706(E)', 2023, 'so-only', '2023-04-10', 'S.O. 1706(E)', 'textiles', 'geo-textiles-quality-control-order-2022', 'textiles-geo-textiles-qco'),
  ('textiles-so-2331-2023', 'Textiles', 'S.O. 2331(E)', 2023, 'so-only', '2023-05-24', 'S.O. 2331(E)', 'textiles', 'geo-textiles-quality-control-order-2022', 'textiles-geo-textiles-qco'),
  ('textiles-so-4386-2023', 'Textiles', 'S.O. 4386(E)', 2023, 'so-only', '2023-10-10', 'S.O. 4386(E)', 'textiles', 'geo-textiles-quality-control-order-2022', 'textiles-geo-textiles-qco'),
  ('textiles-so-4248-2023', 'Textiles', 'S.O. 4248(E)', 2023, 'so-only', '2023-09-27', 'S.O. 4248(E)', 'textiles', 'agro-textiles-quality-control-order-2023', 'textiles-agro-textiles-qco'),
  ('textiles-so-1579-2024', 'Textiles', 'S.O. 1579(E)', 2024, 'so-only', '2024-03-28', 'S.O. 1579(E)', 'textiles', 'agro-textiles-quality-control-order-2023', 'textiles-agro-textiles-qco'),
  ('textiles-so-1707-2023', 'Textiles', 'S.O. 1707(E)', 2023, 'so-only', '2023-04-10', 'S.O. 1707(E)', 'textiles', 'protective-textiles-quality-control-order-2023', 'textiles-protective-textiles-qco'),
  ('textiles-so-2332-2023', 'Textiles', 'S.O. 2332(E)', 2023, 'so-only', '2023-05-24', 'S.O. 2332(E)', 'textiles', 'protective-textiles-quality-control-order-2023', 'textiles-protective-textiles-qco'),
  ('textiles-so-3896-2024', 'Textiles', 'S.O. 3896(E)', 2024, 'so-only', '2024-09-11', 'S.O. 3896(E)', 'textiles', 'protective-textiles-quality-control-order-2023', 'textiles-protective-textiles-qco'),
  ('textiles-so-3916-2024', 'Textiles', 'S.O. 3916(E)', 2024, 'so-only', '2024-09-12', 'S.O. 3916(E)', 'textiles', 'protective-textiles-quality-control-order-2023', 'textiles-protective-textiles-qco'),
  ('textiles-so-6143-2022', 'Textiles', 'S.O. 6143(E)', 2022, 'so-only', '2022-12-29', 'S.O. 6143(E)', 'textiles', 'viscose-staple-fibres-quality-control-order', 'textiles-viscose-staple-fibres-qco'),
  ('textiles-so-5267-2025', 'Textiles', 'S.O. 5267(E)', 2025, 'so-only', '2025-11-18', 'S.O. 5267(E)', 'textiles', 'viscose-staple-fibres-quality-control-order', 'textiles-viscose-staple-fibres-qco'),
  ('textiles-so-5655-2024', 'Textiles', 'S.O. 5655(E)', 2024, 'so-only', '2024-12-18', 'S.O. 5655(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-hearing-order-corrigendum'),
  ('textiles-so-133-2025', 'Textiles', 'S.O. 133(E)', 2025, 'so-only', '2025-01-07', 'S.O. 133(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-hearing-order-corrigendum'),
  ('textiles-sro-662-1955', 'Textiles', 'S.R.O. 662', 1955, 'bare', '1955-03-23', 'S.R.O. 662', 'textiles', 'central-silk-board-rules-1955', 'textiles-central-silk-board-rules'),
  ('textiles-gsr-76-2015', 'Textiles', 'G.S.R. 76', 2015, 'bare', '2015-03-31', 'G.S.R. 76', 'textiles', 'central-silk-board-rules-1955', 'textiles-central-silk-board-rules'),
  ('textiles-gsr-36-2026', 'Textiles', 'G.S.R. 36(E)', 2026, 'so-only', '2026-01-15', 'G.S.R. 36(E)', 'textiles', 'central-silk-board-rules-1955', 'textiles-central-silk-board-rules'),
  ('textiles-so-43-2016', 'Textiles', 'S.O. 43(E)', 2016, 'so-only', '2016-12-16', 'S.O. 43(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-44-2016', 'Textiles', 'S.O. 44(E)', 2016, 'so-only', '2016-12-16', 'S.O. 44(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-39-2016', 'Textiles', 'S.O. 39(E)', 2016, 'so-only', '2016-12-16', 'S.O. 39(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-40-2016', 'Textiles', 'S.O. 40(E)', 2016, 'so-only', '2016-12-16', 'S.O. 40(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-707-2017', 'Textiles', 'S.O. 707(E)', 2017, 'so-only', '2017-01-06', 'S.O. 707(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-708-2017', 'Textiles', 'S.O. 708(E)', 2017, 'so-only', '2017-02-20', 'S.O. 708(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-1615-2026', 'Textiles', 'S.O. 1615(E)', 2026, 'so-only', '2026-03-26', 'S.O. 1615(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-1616-2026', 'Textiles', 'S.O. 1616(E)', 2026, 'so-only', '2026-03-26', 'S.O. 1616(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-bag-price-fixation'),
  ('textiles-so-2523-2021', 'Textiles', 'S.O. 2523(E)', 2021, 'so-only', '2021-06-18', 'S.O. 2523(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-dealer-registration'),
  ('textiles-so-1010-2026', 'Textiles', 'S.O. 1010(E)', 2026, 'so-only', '2026-02-24', 'S.O. 1010(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-dealer-registration'),
  ('textiles-so-2601-2022', 'Textiles', 'S.O. 2601(E)', 2022, 'so-only', '2022-06-06', 'S.O. 2601(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-loomtex-hearing'),
  ('textiles-so-2657-2024', 'Textiles', 'S.O. 2657(E)', 2024, 'so-only', '2024-06-24', 'S.O. 2657(E)', 'textiles', 'jute-jute-textiles-control-order-2016', 'textiles-jute-loomtex-hearing');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('textiles-so-830-2024', 'textiles-so-4247-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4-2025', 'textiles-so-4634-2024', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3526-2025', 'textiles-so-4634-2024', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3526-2025', 'textiles-so-4-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4226-2023', 'textiles-so-1532-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-5459-2023', 'textiles-so-1532-2023', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-5459-2023', 'textiles-so-295-2022', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-2500-2024', 'textiles-so-5459-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4319-2024', 'textiles-so-5459-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-5653-2024', 'textiles-so-5459-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1649-2025', 'textiles-so-5459-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1830-2025', 'textiles-so-5459-2023', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1830-2025', 'textiles-so-295-2022', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-2902-2025', 'textiles-so-1830-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4501-2025', 'textiles-so-1830-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-6138-2025', 'textiles-so-1830-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-845-2026', 'textiles-so-1830-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3585-2026', 'textiles-so-1830-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-5-2026', 'textiles-so-4577-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-310-2026', 'textiles-so-5-2026', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1007-2026', 'textiles-so-310-2026', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1493-2026', 'textiles-so-1007-2026', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-2050-2026', 'textiles-so-1493-2026', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3705-2026', 'textiles-so-4577-2025', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3705-2026', 'textiles-so-5-2026', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3705-2026', 'textiles-so-310-2026', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3705-2026', 'textiles-so-1007-2026', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3705-2026', 'textiles-so-1493-2026', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3705-2026', 'textiles-so-2050-2026', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3532-2025', 'textiles-so-2317-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3533-2025', 'textiles-so-2317-2025', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3533-2025', 'textiles-so-3532-2025', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4707-2023', 'textiles-so-4553-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4632-2023', 'textiles-so-190-2021', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4632-2023', 'textiles-so-4550-2022', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-33-2024', 'textiles-so-4632-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3444-2024', 'textiles-so-33-2024', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3535-2025', 'textiles-so-3444-2024', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3839-2023', 'textiles-so-768-2021', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-152-2024', 'textiles-so-3375-2020', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3642-2024', 'textiles-so-152-2024', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-5325-2024', 'textiles-so-3839-2023', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-712-2025', 'textiles-so-4904-2022', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4386-2023', 'textiles-so-1706-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-4386-2023', 'textiles-so-2331-2023', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1579-2024', 'textiles-so-4248-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3896-2024', 'textiles-so-1707-2023', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3896-2024', 'textiles-so-2332-2023', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-3916-2024', 'textiles-so-3896-2024', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-5267-2025', 'textiles-so-6143-2022', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-133-2025', 'textiles-so-5655-2024', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('textiles-gsr-36-2026', 'textiles-sro-662-1955', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-gsr-36-2026', 'textiles-gsr-76-2015', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1615-2026', 'textiles-so-43-2016', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1615-2026', 'textiles-so-44-2016', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1615-2026', 'textiles-so-39-2016', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1615-2026', 'textiles-so-40-2016', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1616-2026', 'textiles-so-707-2017', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1616-2026', 'textiles-so-708-2017', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-1010-2026', 'textiles-so-2523-2021', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('textiles-so-2657-2024', 'textiles-so-2601-2022', 'cites', 'research-agent-quoted', '2026-09-05');

