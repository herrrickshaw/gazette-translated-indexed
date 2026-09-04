-- Ministry of Corporate Affairs pilot.
--
-- Modeled: G.S.R. 849(E) corrects a misspelled name in G.S.R. 703(E)
-- (verified_by 'research-agent-quoted').
--
-- Also modeled (2026-09-04, using extract.common_templates.find_note_chain,
-- built once nine real ministries had confirmed the same shape): two
-- Note-chain amendment histories, each a principal Rules instrument plus
-- its most recently named prior amendment plus the current amending
-- notification — three real citations per chain, not fabricated
-- intermediates. Real, unlisted amendments may exist between the principal
-- and the "last amended" item named in each Note; only the named items are
-- modeled, the same limitation CBIC's own 31-notification chain accepts.

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
  ('mca-gsr-849-2025', 'MCA', 'G.S.R. 849(E)', 2025, 'so-only', '2025-11-17', 'G.S.R. 849(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  -- Companies (Registration Offices and Fees) Rules chain
  ('mca-gsr-268-2014', 'MCA', 'G.S.R. 268(E)', 2014, 'so-only', '2014-03-31', 'G.S.R. 268(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-360-2025', 'MCA', 'G.S.R. 360(E)', 2025, 'so-only', '2025-05-30', 'G.S.R. 360(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-300-2026', 'MCA', 'G.S.R. 300(E)', 2026, 'so-only', '2026-04-21', 'G.S.R. 300(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  -- Companies (Appointment and Qualification of Directors) Rules chain
  ('mca-gsr-259-2014', 'MCA', 'G.S.R. 259(E)', 2014, 'so-only', '2014-03-31', 'G.S.R. 259(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-412-2024', 'MCA', 'G.S.R. 412(E)', 2024, 'so-only', '2024-07-16', 'G.S.R. 412(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections'),
  ('mca-gsr-943-2025', 'MCA', 'G.S.R. 943(E)', 2025, 'so-only', '2025-12-31', 'G.S.R. 943(E)', 'corporate-affairs', 'companies-act-2013', 'mca-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mca-gsr-849-2025', 'mca-gsr-703-2025', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  ('mca-gsr-360-2025', 'mca-gsr-268-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-300-2026', 'mca-gsr-360-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-412-2024', 'mca-gsr-259-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mca-gsr-943-2025', 'mca-gsr-412-2024', 'amends', 'research-agent-quoted', '2026-09-04');
