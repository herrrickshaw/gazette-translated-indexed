# Gates: bounded first bulk run — fetch to Dropbox, parse against the index

OWNS: data/manifest/**, data/raw_md/**, db/**, extract/**, tests/**

Scope: "go ahead with the bounded first run, fetch to dropbox and then parse". Every gazette ID collected across this session's research (66 total) fetched from egazette.gov.in into `~/Dropbox/gazette-translated-indexed/egazette/` (gitignored — PDFs are publicly re-fetchable by ID, so only the path/URL is tracked, never the bytes), then parsed against what the index currently claims.

- [x] G1: All 66 manifest PDFs fetched, none disk-cached from a stale/wrong source, none smaller than a real gazette page.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && find "$HOME/Library/CloudStorage/Dropbox/gazette-translated-indexed/egazette" -name '*.pdf' | wc -l | tr -d ' '
  EXPECT: 66
  EVIDENCE: met — 64 MB total, every file's first 5 bytes confirmed `%PDF-` before this gate was written.

- [x] G2: Parsing the OFFICIAL PDFs caught real bugs a synthetic fixture could not — same discipline as every earlier batch, now proven at bulk scale rather than one document at a time.
  EVIDENCE: met — two, both structural (not one-off typos):
  (a) **Whitespace bug, both shared templates.** Real PDF text line-wraps mid-phrase — Ministry of Home Affairs prints "hereby makes the following \namendments" with the break landing inside the anchor phrase. Every anchor in extract/common_templates.py used literal substring `.find()`, which silently fails on any such wrap even though both citations are plainly present. Fixed by normalizing all whitespace runs to a single space once, before every anchor and citation search — flipped MHA, MeitY, and Housing and Urban Affairs from MISSED to RECOVERED with no other change. extract/railways_patterns.py's own duplicate copy of the same loop was refactored to share the fix instead of getting a second patch.
  (b) **Aggregator ID/content mismatch, MoEFCC.** The pair earlier marked 'spot-checked' (S.O. 3182(E) corrects S.O. 3252(E), gazette ID CG-DL-E-19072023-247431) does not exist at that ID on the official site — the real content there is a different notification, G.S.R. 522(E) correcting G.S.R. 499(E). A "spot-check" against mismatched content is not a spot-check: downgraded to 'research-agent-quoted' (the quote itself is real, its own gazette ID is unresolved) and the genuinely-verified G.S.R. 522(E)/499(E) pair recovered from the real official PDF was added at the 'primary-source-egazette' tier instead, in db/seed_moefcc.sql with the correction documented inline.

- [x] G3: Every recoverable modeled claim across all 17 ministries is now verified directly against the official source, not carried on an aggregator's word.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE verified_by='primary-source-egazette';"
  EXPECT: /^(1[5-9]|2[0-9])$/
  EVIDENCE: met — 21. Remaining non-egazette tiers are CBIC's original 31 ('primary-source-preamble', verified a different way before this manifest existed and out of this run's scope) plus a handful of genuinely un-recoverable-yet leads (deferred shapes, login-gated aggregator pages, IDs this run didn't include).

- [x] G4: Full suite passes after both fixes, with the corrected MoEFCC seed data.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 51 passed
  EVIDENCE: met.

- [ ] G5: A CRUD layer over gazette_notification/cross_reference, replacing ad-hoc seed .sql + shell one-liners, storing paths/URLs never PDF bytes (already true of the schema; this is the access-layer request, not a data-model change).
  EVIDENCE: pending — next piece of work, in progress.
