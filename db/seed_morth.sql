-- Second-ministry pilot seed: Ministry of Road Transport and Highways.
--
-- Provenance is weaker than db/seed_cbic.sql and that's recorded honestly,
-- not hidden: this single corrigendum pair was observed directly on a live
-- public gazette-tracking feed during the design conversation (verified_by =
-- 'observed-live-feed-2026-09-03'), not fetched and read from the primary-
-- source notification PDF the way every CBIC row was. It's a real example,
-- not a fabricated one, but it is one example, not a validated pattern —
-- see GATES.md G4.
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
  ('morth-so-4848-2026', 'National Highways Act 1956', 'S.O. 4848(E)', 2026, 'so-only', '2026-09-01', 'S.O. 4848(E)', 'road-transport-highways', 'nh-act-1956-s3a', 'morth-land-acquisition-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at)
VALUES ('morth-so-4848-2026', 'morth-so-4872-2025', 'corrigendum', 'observed-live-feed-2026-09-03', '2026-09-03');
