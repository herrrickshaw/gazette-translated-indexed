# Gates: 6th research batch — Petroleum, Rural Development, Social Justice, Skill Development, Tourism

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: research, review, and model the next 5 ministries (Petroleum and Natural Gas, Rural Development, Social Justice and Empowerment, Skill Development and Entrepreneurship, Tourism) the same way as prior batches — real citations only, honest gaps left honest, templates generalized only after independent confirmation.

- [x] G1: A fourth shared template ("supersession-preamble") built and tested against two independent real examples from one ministry (a same-ministry supersession and a cross-ministry supersession) — generalizing CBIC's own cross_ref.py boilerplate match to G.S.R./S.O./S.R.O. citations instead of CBIC-only numbering.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_skill_development_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — extract.common_templates.find_supersession_links, confirmed via Ministry of Skill Development and Entrepreneurship superseding both a different ministry's notification (Ministry of Labour) and its own. Deliberately does NOT anchor on a ministry name, unlike the other two ministry-anchored templates, because the superseded notification can belong to an entirely different ministry.

- [x] G2: A real "S.O. No. NNNN(E)" citation variant (extra "No." before the digits, first seen in Ministry of Social Justice and Empowerment text) recognized by the shared citation regex.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_so_no_variant.py -q
  EXPECT: 1 passed
  EVIDENCE: met — extract/citation_patterns.py's `_GSR_RE`/`_SO_RE` now tolerate an optional `(?:No\.?\s*)?` before the digits.

- [x] G3: Ministry of Skill Development and Entrepreneurship fully modeled — one corrigendum plus two supersessions (one cross-ministry, one same-ministry), the first ministry needing two templates combined in one extractor module.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='skill-development-entrepreneurship';"
  EXPECT: 6
  EVIDENCE: met — db/seed_skill_development.sql, extract/skill_development_patterns.py. A fourth real lead (bare "Notification No. SL-11/01/2023-T&P" form) deliberately not modeled.

- [x] G4: Ministry of Social Justice and Empowerment fully modeled — three real note-chains, including a 12-node chain (the longest S.O.-numbered chain in this project) and the real "S.O. No." variant from G2.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='social-justice-and-empowerment';"
  EXPECT: 17
  EVIDENCE: met — db/seed_social_justice.sql.

- [x] G5: Ministry of Rural Development modeled — a complete 14-node MGNREGA wage-Schedule chain (the new longest chain overall) plus a genuinely partial Schedule-I chain, left honestly incomplete rather than bridged.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest "tests/test_note_chain.py::test_thirteen_item_chain_with_roman_numeral_parenthetical_items" -q
  EXPECT: 1 passed
  EVIDENCE: met — db/seed_rural_development.sql. The Schedule-I chain's real 15-year gap (S.O. 323(E), 2007, to S.O. 3126(E), 2022) is recorded as an unbridged fact, not an invented edge.

- [x] G6: Ministry of Petroleum and Natural Gas modeled — a complete 3-node chain plus a second chain whose current link is a genuine rule-making DRAFT, modeled with relation_type='cites' rather than 'amends' since a draft has no legal effect yet.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT relation_type FROM cross_reference WHERE source_gazette_id='mopng-gsr-781-2026';"
  EXPECT: cites
  EVIDENCE: met — db/seed_petroleum.sql. A third real lead (a Resolution amending a Resolution, bare F. No. form) deliberately not modeled.

- [ ] G7: Ministry of Tourism — the tracker lists only 4 total notifications for this ministry; all 3 real supersession/suppression pairs found cite a G.S.R. number on the AMENDING side only, never on the target side (rules/Resolutions are named by title, not by number) — there is nothing to link TO.
  EVIDENCE: not modeled — no pair has a citation on both ends, so no cross_reference row can be built without inventing a target citation that was never printed.

ABANDON: G7 All three Ministry of Tourism pairs found this batch (Tourist Organization Information Staff Rules supersession, MoT Group 'A' Recruitment Rules supersession, Hindi Salahakar Samiti reconstitution) are real, quoted from primary Full Text, and structurally unlinkable — the superseded instrument is never given a G.S.R./S.O./S.R.O. number in this tracker's text. This is a real finding (thin, mostly-administrative gazette activity for this ministry), not a research gap.

- [x] G8: Foreign-key integrity holds across the whole database after 5 new seed files, 2 new extractor modules, and 1 new shared template.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates2.txt; [ ! -s /tmp/fk_check_gates2.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates2.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 27 ministries, 214 notifications, 150 cross-references.

- [x] G9: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 91 passed
  EVIDENCE: met.
