-- Ministry of Home Affairs pilot.
--
-- Modeled: S.O. 3778(E) amends S.O. 3987(E) (immigration post list,
-- verified_by 'research-agent-quoted' — primary Full Text quoted by a
-- research agent, not independently re-fetched this session).
--
-- Real leads found but NOT modeled here (different relationship shapes,
-- deliberately left as backlog rather than forced into this schema):
--   - S.O. 4583(E) (19 Aug 2026) disapplies/rescinds THREE earlier orders
--     (S.O. 1231(E), S.O. 941(E), S.O. 1110(E)) in specific states — a
--     one-to-many relationship this schema can represent (multiple
--     cross_reference rows from one source) but not attempted this pass.
--   - An "Amendment to Resolution" (F. No. 25022/38/2025-F.I) cited by File
--     Number, not an S.O./G.S.R. citation — doesn't fit numbering_form at
--     all as currently modeled; would need a new form.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('home-affairs', 'Ministry of Home Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('mha-notifications-general', 'MHA notifications (various subject matter)', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mha-amendments', 'MHA notification amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mha-so-3987-2025', 'MHA', 'S.O. 3987(E)', 2025, 'so-only', '2025-09-01', 'S.O. 3987(E)', 'home-affairs', 'mha-notifications-general', 'mha-amendments'),
  ('mha-so-3778-2026', 'MHA', 'S.O. 3778(E)', 2026, 'so-only', '2026-07-10', 'S.O. 3778(E)', 'home-affairs', 'mha-notifications-general', 'mha-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mha-so-3778-2026', 'mha-so-3987-2025', 'amends', 'research-agent-quoted', '2026-09-03');
