# Gates: depth-pass batch 8 — MoHUA, MoRTH, MoSPI, MSME, New & Renewable Energy

OWNS: db/**, docs/**

Scope: depth-pass batch 8 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries. No new extractor code needed this batch: every real shape found fit an existing shared template, generic note-chain, or pure seed-only modeling.

- [x] G1: Ministry of Housing and Urban Affairs — 3 new subject areas, ~20 new edges: the other six UT/State RERA General Rules amendments from the same 1 July 2026 batch as the already-modeled Ladakh pair; an NCR Planning Board Act Schedule amendment; and the previously-unmodeled Metro Railways (Construction of Works) Act Schedule-alignment series (Pune Metro a root-plus-three-branch hub whose latest notification carries an explicit primary-source note-chain). The weakest-corroborated pair in the project (Directorate of Estates) found no independent corroboration this pass either — its tier left honestly unchanged.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='housing-and-urban-affairs';"
  EXPECT: 46
  EVIDENCE: met — db/seed_mohua.sql. A cross-ministry citation to a Cabinet Secretariat notification deliberately deferred rather than mis-attributed (no such ministry row exists in this project).

- [x] G1b: A real citation collision (S.O. 2979(E): MoHUA's 2013 NCR Schedule notification vs. Power's 2026 TFL notification, thirteen years apart) correctly kept as 2 distinct rows.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE gsr_or_so='S.O. 2979(E)';"
  EXPECT: 2
  EVIDENCE: met — mohua-so-2979-2013 and power-so-2979-2026 are distinct rows.

- [x] G2: Ministry of Road Transport and Highways — 5 new subject areas beyond the land-acquisition corrigenda, all Central Motor Vehicles Rules or adjacent rule-families, all following a draft-to-final rulemaking preamble (`cites`): Automated Testing Station norms, the Vehicle Scrapping Facility Rules (a 5-node chain with two draft->final cycles), Third Party Insurance Base Premium Rules, a "Category L2-5" vehicle class, and a rule 81 fee-table amendment.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='road-transport-highways';"
  EXPECT: 20
  EVIDENCE: met — db/seed_morth.sql. A 2022 Scrapping Facility amendment cited only by year, and two further 2026 CMVR amendments not opened this pass, deliberately not modeled.

- [x] G3: Ministry of Statistics and Programme Implementation — 4 new subject areas from a genuinely small (44-notification) corpus: an ISI Act Committee amendment, the ASI 2023-24 notification independently amended twice (closing the deferred S.O. 4544(E) lead via a File-No.+date cross-match against the target's own text), the NSS North-East Monitoring Committee's two successive reconstitutions each superseding the same two predecessors, and the ACNAS reconstitution's bare-file-number corrigendum chain cross-matched by e-Gazette press ID.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='statistics-and-programme-implementation';"
  EXPECT: 16
  EVIDENCE: met — db/seed_mospi.sql. A recurring MoSPI house style (Rules/guidelines superseding their predecessor by title/year only, three independent instances) documented and deliberately not modeled.

- [x] G4: Ministry of MSME — a CORRECTION to an existing edge (S.O. 3820(E)'s own operative clause targets S.O. 3193(E) directly, not S.O. 5403(E); both now correctly amend the principal independently), plus 3 new subject threads: a TReDS onboarding-mandate supersession (one preamble, two targets), a KVIC s.9(3) government-representative supersession, and a Recruitment Rules corrigendum that closes the deferred "GSR 381" lead as a dated bare-form citation.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE source_gazette_id='msme-so-3820-2023' AND target_gazette_id='msme-so-3193-2022';"
  EXPECT: 1
  EVIDENCE: met — db/seed_msme.sql; the old 3820->5403 edge is gone, 12 notifications total for the ministry.

- [x] G5: Ministry of New and Renewable Energy — the documented gap resolved: the 2017 Compulsory Registration Order's own citation number (S.O. 2920(E)) is given directly in three further real documents, yielding a parallel >100kW SPV-inverter self-certification chain (6 nodes, 9 edges) alongside the already-modeled >200kW chain. Five real instances of this ministry's narrative-prose extension shape now exist — enough to justify a shared extractor template in a future pass.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='new-and-renewable-energy';"
  EXPECT: 9
  EVIDENCE: met — db/seed_new_renewable_energy.sql. gazettetracker's entire MNRE corpus is 13 notifications; a standalone Solar Thermal QCO and six Aadhaar/DBT notifications carry no citation language and are not modeled.

- [x] G6: Foreign-key integrity holds and the full suite passes after this batch's additions across 5 ministries — no new extractor code needed this round.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates16.txt; [ ! -s /tmp/fk_check_gates16.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates16.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 1322 notifications, 1003 cross-references; 141 tests passed.
