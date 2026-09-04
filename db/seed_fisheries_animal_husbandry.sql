-- Ministry of Fisheries, Animal Husbandry and Dairying pilot. Three real
-- pairs researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04.
--
-- Pair 1 is a genuinely novel combined shape (a notification that
-- simultaneously supersedes a prior CORRIGENDUM and re-performs the same
-- correction directly against the ORIGINAL notification) — not wired into
-- a dedicated extractor this batch, since forcing it through the existing
-- supersession-preamble template risks a false positive (its generous
-- fallback window, with no "except as respects" terminator present here,
-- would swallow both citations under one relation_type rather than the
-- two distinct real relationships). Modeled directly in this seed file
-- with the correct distinct relation_types instead.
--
-- Pairs 2/3 are note-chains (extract.common_templates.find_note_chain,
-- already tested) — pair 2's 12-node chain is the longest in this
-- project's Livestock Importation Act thread.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('fisheries-animal-husbandry-dairying', 'Ministry of Fisheries, Animal Husbandry and Dairying', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('veterinary-qualification-notification', 'Veterinary institution qualification-recognition notification', NULL),
  ('livestock-importation-act-1898', 'Livestock Importation Act, 1898', 1898),
  ('prevention-cruelty-animals-act-1960', 'Prevention of Cruelty to Animals Act, 1960 (CCSEA constitution)', 1960);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('veterinary-qualification-corrigendum', 'Veterinary institution qualification-recognition corrigendum chain', 'active'),
  ('livestock-importation-amendments', 'Livestock Importation Act notification and its amendments', 'active'),
  ('ccsea-constitution', 'Committee for Control and Supervision of Experiments on Animals constitution', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: three-node chain, two distinct relation types from the final node
  ('fahd-so-3317-2025', 'FAHD', 'S.O. 3317(E)', 2025, 'so-only', '2025-07-18', 'S.O. 3317(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  ('fahd-so-3410-2025', 'FAHD', 'S.O. 3410(E)', 2025, 'so-only', '2025-07-25', 'S.O. 3410(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  ('fahd-so-3868-2025', 'FAHD', 'S.O. 3868(E)', 2025, 'so-only', '2025-08-19', 'S.O. 3868(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  -- Pair 2: twelve-node chain (principal + 10 listed amendments + current)
  ('fahd-so-2666-2014', 'FAHD', 'S.O. 2666(E)', 2014, 'so-only', '2014-10-16', 'S.O. 2666(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-3356-2015', 'FAHD', 'S.O. 3356(E)', 2015, 'so-only', '2015-12-10', 'S.O. 3356(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-2640-2016', 'FAHD', 'S.O. 2640(E)', 2016, 'so-only', '2016-08-03', 'S.O. 2640(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-3112-2016', 'FAHD', 'S.O. 3112(E)', 2016, 'so-only', '2016-09-30', 'S.O. 3112(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-948-2017',  'FAHD', 'S.O. 948(E)',  2017, 'so-only', '2017-03-22', 'S.O. 948(E)',  'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-2486-2017', 'FAHD', 'S.O. 2486(E)', 2017, 'so-only', '2017-08-04', 'S.O. 2486(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-5758-2018', 'FAHD', 'S.O. 5758(E)', 2018, 'so-only', '2018-11-16', 'S.O. 5758(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-2679-2020', 'FAHD', 'S.O. 2679(E)', 2020, 'so-only', '2020-08-10', 'S.O. 2679(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-4559-2020', 'FAHD', 'S.O. 4559(E)', 2020, 'so-only', '2020-12-16', 'S.O. 4559(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-4953-2021', 'FAHD', 'S.O. 4953(E)', 2021, 'so-only', '2021-12-01', 'S.O. 4953(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-1139-2025', 'FAHD', 'S.O. 1139(E)', 2025, 'so-only', '2025-03-11', 'S.O. 1139(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  ('fahd-so-5378-2025', 'FAHD', 'S.O. 5378(E)', 2025, 'so-only', '2025-11-24', 'S.O. 5378(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898', 'livestock-importation-amendments'),
  -- Pair 3: three-node chain
  ('fahd-so-323-2025',  'FAHD', 'S.O. 323(E)',  2025, 'so-only', '2025-01-16', 'S.O. 323(E)',  'fisheries-animal-husbandry-dairying', 'prevention-cruelty-animals-act-1960', 'ccsea-constitution'),
  ('fahd-so-4884-2025', 'FAHD', 'S.O. 4884(E)', 2025, 'so-only', '2025-10-23', 'S.O. 4884(E)', 'fisheries-animal-husbandry-dairying', 'prevention-cruelty-animals-act-1960', 'ccsea-constitution'),
  ('fahd-so-5941-2025', 'FAHD', 'S.O. 5941(E)', 2025, 'so-only', '2025-12-16', 'S.O. 5941(E)', 'fisheries-animal-husbandry-dairying', 'prevention-cruelty-animals-act-1960', 'ccsea-constitution');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('fahd-so-3410-2025', 'fahd-so-3317-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3868-2025', 'fahd-so-3410-2025', 'supersedes',  'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3868-2025', 'fahd-so-3317-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3356-2015', 'fahd-so-2666-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-2640-2016', 'fahd-so-3356-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3112-2016', 'fahd-so-2640-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-948-2017',  'fahd-so-3112-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-2486-2017', 'fahd-so-948-2017',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-5758-2018', 'fahd-so-2486-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-2679-2020', 'fahd-so-5758-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-4559-2020', 'fahd-so-2679-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-4953-2021', 'fahd-so-4559-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-1139-2025', 'fahd-so-4953-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-5378-2025', 'fahd-so-1139-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-4884-2025', 'fahd-so-323-2025',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-5941-2025', 'fahd-so-4884-2025', 'amends', 'research-agent-quoted', '2026-09-04');
