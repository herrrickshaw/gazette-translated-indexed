-- Ministry of Civil Aviation pilot.
--
-- Modeled: G.S.R. 124(E) corrects the English text of G.S.R. 77(E), the
-- Protection of Interests in Aircraft Objects Rules, 2026 (verified_by
-- 'research-agent-quoted').
--
-- Real lead found but NOT modeled here:
--   - G.S.R. 647(E) (17 Jul 2026) amends the Aircraft (Investigation of
--     Accidents and Incidents) Rules, 2025 (G.S.R. 829(E), 7 Nov 2025) —
--     inserts a supersession clause re: the 2017 rules; fits a Rules-
--     amendment shape close to but not identical to the modeled pair,
--     deferred purely for time.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('civil-aviation', 'Ministry of Civil Aviation', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('protection-interests-aircraft-objects-rules-2026', 'Protection of Interests in Aircraft Objects Rules, 2026', 2026);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('civil-aviation-corrections', 'Ministry of Civil Aviation notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('civav-gsr-77-2026', 'Civil Aviation', 'G.S.R. 77(E)', 2026, 'so-only', '2026-01-30', 'G.S.R. 77(E)', 'civil-aviation', 'protection-interests-aircraft-objects-rules-2026', 'civil-aviation-corrections'),
  ('civav-gsr-124-2026', 'Civil Aviation', 'G.S.R. 124(E)', 2026, 'so-only', '2026-02-12', 'G.S.R. 124(E)', 'civil-aviation', 'protection-interests-aircraft-objects-rules-2026', 'civil-aviation-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('civav-gsr-124-2026', 'civav-gsr-77-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03');
