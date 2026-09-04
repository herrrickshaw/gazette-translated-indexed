# Gates: batch 4 (Communications, Coal, Steel, Culture, Women & Child Development)

OWNS: db/**, extract/**, tests/**

Scope: "finish 1 then 2" — close out the ministry-by-ministry batch already in flight (1), then attempt egazette.gov.in directly for bulk coverage (2). This ledger covers (1). Two of the five ministries fit existing templates and are modeled; two are deferred on the same reasoning as earlier batches; one (Communications) was cut off by an API rate limit mid-run and relaunched.

- [x] G1: Every modeled pair traces to a research-agent quote of primary "Full Text" with a source URL, and every deferred lead is written into a seed file header rather than dropped.
  EVIDENCE: met — db/seed_steel.sql, db/seed_culture.sql carry both the modeled pair and the deferred leads for their ministries. Coal's and Women & Child Development's leads (all trailing-"Note" amendment-history chains, plus one that cites a 1979 "Department of Social Welfare" — a ministry that no longer exists under that name) are recorded in this file's ABANDON, not modeled.

- [x] G2: The first genuine one-to-many cross-reference modeled from a single source clause returns all targets, not just the first.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_culture_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — S.O. 441(E) partially modifies S.O. 3514(E), S.O. 2985(E), and S.O. 2637(E) in one sentence; three cross_reference rows from one source.

- [x] G3: Testing this batch's real text caught bugs the earlier 39-test suite did not.
  EVIDENCE: met — two: (a) "S. O. 3514(E)" with a space after "S." was invisible to the S.O. regex, fixed by allowing optional whitespace between abbreviation letters in both _SO_RE and _GSR_RE; (b) passing 'ministry of steel' to the corrigendum-substitution template produced the anchor "ministry of ministry of steel" — the two shared templates treat the ministry-name argument differently (anchor prefix vs. scope-guard substring), and the module docstrings now say so.

- [x] G4: Full suite passes with all 16 ministries seeded together.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 39 passed
  EVIDENCE: met.

- [ ] G5: Communications is modeled.
  EVIDENCE: pending — the first research agent was terminated by an API session rate limit mid-run (HTTP 429) with no findings returned; relaunched. Folded in on arrival, as its own commit.

## Deferred this batch (not gates — nothing here is claimed done)

Coal and Women & Child Development are deliberately not modeled this batch: every Coal lead and two of three WCD leads are trailing-"Note" amendment-history chains (the consolidated-instrument shape already deferred for MCA, Agriculture, Petroleum, Education, Steel's other two pairs) — now nine ministries' worth of real examples of that one shape, which is the strongest signal yet that it deserves its own shared template, designed from all nine rather than extrapolated from one. WCD's remaining lead cites "the then Department of Social Welfare No. S.O. 120(E), dated the 2nd March, 1979": the ministry-name scope guard cannot match a department that was renamed decades ago, and handling ministry reorganizations is a data-model question (a ministry alias/lineage table), not a regex tweak. Handoff: (a) design the "Note"-chain template from the nine real examples; (b) add a ministry-alias table before modeling any pre-reorganization notification.
