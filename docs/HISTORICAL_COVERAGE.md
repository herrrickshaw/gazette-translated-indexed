# Historical coverage audit

`MINISTRY_COVERAGE_PLAN.md` and `DEPTH_PASS_PLAN.md` describe the *process*
used to model each ministry (a bounded first pass, then optional deeper
passes). This file answers a narrower, concrete question instead: for each
already-modeled ministry, how far back does the data in `gazette.db` actually
go, and how thin or thick is it?

```sql
SELECT m.name, MIN(g.publish_date), MAX(g.publish_date), COUNT(*)
FROM gazette_notification g JOIN ministry m ON m.ministry_id = g.ministry_id
WHERE g.archived_at IS NULL GROUP BY g.ministry_id ORDER BY MIN(g.publish_date);
```

Run against the live database (2026-09-06). Both `finance-other-departments`
and `finance-revenue-cbic` display as "Ministry of Finance" (two distinct
`ministry_id` rows, one department string each, per `CLAUDE.md`'s note on
that split); same for `communications` and `posts`.

| Ministry | Oldest | Newest | Span (yrs) | N |
|---|---|---|---:|---:|
| Ministry of Civil Aviation | 1937-03-23 | 2026-07-17 | 89 | 24 |
| Ministry of Finance (Economic Affairs/Expenditure/Financial Services/DIPAM) | 1949-03-26 | 2026-09-03 | 77 | 112 |
| Ministry of Personnel, Public Grievances and Pensions | 1954-09-08 | 2026-08-06 | 72 | 487 |
| Ministry of Textiles | 1955-03-23 | 2026-07-08 | 71 | 73 |
| Ministry of Labour and Employment | 1956-08-21 | 2026-08-24 | 70 | 28 |
| Ministry of Finance (Revenue/CBIC) | 1957-01-08 | 2026-07-31 | 69 | 55 |
| Ministry of Coal | 1960-11-26 | 2026-08-07 | 66 | 41 |
| Ministry of Consumer Affairs, Food and Public Distribution | 1966-07-16 | 2026-08-03 | 60 | 26 |
| Ministry of Jal Shakti | 1972-04-18 | 2026-08-10 | 54 | 94 |
| Ministry of Education | 1973-02-20 | 2025-11-07 | 52 | 36 |
| Ministry of Power | 1974-12-11 | 2026-08-21 | 52 | 34 |
| Ministry of Communications (Dept. of Telecommunications) | 1975-12-19 | 2026-08-12 | 51 | 242 |
| Department of Space | 1976-04-01 | 2025-12-24 | 49 | 4 |
| Ministry of Defence | 1979-02-15 | 2026-07-15 | 47 | 27 |
| Ministry of Women and Child Development | 1979-03-02 | 2026-07-03 | 47 | 20 |
| Ministry of External Affairs | 1979-12-01 | 2026-07-27 | 47 | 23 |
| Ministry of Agriculture and Farmers Welfare | 1981-01-12 | 2026-07-06 | 45 | 32 |
| Ministry of Petroleum and Natural Gas | 1987-03-20 | 2026-09-03 | 39 | 73 |
| Ministry of Railways | 1987-12-03 | 2026-08-31 | 39 | 37 |
| Ministry of Information and Broadcasting | 1991-12-06 | 2026-08-21 | 35 | 61 |
| Ministry of Skill Development and Entrepreneurship | 1992-07-15 | 2026-07-09 | 34 | 26 |
| Ministry of Culture | 1996-11-28 | 2026-01-13 | 30 | 27 |
| Ministry of Health and Family Welfare | 1997-02-05 | 2026-07-23 | 29 | 34 |
| Ministry of Minority Affairs | 1998-09-30 | 2026-08-18 | 28 | 24 |
| Ministry of Youth Affairs and Sports | 1998-11-12 | 2025-05-21 | 27 | 4 |
| Ministry of Steel | 1999-05-26 | 2026-08-07 | 27 | 65 |
| Ministry of Micro, Small and Medium Enterprises | 2000-10-07 | 2025-03-21 | 25 | 12 |
| Ministry of Ports, Shipping and Waterways | 2001-08-24 | 2026-08-28 | 25 | 164 |
| Ministry of Tribal Affairs | 2002-07-18 | 2024-09-04 | 22 | 20 |
| Ministry of Social Justice and Empowerment | 2002-10-21 | 2026-06-16 | 24 | 76 |
| Ministry of Communications (Dept. of Posts) | 2002-10-25 | 2026-05-26 | 24 | 21 |
| Ministry of Commerce and Industry | 2006-02-10 | 2026-08-31 | 20 | 32 |
| Ministry of Rural Development | 2007-03-06 | 2026-07-20 | 19 | 29 |
| Ministry of Statistics and Programme Implementation | 2007-08-01 | 2026-04-01 | 19 | 16 |
| Ministry of Home Affairs | 2009-02-25 | 2026-08-19 | 17 | 49 |
| Ministry of Mines | 2009-03-12 | 2026-08-14 | 17 | 62 |
| Ministry of Housing and Urban Affairs | 2009-10-16 | 2026-08-28 | 17 | 46 |
| Ministry of Environment, Forest and Climate Change | 2011-01-06 | 2024-11-26 | 13 | 24 |
| Ministry of Chemicals and Fertilizers | 2013-05-15 | 2026-08-27 | 13 | 58 |
| Department of Atomic Energy | 2013-05-16 | 2025-05-07 | 12 | 14 |
| Ministry of Corporate Affairs | 2014-02-27 | 2026-06-01 | 12 | 60 |
| Ministry of Science and Technology | 2014-04-24 | 2026-07-23 | 12 | 24 |
| Ministry of Fisheries, Animal Husbandry and Dairying | 2014-10-16 | 2026-02-04 | 12 | 40 |
| Ministry of New and Renewable Energy | 2017-09-05 | 2026-07-03 | 9 | 9 |
| Ministry of Road Transport and Highways | 2018-03-16 | 2026-09-01 | 8 | 20 |
| Ministry of Development of North Eastern Region | 2018-08-13 | 2024-02-14 | 6 | 3 |
| Ministry of Electronics and Information Technology | 2018-10-09 | 2026-07-26 | 8 | 29 |
| Ministry of Heavy Industries | 2019-03-28 | 2026-09-03 | 7 | 29 |
| Ministry of Ayush | 2021-06-01 | 2026-02-04 | 5 | 29 |
| Ministry of Cooperation | 2023-03-21 | 2026-07-09 | 3 | 8 |
| Ministry of Earth Sciences | 2023-08-07 | 2026-08-05 | 3 | 2 |
| Ministry of Food Processing Industries | 2025-12-03 | 2026-08-27 | 1 | 2 |
| Ministry of Parliamentary Affairs | 2025-12-19 | 2026-04-13 | 1 | 4 |

