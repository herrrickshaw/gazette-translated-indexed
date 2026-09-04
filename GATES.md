# Gates: depth-pass batch 2 — Agriculture, Atomic Energy, Ayush, Chemicals/Fertilizers, Civil Aviation

OWNS: db/**, extract/**, tests/**, docs/**

Scope: depth-pass batch 2 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries, closing documented gaps and finding new real material, using one dedicated deep-research agent per ministry.

- [x] G1: Ministry of Agriculture and Farmers Welfare — the S.O. 1589(E) chain's 8-item gap (items 2-10, previously undocumented) fully closed with the complete real 11-item Note list, plus 6 further real pairs/chains across new subject areas (Coconut Development Board, a second Plant Varieties Act chain, Insecticides Act, Public Premises Act, a "cites"-not-"amends" annual price reference). extract/agriculture_patterns.py extended with the corrigendum-substitution template for a real shape the amendment-in-notification template alone missed.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_agriculture_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — db/seed_agriculture.sql. One further real lead (a biostimulant-entry amendment) explicitly NOT modeled because its target citation was only confirmable via the site's AI summary, not primary Full Text — the research agent flagged this itself rather than treating the summary as a source.

- [x] G2: Department of Atomic Energy — real restructuring found: two previously-separate chains turn out to be one hub (S.O. 1317(E) directly amended by 4 separate orders, one of which is further amended once more), plus 3 further real same-year Recruitment Rules amendments.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE target_gazette_id='dae-so-1317-2013';"
  EXPECT: 4
  EVIDENCE: met — db/seed_atomic_energy.sql. Three further real leads are supersessions with no usable citation on the superseded side, deliberately not modeled.

- [x] G3: Ministry of Ayush — a real DATA CORRECTION: a node modeled as "S.O. 221(E)" (based on the only primary text seen at the time) turned out, on independently opening that notification's own page, to be truly "G.S.R. 221(E)" — the later citing document itself contains a real keying error. Corrected to the notification's own true identity. Plus 8 further real chains/pairs (two sibling NCH appointment chains parallel to the known NCISM ones, Advisory Council ISM and Homoeopathy, two Submission-of-List-Rules pairs, one cross-ministry supersession).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT gsr_or_so FROM gazette_notification WHERE gazette_id='ayush-gsr-221-2024';"
  EXPECT: G.S.R. 221(E)
  EVIDENCE: met — db/seed_ayush.sql. One further real lead (a National Dhanwantari Ayurveda Award resolution chain) cites every link by File Number only and is deliberately not modeled.

- [x] G4: Ministry of Chemicals and Fertilizers — extended chains for all three known NPPA orders (2-3 further real addenda each), a new NPPA original order, three further single-hop corrigenda, and a wholly new subject area (Department of Chemicals and Petrochemicals Quality Control Order rescissions/suspensions — six real rescissions in one gazette, three suspension-extension chains) plus a 14-node Drugs Prices Control Order lineage. extract/chemicals_fertilizers_patterns.py extended with corrigendum-substitution for the QCO rescission shape the NPPA-only anchor never covered.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_chemicals_fertilizers_patterns.py -q
  EXPECT: 4 passed
  EVIDENCE: met — db/seed_chemicals_fertilizers.sql. A genuine source-text oddity (the same citation, "S.O. 2729(E)", printed with two different dates in one Note) is kept as a documented, unresolved fact rather than silently picking one.

- [x] G5: Ministry of Civil Aviation — 8 further real pairs/chains, including the specifically-requested long-history Aircraft Rules, 1937 (a real bare pre-independence principal citation, "V-26", modeled per established bare-form precedent) and three real draft-then-final notification pairs, modeled with relation_type='cites' for the draft link since a draft has no independent legal effect to "amend" (same convention as Petroleum's own draft notification).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='civil-aviation';"
  EXPECT: 24
  EVIDENCE: met — db/seed_civil_aviation.sql. Five further real leads are supersessions/citations with no usable citation on the target side, deliberately not modeled.

- [x] G6: Foreign-key integrity holds and the full suite passes after nearly doubling the total database size across this batch's 5 ministries (each roughly doubling or more in row count).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates10.txt; [ ! -s /tmp/fk_check_gates10.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates10.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 567 notifications, 406 cross-references; 141 tests passed.
