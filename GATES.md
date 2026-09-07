# Gates: register_new.py + 6 ministry depth-pass return trips

OWNS: ingest/register_new.py, tests/test_register_new.py, db/seed_department_of_space.sql, db/seed_youth_affairs_sports.sql, db/seed_consumer_affairs.sql, db/seed_defence.sql, db/seed_external_affairs.sql, db/seed_wcd.sql, extract/**, tests/test_*_patterns.py, GATES.md

Scope: (1) a script that registers a bare gazette_notification row for every genuinely new gazette_id a freshness check turns up, decoupled from cross-reference modeling; (2) a bounded depth pass (real corrigendum/amendment/supersession pairs found via gazettetracker.com's Full Text, extractor + regression test + seed data, per docs/DEPTH_PASS_PLAN.md's established rhythm) on each of 6 old-but-thin ministries identified in docs/HISTORICAL_COVERAGE.md. Baseline notification counts (2026-09-07, before this ledger's work): department-of-space=4, youth-affairs-and-sports=4, consumer-affairs-food-public-distribution=26, defence=27, external-affairs=23, women-child-development=20.

- [x] G1: ingest/register_new.py exists, calls db/crud.py's create_notification() for each new item, and its own test suite passes
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -m pytest tests/test_register_new.py -q && echo REGISTER_NEW_TESTS_OK
  EXPECT: REGISTER_NEW_TESTS_OK
  EVIDENCE: exit=0; EXPECT=matched; 14/14 tests passed

- [x] G2: Department of Space grew beyond its 4-notification baseline with real, quoted cross-references
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -c "import sqlite3; n=sqlite3.connect('gazette.db').execute(\"SELECT COUNT(*) FROM gazette_notification WHERE ministry_id='department-of-space' AND archived_at IS NULL\").fetchone()[0]; print('GROWTH_OK' if n > 4 else f'GROWTH_FAIL n={n}')"
  EXPECT: GROWTH_OK
  EVIDENCE: exit=0; EXPECT=matched; n=5 (S.O. 2018(E) added, closing row 39 of the ministry's own Note table, sourced via a direct primary-source PDF fetch)

- [ ] G3: Ministry of Youth Affairs and Sports grew beyond its 4-notification baseline with real, quoted cross-references
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -c "import sqlite3; n=sqlite3.connect('gazette.db').execute(\"SELECT COUNT(*) FROM gazette_notification WHERE ministry_id='youth-affairs-and-sports' AND archived_at IS NULL\").fetchone()[0]; print('GROWTH_OK' if n > 4 else f'GROWTH_FAIL n={n}')"
  EXPECT: GROWTH_OK
  EVIDENCE: GROWTH_FAIL n=4 (expected -- see ABANDON below)

ABANDON: G3 Independently re-verified corpus exhaustion. This ministry was already noted "checked, corpus exhausted" in docs/DEPTH_PASS_PLAN.md from a pass 2 days prior; this run re-confirmed from scratch rather than trusting that note: re-pulled the full 24-item gazettetracker.com listing (unchanged), then -- since gazettetracker's Full Text pages are now login-gated, a real change since the prior pass -- fetched all 20 not-yet-modeled items directly from egazette.gov.in's own deterministic PDF URLs, extracted text, and grepped for every citation keyword this project's templates recognize (G.S.R./S.O., "supersession," "partial modification," "rescind," "corrigendum," "substituted," "Note:," "vide," etc.). None hit: the NSGA/NADA rule-making wave are first-instance rules with no prior-instrument citation, and the Aadhaar-DBT notifications cite only a bare, non-G.S.R./S.O. Cabinet Secretariat OM number, outside this project's schema. Only db/seed_youth_affairs_sports.sql's header comment changed (a second confirmation paragraph).

- [x] G4: Ministry of Consumer Affairs, Food and Public Distribution grew beyond its 26-notification baseline with real, quoted cross-references
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -c "import sqlite3; n=sqlite3.connect('gazette.db').execute(\"SELECT COUNT(*) FROM gazette_notification WHERE ministry_id='consumer-affairs-food-public-distribution' AND archived_at IS NULL\").fetchone()[0]; print('GROWTH_OK' if n > 26 else f'GROWTH_FAIL n={n}')"
  EXPECT: GROWTH_OK
  EVIDENCE: exit=0; EXPECT=matched; n=52 (3 new real chains: 8-node Aadhaar-seeding S.O. 371(E) deadline-extension series, 10-node Warehousing Rules chain, 4-node NCDRC Recruitment Rules chain; found and fixed a real extractor gap -- a "further amendments" anchor variant -- in the shared amendment-in-notification template)

- [x] G5: Ministry of Defence grew beyond its 27-notification baseline with real, quoted cross-references
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -c "import sqlite3; n=sqlite3.connect('gazette.db').execute(\"SELECT COUNT(*) FROM gazette_notification WHERE ministry_id='defence' AND archived_at IS NULL\").fetchone()[0]; print('GROWTH_OK' if n > 27 else f'GROWTH_FAIL n={n}')"
  EXPECT: GROWTH_OK
  EVIDENCE: exit=0; EXPECT=matched; n=32 (new drafting convention found: Cantonment Board "constitution" notifications citing the preceding "variation" notification via `cites`; a third Recruitment Rules chain)

- [x] G6: Ministry of External Affairs grew beyond its 23-notification baseline with real, quoted cross-references
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -c "import sqlite3; n=sqlite3.connect('gazette.db').execute(\"SELECT COUNT(*) FROM gazette_notification WHERE ministry_id='external-affairs' AND archived_at IS NULL\").fetchone()[0]; print('GROWTH_OK' if n > 23 else f'GROWTH_FAIL n={n}')"
  EXPECT: GROWTH_OK
  EVIDENCE: exit=0; EXPECT=matched; n=37 (closed all 4 UNSC-sanctions Order leads -- DRC, Libya, Haiti, Iraq -- flagged-not-fabricated by the original pass, each independently opened and quoted; plus one gap closure on the existing baseline-coordinates thread)

- [ ] G7: Ministry of Women and Child Development grew beyond its 20-notification baseline with real, quoted cross-references
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -c "import sqlite3; n=sqlite3.connect('gazette.db').execute(\"SELECT COUNT(*) FROM gazette_notification WHERE ministry_id='women-child-development' AND archived_at IS NULL\").fetchone()[0]; print('GROWTH_OK' if n > 20 else f'GROWTH_FAIL n={n}')"
  EXPECT: GROWTH_OK
  EVIDENCE: GROWTH_FAIL n=20 (expected -- see ABANDON below)

ABANDON: G7 Genuine third-pass check found nothing new. Re-read the ministry's full 11-item gazettetracker.com corpus via primary Full Text (never AI summary): the 3 items with amendment-sounding titles all turned out to be notifications already modeled (S.O. 4423(E), the Hindi Advisory Committee resolution, G.S.R. 75(E)); the other 8 are confirmed non-citational (appointments, tenure notices, a body rename, scheme closures). Verified the Adoption Regulations 2022 still cites its 2017 predecessor by title only (no G.S.R. number, correctly unmodeled) and that both existing chains (JJ Rules, NCPCR Rules) have no later amendment as of Sept 2026. Only db/seed_wcd.sql's header comment changed (documenting this pass).

- [x] G8: whole repo still self-consistent after all changes -- FK integrity clean and full test suite green
  CHECK: cd /Users/umashankar/gazette-translated-indexed && ~/.venvs/gazette-trail/bin/python -m pytest tests/ -q && test -z "$(sqlite3 gazette.db 'PRAGMA foreign_key_check;')" && echo REPO_CONSISTENT
  EXPECT: REPO_CONSISTENT
  EVIDENCE: exit=0; EXPECT=matched; 183 passed, FK check clean -- re-verified after all 6 depth passes landed

<!--
G2-G7 are independently abandonable: gazettetracker.com's coverage of a
ministry is whatever it happened to index, not that ministry's complete
history (see docs/MINISTRY_COVERAGE_PLAN.md's own "Known limits"). If a
bounded research pass genuinely finds nothing new and citable (checked, not
assumed) for a given ministry, add an ABANDON line naming that gate's id and
stating what was checked and why nothing new/citable turned up, then move
on -- same discipline MINISTRY_COVERAGE_PLAN.md used for Law and Justice,
Tourism, and Panchayati Raj. Abandonment is a documented, honest outcome
here, not a failure to hide.

Final: 6 met (G1, G2, G4, G5, G6, G8), 2 honestly abandoned (G3, G7) --
both re-confirmed exhausted by an independent second (G3's third overall)
check, not assumed from the prior pass's verdict.
-->
