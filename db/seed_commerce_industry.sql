-- Ministry of Commerce and Industry pilot. Three real pairs researched
-- via gazettetracker.com (Full Text section, primary), 2026-09-04 —
-- deliberately targeting the G.S.R./S.O.-numbered side of this ministry's
-- work (SEZ Rules, Ammonium Nitrate Rules) rather than the bare
-- DGFT-numbered notifications already known to be unusable by this
-- pipeline (see Textiles' Hank Yarn precedent).
--
-- All three are pure note-chain/narrative shapes; no dedicated extractor
-- module. Pair 2's plain-rescission narrative ("hereby rescinds the above
-- notification except for things done or omitted to be done before such
-- rescission") is a genuinely distinct shape from "in supersession of"
-- (the word is "rescinds", and there's no "in supersession of" substring
-- to anchor the existing template on) — only one real example exists so
-- far, so it is modeled directly rather than generalized into a template.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('commerce-and-industry', 'Ministry of Commerce and Industry', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('sez-rules-2006', 'Special Economic Zones Rules, 2006', 2006),
  ('rudradev-infopark-sez', 'Rudradev Infopark SEZ notification', NULL),
  ('ammonium-nitrate-rules-2012', 'Ammonium Nitrate Rules, 2012', 2012);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('sez-rules-amendments', 'SEZ Rules, 2006 and its amendments', 'active'),
  ('rudradev-infopark-sez-rescission', 'Rudradev Infopark SEZ rescission', 'superseded'),
  ('ammonium-nitrate-rules-amendments', 'Ammonium Nitrate Rules, 2012 and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: three-node chain
  ('moci-gsr-54-2006',  'MoCI', 'G.S.R. 54(E)',  2006, 'so-only', '2006-02-10', 'G.S.R. 54(E)',  'commerce-and-industry', 'sez-rules-2006', 'sez-rules-amendments'),
  ('moci-gsr-114-2026', 'MoCI', 'G.S.R. 114(E)', 2026, 'so-only', '2026-02-03', 'G.S.R. 114(E)', 'commerce-and-industry', 'sez-rules-2006', 'sez-rules-amendments'),
  ('moci-gsr-609-2026', 'MoCI', 'G.S.R. 609(E)', 2026, 'so-only', '2026-07-09', 'G.S.R. 609(E)', 'commerce-and-industry', 'sez-rules-2006', 'sez-rules-amendments'),
  -- Pair 2: two-node chain, rescission
  ('moci-so-837-2007',  'MoCI', 'S.O. 837(E)',  2007, 'so-only', '2007-05-18', 'S.O. 837(E)',  'commerce-and-industry', 'rudradev-infopark-sez', 'rudradev-infopark-sez-rescission'),
  ('moci-so-4056-2026', 'MoCI', 'S.O. 4056(E)', 2026, 'so-only', '2026-07-22', 'S.O. 4056(E)', 'commerce-and-industry', 'rudradev-infopark-sez', 'rudradev-infopark-sez-rescission'),
  -- Pair 3: seven-node chain
  ('moci-gsr-553-2012', 'MoCI', 'G.S.R. 553(E)', 2012, 'so-only', '2012-07-11', 'G.S.R. 553(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-469-2013', 'MoCI', 'G.S.R. 469(E)', 2013, 'so-only', '2013-07-09', 'G.S.R. 469(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-938-2018', 'MoCI', 'G.S.R. 938(E)', 2018, 'so-only', '2018-09-28', 'G.S.R. 938(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-608-2021', 'MoCI', 'G.S.R. 608(E)', 2021, 'so-only', '2021-09-01', 'G.S.R. 608(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-239-2025', 'MoCI', 'G.S.R. 239(E)', 2025, 'so-only', '2025-04-17', 'G.S.R. 239(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-377-2025', 'MoCI', 'G.S.R. 377(E)', 2025, 'so-only', '2025-06-09', 'G.S.R. 377(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-659-2026', 'MoCI', 'G.S.R. 659(E)', 2026, 'so-only', '2026-07-16', 'G.S.R. 659(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moci-gsr-114-2026', 'moci-gsr-54-2006',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-609-2026', 'moci-gsr-114-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-4056-2026', 'moci-so-837-2007',  'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-469-2013', 'moci-gsr-553-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-938-2018', 'moci-gsr-469-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-608-2021', 'moci-gsr-938-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-239-2025', 'moci-gsr-608-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-377-2025', 'moci-gsr-239-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-659-2026', 'moci-gsr-377-2025', 'amends', 'research-agent-quoted', '2026-09-04');
