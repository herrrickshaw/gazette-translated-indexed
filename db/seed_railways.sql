-- Ministry of Railways pilot.
--
-- Modeled: S.O. 4815(E) corrects survey numbers in S.O. 2950(E) — the South
-- Western Railway (Construction Organisation) example, verified_by
-- 'research-agent-quoted'. This is the exact "minor survey-number
-- correction, hard to trace back" pattern the whole project targets.
--
-- Note: S.O. 2950(E) is cited as "dated 08.09.2026" in the corrigendum's own
-- primary text, which post-dates the corrigendum itself (31 Aug 2026) — an
-- internal inconsistency in the source document (likely an OCR/typo
-- artifact), flagged by the research agent and kept as printed rather than
-- silently corrected.
--
-- Depth pass (2026-09-05): a dedicated research agent surveyed 3,349
-- tracked items (Dec 2024 - Sep 2026) across ~10 zonal railways and the
-- Railway Board, confirming each zonal division drafts its own corrigendum
-- format independently even within one ministry. Modeled below: a 3-node
-- South Central Railway ROB corrigendum chain; a 9-node North Western
-- Railway (Construction Organisation) land-acquisition cluster including
-- this project's first "amendment-in-notification" template seen in
-- Railways and a novel "CANCELLATION" shape (a 20E notification voided for
-- a Hindi-version printing error); two representative North East Frontier
-- Railway one-line corrigenda (of six found, in an even terser format);
-- and ten Railway Board G.S.R. Note-chain pairs (Open Lines Rules,
-- Passenger Cancellation Rules, Public Carriage Rules, RPF Rules, Red
-- Tariff Rules incl. a genuine same-day double-publication, Kolkata Metro
-- Rules, Container Train Operators Rules).
--
-- The original flagged inconsistency (S.O. 2950(E) dated "08.09.2026" in
-- S.O. 4815(E)'s own text, post-dating that corrigendum) was resolved:
-- S.O. 2950(E)'s own page gives its signing date as 8th June 2026,
-- confirming "08.09.2026" is a dd.mm typo for 08.06.2026.
--
-- Deferred, not modeled this pass (real leads, out of this pass's bounded
-- scope — a full agent report of ~3,300 items yielded far more real pairs
-- than this file captures; see the agent's own report for the complete
-- inventory): four more North East Frontier Railway corrigenda of the
-- same shape as the two modeled; the Central Railway "re-issue under a
-- new S.O." corrigendum format (targets cited by gazette issue number,
-- not S.O. number — at least 24 more titles of this shape were seen but
-- not individually opened); South Western Railway withdrawal-from-
-- acquisition notifications; Metro Railway Kolkata's bare gazette-issue
-- citations; East Central Railway's and South East Central Railway's
-- single corrigenda; three more Northern Railway (Construction
-- Organization) corrigenda in three distinct formats; five more Railway
-- Board G.S.R. Note-chain pairs (IRMS, Prosecution Cadre, Library
-- Officer, Dy CAO, Stenographers' Service, Cleanliness Penalties
-- Amendment Rules); the Western Railway S.O. 4509(E)/S.O. 4445(E) pair
-- (Oct 2023, outside the tracker's listing range, not independently
-- located); the Railway Board Secretariat Service Rules 2026 repeal of
-- the 1969 Rules (title-only, no number).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('railways', 'Ministry of Railways', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('railways-act-1989-s20', 'Railways Act, 1989 — section 20A/20E land acquisition', 1989);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('railways-land-acquisition-corrections', 'Railways land-acquisition notifications and their corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- publish_date corrected 2026-09-05: 2026-06-08 (own signing date; "08.09.2026" in the corrigendum was a dd.mm typo)
  ('railways-so-2950-2026', 'Railways Act 1989', 'S.O. 2950(E)', 2026, 'so-only', '2026-06-08', 'S.O. 2950(E)', 'railways', 'railways-act-1989-s20', 'railways-land-acquisition-corrections'),
  ('railways-so-4815-2026', 'Railways Act 1989', 'S.O. 4815(E)', 2026, 'so-only', '2026-08-31', 'S.O. 4815(E)', 'railways', 'railways-act-1989-s20', 'railways-land-acquisition-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('railways-so-4815-2026', 'railways-so-2950-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03');

-- New threads found in the 2026-09-05 depth pass:
INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('railways-rob-scr-lc54', 'Road Over Bridge in lieu of Level Crossing No. 54, South Central Railway', NULL),
  ('railways-nwr-construction-land-acq', 'North Western Railway (Construction Organisation) land acquisition, s.20A/20E', NULL),
  ('railways-nfr-construction-land-acq', 'North East Frontier Railway (Construction Organisation) land acquisition corrigenda', NULL),
  ('railways-open-lines-general-rules-1976', 'Indian Railways (Open Lines) General Rules, 1976', 1976),
  ('railways-passenger-cancellation-refund-rules-2015', 'Railway Passengers (Cancellation of Ticket and Refund of Fare) Rules, 2015', 2015),
  ('railways-public-carriage-rules-2000', 'Railways (Opening for Public Carriage of Passengers) Rules, 2000', 2000),
  ('railways-rpf-rules-1987', 'Railway Protection Force Rules, 1987', 1987),
  ('railways-red-tariff-rules-2000', 'Railways Red Tariff Rules, 2000', 2000),
  ('railways-kolkata-metro-general-rules-2019', 'Kolkata Metro Railway General Rules, 2019', 2019),
  ('railways-container-train-operators-rules-2006', 'Indian Railways (permission for operators to move container trains) Rules, 2006', 2006);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('railways-scr-rob-lc54-corrigenda', 'South Central Railway ROB in lieu of Level Crossing No. 54, corrigendum chain', 'active'),
  ('railways-nwr-construction-organisation', 'North Western Railway (Construction Organisation) land acquisition amendments and a cancellation', 'active'),
  ('railways-nfr-construction-organisation', 'North East Frontier Railway (Construction Organisation) land acquisition corrigenda', 'active'),
  ('railways-open-lines-rules', 'Indian Railways (Open Lines) General Rules amendment/corrigendum', 'active'),
  ('railways-passenger-cancellation-rules', 'Railway Passengers Cancellation/Refund Rules amendment', 'active'),
  ('railways-public-carriage-rules', 'Railways Public Carriage Rules amendment', 'active'),
  ('railways-rpf-rules', 'Railway Protection Force Rules amendment/corrigendum', 'active'),
  ('railways-red-tariff-rules', 'Railways Red Tariff Rules amendments', 'active'),
  ('railways-kolkata-metro-rules', 'Kolkata Metro Railway General Rules amendment', 'active'),
  ('railways-container-train-rules', 'Container train operators Rules amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('railways-so-384-2024', 'Railways', 'S.O. 384(E)', 2024, 'so-only', '2024-12-12', 'S.O. 384(E)', 'railways', 'railways-rob-scr-lc54', 'railways-scr-rob-lc54-corrigenda'),
  ('railways-so-2229-2025', 'Railways', 'S.O. 2229(E)', 2025, 'so-only', '2025-05-14', 'S.O. 2229(E)', 'railways', 'railways-rob-scr-lc54', 'railways-scr-rob-lc54-corrigenda'),
  ('railways-so-4851-2026', 'Railways', 'S.O. 4851(E)', 2026, 'so-only', '2026-08-28', 'S.O. 4851(E)', 'railways', 'railways-rob-scr-lc54', 'railways-scr-rob-lc54-corrigenda'),
  ('railways-so-4483-2025', 'Railways', 'S.O. 4483(E)', 2025, 'so-only', '2025-10-01', 'S.O. 4483(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-2509-2025', 'Railways', 'S.O. 2509(E)', 2025, 'so-only', '2025-05-23', 'S.O. 2509(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-5275-2025', 'Railways', 'S.O. 5275(E)', 2025, 'so-only', '2025-11-18', 'S.O. 5275(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-4614-2026', 'Railways', 'S.O. 4614(E)', 2026, 'so-only', '2026-08-20', 'S.O. 4614(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-5274-2025', 'Railways', 'S.O. 5274(E)', 2025, 'so-only', '2025-11-18', 'S.O. 5274(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-4484-2025', 'Railways', 'S.O. 4484(E)', 2025, 'so-only', '2025-10-01', 'S.O. 4484(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-91-2025', 'Railways', 'S.O. 91(E)', 2025, 'so-only', '2025-01-03', 'S.O. 91(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-5639-2024', 'Railways', 'S.O. 5639(E)', 2024, 'so-only', '2024-12-30', 'S.O. 5639(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-4864-2024', 'Railways', 'S.O. 4864(E)', 2024, 'so-only', '2024-11-08', 'S.O. 4864(E)', 'railways', 'railways-nwr-construction-land-acq', 'railways-nwr-construction-organisation'),
  ('railways-so-3686-2026', 'Railways', 'S.O. 3686(E)', 2026, 'so-only', '2026-07-07', 'S.O. 3686(E)', 'railways', 'railways-nfr-construction-land-acq', 'railways-nfr-construction-organisation'),
  ('railways-so-3656-2026', 'Railways', 'S.O. 3656(E)', 2026, 'so-only', '2026-07-06', 'S.O. 3656(E)', 'railways', 'railways-nfr-construction-land-acq', 'railways-nfr-construction-organisation'),
  ('railways-so-4037-2025', 'Railways', 'S.O. 4037(E)', 2025, 'so-only', '2025-09-01', 'S.O. 4037(E)', 'railways', 'railways-nfr-construction-land-acq', 'railways-nfr-construction-organisation'),
  ('railways-so-3803-2025', 'Railways', 'S.O. 3803(E)', 2025, 'so-only', '2025-08-12', 'S.O. 3803(E)', 'railways', 'railways-nfr-construction-land-acq', 'railways-nfr-construction-organisation'),
  ('railways-gsr-1-2025', 'Railways', 'G.S.R. 01(E)', 2025, 'so-only', '2024-12-31', 'G.S.R. 01(E)', 'railways', 'railways-open-lines-general-rules-1976', 'railways-open-lines-rules'),
  ('railways-gsr-778-2024', 'Railways', 'G.S.R. 778(E)', 2024, 'so-only', '2024-12-23', 'G.S.R. 778(E)', 'railways', 'railways-open-lines-general-rules-1976', 'railways-open-lines-rules'),
  ('railways-gsr-21-2025', 'Railways', 'G.S.R. 21(E)', 2025, 'so-only', '2025-01-06', 'G.S.R. 21(E)', 'railways', 'railways-open-lines-general-rules-1976', 'railways-open-lines-rules'),
  ('railways-gsr-41-2026', 'Railways', 'G.S.R. 41(E)', 2026, 'so-only', '2026-01-16', 'G.S.R. 41(E)', 'railways', 'railways-passenger-cancellation-refund-rules-2015', 'railways-passenger-cancellation-rules'),
  ('railways-gsr-836-2015', 'Railways', 'G.S.R. 836(E)', 2015, 'so-only', '2015-11-04', 'G.S.R. 836(E)', 'railways', 'railways-passenger-cancellation-refund-rules-2015', 'railways-passenger-cancellation-rules'),
  ('railways-gsr-485-2026', 'Railways', 'G.S.R. 485(E)', 2026, 'so-only', '2026-06-16', 'G.S.R. 485(E)', 'railways', 'railways-public-carriage-rules-2000', 'railways-public-carriage-rules'),
  ('railways-gsr-625-2000', 'Railways', 'G.S.R. 625(E)', 2000, 'so-only', '2000-07-21', 'G.S.R. 625(E)', 'railways', 'railways-public-carriage-rules-2000', 'railways-public-carriage-rules'),
  ('railways-gsr-451-2025', 'Railways', 'G.S.R. 451(E)', 2025, 'so-only', '2025-07-07', 'G.S.R. 451(E)', 'railways', 'railways-public-carriage-rules-2000', 'railways-public-carriage-rules'),
  ('railways-gsr-766-2025', 'Railways', 'G.S.R. 766(E)', 2025, 'so-only', '2025-10-17', 'G.S.R. 766(E)', 'railways', 'railways-rpf-rules-1987', 'railways-rpf-rules'),
  ('railways-gsr-951-1987', 'Railways', 'G.S.R. 951(E)', 1987, 'so-only', '1987-12-03', 'G.S.R. 951(E)', 'railways', 'railways-rpf-rules-1987', 'railways-rpf-rules'),
  ('railways-gsr-750-2025', 'Railways', 'G.S.R. 750(E)', 2025, 'so-only', '2025-10-09', 'G.S.R. 750(E)', 'railways', 'railways-rpf-rules-1987', 'railways-rpf-rules'),
  ('railways-gsr-719-2025', 'Railways', 'G.S.R. 719(E)', 2025, 'so-only', '2025-09-26', 'G.S.R. 719(E)', 'railways', 'railways-red-tariff-rules-2000', 'railways-red-tariff-rules'),
  ('railways-gsr-266-2000', 'Railways', 'G.S.R. 266', 2000, 'bare', '2000-07-15', 'G.S.R. 266', 'railways', 'railways-red-tariff-rules-2000', 'railways-red-tariff-rules'),
  ('railways-gsr-769-2025', 'Railways', 'G.S.R. 769(E)', 2025, 'so-only', '2025-10-21', 'G.S.R. 769(E)', 'railways', 'railways-red-tariff-rules-2000', 'railways-red-tariff-rules'),
  ('railways-gsr-770-2025', 'Railways', 'G.S.R. 770(E)', 2025, 'so-only', '2025-10-21', 'G.S.R. 770(E)', 'railways', 'railways-red-tariff-rules-2000', 'railways-red-tariff-rules'),
  ('railways-gsr-80-2025', 'Railways', 'G.S.R. 80(E)', 2025, 'so-only', '2025-01-28', 'G.S.R. 80(E)', 'railways', 'railways-kolkata-metro-general-rules-2019', 'railways-kolkata-metro-rules'),
  ('railways-gsr-465-2019', 'Railways', 'G.S.R. 465(E)', 2019, 'so-only', '2019-07-01', 'G.S.R. 465(E)', 'railways', 'railways-kolkata-metro-general-rules-2019', 'railways-kolkata-metro-rules'),
  ('railways-gsr-727-2026', 'Railways', 'G.S.R. 727(E)', 2026, 'so-only', '2026-08-12', 'G.S.R. 727(E)', 'railways', 'railways-container-train-operators-rules-2006', 'railways-container-train-rules'),
  ('railways-gsr-593-2006', 'Railways', 'G.S.R. 593(E)', 2006, 'so-only', '2006-09-26', 'G.S.R. 593(E)', 'railways', 'railways-container-train-operators-rules-2006', 'railways-container-train-rules');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('railways-so-2229-2025', 'railways-so-384-2024', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-4851-2026', 'railways-so-2229-2025', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-4483-2025', 'railways-so-2509-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-5275-2025', 'railways-so-4483-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-4614-2026', 'railways-so-4483-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-5274-2025', 'railways-so-4484-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-91-2025', 'railways-so-5639-2024', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-5639-2024', 'railways-so-4864-2024', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-3686-2026', 'railways-so-3656-2026', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('railways-so-4037-2025', 'railways-so-3803-2025', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-1-2025', 'railways-gsr-778-2024', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-21-2025', 'railways-gsr-778-2024', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-41-2026', 'railways-gsr-836-2015', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-485-2026', 'railways-gsr-625-2000', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-485-2026', 'railways-gsr-451-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-766-2025', 'railways-gsr-951-1987', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-750-2025', 'railways-gsr-951-1987', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-719-2025', 'railways-gsr-266-2000', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-769-2025', 'railways-gsr-266-2000', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-769-2025', 'railways-gsr-719-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-770-2025', 'railways-gsr-266-2000', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-770-2025', 'railways-gsr-719-2025', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-80-2025', 'railways-gsr-465-2019', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('railways-gsr-727-2026', 'railways-gsr-593-2006', 'amends', 'research-agent-quoted', '2026-09-05');

