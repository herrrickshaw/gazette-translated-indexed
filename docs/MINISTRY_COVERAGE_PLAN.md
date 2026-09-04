# Ministry Coverage Plan

**STATUS: COMPLETE.** Every ministry/department in this plan's scope has been modeled or honestly abandoned across 12 batches. This document is kept as a reference for the process used and as the entry point for extending coverage later (a new ministry reorganization, a deeper pass on an already-"done" ministry, or picking up one of the deliberately-deferred bare-form leads if this project ever adds support for that citation shape).

Tracks progress toward citation-linking every central Government of India ministry/department. Updated after every batch — see `GATES.md` (current batch, reset each session) and git history (past batches) for the detailed evidence behind each row.

## How a batch works

Established over 12 batches, kept here for anyone extending this project's coverage later:

1. Launch 5 parallel research agents (one per ministry), each told to find 2-3 REAL corrigendum/amendment/supersession pairs via gazettetracker.com's Full Text (primary) sections — never the AI summary — and to report "found nothing usable" honestly rather than force a weak match.
2. For each result: check whether it fits one of the existing shared templates (`extract/common_templates.py`: amendment-in-notification, corrigendum-substitution, supersession-preamble, bare-citation-reference, note-chain) or an existing ministry-specific module (reuse `find_after_anchor` with a custom anchor, per `extract/railways_patterns.py` / `extract/chemicals_fertilizers_patterns.py` / `extract/personnel_patterns.py`; combine more than one shared template in one module when a ministry's real evidence needs it, per `extract/external_affairs_patterns.py` / `extract/ports_shipping_patterns.py`). Only write a genuinely new template after 2+ independent real confirmations — never from one example.
3. Write a regression test against the real quoted text for anything new; run it before writing seed data.
4. Write `db/seed_<ministry>.sql` with real dates/citations only. A lead with no G.S.R./S.O./S.R.O. citation on both ends, or citing an Act/Regulation/File-number form the schema doesn't represent, is documented and left unmodeled — never forced.
5. If a ministry has genuinely nothing linkable (checked, not assumed), abandon it outright with a documented reason — same weight as a modeled ministry, not a failure.
6. Rebuild the full DB from `schema.sql` + all seeds, confirm `PRAGMA foreign_key_check` is clean, run the full test suite.
7. Write a fresh `GATES.md` for the batch (checkable gates + `ABANDON:` entries), lint it, approve/run it.
8. Commit and push.

## Status

**56 of 56 ministries/departments processed — 0 remain.** (53 modeled as 53 distinct `ministry_id` rows, 3 honestly abandoned.) Total was revised from 57 to 56 mid-plan: School Education and Literacy + Higher Education turned out to share one real ministry (Batch 11) and are counted once; Finance and Communications each ended up split across two `ministry_id` rows (Revenue/CBIC vs. other departments; Telecommunications vs. Posts) since the schema stores one department string per row.

### Done — modeled (53 ministry_id rows)

Agriculture and Farmers Welfare · Atomic Energy (Department) · Ayush · Chemicals and Fertilizers · Civil Aviation · Coal · Commerce and Industry · Communications (Dept. of Telecommunications) · Consumer Affairs, Food and Public Distribution · Cooperation · Corporate Affairs · Culture · Defence · Development of North Eastern Region (DoNER) · Earth Sciences · Education (School Education and Literacy + Higher Education, one ministry) · Electronics and Information Technology · Environment, Forest and Climate Change · External Affairs · Finance (Revenue/CBIC) · Finance (other departments: Economic Affairs, Expenditure, Financial Services, DIPAM) · Fisheries, Animal Husbandry and Dairying · Food Processing Industries · Health and Family Welfare · Heavy Industries · Home Affairs · Housing and Urban Affairs · Information and Broadcasting · Jal Shakti · Labour and Employment · Micro, Small and Medium Enterprises · Mines · Minority Affairs · New and Renewable Energy · Parliamentary Affairs · Personnel, Public Grievances and Pensions · Petroleum and Natural Gas · Ports, Shipping and Waterways · Posts (Dept. of Posts) · Power · Railways · Road Transport and Highways · Rural Development · Science and Technology · Skill Development and Entrepreneurship · Social Justice and Empowerment · Space (Department) · Statistics and Programme Implementation · Steel · Textiles · Tribal Affairs · Women and Child Development · Youth Affairs and Sports

### Done — abandoned (3, documented in git history)

- **Law and Justice** — all real pairs found cite Act/Regulation numbers ("Reg. 2 of 2026"), never G.S.R./S.O./S.R.O.; no "Ministry of X" anchor either.
- **Tourism** — only 4 notifications in the tracker; every pair cites a G.S.R. number on the amending side only, never the target — nothing to link to.
- **Panchayati Raj** — only 2 notifications in the tracker, both Resolutions cited by file number only, with no amendment relationship between them.

### Final template inventory

Five shared templates in `extract/common_templates.py`: amendment-in-notification, corrigendum-substitution, supersession-preamble, bare-citation-reference, and note-chain (its "Note[:.-]" anchor also matches "Footnote:" — a real Ministry of Information and Broadcasting shape that plain `\bnote\b` structurally could not match). Plus ministry-specific modules reusing `find_after_anchor` directly for shapes that don't fit any shared anchor (Railways, Chemicals/Fertilizers' NPPA anchor, Personnel/DoPT's reversed-order anchor), and modules that try more than one ministry-name variant per document (Information and Broadcasting's full-vs-shortened name, Jal Shakti's current-vs-predecessor name, Education's current-vs-pre-2020-MHRD name, Youth Affairs and Sports' "&"-vs-"and").

Any ministry that turns out, on inspection, to already be split across departments already modeled elsewhere gets folded into that same real ministry rather than double-counted (Education); one that turns out to need a genuinely separate department row under the same ministry name gets one (Finance, Communications) — the plan is a guide, not a guarantee every entry survives contact with the real tracker unchanged.

## Extending this later

To add a new ministry, reorganization, or a deeper pass on one already modeled: follow "How a batch works" above, pick real ministries not yet in the "Done" lists (or an already-"done" one, for a deeper pass), and update this file's Status section afterward the same way each batch did.

## Known limits this plan doesn't try to fix

- **gazettetracker.com is the only source used.** It is a third-party aggregator, not the official egazette.gov.in archive — chosen for session-to-session practicality (see `README.md` for the one bounded direct-egazette.gov.in fetch this project also did). Its coverage of any given ministry is whatever it happened to index, not that ministry's complete gazette history — "found nothing usable" for a ministry means "nothing usable in this tracker," not "this ministry issues no rules."
- **Only G.S.R./S.O./S.R.O. citations are modeled.** Real amendments cited by bare Notification/File/Resolution/Act number are deliberately left out rather than forced — see any `db/seed_*.sql` header comment for that ministry's specific unmodeled leads.
- **Every batch is a sample, not an exhaustive scan.** A ministry marked "done" may have real amendment chains this project never surfaced — it means "found and modeled what a bounded research pass turned up," not "modeled everything that exists."
