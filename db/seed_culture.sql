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
-- Also modeled (2026-09-04, extract.common_templates.find_note_chain —
-- one of the two real examples the template was tested against): the NMA
-- rules chain, G.S.R. 635(E) [principal, 2011] -> G.S.R. 1034(E) [2018] ->
-- G.S.R. 448(E) [current, 2025].
--
-- Real lead found but NOT modeled — still un-modelable, not just deferred:
--   - No. 108(Addendum) (9 Jul 2026) partially modifies Notification No. 108,
--     F.No. 21/11/2025-C&M (11 Apr 2026) — cites the original by a bare
--     "No. 108" + File Number, not a G.S.R./S.O. citation the extractor
--     recognizes at all (same shape deferred for Commerce/DGFT).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('culture', 'Ministry of Culture', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('antiquities-art-treasures-act-1972-s15', 'Antiquities and Art Treasures Act, 1972 — section 15 (Registering Officers)', 1972),
  ('nma-conditions-of-service-rules-2011', 'National Monuments Authority (Conditions of Service...) Rules, 2011', 2011);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('culture-registering-officers', 'Antiquities Act Registering Officer appointments and their modifications', 'active'),
  ('culture-nma-conditions-of-service', 'NMA Conditions of Service Rules and their amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('culture-so-3514-2022', 'Culture', 'S.O. 3514(E)', 2022, 'so-only', '2022-07-29', 'S.O. 3514(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-2985-2023', 'Culture', 'S.O. 2985(E)', 2023, 'so-only', '2023-07-06', 'S.O. 2985(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-2637-2024', 'Culture', 'S.O. 2637(E)', 2024, 'so-only', '2024-07-05', 'S.O. 2637(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-441-2026',  'Culture', 'S.O. 441(E)',  2026, 'so-only', '2026-01-13', 'S.O. 441(E)',  'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-gsr-635-2011', 'Culture', 'G.S.R. 635(E)', 2011, 'so-only', '2011-08-23', 'G.S.R. 635(E)', 'culture', 'nma-conditions-of-service-rules-2011', 'culture-nma-conditions-of-service'),
  ('culture-gsr-1034-2018', 'Culture', 'G.S.R. 1034(E)', 2018, 'so-only', '2018-10-11', 'G.S.R. 1034(E)', 'culture', 'nma-conditions-of-service-rules-2011', 'culture-nma-conditions-of-service'),
  ('culture-gsr-448-2025', 'Culture', 'G.S.R. 448(E)', 2025, 'so-only', '2025-07-04', 'G.S.R. 448(E)', 'culture', 'nma-conditions-of-service-rules-2011', 'culture-nma-conditions-of-service');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('culture-so-441-2026', 'culture-so-3514-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-441-2026', 'culture-so-2985-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-441-2026', 'culture-so-2637-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-gsr-1034-2018', 'culture-gsr-635-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-gsr-448-2025', 'culture-gsr-1034-2018', 'amends', 'research-agent-quoted', '2026-09-04');
