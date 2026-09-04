-- Ministry of Agriculture and Farmers Welfare. Deepened 2026-09-04 (depth
-- pass — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass.
--
-- The S.O. 1589(E) chain's 8-item gap (items 2-10, previously
-- undocumented) is now fully closed: a research agent found the
-- notification quoting the COMPLETE numbered list of all 11 prior
-- amendments, not just the endpoint. Full 13-node chain now modeled.
--
-- Also closed: extract/agriculture_patterns.py only tried the amendment-
-- in-notification template, missing a real corrigendum shape ("for X read
-- Y" with no "makes the following amendment" verb at all) — fixed by
-- adding the corrigendum-substitution template to the same module.
--
-- Six further real pairs/chains found across subject areas not touched in
-- the first pass: a second, separate Plant Varieties Act chain (S.O.
-- 1536(E), distinct from S.O. 1589(E)), Coconut Development Board Act
-- membership, an Insecticides Act supersession, a Public Premises Act
-- amendment, and a Cotton Seeds Price Order that merely CITES (adopts by
-- reference, not amends) the prior year's price notification — modeled
-- with relation_type='cites' rather than 'amends' since the real text
-- doesn't change anything about the target, it just carries its figure
-- forward for a new year.
--
-- One further real lead (a Fertiliser Control Order biostimulant-entry
-- amendment, G.S.R. 758(E)) is explicitly NOT modeled: the research agent
-- could not independently confirm its target citation in the primary Full
-- Text (only the site's AI-generated summary named it), and flagged it as
-- needing re-verification rather than treating the summary as a source —
-- the same discipline this project has applied to every AI-summary-only
-- citation from the start.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('agriculture-and-farmers-welfare', 'Ministry of Agriculture and Farmers Welfare', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('fertiliser-control-order-1985', 'Fertiliser (Inorganic, Organic or Mixed) (Control) Order, 1985', 1985),
  ('protection-plant-varieties-act-2001', 'Protection of Plant Varieties and Farmers'' Rights Act, 2001 (S.O. 1589(E) committee)', 2001),
  ('plant-varieties-registered-list', 'Protection of Plant Varieties and Farmers'' Rights Act, 2001 (S.O. 1536(E) registered-variety list)', 2001),
  ('coconut-development-board-act-1979', 'Coconut Development Board Act, 1979 — Board membership', 1979),
  ('insecticides-act-1968-inspectors', 'Insecticides Act, 1968 — Insecticide Inspector appointments', 1968),
  ('public-premises-act-1971-estate-officer', 'Public Premises (Eviction of Unauthorised Occupants) Act, 1971 — Estate Officer appointment', 1971),
  ('cotton-seeds-price-control-order-2015', 'Cotton Seeds Price (Control) Order, 2015 — annual Bt cotton seed price', 2015);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('agriculture-fertiliser-amendments', 'Fertiliser (Control) Order notification amendments', 'active'),
  ('agriculture-fertiliser-corrigendum', 'Fertiliser Control Order-adjacent corrigendum (National Institute of Occupational Health)', 'active'),
  ('agriculture-plant-varieties-committee', 'Protection of Plant Varieties Act committee notification (S.O. 1589(E)) and its 11-item amendment history', 'active'),
  ('agriculture-plant-varieties-registered-list', 'Protection of Plant Varieties Act registered-variety list (S.O. 1536(E)) and its amendments', 'active'),
  ('agriculture-coconut-board-membership', 'Coconut Development Board membership and its amendments', 'active'),
  ('agriculture-insecticide-inspectors', 'Insecticide Inspector appointments supersession', 'superseded'),
  ('agriculture-public-premises-estate-officer', 'Public Premises Act Estate Officer appointment amendment', 'active'),
  ('agriculture-cotton-seed-price', 'Cotton Seeds Price Order annual price citation', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Fertiliser Control Order pairs (unchanged from first pass)
  ('agri-so-1018-2026', 'Agriculture', 'S.O. 1018(E)', 2026, 'so-only', '2026-02-25', 'S.O. 1018(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  ('agri-so-3666-2026', 'Agriculture', 'S.O. 3666(E)', 2026, 'so-only', '2026-07-06', 'S.O. 3666(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  ('agri-so-5836-2025', 'Agriculture', 'S.O. 5836(E)', 2025, 'so-only', '2025-12-17', 'S.O. 5836(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  ('agri-so-3665-2026', 'Agriculture', 'S.O. 3665(E)', 2026, 'so-only', '2026-07-06', 'S.O. 3665(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  -- Corrigendum (new subject: National Institute of Occupational Health typo)
  ('agri-so-1177-2026', 'Agriculture', 'S.O. 1177(E)', 2026, 'so-only', '2026-03-06', 'S.O. 1177(E)', 'agriculture-and-farmers-welfare', NULL, 'agriculture-fertiliser-corrigendum'),
  ('agri-so-1935-2026', 'Agriculture', 'S.O. 1935(E)', 2026, 'so-only', '2026-04-17', 'S.O. 1935(E)', 'agriculture-and-farmers-welfare', NULL, 'agriculture-fertiliser-corrigendum'),
  -- Plant Varieties Act committee chain (S.O. 1589(E)) — 13-node chain, gap closed
  ('agri-so-1589-2005', 'Agriculture', 'S.O. 1589(E)', 2005, 'so-only', '2005-11-11', 'S.O. 1589(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-1883-2006', 'Agriculture', 'S.O. 1883(E)', 2006, 'so-only', '2006-11-01', 'S.O. 1883(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-1316-2009', 'Agriculture', 'S.O. 1316(E)', 2009, 'so-only', '2009-05-11', 'S.O. 1316(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-3064-2009', 'Agriculture', 'S.O. 3064(E)', 2009, 'so-only', '2009-11-30', 'S.O. 3064(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-195-2011',  'Agriculture', 'S.O. 195(E)',  2011, 'so-only', '2011-01-31', 'S.O. 195(E)',  'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-1726-2012', 'Agriculture', 'S.O. 1726(E)', 2012, 'so-only', '2012-07-31', 'S.O. 1726(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-1126-2013', 'Agriculture', 'S.O. 1126(E)', 2013, 'so-only', '2013-06-10', 'S.O. 1126(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-3094-2016', 'Agriculture', 'S.O. 3094(E)', 2016, 'so-only', '2016-09-30', 'S.O. 3094(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-2784-2020', 'Agriculture', 'S.O. 2784(E)', 2020, 'so-only', '2020-08-18', 'S.O. 2784(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-3456-2020', 'Agriculture', 'S.O. 3456(E)', 2020, 'so-only', '2020-10-01', 'S.O. 3456(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-2023-2022', 'Agriculture', 'S.O. 2023(E)', 2022, 'so-only', '2022-04-28', 'S.O. 2023(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-2963-2025', 'Agriculture', 'S.O. 2963(E)', 2025, 'so-only', '2025-06-30', 'S.O. 2963(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-2944-2026', 'Agriculture', 'S.O. 2944(E)', 2026, 'so-only', '2026-05-22', 'S.O. 2944(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  -- Plant Varieties Act registered-variety list (S.O. 1536(E)) — separate chain
  ('agri-so-1536-2017', 'Agriculture', 'S.O. 1536(E)', 2017, 'so-only', '2017-05-12', 'S.O. 1536(E)', 'agriculture-and-farmers-welfare', 'plant-varieties-registered-list', 'agriculture-plant-varieties-registered-list'),
  ('agri-so-1869-2025', 'Agriculture', 'S.O. 1869(E)', 2025, 'so-only', '2025-04-22', 'S.O. 1869(E)', 'agriculture-and-farmers-welfare', 'plant-varieties-registered-list', 'agriculture-plant-varieties-registered-list'),
  ('agri-so-2605-2026', 'Agriculture', 'S.O. 2605(E)', 2026, 'so-only', '2026-05-22', 'S.O. 2605(E)', 'agriculture-and-farmers-welfare', 'plant-varieties-registered-list', 'agriculture-plant-varieties-registered-list'),
  -- Coconut Development Board membership chain
  ('agri-so-21-1981',   'Agriculture', 'S.O. 21(E)',   1981, 'so-only', '1981-01-12', 'S.O. 21(E)',   'agriculture-and-farmers-welfare', 'coconut-development-board-act-1979', 'agriculture-coconut-board-membership'),
  ('agri-so-5001-2024', 'Agriculture', 'S.O. 5001(E)', 2024, 'so-only', '2024-11-20', 'S.O. 5001(E)', 'agriculture-and-farmers-welfare', 'coconut-development-board-act-1979', 'agriculture-coconut-board-membership'),
  ('agri-so-2679-2026', 'Agriculture', 'S.O. 2679(E)', 2026, 'so-only', '2026-05-25', 'S.O. 2679(E)', 'agriculture-and-farmers-welfare', 'coconut-development-board-act-1979', 'agriculture-coconut-board-membership'),
  -- Insecticide Inspector appointments supersession
  ('agri-so-3950-2024', 'Agriculture', 'S.O. 3950(E)', 2024, 'so-only', '2024-09-13', 'S.O. 3950(E)', 'agriculture-and-farmers-welfare', 'insecticides-act-1968-inspectors', 'agriculture-insecticide-inspectors'),
  ('agri-so-2655-2026', 'Agriculture', 'S.O. 2655(E)', 2026, 'so-only', '2026-05-22', 'S.O. 2655(E)', 'agriculture-and-farmers-welfare', 'insecticides-act-1968-inspectors', 'agriculture-insecticide-inspectors'),
  -- Public Premises Act Estate Officer amendment
  ('agri-gsr-313-2024', 'Agriculture', 'G.S.R. 313(E)', 2024, 'so-only', '2024-06-05', 'G.S.R. 313(E)', 'agriculture-and-farmers-welfare', 'public-premises-act-1971-estate-officer', 'agriculture-public-premises-estate-officer'),
  ('agri-so-2598-2026', 'Agriculture', 'S.O. 2598(E)', 2026, 'so-only', '2026-05-18', 'S.O. 2598(E)', 'agriculture-and-farmers-welfare', 'public-premises-act-1971-estate-officer', 'agriculture-public-premises-estate-officer'),
  -- Cotton Seeds Price Order — annual citation, not an amendment
  ('agri-so-1472-2025', 'Agriculture', 'S.O. 1472(E)', 2025, 'so-only', '2025-03-27', 'S.O. 1472(E)', 'agriculture-and-farmers-welfare', 'cotton-seeds-price-control-order-2015', 'agriculture-cotton-seed-price'),
  ('agri-so-2071-2026', 'Agriculture', 'S.O. 2071(E)', 2026, 'so-only', '2026-04-23', 'S.O. 2071(E)', 'agriculture-and-farmers-welfare', 'cotton-seeds-price-control-order-2015', 'agriculture-cotton-seed-price');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('agri-so-3666-2026', 'agri-so-1018-2026', 'amends', 'research-agent-quoted', '2026-09-03'),
  ('agri-so-3665-2026', 'agri-so-5836-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-1935-2026', 'agri-so-1177-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- S.O. 1589(E) full 13-node chain
  ('agri-so-1883-2006', 'agri-so-1589-2005', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-1316-2009', 'agri-so-1883-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-3064-2009', 'agri-so-1316-2009', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-195-2011',  'agri-so-3064-2009', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-1726-2012', 'agri-so-195-2011',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-1126-2013', 'agri-so-1726-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-3094-2016', 'agri-so-1126-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-2784-2020', 'agri-so-3094-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-3456-2020', 'agri-so-2784-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-2023-2022', 'agri-so-3456-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-2963-2025', 'agri-so-2023-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-2944-2026', 'agri-so-2963-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- S.O. 1536(E) chain
  ('agri-so-1869-2025', 'agri-so-1536-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-2605-2026', 'agri-so-1869-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Coconut Development Board
  ('agri-so-5001-2024', 'agri-so-21-1981',   'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-2679-2026', 'agri-so-5001-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Insecticides Act
  ('agri-so-2655-2026', 'agri-so-3950-2024', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- Public Premises Act
  ('agri-so-2598-2026', 'agri-gsr-313-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Cotton Seeds Price Order
  ('agri-so-2071-2026', 'agri-so-1472-2025', 'cites', 'research-agent-quoted', '2026-09-04');
