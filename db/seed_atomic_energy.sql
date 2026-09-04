-- Department of Atomic Energy pilot. Three real pairs researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04, modeled
-- via extract/atomic_energy_patterns.py (amendment-in-notification
-- template) for pairs 1/2, plain note-chain for pair 3.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('atomic-energy', 'Department of Atomic Energy', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('dae-cca-authority-order-2022', 'DAE Classification, Control and Appeal authority order, 2022', 2022),
  ('dae-cca-authority-order-2013', 'DAE Classification, Control and Appeal authority order, 2013', 2013),
  ('dae-driver-cadre-recruitment-rules-2024', 'DAE (Driver Cadre) Recruitment Rules, 2024', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('dae-cca-authority-2022-amendment', 'DAE CCA authority order (2022) amendment', 'active'),
  ('dae-cca-authority-2013-amendment', 'DAE CCA authority order (2013) amendment', 'active'),
  ('dae-driver-cadre-rules-amendment', 'DAE Driver Cadre Recruitment Rules amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('dae-so-3943-2022', 'DAE', 'S.O. 3943(E)', 2022, 'so-only', '2022-08-17', 'S.O. 3943(E)', 'atomic-energy', 'dae-cca-authority-order-2022', 'dae-cca-authority-2022-amendment'),
  ('dae-so-2152-2025', 'DAE', 'S.O. 2152(E)', 2025, 'so-only', '2025-05-07', 'S.O. 2152(E)', 'atomic-energy', 'dae-cca-authority-order-2022', 'dae-cca-authority-2022-amendment'),
  ('dae-so-1317-2013', 'DAE', 'S.O. 1317(E)', 2013, 'so-only', '2013-05-16', 'S.O. 1317(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-2013-amendment'),
  ('dae-so-4585-2024', 'DAE', 'S.O. 4585(E)', 2024, 'so-only', '2024-10-17', 'S.O. 4585(E)', 'atomic-energy', 'dae-cca-authority-order-2013', 'dae-cca-authority-2013-amendment'),
  ('dae-gsr-509-2024', 'DAE', 'G.S.R. 509(E)', 2024, 'so-only', '2024-08-20', 'G.S.R. 509(E)', 'atomic-energy', 'dae-driver-cadre-recruitment-rules-2024', 'dae-driver-cadre-rules-amendment'),
  ('dae-gsr-732-2024', 'DAE', 'G.S.R. 732(E)', 2024, 'so-only', '2024-11-27', 'G.S.R. 732(E)', 'atomic-energy', 'dae-driver-cadre-recruitment-rules-2024', 'dae-driver-cadre-rules-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('dae-so-2152-2025', 'dae-so-3943-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-so-4585-2024', 'dae-so-1317-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dae-gsr-732-2024', 'dae-gsr-509-2024', 'amends', 'research-agent-quoted', '2026-09-04');
