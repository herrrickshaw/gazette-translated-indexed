-- Ministry of Ayush. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass.
--
-- REAL CORRECTION: the first pass modeled a node as "S.O. 221(E)" because
-- the ONLY primary text seen at the time (S.O. 563(E)'s own Note) cited
-- it that way. A deeper pass independently opened that notification's own
-- gazette page and found its true self-identification is "G.S.R. 221(E)"
-- — S.O. 563(E)'s Note itself contains a real keying error, misciting a
-- G.S.R. as an S.O. This is corrected here to the notification's own true
-- identity (gazette_id renamed ayush-so-221-2024 -> ayush-gsr-221-2024),
-- the same discipline already used once before in this project (the
-- MoEFCC gazette-ID/content-mismatch correction) — model the real
-- underlying document, not a citing document's error, while still noting
-- the error existed.
--
-- Both the S.O. 2280(E)/S.O. 2281(E) NCISM chains (already partially
-- known) and two SIBLING NCH chains (S.O. 2692(E), S.O. 2694(E)) turned
-- out to share the identical pattern: principal [2021] -> an intermediate
-- amendment dated 13 June 2022 (cited only in later Notes, never
-- independently opened — same evidentiary standard as every other
-- Note-sourced citation in this project) -> a 2024 amendment -> a
-- 2026-02-04 current amendment. Six further real chains/pairs found
-- across Advisory Council (ISM and Homoeopathy) and Submission-of-List
-- Rules subject areas, plus one real cross-ministry supersession (this
-- ministry's S.O. 3559(E) supersedes an erstwhile Ministry of Health and
-- Family Welfare notification, modeled under that ministry's own
-- ministry_id).
--
-- One further real lead (a National Dhanwantari Ayurveda Award resolution
-- chain) cites every link only by File Number, no G.S.R./S.O./S.R.O.
-- number at all — deliberately not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('ayush', 'Ministry of Ayush', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('drugs-cosmetics-act-1940', 'Drugs and Cosmetics Act, 1940 — Fifth Amendment Rules, 2024', 1940),
  ('ncism-act-2020', 'National Commission for Indian System of Medicine Act, 2020 (President appointment, S.O. 2280(E)/2281(E) series)', 2020),
  ('nch-act-2020', 'National Commission for Homoeopathy Act, 2020 (President/Chairperson appointments, S.O. 2692(E)/2694(E) series)', 2020),
  ('advisory-council-ism', 'National Commission for Indian System of Medicine Act, 2020 — Advisory Council', 2020),
  ('advisory-council-homoeopathy', 'National Commission for Homoeopathy Act, 2020 — Advisory Council', 2020),
  ('ncism-list-practitioners-rules-2021', 'NCISM (Submission of List of Medical Practitioners) Rules, 2021', 2021),
  ('nch-list-practitioners-rules-2021', 'NCH (Submission of List of Homoeopathy Practitioners) Rules, 2021', 2021),
  ('ayurvedic-siddha-unani-drugs-committee', 'Ayurvedic, Siddha and Unani Drugs Consultative Committee', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('ayush-drugs-fifth-amendment-corrigendum', 'Corrigendum to the Drugs (Fifth Amendment) Rules, 2024', 'active'),
  ('ayush-ep3-recruitment-corrigendum', 'Corrigendum to an EP-III recruitment rules notification', 'active'),
  ('ayush-ncism-president-appointments', 'NCISM President appointments and their amendments', 'active'),
  ('ayush-nch-president-appointments', 'NCH President appointments and their amendments', 'active'),
  ('ayush-nch-chairperson-appointments', 'NCH Chairperson/Ex-officio appointments and their amendments', 'active'),
  ('ayush-advisory-council-ism', 'Advisory Council for Indian System of Medicine and its amendments', 'active'),
  ('ayush-advisory-council-homoeopathy', 'Advisory Council for Homoeopathy and its amendment', 'active'),
  ('ayush-ncism-list-practitioners', 'NCISM Submission of List of Medical Practitioners Rules and its amendment', 'active'),
  ('ayush-nch-list-practitioners', 'NCH Submission of List of Homoeopathy Practitioners Rules and its amendment', 'active'),
  ('ayush-drugs-consultative-committee', 'Ayurvedic, Siddha and Unani Drugs Consultative Committee supersession', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: G.S.R. 660(E) corrects G.S.R. 669(E)
  ('ayush-gsr-669-2024', 'Ayush', 'G.S.R. 669(E)', 2024, 'so-only', '2024-10-28', 'G.S.R. 669(E)', 'ayush', 'drugs-cosmetics-act-1940', 'ayush-drugs-fifth-amendment-corrigendum'),
  ('ayush-gsr-660-2024', 'Ayush', 'G.S.R. 660(E)', 2024, 'so-only', '2024-11-18', 'G.S.R. 660(E)', 'ayush', 'drugs-cosmetics-act-1940', 'ayush-drugs-fifth-amendment-corrigendum'),
  -- Pair 2: G.S.R. 717(E) corrects G.S.R. 637(E)
  ('ayush-gsr-637-2024', 'Ayush', 'G.S.R. 637(E)', 2024, 'so-only', '2024-10-14', 'G.S.R. 637(E)', 'ayush', NULL, 'ayush-ep3-recruitment-corrigendum'),
  ('ayush-gsr-717-2024', 'Ayush', 'G.S.R. 717(E)', 2024, 'so-only', '2024-11-18', 'G.S.R. 717(E)', 'ayush', NULL, 'ayush-ep3-recruitment-corrigendum'),
  -- NCISM President chain (S.O. 2280(E) series) — 4 nodes
  ('ayush-so-2280-2021', 'Ayush', 'S.O. 2280(E)', 2021, 'so-only', '2021-06-11', 'S.O. 2280(E)', 'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  ('ayush-so-2713-2022', 'Ayush', 'S.O. 2713(E)', 2022, 'so-only', '2022-06-13', 'S.O. 2713(E)', 'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  ('ayush-gsr-222-2024', 'Ayush', 'G.S.R. 222(E)', 2024, 'so-only', '2024-03-19', 'G.S.R. 222(E)', 'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  ('ayush-so-562-2026',  'Ayush', 'S.O. 562(E)',  2026, 'so-only', '2026-02-04', 'S.O. 562(E)',  'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  -- NCISM chain (S.O. 2281(E) series) — 4 nodes, correction applied (G.S.R. 221(E), not S.O. 221(E))
  ('ayush-so-2281-2021', 'Ayush', 'S.O. 2281(E)', 2021, 'so-only', '2021-06-11', 'S.O. 2281(E)', 'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  ('ayush-so-2714-2022', 'Ayush', 'S.O. 2714(E)', 2022, 'so-only', '2022-06-13', 'S.O. 2714(E)', 'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  ('ayush-gsr-221-2024', 'Ayush', 'G.S.R. 221(E)', 2024, 'so-only', '2024-03-19', 'G.S.R. 221(E)', 'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  ('ayush-so-563-2026',  'Ayush', 'S.O. 563(E)',  2026, 'so-only', '2026-02-04', 'S.O. 563(E)',  'ayush', 'ncism-act-2020', 'ayush-ncism-president-appointments'),
  -- NCH President chain (S.O. 2692(E) series) — 4 nodes
  ('ayush-so-2692-2021', 'Ayush', 'S.O. 2692(E)', 2021, 'so-only', '2021-07-05', 'S.O. 2692(E)', 'ayush', 'nch-act-2020', 'ayush-nch-president-appointments'),
  ('ayush-so-2715-2022', 'Ayush', 'S.O. 2715(E)', 2022, 'so-only', '2022-06-13', 'S.O. 2715(E)', 'ayush', 'nch-act-2020', 'ayush-nch-president-appointments'),
  ('ayush-so-823-2024',  'Ayush', 'S.O. 823(E)',  2024, 'so-only', '2024-02-20', 'S.O. 823(E)',  'ayush', 'nch-act-2020', 'ayush-nch-president-appointments'),
  ('ayush-so-564-2026',  'Ayush', 'S.O. 564(E)',  2026, 'so-only', '2026-02-04', 'S.O. 564(E)',  'ayush', 'nch-act-2020', 'ayush-nch-president-appointments'),
  -- NCH Chairperson/Ex-officio chain (S.O. 2694(E) series) — 3 nodes
  ('ayush-so-2694-2021', 'Ayush', 'S.O. 2694(E)', 2021, 'so-only', '2021-07-05', 'S.O. 2694(E)', 'ayush', 'nch-act-2020', 'ayush-nch-chairperson-appointments'),
  ('ayush-so-2716-2022', 'Ayush', 'S.O. 2716(E)', 2022, 'so-only', '2022-06-13', 'S.O. 2716(E)', 'ayush', 'nch-act-2020', 'ayush-nch-chairperson-appointments'),
  ('ayush-so-565-2026',  'Ayush', 'S.O. 565(E)',  2026, 'so-only', '2026-02-04', 'S.O. 565(E)',  'ayush', 'nch-act-2020', 'ayush-nch-chairperson-appointments'),
  -- Advisory Council ISM chain
  ('ayush-gsr-666-2021', 'Ayush', 'G.S.R. 666(E)', 2021, 'so-only', '2021-09-22', 'G.S.R. 666(E)', 'ayush', 'advisory-council-ism', 'ayush-advisory-council-ism'),
  ('ayush-gsr-597-2023', 'Ayush', 'G.S.R. 597(E)', 2023, 'so-only', '2023-08-10', 'G.S.R. 597(E)', 'ayush', 'advisory-council-ism', 'ayush-advisory-council-ism'),
  ('ayush-gsr-324-2025', 'Ayush', 'G.S.R. 324(E)', 2025, 'so-only', '2025-05-19', 'G.S.R. 324(E)', 'ayush', 'advisory-council-ism', 'ayush-advisory-council-ism'),
  -- Advisory Council Homoeopathy
  ('ayush-gsr-667-2021', 'Ayush', 'G.S.R. 667(E)', 2021, 'so-only', '2021-09-22', 'G.S.R. 667(E)', 'ayush', 'advisory-council-homoeopathy', 'ayush-advisory-council-homoeopathy'),
  ('ayush-gsr-26-2024',  'Ayush', 'G.S.R. 26(E)',  2024, 'so-only', '2024-01-04', 'G.S.R. 26(E)',  'ayush', 'advisory-council-homoeopathy', 'ayush-advisory-council-homoeopathy'),
  -- NCISM Submission of List Rules
  ('ayush-gsr-357-2021', 'Ayush', 'G.S.R. 357(E)', 2021, 'so-only', '2021-06-01', 'G.S.R. 357(E)', 'ayush', 'ncism-list-practitioners-rules-2021', 'ayush-ncism-list-practitioners'),
  ('ayush-gsr-479-2023', 'Ayush', 'G.S.R. 479(E)', 2023, 'so-only', '2023-06-22', 'G.S.R. 479(E)', 'ayush', 'ncism-list-practitioners-rules-2021', 'ayush-ncism-list-practitioners'),
  -- NCH Submission of List Rules
  ('ayush-gsr-358-2021', 'Ayush', 'G.S.R. 358(E)', 2021, 'so-only', '2021-06-01', 'G.S.R. 358(E)', 'ayush', 'nch-list-practitioners-rules-2021', 'ayush-nch-list-practitioners'),
  ('ayush-gsr-561-2023', 'Ayush', 'G.S.R. 561(E)', 2023, 'so-only', '2023-07-27', 'G.S.R. 561(E)', 'ayush', 'nch-list-practitioners-rules-2021', 'ayush-nch-list-practitioners'),
  -- Drugs Consultative Committee: cross-ministry supersession target under Health
  ('health-so-3909-2013', 'Health', 'S.O. 3909(E)', 2013, 'so-only', '2013-12-30', 'S.O. 3909(E)', 'health-family-welfare', 'ayurvedic-siddha-unani-drugs-committee', 'ayush-drugs-consultative-committee'),
  ('ayush-so-3559-2023', 'Ayush', 'S.O. 3559(E)', 2023, 'so-only', '2023-08-08', 'S.O. 3559(E)', 'ayush', 'ayurvedic-siddha-unani-drugs-committee', 'ayush-drugs-consultative-committee');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('ayush-gsr-660-2024', 'ayush-gsr-669-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('ayush-gsr-717-2024', 'ayush-gsr-637-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- NCISM S.O. 2280(E) chain
  ('ayush-so-2713-2022', 'ayush-so-2280-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-gsr-222-2024', 'ayush-so-2713-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-so-562-2026',  'ayush-gsr-222-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- NCISM S.O. 2281(E) chain
  ('ayush-so-2714-2022', 'ayush-so-2281-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-gsr-221-2024', 'ayush-so-2714-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-so-563-2026',  'ayush-gsr-221-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- NCH S.O. 2692(E) chain
  ('ayush-so-2715-2022', 'ayush-so-2692-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-so-823-2024',  'ayush-so-2715-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-so-564-2026',  'ayush-so-823-2024',  'amends', 'research-agent-quoted', '2026-09-04'),
  -- NCH S.O. 2694(E) chain
  ('ayush-so-2716-2022', 'ayush-so-2694-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-so-565-2026',  'ayush-so-2716-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Advisory Council ISM
  ('ayush-gsr-597-2023', 'ayush-gsr-666-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-gsr-324-2025', 'ayush-gsr-597-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Advisory Council Homoeopathy
  ('ayush-gsr-26-2024', 'ayush-gsr-667-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Submission of List Rules
  ('ayush-gsr-479-2023', 'ayush-gsr-357-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-gsr-561-2023', 'ayush-gsr-358-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Drugs Consultative Committee (cross-ministry supersession)
  ('ayush-so-3559-2023', 'health-so-3909-2013', 'supersedes', 'research-agent-quoted', '2026-09-04');
