# Gates: clear the deferred-lead backlog with a third shared template

OWNS: db/**, extract/**, tests/**

Scope: "ensure that every gazette notification is processed" — every real, already-verified lead documented as deferred backlog across 9 ministries (MCA, Agriculture, Steel, Power, Consumer Affairs, Civil Aviation, Housing, Communications, Culture) now has actual gazette_notification + cross_reference rows, not just a comment describing what wasn't modeled.

- [x] G1: A third shared template ("note-chain") built and tested against two real, independently-sourced examples — not designed from one, the same bar the first two templates were held to.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_note_chain.py -q
  EXPECT: 5 passed
  EVIDENCE: met — extract.common_templates.find_note_chain, confirmed across Culture (NMA rules) and Consumer Affairs (Legal Metrology Rules), two different connective phrasings ("subsequently amended" vs. "was last amended") for the same shape. Deliberately deferred across nine ministries before being written, per its own docstring, rather than designed from one example under time pressure.

- [x] G2: Every deferred lead with a COMPLETE citation+date pair on record is now a real row — no partial or half-cited chain link invented to fill a gap.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference;"
  EXPECT: 76
  EVIDENCE: met — went from 56 to 76 cross-references across the 9 ministries without adding a single new agent-researched fact; every new row traces to a citation+date already recorded in that ministry's own seed-file comments from earlier sessions. Two new relation_types added on real evidence: 'repeals' (Power: S.O. 2978(E) repeals S.O. 1034(E), a distinct statutory verb from 'rescinds') and reuse of 'amends' for every Note-chain edge.

- [x] G3: A genuinely incomplete chain (missing intermediate citations) is left honestly incomplete, not bridged with an invented edge.
  EVIDENCE: met — Agriculture's S.O. 2944(E) is the Note-chain's 11th named amendment to S.O. 1589(E) (2005); only the endpoint (item 11, S.O. 2963(E)) and the 2005 principal were captured verbatim this session, so no edge asserts a direct 2944(E)-to-1589(E) or 2963(E)-to-1589(E) relationship — items 2 through 10 are real but uncited, and the seed file says so. Power's G.S.R. 259(E)/G.S.R. 211(E) edge similarly omits the real intermediate G.S.R. 488(E), whose exact date was never captured.
  Also real, and still correctly unmodeled (a citation form the schema doesn't represent, not a time-pressure gap): Culture's "No. 108(Addendum)" (bare Notification No. + File Number) and Communications' reference to numbered rules 419/419A of the Indian Telegraph Rules, 1951 (a citation to rules within an Act, not a gazette notification).

- [x] G4: Foreign-key integrity holds across the whole database after 20 new rows across 9 files edited by hand.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_$$.txt; [ ! -s /tmp/fk_check_$$.txt ] && echo FK_CLEAN; rm -f /tmp/fk_check_$$.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met.

- [x] G5: Full suite passes with 17 ministries, 113 notifications, 76 cross-references.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 74 passed
  EVIDENCE: met.

- [ ] G6: Next 5 ministries (batch continuing "the same way") researched, reviewed, and modeled using all three templates.
  EVIDENCE: pending — starting now.
