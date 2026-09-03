# Gates: second-ministry pilot (Road Transport and Highways)

OWNS: db/**, extract/**, tests/**, data/**

Scope: "All ministries across all history" is not a completable unit right now (see ABANDON on G0 below). The actual next milestone: extend the pipeline to a second real ministry — Ministry of Road Transport and Highways — with one genuinely verified cross-reference, proving the schema and extraction approach generalize past CBIC's specific drafting conventions rather than just re-running CBIC's regex on new text.

- [ ] G0: All ~50 central ministries have a verified citation chain spanning each ministry's full notification history, the way CBIC's chain was verified against its own primary-source text.
  EVIDENCE: abandoned — see ABANDON below.

- [x] G1: A real (not fabricated) MoRTH corrigendum-to-original cross-reference exists in the database, sourced from an independently observable feed, not invented to fill the schema.
  CHECK: python3 -c "import sqlite3; c=sqlite3.connect('gazette.db'); r=c.execute(\"SELECT count(*) FROM cross_reference WHERE source_gazette_id LIKE 'morth-%'\").fetchone()[0]; assert r==1, f'expected 1, got {r}'; print('MORTH_XREF_OK')"
  EXPECT: MORTH_XREF_OK
  EVIDENCE: met — seeded S.O. 4848(E) (corrigendum, 1 Sep 2026) -> amends -> S.O. 4872(E) (original, 24 Oct 2025), both observed directly on a live public gazette feed during this conversation (Gazette Tracker), not generated to fit the schema. verified_by = 'observed-live-feed-2026-09-03', not 'primary-source-preamble' — a materially weaker provenance tier than the CBIC seed data, recorded honestly rather than upgraded.

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

- [x] G3: A MoRTH-specific extractor exists and is tested against the one real sentence observed, independent of CBIC's citation_patterns module.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_morth_patterns.py -q
  EXPECT: 1 passed
  EVIDENCE: met — see tests/test_morth_patterns.py, run against the real corrigendum sentence, not a synthetic paraphrase.

- [ ] G4: A genuine second cross-reference (beyond the single seeded example) has been independently fetched and verified from primary-source MoRTH notification text, the same way the 31 CBIC entries were verified against the actual 45/2025-Customs preamble.
  EVIDENCE: pending — not attempted this session. One real example is a signal, not a validated pattern; MoRTH needs the same primary-source-fetch-and-diff process CBIC got before its extractor can be trusted, and that's real, unstarted research work, not a formatting task.

ABANDON: G0 "all ministries across all history" is not a gate-able unit of work and is abandoned as stated, not silently narrowed. Reasons: (1) CBIC's own 31-notification chain required fetching and reading actual primary-source PDF text, and testing against that real text caught three genuine extraction bugs (en-dash vs hyphen, a 2-digit-year pivot bug, a too-short phrase-matching window) that a clean synthetic fixture did not surface — there is no shortcut past that per-ministry verification step. (2) ~50 central ministries, each with a decades-to-centuries-long notification history and its own drafting conventions, means ~50 independent verification efforts of that same size, which is real research work across many sessions, not a batch operation. (3) The only way to make "all ministries, all history" look done in one pass is to fabricate citation data to fill the schema — already explicitly ruled out earlier in this project (see README "What's real vs. scaffolded" and the published Ministry Coverage page) and not reversed here. Handoff: pick the next ministry deliberately (MoRTH is a reasonable #2, per G1-G3 above) and budget real fetch-and-verify time per ministry, the same way CBIC got it.
