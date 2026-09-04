-- Ministry of Defence pilot. Three real pairs researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04. This
-- ministry is the first confirmed to cite exclusively via S.R.O.
-- ("Statutory Rules and Orders") rather than G.S.R./S.O. — support added
-- to extract/citation_patterns.py this batch (see tests/test_sro_citations.py).
--
-- Pair 1 — Corrigendum No. 11(E), dated 15 Aug 2026 (Gazette ID
-- CG-DL-E-02092026-275931), deletes an entry across FIVE separate Army
-- honorary-commission notifications (No. 01(E)/2023, No. 09(E)/2023,
-- No. 05(E)/2025, No. 02(E)/2026, No. 04/2026) — DEFERRED, not modeled.
-- Two independent reasons: (1) these Army honorary-rank notifications are
-- cited by a bare "No. NN(E)" form (no G.S.R./S.O./S.R.O. prefix at all,
-- same unsupported-shape class as Textiles' Hank Yarn "Notification No.
-- 2/TDRO/8/2003" lead and Commerce/DGFT's bare citations — the schema and
-- extractors represent G.S.R./S.O./S.R.O. only, and a fourth citation form
-- built for one occurrence would be exactly the un-evidenced design this
-- project has deliberately avoided elsewhere); (2) it is also a genuine
-- one-to-many corrigendum (one amendment touching five unrelated prior
-- notifications), a shape no template here has been built against. Real,
-- not fabricated — simply out of what this schema/extractor set covers
-- today.
--
-- Pairs 2/3 below ARE modeled: pair 2 via the corrigendum-substitution
-- template (extract/defence_patterns.py), pair 3 via the note-chain
-- template (both already tested against this exact real text — see
-- tests/test_defence_patterns.py and tests/test_note_chain.py's
-- test_sro_series_note_chain).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('defence', 'Ministry of Defence', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('cantonments-act-2006', 'Cantonments Act, 2006', 2006),
  ('navy-act-1957', 'Navy Act, 1957', 1957);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('defence-cantonment-board-member', 'Cantonment Board member substitution', 'active'),
  ('defence-navy-act-service-branch', 'Navy Act service-branch listing amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 2: S.R.O. 18(E) amends S.R.O. 19(E)
  ('defence-sro-19-2025', 'Defence', 'S.R.O. 19(E)', 2025, 'so-only', '2025-11-12', 'S.R.O. 19(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member'),
  ('defence-sro-18-2026', 'Defence', 'S.R.O. 18(E)', 2026, 'so-only', '2026-07-15', 'S.R.O. 18(E)', 'defence', 'cantonments-act-2006', 'defence-cantonment-board-member'),
  -- Pair 3: S.R.O. 22(E) amends S.R.O. 9(E) (via Note clause)
  ('defence-sro-9-2022',  'Defence', 'S.R.O. 9(E)',  2022, 'so-only', '2022-06-23', 'S.R.O. 9(E)',  'defence', 'navy-act-1957', 'defence-navy-act-service-branch'),
  ('defence-sro-22-2025', 'Defence', 'S.R.O. 22(E)', 2025, 'so-only', '2025-10-02', 'S.R.O. 22(E)', 'defence', 'navy-act-1957', 'defence-navy-act-service-branch');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('defence-sro-18-2026', 'defence-sro-19-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('defence-sro-22-2025', 'defence-sro-9-2022',  'amends', 'research-agent-quoted', '2026-09-04');
