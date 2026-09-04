-- Ministry of Mines pilot. Three real pairs researched via gazettetracker.com
-- (Full Text section, primary), 2026-09-04.
--
-- Pair 1: corrigendum-substitution template (extract/mines_patterns.py).
-- Pairs 2/3: note-chain template (extract.common_templates.find_note_chain).
-- Pair 2's Note is the longest real chain seen so far (principal + 7
-- amendments, 8 nodes) and the first with an "and" conjunction before the
-- final item — see tests/test_note_chain.py::test_eight_item_chain_with_and_conjunction_before_last_item.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('mines', 'Ministry of Mines', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('minerals-concession-rules-2026', 'Minerals (Other than Atomic and Hydro Carbons Energy Minerals) Concession Rules', NULL),
  ('mineral-conservation-development-rules-2017', 'Mineral Conservation and Development Rules, 2017', 2017),
  ('mineral-auction-rules-2015', 'Mineral (Auction) Rules, 2015', 2015);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mines-concession-rules-corrigendum', 'Corrigendum to the Minerals Concession (Second Amendment) Rules, 2026', 'active'),
  ('mines-mcdr-amendments', 'Mineral Conservation and Development Rules and its amendments', 'active'),
  ('mines-auction-rules-amendments', 'Mineral (Auction) Rules and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: G.S.R. 255(E) corrects G.S.R. 222(E)
  ('mines-gsr-222-2026', 'Mines', 'G.S.R. 222(E)', 2026, 'so-only', '2026-03-30', 'G.S.R. 222(E)', 'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  ('mines-gsr-255-2026', 'Mines', 'G.S.R. 255(E)', 2026, 'so-only', '2026-04-08', 'G.S.R. 255(E)', 'mines', 'minerals-concession-rules-2026', 'mines-concession-rules-corrigendum'),
  -- Pair 2: MCDR nine-node chain (principal + 8 amendments, ending at the
  -- Second Amendment Rules, 2026 that carries the quoted Note)
  ('mines-gsr-169-2017', 'Mines', 'G.S.R. 169(E)', 2017, 'so-only', '2017-02-27', 'G.S.R. 169(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-289-2018', 'Mines', 'G.S.R. 289(E)', 2018, 'so-only', '2018-03-27', 'G.S.R. 289(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-570-2019', 'Mines', 'G.S.R. 570(E)', 2019, 'so-only', '2019-08-13', 'G.S.R. 570(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-780-2021', 'Mines', 'G.S.R. 780(E)', 2021, 'so-only', '2021-11-03', 'G.S.R. 780(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-294-2022', 'Mines', 'G.S.R. 294(E)', 2022, 'so-only', '2022-04-11', 'G.S.R. 294(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-51-2024',  'Mines', 'G.S.R. 51(E)',  2024, 'so-only', '2024-01-21', 'G.S.R. 51(E)',  'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-232-2025', 'Mines', 'G.S.R. 232(E)', 2025, 'so-only', '2025-04-16', 'G.S.R. 232(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-449-2026', 'Mines', 'G.S.R. 449(E)', 2026, 'so-only', '2026-06-05', 'G.S.R. 449(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  ('mines-gsr-683-2026', 'Mines', 'G.S.R. 683(E)', 2026, 'so-only', '2026-07-30', 'G.S.R. 683(E)', 'mines', 'mineral-conservation-development-rules-2017', 'mines-mcdr-amendments'),
  -- Pair 3: Mineral (Auction) Rules three-node chain
  ('mines-gsr-406-2015', 'Mines', 'G.S.R. 406(E)', 2015, 'so-only', '2015-05-20', 'G.S.R. 406(E)', 'mines', 'mineral-auction-rules-2015', 'mines-auction-rules-amendments'),
  ('mines-gsr-71-2026',  'Mines', 'G.S.R. 71(E)',  2026, 'so-only', '2026-01-29', 'G.S.R. 71(E)',  'mines', 'mineral-auction-rules-2015', 'mines-auction-rules-amendments'),
  ('mines-gsr-223-2026', 'Mines', 'G.S.R. 223(E)', 2026, 'so-only', '2026-03-30', 'G.S.R. 223(E)', 'mines', 'mineral-auction-rules-2015', 'mines-auction-rules-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mines-gsr-255-2026', 'mines-gsr-222-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-289-2018', 'mines-gsr-169-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-570-2019', 'mines-gsr-289-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-780-2021', 'mines-gsr-570-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-294-2022', 'mines-gsr-780-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-51-2024',  'mines-gsr-294-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-232-2025', 'mines-gsr-51-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-449-2026', 'mines-gsr-232-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-683-2026', 'mines-gsr-449-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-71-2026',  'mines-gsr-406-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mines-gsr-223-2026', 'mines-gsr-71-2026',  'amends', 'research-agent-quoted', '2026-09-04');
