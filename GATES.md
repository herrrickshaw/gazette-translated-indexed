# Gates: 7th research batch — New/Renewable Energy, Fisheries, Panchayati Raj, Chemicals/Fertilizers, Earth Sciences

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: research, review, and model the next 5 ministries the same way as prior batches — real citations only, honest gaps left honest, a new extractor only after independent confirmation, a ministry abandoned outright when it genuinely has nothing linkable.

- [x] G1: A fifth ministry-specific extractor module built for a genuinely distinct drafting shape not covered by any of the four shared templates — National Pharmaceutical Pricing Authority corrigenda (Ministry of Chemicals and Fertilizers), which name the statutory authority instead of "the Ministry of X", confirmed against three independent real examples in one pass.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_chemicals_fertilizers_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — extract/chemicals_fertilizers_patterns.py reuses find_after_anchor (same reuse pattern as extract/railways_patterns.py) with an NPPA-specific anchor rather than inventing a sixth shared template from one ministry's evidence.

- [x] G2: Ministry of Earth Sciences modeled using an EXISTING template (amendment-in-notification) with zero new extraction code — confirming that template still generalizes to an 11th real ministry.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_earth_sciences_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/earth_sciences_patterns.py, db/seed_earth_sciences.sql. Two further real leads (Group 'A' Recruitment Rules — target has no citation number at all; Scientist 'B' Recruitment Rules — target cited as "G.S.R. 137 RRs", a non-"(E)" form) are real but deliberately not modeled.

- [x] G3: Ministry of Fisheries, Animal Husbandry and Dairying modeled — three real chains, including a genuinely novel combined shape (one notification that both supersedes a prior corrigendum AND re-performs the same correction directly against the original) modeled with two distinct relation_type edges rather than forced through one template.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='fisheries-animal-husbandry-dairying';"
  EXPECT: 18
  EVIDENCE: met — db/seed_fisheries_animal_husbandry.sql, including a 12-node Livestock Importation Act chain (this project's longest S.O.-only chain).

- [x] G4: Ministry of New and Renewable Energy modeled — a real 3-node deadline-extension chain, cited in plain narrative prose rather than any of the four templates' boilerplate, modeled directly in the seed file since only one example of this shape exists (not generalized into a template on one instance, per this project's own rule).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE source_gazette_id IN ('mnre-so-3597-2025','mnre-so-3706-2026');"
  EXPECT: 2
  EVIDENCE: met — db/seed_new_renewable_energy.sql. The chain's true origin (the 2017 Order S.O. 492(E) itself supersedes) is never given a citation number in the real text, so that edge stops at S.O. 492(E) rather than inventing one.

- [ ] G5: Ministry of Panchayati Raj — the tracker lists only 2 total notifications for this ministry, both Resolutions (Hindi Advisory Committee reconstitutions) cited by file number only, with no G.S.R./S.O./S.R.O. anywhere and no amends/corrects/supersedes relationship stated between them (each is triggered independently by a new Lok Sabha's formation).
  EVIDENCE: not modeled — no citable, no relationship, nothing to link.

ABANDON: G5 Confirmed via the ministry's own dedicated listing page plus three targeted site searches (Rashtriya Gram Swaraj Abhiyan, e-Gram Swaraj, Panchayat Enterprise Suite) that all returned zero genuine hits. This is a real finding (a scheme-administration ministry with essentially no statutory rule-making captured by this tracker), not a research shortfall.

- [x] G6: Foreign-key integrity holds across the whole database after 4 new seed files, 2 new extractor modules.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates3.txt; [ ! -s /tmp/fk_check_gates3.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates3.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 31 ministries, 243 notifications, 172 cross-references.

- [x] G7: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 96 passed
  EVIDENCE: met.
