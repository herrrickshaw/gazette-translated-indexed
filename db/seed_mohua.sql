-- Ministry of Housing and Urban Affairs (MoHUA) pilot.
--
-- Modeled: S.O. 4041(E) corrects S.O. 3379(E), a Directorate of Estates
-- notification. verified_by 'research-agent-quoted' — and the WEAKEST
-- corroboration in this project so far: the research agent explicitly
-- flagged that it could not independently corroborate this pair via a
-- plain web search, and it rests solely on gazettetracker.com's Full Text.
-- Recorded honestly rather than smoothed to look as solid as the rest.
--
-- Also modeled (2026-09-04): G.S.R. 559(E) amends the Ladakh RERA (General)
-- Rules, 2020 (G.S.R. 619(E)); and S.O. 1713(E) amends S.O. 3184(E), which
-- itself continues S.O. 2666(E) — a RERA Central Advisory Council
-- membership chain, two edges.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('housing-and-urban-affairs', 'Ministry of Housing and Urban Affairs', 'Directorate of Estates');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('mohua-notifications-general', 'MoHUA notifications (various subject matter)', NULL),
  ('ladakh-rera-general-rules-2020', 'Ladakh Real Estate (Regulation and Development) (General) Rules, 2020', 2020),
  ('rera-act-2016', 'Real Estate (Regulation and Development) Act, 2016 — Central Advisory Council', 2016);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mohua-corrections', 'MoHUA notification corrigenda', 'active'),
  ('mohua-ladakh-rera-rules', 'Ladakh RERA General Rules and its amendments', 'active'),
  ('mohua-rera-cac-membership', 'RERA Central Advisory Council membership notifications', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mohua-so-3379-2026', 'MoHUA', 'S.O. 3379(E)', 2026, 'so-only', '2026-06-24', 'S.O. 3379(E)', 'housing-and-urban-affairs', 'mohua-notifications-general', 'mohua-corrections'),
  ('mohua-so-4041-2026', 'MoHUA', 'S.O. 4041(E)', 2026, 'so-only', '2026-07-23', 'S.O. 4041(E)', 'housing-and-urban-affairs', 'mohua-notifications-general', 'mohua-corrections'),
  ('mohua-gsr-619-2020', 'MoHUA', 'G.S.R. 619(E)', 2020, 'so-only', '2020-10-08', 'G.S.R. 619(E)', 'housing-and-urban-affairs', 'ladakh-rera-general-rules-2020', 'mohua-ladakh-rera-rules'),
  ('mohua-gsr-559-2026', 'MoHUA', 'G.S.R. 559(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 559(E)', 'housing-and-urban-affairs', 'ladakh-rera-general-rules-2020', 'mohua-ladakh-rera-rules'),
  ('mohua-so-2666-2017', 'MoHUA', 'S.O. 2666(E)', 2017, 'so-only', '2017-11-20', 'S.O. 2666(E)', 'housing-and-urban-affairs', 'rera-act-2016', 'mohua-rera-cac-membership'),
  ('mohua-so-3184-2022', 'MoHUA', 'S.O. 3184(E)', 2022, 'so-only', '2022-07-13', 'S.O. 3184(E)', 'housing-and-urban-affairs', 'rera-act-2016', 'mohua-rera-cac-membership'),
  ('mohua-so-1713-2026', 'MoHUA', 'S.O. 1713(E)', 2026, 'so-only', '2026-04-02', 'S.O. 1713(E)', 'housing-and-urban-affairs', 'rera-act-2016', 'mohua-rera-cac-membership');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mohua-so-4041-2026', 'mohua-so-3379-2026', 'corrigendum', 'research-agent-quoted-uncorroborated', '2026-09-03'),
  ('mohua-gsr-559-2026', 'mohua-gsr-619-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-3184-2022', 'mohua-so-2666-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mohua-so-1713-2026', 'mohua-so-3184-2022', 'amends', 'research-agent-quoted', '2026-09-04');
