-- Ministry of Housing and Urban Affairs (MoHUA) pilot.
--
-- Modeled: S.O. 4041(E) corrects S.O. 3379(E), a Directorate of Estates
-- notification. verified_by 'research-agent-quoted' — and the WEAKEST
-- corroboration in this project so far: the research agent explicitly
-- flagged that it could not independently corroborate this pair via a
-- plain web search, and it rests solely on gazettetracker.com's Full Text.
-- Recorded honestly rather than smoothed to look as solid as the rest.
--
-- Real leads found but NOT modeled here (Rules/consolidated-instrument
-- shape, not a single corrigendum pair):
--   - G.S.R. 559(E) (1 Jul 2026) amends the Ladakh Real Estate (Regulation
--     and Development) (General) Rules, 2020 (G.S.R. 619(E), 8 Oct 2020).
--   - S.O. 1713(E) (2 Apr 2026) amends S.O. 3184(E) (13 Jul 2022), itself
--     continuing S.O. 2666(E) (20 Nov 2017) — a RERA Central Advisory
--     Council membership chain.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('housing-and-urban-affairs', 'Ministry of Housing and Urban Affairs', 'Directorate of Estates');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('mohua-notifications-general', 'MoHUA notifications (various subject matter)', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mohua-corrections', 'MoHUA notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mohua-so-3379-2026', 'MoHUA', 'S.O. 3379(E)', 2026, 'so-only', '2026-06-24', 'S.O. 3379(E)', 'housing-and-urban-affairs', 'mohua-notifications-general', 'mohua-corrections'),
  ('mohua-so-4041-2026', 'MoHUA', 'S.O. 4041(E)', 2026, 'so-only', '2026-07-23', 'S.O. 4041(E)', 'housing-and-urban-affairs', 'mohua-notifications-general', 'mohua-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mohua-so-4041-2026', 'mohua-so-3379-2026', 'corrigendum', 'research-agent-quoted-uncorroborated', '2026-09-03');
