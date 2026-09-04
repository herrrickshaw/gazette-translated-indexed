-- Ministry of Steel pilot.
--
-- Modeled: S.O. 2685(E) corrects an address in S.O. 1868(E), a Collection of
-- Statistics Act notification (verified_by 'research-agent-quoted').
--
-- Real leads found but NOT modeled here (amendments to a principal Order
-- citing it in a trailing "Note" — the consolidated-instrument shape
-- deferred for MCA, Agriculture, Petroleum, Coal, Education):
--   - S.O. 5134(E) (20 Nov 2025) and S.O. 3300(E) (20 Jun 2026) both amend
--     the Steel and Steel Products (Quality Control) Order, 2024
--     (S.O. 3716(E), 29 Aug 2024) — two sequential amendments to one
--     principal order.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('steel', 'Ministry of Steel', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('collection-of-statistics-act-2008', 'Collection of Statistics Act, 2008', 2008);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('steel-corrections', 'Ministry of Steel notification corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('steel-so-1868-2025', 'Steel', 'S.O. 1868(E)', 2025, 'so-only', '2025-04-25', 'S.O. 1868(E)', 'steel', 'collection-of-statistics-act-2008', 'steel-corrections'),
  ('steel-so-2685-2025', 'Steel', 'S.O. 2685(E)', 2025, 'so-only', '2025-06-16', 'S.O. 2685(E)', 'steel', 'collection-of-statistics-act-2008', 'steel-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('steel-so-2685-2025', 'steel-so-1868-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04');
