-- Ministry of Fisheries, Animal Husbandry and Dairying. Deepened
-- 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the
-- original bounded pass (3 pairs/chains, 15 notifications).
--
-- 6 new subject areas found (Coastal Aquaculture Authority Rules, 2024;
-- CAA constitution-of-members 3-node supersession chain; CAA shrimp
-- hatchery guidelines with a combined amends+cites shape; National Dairy
-- Development Board Act Chairman/Additional-Charge 5-node chain; NDDB
-- Board of Directors nominations 4-node chain; Livestock Importation
-- Act s.3A dog/cat food import certificate) plus a real extension of the
-- already-modeled Indian Veterinary Council Act First Schedule thread — a
-- parallel SUBSTANTIVE-amendment sub-chain (S.O.1914(E)->S.O.3232(E)->
-- S.O.3317(E)->S.O.3443(E)) running alongside the already-modeled
-- corrigendum sub-chain from the same root node S.O. 3317(E).
--
-- Real leads NOT modeled: a draft (G.S.R. 723(E), not yet effective)
-- proposing a title-only supersession; the Coastal Aquaculture Authority
-- Rules, 2005 (superseded by G.S.R. 33(E) but cited only by title); a
-- probable-but-unconfirmed match between S.O. 1496(E) and a same-titled
-- S.O. 1455(E) five days apart — the citing text never actually names the
-- number, so per the anti-fabrication rule this is left unmodeled rather
-- than assumed from title/date proximity alone.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('fisheries-animal-husbandry-dairying', 'Ministry of Fisheries, Animal Husbandry and Dairying', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('veterinary-qualification-notification', 'Veterinary institution qualification-recognition notification (Indian Veterinary Council Act, 1984, First Schedule)', 1984),
  ('livestock-importation-act-1898', 'Livestock Importation Act, 1898', 1898),
  ('prevention-cruelty-animals-act-1960', 'Prevention of Cruelty to Animals Act, 1960 (CCSEA constitution)', 1960),
  ('coastal-aquaculture-authority-rules-2024', 'Coastal Aquaculture Authority Rules, 2024', 2024),
  ('coastal-aquaculture-authority-members', 'Coastal Aquaculture Authority — constitution of members', NULL),
  ('coastal-aquaculture-shrimp-hatchery-guidelines-2025', 'Hatcheries and Farms for Seed Production and Culture of Indigenous Shrimp in Marine and Brackishwater Guidelines, 2025', 2025),
  ('nucleus-breeding-broodstock-guidelines-2024', 'Guidelines for Nucleus Breeding/Broodstock Multiplication Centres, 2024', 2024),
  ('nddb-act-1987-chairman-additional-charge', 'National Dairy Development Board Act, 1987 — Chairman/Additional-Charge notification', 1987),
  ('nddb-act-1987-board-nominations', 'National Dairy Development Board Act, 1987 — Board of Directors nominations', 1987),
  ('livestock-importation-act-1898-s3a-import-certificate', 'Livestock Importation Act, 1898, s.3A — dog/cat food import certificate (Form-I)', 1898);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('veterinary-qualification-corrigendum', 'Veterinary institution qualification-recognition: corrigendum sub-chain AND a parallel substantive-amendment sub-chain, both from root S.O. 3317(E)', 'active'),
  ('livestock-importation-amendments', 'Livestock Importation Act notification and its amendments', 'active'),
  ('ccsea-constitution', 'Committee for Control and Supervision of Experiments on Animals constitution', 'active'),
  ('caa-rules-2024-amendments', 'Coastal Aquaculture Authority Rules, 2024 and its amendment', 'active'),
  ('caa-members-supersession', 'Coastal Aquaculture Authority constitution-of-members supersession chain', 'active'),
  ('caa-shrimp-hatchery-guidelines', 'CAA shrimp hatchery guidelines amendment and cross-reference', 'active'),
  ('nddb-chairman-additional-charge', 'NDDB Act Chairman/Additional-Charge amendment chain', 'active'),
  ('nddb-board-nominations', 'NDDB Act Board of Directors nominations amendment chain', 'active'),
  ('livestock-importation-s3a-import-certificate', 'Livestock Importation Act s.3A dog/cat food import certificate amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1 + Thread 7 extension: nine-node combined shape from root S.O. 3317(E)
  ('fahd-so-3317-2025', 'FAHD', 'S.O. 3317(E)', 2025, 'so-only', '2025-07-18', 'S.O. 3317(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  ('fahd-so-3410-2025', 'FAHD', 'S.O. 3410(E)', 2025, 'so-only', '2025-07-25', 'S.O. 3410(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  ('fahd-so-3868-2025', 'FAHD', 'S.O. 3868(E)', 2025, 'so-only', '2025-08-19', 'S.O. 3868(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  ('fahd-so-1914-2025', 'FAHD', 'S.O. 1914(E)', 2025, 'so-only', '2025-04-28', 'S.O. 1914(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  ('fahd-so-3232-2025', 'FAHD', 'S.O. 3232(E)', 2025, 'so-only', '2025-07-14', 'S.O. 3232(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
  ('fahd-so-3443-2025', 'FAHD', 'S.O. 3443(E)', 2025, 'so-only', '2025-07-28', 'S.O. 3443(E)', 'fisheries-animal-husbandry-dairying', 'veterinary-qualification-notification', 'veterinary-qualification-corrigendum'),
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
  ('fahd-so-5941-2025', 'FAHD', 'S.O. 5941(E)', 2025, 'so-only', '2025-12-16', 'S.O. 5941(E)', 'fisheries-animal-husbandry-dairying', 'prevention-cruelty-animals-act-1960', 'ccsea-constitution'),
  -- Coastal Aquaculture Authority Rules, 2024
  ('fahd-gsr-33-2024',  'FAHD', 'G.S.R. 33(E)',  2024, 'so-only', '2024-01-09', 'G.S.R. 33(E)',  'fisheries-animal-husbandry-dairying', 'coastal-aquaculture-authority-rules-2024', 'caa-rules-2024-amendments'),
  ('fahd-gsr-750-2024', 'FAHD', 'G.S.R. 750(E)', 2024, 'so-only', '2024-12-04', 'G.S.R. 750(E)', 'fisheries-animal-husbandry-dairying', 'coastal-aquaculture-authority-rules-2024', 'caa-rules-2024-amendments'),
  -- CAA constitution of members
  ('fahd-so-5037-2021', 'FAHD', 'S.O. 5037(E)', 2021, 'so-only', '2021-12-06', 'S.O. 5037(E)', 'fisheries-animal-husbandry-dairying', 'coastal-aquaculture-authority-members', 'caa-members-supersession'),
  ('fahd-so-1341-2025', 'FAHD', 'S.O. 1341(E)', 2025, 'so-only', '2025-03-20', 'S.O. 1341(E)', 'fisheries-animal-husbandry-dairying', 'coastal-aquaculture-authority-members', 'caa-members-supersession'),
  ('fahd-so-557-2026',  'FAHD', 'S.O. 557(E)',  2026, 'so-only', '2026-02-04', 'S.O. 557(E)',  'fisheries-animal-husbandry-dairying', 'coastal-aquaculture-authority-members', 'caa-members-supersession'),
  -- CAA shrimp hatchery guidelines (combined amends + cites)
  ('fahd-so-2903-2025', 'FAHD', 'S.O. 2903(E)', 2025, 'so-only', '2025-06-30', 'S.O. 2903(E)', 'fisheries-animal-husbandry-dairying', 'coastal-aquaculture-shrimp-hatchery-guidelines-2025', 'caa-shrimp-hatchery-guidelines'),
  ('fahd-so-552-2026',  'FAHD', 'S.O. 552(E)',  2026, 'so-only', '2026-02-04', 'S.O. 552(E)',  'fisheries-animal-husbandry-dairying', 'coastal-aquaculture-shrimp-hatchery-guidelines-2025', 'caa-shrimp-hatchery-guidelines'),
  ('fahd-so-1459-2024', 'FAHD', 'S.O. 1459(E)', 2024, 'so-only', '2024-03-15', 'S.O. 1459(E)', 'fisheries-animal-husbandry-dairying', 'nucleus-breeding-broodstock-guidelines-2024', 'caa-shrimp-hatchery-guidelines'),
  -- NDDB Act Chairman/Additional-Charge
  ('fahd-so-2685-2023', 'FAHD', 'S.O. 2685(E)', 2023, 'so-only', '2023-06-15', 'S.O. 2685(E)', 'fisheries-animal-husbandry-dairying', 'nddb-act-1987-chairman-additional-charge', 'nddb-chairman-additional-charge'),
  ('fahd-so-364-2024',  'FAHD', 'S.O. 364(E)',  2024, 'so-only', '2024-01-30', 'S.O. 364(E)',  'fisheries-animal-husbandry-dairying', 'nddb-act-1987-chairman-additional-charge', 'nddb-chairman-additional-charge'),
  ('fahd-so-5373-2024', 'FAHD', 'S.O. 5373(E)', 2024, 'so-only', '2024-12-05', 'S.O. 5373(E)', 'fisheries-animal-husbandry-dairying', 'nddb-act-1987-chairman-additional-charge', 'nddb-chairman-additional-charge'),
  ('fahd-so-2172-2025', 'FAHD', 'S.O. 2172(E)', 2025, 'so-only', '2025-05-15', 'S.O. 2172(E)', 'fisheries-animal-husbandry-dairying', 'nddb-act-1987-chairman-additional-charge', 'nddb-chairman-additional-charge'),
  ('fahd-so-10-2026',   'FAHD', 'S.O. 10(E)',   2026, 'so-only', '2026-01-01', 'S.O. 10(E)',   'fisheries-animal-husbandry-dairying', 'nddb-act-1987-chairman-additional-charge', 'nddb-chairman-additional-charge'),
  -- NDDB Act Board of Directors nominations
  ('fahd-so-957-2023',  'FAHD', 'S.O. 957(E)',  2023, 'so-only', '2023-02-28', 'S.O. 957(E)',  'fisheries-animal-husbandry-dairying', 'nddb-act-1987-board-nominations', 'nddb-board-nominations'),
  ('fahd-so-4987-2023', 'FAHD', 'S.O. 4987(E)', 2023, 'so-only', '2023-11-17', 'S.O. 4987(E)', 'fisheries-animal-husbandry-dairying', 'nddb-act-1987-board-nominations', 'nddb-board-nominations'),
  ('fahd-so-2705-2024', 'FAHD', 'S.O. 2705(E)', 2024, 'so-only', '2024-07-11', 'S.O. 2705(E)', 'fisheries-animal-husbandry-dairying', 'nddb-act-1987-board-nominations', 'nddb-board-nominations'),
  ('fahd-so-2961-2024', 'FAHD', 'S.O. 2961(E)', 2024, 'so-only', '2024-07-24', 'S.O. 2961(E)', 'fisheries-animal-husbandry-dairying', 'nddb-act-1987-board-nominations', 'nddb-board-nominations'),
  -- Livestock Importation Act s.3A dog/cat food import certificate
  ('fahd-so-3926-2021', 'FAHD', 'S.O. 3926(E)', 2021, 'so-only', '2021-09-22', 'S.O. 3926(E)', 'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898-s3a-import-certificate', 'livestock-importation-s3a-import-certificate'),
  ('fahd-so-320-2025',  'FAHD', 'S.O. 320(E)',  2025, 'so-only', '2025-01-17', 'S.O. 320(E)',  'fisheries-animal-husbandry-dairying', 'livestock-importation-act-1898-s3a-import-certificate', 'livestock-importation-s3a-import-certificate');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('fahd-so-3410-2025', 'fahd-so-3317-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3868-2025', 'fahd-so-3410-2025', 'supersedes',  'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3868-2025', 'fahd-so-3317-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3232-2025', 'fahd-so-1914-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3317-2025', 'fahd-so-3232-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-3443-2025', 'fahd-so-3317-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
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
  ('fahd-so-5941-2025', 'fahd-so-4884-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-gsr-750-2024', 'fahd-gsr-33-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-1341-2025', 'fahd-so-5037-2021', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-557-2026',  'fahd-so-1341-2025', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-552-2026', 'fahd-so-2903-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-552-2026', 'fahd-so-1459-2024', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('fahd-so-364-2024',  'fahd-so-2685-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-5373-2024', 'fahd-so-364-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-2172-2025', 'fahd-so-5373-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-10-2026',   'fahd-so-2172-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-4987-2023', 'fahd-so-957-2023',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-2705-2024', 'fahd-so-4987-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-2961-2024', 'fahd-so-2705-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('fahd-so-320-2025', 'fahd-so-3926-2021', 'amends', 'research-agent-quoted', '2026-09-04');
