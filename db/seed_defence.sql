-- Ministry of Defence. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original 2-pair pass. Both known
-- S.R.O. pairs re-confirmed with no further amendments; the deferred
-- bare-form Corrigendum No. 11(E) re-confirmed identical, not modeled.
--
-- Eight further real pairs/chains found, several multi-hop, across
-- Cantonment Board membership (a second board, distinct from the
-- already-known one), DRDO Recruitment Rules (three chains), and Canteen
-- Stores Department Recruitment Rules (two chains). Many of these real
-- chains' older links are cited in a genuinely bare pre-"(E)" S.R.O. form
-- (e.g. "S.R.O. 68, dated 28th October, 2011") — modeled as bare rows per
-- established precedent even though the live regex requires the "(E)"
-- suffix.
--
-- REAL CITATION COLLISION RISK, handled explicitly: S.R.O. numbers reset
-- annually, so e.g. "S.R.O. 3(E)" and "S.R.O. 6(E)" each denote TWO
-- completely different real notifications in different years (2025 vs.
-- 2026) — kept as distinct gazette_id rows throughout, the same
-- discipline applied to Communications' G.S.R. 796(E) collision this
-- same batch.
--
-- SECOND DEPTH PASS (2026-09-07). Defence had already had one depth pass
-- (2026-09-04, above), so this was a search for material beyond an
-- already-deepened ministry, not a first look. gazettetracker.com's
-- Ministry of Defence listing runs to 300 notifications across 6 pages;
-- read broadly rather than exhaustively (Cantonment Board building
-- bye-laws drafts, honorary-commission/rank notices, RR amendments,
-- land-restriction notices) and confirmed 4 more real, genuinely new
-- cross-references from primary "Full Text", all consistent with the
-- existing extractor with no code changes needed:
--
-- 1-3. A drafting convention not previously modeled for this ministry: the
--    Cantonment Board "constitution" notification for a given cycle
--    routinely opens with "... read with the notification of the
--    Government of India in the Ministry of Defence [number] S.R.O.
--    <X>(E), dated <date> ... containing the declaration varying certain
--    Cantonment Boards" — citing the immediately preceding "variation"
--    notification for the same cycle. Found and verified for THREE
--    already-modeled "constitution" notifications that had no upstream
--    citation recorded: S.R.O. 1(E) [2025-01-03, Board B] cites S.R.O.
--    206(E) [2024-12-31]; S.R.O. 19(E) [2025-11-12, Board A] cites S.R.O.
--    18(E) [2025-11-10]; S.R.O. 2(E) [2026-01-19, Board B] cites S.R.O.
--    1(E) [2026-01-16]. Each cited "variation" notification is a terminal
--    node (own primary text checked; no further citation), and none
--    amends its citing document — modeled as relation_type='cites', same
--    convention used elsewhere in this project for a "read with"/context
--    reference that isn't itself an amendment. Note the second and third
--    of these introduce a fourth and fifth real "S.R.O. 1(E)" / "S.R.O.
--    18(E)" collision year (2026 and 2025 respectively) beside the ones
--    already tracked above — kept distinct by gazette_id as always.
--
-- 4. A third, previously unmodeled Canteen Stores Department Recruitment
--    Rules chain, alongside the existing Group A and Group A-and-B ones:
--    S.R.O. 7(E) [2025-04-30] amends the Canteen Stores Department (Joint
--    General Manager Grade-II) Recruitment Rules, 1994, whose own trailing
--    Note cites its principal rules as "notification number S.R.O. 58
--    dated the 28th March, 1994" — a genuinely bare (no "(E)") S.R.O.
--    number, modeled as a bare row per the same established precedent as
--    the DRDO/CSD bare-form links above (the live regex requires a
--    parenthetical letter, so find_note_chain does not recover this one
--    automatically; it is still modeled here because a human research
--    pass confirmed it against primary text). The other two RR
--    notifications gazetted the same day (S.R.O. 6(E) amending Group A,
--    S.R.O. 8(E) amending Group A-and-B) were re-checked and are both
--    already fully modeled above — no changes there.
--
-- The honorary-commission/rank "Corrigendum" [No. 11(E), 15 Aug 2026] and
-- several others like it were read and are NOT modeled: every citation on
-- both sides is a bare "Notification No. 01(E)"/"No. 09(E)"/"No. 04" form
-- with no G.S.R./S.O./S.R.O. series at all — not one of the three
-- recognized numbering forms, so it is left as a documented unmodeled lead
-- rather than forced. The many Cantonment "draft building bye-laws, 2026"
-- notifications proposing to "supersede Notification Number 107 dated 20th
-- March, 1954" (Ayodhya), "notification number 492, dated 22.04.1939"
-- (Barrackpore), and similar pre-independence-era bare numbers are the
-- same unmodelable bare-Notification-number class, and are also drafts (no
-- final notification confirmed) — not modeled, same as the first pass's
-- own documented gaps.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('defence', 'Ministry of Defence', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('cantonments-act-2006', 'Cantonments Act, 2006', 2006),
  ('navy-act-1957', 'Navy Act, 1957', 1957),
  ('drdo-vehicle-operator-rr-2017', 'DRDO Vehicle Operator A/B/C Recruitment Rules, 2017', 2017),
  ('drdo-fire-service-rr-2011', 'DRDO Group C Fire Service Recruitment Rules, 2011', 2011),
  ('drdo-fire-engine-driver-rr-2017', 'DRDO Group C Fire Engine Driver Recruitment Rules, 2017', 2017),
  ('drdo-security-rr-2012', 'DRDO Group C (Security) Recruitment Rules, 2012', 2012),
  ('csd-group-a-rr-1988', 'Canteen Stores Department Group A Posts Recruitment Rules, 1988', 1988),
  ('csd-group-ab-rr-1979', 'Canteen Stores Department Group A and B Posts Recruitment Rules, 1979', 1979),
  ('csd-jgm-grade2-rr-1994', 'Canteen Stores Department (Joint General Manager Grade-II) Recruitment Rules, 1994', 1994);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('defence-cantonment-board-member', 'Cantonment Board member substitution (Board A)', 'active'),
  ('defence-cantonment-board-member-2', 'Cantonment Board member substitution (Board B)', 'active'),
  ('defence-navy-act-service-branch', 'Navy Act service-branch listing amendment', 'active'),
  ('defence-drdo-vehicle-operator-rr', 'DRDO Vehicle Operator Recruitment Rules amendment', 'active'),
  ('defence-drdo-fire-service-rr', 'DRDO Fire Service Recruitment Rules and its amendments', 'active'),
  ('defence-drdo-fire-engine-driver-rr', 'DRDO Fire Engine Driver Recruitment Rules amendment', 'active'),
  ('defence-drdo-security-rr', 'DRDO Security Recruitment Rules and its amendments', 'active'),
  ('defence-csd-group-a-rr', 'CSD Group A Recruitment Rules and its amendment', 'active'),
  ('defence-csd-group-ab-rr', 'CSD Group A and B Recruitment Rules and its amendment', 'active'),
  ('defence-csd-jgm2-rr', 'CSD Joint General Manager Grade-II Recruitment Rules and its amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Cantonment Board (already known)
  ('defence-sro-19-2025', 'Defence', 'S.R.O. 19(E)', 2025, 'so-only', '2025-11-12', 'S.R.O. 19(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member'),
  ('defence-sro-18-2026', 'Defence', 'S.R.O. 18(E)', 2026, 'so-only', '2026-07-15', 'S.R.O. 18(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member'),
  ('defence-sro-9-2022',  'Defence', 'S.R.O. 9(E)',  2022, 'so-only', '2022-06-23', 'S.R.O. 9(E)',  'defence', 'navy-act-1957', 'defence-navy-act-service-branch'),
  ('defence-sro-22-2025', 'Defence', 'S.R.O. 22(E)', 2025, 'so-only', '2025-10-02', 'S.R.O. 22(E)', 'defence', 'navy-act-1957', 'defence-navy-act-service-branch'),
  -- Cantonment Board (Board B, 2026) — new
  ('defence-sro-2-2026-cantonment',  'Defence', 'S.R.O. 2(E)', 2026, 'so-only', '2026-01-19', 'S.R.O. 2(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member-2'),
  ('defence-sro-17-2026-cantonment', 'Defence', 'S.R.O. 17(E)', 2026, 'so-only', '2026-07-15', 'S.R.O. 17(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member-2'),
  -- Cantonment Board (Board B, 2025) — new, distinct notification from Board A's 2025 pair
  ('defence-sro-1-2025-cantonment', 'Defence', 'S.R.O. 1(E)', 2025, 'so-only', '2025-01-03', 'S.R.O. 1(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member-2'),
  ('defence-sro-3-2025-cantonment', 'Defence', 'S.R.O. 3(E)', 2025, 'so-only', '2025-03-06', 'S.R.O. 3(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member-2'),
  -- DRDO Vehicle Operator RR
  ('defence-sro-95-2017-vehicle', 'Defence', 'S.R.O. 95', 2017, 'bare', '2017-10-27', 'S.R.O. 95', 'defence', 'drdo-vehicle-operator-rr-2017', 'defence-drdo-vehicle-operator-rr'),
  ('defence-sro-5-2026-vehicle',  'Defence', 'S.R.O. 5(E)', 2026, 'so-only', '2026-04-13', 'S.R.O. 5(E)', 'defence', 'drdo-vehicle-operator-rr-2017', 'defence-drdo-vehicle-operator-rr'),
  -- DRDO Fire Service RR chain
  ('defence-sro-68-2011-fire', 'Defence', 'S.R.O. 68', 2011, 'bare', '2011-10-28', 'S.R.O. 68', 'defence', 'drdo-fire-service-rr-2011', 'defence-drdo-fire-service-rr'),
  ('defence-sro-35-2017-fire', 'Defence', 'S.R.O. 35', 2017, 'bare', '2017-04-21', 'S.R.O. 35', 'defence', 'drdo-fire-service-rr-2011', 'defence-drdo-fire-service-rr'),
  ('defence-sro-85-2017-fire', 'Defence', 'S.R.O. 85', 2017, 'bare', '2017-10-11', 'S.R.O. 85', 'defence', 'drdo-fire-service-rr-2011', 'defence-drdo-fire-service-rr'),
  ('defence-sro-4-2026-fire',  'Defence', 'S.R.O. 4(E)', 2026, 'so-only', '2026-04-13', 'S.R.O. 4(E)', 'defence', 'drdo-fire-service-rr-2011', 'defence-drdo-fire-service-rr'),
  -- DRDO Fire Engine Driver RR
  ('defence-sro-2-2017-driver', 'Defence', 'S.R.O. 2', 2017, 'bare', '2017-12-28', 'S.R.O. 2', 'defence', 'drdo-fire-engine-driver-rr-2017', 'defence-drdo-fire-engine-driver-rr'),
  ('defence-sro-6-2026-driver', 'Defence', 'S.R.O. 6(E)', 2026, 'so-only', '2026-04-13', 'S.R.O. 6(E)', 'defence', 'drdo-fire-engine-driver-rr-2017', 'defence-drdo-fire-engine-driver-rr'),
  -- DRDO Security RR chain
  ('defence-sro-96-2012-security', 'Defence', 'S.R.O. 96', 2012, 'bare', '2012-10-31', 'S.R.O. 96', 'defence', 'drdo-security-rr-2012', 'defence-drdo-security-rr'),
  ('defence-sro-9-2014-security',  'Defence', 'S.R.O. 9',  2014, 'bare', '2014-12-23', 'S.R.O. 9',  'defence', 'drdo-security-rr-2012', 'defence-drdo-security-rr'),
  ('defence-sro-28-2017-security', 'Defence', 'S.R.O. 28', 2017, 'bare', '2017-03-20', 'S.R.O. 28', 'defence', 'drdo-security-rr-2012', 'defence-drdo-security-rr'),
  ('defence-sro-91-2017-security', 'Defence', 'S.R.O. 91', 2017, 'bare', '2017-10-26', 'S.R.O. 91', 'defence', 'drdo-security-rr-2012', 'defence-drdo-security-rr'),
  ('defence-sro-3-2026-security',  'Defence', 'S.R.O. 3(E)', 2026, 'so-only', '2026-04-13', 'S.R.O. 3(E)', 'defence', 'drdo-security-rr-2012', 'defence-drdo-security-rr'),
  -- CSD Group A RR chain
  ('defence-sro-99-1988-csda',  'Defence', 'S.R.O. 99',  1988, 'bare', '1988-04-20', 'S.R.O. 99',  'defence', 'csd-group-a-rr-1988', 'defence-csd-group-a-rr'),
  ('defence-sro-360-1989-csda', 'Defence', 'S.R.O. 360', 1989, 'bare', '1989-12-20', 'S.R.O. 360', 'defence', 'csd-group-a-rr-1988', 'defence-csd-group-a-rr'),
  ('defence-sro-6-2025-csda',   'Defence', 'S.R.O. 6(E)', 2025, 'so-only', '2025-04-30', 'S.R.O. 6(E)', 'defence', 'csd-group-a-rr-1988', 'defence-csd-group-a-rr'),
  -- CSD Group A and B RR chain
  ('defence-sro-64-1979-csdab',  'Defence', 'S.R.O. 64',  1979, 'bare', '1979-02-15', 'S.R.O. 64',  'defence', 'csd-group-ab-rr-1979', 'defence-csd-group-ab-rr'),
  ('defence-sro-359-1989-csdab', 'Defence', 'S.R.O. 359', 1989, 'bare', '1989-12-20', 'S.R.O. 359', 'defence', 'csd-group-ab-rr-1979', 'defence-csd-group-ab-rr'),
  ('defence-sro-8-2025-csdab',   'Defence', 'S.R.O. 8(E)', 2025, 'so-only', '2025-04-30', 'S.R.O. 8(E)', 'defence', 'csd-group-ab-rr-1979', 'defence-csd-group-ab-rr'),
  -- Cantonment Board cycle "variation" notifications — newly found upstream
  -- citations of three already-modeled "constitution" notifications (see
  -- header comment). Each is a terminal node in its own right.
  ('defence-sro-206-2024-var', 'Defence', 'S.R.O. 206(E)', 2024, 'so-only', '2024-12-31', 'S.R.O. 206(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member-2'),
  ('defence-sro-18-2025-var',  'Defence', 'S.R.O. 18(E)',  2025, 'so-only', '2025-11-10', 'S.R.O. 18(E)',  'defence', 'cantonments-act-2006', 'defence-cantonment-board-member'),
  ('defence-sro-1-2026-var',   'Defence', 'S.R.O. 1(E)',   2026, 'so-only', '2026-01-16', 'S.R.O. 1(E)',   'defence', 'cantonments-act-2006', 'defence-cantonment-board-member-2'),
  -- CSD Joint General Manager Grade-II RR chain — new third CSD thread
  ('defence-sro-58-1994-csdjgm2', 'Defence', 'S.R.O. 58', 1994, 'bare', '1994-03-28', 'S.R.O. 58', 'defence', 'csd-jgm-grade2-rr-1994', 'defence-csd-jgm2-rr'),
  ('defence-sro-7-2025-csdjgm2',  'Defence', 'S.R.O. 7(E)', 2025, 'so-only', '2025-04-30', 'S.R.O. 7(E)', 'defence', 'csd-jgm-grade2-rr-1994', 'defence-csd-jgm2-rr');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('defence-sro-18-2026', 'defence-sro-19-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-22-2025', 'defence-sro-9-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-17-2026-cantonment', 'defence-sro-2-2026-cantonment', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-3-2025-cantonment',  'defence-sro-1-2025-cantonment', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-5-2026-vehicle', 'defence-sro-95-2017-vehicle', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-35-2017-fire', 'defence-sro-68-2011-fire', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-85-2017-fire', 'defence-sro-35-2017-fire', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-4-2026-fire',  'defence-sro-85-2017-fire', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-6-2026-driver', 'defence-sro-2-2017-driver', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-9-2014-security',  'defence-sro-96-2012-security', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-28-2017-security', 'defence-sro-9-2014-security',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-91-2017-security', 'defence-sro-28-2017-security', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-3-2026-security',  'defence-sro-91-2017-security', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-360-1989-csda', 'defence-sro-99-1988-csda',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-6-2025-csda',   'defence-sro-360-1989-csda', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-359-1989-csdab', 'defence-sro-64-1979-csdab',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-8-2025-csdab',   'defence-sro-359-1989-csdab', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Second depth pass (2026-09-07), see header comment
  ('defence-sro-1-2025-cantonment', 'defence-sro-206-2024-var', 'cites', 'research-agent-quoted', '2026-09-07'),
  ('defence-sro-19-2025',           'defence-sro-18-2025-var',  'cites', 'research-agent-quoted', '2026-09-07'),
  ('defence-sro-2-2026-cantonment', 'defence-sro-1-2026-var',   'cites', 'research-agent-quoted', '2026-09-07'),
  ('defence-sro-7-2025-csdjgm2',    'defence-sro-58-1994-csdjgm2', 'amends', 'research-agent-quoted', '2026-09-07');
