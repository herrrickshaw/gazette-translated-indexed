# Gates: depth-pass batch 5 — Education, External Affairs, Finance (other depts), Fisheries/Animal Husbandry/Dairying, Food Processing Industries

OWNS: db/**, docs/**

Scope: depth-pass batch 5 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries. No new extractor code needed this batch: every real shape found fit an existing shared template, generic note-chain, or pure seed-only table-citation modeling.

- [x] G1: Ministry of Education — two existing chains turned out longer than first modeled (Council of Architecture foreign-qualification thread and NCTE General Body thread each gained 2 real intermediate nodes, replacing the old direct edges). 4 new subject threads found: UGC Recruitment Rules 2016 (a hub — two independent Schedule-entry amendments both citing the same predecessor), a second parallel Punjab University rescission cycle one week earlier, RTE Act s.33 Committee, and Council of Architecture Rules 1973 (an 11-node chain, distinct from but adjacent to the already-modeled G.S.R.68(E) thread).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='education';"
  EXPECT: 36
  EVIDENCE: met — db/seed_education.sql. Three further real leads (NCTE Regulations, AICTE Guidelines, Delhi University Statutes amendment) deliberately not modeled — all File-Number-only citations.

- [x] G2: Ministry of External Affairs — 4 new subject threads found, three sharing a recurring MEA drafting convention (a trailing Note naming only the origin and immediately-preceding amendment, not a full list) assembled across multiple documents into linear chains: Terrorism Implementation Order 2007 (6-node chain), Sudan UNSC Implementation Order 2016 (4-node chain), Passports Rules 1980 fee schedule (4-node chain), plus a Yemen travel-conditions rescission.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='external-affairs';"
  EXPECT: 23
  EVIDENCE: met — db/seed_external_affairs.sql. Four further UNSC-sanctions Orders flagged as high-confidence but unverified (own Full Text not independently opened this pass) — not modeled.

- [x] G3: Ministry of Finance (departments other than Revenue/CBIC) — both items flagged in the first pass are now closed: the FEMA Non-debt Instruments Rules gap (16 missing items) fully closed with the complete real 18-item list, and the cross-department DEA<->DFS Investment Pattern lead is now a fully quoted 5-node bare-numbering chain. 14 further new subject threads found across DEA/DFS/DIPAM, including two long pre-1994 bare-numbering chains (LIC General Rules 1956, 15 nodes; Banking Regulation Companies Rules 1949, 11 nodes; Banking Regulation Co-operative Societies Rules 1966, 8 nodes) and a hub (DRT jurisdiction notification amended independently by two later notifications).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='finance-other-departments';"
  EXPECT: 110
  EVIDENCE: met — db/seed_finance_other.sql.

- [x] G3b: A REAL CITATION COLLISION found and correctly kept distinct: this file's G.S.R. 488(E) [2023, Government Savings Promotion Rules] is unrelated to Power's G.S.R. 488(E) [2021, JERC chain, already in db/seed_power.sql] — same displayed citation, different real documents, different ministry-prefixed gazette_id.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE gsr_or_so='G.S.R. 488(E)';"
  EXPECT: 2
  EVIDENCE: met — power-gsr-488-2021 and mof-gsr-488-2023 are distinct rows.

- [x] G4: Ministry of Fisheries, Animal Husbandry and Dairying — 6 new subject threads found (Coastal Aquaculture Authority Rules 2024, CAA constitution-of-members 3-node supersession chain, CAA shrimp hatchery guidelines with a combined amends+cites shape, National Dairy Development Board Act Chairman/Additional-Charge 5-node chain, NDDB Board of Directors nominations 4-node chain, Livestock Importation Act s.3A import certificate) plus a real extension of the already-modeled Indian Veterinary Council Act thread — a parallel substantive-amendment sub-chain running alongside the already-modeled corrigendum sub-chain from the same root node.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='fisheries-animal-husbandry-dairying';"
  EXPECT: 40
  EVIDENCE: met — db/seed_fisheries_animal_husbandry.sql. A probable-but-unconfirmed title/date-proximity match (S.O. 1496(E) / S.O. 1455(E)) deliberately not modeled since the citing text never actually names the target's number.

- [x] G5: Ministry of Food Processing Industries — freshly re-researched (all 6 tracker notifications plus 2 NIFTEM-filed controls re-opened); confirmed genuinely no new material exists beyond the one already-modeled pair. Recorded as checked, not skipped.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='food-processing-industries';"
  EXPECT: 2
  EVIDENCE: met — no seed file change needed; the three previously-deferred leads remain correctly deferred (one gained a precise date but still no citation number).

- [x] G6: Foreign-key integrity holds and the full suite passes after this batch's additions across 5 ministries — no new extractor code needed this round (every real shape fit an existing shared template, generic note-chain, or pure seed-only table-citation modeling).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates13.txt; [ ! -s /tmp/fk_check_gates13.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates13.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 916 notifications, 671 cross-references; 141 tests passed.
