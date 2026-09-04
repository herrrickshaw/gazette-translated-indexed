# Gates: depth-pass batch 7 — MeitY, MHA, Mines, Minority Affairs, MoEFCC

OWNS: db/**, docs/**

Scope: depth-pass batch 7 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries. No new extractor code needed this batch: every real shape found fit an existing shared template, generic note-chain, or pure seed-only note-chain/table-citation modeling.

- [x] G1: Ministry of Electronics and Information Technology — the already-modeled G.S.R. 120(E)/148(E) corrigendum turned out to sit at the end of a longer real IT Intermediary Guidelines Rules chain (3 further real predecessors found); the deferred G.S.R. 892(E)/846(E) lead closed and extended into a draft-to-final chain; 5 further new subject threads, the richest a 13-node Electronics & IT Goods Compulsory Registration Order chain.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='electronics-and-information-technology';"
  EXPECT: 29
  EVIDENCE: met — db/seed_meity.sql.

- [x] G2: Ministry of Home Affairs — both deferred leads confirmed (S.O. 4583(E)'s real one-to-many rescission/disapplication; the bare-file-number "Amendment to Resolution" shape, now with two independent real instances); 13 further new pairs/chains, including a rich FCRR 2011 Note-chain (the concrete example needed to confirm the trailing-Note template design) and a genuinely novel UAPA Tribunal-confirmation preamble.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='home-affairs';"
  EXPECT: 49
  EVIDENCE: met — db/seed_mha.sql. A real aggregator mislabel was caught and correctly bypassed: a corrigendum's site-assigned subject line named the already-modeled S.O. 3987(E) as its target, but the Full Text's actual target is the unrelated S.O. 3986(E) (one digit apart, different subject) — modeled per Full Text.

- [x] G3: Ministry of Mines — the already-modeled Concession Rules corrigendum thread turned out to be part of a much longer 17-node real chain (principal now confirmed as 2016, not year-unknown); 8 further new subject threads, including the Central Geoscience Programming Board Resolution — a genuinely novel shape where one new resolution supersedes an entire prior chain of six resolutions at once.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='mines';"
  EXPECT: 62
  EVIDENCE: met — db/seed_mines.sql.

- [x] G3b: A real citation collision found within Mines (G.S.R. 682(E) denotes two unrelated documents, the 5th Atomic Minerals Concession amendment and the wholly separate Adjudication of Penalties Rules) and correctly kept as 2 distinct rows, not conflated.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE gsr_or_so='G.S.R. 682(E)' AND ministry_id='mines';"
  EXPECT: 2
  EVIDENCE: met — 2 distinct gazette_id rows confirmed.

- [x] G4: Ministry of Minority Affairs — 2 brand-new note-chains found (Haj Committee Rules, 2002 — distinct from the already-modeled Act-composition chain; Haj Committee Act s.41 Schedule/Zones); 2 new nodes extending the existing Haj composition chain, one of which exposed a real gap in the Ministry's own record-keeping (a genuine amendment the Ministry's own later Notes consistently omit from their historical recitals).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='minority-affairs';"
  EXPECT: 24
  EVIDENCE: met — db/seed_minority_affairs.sql.

- [x] G5: Ministry of Environment, Forest and Climate Change — given this ministry's own documented aggregator-mismatch history, this pass deliberately preferred the official egazette.gov.in PDF over aggregator text; 3 new subject areas found beyond simple corrigenda (Plastic Waste Management Rules 5-amendment chain with 3 draft precursors; Coastal Regulation Zone Notification supersession; E-Waste Rules two-generation supersession lineage).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='environment-forest-climate-change';"
  EXPECT: 24
  EVIDENCE: met — db/seed_moefcc.sql.

- [x] G5b: A real citation collision found within MoEFCC (G.S.R. 522(E) denotes the 2022 Plastic Waste Management amendment and the already-modeled 2023 corrigendum) and correctly kept as 2 distinct rows, not conflated.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE gsr_or_so='G.S.R. 522(E)' AND ministry_id='environment-forest-climate-change';"
  EXPECT: 2
  EVIDENCE: met — 2 distinct gazette_id rows confirmed.

- [x] G6: Foreign-key integrity holds and the full suite passes after this batch's additions across 5 ministries — no new extractor code needed this round (every real shape fit an existing shared template, generic note-chain, or pure seed-only table-citation modeling).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates15.txt; [ ! -s /tmp/fk_check_gates15.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates15.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 1244 notifications, 938 cross-references; 141 tests passed.
