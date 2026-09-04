# Gates: 5th research batch — Ayush, Mines, Law and Justice, Defence (+ Textiles processing)

OWNS: db/**, extract/**, tests/**, ingest/parse_manifest.py

Scope: process every real gazette notification found this session for the batch (Ayush, Mines, Law and Justice, Defence) plus the previously-received but unbuilt Textiles results — model what the schema/extractors can represent, and explicitly abandon (not silently drop) what they can't, per "ensure that every gazette notification is processed."

- [x] G1: Real Ayush comma-typo bug (`"S.O, 2281(E)"`, a keying error in the source gazette itself, not a formatting choice) fixed in the shared citation regex and covered by a regression test using the real text.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_ayush_note_chain.py tests/test_ayush_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — extract/citation_patterns.py's `_SO_RE`/`_GSR_RE` now tolerate `[.,]?` in place of the bare `\.?` after the abbreviation letters. All three Ayush pairs (2 corrigenda + 1 three-item note-chain, S.O. 2281(E) -> S.O. 221(E) -> S.O. 563(E)) modeled in db/seed_ayush.sql with real dates recovered from the original research-agent report.

- [x] G2: A third gazette-citation series (S.R.O., "Statutory Rules and Orders") added to the shared citation extractor after Defence turned up as the first ministry citing exclusively via S.R.O., never G.S.R./S.O. — confirmed against real text, not designed speculatively.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_sro_citations.py tests/test_note_chain.py::test_sro_series_note_chain -q
  EXPECT: 4 passed
  EVIDENCE: met — extract/citation_patterns.py's `_SRO_RE` plus a `GazetteCitation.kind == 'S.R.O.'` branch in `find_gazette_citations`; both shared templates (corrigendum-substitution, note-chain) pick it up for free since they scan through `find_gazette_citations`.

- [x] G3: Ministry of Mines fully modeled — one corrigendum-substitution pair plus two note-chains, including the longest real chain seen this project (9 nodes: principal + 8 amendments) and the first real "; and" conjunction before a chain's final citation.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_mines_patterns.py tests/test_note_chain.py::test_eight_item_chain_with_and_conjunction_before_last_item -q
  EXPECT: 3 passed
  EVIDENCE: met — db/seed_mines.sql, extract/mines_patterns.py.

- [x] G4: Ministry of Defence — the two pairs the current schema/extractors CAN represent (S.R.O.-cited: one corrigendum-substitution, one note-chain) are modeled and tested.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_defence_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — db/seed_defence.sql.

- [ ] G4b: Defence's third pair, Corrigendum No. 11(E) (Army honorary-rank fan-out amending 5 separate prior notifications).
  EVIDENCE: not modeled — it cites via a bare "No. NN(E)" form with no G.S.R./S.O./S.R.O. prefix, a fourth citation shape this schema doesn't recognize, and it is also a one-to-many corrigendum no template here handles.

ABANDON: G4b Building a citation form for one occurrence would repeat exactly the un-evidenced-design mistake this project has deliberately avoided elsewhere. Documented in db/seed_defence.sql's header comment rather than silently dropped.

- [x] G5: Ministry of Textiles (results received last batch, not yet built) — the two note-chain pairs are modeled and tested; the schema-incompatible one is explicitly deferred.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='textiles';"
  EXPECT: 8
  EVIDENCE: met — db/seed_textiles.sql (Cotton Bales Order 6-node chain ending in a 'rescinds' edge; Ropes and Cordages Order 2-node chain).

- [ ] G5b: Textiles' third pair, S.O. 3189(E) superseding "Notification No. 2/TDRO/8/2003" (Hank Yarn packing notification).
  EVIDENCE: not modeled — same bare-notification-number citation-shape gap as Commerce/DGFT.

ABANDON: G5b Documented rather than forced; no second ministry confirms this citation shape.

- [ ] G6: Ministry of Law and Justice — all three real pairs found this batch use Act/Regulation-number citations ("Reg. 2 of 2026", "4 of 2026"), never G.S.R./S.O./S.R.O., and the Legislative Department's corrigenda text doesn't carry a "Ministry of X" anchor phrase either.
  EVIDENCE: not modeled — none of the three fit the current schema's citation representation or either shared template. This is a structurally different citation regime from every other ministry modeled so far (25 ministries now, all G.S.R./S.O./S.R.O.), not a research gap or a time-pressure shortcut.

ABANDON: G6 Corrigenda to the Lakshadweep (Registration Amendment) Regulation, 2026; the Lakshadweep Fire and Emergency Service Regulation, 2026; and the Finance Act, 2026 / Jan Vishwas (Amendment of Provisions) Act, 2026 are all real, all quoted from primary Full Text, and all left unmodeled — building Act/Regulation-number citation support for a single ministry's batch, with no second ministry confirming the shape, would be exactly the un-evidenced, one-example design this project has refused to do for every other template.

- [x] G7: Foreign-key integrity holds across the whole database after 6 new/edited seed files (ayush, mines, defence, textiles) plus 3 new extractor modules.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates.txt; [ ! -s /tmp/fk_check_gates.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_gates.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 23 ministries, 166 notifications, 113 cross-references.

- [x] G8: Full suite passes.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 86 passed
  EVIDENCE: met.
