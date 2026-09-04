-- Ministry of Consumer Affairs, Food and Public Distribution. Deepened
-- 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the
-- original 2-chain pass.
--
-- Both known chains (wheat stock-limit order, Legal Metrology Packaged
-- Commodities Rules) confirmed to have no further amendments beyond
-- what was already modeled. Eight further real pairs/chains found across
-- new subject areas spanning both departments: BIS Act hallmarking,
-- two further Legal Metrology Act rule families (Government Approved
-- Test Centre Rules, General Rules — distinct from Packaged Commodities),
-- Essential Commodities Act orders for edible oil, sugarcane, food
-- security assistance, and the Targeted Public Distribution System.
--
-- The Sugarcane (Control) Order, 1966's own principal citation is a real,
-- non-standard pre-modern form ("G.S.R. 1126/Ess.Com./Sugarcane") —
-- modeled as a bare row per established precedent even though the live
-- regex can't discover it unaided; the edge from its confirmed successor
-- (S.O. 4646(E)) is still fully evidenced by the citing document's own
-- Note.
--
-- One further real lead (a Sugar (Control) Order, 2025 supersession of
-- two predecessor orders) cites both superseded orders by title/year only
-- — no G.S.R./S.O. number for either — deliberately not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('consumer-affairs-food-public-distribution', 'Ministry of Consumer Affairs, Food and Public Distribution', 'Department of Food and Public Distribution; Department of Consumer Affairs');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('essential-commodities-act-1955', 'Essential Commodities Act, 1955', 1955),
  ('legal-metrology-packaged-commodities-rules-2011', 'Legal Metrology (Packaged Commodities) Rules, 2011', 2011),
  ('bis-act-2016-hallmarking-order', 'BIS Act, 2016 — Hallmarking of Gold Jewellery and Gold Artefacts Order, 2020', 2020),
  ('legal-metrology-test-centre-rules-2013', 'Legal Metrology (Government Approved Test Centre) Rules, 2013', 2013),
  ('legal-metrology-general-rules-2011', 'Legal Metrology (General) Rules, 2011', 2011),
  ('vegetable-oil-products-order-2011', 'Vegetable Oil Products Production and Availability (Regulation) Order, 2011', 2011),
  ('sugarcane-control-order-1966', 'Sugarcane (Control) Order, 1966', 1966),
  ('food-security-assistance-rules-2015', 'Food Security (Assistance to State Governments) Rules, 2015', 2015),
  ('tpds-control-order-2015', 'Targeted Public Distribution System (Control) Order, 2015', 2015);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('wheat-stock-limit-order', 'Wheat stock-limit order and its amendments', 'active'),
  ('legal-metrology-packaged-commodities', 'Legal Metrology (Packaged Commodities) Rules and its amendments', 'active'),
  ('bis-hallmarking-order-amendments', 'Hallmarking of Gold Jewellery and Gold Artefacts Order and its amendments', 'active'),
  ('lm-test-centre-rules-amendments', 'Legal Metrology (Government Approved Test Centre) Rules and its amendments', 'active'),
  ('lm-general-rules-amendments', 'Legal Metrology (General) Rules and its amendments', 'active'),
  ('vegetable-oil-order-amendment', 'Vegetable Oil Products Order amendment', 'active'),
  ('sugarcane-control-order-amendments', 'Sugarcane (Control) Order and its amendments', 'active'),
  ('food-security-assistance-rules-amendments', 'Food Security Assistance Rules and its amendments', 'active'),
  ('tpds-control-order-amendments', 'TPDS Control Order and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('cafpd-so-2359-2025', 'Consumer Affairs', 'S.O. 2359(E)', 2025, 'so-only', '2025-05-27', 'S.O. 2359(E)', 'consumer-affairs-food-public-distribution', 'essential-commodities-act-1955', 'wheat-stock-limit-order'),
  ('cafpd-so-3926-2025', 'Consumer Affairs', 'S.O. 3926(E)', 2025, 'so-only', '2025-08-26', 'S.O. 3926(E)', 'consumer-affairs-food-public-distribution', 'essential-commodities-act-1955', 'wheat-stock-limit-order'),
  ('cafpd-so-245-2026',  'Consumer Affairs', 'S.O. 245(E)',  2026, 'so-only', '2026-01-16', 'S.O. 245(E)',  'consumer-affairs-food-public-distribution', 'essential-commodities-act-1955', 'wheat-stock-limit-order'),
  ('cafpd-gsr-202-2011', 'Consumer Affairs', 'G.S.R. 202(E)', 2011, 'so-only', '2011-03-07', 'G.S.R. 202(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-packaged-commodities-rules-2011', 'legal-metrology-packaged-commodities'),
  ('cafpd-gsr-312-2026', 'Consumer Affairs', 'G.S.R. 312(E)', 2026, 'so-only', '2026-04-27', 'G.S.R. 312(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-packaged-commodities-rules-2011', 'legal-metrology-packaged-commodities'),
  ('cafpd-gsr-418-2026', 'Consumer Affairs', 'G.S.R. 418(E)', 2026, 'so-only', '2026-05-29', 'G.S.R. 418(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-packaged-commodities-rules-2011', 'legal-metrology-packaged-commodities'),
  -- BIS hallmarking chain
  ('cafpd-so-205-2020',  'Consumer Affairs', 'S.O. 205(E)',  2020, 'so-only', '2020-01-15', 'S.O. 205(E)',  'consumer-affairs-food-public-distribution', 'bis-act-2016-hallmarking-order', 'bis-hallmarking-order-amendments'),
  ('cafpd-so-2117-2026', 'Consumer Affairs', 'S.O. 2117(E)', 2026, 'so-only', '2026-04-28', 'S.O. 2117(E)', 'consumer-affairs-food-public-distribution', 'bis-act-2016-hallmarking-order', 'bis-hallmarking-order-amendments'),
  ('cafpd-so-4345-2026', 'Consumer Affairs', 'S.O. 4345(E)', 2026, 'so-only', '2026-08-03', 'S.O. 4345(E)', 'consumer-affairs-food-public-distribution', 'bis-act-2016-hallmarking-order', 'bis-hallmarking-order-amendments'),
  -- Legal Metrology Test Centre Rules chain
  ('cafpd-gsr-593-2013', 'Consumer Affairs', 'G.S.R. 593(E)', 2013, 'so-only', '2013-09-05', 'G.S.R. 593(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-test-centre-rules-2013', 'lm-test-centre-rules-amendments'),
  ('cafpd-gsr-779-2025', 'Consumer Affairs', 'G.S.R. 779(E)', 2025, 'so-only', '2025-10-23', 'G.S.R. 779(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-test-centre-rules-2013', 'lm-test-centre-rules-amendments'),
  ('cafpd-gsr-346-2026', 'Consumer Affairs', 'G.S.R. 346(E)', 2026, 'so-only', '2026-05-08', 'G.S.R. 346(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-test-centre-rules-2013', 'lm-test-centre-rules-amendments'),
  -- Legal Metrology General Rules chain
  ('cafpd-gsr-71-2011',  'Consumer Affairs', 'G.S.R. 71(E)',  2011, 'so-only', '2011-02-07', 'G.S.R. 71(E)',  'consumer-affairs-food-public-distribution', 'legal-metrology-general-rules-2011', 'lm-general-rules-amendments'),
  ('cafpd-gsr-175-2026', 'Consumer Affairs', 'G.S.R. 175(E)', 2026, 'so-only', '2026-03-12', 'G.S.R. 175(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-general-rules-2011', 'lm-general-rules-amendments'),
  ('cafpd-gsr-568-2026', 'Consumer Affairs', 'G.S.R. 568(E)', 2026, 'so-only', '2026-07-03', 'G.S.R. 568(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-general-rules-2011', 'lm-general-rules-amendments'),
  -- Vegetable Oil Products Order
  ('cafpd-gsr-664-2011', 'Consumer Affairs', 'G.S.R. 664(E)', 2011, 'so-only', '2011-09-07', 'G.S.R. 664(E)', 'consumer-affairs-food-public-distribution', 'vegetable-oil-products-order-2011', 'vegetable-oil-order-amendment'),
  ('cafpd-gsr-523-2025', 'Consumer Affairs', 'G.S.R. 523(E)', 2025, 'so-only', '2025-08-01', 'G.S.R. 523(E)', 'consumer-affairs-food-public-distribution', 'vegetable-oil-products-order-2011', 'vegetable-oil-order-amendment'),
  -- Sugarcane Control Order chain, bare pre-modern principal
  ('cafpd-gsr-1126-sugarcane', 'Consumer Affairs', 'G.S.R. 1126/Ess.Com./Sugarcane', 1966, 'bare', '1966-07-16', 'G.S.R. 1126/Ess.Com./Sugarcane', 'consumer-affairs-food-public-distribution', 'sugarcane-control-order-1966', 'sugarcane-control-order-amendments'),
  ('cafpd-so-4646-2022', 'Consumer Affairs', 'S.O. 4646(E)', 2022, 'so-only', '2022-09-30', 'S.O. 4646(E)', 'consumer-affairs-food-public-distribution', 'sugarcane-control-order-1966', 'sugarcane-control-order-amendments'),
  ('cafpd-so-4688-2025', 'Consumer Affairs', 'S.O. 4688(E)', 2025, 'so-only', '2025-10-16', 'S.O. 4688(E)', 'consumer-affairs-food-public-distribution', 'sugarcane-control-order-1966', 'sugarcane-control-order-amendments'),
  -- Food Security Assistance Rules chain
  ('cafpd-gsr-636-2015', 'Consumer Affairs', 'G.S.R. 636(E)', 2015, 'so-only', '2015-08-17', 'G.S.R. 636(E)', 'consumer-affairs-food-public-distribution', 'food-security-assistance-rules-2015', 'food-security-assistance-rules-amendments'),
  ('cafpd-gsr-384-2022', 'Consumer Affairs', 'G.S.R. 384(E)', 2022, 'so-only', '2022-05-23', 'G.S.R. 384(E)', 'consumer-affairs-food-public-distribution', 'food-security-assistance-rules-2015', 'food-security-assistance-rules-amendments'),
  ('cafpd-gsr-544-2026', 'Consumer Affairs', 'G.S.R. 544(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 544(E)', 'consumer-affairs-food-public-distribution', 'food-security-assistance-rules-2015', 'food-security-assistance-rules-amendments'),
  -- TPDS Control Order chain
  ('cafpd-gsr-213-2015', 'Consumer Affairs', 'G.S.R. 213(E)', 2015, 'so-only', '2015-03-20', 'G.S.R. 213(E)', 'consumer-affairs-food-public-distribution', 'tpds-control-order-2015', 'tpds-control-order-amendments'),
  ('cafpd-gsr-43-2024',  'Consumer Affairs', 'G.S.R. 43(E)',  2024, 'so-only', '2024-01-15', 'G.S.R. 43(E)',  'consumer-affairs-food-public-distribution', 'tpds-control-order-2015', 'tpds-control-order-amendments'),
  ('cafpd-gsr-488-2025', 'Consumer Affairs', 'G.S.R. 488(E)', 2025, 'so-only', '2025-07-22', 'G.S.R. 488(E)', 'consumer-affairs-food-public-distribution', 'tpds-control-order-2015', 'tpds-control-order-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('cafpd-so-3926-2025', 'cafpd-so-2359-2025', 'amends', 'research-agent-quoted', '2026-09-03'),
  ('cafpd-so-245-2026',  'cafpd-so-2359-2025', 'amends', 'research-agent-quoted', '2026-09-03'),
  ('cafpd-gsr-312-2026', 'cafpd-gsr-202-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-418-2026', 'cafpd-gsr-312-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-so-2117-2026', 'cafpd-so-205-2020',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-so-4345-2026', 'cafpd-so-2117-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-779-2025', 'cafpd-gsr-593-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-346-2026', 'cafpd-gsr-779-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-175-2026', 'cafpd-gsr-71-2011',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-568-2026', 'cafpd-gsr-175-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-523-2025', 'cafpd-gsr-664-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-so-4646-2022', 'cafpd-gsr-1126-sugarcane', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-so-4688-2025', 'cafpd-so-4646-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-384-2022', 'cafpd-gsr-636-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-544-2026', 'cafpd-gsr-384-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-43-2024',  'cafpd-gsr-213-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-488-2025', 'cafpd-gsr-43-2024',  'amends', 'research-agent-quoted', '2026-09-04');
