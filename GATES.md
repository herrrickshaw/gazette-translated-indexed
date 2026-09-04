# Gates: depth-pass batch 3 — Coal, Commerce/Industry, Communications, Consumer Affairs, Cooperation

OWNS: db/**, docs/**

Scope: depth-pass batch 3 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries. No new extractor code needed this batch: every real shape found fit an existing template or pure note-chain/table-citation seed-only modeling.

- [x] G1: Ministry of Coal — the Coal Mines Pension Scheme's 15-item gap (items 2-16, previously undocumented) fully closed with the complete real 18-item Note list (generated programmatically to avoid transcription error), plus 5 further real pairs/chains across new subject areas (Coal Bearing Areas Act, Mineral Concession Rules, Coal Mines Special Provisions Rules, MMDR Act, a draft-to-final Adjudication of Penalties Rules pair).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='coal';"
  EXPECT: 33
  EVIDENCE: met — db/seed_coal.sql.

- [x] G2: Ministry of Commerce and Industry — both known chains (SEZ Rules, Ammonium Nitrate Rules) confirmed to have no further amendments; 6 further real pairs/chains found, including 5 Special Economic Zone area-adjustment chains (a genuinely distinct real citation format — a "WHEREAS ... as per the details given below" table listing every prior de-notification — not forced into any existing template on one ministry's evidence) and the Ammonium Nitrate chain's own draft precursor.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='commerce-and-industry';"
  EXPECT: 30
  EVIDENCE: met — db/seed_commerce_industry.sql. A real source-text date discrepancy (the same citation given two different dates across two documents) is recorded as an observed oddity, not resolved by picking one.

- [x] G3: Ministry of Communications — the open question about G.S.R. 796(E) vs. G.S.R. 771(E) resolved: independently confirmed word-for-word duplicate publication of the same rules. A REAL CITATION COLLISION found and modeled correctly: a different, unrelated "G.S.R. 796(E)" from 2020 exists in a separate TRAI rules chain — kept as a distinct row rather than conflated. 6 further real pairs/chains across 4 new subject areas.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE gsr_or_so='G.S.R. 796(E)';"
  EXPECT: 2
  EVIDENCE: met — db/seed_communications.sql. A supersession edge inferred only from a DIFFERENT document's context (not stated in the citing document's own text) is deliberately not modeled — same discipline applied to a near-identical case in Cooperation this same batch.

- [x] G4: Ministry of Consumer Affairs, Food and Public Distribution — both known chains confirmed to have no further amendments; 8 further real pairs/chains across both departments (BIS hallmarking, two further Legal Metrology Act rule families, and four Essential Commodities Act orders for edible oil, sugarcane, food security, and TPDS). A real non-standard pre-modern principal citation (Sugarcane Control Order, 1966) modeled as a bare row per established precedent.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='consumer-affairs-food-public-distribution';"
  EXPECT: 26
  EVIDENCE: met — db/seed_consumer_affairs.sql. A Sugar (Control) Order, 2025 supersession citing two predecessor orders by title only (no G.S.R./S.O. number for either) is deliberately not modeled.

- [x] G5: Ministry of Cooperation — the ministry's ENTIRE 19-notification tracked history reviewed. A real chain extension (Tribhuvan University Executive Council, now 3 links) and a real sibling discovery: the same 2020 target notification (G.S.R. 427(E), already modeled under Agriculture) turns out to have been split into TWO separate 2024 replacement notifications (General Council, already known; Board of Management, newly found) — modeled as two independent supersession edges from the same real target.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE target_gazette_id='moa-gsr-427-2020';"
  EXPECT: 2
  EVIDENCE: met — db/seed_cooperation.sql. Two further real leads deliberately not modeled: one whose citing document names its target only by title (the same "citing document must state the citation itself" discipline just applied to Communications), one whose Full Text could not be extracted at all (genuinely unverified, not just weakly cited).

- [x] G6: Foreign-key integrity holds and the full suite passes after this batch's additions across 5 ministries — no new extractor code needed this round (every real shape fit an existing template, generic note-chain, or pure seed-only table-citation modeling).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates11.txt; [ ! -s /tmp/fk_check_gates11.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates11.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 656 notifications, 472 cross-references; 141 tests passed.
