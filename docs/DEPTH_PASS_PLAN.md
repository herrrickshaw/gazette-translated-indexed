# Depth Pass Plan

`docs/MINISTRY_COVERAGE_PLAN.md` got every ministry to a first, deliberately
bounded pass (2-3 real pairs each, enough to prove the pipeline works for
that ministry). This document tracks a second, deeper pass: going back over
each already-modeled ministry to find substantially more real material —
closing documented gaps, verifying noted-but-unconfirmed leads, and actively
searching for chains the first bounded pass never had time to reach.

## Pilot: Ministry of Power (2026-09-04)

Went from 6 notifications / 3 cross-references to **34 notifications / 22
cross-references** across 11 subject threads (3 original + 8 new). Two
documented gaps from the first pass were closed:

- **G.S.R. 488(E)**, the JERC chain's missing intermediate amendment, was
  found and dated (2021-07-13), closing a real gap the first pass had left
  open.
- **S.O. 2979(E)/S.O. 1033(E)**, a parallel TFL-programme companion pair
  noted but never verified, was fully confirmed with its own primary-text
  quote.

8 further real pairs/chains were found across subject areas the first pass
never touched (LED lamp standards, induction hob standards, two transmission-
scheme actions, Bhakra Beas Management Board Rules, Electricity Rules 2005,
Energy Conservation Rules 2012/PAT scheme). One real extractor gap was found
and fixed along the way: `extract/power_patterns.py` only tried the
amendment-in-notification template, missing two real shapes ("hereby
repeals ... Ministry of Power ... vide number X" and "further to amend the
notification ... Ministry of Power ... vide number X", neither containing
"makes the following amendment") — fixed by adding a second, already-existing
template (corrigendum-substitution) to the same module rather than writing
new extraction code, confirmed against the real text first.

A stray out-of-context Note fragment embedded mid-document in unrelated
LED-lamp text was correctly flagged by the research agent as a likely
copy-paste drafting artifact in the source gazette, not modeled as a real
cross-reference — the same discipline used throughout this project for
content that looks like a citation but isn't a genuine one.

See git history (commit message for this pilot) and `db/seed_power.sql`'s
own header comment for the full detail.

## How a depth-pass batch works

Same rhythm as the coverage-plan batches, adapted for depth instead of
breadth:

1. Before dispatching, read that ministry's current `db/seed_<ministry>.sql`
   in full — note every already-modeled citation (so the research agent
   doesn't re-report known material) and every documented gap/deferred lead
   (so it has concrete threads to try to close, not just "find more stuff").
2. Launch ONE research agent per ministry being deepened (not 5-per-batch
   the way the coverage-plan agents covered 5 *different* ministries — here
   each agent goes deep on a single ministry). Tell it explicitly: which
   citations are already known, which specific gaps/companion-pairs to try
   to close, and to aim for at least 5 new real pairs/chains, not the
   original bounded 2-3.
3. For each new real pair found: check whether it fits an existing shared
   template or that ministry's existing module (extend the module's
   docstring and tests with the new confirmation) before ever writing new
   extraction code. A genuinely new shape still needs its own 2+ independent
   real confirmations before becoming a shared template, same bar as the
   first pass.
4. Rewrite (not append-only) that ministry's `db/seed_<ministry>.sql`:
   documented gaps that got closed should show the closure in the file's own
   header comment, and a chain that turned out longer than first modeled
   (e.g. an intermediate amendment inserted into an existing edge) replaces
   the old edge rather than leaving both the old and new versions in the
   database.
5. Rebuild the full DB, confirm `PRAGMA foreign_key_check` is clean, run the
   full test suite.
6. Write a fresh `GATES.md` for the batch, lint it, approve/run it.
7. Commit and push. Update this file's status table below.

## Status

**41 of 53 ministries deepened.** User confirmed (2026-09-04) "full speed, same batching" — proceeding 5 ministries per batch, one dedicated research agent per ministry, continuously.

