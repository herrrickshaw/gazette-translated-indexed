-- Ministry of Heavy Industries. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3 pairs).
--
-- 7 new subject threads found, plus confirmation that PM E-DRIVE (2024)
-- has a genuine substantive amendment beyond the already-modeled Hindi
-- corrigendum, and that PLI-Auto's S.O. 3946(E) is a hub independently
-- amended by three separate later notifications (S.O. 5486(E), already
-- modeled; S.O. 3862(E) and S.O. 188(E), new). Two Phased Manufacturing
-- Programme note-chains (e-Trucks, e-Buses) both explicitly reference PM
-- E-DRIVE (S.O. 4259(E)) as their parent scheme without amending it —
-- modeled as `cites`.
--
-- Real leads NOT modeled: Capital Goods Sector Phase-II Scheme and a
-- FAME-II e-2W carve-out, both citing only departmental file numbers, no
-- G.S.R./S.O.; S.O. No. 4632(E), seen cited but not independently opened;
-- an Electrical Equipment (Quality Control) Order chain and a Wheel Rim
-- QCO amendment, both real but not opened for exact quotes this pass.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('heavy-industries', 'Ministry of Heavy Industries', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('electric-mobility-promotion-scheme-2024', 'Electric Mobility Promotion Scheme, 2024', 2024),
  ('pm-edrive-scheme-2024', 'PM E-DRIVE Scheme, 2024', 2024),
  ('pli-auto-scheme-2021', 'Production Linked Incentive (PLI) Scheme for Automobile and Auto Component Industry, 2021', 2021),
  ('pli-auto-scheme-guidelines-2021', 'PLI-Auto Scheme Guidelines, 2021', 2021),
  ('pmp-etrucks-2025', 'Phased Manufacturing Programme (PMP) for e-Trucks (N2/N3), 2025', 2025),
  ('pmp-ebuses-2025', 'Phased Manufacturing Programme (PMP) for e-Buses (M2/M3), 2025', 2025),
  ('machinery-electrical-equipment-safety-order-2024', 'Machinery and Electrical Equipment Safety (Omnibus Technical Regulation) Order, 2024', 2024),
  ('rare-earth-magnet-scheme-2025', 'Scheme to Promote Manufacturing of Sintered Rare Earth Permanent Magnet', 2025),
  ('spmepci-2024', 'Scheme to Promote Manufacturing of Electric Passenger Cars in India (SPMEPCI), 2024', 2024),
  ('fame-india-phase-2-2019', 'FAME India Phase II Scheme, 2019', 2019);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('emps-2024-corrigendum', 'Electric Mobility Promotion Scheme, 2024 Hindi-text corrigendum', 'active'),
  ('pm-edrive-corrigendum', 'PM E-DRIVE Scheme Hindi-text corrigendum', 'active'),
  ('pli-auto-amendments', 'PLI-Auto Scheme — a hub with three independent amendments', 'active'),
  ('pli-auto-guidelines-amendment', 'PLI-Auto Scheme Guidelines amendment', 'active'),
  ('pmp-etrucks-amendments', 'PMP for e-Trucks note-chain', 'active'),
  ('pmp-ebuses-amendments', 'PMP for e-Buses note-chain', 'active'),
  ('machinery-electrical-safety-order-rescission', 'Machinery and Electrical Equipment Safety Order — amended then rescinded', 'superseded'),
  ('rare-earth-magnet-scheme-amendment', 'Rare Earth Permanent Magnet Scheme Technical Committee amendment', 'active'),
  ('spmepci-guidelines-reference', 'SPMEPCI Scheme and its supplementing Guidelines', 'active'),
  ('pm-edrive-substantive-amendment', 'PM E-DRIVE Scheme substantive (non-Hindi) amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mohi-so-1334-2024', 'MoHI', 'S.O. 1334(E)', 2024, 'so-only', '2024-03-13', 'S.O. 1334(E)', 'heavy-industries', 'electric-mobility-promotion-scheme-2024', 'emps-2024-corrigendum'),
  ('mohi-so-1636-2024', 'MoHI', 'S.O. 1636(E)', 2024, 'so-only', '2024-04-05', 'S.O. 1636(E)', 'heavy-industries', 'electric-mobility-promotion-scheme-2024', 'emps-2024-corrigendum'),
  ('mohi-so-4259-2024', 'MoHI', 'S.O. 4259(E)', 2024, 'so-only', '2024-09-29', 'S.O. 4259(E)', 'heavy-industries', 'pm-edrive-scheme-2024', 'pm-edrive-corrigendum'),
  ('mohi-so-4703-2024', 'MoHI', 'S.O. 4703(E)', 2024, 'so-only', '2024-10-24', 'S.O. 4703(E)', 'heavy-industries', 'pm-edrive-scheme-2024', 'pm-edrive-corrigendum'),
  ('mohi-so-3946-2021', 'MoHI', 'S.O. 3946(E)', 2021, 'so-only', '2021-09-23', 'S.O. 3946(E)', 'heavy-industries', 'pli-auto-scheme-2021', 'pli-auto-amendments'),
  ('mohi-so-5486-2023', 'MoHI', 'S.O. 5486(E)', 2023, 'so-only', '2023-12-29', 'S.O. 5486(E)', 'heavy-industries', 'pli-auto-scheme-2021', 'pli-auto-amendments'),
  ('mohi-so-3862-2024', 'MoHI', 'S.O. 3862(E)', 2024, 'so-only', '2024-09-06', 'S.O. 3862(E)', 'heavy-industries', 'pli-auto-scheme-2021', 'pli-auto-amendments'),
  ('mohi-so-188-2026',  'MoHI', 'S.O. 188(E)',  2026, 'so-only', '2026-01-13', 'S.O. 188(E)',  'heavy-industries', 'pli-auto-scheme-2021', 'pli-auto-amendments'),
  -- PLI-Auto Scheme Guidelines (sister instrument to the Scheme itself)
  ('mohi-so-3947-2021', 'MoHI', 'S.O. 3947(E)', 2021, 'so-only', '2021-09-23', 'S.O. 3947(E)', 'heavy-industries', 'pli-auto-scheme-guidelines-2021', 'pli-auto-guidelines-amendment'),
  ('mohi-so-3863-2024', 'MoHI', 'S.O. 3863(E)', 2024, 'so-only', '2024-09-06', 'S.O. 3863(E)', 'heavy-industries', 'pli-auto-scheme-guidelines-2021', 'pli-auto-guidelines-amendment'),
  -- PMP for e-Trucks note-chain
  ('mohi-so-3081-2025', 'MoHI', 'S.O. 3081(E)', 2025, 'so-only', '2025-07-10', 'S.O. 3081(E)', 'heavy-industries', 'pmp-etrucks-2025', 'pmp-etrucks-amendments'),
  ('mohi-so-4481-2025', 'MoHI', 'S.O. 4481(E)', 2025, 'so-only', '2025-09-30', 'S.O. 4481(E)', 'heavy-industries', 'pmp-etrucks-2025', 'pmp-etrucks-amendments'),
  ('mohi-so-1331-2026', 'MoHI', 'S.O. 1331(E)', 2026, 'so-only', '2026-03-13', 'S.O. 1331(E)', 'heavy-industries', 'pmp-etrucks-2025', 'pmp-etrucks-amendments'),
  ('mohi-so-2131-2026', 'MoHI', 'S.O. 2131(E)', 2026, 'so-only', '2026-04-29', 'S.O. 2131(E)', 'heavy-industries', 'pmp-etrucks-2025', 'pmp-etrucks-amendments'),
  ('mohi-so-4871-2026', 'MoHI', 'S.O. 4871(E)', 2026, 'so-only', '2026-09-03', 'S.O. 4871(E)', 'heavy-industries', 'pmp-etrucks-2025', 'pmp-etrucks-amendments'),
  -- PMP for e-Buses note-chain
  ('mohi-so-1078-2025', 'MoHI', 'S.O. 1078(E)', 2025, 'so-only', '2025-03-03', 'S.O. 1078(E)', 'heavy-industries', 'pmp-ebuses-2025', 'pmp-ebuses-amendments'),
  ('mohi-so-4480-2025', 'MoHI', 'S.O. 4480(E)', 2025, 'so-only', '2025-09-30', 'S.O. 4480(E)', 'heavy-industries', 'pmp-ebuses-2025', 'pmp-ebuses-amendments'),
  ('mohi-so-1330-2026', 'MoHI', 'S.O. 1330(E)', 2026, 'so-only', '2026-03-13', 'S.O. 1330(E)', 'heavy-industries', 'pmp-ebuses-2025', 'pmp-ebuses-amendments'),
  ('mohi-so-4884-2026', 'MoHI', 'S.O. 4884(E)', 2026, 'so-only', '2026-09-03', 'S.O. 4884(E)', 'heavy-industries', 'pmp-ebuses-2025', 'pmp-ebuses-amendments'),
  -- Machinery and Electrical Equipment Safety Order: amended twice, then rescinded
  ('mohi-so-3649-2024', 'MoHI', 'S.O. 3649(E)', 2024, 'so-only', '2024-08-28', 'S.O. 3649(E)', 'heavy-industries', 'machinery-electrical-equipment-safety-order-2024', 'machinery-electrical-safety-order-rescission'),
  ('mohi-so-2579-2025', 'MoHI', 'S.O. 2579(E)', 2025, 'so-only', '2025-06-12', 'S.O. 2579(E)', 'heavy-industries', 'machinery-electrical-equipment-safety-order-2024', 'machinery-electrical-safety-order-rescission'),
  ('mohi-so-5179-2025', 'MoHI', 'S.O. 5179(E)', 2025, 'so-only', '2025-11-13', 'S.O. 5179(E)', 'heavy-industries', 'machinery-electrical-equipment-safety-order-2024', 'machinery-electrical-safety-order-rescission'),
  ('mohi-so-239-2026',  'MoHI', 'S.O. 239(E)',  2026, 'so-only', '2026-01-14', 'S.O. 239(E)',  'heavy-industries', 'machinery-electrical-equipment-safety-order-2024', 'machinery-electrical-safety-order-rescission'),
  -- Rare Earth Permanent Magnet Scheme
  ('mohi-so-5800-2025', 'MoHI', 'S.O. 5800(E)', 2025, 'so-only', '2025-12-15', 'S.O. 5800(E)', 'heavy-industries', 'rare-earth-magnet-scheme-2025', 'rare-earth-magnet-scheme-amendment'),
  ('mohi-so-4826-2026', 'MoHI', 'S.O. 4826(E)', 2026, 'so-only', '2026-08-21', 'S.O. 4826(E)', 'heavy-industries', 'rare-earth-magnet-scheme-2025', 'rare-earth-magnet-scheme-amendment'),
  -- SPMEPCI + supplementing Guidelines
  ('mohi-so-1363-2024', 'MoHI', 'S.O. 1363(E)', 2024, 'so-only', '2024-03-15', 'S.O. 1363(E)', 'heavy-industries', 'spmepci-2024', 'spmepci-guidelines-reference'),
  ('mohi-so-2450-2025', 'MoHI', 'S.O. 2450(E)', 2025, 'so-only', '2025-06-02', 'S.O. 2450(E)', 'heavy-industries', 'spmepci-2024', 'spmepci-guidelines-reference'),
  -- FAME India Phase II (cited by S.O. 188(E) with its own real number)
  ('mohi-so-1472-2019', 'MoHI', 'S.O. 1472(E)', 2019, 'so-only', '2019-03-28', 'S.O. 1472(E)', 'heavy-industries', 'fame-india-phase-2-2019', 'pli-auto-amendments'),
  -- PM E-DRIVE substantive amendment
  ('mohi-so-1617-2026', 'MoHI', 'S.O. 1617(E)', 2026, 'so-only', '2026-03-27', 'S.O. 1617(E)', 'heavy-industries', 'pm-edrive-scheme-2024', 'pm-edrive-substantive-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mohi-so-1636-2024', 'mohi-so-1334-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-4703-2024', 'mohi-so-4259-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-5486-2023', 'mohi-so-3946-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-3862-2024', 'mohi-so-3946-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-188-2026',  'mohi-so-3946-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-188-2026',  'mohi-so-4259-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-188-2026',  'mohi-so-3081-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-188-2026',  'mohi-so-1472-2019', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-3863-2024', 'mohi-so-3947-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-3081-2025', 'mohi-so-4259-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-4481-2025', 'mohi-so-3081-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-1331-2026', 'mohi-so-4481-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-2131-2026', 'mohi-so-1331-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-4871-2026', 'mohi-so-2131-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-1078-2025', 'mohi-so-4259-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-4480-2025', 'mohi-so-1078-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-1330-2026', 'mohi-so-4480-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-4884-2026', 'mohi-so-1330-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-2579-2025', 'mohi-so-3649-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-5179-2025', 'mohi-so-2579-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-239-2026',  'mohi-so-3649-2024', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-4826-2026', 'mohi-so-5800-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-2450-2025', 'mohi-so-1363-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-1617-2026', 'mohi-so-4259-2024', 'amends', 'research-agent-quoted', '2026-09-04');
