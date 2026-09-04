-- Department of Atomic Energy. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded 3-pair pass.
--
-- Real restructuring: the first pass modeled S.O. 3943(E) as an
-- independent principal order (amended by S.O. 2152(E)) and S.O. 1317(E)
-- as a SEPARATE principal (amended by S.O. 4585(E)). A deeper pass found
-- that S.O. 3943(E) is ITSELF an amendment of S.O. 1317(E) — so these are
-- not two separate chains but one real "hub": S.O. 1317(E) [2013] has been
-- directly amended by at least FOUR separate orders (S.O. 3943(E) [2022],
-- S.O. 3049(E) [Jul 2024], S.O. 3638(E) [Aug 2024], S.O. 4585(E) [Oct
-- 2024]), and S.O. 3943(E) was itself further amended once more by S.O.
-- 2152(E) [2025]. Modeled as multiple edges into the same target rather
-- than a linear chain, since that's what the real text shows.
--
-- (The S.O. 3943(E)-amends-S.O. 1317(E) edge is sourced from a citing
-- document's own Note quoting it, not from independently opening S.O.
-- 3943(E)'s own page — the same evidentiary standard already used
-- elsewhere in this project, e.g. Department of Posts' S.O. 4053(E).)
--
-- Three further real pairs found: same-year amendments to three separate
-- 2024 Recruitment Rules (Stenographer Cadre, Senior PS/PS/Stenographer
-- Grade I, Lower Division Clerk) — all pure note-chain shapes citing the
-- principal rules only in a trailing Note, not in the operative clause.
--
-- Three further real leads are supersessions with NO usable citation on
-- the superseded side (predecessor Recruitment Rules named only by title
-- and year — ATI cadre, Driver cadre, Security cadre) — deliberately not
-- modeled, the same class of gap as every other unnumbered-citation lead
-- in this project.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('atomic-energy', 'Department of Atomic Energy', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('dae-cca-authority-order-2013', 'DAE Classification, Control and Appeal authority order, 2013 (S.O. 1317(E))', 2013),
  ('dae-driver-cadre-recruitment-rules-2024', 'DAE (Driver Cadre) Recruitment Rules, 2024', 2024),
  ('dae-stenographer-cadre-rr-2024', 'DAE Stenographer Cadre (Secretariat), Group A and B Posts Recruitment Rules, 2024', 2024),
  ('dae-senior-ps-ps-rr-2024', 'DAE Senior Private Secretary, Private Secretary (Non-Secretariat) and Stenographer Grade I, Group B Posts Recruitment Rules, 2024', 2024),
  ('dae-ldc-rr-2024', 'DAE Lower Division Clerk Recruitment Rules, 2024', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('dae-cca-authority-order-chain', 'DAE CCA authority order (S.O. 1317(E)) and its four independent amendments', 'active'),
  ('dae-driver-cadre-rules-amendment', 'DAE Driver Cadre Recruitment Rules amendment', 'active'),
  ('dae-stenographer-cadre-rules-amendment', 'DAE Stenographer Cadre Recruitment Rules amendment', 'active'),
  ('dae-senior-ps-ps-rules-amendment', 'DAE Senior PS/PS/Stenographer Grade I Recruitment Rules amendment', 'active'),
  ('dae-ldc-rules-amendment', 'DAE Lower Division Clerk Recruitment Rules amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- CCA authority order hub: S.O. 1317(E) amended by four separate orders,
  -- one of which (S.O. 3943(E)) was itself further amended
  ('dae-so-1317-2013', 'DAE', 'S.O. 1317(E)', 2013, 'so-only', '2013-05-16', 'S.O. 1317(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-order-chain'),
  ('dae-so-3943-2022', 'DAE', 'S.O. 3943(E)', 2022, 'so-only', '2022-08-17', 'S.O. 3943(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-order-chain'),
  ('dae-so-3049-2024', 'DAE', 'S.O. 3049(E)', 2024, 'so-only', '2024-07-29', 'S.O. 3049(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-order-chain'),
  ('dae-so-3638-2024', 'DAE', 'S.O. 3638(E)', 2024, 'so-only', '2024-08-26', 'S.O. 3638(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-order-chain'),
  ('dae-so-4585-2024', 'DAE', 'S.O. 4585(E)', 2024, 'so-only', '2024-10-17', 'S.O. 4585(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-order-chain'),
  ('dae-so-2152-2025', 'DAE', 'S.O. 2152(E)', 2025, 'so-only', '2025-05-07', 'S.O. 2152(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-order-chain'),
  -- Driver Cadre RR (unchanged)
  ('dae-gsr-509-2024', 'DAE', 'G.S.R. 509(E)', 2024, 'so-only', '2024-08-20', 'G.S.R. 509(E)', 'atomic-energy', 'dae-driver-cadre-recruitment-rules-2024', 'dae-driver-cadre-rules-amendment'),
  ('dae-gsr-732-2024', 'DAE', 'G.S.R. 732(E)', 2024, 'so-only', '2024-11-27', 'G.S.R. 732(E)', 'atomic-energy', 'dae-driver-cadre-recruitment-rules-2024', 'dae-driver-cadre-rules-amendment'),
  -- Stenographer Cadre RR
  ('dae-gsr-591-2024', 'DAE', 'G.S.R. 591(E)', 2024, 'so-only', '2024-09-25', 'G.S.R. 591(E)', 'atomic-energy', 'dae-stenographer-cadre-rr-2024', 'dae-stenographer-cadre-rules-amendment'),
  ('dae-gsr-734-2024', 'DAE', 'G.S.R. 734(E)', 2024, 'so-only', '2024-11-27', 'G.S.R. 734(E)', 'atomic-energy', 'dae-stenographer-cadre-rr-2024', 'dae-stenographer-cadre-rules-amendment'),
  -- Senior PS/PS/Stenographer Grade I RR
  ('dae-gsr-590-2024', 'DAE', 'G.S.R. 590(E)', 2024, 'so-only', '2024-09-25', 'G.S.R. 590(E)', 'atomic-energy', 'dae-senior-ps-ps-rr-2024', 'dae-senior-ps-ps-rules-amendment'),
  ('dae-gsr-733-2024', 'DAE', 'G.S.R. 733(E)', 2024, 'so-only', '2024-11-27', 'G.S.R. 733(E)', 'atomic-energy', 'dae-senior-ps-ps-rr-2024', 'dae-senior-ps-ps-rules-amendment'),
  -- Lower Division Clerk RR
  ('dae-gsr-238-2024', 'DAE', 'G.S.R. 238(E)', 2024, 'so-only', '2024-04-02', 'G.S.R. 238(E)', 'atomic-energy', 'dae-ldc-rr-2024', 'dae-ldc-rules-amendment'),
  ('dae-gsr-726-2024', 'DAE', 'G.S.R. 726(E)', 2024, 'so-only', '2024-11-21', 'G.S.R. 726(E)', 'atomic-energy', 'dae-ldc-rr-2024', 'dae-ldc-rules-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  -- Hub: four independent amendments to S.O. 1317(E), plus one nested amendment to S.O. 3943(E)
  ('dae-so-3943-2022', 'dae-so-1317-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-so-3049-2024', 'dae-so-1317-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-so-3638-2024', 'dae-so-1317-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-so-4585-2024', 'dae-so-1317-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-so-2152-2025', 'dae-so-3943-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-gsr-732-2024', 'dae-gsr-509-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-gsr-734-2024', 'dae-gsr-591-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-gsr-733-2024', 'dae-gsr-590-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-gsr-726-2024', 'dae-gsr-238-2024', 'amends', 'research-agent-quoted', '2026-09-04');
