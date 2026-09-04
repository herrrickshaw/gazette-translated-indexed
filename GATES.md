# Gates: 8th research batch — MSME, Heavy Industries, Food Processing, Minority Affairs, Tribal Affairs

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: research, review, and model the next 5 ministries the same way as prior batches — real citations only, honest gaps left honest, an existing template reused wherever the real text actually fits it rather than reflexively writing new code.

- [x] G1: Ministry of MSME modeled entirely with the EXISTING amendment-in-notification and note-chain templates — zero new extraction code, confirming both templates still generalize (12th/13th real ministries respectively).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_msme_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/msme_patterns.py, db/seed_msme.sql. A third real lead (Recruitment Rules corrigendum citing "GSR 381", no "(E)" suffix) deliberately not modeled.

- [x] G2: Ministry of Heavy Industries modeled entirely with the EXISTING corrigendum-substitution template — confirming the template doesn't care about the closing verb ("are hereby made" / "in partial modification of" both fit the same ministry-name-then-citation anchor).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_heavy_industries_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — extract/heavy_industries_patterns.py, db/seed_heavy_industries.sql (two Hindi-text-only corrigenda, one substantive PLI-Auto amendment).

- [x] G3: Ministry of Food Processing Industries modeled — one real, usable pair (a genuinely small ministry: 6 total notifications in the tracker).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_food_processing_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/food_processing_patterns.py, db/seed_food_processing.sql. Two further real leads (Recruitment Rules superseding unnumbered 1994-era rules) and one bare-form lead deliberately not modeled.

- [x] G4: Ministry of Tribal Affairs modeled — the ministry's tracker listing has only 2 notifications total, and the one real amendment relationship between them is modeled.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_tribal_affairs_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/tribal_affairs_patterns.py, db/seed_tribal_affairs.sql. A second real lead exists but is issued by the Ministry of Law and Justice (not Tribal Affairs) and cites only an Act number — wrong ministry AND unusable form, so correctly excluded from this ministry's data.

- [x] G5: Ministry of Minority Affairs modeled — three real note-chains, all via the existing template, no new code.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='minority-affairs';"
  EXPECT: 14
  EVIDENCE: met — db/seed_minority_affairs.sql (Central Waqf Council Rules 6-node chain, Recruitment Rules 3-node chain, Haj Committee composition 6-node chain).

- [x] G6: Foreign-key integrity holds across the whole database after 5 new seed files and 4 new (all zero-new-template) extractor modules.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates4.txt; [ ! -s /tmp/fk_check_gates4.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates4.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 36 ministries, 273 notifications, 192 cross-references.

- [x] G7: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 105 passed
  EVIDENCE: met.
