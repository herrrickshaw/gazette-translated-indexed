-- Ministry of External Affairs pilot. Three real pairs researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04, modeled
-- via extract/external_affairs_patterns.py (all three existing
-- ministry-anchored/supersession templates — see that module's docstring).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('external-affairs', 'Ministry of External Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('territorial-waters-baseline-notification', 'Territorial waters baseline-coordinates notification', NULL),
  ('maritime-designated-areas-2009', 'Maritime zones designated-areas notification, 2009', 2009),
  ('passports-act-1967-prosecution-sanction', 'Passports Act, 1967 — prosecution-sanction authority notification', 1967);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('baseline-coordinates-corrigendum', 'Territorial waters baseline-coordinates corrigendum', 'active'),
  ('maritime-designated-areas-amendment', 'Maritime designated-areas notification and its amendment', 'active'),
  ('passports-act-prosecution-sanction', 'Passports Act prosecution-sanction authority', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain
  ('mea-gsr-216-2025', 'MEA', 'G.S.R. 216(E)', 2025, 'so-only', '2025-04-02', 'G.S.R. 216(E)', 'external-affairs', 'territorial-waters-baseline-notification', 'baseline-coordinates-corrigendum'),
  ('mea-gsr-253-2025', 'MEA', 'G.S.R. 253(E)', 2025, 'so-only', '2025-04-22', 'G.S.R. 253(E)', 'external-affairs', 'territorial-waters-baseline-notification', 'baseline-coordinates-corrigendum'),
  -- Pair 2: two-node chain
  ('mea-so-135-2009',  'MEA', 'S.O. 135(E)',  2009, 'so-only', '2009-01-13', 'S.O. 135(E)',  'external-affairs', 'maritime-designated-areas-2009', 'maritime-designated-areas-amendment'),
  ('mea-so-2565-2025', 'MEA', 'S.O. 2565(E)', 2025, 'so-only', '2025-06-12', 'S.O. 2565(E)', 'external-affairs', 'maritime-designated-areas-2009', 'maritime-designated-areas-amendment'),
  -- Pair 3: three-node chain (one source supersedes two targets)
  ('mea-gsr-662-1979', 'MEA', 'G.S.R. 662(E)', 1979, 'so-only', '1979-12-01', 'G.S.R. 662(E)', 'external-affairs', 'passports-act-1967-prosecution-sanction', 'passports-act-prosecution-sanction'),
  ('mea-gsr-370-2010', 'MEA', 'G.S.R. 370(E)', 2010, 'so-only', '2010-02-09', 'G.S.R. 370(E)', 'external-affairs', 'passports-act-1967-prosecution-sanction', 'passports-act-prosecution-sanction'),
  ('mea-so-3022-2026', 'MEA', 'S.O. 3022(E)', 2026, 'so-only', '2026-05-26', 'S.O. 3022(E)', 'external-affairs', 'passports-act-1967-prosecution-sanction', 'passports-act-prosecution-sanction');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mea-gsr-253-2025', 'mea-gsr-216-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-2565-2025', 'mea-so-135-2009',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-3022-2026', 'mea-gsr-662-1979', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-3022-2026', 'mea-gsr-370-2010', 'supersedes', 'research-agent-quoted', '2026-09-04');
