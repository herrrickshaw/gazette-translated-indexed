-- Ministry of Culture. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass. Both known
-- chains (Registering Officers, NMA Rules) re-confirmed still current,
-- no further amendments.
--
-- Real new material found across four usable subject areas, all fitting
-- the EXISTING corrigendum-substitution template (no new extractor code
-- needed): a 7-node AMASR Act "competent authority" chain, two AMASR
-- Act s.35 "ceased to be of national importance" two-stage notice-then-
-- declaration pairs, three AMASR Act s.4(3) "declared of national
-- importance" two-stage pairs, and a National Culture Fund corrigendum
-- plus its own back-reference to the 1996 vesting order. The notice-to-
-- declaration and back-reference pairs are modeled with relation_type=
-- 'cites' rather than 'amends' — the later notification acts on or
-- references the earlier one without textually modifying it, the same
-- distinction already used for draft-to-final and foundational-reference
-- pairs elsewhere in this project.
--
-- Real leads NOT modeled: six ASI Recruitment Rules supersessions citing
-- their targets by title/year only (no G.S.R. number); a National Culture
-- Fund committee addendum and a Hindi Advisory Committee resolution, both
-- Part I notifications with no G.S.R./S.O. number at all; the third link
-- in the Nicholson Statue pair, a pre-independence 1913 protection order
-- with no modern citation form.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('culture', 'Ministry of Culture', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('antiquities-art-treasures-act-1972-s15', 'Antiquities and Art Treasures Act, 1972 — section 15 (Registering Officers)', 1972),
  ('nma-conditions-of-service-rules-2011', 'National Monuments Authority (Conditions of Service...) Rules, 2011', 2011),
  ('amasr-act-1958-competent-authority', 'Ancient Monuments and Archaeological Sites and Remains Act, 1958 — s.2(db)/20C/20D Competent Authority', 1958),
  ('amasr-act-1958-s35-kos-minar-13', 'AMASR Act, 1958 — s.35, Kos Minar No. 13, Gurugram', 1958),
  ('amasr-act-1958-s35-nicholson-statue', 'AMASR Act, 1958 — s.35, Nicholson Statue, Kashmiri Gate', 1958),
  ('amasr-act-1958-s4-moidams-charaideo', 'AMASR Act, 1958 — s.4(3), Group of Moidams, Charaideo', 1958),
  ('amasr-act-1958-s4-rakhigarhi-mound-vi', 'AMASR Act, 1958 — s.4(3), Ancient Mound No. VI, Rakhigarhi', 1958),
  ('amasr-act-1958-s4-rakhigarhi-mound-vii', 'AMASR Act, 1958 — s.4(3), Ancient Mound No. VII, Rakhigarhi', 1958),
  ('national-culture-fund-1996', 'National Culture Fund, 1996', 1996);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('culture-registering-officers', 'Antiquities Act Registering Officer appointments and their modifications', 'active'),
  ('culture-nma-conditions-of-service', 'NMA Conditions of Service Rules and their amendments', 'active'),
  ('culture-amasr-competent-authority', 'AMASR Act Competent Authority designation and its amendments', 'active'),
  ('culture-kos-minar-13-cessation', 'Kos Minar No. 13 ceased-to-be-of-importance declaration', 'active'),
  ('culture-nicholson-statue-cessation', 'Nicholson Statue ceased-to-be-of-importance declaration', 'active'),
  ('culture-moidams-charaideo-declaration', 'Group of Moidams, Charaideo national-importance declaration', 'active'),
  ('culture-rakhigarhi-mound-vi-declaration', 'Ancient Mound No. VI, Rakhigarhi national-importance declaration', 'active'),
  ('culture-rakhigarhi-mound-vii-declaration', 'Ancient Mound No. VII, Rakhigarhi national-importance declaration', 'active'),
  ('culture-ncf-corrigendum', 'National Culture Fund corrigendum and back-reference', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('culture-so-3514-2022', 'Culture', 'S.O. 3514(E)', 2022, 'so-only', '2022-07-29', 'S.O. 3514(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-2985-2023', 'Culture', 'S.O. 2985(E)', 2023, 'so-only', '2023-07-06', 'S.O. 2985(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-2637-2024', 'Culture', 'S.O. 2637(E)', 2024, 'so-only', '2024-07-05', 'S.O. 2637(E)', 'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-so-441-2026',  'Culture', 'S.O. 441(E)',  2026, 'so-only', '2026-01-13', 'S.O. 441(E)',  'culture', 'antiquities-art-treasures-act-1972-s15', 'culture-registering-officers'),
  ('culture-gsr-635-2011', 'Culture', 'G.S.R. 635(E)', 2011, 'so-only', '2011-08-23', 'G.S.R. 635(E)', 'culture', 'nma-conditions-of-service-rules-2011', 'culture-nma-conditions-of-service'),
  ('culture-gsr-1034-2018', 'Culture', 'G.S.R. 1034(E)', 2018, 'so-only', '2018-10-11', 'G.S.R. 1034(E)', 'culture', 'nma-conditions-of-service-rules-2011', 'culture-nma-conditions-of-service'),
  ('culture-gsr-448-2025', 'Culture', 'G.S.R. 448(E)', 2025, 'so-only', '2025-07-04', 'G.S.R. 448(E)', 'culture', 'nma-conditions-of-service-rules-2011', 'culture-nma-conditions-of-service'),
  -- AMASR Competent Authority chain (7 nodes)
  ('culture-so-728-2014',  'Culture', 'S.O. 728(E)',  2014, 'so-only', '2014-02-25', 'S.O. 728(E)',  'culture', 'amasr-act-1958-competent-authority', 'culture-amasr-competent-authority'),
  ('culture-so-2314-2015', 'Culture', 'S.O. 2314(E)', 2015, 'so-only', '2015-07-31', 'S.O. 2314(E)', 'culture', 'amasr-act-1958-competent-authority', 'culture-amasr-competent-authority'),
  ('culture-so-2810-2015', 'Culture', 'S.O. 2810(E)', 2015, 'so-only', '2015-10-13', 'S.O. 2810(E)', 'culture', 'amasr-act-1958-competent-authority', 'culture-amasr-competent-authority'),
  ('culture-so-3627-2019', 'Culture', 'S.O. 3627(E)', 2019, 'so-only', '2019-10-09', 'S.O. 3627(E)', 'culture', 'amasr-act-1958-competent-authority', 'culture-amasr-competent-authority'),
  ('culture-gsr-768-2020', 'Culture', 'G.S.R. 768(E)', 2020, 'so-only', '2020-12-16', 'G.S.R. 768(E)', 'culture', 'amasr-act-1958-competent-authority', 'culture-amasr-competent-authority'),
  ('culture-so-49-2023',   'Culture', 'S.O. 49(E)',   2023, 'so-only', '2023-12-29', 'S.O. 49(E)',   'culture', 'amasr-act-1958-competent-authority', 'culture-amasr-competent-authority'),
  ('culture-so-1999-2024', 'Culture', 'S.O. 1999(E)', 2024, 'so-only', '2024-03-20', 'S.O. 1999(E)', 'culture', 'amasr-act-1958-competent-authority', 'culture-amasr-competent-authority'),
  -- s.35 cessation pairs
  ('culture-so-1199-2024', 'Culture', 'S.O. 1199(E)', 2024, 'so-only', '2024-03-08', 'S.O. 1199(E)', 'culture', 'amasr-act-1958-s35-kos-minar-13', 'culture-kos-minar-13-cessation'),
  ('culture-so-2974-2025', 'Culture', 'S.O. 2974(E)', 2025, 'so-only', '2025-07-01', 'S.O. 2974(E)', 'culture', 'amasr-act-1958-s35-kos-minar-13', 'culture-kos-minar-13-cessation'),
  ('culture-so-3036-2024', 'Culture', 'S.O. 3036(E)', 2024, 'so-only', '2024-07-25', 'S.O. 3036(E)', 'culture', 'amasr-act-1958-s35-nicholson-statue', 'culture-nicholson-statue-cessation'),
  ('culture-so-5178-2024', 'Culture', 'S.O. 5178(E)', 2024, 'so-only', '2024-12-02', 'S.O. 5178(E)', 'culture', 'amasr-act-1958-s35-nicholson-statue', 'culture-nicholson-statue-cessation'),
  -- s.4(3) declaration pairs
  ('culture-so-3958-2024', 'Culture', 'S.O. 3958(E)', 2024, 'so-only', '2024-09-18', 'S.O. 3958(E)', 'culture', 'amasr-act-1958-s4-moidams-charaideo', 'culture-moidams-charaideo-declaration'),
  ('culture-so-519-2025',  'Culture', 'S.O. 519(E)',  2025, 'so-only', '2025-01-29', 'S.O. 519(E)',  'culture', 'amasr-act-1958-s4-moidams-charaideo', 'culture-moidams-charaideo-declaration'),
  ('culture-so-3103-2024', 'Culture', 'S.O. 3103(E)', 2024, 'so-only', '2024-08-02', 'S.O. 3103(E)', 'culture', 'amasr-act-1958-s4-rakhigarhi-mound-vi', 'culture-rakhigarhi-mound-vi-declaration'),
  ('culture-so-5340-2024', 'Culture', 'S.O. 5340(E)', 2024, 'so-only', '2024-12-10', 'S.O. 5340(E)', 'culture', 'amasr-act-1958-s4-rakhigarhi-mound-vi', 'culture-rakhigarhi-mound-vi-declaration'),
  ('culture-so-3104-2024', 'Culture', 'S.O. 3104(E)', 2024, 'so-only', '2024-08-02', 'S.O. 3104(E)', 'culture', 'amasr-act-1958-s4-rakhigarhi-mound-vii', 'culture-rakhigarhi-mound-vii-declaration'),
  ('culture-so-5341-2024', 'Culture', 'S.O. 5341(E)', 2024, 'so-only', '2024-12-10', 'S.O. 5341(E)', 'culture', 'amasr-act-1958-s4-rakhigarhi-mound-vii', 'culture-rakhigarhi-mound-vii-declaration'),
  -- National Culture Fund
  ('culture-so-832-1996',  'Culture', 'S.O. 832(E)',  1996, 'so-only', '1996-11-28', 'S.O. 832(E)',  'culture', 'national-culture-fund-1996', 'culture-ncf-corrigendum'),
  ('culture-so-1893-2024', 'Culture', 'S.O. 1893(E)', 2024, 'so-only', '2024-05-01', 'S.O. 1893(E)', 'culture', 'national-culture-fund-1996', 'culture-ncf-corrigendum'),
  ('culture-so-2359-2024', 'Culture', 'S.O. 2359(E)', 2024, 'so-only', '2024-06-18', 'S.O. 2359(E)', 'culture', 'national-culture-fund-1996', 'culture-ncf-corrigendum');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('culture-so-441-2026', 'culture-so-3514-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-441-2026', 'culture-so-2985-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-441-2026', 'culture-so-2637-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-gsr-1034-2018', 'culture-gsr-635-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-gsr-448-2025', 'culture-gsr-1034-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- AMASR Competent Authority chain
  ('culture-so-2314-2015', 'culture-so-728-2014',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-2810-2015', 'culture-so-2314-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-3627-2019', 'culture-so-2810-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-gsr-768-2020', 'culture-so-3627-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-49-2023',   'culture-gsr-768-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-1999-2024', 'culture-so-49-2023',   'amends', 'research-agent-quoted', '2026-09-04'),
  -- s.35 cessation (notice -> final)
  ('culture-so-2974-2025', 'culture-so-1199-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-5178-2024', 'culture-so-3036-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- s.4(3) declaration (notice -> final)
  ('culture-so-519-2025',  'culture-so-3958-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-5340-2024', 'culture-so-3103-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-5341-2024', 'culture-so-3104-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- National Culture Fund
  ('culture-so-1893-2024', 'culture-so-832-1996',  'cites', 'research-agent-quoted', '2026-09-04'),
  ('culture-so-2359-2024', 'culture-so-1893-2024', 'corrigendum', 'research-agent-quoted', '2026-09-04');
