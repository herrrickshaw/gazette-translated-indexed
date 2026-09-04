-- Ministry of Ports, Shipping and Waterways pilot. Three real pairs
-- researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04, modeled via extract/ports_shipping_patterns.py (combining
-- corrigendum-substitution, supersession-preamble, and the new
-- bare-citation-reference template — see that module's docstring).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('ports-shipping-waterways', 'Ministry of Ports, Shipping and Waterways', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('major-port-authorities-act-2021', 'Major Port Authorities Act, 2021 (port authority appointment)', 2021),
  ('inland-vessels-safe-navigation-rules-2022', 'Inland Vessels (Safe Navigation, Communication and Signals) Rules, 2022', 2022),
  ('national-shipping-board-rules-1960', 'National Shipping Board Rules, 1960 (member composition)', 1960);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('port-authority-appointment-chain', 'Port authority appointment: supersession then corrigendum', 'active'),
  ('inland-vessels-rules-amendment', 'Inland Vessels Rules, 2022 and its amendment', 'active'),
  ('national-shipping-board-composition', 'National Shipping Board member composition', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: three-node chain
  ('mopsw-gsr-641-2024', 'MoPSW', 'G.S.R. 641(E)', 2024, 'so-only', '2024-10-15', 'G.S.R. 641(E)', 'ports-shipping-waterways', 'major-port-authorities-act-2021', 'port-authority-appointment-chain'),
  ('mopsw-gsr-651-2026', 'MoPSW', 'G.S.R. 651(E)', 2026, 'so-only', '2026-07-22', 'G.S.R. 651(E)', 'ports-shipping-waterways', 'major-port-authorities-act-2021', 'port-authority-appointment-chain'),
  ('mopsw-gsr-677-2026', 'MoPSW', 'G.S.R. 677(E)', 2026, 'so-only', '2026-07-29', 'G.S.R. 677(E)', 'ports-shipping-waterways', 'major-port-authorities-act-2021', 'port-authority-appointment-chain'),
  -- Pair 2: two-node chain
  ('mopsw-gsr-424-2022', 'MoPSW', 'G.S.R. 424(E)', 2022, 'so-only', '2022-06-07', 'G.S.R. 424(E)', 'ports-shipping-waterways', 'inland-vessels-safe-navigation-rules-2022', 'inland-vessels-rules-amendment'),
  ('mopsw-gsr-155-2026', 'MoPSW', 'G.S.R. 155(E)', 2026, 'so-only', '2026-03-05', 'G.S.R. 155(E)', 'ports-shipping-waterways', 'inland-vessels-safe-navigation-rules-2022', 'inland-vessels-rules-amendment'),
  -- Pair 3: two-node chain
  ('mopsw-so-1935-2025', 'MoPSW', 'S.O. 1935(E)', 2025, 'so-only', '2025-04-30', 'S.O. 1935(E)', 'ports-shipping-waterways', 'national-shipping-board-rules-1960', 'national-shipping-board-composition'),
  ('mopsw-so-4353-2025', 'MoPSW', 'S.O. 4353(E)', 2025, 'so-only', '2025-09-23', 'S.O. 4353(E)', 'ports-shipping-waterways', 'national-shipping-board-rules-1960', 'national-shipping-board-composition');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mopsw-gsr-651-2026', 'mopsw-gsr-641-2024', 'supersedes',  'research-agent-quoted', '2026-09-04'),
  ('mopsw-gsr-677-2026', 'mopsw-gsr-651-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mopsw-gsr-155-2026', 'mopsw-gsr-424-2022', 'amends',      'research-agent-quoted', '2026-09-04'),
  ('mopsw-so-4353-2025', 'mopsw-so-1935-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04');
