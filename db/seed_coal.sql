-- Ministry of Coal. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass.
--
-- The Coal Mines Pension Scheme chain's 15-item gap (items 2-16,
-- previously undocumented) is now fully closed: the notification
-- containing the current link's own Note quotes the COMPLETE numbered
-- list of all 18 prior amendments. Full 20-node chain now modeled
-- (principal + 18 + current), generated programmatically from the
-- verbatim quote to avoid transcription error. Item 11 (G.S.R. 403,
-- 2004) is a real bare form with no "(E)" suffix; item 17 (S.O. 4336(E))
-- is the chain's only S.O.-numbered link, everything else is G.S.R.
--
-- Five further real pairs/chains found across new subject areas: Coal
-- Bearing Areas Act land-boundary amendment, Mineral Concession Rules
-- 1960, Coal Mines (Special Provisions) Rules 2014, an MMDR Act coal-sale
-- percentage amendment, and a draft-to-final Adjudication of Penalties
-- Rules pair (relation_type='cites' for the draft link, same convention
-- as Petroleum's and Civil Aviation's own draft notifications).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('coal', 'Ministry of Coal', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('coal-blocks-allocation-rules-2017', 'Coal Blocks Allocation Rules, 2017', 2017),
  ('colliery-control-rules-2004', 'Colliery Control Rules, 2004', 2004),
  ('coal-mines-pension-scheme-1998', 'Coal Mines Pension Scheme, 1998', 1998),
  ('coal-bearing-areas-act-1957-land', 'Coal Bearing Areas (Acquisition and Development) Act, 1957 — land-boundary notification', 1957),
  ('mineral-concession-rules-1960', 'Mineral Concession Rules, 1960', 1960),
  ('coal-mines-special-provisions-rules-2014', 'Coal Mines (Special Provisions) Rules, 2014', 2014),
  ('mmdr-act-1957-s8-coal-sale', 'Mines and Minerals (Development and Regulation) Act, 1957 — s.8(5) proviso, coal-sale percentage', 1957),
  ('coal-mines-special-provisions-penalties-rules-2026', 'Coal Mines (Special Provisions) Adjudication of Penalties Rules, 2026', 2026);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('coal-blocks-allocation-amendments', 'Coal Blocks Allocation Rules and its amendments', 'active'),
  ('colliery-control-amendments', 'Colliery Control Rules and its amendments', 'active'),
  ('coal-mines-pension-amendments', 'Coal Mines Pension Scheme and its complete 18-item amendment history', 'active'),
  ('coal-bearing-areas-land-amendment', 'Coal Bearing Areas Act land-boundary amendment', 'active'),
  ('mineral-concession-rules-amendments', 'Mineral Concession Rules, 1960 and its amendments', 'active'),
  ('coal-mines-special-provisions-rules-amendments', 'Coal Mines (Special Provisions) Rules, 2014 and its amendments (incl. a pending draft)', 'active'),
  ('mmdr-coal-sale-percentage-amendment', 'MMDR Act coal-sale percentage amendment (NLC India Talabira)', 'active'),
  ('coal-mines-penalties-rules-draft-final', 'Coal Mines Special Provisions Adjudication of Penalties Rules, draft to final', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Coal Blocks Allocation Rules chain (unchanged)
  ('coal-gsr-877-2017', 'Coal', 'G.S.R. 877(E)', 2017, 'so-only', '2017-07-13', 'G.S.R. 877(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  ('coal-gsr-300-2020', 'Coal', 'G.S.R. 300(E)', 2020, 'so-only', '2020-05-18', 'G.S.R. 300(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  ('coal-gsr-394-2023', 'Coal', 'G.S.R. 394(E)', 2023, 'so-only', '2023-05-29', 'G.S.R. 394(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  ('coal-gsr-508-2026', 'Coal', 'G.S.R. 508(E)', 2026, 'so-only', '2026-06-22', 'G.S.R. 508(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  -- Colliery Control Rules chain (unchanged)
  ('coal-gsr-540-2004', 'Coal', 'G.S.R. 540(E)', 2004, 'so-only', '2004-08-25', 'G.S.R. 540(E)', 'coal', 'colliery-control-rules-2004', 'colliery-control-amendments'),
  ('coal-gsr-917-2025', 'Coal', 'G.S.R. 917(E)', 2025, 'so-only', '2025-12-23', 'G.S.R. 917(E)', 'coal', 'colliery-control-rules-2004', 'colliery-control-amendments'),
  ('coal-gsr-710-2026', 'Coal', 'G.S.R. 710(E)', 2026, 'so-only', '2026-08-06', 'G.S.R. 710(E)', 'coal', 'colliery-control-rules-2004', 'colliery-control-amendments'),
  -- Coal Mines Pension Scheme: full 20-node chain
  ('coal-gsr-123-pension', 'Coal', 'G.S.R. 123(E)', 1998, 'so-only', '1998-03-05', 'G.S.R. 123(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-268-pension', 'Coal', 'G.S.R. 268(E)', 1998, 'so-only', '1998-05-25', 'G.S.R. 268(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-218-pension', 'Coal', 'G.S.R. 218(E)', 1999, 'so-only', '1999-03-22', 'G.S.R. 218(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-689-pension', 'Coal', 'G.S.R. 689(E)', 2000, 'so-only', '2000-08-29', 'G.S.R. 689(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-256-pension', 'Coal', 'G.S.R. 256(E)', 2001, 'so-only', '2001-04-12', 'G.S.R. 256(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-861-pension', 'Coal', 'G.S.R. 861(E)', 2001, 'so-only', '2001-11-23', 'G.S.R. 861(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-16-pension',  'Coal', 'G.S.R. 16(E)',  2002, 'so-only', '2002-01-09', 'G.S.R. 16(E)',  'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-482-pension', 'Coal', 'G.S.R. 482(E)', 2002, 'so-only', '2002-07-08', 'G.S.R. 482(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-107-pension', 'Coal', 'G.S.R. 107(E)', 2003, 'so-only', '2003-02-13', 'G.S.R. 107(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-108-pension', 'Coal', 'G.S.R. 108(E)', 2003, 'so-only', '2003-02-13', 'G.S.R. 108(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-521-pension', 'Coal', 'G.S.R. 521(E)', 2004, 'so-only', '2004-08-12', 'G.S.R. 521(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-403-pension', 'Coal', 'G.S.R. 403',    2004, 'bare',    '2004-11-19', 'G.S.R. 403',    'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-154-pension', 'Coal', 'G.S.R. 154(E)', 2009, 'so-only', '2009-03-05', 'G.S.R. 154(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-348-pension', 'Coal', 'G.S.R. 348(E)', 2009, 'so-only', '2009-05-22', 'G.S.R. 348(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-774-pension', 'Coal', 'G.S.R. 774(E)', 2009, 'so-only', '2009-10-22', 'G.S.R. 774(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-540-pension', 'Coal', 'G.S.R. 540(E)', 2018, 'so-only', '2018-06-08', 'G.S.R. 540(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-119-pension', 'Coal', 'G.S.R. 119(E)', 2023, 'so-only', '2023-02-22', 'G.S.R. 119(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-so-4336-pension', 'Coal', 'S.O. 4336(E)',  2023, 'so-only', '2023-10-04', 'S.O. 4336(E)',  'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-165-2024',   'Coal', 'G.S.R. 165(E)', 2024, 'so-only', '2024-03-08', 'G.S.R. 165(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-370-2026',   'Coal', 'G.S.R. 370(E)', 2026, 'so-only', '2026-05-15', 'G.S.R. 370(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  -- Coal Bearing Areas Act land-boundary amendment
  ('coal-so-1039-1999', 'Coal', 'S.O. 1039(E)', 1999, 'so-only', '1999-10-20', 'S.O. 1039(E)', 'coal', 'coal-bearing-areas-act-1957-land', 'coal-bearing-areas-land-amendment'),
  ('coal-so-4392-2026', 'Coal', 'S.O. 4392(E)', 2026, 'so-only', '2026-08-07', 'S.O. 4392(E)', 'coal', 'coal-bearing-areas-act-1957-land', 'coal-bearing-areas-land-amendment'),
  -- Mineral Concession Rules chain
  ('coal-gsr-1398-1960', 'Coal', 'G.S.R. 1398',  1960, 'bare',    '1960-11-26', 'G.S.R. 1398',  'coal', 'mineral-concession-rules-1960', 'mineral-concession-rules-amendments'),
  ('coal-gsr-323-2025',  'Coal', 'G.S.R. 323(E)', 2025, 'so-only', '2025-05-20', 'G.S.R. 323(E)', 'coal', 'mineral-concession-rules-1960', 'mineral-concession-rules-amendments'),
  ('coal-gsr-150-2026',  'Coal', 'G.S.R. 150(E)', 2026, 'so-only', '2026-02-27', 'G.S.R. 150(E)', 'coal', 'mineral-concession-rules-1960', 'mineral-concession-rules-amendments'),
  -- Coal Mines (Special Provisions) Rules 2014 chain (current is a draft)
  ('coal-gsr-883-2014', 'Coal', 'G.S.R. 883(E)', 2014, 'so-only', '2014-12-11', 'G.S.R. 883(E)', 'coal', 'coal-mines-special-provisions-rules-2014', 'coal-mines-special-provisions-rules-amendments'),
  ('coal-gsr-782-2015', 'Coal', 'G.S.R. 782(E)', 2015, 'so-only', '2015-03-18', 'G.S.R. 782(E)', 'coal', 'coal-mines-special-provisions-rules-2014', 'coal-mines-special-provisions-rules-amendments'),
  ('coal-gsr-332-2020', 'Coal', 'G.S.R. 332(E)', 2020, 'so-only', '2020-05-29', 'G.S.R. 332(E)', 'coal', 'coal-mines-special-provisions-rules-2014', 'coal-mines-special-provisions-rules-amendments'),
  ('coal-gsr-393-2023', 'Coal', 'G.S.R. 393(E)', 2023, 'so-only', '2023-05-29', 'G.S.R. 393(E)', 'coal', 'coal-mines-special-provisions-rules-2014', 'coal-mines-special-provisions-rules-amendments'),
  ('coal-gsr-101-2026', 'Coal', 'G.S.R. 101(E)', 2026, 'so-only', '2026-02-03', 'G.S.R. 101(E)', 'coal', 'coal-mines-special-provisions-rules-2014', 'coal-mines-special-provisions-rules-amendments'),
  -- MMDR Act coal-sale percentage amendment
  ('coal-so-4589-2021', 'Coal', 'S.O. 4589(E)', 2021, 'so-only', '2021-11-02', 'S.O. 4589(E)', 'coal', 'mmdr-act-1957-s8-coal-sale', 'mmdr-coal-sale-percentage-amendment'),
  ('coal-so-2626-2026', 'Coal', 'S.O. 2626(E)', 2026, 'so-only', '2026-05-22', 'S.O. 2626(E)', 'coal', 'mmdr-act-1957-s8-coal-sale', 'mmdr-coal-sale-percentage-amendment'),
  -- Adjudication of Penalties Rules: draft then final
  ('coal-gsr-450-2026', 'Coal', 'G.S.R. 450(E)', 2026, 'so-only', '2026-06-05', 'G.S.R. 450(E)', 'coal', 'coal-mines-special-provisions-penalties-rules-2026', 'coal-mines-penalties-rules-draft-final'),
  ('coal-gsr-699-2026', 'Coal', 'G.S.R. 699(E)', 2026, 'so-only', '2026-07-31', 'G.S.R. 699(E)', 'coal', 'coal-mines-special-provisions-penalties-rules-2026', 'coal-mines-penalties-rules-draft-final');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('coal-gsr-300-2020', 'coal-gsr-877-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-394-2023', 'coal-gsr-300-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-508-2026', 'coal-gsr-394-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-917-2025', 'coal-gsr-540-2004', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-710-2026', 'coal-gsr-917-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Pension Scheme full chain
  ('coal-gsr-268-pension', 'coal-gsr-123-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-218-pension', 'coal-gsr-268-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-689-pension', 'coal-gsr-218-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-256-pension', 'coal-gsr-689-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-861-pension', 'coal-gsr-256-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-16-pension',  'coal-gsr-861-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-482-pension', 'coal-gsr-16-pension',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-107-pension', 'coal-gsr-482-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-108-pension', 'coal-gsr-107-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-521-pension', 'coal-gsr-108-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-403-pension', 'coal-gsr-521-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-154-pension', 'coal-gsr-403-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-348-pension', 'coal-gsr-154-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-774-pension', 'coal-gsr-348-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-540-pension', 'coal-gsr-774-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-119-pension', 'coal-gsr-540-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-so-4336-pension', 'coal-gsr-119-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-165-2024',   'coal-so-4336-pension', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-370-2026',   'coal-gsr-165-2024',   'amends', 'research-agent-quoted', '2026-09-04'),
  -- New pairs
  ('coal-so-4392-2026', 'coal-so-1039-1999', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-323-2025', 'coal-gsr-1398-1960', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-150-2026', 'coal-gsr-323-2025',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-782-2015', 'coal-gsr-883-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-332-2020', 'coal-gsr-782-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-393-2023', 'coal-gsr-332-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-101-2026', 'coal-gsr-393-2023', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('coal-so-2626-2026', 'coal-so-4589-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-699-2026', 'coal-gsr-450-2026', 'cites',  'research-agent-quoted', '2026-09-04');
