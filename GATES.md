# Gates: second-ministry pilot (Road Transport and Highways)

OWNS: db/**, extract/**, tests/**, data/**

Scope: "All ministries across all history" is not a completable unit right now (see ABANDON on G0 below). The actual next milestone: extend the pipeline to a second real ministry — Ministry of Road Transport and Highways — with one genuinely verified cross-reference, proving the schema and extraction approach generalize past CBIC's specific drafting conventions rather than just re-running CBIC's regex on new text.

- [ ] G0: All ~50 central ministries have a verified citation chain spanning each ministry's full notification history, the way CBIC's chain was verified against its own primary-source text.
  EVIDENCE: abandoned — see ABANDON below.

- [x] G1: Real (not fabricated) MoRTH corrigendum-to-original cross-references exist in the database, sourced from independently observable evidence, not invented to fill the schema.
  CHECK: python3 -c "import sqlite3; c=sqlite3.connect('gazette.db'); r=c.execute(\"SELECT count(*) FROM cross_reference WHERE source_gazette_id LIKE 'morth-%'\").fetchone()[0]; assert r==3, f'expected 3, got {r}'; print('MORTH_XREF_OK')"
  EXPECT: MORTH_XREF_OK
  EVIDENCE: met — 3 real corrigendum->original pairs: S.O. 4848(E)->4872(E) (2026, read from the notification's own primary "Full Text" page), S.O. 2432(E)->732(E) and S.O. 4689(E)->1265(E) (2025/2024, literal excerpts from a full-text search index, not an AI summary). verified_by distinguishes 'primary-source-full-text' from 'search-index-excerpt' — neither claims CBIC's tier (an independently downloaded gazette PDF read start to finish).

- [x] G2: MoRTH's citation format is structurally different from CBIC's, and the schema/extractor handle that difference explicitly rather than by coincidence.
  CHECK: python3 -c "
import sqlite3
c = sqlite3.connect('gazette.db')
row = c.execute(\"SELECT numbering_form FROM gazette_notification WHERE gazette_id='morth-so-4872-2025'\").fetchone()
assert row and row[0] == 'so-only', f'expected so-only, got {row}'
print('MORTH_FORM_OK')
"
  EXPECT: MORTH_FORM_OK
  EVIDENCE: met — MoRTH notifications under the National Highways Act, 1956 carry no ministry-internal sequential number at all (no "No. X/YYYY-series"); the S.O. gazette number is the only citation. Modeled as numbering_form='so-only', distinct from CBIC's bare/2-digit-year/4-digit-year forms.

- [x] G3: A MoRTH-specific extractor exists and is tested against three real sentences, independent of CBIC's citation_patterns module.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_morth_patterns.py -q
  EXPECT: 3 passed
  EVIDENCE: met — see tests/test_morth_patterns.py. The extractor's original phrase ("to amend notification") was itself sourced from an aggregator's AI summary, not the real legal text, and matched none of the three real examples; fixed by reading primary text and matching the actual recurring boilerplate ("hereby makes the following amendment in").

- [x] G4: A genuine second and third cross-reference (beyond the single seeded example) have been independently fetched and verified from real MoRTH notification text, distinguishing provenance tiers rather than treating every source as equivalent.
  CHECK: python3 -c "import sqlite3; c=sqlite3.connect('gazette.db'); r=c.execute(\"SELECT count(DISTINCT verified_by) FROM cross_reference WHERE source_gazette_id LIKE 'morth-%'\").fetchone()[0]; assert r==2, f'expected 2 distinct provenance tiers, got {r}'; print('MORTH_G4_OK')"
  EXPECT: MORTH_G4_OK
  EVIDENCE: met — see db/seed_morth.sql for the two additional pairs and the explicit provenance-tier distinction ('primary-source-full-text' vs 'search-index-excerpt'), neither smoothed into CBIC's 'primary-source-preamble' tier.

ABANDON: G0 "all ministries across all history" is not a gate-able unit of work and is abandoned as stated, not silently narrowed. Reasons: (1) CBIC's own 31-notification chain required fetching and reading actual primary-source PDF text, and testing against that real text caught three genuine extraction bugs (en-dash vs hyphen, a 2-digit-year pivot bug, a too-short phrase-matching window) that a clean synthetic fixture did not surface — there is no shortcut past that per-ministry verification step. (2) ~50 central ministries, each with a decades-to-centuries-long notification history and its own drafting conventions, means ~50 independent verification efforts of that same size, which is real research work across many sessions, not a batch operation. (3) The only way to make "all ministries, all history" look done in one pass is to fabricate citation data to fill the schema — already explicitly ruled out earlier in this project (see README "What's real vs. scaffolded" and the published Ministry Coverage page) and not reversed here. Handoff: pick the next ministry deliberately (MoRTH is a reasonable #2, per G1-G3 above) and budget real fetch-and-verify time per ministry, the same way CBIC got it.