| Ministry | Status | Notifications (before → after) | New subject threads |
|---|---|---|---|
| Power | done (pilot) | 6 → 34 | +8 |
| Agriculture and Farmers Welfare | done | 5 → 30 | +6 (plus an 8-item gap closed) |
| Atomic Energy | done | 6 → 14 | real restructuring: 2 chains merged into 1 hub, +3 pairs |
| Ayush | done | 7 → 27 | +8 (plus a real citation correction: S.O. 221(E) → G.S.R. 221(E)) |
| Chemicals and Fertilizers | done | 6 → 44 | +13 (new subject area: QCO rescissions) |
| Civil Aviation | done | 4 → 24 | +8 |
| Coal | done | 10 → 33 | +5 (plus an 18-item pension-scheme gap closed) |
| Commerce and Industry | done | 12 → 30 | +6 (new format: SEZ area-adjustment tables) |
| Communications | done | 6 → 20 | +6 (real citation collision found and correctly kept distinct) |
| Consumer Affairs, Food and Public Distribution | done | 6 → 26 | +8 |
| Cooperation | done | 5 → 9 | +2 (plus a real sibling-notification discovery) |
| Corporate Affairs | done | 12 → 60 | +8 (large expansion; 2 summary-sourced leads deliberately deferred) |
| Culture | done | 6 → 27 | +4 subject areas (AMASR competent-authority 7-node chain, two 2-stage cessation pairs, three 2-stage declaration pairs, National Culture Fund) |
| Defence | done | 11 → 27 | +8 (bare-form DRDO/CSD/Cantonment Recruitment Rules; multiple real S.R.O.-number collisions across years correctly kept distinct) |
| DoNER | checked, no new material | 3 → 3 | none (entire tracked corpus is genuinely just 1 citing notification) |
| Earth Sciences | checked, corpus exhausted | 2 → 2 | none (full corpus reviewed, same 2 unmodelable leads as before) |
| Education | done | 12 → 36 | 2 existing chains extended +2 nodes each, +4 new subject threads |
| External Affairs | done | 7 → 23 | +4 (a recurring MEA trailing-Note drafting convention found across 3 threads) |
| Finance (other departments) | done | 6 → 110 | both flagged gaps closed (FEMA 18-item Note, DEA<->DFS chain), +14 new subject threads; a real G.S.R. 488(E) collision with Power correctly kept distinct |
| Fisheries, Animal Husbandry and Dairying | done | 15 → 40 | +6 new subject threads, +1 parallel sub-chain on the existing root node |
| Food Processing Industries | checked, corpus exhausted | 2 → 2 | none (all 6 tracker notifications + 2 NIFTEM controls re-opened) |
| Health and Family Welfare | done | 2 → 34 | +6 new subject threads, plus a closed draft-to-final deferred lead (G.S.R. 587(E)) |
| Heavy Industries | done | 6 → 29 | +7 new subject threads; PLI-Auto revealed as a 3-amendment hub |
| Information and Broadcasting | done | 9 → 61 | +8 new subject threads incl. a 29-node Cable TV Rules chain; 2 real citation collisions (G.S.R. 459(E), G.S.R. 719(E)) kept distinct |
| Jal Shakti | done | 40 → 94 | +9 new subject threads, several tribunal chains comparable in scale to the existing 36-node Ravi-Beas chain |
| Labour and Employment | done | 2 → 27 | +9 new pairs/chains incl. this ministry's first `rescinds` pairs; one deferred-lead citation correction (G.S.R. 706(E) -> G.S.R. 705(E)) |
| Electronics and Information Technology (MeitY) | done | 2 → 29 | +5 new subject threads, richest a 13-node Compulsory Registration Order chain; deferred lead closed and extended into a draft-to-final chain |
| Home Affairs | done | 2 → 49 | +13 new pairs/chains incl. a rich FCRR 2011 Note-chain and a novel UAPA Tribunal-confirmation preamble; both deferred leads confirmed |
| Mines | done | 15 → 62 | +8 new subject threads; Concession Rules corrigendum re-parented into a 17-node chain; a novel CGPB "one supersedes six" shape |
| Minority Affairs | done | 15 → 24 | +2 new note-chains, +2 nodes on the existing Haj chain (one exposing a real Ministry record-keeping gap) |
| Environment, Forest and Climate Change | done | 8 → 24 | +3 new subject areas beyond corrigenda (PWM Rules, CRZ, E-Waste), deliberately egazette-PDF-verified given this ministry's aggregator-mismatch history |
| Housing and Urban Affairs | done | 7 → 46 | +3 subject areas incl. the Metro Railways Act Schedule-alignment series (Pune Metro hub); six more UT/State RERA amendments; S.O. 2979(E) collision with Power kept distinct |
| Road Transport and Highways | done | 6 → 20 | +5 CMVR/adjacent-rules draft-to-final chains beyond land-acquisition corrigenda |
| Statistics and Programme Implementation | done | 4 → 16 | +4 subject areas from a 44-notification corpus; deferred S.O. 4544(E) lead closed via File-No. cross-match |
| MSME | done | 5 → 12 | +3 subject threads; one existing edge CORRECTED (3820 amends 3193, not 5403); deferred "GSR 381" lead closed as bare-form |
| New and Renewable Energy | done | 3 → 9 | documented 2017-Order gap resolved (S.O. 2920(E)); parallel >100kW chain; narrative-prose shape now has 5 real instances |
| Parliamentary Affairs | checked, corpus exhausted | 4 → 4 | none (all 28 notifications + 18 egazette PDFs re-read; LoP lead still fails the bare-form rule) |
| Personnel, Public Grievances and Pensions (DoPT/DoPPW) | done | 6 → 487 | +23 subject threads (CAT hubs, UPSC, AIS Pay/cadre-strength tables, Appointment-by-Promotion segments); CCS(CCA) intermediate G.S.R. 18(E) inserted; G.S.R. 331(E) re-identified |
| Petroleum and Natural Gas | done | 6 → 73 | 2 corrections (draft date; missing G.S.R. 196(E)); +11 threads incl. two 12-node EC Act Order chains; 3 collisions kept distinct; PNGRB deferred (issuer taxonomy) |
| Ports, Shipping and Waterways | done | 7 → 164 | ~45 chains: Inland Vessels draft->final cycles, 11 ports' board-seat supersessions, 9 port-of-import continuations; 6 in-ministry collisions kept distinct |
| Posts | done | 4 → 242 | Regulations chain 4->15 nodes (S.O. 4053(E) re-parented); the 1933 Rules' 207-entry official history transcribed; +5 threads |
| *(12 more ministries pending)* | | | |

Given the scale (a full research-agent call per ministry, often 150-250K
tokens of agent work), replicating this across all remaining ministries is a
substantial undertaking, on the order of the entire original coverage-plan
effort again. Continuing 5 at a time (one research agent per ministry, still
5 concurrent agents per batch) the same way the coverage-plan batches ran.
