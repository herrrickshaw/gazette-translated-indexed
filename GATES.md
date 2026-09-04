# Gates: depth-pass batch 6 — Health, Heavy Industries, Information & Broadcasting, Jal Shakti, Labour

OWNS: db/**, docs/**

Scope: depth-pass batch 6 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries. No new extractor code needed this batch: every real shape found fit an existing shared template, generic note-chain, or pure seed-only note-chain/table-citation modeling.

- [x] G1: Ministry of Health and Family Welfare — closed a deferred lead (the G.S.R. 587(E) draft's own page was found, completing a draft->corrigendum->final chain); 6 new subject threads found, including two independent National Medical Commission Act appointment "hubs" and the PCPNDT Act Central Supervisory Board's ~30-year note-chain.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='health-family-welfare';"
  EXPECT: 34
  EVIDENCE: met — db/seed_health.sql. gazettetracker.com's "Cite This Gazette" widget was found unreliable on this ministry's amendments (prints the target's number, not the citing document's own) — every citation was taken from the Full Text body's own opening line instead.

- [x] G2: Ministry of Heavy Industries — 7 new subject threads found, plus confirmation that PLI-Auto's S.O. 3946(E) is a hub independently amended by three separate later notifications, and that PM E-DRIVE has a genuine substantive amendment beyond the already-modeled Hindi corrigendum.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='heavy-industries';"
  EXPECT: 29
  EVIDENCE: met — db/seed_heavy_industries.sql.

- [x] G3: Ministry of Information and Broadcasting — 8 new subject threads plus two new edges on already-known nodes; the richest find is a 29-node Cable Television Networks Rules, 1994 chain cross-checked against three independently-opened documents.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='information-and-broadcasting';"
  EXPECT: 61
  EVIDENCE: met — db/seed_information_broadcasting.sql.

- [x] G3b: Two real citation-number collisions found within the Cable TV Rules chain (G.S.R. 459(E) reused 1996/2006; G.S.R. 719(E) reused 2000/2023) and correctly kept as 4 distinct rows via chain-position-encoded gazette_ids, not conflated.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE gsr_or_so IN ('G.S.R. 459(E)','G.S.R. 719(E)');"
  EXPECT: 4
  EVIDENCE: met — 4 distinct gazette_id rows confirmed.

- [x] G4: Ministry of Jal Shakti — 9 further real subject threads found, several comparable in scale to the already-modeled 36-node Ravi-Beas chain (Krishna WDT ~19 nodes, Mahadayi WDT 14 nodes); the already-modeled Clean Ganga schedule thread gained 3 real intermediate amendments, extending it to 6 nodes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='jal-shakti';"
  EXPECT: 94
  EVIDENCE: met — db/seed_jal_shakti.sql. A genuinely partial chain (Krishna WDT runs through a real but uncitable unnumbered 2014 MoWR order) is left honestly split rather than bridged; a real file-number reuse across three distinct Resolutions is handled with date+subject-qualified gazette_ids, not conflated.

- [x] G5: Ministry of Labour and Employment — all three deferred leads from the first pass now confirmed, with one real citation correction (the third lead's true number is G.S.R. 705(E), not the previously-recorded G.S.R. 706(E)); 9 further new pairs/chains found, including this ministry's first `rescinds` pairs (two DGMS byelaw rescissions).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='labour-and-employment';"
  EXPECT: 27
  EVIDENCE: met — db/seed_labour.sql. A real extraction-pipeline gap was found and flagged (not fixed this batch): two of the new corrigenda are entirely Hindi-language documents with no English rendering, which the current English-only extractor would silently miss.

- [x] G6: Foreign-key integrity holds and the full suite passes after this batch's additions across 5 ministries — no new extractor code needed this round (every real shape fit an existing shared template, generic note-chain, or pure seed-only table-citation modeling).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates14.txt; [ ! -s /tmp/fk_check_gates14.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates14.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 1097 notifications, 819 cross-references; 141 tests passed.
