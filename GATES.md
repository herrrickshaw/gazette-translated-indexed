# Gates: two more parallel batches (10 ministries researched, 7 modeled)

OWNS: db/**, extract/**, tests/**

Scope: user asked to keep running batches of 5 in parallel. Ran two more batches of 5 (10 agents total across this session: Labour, Petroleum, Consumer Affairs, Commerce, Power, then Agriculture, Civil Aviation, Education, Electronics/IT, Housing), same anti-fabrication brief as the first batch. Reviewed every finding by hand; modeled 7 of the 10 ministries with a clean, tested pair each. Deliberately did not model 3 (Petroleum, Commerce/DGFT, Education) — see ABANDON.

- [x] G1: Every real, source-quoted finding from all 10 agents was reviewed before touching the repo; none were merged on an agent's say-so alone.
  EVIDENCE: met — every modeled ministry's seed file cites its research-agent quote and source URL; deferred leads are documented in the same files' header comments, not discarded silently.

- [x] G2: The full test suite passes with all 14 ministries seeded together.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 34 passed
  EVIDENCE: met.

- [x] G3: At least one bug was caught by testing against this batch's real text that the first two batches' tests did not surface.
  EVIDENCE: met — Ministry of Agriculture's real primary text has "the Central Government herby makes the following amendments" (missing the second "e" in "hereby" — an apparent transcription/OCR artifact in the source gazette itself, not this project's error). The shared anchor required the correct spelling and silently matched nothing; fixed by dropping "hereby" from the anchor rather than special-casing the typo, since the shorter anchor is still unambiguous and a strict superset of what the old one matched.

- [x] G4: Every provenance tier is still tracked distinctly — no ministry's real-but-weaker sourcing got smoothed to look as solid as CBIC's.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT DISTINCT verified_by FROM cross_reference ORDER BY 1;" | wc -l | tr -d ' '
  EXPECT: 7
  EVIDENCE: met — includes a new, explicitly weaker tier introduced this batch: 'research-agent-quoted-uncorroborated' (Ministry of Housing and Urban Affairs), because the research agent itself flagged that pair as resting solely on one aggregator's text with no independent corroboration found. Recorded as weaker, not silently merged into the ordinary 'research-agent-quoted' tier.

- [ ] G5: Every real lead this batch's agents found is modeled, not just one clean pair per ministry.
  EVIDENCE: abandoned — see ABANDON.

ABANDON: G5 the same reasoning as the first batch's G5 applies, plus one new case: Petroleum and Commerce/DGFT's real findings don't fit either shared template at all (Petroleum's leads are all footnote-style "principal regulation...amended vide..." citations in regulator PDFs; Commerce/DGFT's leads cite the original by a bare "Notification No. 66" DGFT-internal number, not a G.S.R./S.O. citation the current extractor even recognizes) — modeling either would mean designing a new citation pattern under time pressure, which is exactly how the "herby" and "in the Ministry of X" bugs got introduced earlier this session. Education's three real leads are all citation-history chains in a trailing "Note" (2 to 11 prior amendments each), the same consolidated-instrument shape already deferred for MCA and Agriculture — left out for the same reason, not forgotten. Handoff: Petroleum and Commerce/DGFT need their own citation-pattern modules (not a template reuse) before any pair from either can be modeled; the "Note"-chain shape (MCA, Agriculture, Education, Consumer Affairs' Legal Metrology lead) is common enough across ministries now that it may be worth its own shared template, the same way amendment-in-notification and corrigendum-substitution were factored out — but only after it's been read carefully enough to get right, not extrapolated from four examples under time pressure.
