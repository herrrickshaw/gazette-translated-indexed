-- Ministry of Skill Development and Entrepreneurship pilot. Three real
-- pairs researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04. First ministry needing two templates in one extractor —
-- corrigendum-substitution (pair 1) and the newly-generalized
-- supersession-preamble (pairs 2/3, see extract.common_templates and
-- extract/skill_development_patterns.py).
--
-- A fourth real lead (CGFSSD scheme modification, "Notification No.
-- SL-11/01/2023-T&P dated 09.07.2026" superseding "...dated 09.07.2024"
-- superseding "Notification No. 8-8/2014-SD&E (Vol.II) dated 20.11.2015")
-- is a bare form with no G.S.R./S.O./S.R.O. number anywhere and is
-- deliberately not modeled — same class of gap as Commerce/DGFT.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('skill-development-entrepreneurship', 'Ministry of Skill Development and Entrepreneurship', NULL),
  ('labour-and-employment', 'Ministry of Labour and Employment', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('msde-recruitment-rules-2025', 'MSDE recruitment rules (corrected 2025)', 2025),
  ('apprentices-act-1961', 'Apprentices Act, 1961', 1961);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('msde-recruitment-rules-corrigendum', 'Corrigendum to an MSDE recruitment rules notification', 'active'),
  ('apprentices-act-industry-coverage', 'Apprentices Act industry-coverage notification and its supersession', 'superseded'),
  ('central-apprenticeship-council', 'Central Apprenticeship Council reconstitution', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: G.S.R. 744(E) corrects G.S.R. 130(E)
  ('msde-gsr-130-2025', 'MSDE', 'G.S.R. 130(E)', 2025, 'so-only', '2025-02-11', 'G.S.R. 130(E)', 'skill-development-entrepreneurship', 'msde-recruitment-rules-2025', 'msde-recruitment-rules-corrigendum'),
  ('msde-gsr-744-2025', 'MSDE', 'G.S.R. 744(E)', 2025, 'so-only', '2025-10-08', 'G.S.R. 744(E)', 'skill-development-entrepreneurship', 'msde-recruitment-rules-2025', 'msde-recruitment-rules-corrigendum'),
  -- Pair 2: S.O. 4072(E) (MSDE) supersedes G.S.R. 479(E) (originally issued
  -- by the Ministry of Labour, Directorate General of Employment and
  -- Training — a cross-ministry supersession)
  ('mole-gsr-479-1999', 'Labour', 'G.S.R. 479(E)', 1999, 'so-only', '1999-06-30', 'G.S.R. 479(E)', 'labour-and-employment', 'apprentices-act-1961', 'apprentices-act-industry-coverage'),
  ('msde-so-4072-2025', 'MSDE', 'S.O. 4072(E)', 2025, 'so-only', '2025-09-03', 'S.O. 4072(E)', 'skill-development-entrepreneurship', 'apprentices-act-1961', 'apprentices-act-industry-coverage'),
  -- Pair 3: S.O. 4560(E) supersedes MSDE's own S.O. 1348(E)
  ('msde-so-1348-2019', 'MSDE', 'S.O. 1348(E)', 2019, 'so-only', '2019-03-08', 'S.O. 1348(E)', 'skill-development-entrepreneurship', 'apprentices-act-1961', 'central-apprenticeship-council'),
  ('msde-so-4560-2024', 'MSDE', 'S.O. 4560(E)', 2024, 'so-only', '2024-10-16', 'S.O. 4560(E)', 'skill-development-entrepreneurship', 'apprentices-act-1961', 'central-apprenticeship-council');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('msde-gsr-744-2025', 'msde-gsr-130-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('msde-so-4072-2025', 'mole-gsr-479-1999', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('msde-so-4560-2024', 'msde-so-1348-2019', 'supersedes', 'research-agent-quoted', '2026-09-04');
