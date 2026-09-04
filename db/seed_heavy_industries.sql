-- Ministry of Heavy Industries pilot. Three real pairs researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04, modeled
-- via extract/heavy_industries_patterns.py (corrigendum-substitution
-- template). Two are Hindi-text-only corrigenda (no substantive/English
-- change); the third is a genuine substantive amendment.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('heavy-industries', 'Ministry of Heavy Industries', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('electric-mobility-promotion-scheme-2024', 'Electric Mobility Promotion Scheme, 2024', 2024),
  ('pm-edrive-scheme-2024', 'PM E-DRIVE Scheme, 2024', 2024),
  ('pli-auto-scheme-2021', 'Production Linked Incentive (PLI) Scheme for Automobile and Auto Component Industry, 2021', 2021);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('emps-2024-corrigendum', 'Electric Mobility Promotion Scheme, 2024 Hindi-text corrigendum', 'active'),
  ('pm-edrive-corrigendum', 'PM E-DRIVE Scheme Hindi-text corrigendum', 'active'),
  ('pli-auto-amendments', 'PLI-Auto Scheme and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mohi-so-1334-2024', 'MoHI', 'S.O. 1334(E)', 2024, 'so-only', '2024-03-13', 'S.O. 1334(E)', 'heavy-industries', 'electric-mobility-promotion-scheme-2024', 'emps-2024-corrigendum'),
  ('mohi-so-1636-2024', 'MoHI', 'S.O. 1636(E)', 2024, 'so-only', '2024-04-05', 'S.O. 1636(E)', 'heavy-industries', 'electric-mobility-promotion-scheme-2024', 'emps-2024-corrigendum'),
  ('mohi-so-4259-2024', 'MoHI', 'S.O. 4259(E)', 2024, 'so-only', '2024-09-29', 'S.O. 4259(E)', 'heavy-industries', 'pm-edrive-scheme-2024', 'pm-edrive-corrigendum'),
  ('mohi-so-4703-2024', 'MoHI', 'S.O. 4703(E)', 2024, 'so-only', '2024-10-24', 'S.O. 4703(E)', 'heavy-industries', 'pm-edrive-scheme-2024', 'pm-edrive-corrigendum'),
  ('mohi-so-3946-2021', 'MoHI', 'S.O. 3946(E)', 2021, 'so-only', '2021-09-23', 'S.O. 3946(E)', 'heavy-industries', 'pli-auto-scheme-2021', 'pli-auto-amendments'),
  ('mohi-so-5486-2023', 'MoHI', 'S.O. 5486(E)', 2023, 'so-only', '2023-12-29', 'S.O. 5486(E)', 'heavy-industries', 'pli-auto-scheme-2021', 'pli-auto-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mohi-so-1636-2024', 'mohi-so-1334-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-4703-2024', 'mohi-so-4259-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mohi-so-5486-2023', 'mohi-so-3946-2021', 'amends', 'research-agent-quoted', '2026-09-04');
