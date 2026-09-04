# Gates: 11th research batch (Batch 11 of the coverage plan) — Youth Affairs/Sports, Education, Cooperation, DoNER

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: batch 11 of `docs/MINISTRY_COVERAGE_PLAN.md` — research, review, and model the last 5 dispatched ministries; fold School Education and Higher Education into one real ministry rather than double-counting, per the plan's own stated exception.

- [x] G1: Ministry of Education modeled as ONE ministry (not two) — School Education and Literacy and Higher Education share one real ministry (the 2020 MHRD merger) and one gazettetracker.com listing. Six real pairs across both departments, needing the amendment-in-notification template under both the current and pre-2020 predecessor ministry names, plus corrigendum-substitution for a rescission-shaped example.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_education_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — extract/education_patterns.py, db/seed_education.sql. A seventh real lead (CIET/NCERT Recruitment Rules) cites its target with no citation number of any kind and is deliberately not modeled.

- [x] G2: Ministry of Youth Affairs and Sports modeled — one real pair, a genuine one-to-many example (one clause naming three predecessor notifications at once), confirming corrigendum-substitution's window scan already handles this shape correctly (same pattern as Ministry of Culture's first real example).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_youth_affairs_sports_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/youth_affairs_sports_patterns.py, db/seed_youth_affairs_sports.sql. This ministry's real 2025-26 gazette activity is dominated by fresh subordinate legislation (not amendments) — a checked finding, not a research gap.

- [x] G3: Ministry of Cooperation modeled — two real pairs, one a genuine cross-ministry chain (its own principal notification, issued in 2020, supersedes a prior Ministry of Agriculture and Farmers Welfare notification, since Cooperation didn't exist as a separate ministry until 2021) recorded under the Agriculture ministry_id already defined, not invented as a Cooperation row.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_cooperation_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/cooperation_patterns.py, db/seed_cooperation.sql.

- [x] G4: Ministry of Development of North Eastern Region (DoNER) modeled — the tracker has only 1 total notification for it; a real double-target supersession, fully covered by the existing generic supersession-preamble template with no new code.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE source_gazette_id='doner-so-713-2024';"
  EXPECT: 2
  EVIDENCE: met — db/seed_doner.sql, pure seed-only.

- [x] G5: Foreign-key integrity holds across the whole database after 4 new seed files (one folding two research passes into one ministry, one spanning two ministries) and 3 new extractor modules.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates7.txt; [ ! -s /tmp/fk_check_gates7.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates7.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 50 ministries, 398 notifications, 283 cross-references.

- [x] G6: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 133 passed
  EVIDENCE: met.
