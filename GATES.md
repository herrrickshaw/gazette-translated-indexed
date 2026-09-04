# Gates: 12th research batch (Batch 12 of the coverage plan) — Parliamentary Affairs, Finance (other departments), Department of Posts — FINAL BATCH

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: batch 12 of `docs/MINISTRY_COVERAGE_PLAN.md` — the last 3 ministries/departments in the plan. Closing this batch means every ministry/department the plan named has been either modeled or honestly abandoned.

- [x] G1: Ministry of Finance's non-Revenue departments (Economic Affairs, Expenditure, Financial Services, DIPAM) modeled as a SEPARATE ministry_id from the existing Revenue/CBIC row (same real ministry name, genuinely different department scope) — one corrigendum plus a note-chain left honestly PARTIAL where only the first and last of 18 listed intermediate amendments were transcribed this session.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_finance_other_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/finance_other_patterns.py, db/seed_finance_other.sql. A third real lead (a cross-department DEA-amends-DFS notification, bare "Notification No." form throughout) deliberately not modeled.

- [x] G2: Ministry of Parliamentary Affairs modeled — two real pairs (an amendment and a supersession, both Aadhaar-authentication rules for the Rajya Sabha and Lok Sabha secretariats), this ministry's only real amendment-linkable activity among ~28 tracked notifications otherwise dominated by staff appointments and standalone recruitment rules.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_parliamentary_affairs_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/parliamentary_affairs_patterns.py, db/seed_parliamentary_affairs.sql.

- [x] G3: Department of Posts modeled as a separate ministry_id from the existing Department of Telecommunications row (both are "Ministry of Communications" but genuinely different departments) — a complete 4-node Post Office Regulations amendment chain, pure note-chain, no new code.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='posts';"
  EXPECT: 4
  EVIDENCE: met — db/seed_posts.sql.

- [x] G4: Foreign-key integrity holds across the whole database — the final rebuild of the entire ministry-coverage effort.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates8.txt; [ ! -s /tmp/fk_check_gates8.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates8.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 412 notifications, 291 cross-references.

- [x] G5: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 137 passed
  EVIDENCE: met.

- [x] G6: Every ministry/department in docs/MINISTRY_COVERAGE_PLAN.md's original 56-entry scope is now accounted for — modeled or honestly abandoned, none left untouched.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM ministry;"
  EXPECT: 53
  EVIDENCE: met — 53 modeled ministry_id rows + 3 documented abandonments (Law and Justice, Tourism, Panchayati Raj) = 56, matching the plan's revised total exactly.
