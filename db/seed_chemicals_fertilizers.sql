-- Ministry of Chemicals and Fertilizers. Deepened 2026-09-04 (depth pass
-- — see docs/DEPTH_PASS_PLAN.md) beyond the original 3-corrigendum pass.
--
-- Extended chains for the three already-known NPPA orders (each now has
-- 2-3 further "is henceforth to be read with the following additions"
-- addenda beyond the original corrigendum), a new original NPPA order
-- (S.O. 1586(E)), three further single-hop NPPA corrigenda, a wholly new
-- subject area (Department of Chemicals and Petrochemicals Quality
-- Control Order rescissions/suspensions — six real rescissions in one
-- gazette, three suspension-extension chains), and the Drugs (Prices
-- Control) Order, 2013 principal instrument's own 14-node amendment
-- lineage.
--
-- extract/chemicals_fertilizers_patterns.py extended: the QCO rescissions
-- use a real shape ("hereby rescinds ... Ministry of Chemicals and
-- Fertilizers number X ... with immediate effect") the NPPA-only anchor
-- never covered — fixed by adding the existing corrigendum-substitution
-- template to the same module.
--
-- One real source-text oddity, kept as printed rather than resolved: the
-- n-Butyl Acrylate QCO's own Note cites "S.O. 2729(E)" twice, once dated
-- 13 June 2022 and once dated 2023 — the research agent flagged this as
-- likely a typo in the government's own document. Only the first,
-- unambiguous occurrence (2022-06-13) is modeled; the second mention is
-- real but not turned into a conflicting or duplicate row.
--
-- The Drugs (Prices Control) Order, 2013 chain's 12 intermediate
-- amendments are sourced entirely from one citing document's own Note
-- (not independently opened one by one) — the same evidentiary standard
-- already used throughout this project for every other long Note-quoted
-- chain.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('chemicals-and-fertilizers', 'Ministry of Chemicals and Fertilizers', 'Department of Pharmaceuticals (National Pharmaceutical Pricing Authority); Department of Chemicals and Petrochemicals');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('nppa-ringer-lactate-ceiling-price', 'NPPA ceiling-price fixation, Ringer Lactate', NULL),
  ('nppa-retail-price-order-575-2021', 'NPPA retail-price fixation order (S.O. 575(E), 2021)', 2021),
  ('nppa-retail-price-order-5635-2018', 'NPPA retail-price fixation order (S.O. 5635(E), 2018)', 2018),
  ('nppa-iv-fluids-ceiling-price-1583', 'NPPA ceiling-price fixation, I.V. fluids non-Glass (S.O. 1583(E))', NULL),
  ('nppa-iv-fluids-ceiling-price-1586', 'NPPA ceiling-price fixation, other I.V. fluids non-Glass (S.O. 1586(E))', NULL),
  ('nppa-retail-price-order-4062-2019', 'NPPA retail-price fixation order (S.O. 4062(E), 2019)', 2019),
  ('nppa-ceiling-price-review-659-2025', 'NPPA ceiling-price review order (S.O. 659(E), 2025)', 2025),
  ('nppa-synchrobreathe-price-5496-2024', 'NPPA separate-price fixation, Synchrobreathe Inhaler Device (S.O. 5496(E), 2024)', 2024),
  ('nbutyl-acrylate-qco-2021', 'n-Butyl Acrylate (Quality Control) Order, 2021', 2021),
  ('linear-alkyl-benzene-qco-2022', 'Linear Alkyl Benzene (Quality Control) Order, 2022', 2022),
  ('morpholine-qco-2020', 'Morpholine (Quality Control) Order, 2020', 2020),
  ('p-xylene-qco-2021', 'p-Xylene (Quality Control) Order, 2021', 2021),
  ('toluene-qco-2021', 'Toluene (Quality Control) Order, 2021', 2021),
  ('methyl-ethyl-acrylate-qco-2021', 'Methyl Acrylate/Ethyl Acrylate (Quality Control) Order, 2021', 2021),
  ('vinyl-acetate-monomer-qco-2021', 'Vinyl Acetate Monomer (Quality Control) Order, 2021', 2021),
  ('ethylene-dichloride-qco-2021', 'Ethylene Dichloride (Quality Control) Order, 2021', 2021),
  ('vinyl-chloride-monomer-qco-2020', 'Vinyl Chloride Monomer (Quality Control) Order, 2020', 2020),
  ('drugs-prices-control-order-2013', 'Drugs (Prices Control) Order, 2013', 2013);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('nppa-ringer-lactate-corrigendum', 'NPPA Ringer Lactate ceiling-price corrigendum and further addenda', 'active'),
  ('nppa-retail-price-corrigendum-2021', 'NPPA retail-price corrigendum (2021 order)', 'active'),
  ('nppa-retail-price-corrigendum-2018', 'NPPA retail-price corrigendum (2018 order)', 'active'),
  ('nppa-iv-fluids-1583-addenda', 'NPPA I.V. fluids ceiling-price order and its addenda', 'active'),
  ('nppa-iv-fluids-1586-addenda', 'NPPA other I.V. fluids ceiling-price order and its addendum', 'active'),
  ('nppa-4062-corrigendum', 'NPPA retail-price corrigendum (2019 order)', 'active'),
  ('nppa-659-corrigendum', 'NPPA ceiling-price review corrigendum (2025)', 'active'),
  ('nppa-5496-corrigendum', 'NPPA Synchrobreathe device price corrigendum', 'active'),
  ('nbutyl-acrylate-qco-amendments', 'n-Butyl Acrylate QCO and its suspension-extension chain', 'active'),
  ('linear-alkyl-benzene-qco-amendments', 'Linear Alkyl Benzene QCO and its suspension-extension chain', 'active'),
  ('morpholine-qco-amendments', 'Morpholine QCO and its amendments', 'active'),
  ('qco-rescissions-2025', 'Six Quality Control Order rescissions (2025-11-28 gazette)', 'superseded'),
  ('dpco-2013-amendments', 'Drugs (Prices Control) Order, 2013 and its 13-item amendment lineage', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Ringer Lactate: original corrigendum + two further addenda
  ('mocf-so-1584-2026', 'NPPA', 'S.O. 1584(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1584(E)', 'chemicals-and-fertilizers', 'nppa-ringer-lactate-ceiling-price', 'nppa-ringer-lactate-corrigendum'),
  ('mocf-so-2682-2026', 'NPPA', 'S.O. 2682(E)', 2026, 'so-only', '2026-05-27', 'S.O. 2682(E)', 'chemicals-and-fertilizers', 'nppa-ringer-lactate-ceiling-price', 'nppa-ringer-lactate-corrigendum'),
  ('mocf-so-3714-2026', 'NPPA', 'S.O. 3714(E)', 2026, 'so-only', '2026-07-08', 'S.O. 3714(E)', 'chemicals-and-fertilizers', 'nppa-ringer-lactate-ceiling-price', 'nppa-ringer-lactate-corrigendum'),
  ('mocf-so-4776-2026', 'NPPA', 'S.O. 4776(E)', 2026, 'so-only', '2026-08-27', 'S.O. 4776(E)', 'chemicals-and-fertilizers', 'nppa-ringer-lactate-ceiling-price', 'nppa-ringer-lactate-corrigendum'),
  -- Retail-price corrigenda (unchanged)
  ('mocf-so-575-2021',  'NPPA', 'S.O. 575(E)',  2021, 'so-only', '2021-02-09', 'S.O. 575(E)',  'chemicals-and-fertilizers', 'nppa-retail-price-order-575-2021', 'nppa-retail-price-corrigendum-2021'),
  ('mocf-so-1591-2026', 'NPPA', 'S.O. 1591(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1591(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-575-2021', 'nppa-retail-price-corrigendum-2021'),
  ('mocf-so-5635-2018', 'NPPA', 'S.O. 5635(E)', 2018, 'so-only', '2018-11-02', 'S.O. 5635(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-5635-2018', 'nppa-retail-price-corrigendum-2018'),
  ('mocf-so-1592-2026', 'NPPA', 'S.O. 1592(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1592(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-5635-2018', 'nppa-retail-price-corrigendum-2018'),
  -- I.V. fluids S.O. 1583(E) chain
  ('mocf-so-1583-2026', 'NPPA', 'S.O. 1583(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1583(E)', 'chemicals-and-fertilizers', 'nppa-iv-fluids-ceiling-price-1583', 'nppa-iv-fluids-1583-addenda'),
  ('mocf-so-2168-2026', 'NPPA', 'S.O. 2168(E)', 2026, 'so-only', '2026-04-30', 'S.O. 2168(E)', 'chemicals-and-fertilizers', 'nppa-iv-fluids-ceiling-price-1583', 'nppa-iv-fluids-1583-addenda'),
  ('mocf-so-3713-2026', 'NPPA', 'S.O. 3713(E)', 2026, 'so-only', '2026-07-08', 'S.O. 3713(E)', 'chemicals-and-fertilizers', 'nppa-iv-fluids-ceiling-price-1583', 'nppa-iv-fluids-1583-addenda'),
  ('mocf-so-4778-2026', 'NPPA', 'S.O. 4778(E)', 2026, 'so-only', '2026-08-27', 'S.O. 4778(E)', 'chemicals-and-fertilizers', 'nppa-iv-fluids-ceiling-price-1583', 'nppa-iv-fluids-1583-addenda'),
  -- I.V. fluids S.O. 1586(E) — distinct original + one addendum
  ('mocf-so-1586-2026', 'NPPA', 'S.O. 1586(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1586(E)', 'chemicals-and-fertilizers', 'nppa-iv-fluids-ceiling-price-1586', 'nppa-iv-fluids-1586-addenda'),
  ('mocf-so-4777-2026', 'NPPA', 'S.O. 4777(E)', 2026, 'so-only', '2026-08-27', 'S.O. 4777(E)', 'chemicals-and-fertilizers', 'nppa-iv-fluids-ceiling-price-1586', 'nppa-iv-fluids-1586-addenda'),
  -- Three further single-hop NPPA corrigenda
  ('mocf-so-4062-2019', 'NPPA', 'S.O. 4062(E)', 2019, 'so-only', '2019-11-08', 'S.O. 4062(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-4062-2019', 'nppa-4062-corrigendum'),
  ('mocf-so-2470-2025', 'NPPA', 'S.O. 2470(E)', 2025, 'so-only', '2025-06-03', 'S.O. 2470(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-4062-2019', 'nppa-4062-corrigendum'),
  ('mocf-so-659-2025',  'NPPA', 'S.O. 659(E)',  2025, 'so-only', '2025-02-07', 'S.O. 659(E)',  'chemicals-and-fertilizers', 'nppa-ceiling-price-review-659-2025', 'nppa-659-corrigendum'),
  ('mocf-so-910-2025',  'NPPA', 'S.O. 910(E)',  2025, 'so-only', '2025-02-20', 'S.O. 910(E)',  'chemicals-and-fertilizers', 'nppa-ceiling-price-review-659-2025', 'nppa-659-corrigendum'),
  ('mocf-so-5496-2024', 'NPPA', 'S.O. 5496(E)', 2024, 'so-only', '2024-12-19', 'S.O. 5496(E)', 'chemicals-and-fertilizers', 'nppa-synchrobreathe-price-5496-2024', 'nppa-5496-corrigendum'),
  ('mocf-so-662-2025',  'NPPA', 'S.O. 662(E)',  2025, 'so-only', '2025-02-07', 'S.O. 662(E)',  'chemicals-and-fertilizers', 'nppa-synchrobreathe-price-5496-2024', 'nppa-5496-corrigendum'),
  -- n-Butyl Acrylate QCO chain (S.O. 2729(E)'s second, 2023-dated Note
  -- mention is a real source-text oddity, not modeled as a separate row)
  ('mocf-so-5438-2021', 'DCPC', 'S.O. 5438(E)', 2021, 'so-only', '2021-12-24', 'S.O. 5438(E)', 'chemicals-and-fertilizers', 'nbutyl-acrylate-qco-2021', 'nbutyl-acrylate-qco-amendments'),
  ('mocf-so-2729-2022', 'DCPC', 'S.O. 2729(E)', 2022, 'so-only', '2022-06-13', 'S.O. 2729(E)', 'chemicals-and-fertilizers', 'nbutyl-acrylate-qco-2021', 'nbutyl-acrylate-qco-amendments'),
  ('mocf-so-5992-2022', 'DCPC', 'S.O. 5992(E)', 2022, 'so-only', '2022-12-21', 'S.O. 5992(E)', 'chemicals-and-fertilizers', 'nbutyl-acrylate-qco-2021', 'nbutyl-acrylate-qco-amendments'),
  ('mocf-so-1854-2026', 'DCPC', 'S.O. 1854(E)', 2026, 'so-only', '2026-04-10', 'S.O. 1854(E)', 'chemicals-and-fertilizers', 'nbutyl-acrylate-qco-2021', 'nbutyl-acrylate-qco-amendments'),
  ('mocf-so-3729-2026', 'DCPC', 'S.O. 3729(E)', 2026, 'so-only', '2026-07-09', 'S.O. 3729(E)', 'chemicals-and-fertilizers', 'nbutyl-acrylate-qco-2021', 'nbutyl-acrylate-qco-amendments'),
  -- Linear Alkyl Benzene QCO chain
  ('mocf-so-1648-2022', 'DCPC', 'S.O. 1648(E)', 2022, 'so-only', '2022-04-05', 'S.O. 1648(E)', 'chemicals-and-fertilizers', 'linear-alkyl-benzene-qco-2022', 'linear-alkyl-benzene-qco-amendments'),
  ('mocf-so-4602-2022', 'DCPC', 'S.O. 4602(E)', 2022, 'so-only', '2022-09-29', 'S.O. 4602(E)', 'chemicals-and-fertilizers', 'linear-alkyl-benzene-qco-2022', 'linear-alkyl-benzene-qco-amendments'),
  ('mocf-so-1655-2026', 'DCPC', 'S.O. 1655(E)', 2026, 'so-only', '2026-03-30', 'S.O. 1655(E)', 'chemicals-and-fertilizers', 'linear-alkyl-benzene-qco-2022', 'linear-alkyl-benzene-qco-amendments'),
  ('mocf-so-3456-2026', 'DCPC', 'S.O. 3456(E)', 2026, 'so-only', '2026-06-25', 'S.O. 3456(E)', 'chemicals-and-fertilizers', 'linear-alkyl-benzene-qco-2022', 'linear-alkyl-benzene-qco-amendments'),
  -- Morpholine QCO chain
  ('mocf-so-1893-2020', 'DCPC', 'S.O. 1893(E)', 2020, 'so-only', '2020-06-16', 'S.O. 1893(E)', 'chemicals-and-fertilizers', 'morpholine-qco-2020', 'morpholine-qco-amendments'),
  ('mocf-so-4772-2024', 'DCPC', 'S.O. 4772(E)', 2024, 'so-only', '2024-10-30', 'S.O. 4772(E)', 'chemicals-and-fertilizers', 'morpholine-qco-2020', 'morpholine-qco-amendments'),
  ('mocf-so-1722-2026', 'DCPC', 'S.O. 1722(E)', 2026, 'so-only', '2026-04-02', 'S.O. 1722(E)', 'chemicals-and-fertilizers', 'morpholine-qco-2020', 'morpholine-qco-amendments'),
  -- Six QCO rescissions (one gazette, 2025-11-28)
  ('mocf-so-3929-2021', 'DCPC', 'S.O. 3929(E)', 2021, 'so-only', '2021-09-13', 'S.O. 3929(E)', 'chemicals-and-fertilizers', 'p-xylene-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5527-2025', 'DCPC', 'S.O. 5527(E)', 2025, 'so-only', '2025-11-28', 'S.O. 5527(E)', 'chemicals-and-fertilizers', 'p-xylene-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5436-2021', 'DCPC', 'S.O. 5436(E)', 2021, 'so-only', '2021-12-24', 'S.O. 5436(E)', 'chemicals-and-fertilizers', 'toluene-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5528-2025', 'DCPC', 'S.O. 5528(E)', 2025, 'so-only', '2025-11-28', 'S.O. 5528(E)', 'chemicals-and-fertilizers', 'toluene-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5406-2021', 'DCPC', 'S.O. 5406(E)', 2021, 'so-only', '2021-12-22', 'S.O. 5406(E)', 'chemicals-and-fertilizers', 'methyl-ethyl-acrylate-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5529-2025', 'DCPC', 'S.O. 5529(E)', 2025, 'so-only', '2025-11-28', 'S.O. 5529(E)', 'chemicals-and-fertilizers', 'methyl-ethyl-acrylate-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5405-2021', 'DCPC', 'S.O. 5405(E)', 2021, 'so-only', '2021-12-22', 'S.O. 5405(E)', 'chemicals-and-fertilizers', 'vinyl-acetate-monomer-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5530-2025', 'DCPC', 'S.O. 5530(E)', 2025, 'so-only', '2025-11-28', 'S.O. 5530(E)', 'chemicals-and-fertilizers', 'vinyl-acetate-monomer-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-3928-2021', 'DCPC', 'S.O. 3928(E)', 2021, 'so-only', '2021-09-13', 'S.O. 3928(E)', 'chemicals-and-fertilizers', 'ethylene-dichloride-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-5531-2025', 'DCPC', 'S.O. 5531(E)', 2025, 'so-only', '2025-11-28', 'S.O. 5531(E)', 'chemicals-and-fertilizers', 'ethylene-dichloride-qco-2021', 'qco-rescissions-2025'),
  ('mocf-so-3932-2021', 'DCPC', 'S.O. 3932(E)', 2021, 'so-only', '2021-09-13', 'S.O. 3932(E)', 'chemicals-and-fertilizers', 'vinyl-chloride-monomer-qco-2020', 'qco-rescissions-2025'),
  ('mocf-so-5532-2025', 'DCPC', 'S.O. 5532(E)', 2025, 'so-only', '2025-11-28', 'S.O. 5532(E)', 'chemicals-and-fertilizers', 'vinyl-chloride-monomer-qco-2020', 'qco-rescissions-2025'),
  -- DPCO 2013 — 14-node chain (principal + 12 listed + current)
  ('mocf-so-1221-2013', 'DoP', 'S.O. 1221(E)', 2013, 'so-only', '2013-05-15', 'S.O. 1221(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-686-2015',  'DoP', 'S.O. 686(E)',  2015, 'so-only', '2015-03-09', 'S.O. 686(E)',  'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-1233-2015', 'DoP', 'S.O. 1233(E)', 2015, 'so-only', '2015-05-08', 'S.O. 1233(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-701-2016',  'DoP', 'S.O. 701(E)',  2016, 'so-only', '2016-03-10', 'S.O. 701(E)',  'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-1192-2016', 'DoP', 'S.O. 1192(E)', 2016, 'so-only', '2016-03-22', 'S.O. 1192(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-4100-2016', 'DoP', 'S.O. 4100(E)', 2016, 'so-only', '2016-12-21', 'S.O. 4100(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-39-2019',   'DoP', 'S.O. 39(E)',   2019, 'so-only', '2019-01-03', 'S.O. 39(E)',   'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-508-2021',  'DoP', 'S.O. 508(E)',  2021, 'so-only', '2021-02-01', 'S.O. 508(E)',  'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-2899-2021', 'DoP', 'S.O. 2899(E)', 2021, 'so-only', '2021-07-20', 'S.O. 2899(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-3249-2021', 'DoP', 'S.O. 3249(E)', 2021, 'so-only', '2021-08-12', 'S.O. 3249(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-5249-2022', 'DoP', 'S.O. 5249(E)', 2022, 'so-only', '2022-11-11', 'S.O. 5249(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-2165-2023', 'DoP', 'S.O. 2165(E)', 2023, 'so-only', '2023-05-11', 'S.O. 2165(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-2324-2023', 'DoP', 'S.O. 2324(E)', 2023, 'so-only', '2023-05-25', 'S.O. 2324(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments'),
  ('mocf-so-3516-2026', 'DoP', 'S.O. 3516(E)', 2026, 'so-only', '2026-06-30', 'S.O. 3516(E)', 'chemicals-and-fertilizers', 'drugs-prices-control-order-2013', 'dpco-2013-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mocf-so-2682-2026', 'mocf-so-1584-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-3714-2026', 'mocf-so-1584-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4776-2026', 'mocf-so-1584-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4776-2026', 'mocf-so-2682-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4776-2026', 'mocf-so-3714-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1591-2026', 'mocf-so-575-2021',  'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1592-2026', 'mocf-so-5635-2018', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-2168-2026', 'mocf-so-1583-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-3713-2026', 'mocf-so-1583-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-3713-2026', 'mocf-so-2168-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4778-2026', 'mocf-so-1583-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4778-2026', 'mocf-so-2168-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4778-2026', 'mocf-so-3713-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4777-2026', 'mocf-so-1586-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-2470-2025', 'mocf-so-4062-2019', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-910-2025',  'mocf-so-659-2025',  'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-662-2025',  'mocf-so-5496-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- n-Butyl Acrylate QCO
  ('mocf-so-2729-2022', 'mocf-so-5438-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-5992-2022', 'mocf-so-2729-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1854-2026', 'mocf-so-5992-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-3729-2026', 'mocf-so-1854-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Linear Alkyl Benzene QCO
  ('mocf-so-4602-2022', 'mocf-so-1648-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1655-2026', 'mocf-so-4602-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-3456-2026', 'mocf-so-1655-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Morpholine QCO
  ('mocf-so-4772-2024', 'mocf-so-1893-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1722-2026', 'mocf-so-4772-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- QCO rescissions
  ('mocf-so-5527-2025', 'mocf-so-3929-2021', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-5528-2025', 'mocf-so-5436-2021', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-5529-2025', 'mocf-so-5406-2021', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-5530-2025', 'mocf-so-5405-2021', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-5531-2025', 'mocf-so-3928-2021', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-5532-2025', 'mocf-so-3932-2021', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  -- DPCO 2013 chain
  ('mocf-so-686-2015',  'mocf-so-1221-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1233-2015', 'mocf-so-686-2015',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-701-2016',  'mocf-so-1233-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1192-2016', 'mocf-so-701-2016',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-4100-2016', 'mocf-so-1192-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-39-2019',   'mocf-so-4100-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-508-2021',  'mocf-so-39-2019',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-2899-2021', 'mocf-so-508-2021',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-3249-2021', 'mocf-so-2899-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-5249-2022', 'mocf-so-3249-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-2165-2023', 'mocf-so-5249-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-2324-2023', 'mocf-so-2165-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-3516-2026', 'mocf-so-2324-2023', 'amends', 'research-agent-quoted', '2026-09-04');
