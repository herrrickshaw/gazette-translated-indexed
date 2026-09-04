# Gates: depth-pass batch 4 — Corporate Affairs, Culture, Defence, DoNER, Earth Sciences

OWNS: db/**, docs/**

Scope: depth-pass batch 4 of `docs/DEPTH_PASS_PLAN.md` — go substantially deeper on five already-modeled ministries. No new extractor code needed this batch: every real shape found fit an existing template, generic note-chain, or pure table-citation seed-only modeling.

- [x] G1: Ministry of Corporate Affairs — large expansion across 8 new subject threads (Companies Incorporation Rules, CSR Policy Rules partial chain, Registered Valuers Rules 7-node chain, Removal of Names Rules 9-node chain, a s.458 delegation-of-power series, an LLP Act delegation series, a date-substitution series, IEPFA membership 6-node chain), all fully quoted from primary text. Two leads the research agent itself flagged as summary-sourced (page-extraction truncation reaching only the AI "Detailed Summary") deliberately excluded per the standing no-AI-summary rule.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='corporate-affairs';"
  EXPECT: 60
  EVIDENCE: met — db/seed_mca.sql.

- [x] G2: Ministry of Culture — both known chains (Registering Officers, NMA Rules) re-confirmed still current. 4 new usable subject areas found: a 7-node AMASR Act "competent authority" chain (fully quoted from one Note), two s.35 "ceased to be of national importance" two-stage pairs, three s.4(3) "declared of national importance" two-stage pairs, and a National Culture Fund corrigendum plus its own back-reference to a 1996 vesting order. The two-stage notice-then-declaration pairs are modeled with relation_type='cites' (the later notification acts on the earlier one rather than amending its text), matching the draft-to-final convention used elsewhere in this project.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='culture';"
  EXPECT: 27
  EVIDENCE: met — db/seed_culture.sql. Three further real leads (six bare-form ASI Recruitment Rules supersessions, a committee addendum, a Hindi Advisory Committee resolution) deliberately not modeled — none carry a G.S.R./S.O. number in their own text.

- [x] G3: Ministry of Defence — both known S.R.O. pairs re-confirmed unchanged. 8 new pairs/chains found across Cantonment Board, DRDO Vehicle Operator/Fire Service/Fire Engine Driver/Security Recruitment Rules, and CSD Group A / Group A&B Recruitment Rules — several in genuinely bare pre-"(E)" citation form. Multiple real S.R.O.-number collisions across years/subject-areas discovered and handled by descriptive gazette_id suffixes (e.g. defence-sro-3-2025-cantonment vs defence-sro-3-2026-security) rather than a bare numeric key, avoiding conflation.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT COUNT(DISTINCT gazette_id) FROM gazette_notification WHERE ministry_id='defence' AND gsr_or_so LIKE 'S.R.O. 3%';"
  EXPECT: 2
  EVIDENCE: met — db/seed_defence.sql. The already-deferred bare-form Corrigendum No.11(E) re-confirmed unchanged, still not modeled.

- [x] G4: Department of North Eastern Region (DoNER) — fresh research confirmed the ministry's entire tracked corpus is genuinely still just 1 real citing notification (plus its 2 cited-but-unindexed targets, 3 rows total); no new material exists to find. Recorded as checked, not skipped.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='doner';"
  EXPECT: 3
  EVIDENCE: met — no seed file change needed; corpus exhaustively reviewed.

- [x] G5: Ministry of Earth Sciences — fresh research exhaustively reviewed the ministry's full tracked corpus (no pagination remaining); only the same 1 modeled pair plus 2 already-known but unmodelable leads exist, none newly closeable.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='earth-sciences';"
  EXPECT: 2
  EVIDENCE: met — no seed file change needed; corpus confirmed exhausted.

- [x] G6: Foreign-key integrity holds and the full suite passes after this batch's additions across 5 ministries — no new extractor code needed this round (every real shape fit an existing template, generic note-chain, or pure seed-only table-citation modeling).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates12.txt; [ ! -s /tmp/fk_check_gates12.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates12.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 751 notifications, 536 cross-references; 141 tests passed.
