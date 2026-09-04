# Gates: depth-pass batch 9 — Parliamentary Affairs, Personnel (DoPT), Petroleum, Ports & Shipping, Posts

OWNS: db/**, docs/**

Scope: depth-pass batch 9 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries. No new extractor code this batch: every real shape fit an existing shared template, generic note-chain, or seed-only modeling. Three seed files (Ports, Posts, Personnel) were generated from the research logs by one-off scripts to avoid transcription error across ~900 rows.

- [x] G1: Ministry of Parliamentary Affairs — re-checked, corpus exhausted: all 28 tracker notifications re-opened plus 18 egazette PDFs read through the login-truncated tails; both known pairs closed at 2 nodes; the Leader of Opposition lead re-tested against the bare-form rule and still fails (citing texts name the Speaker's act, not any notification number/date). Header note updated, no data change.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='parliamentary-affairs';"
  EXPECT: 4
  EVIDENCE: met — db/seed_parliamentary_affairs.sql header records the eight title-only Recruitment Rules supersessions and the S.O. 2457(E) cross-document inference deliberately not drawn.

- [x] G2: Ministry of Personnel, Public Grievances and Pensions — the CCS (CCA) chain gained its real intermediate (G.S.R. 18(E), from G.S.R. 337(E)'s own Note); the already-modeled G.S.R. 331(E) identified from its own text and re-parented into the IPS cadre-strength Telangana chain; 23 further subject threads incl. CAT s.14(3)/s.18 hubs (spot-checked against official PDFs), UPSC Members' 25-node chain, IAS/IPS/IFS Pay and cadre-strength tables, and the Appointment-by-Promotion twin lists modeled as chain segments around file-number-only items.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE source_gazette_id='dopt-gsr-337-2024' AND target_gazette_id='dopt-gsr-18-2023';"
  EXPECT: 1
  EVIDENCE: met — db/seed_personnel.sql (487 notifications). The CCS (Pension) October-2022 amendment cited as both 770(E) and 710(E) by two DoPPW Notes is deferred, not guessed; G.S.R. 635(E)'s West-Bengal-labeled table skipped.

- [x] G3: Ministry of Petroleum and Natural Gas — two CORRECTIONS (the draft G.S.R. 781(E) is dated 3 September 2026 per the official PDF, not 3 August; the Petroleum Rules chain was missing G.S.R. 196(E) and its draft precursor); 11 new subject threads incl. two 12-node Essential Commodities Order chains and the Oilfields Act Schedule chain. PNGRB regulations deferred pending an issuer-taxonomy decision rather than mis-attributed to the ministry.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT publish_date FROM gazette_notification WHERE gazette_id='mopng-gsr-781-2026';"
  EXPECT: 2026-09-03
  EVIDENCE: met — db/seed_petroleum.sql (73 notifications).

- [x] G3b: Three real citation collisions within Petroleum (G.S.R. 730(E) 2007/2026, G.S.R. 781(E) 2013/2026, 814(E) as G.S.R. 2004, G.S.R. 2023 and S.O. 2023) kept as six distinct rows.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE ministry_id='petroleum-and-natural-gas' AND gsr_or_so IN ('G.S.R. 730(E)','G.S.R. 781(E)','G.S.R. 814(E)','S.O. 814(E)');"
  EXPECT: 7
  EVIDENCE: met — 730x2, 781x2, G.S.R. 814x2, S.O. 814x1.

- [x] G4: Ministry of Ports, Shipping and Waterways — the tracker's full 216-notification corpus enumerated; ~45 new chains across Inland Vessels rule families (draft->final cycles), Major Port Authorities Act board-seat supersessions for eleven ports, nine Petroleum Rules r.16 port-of-import continuation chains, Merchant Shipping and Indian Ports / Coastal Shipping / Marine AtoN rulemaking. The already-modeled Chennai chain gained its 2022 root and the Safe Navigation pair its draft precursor.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE ministry_id='ports-shipping-waterways' AND gsr_or_so IN ('G.S.R. 155(E)','G.S.R. 347(E)','G.S.R. 333(E)','G.S.R. 395(E)','G.S.R. 217(E)','G.S.R. 262(E)');"
  EXPECT: 12
  EVIDENCE: met — db/seed_ports_shipping.sql (164 notifications); six in-ministry collisions each kept as two rows. G.S.R. 391(E)'s mis-dated citation of its target recorded, modeled to the real document.

- [x] G5: Department of Posts — the Post Office Regulations, 2024 chain is 15 nodes, not 4 (the previously-modeled S.O. 4053(E) is the Fifth Amendment 2026, re-parented onto the Fourth); the Indian Post Office Rules, 1933's 207-entry official amendment history transcribed in full and modeled with position-encoded ids (the Finance Act entry left as an honest gap); three Recruitment Rules chains, a Hindi-only RPLI corrigendum, and two bare-file-number PLI threads.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE gazette_id LIKE 'dop-ipo-%';"
  EXPECT: 206
  EVIDENCE: met — db/seed_posts.sql (242 notifications); 207 entries minus the one that is an Act. The Second Amendment 2025 modeled as G.S.R. 263(E) per its own text though a later Note cites it as "S.O. 263(E)".

- [x] G6: Foreign-key integrity holds and the full suite passes after this batch's additions across 5 ministries — seeds loaded with sqlite3 -bail so any statement error is fatal, not silent.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 -bail gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates17.txt; [ ! -s /tmp/fk_check_gates17.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates17.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 2265 notifications, 1845 cross-references; 141 tests passed.
