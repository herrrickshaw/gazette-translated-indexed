-- Ministry of Ayush pilot. Three real pairs researched via gazettetracker.com
-- (Full Text section, primary), 2026-09-04.
--
-- Pair 1/2: corrigendum-substitution template (extract/ayush_patterns.py).
-- Pair 3: note-chain template (extract.common_templates.find_note_chain) —
-- the real Note clause has a comma typo ("S.O, 2281(E)") in place of the
-- expected period, fixed in extract/citation_patterns.py's _SO_RE/_GSR_RE
-- ([.,]? tolerance) and covered by tests/test_ayush_note_chain.py.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('ayush', 'Ministry of Ayush', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('drugs-cosmetics-act-1940', 'Drugs and Cosmetics Act, 1940 — Fifth Amendment Rules, 2024', 1940),
  ('ncism-act-2020', 'National Commission for Indian System of Medicine Act, 2020', 2020);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('ayush-drugs-fifth-amendment-corrigendum', 'Corrigendum to the Drugs (Fifth Amendment) Rules, 2024', 'active'),
  ('ayush-ep3-recruitment-corrigendum', 'Corrigendum to an EP-III recruitment rules notification', 'active'),
  ('ayush-ncism-appointments', 'NCISM Act appointments and their amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: G.S.R. 660(E) corrects G.S.R. 669(E)
  ('ayush-gsr-669-2024', 'Ayush', 'G.S.R. 669(E)', 2024, 'so-only', '2024-10-28', 'G.S.R. 669(E)', 'ayush', 'drugs-cosmetics-act-1940', 'ayush-drugs-fifth-amendment-corrigendum'),
  ('ayush-gsr-660-2024', 'Ayush', 'G.S.R. 660(E)', 2024, 'so-only', '2024-11-18', 'G.S.R. 660(E)', 'ayush', 'drugs-cosmetics-act-1940', 'ayush-drugs-fifth-amendment-corrigendum'),
  -- Pair 2: G.S.R. 717(E) corrects G.S.R. 637(E) (EP-III recruitment rules,
  -- File No. R-21011/3/2022-EP-III — no dedicated act_or_rule row: the
  -- underlying rules instrument wasn't named in the quoted text, only the
  -- file number, so instrument_id is left NULL rather than guessed)
  ('ayush-gsr-637-2024', 'Ayush', 'G.S.R. 637(E)', 2024, 'so-only', '2024-10-14', 'G.S.R. 637(E)', 'ayush', NULL, 'ayush-ep3-recruitment-corrigendum'),
  ('ayush-gsr-717-2024', 'Ayush', 'G.S.R. 717(E)', 2024, 'so-only', '2024-11-18', 'G.S.R. 717(E)', 'ayush', NULL, 'ayush-ep3-recruitment-corrigendum'),
  -- Pair 3: three-item chain S.O. 2281(E) [principal] -> S.O. 221(E) -> S.O. 563(E) [current]
  ('ayush-so-2281-2021', 'Ayush', 'S.O. 2281(E)', 2021, 'so-only', '2021-06-11', 'S.O. 2281(E)', 'ayush', 'ncism-act-2020', 'ayush-ncism-appointments'),
  ('ayush-so-221-2024',  'Ayush', 'S.O. 221(E)',  2024, 'so-only', '2024-03-19', 'S.O. 221(E)',  'ayush', 'ncism-act-2020', 'ayush-ncism-appointments'),
  ('ayush-so-563-2026',  'Ayush', 'S.O. 563(E)',  2026, 'so-only', '2026-02-04', 'S.O. 563(E)',  'ayush', 'ncism-act-2020', 'ayush-ncism-appointments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('ayush-gsr-660-2024', 'ayush-gsr-669-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('ayush-gsr-717-2024', 'ayush-gsr-637-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('ayush-so-221-2024',  'ayush-so-2281-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('ayush-so-563-2026',  'ayush-so-221-2024',  'amends', 'research-agent-quoted', '2026-09-04');
