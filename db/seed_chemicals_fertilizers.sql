-- Ministry of Chemicals and Fertilizers pilot (Department of
-- Pharmaceuticals / National Pharmaceutical Pricing Authority). Three real
-- corrigenda researched via gazettetracker.com (Full Text section,
-- primary), 2026-09-04. All three name the National Pharmaceutical
-- Pricing Authority, never "the Ministry of Chemicals and Fertilizers"
-- itself — the real evidence for the new extract/chemicals_fertilizers_patterns.py
-- module (see its own docstring for why the shared corrigendum-
-- substitution template's ministry-name anchor doesn't fit).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('chemicals-and-fertilizers', 'Ministry of Chemicals and Fertilizers', 'Department of Pharmaceuticals (National Pharmaceutical Pricing Authority)');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('nppa-ringer-lactate-ceiling-price', 'NPPA ceiling-price fixation, Ringer Lactate', NULL),
  ('nppa-retail-price-order-575-2021', 'NPPA retail-price fixation order (S.O. 575(E), 2021)', 2021),
  ('nppa-retail-price-order-5635-2018', 'NPPA retail-price fixation order (S.O. 5635(E), 2018)', 2018);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('nppa-ringer-lactate-corrigendum', 'NPPA Ringer Lactate ceiling-price corrigendum', 'active'),
  ('nppa-retail-price-corrigendum-2021', 'NPPA retail-price corrigendum (2021 order)', 'active'),
  ('nppa-retail-price-corrigendum-2018', 'NPPA retail-price corrigendum (2018 order)', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mocf-so-1584-2026', 'NPPA', 'S.O. 1584(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1584(E)', 'chemicals-and-fertilizers', 'nppa-ringer-lactate-ceiling-price', 'nppa-ringer-lactate-corrigendum'),
  ('mocf-so-2682-2026', 'NPPA', 'S.O. 2682(E)', 2026, 'so-only', '2026-05-27', 'S.O. 2682(E)', 'chemicals-and-fertilizers', 'nppa-ringer-lactate-ceiling-price', 'nppa-ringer-lactate-corrigendum'),
  ('mocf-so-575-2021',  'NPPA', 'S.O. 575(E)',  2021, 'so-only', '2021-02-09', 'S.O. 575(E)',  'chemicals-and-fertilizers', 'nppa-retail-price-order-575-2021', 'nppa-retail-price-corrigendum-2021'),
  ('mocf-so-1591-2026', 'NPPA', 'S.O. 1591(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1591(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-575-2021', 'nppa-retail-price-corrigendum-2021'),
  ('mocf-so-5635-2018', 'NPPA', 'S.O. 5635(E)', 2018, 'so-only', '2018-11-02', 'S.O. 5635(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-5635-2018', 'nppa-retail-price-corrigendum-2018'),
  ('mocf-so-1592-2026', 'NPPA', 'S.O. 1592(E)', 2026, 'so-only', '2026-03-25', 'S.O. 1592(E)', 'chemicals-and-fertilizers', 'nppa-retail-price-order-5635-2018', 'nppa-retail-price-corrigendum-2018');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mocf-so-2682-2026', 'mocf-so-1584-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1591-2026', 'mocf-so-575-2021',  'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mocf-so-1592-2026', 'mocf-so-5635-2018', 'corrigendum', 'research-agent-quoted', '2026-09-04');
