-- Ministry of Electronics and Information Technology (MeitY) pilot.
--
-- Modeled: G.S.R. 148(E) corrects G.S.R. 120(E), an IT (Intermediary
-- Guidelines and Digital Media Ethics Code) Amendment Rules, 2026
-- correction (verified_by 'research-agent-quoted').
--
-- Real lead found but NOT modeled here:
--   - G.S.R. 892(E) (10 Dec 2025) corrects G.S.R. 846(E) (13 Nov 2025,
--     Digital Personal Data Protection Rules, 2025) — fits the same
--     template cleanly, deferred purely for time.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('electronics-and-information-technology', 'Ministry of Electronics and Information Technology', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('it-intermediary-guidelines-rules', 'Information Technology (Intermediary Guidelines and Digital Media Ethics Code) Rules', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('meity-corrections', 'MeitY notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('meity-gsr-120-2026', 'MeitY', 'G.S.R. 120(E)', 2026, 'so-only', '2026-02-10', 'G.S.R. 120(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'meity-corrections'),
  ('meity-gsr-148-2026', 'MeitY', 'G.S.R. 148(E)', 2026, 'so-only', '2026-02-26', 'G.S.R. 148(E)', 'electronics-and-information-technology', 'it-intermediary-guidelines-rules', 'meity-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('meity-gsr-148-2026', 'meity-gsr-120-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03');