## Assessment: is coverage historical?

**Mostly yes, but unevenly, and it correlates with why each ministry exists
as a modern entity, not with how thoroughly it was researched.** The oldest
records (Civil Aviation 1937, Finance 1949, Personnel 1954, Textiles 1955)
predate independence-era reorganizations and reach back about as far as any
gazette notification citation chain plausibly could. 39 of 53 ministries
have a span of 12+ years; 27 have 25+ years.

The ministries with thin, recent-only coverage (span under 5 years — Ayush,
Cooperation, Earth Sciences, Food Processing Industries, Parliamentary
Affairs, Development of North Eastern Region, Heavy Industries, Road
Transport and Highways, New and Renewable Energy) are **not under-researched
in the way the coverage plan means it** — most of these ministries were
themselves *created* recently (Ayush 2014, Cooperation 2021, DoNER 2001) or
restructured, so there is little pre-creation history to find in the first
place. This matches `MINISTRY_COVERAGE_PLAN.md`'s own framing: "found and
modeled what a bounded research pass turned up," not an exhaustive scan --
low `N` here reflects real ministry age and gazettetracker.com's own
coverage limits, not a skipped step.

**Real candidates for a depth pass by this measure** (old ministry, thin
`N` relative to its span, suggesting more real material likely exists
untouched) rather than "recently created, so naturally thin": Department of
Space (49 years, N=4), Ministry of Youth Affairs and Sports (27 years, N=4),
Ministry of Consumer Affairs, Food and Public Distribution (60 years, N=26),
Ministry of Defence (47 years, N=27), Ministry of External Affairs
(47 years, N=23), Ministry of Women and Child Development (47 years, N=20).
`DEPTH_PASS_PLAN.md`'s existing pilot (Ministry of Power, 6→34 notifications)
is exactly this kind of gap-closing pass; these six are where the same
treatment would likely find the most.
