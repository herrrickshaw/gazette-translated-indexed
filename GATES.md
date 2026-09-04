# Gates: 10th research batch (Batch 10 of the coverage plan) — Science/Tech, Space, Atomic Energy, Jal Shakti, Information/Broadcasting

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: batch 10 of `docs/MINISTRY_COVERAGE_PLAN.md` — research, review, and model these 5 ministries/departments the same way as prior batches; fix a real regex bug found this batch before it could silently drop data.

- [x] G1: Fixed a real bug in the note-chain anchor — real Ministry of Information and Broadcasting text closes with "Footnote:" instead of "Note:", which `\bnote\b` structurally cannot match (no word boundary between "t" in "Foot" and "n" in "note"). Now recognized without breaking the existing "noteworthy is not a false anchor" guarantee.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_note_chain.py -q
  EXPECT: 9 passed
  EVIDENCE: met — extract/common_templates.py's `_NOTE_ANCHOR` regex, tests/test_note_chain.py::test_footnote_variant_is_recognized.

- [x] G2: Ministry of Science and Technology modeled — two real note-chains, one with a bare (no "(E)") principal citation, modeled per the established WCD/DoPT precedent. A third real lead (SERB rescission of two bare-form notifications) deliberately not modeled.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='science-and-technology';"
  EXPECT: 4
  EVIDENCE: met — db/seed_science_technology.sql, pure seed-only.

- [x] G3: Department of Space modeled — the tracker has only 2 notifications for it; the one real amendment is modeled as a genuinely PARTIAL chain (the Note's 39-link table history isn't individually re-verifiable from the single row quoted, so only the fully-unambiguous endpoints are linked).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE source_gazette_id='dos-so-5979-2025';"
  EXPECT: 1
  EVIDENCE: met — db/seed_space.sql.

- [x] G4: Department of Atomic Energy modeled — three real pairs, two via the existing amendment-in-notification template (DAE is not "a Ministry of X", confirming the template's scope guard is a plain substring check, not tied to the word "ministry").
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_atomic_energy_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/atomic_energy_patterns.py, db/seed_atomic_energy.sql.

- [x] G5: Ministry of Jal Shakti modeled — two amendments via the existing template (needing BOTH the current ministry name and its pre-2019 predecessor name, since one real 2025 notification still cites the old one) plus the longest chain in this project: 36 nodes, the Ravi and Beas Waters Tribunal's near-annual deadline-extension history from 1986-2026, generated programmatically from one verbatim quote to avoid transcription error.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='jal-shakti';"
  EXPECT: 40
  EVIDENCE: met — extract/jal_shakti_patterns.py, db/seed_jal_shakti.sql.

- [x] G6: Ministry of Information and Broadcasting modeled — three real pairs, two corrigenda (one using the full ministry name, one a shortened "Ministry of Information" alone — both tried and merged) and the note-chain whose "Footnote:" anchor motivated G1.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_information_broadcasting_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/information_broadcasting_patterns.py, db/seed_information_broadcasting.sql.

- [x] G7: Foreign-key integrity holds across the whole database after 5 new seed files (one with 36 programmatically-generated rows) and 3 new extractor modules.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates6.txt; [ ! -s /tmp/fk_check_gates6.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates6.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 46 ministries, 373 notifications, 267 cross-references.

- [x] G8: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 126 passed
  EVIDENCE: met.
