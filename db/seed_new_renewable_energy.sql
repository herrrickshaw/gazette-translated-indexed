-- Ministry of New and Renewable Energy. Deepened 2026-09-04 (depth pass —
-- see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (1 chain).
-- gazettetracker.com's entire indexed MNRE corpus is 13 notifications (its
-- own "Page 1 of 1" meta line confirms this is not a truncated view).
--
-- This pass resolved the documented gap: the 2017 Compulsory Registration
-- Order's own citation number (S.O. 2920(E)) is never given in the text
-- the first pass saw, but IS given directly in three other real documents
-- opened this pass — a parallel, lower-capacity-threshold self-
-- certification chain (>100kW SPV inverters) running alongside the
-- already-modeled >200kW chain under the newer 2025 order. Both chains
-- share the same underlying "Solar Photovoltaics ... Order, 2017" root,
-- but the >100kW chain was never superseded/acknowledged by the 2025
-- order's own text (a real structural quirk: two parallel citation
-- lineages for the same product items coexist post-2025, noted rather
-- than resolved).
--
-- Five real examples of the narrative-prose extension shape ("...was
-- extended up to DATE1 ... vide S.O. X ... stands extended till
-- DATE2...") now exist across this ministry's material (the original
-- 3-node chain plus 4 more nodes here) — per this project's own rule
-- (generalize only after a second real example), this is now enough to
-- justify a shared extractor template; not implemented this batch since
-- seed-only modeling sufficed, flagged for a future extractor pass.
--
-- Real leads NOT modeled: a standalone Solar Thermal Systems (Quality
-- Control) Order, 2024 (S.O. 4485(E)) with no citation language of any
-- kind — a first-instance order, not a pair; six Aadhaar/DBT-mandate
-- notifications, each a first-instance boilerplate scheme notification
-- with no cross-reference to any other gazette. Several subject areas
-- (Green Hydrogen Mission, RPO, offshore wind, IREDA/SECI/NISE
-- Recruitment Rules) returned no results on this source at all — flagged
-- as unindexed-here, not confirmed absent.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('new-and-renewable-energy', 'Ministry of New and Renewable Energy', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('solar-systems-goods-order-2025', 'Solar Systems, Devices and Components Goods Order, 2025', 2025),
  ('solar-pv-compulsory-registration-order-2017', 'Solar Photovoltaics, Systems, Devices and Components Goods (Requirements for Compulsory Registration) Order, 2017', 2017);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('solar-goods-order-self-certification-deadline', 'Solar Systems Goods Order self-certification deadline extensions (>200kW lineage)', 'active'),
  ('spv-inverter-100kw-self-certification', 'SPV inverter (>100kW) self-certification deadline extensions under the 2017 Order', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mnre-so-492-2025',  'MNRE', 'S.O. 492(E)',  2025, 'so-only', '2025-01-27', 'S.O. 492(E)',  'new-and-renewable-energy', 'solar-systems-goods-order-2025', 'solar-goods-order-self-certification-deadline'),
  ('mnre-so-3597-2025', 'MNRE', 'S.O. 3597(E)', 2025, 'so-only', '2025-08-05', 'S.O. 3597(E)', 'new-and-renewable-energy', 'solar-systems-goods-order-2025', 'solar-goods-order-self-certification-deadline'),
  ('mnre-so-3706-2026', 'MNRE', 'S.O. 3706(E)', 2026, 'so-only', '2026-07-03', 'S.O. 3706(E)', 'new-and-renewable-energy', 'solar-systems-goods-order-2025', 'solar-goods-order-self-certification-deadline'),
  -- SPV inverter (>100kW) self-certification chain (2017 Order lineage)
  ('mnre-so-2920-2017', 'MNRE', 'S.O. 2920(E)', 2017, 'so-only', '2017-09-05', 'S.O. 2920(E)', 'new-and-renewable-energy', 'solar-pv-compulsory-registration-order-2017', 'spv-inverter-100kw-self-certification'),
  ('mnre-so-5259-2018', 'MNRE', 'S.O. 5259(E)', 2018, 'so-only', '2018-10-12', 'S.O. 5259(E)', 'new-and-renewable-energy', 'solar-pv-compulsory-registration-order-2017', 'spv-inverter-100kw-self-certification'),
  ('mnre-so-444-2023',  'MNRE', 'S.O. 444(E)',  2023, 'so-only', '2023-01-30', 'S.O. 444(E)',  'new-and-renewable-energy', 'solar-pv-compulsory-registration-order-2017', 'spv-inverter-100kw-self-certification'),
  ('mnre-so-3386-2023', 'MNRE', 'S.O. 3386(E)', 2023, 'so-only', '2023-07-27', 'S.O. 3386(E)', 'new-and-renewable-energy', 'solar-pv-compulsory-registration-order-2017', 'spv-inverter-100kw-self-certification'),
  ('mnre-so-5475-2023', 'MNRE', 'S.O. 5475(E)', 2023, 'so-only', '2023-12-27', 'S.O. 5475(E)', 'new-and-renewable-energy', 'solar-pv-compulsory-registration-order-2017', 'spv-inverter-100kw-self-certification'),
  ('mnre-so-526-2025',  'MNRE', 'S.O. 526(E)',  2025, 'so-only', '2025-01-27', 'S.O. 526(E)',  'new-and-renewable-energy', 'solar-pv-compulsory-registration-order-2017', 'spv-inverter-100kw-self-certification');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mnre-so-3597-2025', 'mnre-so-492-2025',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mnre-so-3706-2026', 'mnre-so-3597-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- SPV inverter >100kW chain
  ('mnre-so-3386-2023', 'mnre-so-2920-2017', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mnre-so-3386-2023', 'mnre-so-5259-2018', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mnre-so-3386-2023', 'mnre-so-444-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mnre-so-5475-2023', 'mnre-so-3386-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mnre-so-5475-2023', 'mnre-so-2920-2017', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mnre-so-5475-2023', 'mnre-so-5259-2018', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mnre-so-526-2025',  'mnre-so-5475-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mnre-so-526-2025',  'mnre-so-2920-2017', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('mnre-so-526-2025',  'mnre-so-5259-2018', 'cites',  'research-agent-quoted', '2026-09-04');
