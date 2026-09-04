-- Ministry of Culture pilot — first one-to-many example modeled from a
-- single source clause.
--
-- Modeled: S.O. 441(E) (13 Jan 2026) "in partial modification of" THREE
-- earlier Registering-Officer notifications under the Antiquities and Art
-- Treasures Act, 1972 — S.O. 3514(E), S.O. 2985(E), S.O. 2637(E). Three
-- cross_reference rows from one source.
--
-- Provenance caveat, recorded rather than smoothed: the research agent could
-- NOT locate the three targets' own gazette pages; their numbers and dates
-- are corroborated only as quoted inside S.O. 441(E)'s primary text. That's
-- the same standing as CBIC's 31 predecessors (named in the citing
-- document's own preamble) — but with one read of one document, not a
-- second source. Tier: 'research-agent-quoted'.
--
-- Real leads found but NOT modeled here:
--   - No. 108(Addendum) (9 Jul 2026) partially modifies Notification No. 108,
--     F.No. 21/11/2025-C&M (11 Apr 2026) — cites the original by a bare
--     "No. 108" + File Number, not a G.S.R./S.O. citation the extractor
--     recognizes (same shape deferred for Commerce/DGFT).
--   - G.S.R. 448(E) (4 Jul 2025) amends the National Monuments Authority
--     rules, G.S.R. 635(E) (23 Aug 2011), via G.S.R. 1034(E) (2018) — a
--     trailing-"Note" amendment history, the deferred consolidated-
--     instrument shape.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('culture', 'Ministry of Culture', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('antiquities-art-treasures-act-1972-s15', 'Antiquities and Art Treasures Act, 1972 — section 15 (Registering Officers)', 1972);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('culture-registering-officers', 'Antiquities Act Registering Officer appointments and their modifications', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('culture-so-3514-2022', 'Culture', 'S.O. 3514(E)', 2022, 'so-only', '2022-07-29', 'S.O. 3514(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-2985-2023', 'Culture', 'S.O. 2985(E)', 2023, 'so-only', '2023-07-06', 'S.O. 2985(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-2637-2024', 'Culture', 'S.O. 2637(E)', 2024, 'so-only', '2024-07-05', 'S.O. 2637(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-441-2026',  'Culture', 'S.O. 441(E)',  2026, 'so-only', '2026-01-13', 'S.O. 441(E)',  'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('culture-so-441-2026', 'culture-so-3514-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-441-2026', 'culture-so-2985-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-441-2026', 'culture-so-2637-2024', 'amends', 'research-agent-quoted', '2026-09-04');
