# Gates: parallel multi-ministry research batch (5 ministries)

OWNS: db/**, extract/**, tests/**

Scope: user asked to parallelize ministry research, 5 at a time. Five Explore agents ran concurrently (Railways, Home Affairs, Environment/Forest/Climate Change, Health and Family Welfare, Corporate Affairs), each under the same anti-fabrication brief: quote real primary or indexed gazette text with a source URL, explicitly report "not found" rather than invent. Every finding was reviewed and gated by hand before touching the repo — not merged on the agents' say-so.

- [x] G1: Every one of the 5 agents returned real, source-quoted findings — none fabricated a citation to fill the count.
  EVIDENCE: met — all 5 reports included exact notification numbers, dates, and verbatim primary-text quotes with source URLs; two agents explicitly flagged rate limits or gaps they hit rather than padding around them (Health: "hit a search limit ... did not attempt to work around this"; Corporate Affairs: "did not find ... a true 'corrigendum correcting a Companies (Incorporation)/(Accounts) Rules' ... that combination didn't surface").

- [x] G2: At least one agent finding was independently spot-checked by this session against its source, not just trusted on the agent's word.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && grep -c "spot-checked" db/seed_moefcc.sql
  EXPECT: /[1-9]/
  EVIDENCE: met — navigated to https://gazettetracker.com/g/CG-DL-E-19072023-247431 directly and confirmed the MoEFCC S.O. 3182(E)->S.O. 3252(E) quote matches word-for-word, including the agent's own flagged discrepancy (a mislabeled page title). Every other row's `verified_by` is 'research-agent-quoted', not upgraded to look equivalent.

- [x] G3: Each of the 5 ministries got its own citation extractor, tested against that ministry's own real text — not one pattern stretched across all five.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_moefcc_patterns.py tests/test_mha_patterns.py tests/test_health_patterns.py tests/test_railways_patterns.py tests/test_mca_patterns.py -q
  EXPECT: 12 passed
  EVIDENCE: met. Two real shared drafting templates emerged and were factored out (extract/common_templates.py) only after independent confirmation from a second ministry each — MoRTH+MHA share "hereby makes the following amendment(s) in the notification..."; MoEFCC+MoHFW+MCA share "...ministry of X [vide] number Y ... for [old] read [new]". Railways did not fit either (citation precedes "Ministry of Railways" instead of following "Ministry of X") and kept its own module. The consolidation itself caught a bug: assuming MoEFCC's and MoHFW's connective wording were identical ("in the Ministry of X" vs "..., Ministry of X,") was wrong and had to be loosened.

- [x] G4: The full test suite passes with all 7 ministries seeded together (no cross-ministry regressions from the shared-template refactor).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 19 passed
  EVIDENCE: met.

- [ ] G5: Every real lead an agent found is modeled in the database, not just the cleanest one per ministry.
  EVIDENCE: abandoned — see ABANDON. Deliberately scoped down to one pair per ministry this pass; the rest are documented as backlog in each seed_*.sql file's header comment, not silently dropped.

ABANDON: G5 exhausting every agent-found lead in one pass would have meant inventing new schema shapes under time pressure for at least three genuinely different relationship types found this batch — a one-to-many disapplication order (MHA), a draft-to-final rulemaking chain (MoHFW), and a Rules-instrument amendment-history citation (MCA, structurally closer to CBIC's consolidated-instrument shape than a corrigendum pair). Rushing those in risks the same kind of bug this session already caught twice (wrong assumption about shared phrasing, wrong assumption about connective wording) — better to model one clean, tested pair per ministry now and treat the rest as a scoped backlog, which is written into each seed file rather than lost. Handoff: each seed_*.sql file's header names its own unmodeled leads.
