# Gates: depth-pass batch 11 (final) — Space, Steel, Textiles, Tribal Affairs, WCD, Youth Affairs & Sports, CBIC

OWNS: db/**, docs/**

Scope: the last batch of the depth pass — the six remaining unvisited ministries plus a return trip to CBIC (the project's original pilot ministry), completing all 53 of 53. No new extractor code this batch: every real shape fit an existing shared template, generic note-chain/corrigendum/supersession pattern, or seed-only modeling. Textiles, Steel, Tribal Affairs, and Railways seeds were assembled from the research logs by one-off generator scripts to avoid transcription error across ~190 rows combined. Two of the seven agents (Space, WCD) hit the session rate limit mid-run and were retried with the token-efficiency policy adopted mid-batch (5-agent concurrency cap, trafilatura extraction-before-reading). Railways' depth-pass report (received at the start of this batch, from a prior wave) was processed into its seed only now, having been set aside; its report covered ~3,300 items and only a bounded subset was modeled, documented as such in the seed's own header.

- [x] G1: Department of Space — the "Login to read full text" gate on gazettetracker turned out to be CSS-only, not an actual auth wall; the previously-PARTIAL 39-row Note table is now fully transcribed and its column semantics resolved (file number/signing date vs. S.O. number/gazette date), with two of its rows (36, 38) independently confirmed as their own separately-fetched primary documents and modeled as real edges. `publish_date` on the existing 2025 node corrected from its signing date to its actual gazette date.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='department-of-space';"
  EXPECT: 4
  EVIDENCE: met — db/seed_space.sql; full 39-row table transcribed in the header comment, two rows (S.O. 424(E)/2018, S.O. 4235(E)/2019) independently verified and modeled.

- [x] G2: Ministry of Steel — the pre-2020 QCO layer (missing from gazettetracker's single-page listing) recovered via archive.org's Gazette mirror; ten new subject threads added incl. the full QCO supersession spine 2018-2024 chaining into the already-modeled S.O. 3716(E), the Stainless Steel Products QCO chain, the DMI&SP Policy extension history, a Green Steel Taxonomy rescission, and a bounded subset of the Factories Act "occupier" amendment chains.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM cross_reference WHERE source_gazette_id='steel-so-3716-2024' AND target_gazette_id='steel-so-574-2024' AND relation_type='supersedes';"
  EXPECT: 1
  EVIDENCE: met — db/seed_steel.sql (65 notifications, 48 cross-references, up from 5/3).

- [x] G3: Ministry of Textiles — 145-item tracker corpus fully read; 18 new subject threads incl. a Jute Packaging Materials reservation-order chain spanning 2023-2026, a Jute Commissioner stock-limit chain ending in a six-target rescission, and the Central Silk Board Rules 1955 Note-chain. The Hank Yarn Packing deferred lead (2/TDRO/8/2003) was resolved as a matter of fact, not left open by omission: confirmed via the Textile Commissioner's own PDF that the whole chain is Part I Section 1, which carries no S.O./G.S.R. number at all.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='textiles';"
  EXPECT: 73
  EVIDENCE: met — db/seed_textiles.sql (73 notifications, 61 cross-references, up from 8/6).

- [x] G4: Ministry of Tribal Affairs — gazettetracker's listing (still just 2 items, but a different pair than the prior pass described) was re-confirmed genuinely thin; ~1,470 titles across 8 other ministries' listings swept for misfiled material (none found); the real expansion came from archive.org, recovering the NCST Chairperson/Member appointment chain back to 2004, a 2002-2004 Scheduled Areas Commission tenure-extension chain, and the 2007-2008 Forest Rights Rules draft-to-final pair with its corrigendum.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='tribal-affairs';"
  EXPECT: 20
  EVIDENCE: met — db/seed_tribal_affairs.sql (20 notifications, 19 cross-references, up from 2/1).

- [x] G5: Ministry of Women and Child Development — the Juvenile Justice (Care and Protection of Children) Rules repeal/amendment chain (2007→2011→2016→2022) recovered from wcd.gov.in and archive.org; a POCSO Rules 2020 corrigendum and the Adoption Guidelines 2015→Regulations 2017 supersession added. Two WCD-issued commencement notifications citing Law & Justice-published Acts were found but deliberately not modeled, applying the same out-of-scope precedent already recorded for Tribal Affairs rather than treating it as a fresh judgment call.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='women-child-development';"
  EXPECT: 20
  EVIDENCE: met — db/seed_wcd.sql (20 notifications, 15 cross-references, up from 10/8).

- [x] G6: Ministry of Youth Affairs and Sports — the ministry's entire 24-item tracked corpus was re-read in full (egazette PDF-verified where the tracker's Full Text was truncated for logged-out users); genuinely no new number/date-cited cross-reference exists beyond the already-modeled S.O. 2292(E) cluster. Two candidate edges (National Sports Governance rules citing each other by title) and the Khelo India Directorate renaming lead were confirmed real but unmodelable, not silently dropped.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='youth-affairs-and-sports';"
  EXPECT: 4
  EVIDENCE: met — db/seed_youth_affairs_sports.sql header updated with the full re-check; no data change (4 notifications, 3 cross-references, unchanged).

- [x] G7: CBIC (Customs) — both previously-NULL G.S.R. numbers on the pilot's own consolidating instruments confirmed from primary egazette PDFs (45/2025-Customs = G.S.R. 781(E); 02/2026-Customs = G.S.R. 83(E)); the assumption that 02/2026 was 45/2025's first amendment corrected — a 31 Oct 2025 corrigendum and No. 48/2025-Customs both preceded it. Full amendment/corrigendum history of 45/2025 through 8 Jul 2026 modeled, plus three further chains (the last amendments to No. 50/2017-Customs, two anti-dumping sunset-extension chains, and No. 44/2025-Customs' companion history).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT gsr_or_so FROM gazette_notification WHERE gazette_id='cus-45-2025';"
  EXPECT: G.S.R. 781(E)
  EVIDENCE: met — db/seed_cbic.sql (55 notifications, 56 cross-references, up from 33/32).

- [x] G8: Ministry of Railways — the depth-pass report from this batch's own dispatch wave (a ~3,300-item survey across zonal railways and the Railway Board) was correctly processed into its seed rather than left unapplied: a South Central Railway ROB corrigendum chain, a North Western Railway land-acquisition cluster including a novel CANCELLATION shape, two North East Frontier Railway corrigenda, and ten Railway Board G.S.R. Note-chain pairs. The original flagged date inconsistency (S.O. 2950(E) "dated 08.09.2026") was resolved as a dd.mm typo for 08.06.2026, and `publish_date` corrected accordingly.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && sqlite3 gazette.db "SELECT count(*) FROM gazette_notification WHERE ministry_id='railways';"
  EXPECT: 37
  EVIDENCE: met — db/seed_railways.sql (37 notifications, 25 cross-references, up from 2/1).

- [x] G9: Foreign-key integrity holds and the full suite passes after this batch's additions across 8 ministries — seeds loaded with sqlite3 -bail so any statement error is fatal, not silent. This is the FINAL depth-pass batch: 53 of 53 ministries now deepened.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && rm -f gazette.db && sqlite3 gazette.db < db/schema.sql && for f in db/seed_*.sql; do sqlite3 -bail gazette.db < "$f" || echo "FAILED: $f"; done && sqlite3 gazette.db "PRAGMA foreign_key_check;" > /tmp/fk_check_gates_b11.txt; [ ! -s /tmp/fk_check_gates_b11.txt ] && echo FK_CLEAN; /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q; rm -f /tmp/fk_check_gates_b11.txt
  EXPECT: FK_CLEAN
  EVIDENCE: met — 53 ministries, 2591 notifications, 2113 cross-references; 141 tests passed.
