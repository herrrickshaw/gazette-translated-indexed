-- Ministry of Corporate Affairs pilot.
--
-- Modeled: G.S.R. 849(E) corrects a misspelled name in G.S.R. 703(E)
-- (verified_by 'research-agent-quoted').
--
-- Real leads found but NOT modeled here (a different relationship shape —
-- an amending rule citing its own amendment history, not a single
-- corrigendum-to-original pair):
--   - G.S.R. 300(E) (21 Apr 2026) amends the Companies (Registration
--     Offices and Fees) Rules, originally G.S.R. 268(E) (31 Mar 2014),
--     "last amended, vide number G.S.R. 360(E), dated the 30th May, 2025."
--   - G.S.R. 943(E) (31 Dec 2025) amends the Companies (Appointment and
--     Qualification of Directors) Rules, originally G.S.R. 259(E)
--     (31 Mar 2014), "last amended ... vide notification number G.S.R.
--     412(E), dated the 16th July, 2024."
--   Both are genuine multi-notification amendment chains for a named Rules
--   instrument — closer to the CBIC "consolidated instrument" shape than a
--   simple corrigendum pair, and worth a dedicated pass rather than a rushed fit here.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('corporate-affairs', 'Ministry of Corporate Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('companies-act-2013', 'Companies Act, 2013', 2013);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mca-corrections', 'MCA notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mca-gsr-703-2025', 'MCA', 'G.S.R. 703(E)', 2025, 'so-only', '2025-09-22', 'G.S.R. 703(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-849-2025', 'MCA', 'G.S.R. 849(E)', 2025, 'so-only', '2025-11-17', 'G.S.R. 849(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mca-gsr-849-2025', 'mca-gsr-703-2025', 'corrigendum', 'research-agent-quoted', '2026-09-03');
