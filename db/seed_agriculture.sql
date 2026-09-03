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
-- Real leads found but NOT modeled here (a genuine long consolidated-
-- instrument chain, not a single pair):
--   - S.O. 2944(E) (22 May 2026) is the ELEVENTH amendment to S.O. 1589(E)
--     (11 Nov 2005, Protection of Plant Varieties and Farmers' Rights Act
--     committee), with the full 11-notification amendment history quoted
--     in its own "Note" — structurally closer to CBIC's 45/2025-style
--     consolidation than a corrigendum pair, and worth its own pass.
--   - S.O. 3665(E) (6 Jul 2026) amends S.O. 5836(E) (17 Dec 2025) — a second
--     clean Fertiliser (Control) Order pair, not modeled this round purely
--     for time, not because it doesn't fit.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('agriculture-and-farmers-welfare', 'Ministry of Agriculture and Farmers Welfare', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('fertiliser-control-order-1985', 'Fertiliser (Inorganic, Organic or Mixed) (Control) Order, 1985', 1985);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('agriculture-fertiliser-amendments', 'Fertiliser (Control) Order notification amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('agri-so-1018-2026', 'Agriculture', 'S.O. 1018(E)', 2026, 'so-only', '2026-02-25', 'S.O. 1018(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments'),
  ('agri-so-3666-2026', 'Agriculture', 'S.O. 3666(E)', 2026, 'so-only', '2026-07-06', 'S.O. 3666(E)', 'agriculture-and-farmers-welfare', 'fertiliser-control-order-1985', 'agriculture-fertiliser-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('agri-so-3666-2026', 'agri-so-1018-2026', 'amends', 'research-agent-quoted', '2026-09-03');
