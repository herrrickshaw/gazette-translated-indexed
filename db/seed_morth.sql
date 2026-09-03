-- Second-ministry pilot seed: Ministry of Road Transport and Highways.
--
-- Three real corrigendum-to-original pairs, two provenance tiers, both
-- recorded honestly rather than smoothed into one:
--   'primary-source-full-text'   — read directly off the notification's own
--                                   "Full Text" page (S.O. 4848(E)/4872(E))
--   'search-index-excerpt'       — a literal indexed excerpt of the gazette
--                                   text from a full-text search result (not
--                                   an AI summary, but not an independently
--                                   downloaded gazette PDF either)
-- Neither tier is CBIC's tier (reading the actual notification PDF start to
-- finish) — that distinction is the point, not an oversight. See GATES.md G4.
--
-- MoRTH notifications under the National Highways Act, 1956 carry no
-- ministry-internal sequential number at all (no "No. X/YYYY-series" the
-- way CBIC's do) — the S.O. gazette number is the only citation, hence
-- numbering_form = 'so-only', a form CBIC's schema didn't need.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('road-transport-highways', 'Ministry of Road Transport and Highways', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('nh-act-1956-s3a', 'National Highways Act, 1956 — section 3A/3D land acquisition', 1956);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('morth-land-acquisition-corrections', 'MoRTH land-acquisition notifications and their corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('morth-so-4872-2025', 'National Highways Act 1956', 'S.O. 4872(E)', 2025, 'so-only', '2025-10-24', 'S.O. 4872(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-4848-2026', 'National Highways Act 1956', 'S.O. 4848(E)', 2026, 'so-only', '2026-09-01', 'S.O. 4848(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-732-2025',  'National Highways Act 1956', 'S.O. 732(E)',  2025, 'so-only', '2025-02-11', 'S.O. 732(E)',  'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-2432-2025', 'National Highways Act 1956', 'S.O. 2432(E)', 2025, 'so-only', '2025-05-30', 'S.O. 2432(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-1265-2018', 'National Highways Act 1956', 'S.O. 1265(E)', 2018, 'so-only', '2018-03-16', 'S.O. 1265(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections'),
  ('morth-so-4689-2024', 'National Highways Act 1956', 'S.O. 4689(E)', 2024, 'so-only', '2024-10-25', 'S.O. 4689(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('morth-so-4848-2026', 'morth-so-4872-2025', 'corrigendum', 'primary-source-full-text', '2026-09-03'),
  ('morth-so-2432-2025', 'morth-so-732-2025',  'corrigendum', 'search-index-excerpt',      '2026-09-03'),
  ('morth-so-4689-2024', 'morth-so-1265-2018', 'corrigendum', 'search-index-excerpt',      '2026-09-03');
