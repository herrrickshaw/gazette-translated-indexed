-- Ministry of Civil Aviation pilot.
--
-- Modeled: G.S.R. 124(E) corrects the English text of G.S.R. 77(E), the
-- Protection of Interests in Aircraft Objects Rules, 2026 (verified_by
-- 'research-agent-quoted').
--
-- Also modeled (2026-09-04): G.S.R. 647(E) amends the Aircraft
-- (Investigation of Accidents and Incidents) Rules, 2025 (G.S.R. 829(E)) —
-- a "NOTE:-" clause citing its own principal directly, single-hop chain.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('civil-aviation', 'Ministry of Civil Aviation', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('protection-interests-aircraft-objects-rules-2026', 'Protection of Interests in Aircraft Objects Rules, 2026', 2026),
  ('aircraft-investigation-accidents-incidents-rules-2025', 'Aircraft (Investigation of Accidents and Incidents) Rules, 2025', 2025);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('civil-aviation-corrections', 'Ministry of Civil Aviation notification corrigenda', 'active'),
  ('civil-aviation-accident-investigation-rules', 'Aircraft accident-investigation rules and their amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('civav-gsr-77-2026', 'Civil Aviation', 'G.S.R. 77(E)', 2026, 'so-only', '2026-01-30', 'G.S.R. 77(E)', 'civil-aviation', 'protection-interests-aircraft-objects-rules-2026', 'civil-aviation-corrections'),
  ('civav-gsr-124-2026', 'Civil Aviation', 'G.S.R. 124(E)', 2026, 'so-only', '2026-02-12', 'G.S.R. 124(E)', 'civil-aviation', 'protection-interests-aircraft-objects-rules-2026', 'civil-aviation-corrections'),
  ('civav-gsr-829-2025', 'Civil Aviation', 'G.S.R. 829(E)', 2025, 'so-only', '2025-11-07', 'G.S.R. 829(E)', 'civil-aviation', 'aircraft-investigation-accidents-incidents-rules-2025', 'civil-aviation-accident-investigation-rules'),
  ('civav-gsr-647-2026', 'Civil Aviation', 'G.S.R. 647(E)', 2026, 'so-only', '2026-07-17', 'G.S.R. 647(E)', 'civil-aviation', 'aircraft-investigation-accidents-incidents-rules-2025', 'civil-aviation-accident-investigation-rules');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('civav-gsr-124-2026', 'civav-gsr-77-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  ('civav-gsr-647-2026', 'civav-gsr-829-2025', 'amends', 'research-agent-quoted', '2026-09-04');
