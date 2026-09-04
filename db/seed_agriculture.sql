-- Ministry of Agriculture and Farmers Welfare pilot.
--
-- Modeled: S.O. 3666(E) amends S.O. 1018(E), a Fertiliser (Control) Order,
-- 1985 notification (verified_by 'research-agent-quoted').
--
-- This ministry's real text also contains a transcription typo ("herby" for
-- "hereby") that broke the shared amendment-in-notification anchor until
-- fixed in extract/common_templates.py — kept as printed in the test
-- fixture rather than silently corrected.
--
-- Also modeled (2026-09-04): S.O. 3665(E) amends S.O. 5836(E), a second
-- clean Fertiliser (Control) Order pair (same shape as S.O. 3666(E) above).
--
-- Also modeled: S.O. 2944(E) amends S.O. 2963(E) — the ELEVENTH and most
-- recent named amendment to S.O. 1589(E) (11 Nov 2005, Protection of Plant
-- Varieties and Farmers' Rights Act committee). This Note names all 11
-- intermediate amendments; only the endpoints this session actually
-- captured verbatim (item 11, and the 2005 principal) are modeled as
-- notification rows — items 2 through 10 are real but their individual
-- citations were not transcribed, so no edge is asserted between item 11
-- and the 2005 principal directly (that gap is real, not filled in).

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('agri-so-5836-2025', 'Agriculture', 'S.O. 5836(E)', 2025, 'so-only', '2025-12-17', 'S.O. 5836(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  ('agri-so-3665-2026', 'Agriculture', 'S.O. 3665(E)', 2026, 'so-only', '2026-07-06', 'S.O. 3665(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  ('agri-so-1589-2005', 'Agriculture', 'S.O. 1589(E)', 2005, 'so-only', '2005-11-11', 'S.O. 1589(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-2963-2025', 'Agriculture', 'S.O. 2963(E)', 2025, 'so-only', '2025-06-30', 'S.O. 2963(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee'),
  ('agri-so-2944-2026', 'Agriculture', 'S.O. 2944(E)', 2026, 'so-only', '2026-05-22', 'S.O. 2944(E)', 'agriculture-and-farmers-welfare', 'protection-plant-varieties-act-2001', 'agriculture-plant-varieties-committee');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('agri-so-3665-2026', 'agri-so-5836-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('agri-so-2944-2026', 'agri-so-2963-2025', 'amends', 'research-agent-quoted', '2026-09-04');

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('agriculture-and-farmers-welfare', 'Ministry of Agriculture and Farmers Welfare', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('fertiliser-control-order-1985', 'Fertiliser (Inorganic, Organic or Mixed) (Control) Order, 1985', 1985),
  ('protection-plant-varieties-act-2001', 'Protection of Plant Varieties and Farmers'' Rights Act, 2001', 2001);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('agriculture-fertiliser-amendments', 'Fertiliser (Control) Order notification amendments', 'active'),
  ('agriculture-plant-varieties-committee', 'Protection of Plant Varieties Act committee notification and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('agri-so-1018-2026', 'Agriculture', 'S.O. 1018(E)', 2026, 'so-only', '2026-02-25', 'S.O. 1018(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  ('agri-so-3666-2026', 'Agriculture', 'S.O. 3666(E)', 2026, 'so-only', '2026-07-06', 'S.O. 3666(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('agri-so-3666-2026', 'agri-so-1018-2026', 'amends', 'research-agent-quoted', '2026-09-03');
