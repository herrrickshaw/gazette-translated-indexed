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

| Ministry | Status | Notifications (before → after) | New subject threads |
|---|---|---|---|
| Power | done (pilot) | 6 → 34 | +8 |
| *(52 more ministries pending)* | | | |

The remaining 52 already-modeled ministries have not yet had a depth pass.
Given the scale (a full research-agent call per ministry, each comparable in
size to the Power pilot — roughly 200K+ tokens of agent work per ministry),
replicating this across all 53 modeled ministries is a substantial
undertaking, on the order of the entire original coverage-plan effort again.
Whether and how fast to run the remaining 52 is a pacing decision for
whoever picks this file up next — nothing here blocks doing them 5 at a time
(one research agent per ministry, still 5 concurrent agents per batch) the
same way the coverage-plan batches ran.
