-- Department of Food and Public Distribution (Ministry of Consumer
-- Affairs, Food and Public Distribution) pilot.
--
-- Modeled: two distinct amendment orders (S.O. 3926(E), S.O. 245(E)) both
-- amending the same parent order S.O. 2359(E) — a wheat stock-limit order
-- under the Essential Commodities Act, 1955 (verified_by
-- 'research-agent-quoted' for both). Two edges into one original, not two
-- independent pairs.
--
-- Also modeled (2026-09-04, extract.common_templates.find_note_chain —
-- both quoted verbatim, this is one of the two real examples the template
-- itself was tested against): a real three-item chain, G.S.R. 202(E)
-- [principal, 2011] -> G.S.R. 312(E) [2026] -> G.S.R. 418(E) [current,
-- 2026], Legal Metrology (Packaged Commodities) Rules, 2011.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('consumer-affairs-food-public-distribution', 'Ministry of Consumer Affairs, Food and Public Distribution', 'Department of Food and Public Distribution');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('essential-commodities-act-1955', 'Essential Commodities Act, 1955', 1955),
  ('legal-metrology-packaged-commodities-rules-2011', 'Legal Metrology (Packaged Commodities) Rules, 2011', 2011);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('wheat-stock-limit-order', 'Wheat stock-limit order and its amendments', 'active'),
  ('legal-metrology-packaged-commodities', 'Legal Metrology (Packaged Commodities) Rules and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('cafpd-so-2359-2025', 'Consumer Affairs', 'S.O. 2359(E)', 2025, 'so-only', '2025-05-27', 'S.O. 2359(E)', 'consumer-affairs-food-public-distribution', 'essential-commodities-act-1955', 'wheat-stock-limit-order'),
  ('cafpd-so-3926-2025', 'Consumer Affairs', 'S.O. 3926(E)', 2025, 'so-only', '2025-08-26', 'S.O. 3926(E)', 'consumer-affairs-food-public-distribution', 'essential-commodities-act-1955', 'wheat-stock-limit-order'),
  ('cafpd-so-245-2026',  'Consumer Affairs', 'S.O. 245(E)',  2026, 'so-only', '2026-01-16', 'S.O. 245(E)',  'consumer-affairs-food-public-distribution', 'essential-commodities-act-1955', 'wheat-stock-limit-order'),
  ('cafpd-gsr-202-2011', 'Consumer Affairs', 'G.S.R. 202(E)', 2011, 'so-only', '2011-03-07', 'G.S.R. 202(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-packaged-commodities-rules-2011', 'legal-metrology-packaged-commodities'),
  ('cafpd-gsr-312-2026', 'Consumer Affairs', 'G.S.R. 312(E)', 2026, 'so-only', '2026-04-27', 'G.S.R. 312(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-packaged-commodities-rules-2011', 'legal-metrology-packaged-commodities'),
  ('cafpd-gsr-418-2026', 'Consumer Affairs', 'G.S.R. 418(E)', 2026, 'so-only', '2026-05-29', 'G.S.R. 418(E)', 'consumer-affairs-food-public-distribution', 'legal-metrology-packaged-commodities-rules-2011', 'legal-metrology-packaged-commodities');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('cafpd-so-3926-2025', 'cafpd-so-2359-2025', 'amends', 'research-agent-quoted', '2026-09-03'),
  ('cafpd-so-245-2026',  'cafpd-so-2359-2025', 'amends', 'research-agent-quoted', '2026-09-03'),
  ('cafpd-gsr-312-2026', 'cafpd-gsr-202-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('cafpd-gsr-418-2026', 'cafpd-gsr-312-2026', 'amends', 'research-agent-quoted', '2026-09-04');
