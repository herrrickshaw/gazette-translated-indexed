# Gates: 9th research batch (Batch 9 of the coverage plan) — Commerce/Industry, External Affairs, Personnel/DoPT, MoSPI, Ports/Shipping/Waterways

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: batch 9 of `docs/MINISTRY_COVERAGE_PLAN.md` — research, review, and model these 5 ministries the same way as prior batches; generalize a new template only after independent cross-ministry confirmation.

- [x] G1: A fifth shared template ("bare-citation-reference") built and tested against two INDEPENDENT ministries in one pass (Statistics and Programme Implementation, two different lead-in phrasings; Ports, Shipping and Waterways, a third) — the first template confirmed cross-ministry within a single batch rather than across separate ones.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_bare_citation_links.py -q
  EXPECT: 4 passed
  EVIDENCE: met — extract.common_templates.find_bare_citation_links, deliberately narrow window (60 chars vs. 100-300 for the ministry-anchored templates) since there is no ministry name to anchor on.

- [x] G2: Ministry of Commerce and Industry modeled — three real pairs, deliberately targeting its G.S.R./S.O.-numbered rule-making (SEZ Rules, Ammonium Nitrate Rules) rather than the bare DGFT-numbered notifications already known unusable.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='commerce-and-industry';"
  EXPECT: 12
  EVIDENCE: met — db/seed_commerce_industry.sql, pure seed-only (a plain-rescission narrative shape confirmed by only one example, not generalized into a template).

- [x] G3: Ministry of External Affairs modeled — three real pairs needing THREE existing templates combined in one module (corrigendum-substitution, amendment-in-notification, supersession-preamble), including a real double-target supersession (one notification superseding two prior G.S.R.s at once).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_external_affairs_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — extract/external_affairs_patterns.py, db/seed_external_affairs.sql.

- [x] G4: Ministry of Personnel, Public Grievances and Pensions modeled — a sixth genuinely distinct drafting shape (target citation appears BEFORE the ministry name, same reversed-order class as Railways), plus a real administrative oddity (two separately-numbered corrigenda, same date, identical correction to the same target) recorded as two real rows rather than merged.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_personnel_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/personnel_patterns.py, db/seed_personnel.sql. Its principal notification ("S.O. 3703", pre-1965, no "(E)" suffix) is modeled as a real bare-form row per the established WCD/CBIC precedent, not discoverable by the live regex but hand/agent-verified.

- [x] G5: Ministry of Statistics and Programme Implementation modeled — two real corrigenda, both via the new bare-citation-reference template (G1), confirming it independently of Ports (G6).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_mospi_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — extract/mospi_patterns.py, db/seed_mospi.sql. Two further real leads (target cited only by date+File No.; a fully bare-form pair) deliberately not modeled.

- [x] G6: Ministry of Ports, Shipping and Waterways modeled — three real pairs needing THREE templates combined (corrigendum-substitution, supersession-preamble, bare-citation-reference), the second ministry confirming G1.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_ports_shipping_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — extract/ports_shipping_patterns.py, db/seed_ports_shipping.sql.

- [x] G7: Foreign-key integrity holds across the whole database after 5 new seed files and 5 new extractor modules (one combining three templates).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates5.txt; [ ! -s /tmp/fk_check_gates5.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates5.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 41 ministries, 309 notifications, 215 cross-references.

- [x] G8: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 119 passed
  EVIDENCE: met.
