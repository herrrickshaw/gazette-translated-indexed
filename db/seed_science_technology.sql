-- Ministry of Science and Technology (Departments of Science and
-- Technology, Biotechnology, and Scientific and Industrial Research share
-- one tracker listing). Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (2 pairs).
-- The ministry's entire tracker footprint is 58 notifications; every one
-- was read, six official egazette PDFs verified.
--
-- The previously deferred SERB lead is now resolved: the Anusandhan
-- National Research Foundation Act, 2023 subsumed the Science and
-- Engineering Research Board, and S.O. 2081(E) [2026-04-24] rescinds
-- SERB's two 2014 staff notifications by full file number and date
-- (bare form, modelable). Two 2025 ANRF draft Recruitment Rules each
-- supersede a 2014 SERB regulation "vide No. 003/2014/F. No. SR/S9/Z-08/
-- 2011" — BOTH drafts cite 003/2014 although the rescission lists 002 and
-- 003 as distinct notifications; confirmed in both official PDFs (English
-- and Hindi). One draft almost certainly meant 002/2014, but the text
-- does not say so: modeled exactly as written.
--
-- Draft->final identification: four ANRF finals (G.S.R. 310(E), 311(E),
-- 126(E), 127(E)) cite their draft by exact title AND exact gazette date
-- and Part/Section, but give no number; the drafts themselves are in the
-- tracker and were opened. Modeled `cites` on the same basis as MoSPI's
-- File-No.+date cross-match (a unique identification in the citing text),
-- and flagged here; a numbering-strict matcher will miss these four.
-- G.S.R. 353(E) (ANRF Rules, 2024) cites its four drafts by number in
-- one sentence — a 4-in-1 consolidation. G.S.R. 152(E)'s number and
-- preamble come from the official PDF (the tracker's Full Text omits the
-- preamble and its extraction mis-shows "G.S.R. 127(E)", which is the
-- DPIIT reference inside the body).
--
-- CROSS-MINISTRY CITE modeled: G.S.R. 152(E) cites the DPIIT startup-
-- definition notification G.S.R. 127(E), 2019-02-19 (number + date in
-- the citing text) — the target node is filed under the existing
-- 'commerce-and-industry' ministry_id, as Ayush's cite of a Health
-- notification was. REAL CITATION COLLISION: that DPIIT G.S.R. 127(E)
-- [2019] vs this ministry's own G.S.R. 127(E) [2026-02-12, ANRF COO/CFO
-- Rules] — distinct ministry-prefixed gazette_ids.
--
-- Real leads NOT modeled: seven Recruitment/Service Rules supersessions
-- citing their 1984-2019 predecessors by title only (Survey of India
-- Group A 1989, DST Group A 2013, DBT Group A 2018, SoI Stenographer 1984,
-- Senior PA 2001, SoI Translator 2019, SoI Officer Surveyor 2000); the
-- ANRF interim-CEO series (four notifications, none citing its
-- predecessor); several DoPT/DBT Office Memoranda (not gazette
-- notifications).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('science-and-technology', 'Ministry of Science and Technology', 'Department of Science and Technology; Department of Biotechnology; Department of Scientific and Industrial Research'),
  ('commerce-and-industry', 'Ministry of Commerce and Industry', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('soi-stenographer-grade2-rules-2025', 'Survey of India, Stenographer Grade II, Group ''C'' Post Recruitment Rules, 2025', 2025),
  ('staff-car-driver-recruitment-rules-2022', 'Staff Car Driver Recruitment Rules, 2022', 2022),
  ('serb-2014-staff-regulations', 'Science and Engineering Research Board staff Regulations, 2014 (rescinded 2026)', 2014),
  ('anrf-group-a-scientific-recruitment-rules', 'ANRF Group A Posts (Non-ministerial, Scientific and Technical) Recruitment Rules', 2026),
  ('anrf-group-ab-administrative-recruitment-rules', 'ANRF Group A and Group B Administrative Posts Recruitment Rules', 2026),
  ('anrf-rules-2024', 'Anusandhan National Research Foundation Rules, 2024', 2024),
  ('anrf-rdi-fund-financial-rules-2026', 'ANRF (Utilisation of Research Development and Innovation Fund) Financial Rules, 2026', 2026),
  ('dpiit-startup-definition-2019', 'DPIIT startup-definition notification, 2019', 2019),
  ('technology-development-board-act-1995-members', 'Technology Development Board Act, 1995 s.3 — Board members', 1995),
  ('anrf-accounts-officer-service-rules', 'ANRF Accounts Officer Recruitment and Service Rules', 2026),
  ('anrf-coo-cfo-service-rules', 'ANRF Chief Operating Officer and Chief Financial Officer Rules', 2026);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('soi-stenographer-rules-amendment', 'Survey of India Stenographer Grade II Rules amendment', 'active'),
  ('staff-car-driver-rules-amendment', 'Staff Car Driver Recruitment Rules amendment', 'active'),
  ('serb-to-anrf-recruitment', 'SERB 2014 staff regulations rescinded/superseded by ANRF recruitment rules (draft->final)', 'active'),
  ('anrf-rules-2024-draft-final', 'ANRF Rules, 2024 consolidating four drafts', 'active'),
  ('anrf-rdi-fund-rules-draft-final', 'ANRF RDI Fund Financial Rules draft->final, with a cross-ministry DPIIT cite', 'active'),
  ('tdb-members-supersession', 'Technology Development Board members supersession', 'active'),
  ('anrf-accounts-officer-draft-final', 'ANRF Accounts Officer Rules draft->final', 'active'),
  ('anrf-coo-cfo-draft-final', 'ANRF COO/CFO Rules draft->final', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('dst-gsr-383-2025', 'DST', 'G.S.R. 383(E)', 2025, 'so-only', '2025-06-13', 'G.S.R. 383(E)', 'science-and-technology', 'soi-stenographer-grade2-rules-2025', 'soi-stenographer-rules-amendment'),
  ('dst-gsr-635-2026', 'DST', 'G.S.R. 635(E)', 2026, 'so-only', '2026-07-13', 'G.S.R. 635(E)', 'science-and-technology', 'soi-stenographer-grade2-rules-2025', 'soi-stenographer-rules-amendment'),
  ('dst-gsr-57-2022',  'DST', 'G.S.R. 57',     2022, 'bare',    '2022-03-31', 'G.S.R. 57',     'science-and-technology', 'staff-car-driver-recruitment-rules-2022', 'staff-car-driver-rules-amendment'),
  ('dst-gsr-660-2026', 'DST', 'G.S.R. 660(E)', 2026, 'so-only', '2026-07-23', 'G.S.R. 660(E)', 'science-and-technology', 'staff-car-driver-recruitment-rules-2022', 'staff-car-driver-rules-amendment'),
  -- SERB -> ANRF recruitment
  ('dst-serb-002-2014', 'DST', 'No. 002/2014/F. No. SR/S9/Z-08/2011', 2014, 'bare', '2014-04-24', 'No. 002/2014/F. No. SR/S9/Z-08/2011', 'science-and-technology', 'serb-2014-staff-regulations', 'serb-to-anrf-recruitment'),
  ('dst-serb-003-2014', 'DST', 'No. 003/2014/F. No. SR/S9/Z-08/2011', 2014, 'bare', '2014-04-24', 'No. 003/2014/F. No. SR/S9/Z-08/2011', 'science-and-technology', 'serb-2014-staff-regulations', 'serb-to-anrf-recruitment'),
  ('dst-gsr-530-2025', 'DST', 'G.S.R. 530(E)', 2025, 'so-only', '2025-08-05', 'G.S.R. 530(E)', 'science-and-technology', 'anrf-group-a-scientific-recruitment-rules', 'serb-to-anrf-recruitment'),
  ('dst-gsr-531-2025', 'DST', 'G.S.R. 531(E)', 2025, 'so-only', '2025-08-05', 'G.S.R. 531(E)', 'science-and-technology', 'anrf-group-ab-administrative-recruitment-rules', 'serb-to-anrf-recruitment'),
  ('dst-gsr-310-2026', 'DST', 'G.S.R. 310(E)', 2026, 'so-only', '2026-04-24', 'G.S.R. 310(E)', 'science-and-technology', 'anrf-group-a-scientific-recruitment-rules', 'serb-to-anrf-recruitment'),
  ('dst-gsr-311-2026', 'DST', 'G.S.R. 311(E)', 2026, 'so-only', '2026-04-24', 'G.S.R. 311(E)', 'science-and-technology', 'anrf-group-ab-administrative-recruitment-rules', 'serb-to-anrf-recruitment'),
  ('dst-so-2081-2026', 'DST', 'S.O. 2081(E)', 2026, 'so-only', '2026-04-24', 'S.O. 2081(E)', 'science-and-technology', 'serb-2014-staff-regulations', 'serb-to-anrf-recruitment'),
  -- ANRF Rules, 2024
  ('dst-gsr-85-2024',  'DST', 'G.S.R. 85(E)',  2024, 'so-only', '2024-02-02', 'G.S.R. 85(E)',  'science-and-technology', 'anrf-rules-2024', 'anrf-rules-2024-draft-final'),
  ('dst-gsr-86-2024',  'DST', 'G.S.R. 86(E)',  2024, 'so-only', '2024-02-02', 'G.S.R. 86(E)',  'science-and-technology', 'anrf-rules-2024', 'anrf-rules-2024-draft-final'),
  ('dst-gsr-87-2024',  'DST', 'G.S.R. 87(E)',  2024, 'so-only', '2024-02-02', 'G.S.R. 87(E)',  'science-and-technology', 'anrf-rules-2024', 'anrf-rules-2024-draft-final'),
  ('dst-gsr-88-2024',  'DST', 'G.S.R. 88(E)',  2024, 'so-only', '2024-02-02', 'G.S.R. 88(E)',  'science-and-technology', 'anrf-rules-2024', 'anrf-rules-2024-draft-final'),
  ('dst-gsr-353-2024', 'DST', 'G.S.R. 353(E)', 2024, 'so-only', '2024-06-28', 'G.S.R. 353(E)', 'science-and-technology', 'anrf-rules-2024', 'anrf-rules-2024-draft-final'),
  -- ANRF RDI Fund Financial Rules + DPIIT cross-ministry target
  ('dst-gsr-809-2025', 'DST', 'G.S.R. 809(E)', 2025, 'so-only', '2025-11-01', 'G.S.R. 809(E)', 'science-and-technology', 'anrf-rdi-fund-financial-rules-2026', 'anrf-rdi-fund-rules-draft-final'),
  ('dst-gsr-152-2026', 'DST', 'G.S.R. 152(E)', 2026, 'so-only', '2026-03-02', 'G.S.R. 152(E)', 'science-and-technology', 'anrf-rdi-fund-financial-rules-2026', 'anrf-rdi-fund-rules-draft-final'),
  ('dpiit-gsr-127-2019', 'DPIIT', 'G.S.R. 127(E)', 2019, 'so-only', '2019-02-19', 'G.S.R. 127(E)', 'commerce-and-industry', 'dpiit-startup-definition-2019', 'anrf-rdi-fund-rules-draft-final'),
  -- Technology Development Board members
  ('dst-so-114-2025', 'DST', 'S.O. 114(E)', 2025, 'so-only', '2025-01-07', 'S.O. 114(E)', 'science-and-technology', 'technology-development-board-act-1995-members', 'tdb-members-supersession'),
  ('dst-so-694-2025', 'DST', 'S.O. 694(E)', 2025, 'so-only', '2025-02-11', 'S.O. 694(E)', 'science-and-technology', 'technology-development-board-act-1995-members', 'tdb-members-supersession'),
  -- ANRF Accounts Officer and COO/CFO Rules (draft -> final, title+date cites)
  ('dst-gsr-626-2025', 'DST', 'G.S.R. 626(E)', 2025, 'so-only', '2025-09-12', 'G.S.R. 626(E)', 'science-and-technology', 'anrf-accounts-officer-service-rules', 'anrf-accounts-officer-draft-final'),
  ('dst-gsr-126-2026', 'DST', 'G.S.R. 126(E)', 2026, 'so-only', '2026-02-12', 'G.S.R. 126(E)', 'science-and-technology', 'anrf-accounts-officer-service-rules', 'anrf-accounts-officer-draft-final'),
  ('dst-gsr-627-2025', 'DST', 'G.S.R. 627(E)', 2025, 'so-only', '2025-09-12', 'G.S.R. 627(E)', 'science-and-technology', 'anrf-coo-cfo-service-rules', 'anrf-coo-cfo-draft-final'),
  ('dst-gsr-127-2026', 'DST', 'G.S.R. 127(E)', 2026, 'so-only', '2026-02-12', 'G.S.R. 127(E)', 'science-and-technology', 'anrf-coo-cfo-service-rules', 'anrf-coo-cfo-draft-final');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('dst-gsr-635-2026', 'dst-gsr-383-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dst-gsr-660-2026', 'dst-gsr-57-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- SERB -> ANRF
  ('dst-so-2081-2026', 'dst-serb-002-2014', 'rescinds', 'primary-source-egazette', '2026-09-04'),
  ('dst-so-2081-2026', 'dst-serb-003-2014', 'rescinds', 'primary-source-egazette', '2026-09-04'),
  ('dst-gsr-530-2025', 'dst-serb-003-2014', 'cites', 'primary-source-egazette', '2026-09-04'),
  ('dst-gsr-531-2025', 'dst-serb-003-2014', 'cites', 'primary-source-egazette', '2026-09-04'),
  ('dst-gsr-310-2026', 'dst-gsr-530-2025', 'cites', 'research-agent-quoted-title-date', '2026-09-04'),
  ('dst-gsr-311-2026', 'dst-gsr-531-2025', 'cites', 'research-agent-quoted-title-date', '2026-09-04'),
  -- ANRF Rules, 2024 (4-in-1 draft consolidation)
  ('dst-gsr-353-2024', 'dst-gsr-85-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('dst-gsr-353-2024', 'dst-gsr-86-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('dst-gsr-353-2024', 'dst-gsr-87-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('dst-gsr-353-2024', 'dst-gsr-88-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- RDI Fund Financial Rules
  ('dst-gsr-152-2026', 'dst-gsr-809-2025', 'cites', 'primary-source-egazette', '2026-09-04'),
  ('dst-gsr-152-2026', 'dpiit-gsr-127-2019', 'cites', 'primary-source-egazette', '2026-09-04'),
  -- Technology Development Board
  ('dst-so-694-2025', 'dst-so-114-2025', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- Accounts Officer / COO-CFO Rules
  ('dst-gsr-126-2026', 'dst-gsr-626-2025', 'cites', 'research-agent-quoted-title-date', '2026-09-04'),
  ('dst-gsr-127-2026', 'dst-gsr-627-2025', 'cites', 'research-agent-quoted-title-date', '2026-09-04');
