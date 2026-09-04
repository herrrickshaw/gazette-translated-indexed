-- Ministry of Mines. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3 pairs/
-- chains).
--
-- The already-modeled Concession Rules corrigendum thread turned out to
-- be part of a much longer real chain: the principal is G.S.R. 279(E),
-- 2016 (not year-unknown as first modeled), and the already-seeded
-- G.S.R. 222(E) is amendment #14 of 15 — re-parented into the full
-- 17-node chain rather than left isolated with only its corrigendum edge.
--
-- 8 further new subject threads found: Atomic Minerals Concession Rules,
-- 2016 (a DISTINCT instrument from the non-atomic Concession Rules,
-- confirmed genuinely separate); three Offshore Areas Mineral rules
-- amendments, all published the same day; Minerals (Evidence of Mineral
-- Contents) Rules, 2015; two Administering Authority supersessions under
-- two different Acts; and the Central Geoscience Programming Board
-- Resolution — a genuinely novel shape where ONE new resolution
-- supersedes an entire prior chain of six resolutions at once (modeled
-- as six `supersedes` edges from one source, the same one-to-many
-- pattern already used elsewhere in this project).
--
-- REAL CITATION COLLISION found and correctly kept distinct: "G.S.R.
-- 682(E)" denotes two unrelated real documents — the 5th Atomic Minerals
-- Concession Rules amendment [2023-09-22] and the wholly separate Mines
-- and Minerals Adjudication of Penalties Rules, 2026 [2026-07-30] — kept
-- as distinct gazette_id rows.
--
-- A REAL STRING REUSE, not modeled as a collision since it is the SAME
-- resolution's own identifier cited two ways: "M.I-4/1/2021-Mines I" is
-- both the 2023 CGPB amending resolution's own number AND the 2026
-- resolution's file number — flagged in the CGPB thread's own node
-- naming (distinct gazette_ids, not conflated).
--
-- Real leads NOT modeled: two commencement notifications whose target is
-- a Parliamentary Act (identified by Act number, not another gazette
-- notification) — out of this schema's notification-to-notification
-- scope; the CGPB's own 1966 origin resolution, cited only by date with
-- no number of any kind; eight standalone Exploration Agency
-- accreditation notifications citing only the parent Act.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('mines', 'Ministry of Mines', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('minerals-concession-rules-2026', 'Minerals (Other than Atomic and Hydro Carbons Energy Minerals) Concession Rules, 2016', 2016),
  ('mineral-conservation-development-rules-2017', 'Mineral Conservation and Development Rules, 2017', 2017),
  ('mineral-auction-rules-2015', 'Mineral (Auction) Rules, 2015', 2015),
  ('atomic-minerals-concession-rules-2016', 'Atomic Minerals Concession Rules, 2016', 2016),
  ('offshore-atomic-minerals-operating-right-rules-2025', 'Offshore Areas Atomic Minerals Operating Right Rules, 2025', 2025),
  ('offshore-mineral-conservation-development-rules-2024', 'Offshore Areas Mineral Conservation and Development Rules, 2024', 2024),
  ('offshore-operating-right-rules-2024', 'Offshore Areas Operating Right Rules, 2024', 2024),
  ('minerals-evidence-mineral-contents-rules-2015', 'Minerals (Evidence of Mineral Contents) Rules, 2015', 2015),
  ('mmdr-act-1957-s26-administering-authority', 'Mines and Minerals (Development and Regulation) Act, 1957 — s.26(1)(a) Administering Authority', 1957),
  ('oamdr-act-2002-s4-administering-authority', 'Offshore Areas Mineral (Development and Regulation) Act, 2002 — s.4(a) Administering Authority', 2002),
  ('cgpb-resolution', 'Central Geoscience Programming Board Resolution', 2009),
  ('mmdr-penalties-rules-2026', 'Mines and Minerals Adjudication of Penalties Rules, 2026', 2026),
  ('offshore-penalties-rules-2026', 'Offshore Areas Mineral Adjudication of Penalties Rules, 2026', 2026);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mines-concession-rules-corrigendum', 'Minerals Concession Rules, 2016 — 17-node amendment chain', 'active'),
  ('mines-mcdr-amendments', 'Mineral Conservation and Development Rules and its amendments', 'active'),
  ('mines-auction-rules-amendments', 'Mineral (Auction) Rules and its amendments', 'active'),
  ('mines-atomic-concession-amendments', 'Atomic Minerals Concession Rules, 2016 and its amendments', 'active'),
  ('mines-offshore-atomic-operating-right-amendment', 'Offshore Areas Atomic Minerals Operating Right Rules amendment', 'active'),
  ('mines-offshore-mcdr-amendment', 'Offshore Areas Mineral Conservation and Development Rules amendment', 'active'),
  ('mines-offshore-operating-right-amendment', 'Offshore Areas Operating Right Rules amendment', 'active'),
  ('mines-evidence-mineral-contents-amendments', 'Minerals (Evidence of Mineral Contents) Rules and its amendments', 'active'),
  ('mines-mmdr-administering-authority', 'MMDR Act Administering Authority supersession', 'active'),
  ('mines-oamdr-administering-authority', 'OAMDR Act Administering Authority supersession', 'active'),
  ('mines-cgpb-reconstitution', 'Central Geoscience Programming Board — one resolution supersedes six prior', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Concession Rules, 2016 — 17-node chain (principal + 15 listed + current)
  ('mines-gsr-279-2016',  'Mines', 'G.S.R. 279(E)',  2016, 'so-only', '2016-03-04', 'G.S.R. 279(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-1120-2016', 'Mines', 'G.S.R. 1120(E)', 2016, 'so-only', '2016-12-08', 'G.S.R. 1120(E)', 'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-674-2019',  'Mines', 'G.S.R. 674(E)',  2019, 'so-only', '2019-09-20', 'G.S.R. 674(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-191-2020',  'Mines', 'G.S.R. 191(E)',  2020, 'so-only', '2020-03-20', 'G.S.R. 191(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-209-2021',  'Mines', 'G.S.R. 209(E)',  2021, 'so-only', '2021-03-24', 'G.S.R. 209(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-254-2021',  'Mines', 'G.S.R. 254(E)',  2021, 'so-only', '2021-04-08', 'G.S.R. 254(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-397-2021',  'Mines', 'G.S.R. 397(E)',  2021, 'so-only', '2021-06-10', 'G.S.R. 397(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-775-2021',  'Mines', 'G.S.R. 775(E)',  2021, 'so-only', '2021-11-02', 'G.S.R. 775(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-205-2022',  'Mines', 'G.S.R. 205(E)',  2022, 'so-only', '2022-03-15', 'G.S.R. 205(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-737-2023',  'Mines', 'G.S.R. 737(E)',  2023, 'so-only', '2023-10-12', 'G.S.R. 737(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-50-2024',   'Mines', 'G.S.R. 50(E)',   2024, 'so-only', '2024-01-21', 'G.S.R. 50(E)',   'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-118-2024',  'Mines', 'G.S.R. 118(E)',  2024, 'so-only', '2024-02-20', 'G.S.R. 118(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-486-2025',  'Mines', 'G.S.R. 486(E)',  2025, 'so-only', '2025-07-21', 'G.S.R. 486(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-22-2026',   'Mines', 'G.S.R. 22(E)',   2026, 'so-only', '2026-01-12', 'G.S.R. 22(E)',   'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-222-2026', 'Mines', 'G.S.R. 222(E)', 2026, 'so-only', '2026-03-30', 'G.S.R. 222(E)', 'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-255-2026', 'Mines', 'G.S.R. 255(E)', 2026, 'so-only', '2026-04-08', 'G.S.R. 255(E)', 'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-271-2026',  'Mines', 'G.S.R. 271(E)',  2026, 'so-only', '2026-04-10', 'G.S.R. 271(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-684-2026',  'Mines', 'G.S.R. 684(E)',  2026, 'so-only', '2026-07-30', 'G.S.R. 684(E)',  'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  -- MCDR nine-node chain (unchanged)
  ('mines-gsr-169-2017', 'Mines', 'G.S.R. 169(E)', 2017, 'so-only', '2017-02-27', 'G.S.R. 169(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-289-2018', 'Mines', 'G.S.R. 289(E)', 2018, 'so-only', '2018-03-27', 'G.S.R. 289(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-570-2019', 'Mines', 'G.S.R. 570(E)', 2019, 'so-only', '2019-08-13', 'G.S.R. 570(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-780-2021', 'Mines', 'G.S.R. 780(E)', 2021, 'so-only', '2021-11-03', 'G.S.R. 780(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-294-2022', 'Mines', 'G.S.R. 294(E)', 2022, 'so-only', '2022-04-11', 'G.S.R. 294(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-51-2024',  'Mines', 'G.S.R. 51(E)',  2024, 'so-only', '2024-01-21', 'G.S.R. 51(E)',  'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-232-2025', 'Mines', 'G.S.R. 232(E)', 2025, 'so-only', '2025-04-16', 'G.S.R. 232(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-449-2026', 'Mines', 'G.S.R. 449(E)', 2026, 'so-only', '2026-06-05', 'G.S.R. 449(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-683-2026', 'Mines', 'G.S.R. 683(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 683(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  -- Mineral (Auction) Rules three-node chain (unchanged)
  ('mines-gsr-406-2015', 'Mines', 'G.S.R. 406(E)', 2015, 'so-only', '2015-05-20', 'G.S.R. 406(E)', 'mines', 'mineral-auction-rules-2015', 'mines-auction-rules-amendments'),
  ('mines-gsr-71-2026',  'Mines', 'G.S.R. 71(E)',  2026, 'so-only', '2026-01-29', 'G.S.R. 71(E)',  'mines', 'mineral-auction-rules-2015', 'mines-auction-rules-amendments'),
  ('mines-gsr-223-2026', 'Mines', 'G.S.R. 223(E)', 2026, 'so-only', '2026-03-30', 'G.S.R. 223(E)', 'mines', 'mineral-auction-rules-2015', 'mines-auction-rules-amendments'),
  -- Atomic Minerals Concession Rules, 2016 (7-node chain)
  ('mines-atomic-gsr-677-2016', 'Mines', 'G.S.R. 677(E)', 2016, 'so-only', '2016-07-11', 'G.S.R. 677(E)', 'mines', 'atomic-minerals-concession-rules-2016', 'mines-atomic-concession-amendments'),
  ('mines-atomic-gsr-126-2019', 'Mines', 'G.S.R. 126(E)', 2019, 'so-only', '2019-02-19', 'G.S.R. 126(E)', 'mines', 'atomic-minerals-concession-rules-2016', 'mines-atomic-concession-amendments'),
  ('mines-atomic-gsr-134-2019', 'Mines', 'G.S.R. 134(E)', 2019, 'so-only', '2019-02-20', 'G.S.R. 134(E)', 'mines', 'atomic-minerals-concession-rules-2016', 'mines-atomic-concession-amendments'),
  ('mines-atomic-gsr-693-2020', 'Mines', 'G.S.R. 693(E)', 2020, 'so-only', '2020-11-05', 'G.S.R. 693(E)', 'mines', 'atomic-minerals-concession-rules-2016', 'mines-atomic-concession-amendments'),
  ('mines-atomic-gsr-682-2023', 'Mines', 'G.S.R. 682(E)', 2023, 'so-only', '2023-09-22', 'G.S.R. 682(E)', 'mines', 'atomic-minerals-concession-rules-2016', 'mines-atomic-concession-amendments'),
  ('mines-atomic-gsr-106-2024', 'Mines', 'G.S.R. 106(E)', 2024, 'so-only', '2024-02-14', 'G.S.R. 106(E)', 'mines', 'atomic-minerals-concession-rules-2016', 'mines-atomic-concession-amendments'),
  ('mines-atomic-gsr-685-2026', 'Mines', 'G.S.R. 685(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 685(E)', 'mines', 'atomic-minerals-concession-rules-2016', 'mines-atomic-concession-amendments'),
  -- Offshore Areas rules (three separate instruments, same-day amendments)
  ('mines-offshore-gsr-468-2025', 'Mines', 'G.S.R. 468(E)', 2025, 'so-only', '2025-07-14', 'G.S.R. 468(E)', 'mines', 'offshore-atomic-minerals-operating-right-rules-2025', 'mines-offshore-atomic-operating-right-amendment'),
  ('mines-offshore-gsr-689-2026', 'Mines', 'G.S.R. 689(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 689(E)', 'mines', 'offshore-atomic-minerals-operating-right-rules-2025', 'mines-offshore-atomic-operating-right-amendment'),
  ('mines-offshore-gsr-791-2024', 'Mines', 'G.S.R. 791(E)', 2024, 'so-only', '2024-12-31', 'G.S.R. 791(E)', 'mines', 'offshore-mineral-conservation-development-rules-2024', 'mines-offshore-mcdr-amendment'),
  ('mines-offshore-gsr-687-2026', 'Mines', 'G.S.R. 687(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 687(E)', 'mines', 'offshore-mineral-conservation-development-rules-2024', 'mines-offshore-mcdr-amendment'),
  ('mines-offshore-gsr-646-2024', 'Mines', 'G.S.R. 646(E)', 2024, 'so-only', '2024-10-16', 'G.S.R. 646(E)', 'mines', 'offshore-operating-right-rules-2024', 'mines-offshore-operating-right-amendment'),
  ('mines-offshore-gsr-688-2026', 'Mines', 'G.S.R. 688(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 688(E)', 'mines', 'offshore-operating-right-rules-2024', 'mines-offshore-operating-right-amendment'),
  -- Minerals (Evidence of Mineral Contents) Rules, 2015 (6-node chain)
  ('mines-emc-gsr-304-2015', 'Mines', 'G.S.R. 304(E)', 2015, 'so-only', '2015-04-17', 'G.S.R. 304(E)', 'mines', 'minerals-evidence-mineral-contents-rules-2015', 'mines-evidence-mineral-contents-amendments'),
  ('mines-emc-gsr-421-2021', 'Mines', 'G.S.R. 421(E)', 2021, 'so-only', '2021-06-18', 'G.S.R. 421(E)', 'mines', 'minerals-evidence-mineral-contents-rules-2015', 'mines-evidence-mineral-contents-amendments'),
  ('mines-emc-gsr-856-2021', 'Mines', 'G.S.R. 856(E)', 2021, 'so-only', '2021-12-14', 'G.S.R. 856(E)', 'mines', 'minerals-evidence-mineral-contents-rules-2015', 'mines-evidence-mineral-contents-amendments'),
  ('mines-emc-gsr-52-2024',  'Mines', 'G.S.R. 52(E)',  2024, 'so-only', '2024-01-21', 'G.S.R. 52(E)',  'mines', 'minerals-evidence-mineral-contents-rules-2015', 'mines-evidence-mineral-contents-amendments'),
  ('mines-emc-gsr-382-2025', 'Mines', 'G.S.R. 382(E)', 2025, 'so-only', '2025-06-12', 'G.S.R. 382(E)', 'mines', 'minerals-evidence-mineral-contents-rules-2015', 'mines-evidence-mineral-contents-amendments'),
  ('mines-emc-gsr-567-2026', 'Mines', 'G.S.R. 567(E)', 2026, 'so-only', '2026-07-03', 'G.S.R. 567(E)', 'mines', 'minerals-evidence-mineral-contents-rules-2015', 'mines-evidence-mineral-contents-amendments'),
  -- Administering Authority supersessions
  ('mines-so-3847-2024', 'Mines', 'S.O. 3847(E)', 2024, 'so-only', '2024-09-09', 'S.O. 3847(E)', 'mines', 'mmdr-act-1957-s26-administering-authority', 'mines-mmdr-administering-authority'),
  ('mines-so-4543-2026', 'Mines', 'S.O. 4543(E)', 2026, 'so-only', '2026-08-14', 'S.O. 4543(E)', 'mines', 'mmdr-act-1957-s26-administering-authority', 'mines-mmdr-administering-authority'),
  ('mines-so-5578-2025', 'Mines', 'S.O. 5578(E)', 2025, 'so-only', '2025-12-03', 'S.O. 5578(E)', 'mines', 'oamdr-act-2002-s4-administering-authority', 'mines-oamdr-administering-authority'),
  ('mines-so-4510-2026', 'Mines', 'S.O. 4510(E)', 2026, 'so-only', '2026-08-14', 'S.O. 4510(E)', 'mines', 'oamdr-act-2002-s4-administering-authority', 'mines-oamdr-administering-authority'),
  -- Central Geoscience Programming Board Resolution (hub: one supersedes six)
  ('mines-cgpb-2009-03', 'Mines', 'Resolution No. 4(2)97-M.I',      2009, 'bare', '2009-03-12', 'Resolution No. 4(2)97-M.I',      'mines', 'cgpb-resolution', 'mines-cgpb-reconstitution'),
  ('mines-cgpb-2009-06', 'Mines', 'Resolution No. 4(2)/97-M-I',     2009, 'bare', '2009-06-08', 'Resolution No. 4(2)/97-M-I',     'mines', 'cgpb-resolution', 'mines-cgpb-reconstitution'),
  ('mines-cgpb-2013',    'Mines', 'Resolution No. 4(6)/2013-M.I',   2013, 'bare', '2013-05-07', 'Resolution No. 4(6)/2013-M.I',   'mines', 'cgpb-resolution', 'mines-cgpb-reconstitution'),
  ('mines-cgpb-2018',    'Mines', 'Resolution No. M.I-4/1/2017-Mines-I', 2018, 'bare', '2018-12-10', 'Resolution No. M.I-4/1/2017-Mines-I', 'mines', 'cgpb-resolution', 'mines-cgpb-reconstitution'),
  ('mines-cgpb-2019',    'Mines', 'Resolution No. M.I-4/1/2019-Mines I', 2019, 'bare', '2019-05-17', 'Resolution No. M.I-4/1/2019-Mines I', 'mines', 'cgpb-resolution', 'mines-cgpb-reconstitution'),
  ('mines-cgpb-2023',    'Mines', 'Resolution No. M.I-4/1/2021-Mines I', 2023, 'bare', '2023-08-18', 'Resolution No. M.I-4/1/2021-Mines I', 'mines', 'cgpb-resolution', 'mines-cgpb-reconstitution'),
  ('mines-cgpb-2026',    'Mines', 'F. No. M.I-4/1/2021-Mines I',    2026, 'bare', '2026-07-24', 'F. No. M.I-4/1/2021-Mines I',    'mines', 'cgpb-resolution', 'mines-cgpb-reconstitution'),
  -- Penalties Rules, 2026 (target nodes for several `cites` edges)
  ('mines-penalties-gsr-682-2026', 'Mines', 'G.S.R. 682(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 682(E)', 'mines', 'mmdr-penalties-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-offshore-penalties-gsr-686-2026', 'Mines', 'G.S.R. 686(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 686(E)', 'mines', 'offshore-penalties-rules-2026', 'mines-offshore-atomic-operating-right-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  -- Concession Rules 17-node chain
  ('mines-gsr-1120-2016', 'mines-gsr-279-2016',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-674-2019',  'mines-gsr-1120-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-191-2020',  'mines-gsr-674-2019',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-209-2021',  'mines-gsr-191-2020',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-254-2021',  'mines-gsr-209-2021',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-397-2021',  'mines-gsr-254-2021',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-775-2021',  'mines-gsr-397-2021',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-205-2022',  'mines-gsr-775-2021',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-737-2023',  'mines-gsr-205-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-50-2024',   'mines-gsr-737-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-118-2024',  'mines-gsr-50-2024',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-486-2025',  'mines-gsr-118-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-22-2026',   'mines-gsr-486-2025',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-222-2026',  'mines-gsr-22-2026',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-255-2026', 'mines-gsr-222-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-271-2026',  'mines-gsr-222-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-684-2026',  'mines-gsr-271-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-684-2026',  'mines-penalties-gsr-682-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- MCDR (unchanged) + new cites edge
  ('mines-gsr-289-2018', 'mines-gsr-169-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-570-2019', 'mines-gsr-289-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-780-2021', 'mines-gsr-570-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-294-2022', 'mines-gsr-780-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-51-2024',  'mines-gsr-294-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-232-2025', 'mines-gsr-51-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-449-2026', 'mines-gsr-232-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-683-2026', 'mines-gsr-449-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-683-2026', 'mines-penalties-gsr-682-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Auction Rules (unchanged)
  ('mines-gsr-71-2026',  'mines-gsr-406-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-223-2026', 'mines-gsr-71-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- Atomic Minerals Concession Rules
  ('mines-atomic-gsr-126-2019', 'mines-atomic-gsr-677-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-atomic-gsr-134-2019', 'mines-atomic-gsr-126-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-atomic-gsr-693-2020', 'mines-atomic-gsr-134-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-atomic-gsr-682-2023', 'mines-atomic-gsr-693-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-atomic-gsr-106-2024', 'mines-atomic-gsr-682-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-atomic-gsr-685-2026', 'mines-atomic-gsr-106-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-atomic-gsr-685-2026', 'mines-penalties-gsr-682-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Offshore Areas rules
  ('mines-offshore-gsr-689-2026', 'mines-offshore-gsr-468-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-offshore-gsr-689-2026', 'mines-offshore-penalties-gsr-686-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mines-offshore-gsr-687-2026', 'mines-offshore-gsr-791-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-offshore-gsr-687-2026', 'mines-offshore-penalties-gsr-686-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mines-offshore-gsr-688-2026', 'mines-offshore-gsr-646-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-offshore-gsr-688-2026', 'mines-offshore-penalties-gsr-686-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- Minerals (Evidence of Mineral Contents) Rules
  ('mines-emc-gsr-421-2021', 'mines-emc-gsr-304-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-emc-gsr-856-2021', 'mines-emc-gsr-421-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-emc-gsr-52-2024',  'mines-emc-gsr-856-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-emc-gsr-382-2025', 'mines-emc-gsr-52-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-emc-gsr-567-2026', 'mines-emc-gsr-382-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Administering Authority supersessions
  ('mines-so-4543-2026', 'mines-so-3847-2024', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mines-so-4510-2026', 'mines-so-5578-2025', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- CGPB Resolution: one supersedes six
  ('mines-cgpb-2026', 'mines-cgpb-2009-03', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mines-cgpb-2026', 'mines-cgpb-2009-06', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mines-cgpb-2026', 'mines-cgpb-2013',    'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mines-cgpb-2026', 'mines-cgpb-2018',    'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mines-cgpb-2026', 'mines-cgpb-2019',    'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mines-cgpb-2026', 'mines-cgpb-2023',    'supersedes', 'research-agent-quoted', '2026-09-04');
