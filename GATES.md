# Gates: depth-pass pilot — Ministry of Power

OWNS: db/**, extract/**, tests/**, docs/**

Scope: pilot a "depth pass" — go substantially deeper on one already-modeled ministry (beyond the original bounded 2-3-pair research), to establish the process before replicating it across all 53 modeled ministries.

- [x] G1: Close both documented open threads from the first Ministry of Power pass — the JERC chain's missing intermediate date (G.S.R. 488(E)) and the unverified TFL companion pair (S.O. 2979(E)/S.O. 1033(E)).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE gazette_id IN ('power-gsr-488-2021','power-so-1033-2018','power-so-2979-2026');"
  EXPECT: 3
  EVIDENCE: met — db/seed_power.sql. G.S.R. 488(E) dated 2021-07-13, confirmed as the real intermediate JERC amendment; S.O. 2979(E) repeals S.O. 1033(E), verified with its own primary-text quote, the same shape as the already-known S.O. 2978(E)/S.O. 1034(E) pair.

- [x] G2: At least 5 genuinely new real pairs/chains found beyond the two closed threads, across subject areas the first pass never touched.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(DISTINCT thread_id) FROM gazette_notification WHERE ministry_id='power';"
  EXPECT: 11
  EVIDENCE: met — 8 new real pairs/chains found (exceeding the 5-pair target): LED lamp Standards & Labelling (amendment chain + separate supersession), induction hob Standards & Labelling, a transmission-scheme modify, a transmission-scheme de-notify, Bhakra Beas Management Board Rules, Electricity Rules 2005 (captive generation), and Energy Conservation Rules 2012 (PAT scheme) — 11 subject threads total (3 original + 8 new).

- [x] G3: extract/power_patterns.py extended to catch two real shapes the original module's single template missed (a bare "hereby repeals" clause and a "further to amend" clause, neither containing "makes the following amendment"), reusing the existing corrigendum-substitution template rather than writing new extraction code — confirmed against real text before generalizing.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_power_patterns.py -q
  EXPECT: 5 passed
  EVIDENCE: met — including a regression check that the pre-existing "powers conferred" false-positive guard still holds after adding the new template call.

- [x] G4: A stray, out-of-context Note fragment found mid-document (an "S.O. 1033(E)" reference embedded inside unrelated LED-lamp text) is correctly excluded as a likely drafting/copy-paste artifact in the source gazette, not modeled as a real cross-reference.
  EVIDENCE: met — flagged explicitly by the research agent and left out of db/seed_power.sql; the two genuinely bare-form leads found (a transmission order citing only a raw Gazette ID, a CEA de-notification citing only a File No.+date) are likewise documented as deliberately unmodeled.

- [x] G5: Foreign-key integrity holds and the full suite passes after nearly 6x'ing Ministry of Power's row count (6 notifications/3 edges to 34 notifications/22 edges).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates9.txt; [ ! -s /tmp/fk_check_gates9.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates9.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 440 notifications, 310 cross-references; 139 tests passed.
