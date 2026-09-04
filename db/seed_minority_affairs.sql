-- Ministry of Minority Affairs pilot. Three real note-chains researched
-- via gazettetracker.com (Full Text section, primary), 2026-09-04 — all
-- covered by the existing note-chain template
-- (extract.common_templates.find_note_chain), no new extractor code.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('minority-affairs', 'Ministry of Minority Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('central-waqf-council-rules-1998', 'Central Waqf Council Rules, 1998', 1998),
  ('central-waqf-council-recruitment-rules-2014', 'Central Waqf Council (Group A/B/C) Recruitment Rules, 2014', 2014),
  ('haj-committee-act-2002', 'Haj Committee Act, 2002 (Haj Committee of India composition)', 2002);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('central-waqf-council-rules-amendments', 'Central Waqf Council Rules, 1998 and its amendments', 'active'),
  ('central-waqf-council-recruitment-amendments', 'Central Waqf Council Recruitment Rules and its amendments', 'active'),
  ('haj-committee-composition', 'Haj Committee of India composition', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: six-node chain
  ('moma-gsr-593-1998', 'MoMA', 'G.S.R. 593(E)', 1998, 'so-only', '1998-09-30', 'G.S.R. 593(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-240-2012', 'MoMA', 'G.S.R. 240(E)', 2012, 'so-only', '2012-03-22', 'G.S.R. 240(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-693-2014', 'MoMA', 'G.S.R. 693(E)', 2014, 'so-only', '2014-09-25', 'G.S.R. 693(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-532-2015', 'MoMA', 'G.S.R. 532(E)', 2015, 'so-only', '2015-07-02', 'G.S.R. 532(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-344-2022', 'MoMA', 'G.S.R. 344(E)', 2022, 'so-only', '2022-05-09', 'G.S.R. 344(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  ('moma-gsr-753-2026', 'MoMA', 'G.S.R. 753(E)', 2026, 'so-only', '2026-08-18', 'G.S.R. 753(E)', 'minority-affairs', 'central-waqf-council-rules-1998', 'central-waqf-council-rules-amendments'),
  -- Pair 2: three-node chain
  ('moma-gsr-363-2014', 'MoMA', 'G.S.R. 363(E)', 2014, 'so-only', '2014-05-28', 'G.S.R. 363(E)', 'minority-affairs', 'central-waqf-council-recruitment-rules-2014', 'central-waqf-council-recruitment-amendments'),
  ('moma-gsr-617-2016', 'MoMA', 'G.S.R. 617(E)', 2016, 'so-only', '2016-06-22', 'G.S.R. 617(E)', 'minority-affairs', 'central-waqf-council-recruitment-rules-2014', 'central-waqf-council-recruitment-amendments'),
  ('moma-gsr-754-2026', 'MoMA', 'G.S.R. 754(E)', 2026, 'so-only', '2026-08-18', 'G.S.R. 754(E)', 'minority-affairs', 'central-waqf-council-recruitment-rules-2014', 'central-waqf-council-recruitment-amendments'),
  -- Pair 3: six-node chain
  ('moma-so-1564-2022', 'MoMA', 'S.O. 1564(E)', 2022, 'so-only', '2022-04-01', 'S.O. 1564(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-1912-2022', 'MoMA', 'S.O. 1912(E)', 2022, 'so-only', '2022-04-21', 'S.O. 1912(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-2234-2022', 'MoMA', 'S.O. 2234(E)', 2022, 'so-only', '2022-05-12', 'S.O. 2234(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-1183-2024', 'MoMA', 'S.O. 1183(E)', 2024, 'so-only', '2024-03-07', 'S.O. 1183(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-4171-2024', 'MoMA', 'S.O. 4171(E)', 2024, 'so-only', '2024-09-23', 'S.O. 4171(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition'),
  ('moma-so-4368-2024', 'MoMA', 'S.O. 4368(E)', 2024, 'so-only', '2024-10-08', 'S.O. 4368(E)', 'minority-affairs', 'haj-committee-act-2002', 'haj-committee-composition');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moma-gsr-240-2012', 'moma-gsr-593-1998', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-693-2014', 'moma-gsr-240-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-532-2015', 'moma-gsr-693-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-344-2022', 'moma-gsr-532-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-753-2026', 'moma-gsr-344-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-617-2016', 'moma-gsr-363-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-gsr-754-2026', 'moma-gsr-617-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-1912-2022', 'moma-so-1564-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-2234-2022', 'moma-so-1912-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-1183-2024', 'moma-so-2234-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-4171-2024', 'moma-so-1183-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moma-so-4368-2024', 'moma-so-4171-2024', 'amends', 'research-agent-quoted', '2026-09-04');
