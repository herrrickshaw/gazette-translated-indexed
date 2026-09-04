-- Ministry of Power. Deepened 2026-09-04 (pilot for the depth-pass project
-- covering every already-modeled ministry — see docs/DEPTH_PASS_PLAN.md)
-- beyond the original bounded 3-pair pass.
--
-- Two real gaps from the first pass were closed this round:
--   - G.S.R. 488(E) [2021-07-13], the JERC chain's missing intermediate
--     amendment, is now dated and inserted between G.S.R. 211(E) and
--     G.S.R. 259(E).
--   - S.O. 2979(E)/S.O. 1033(E), the noted-but-unverified parallel
--     companion to the S.O. 2978(E)/S.O. 1034(E) TFL repeal, is now fully
--     verified with its own primary-text quote.
--
-- The TFL chain itself also turned out to be longer than first modeled:
-- S.O. 1034(E) was amended twice (S.O. 1930(E), S.O. 2789(E)) before being
-- repealed by S.O. 2978(E) — both edges now recorded alongside the
-- original direct repeal edge, which the repeal notification's own text
-- still literally states.
--
-- Eight further real pairs/chains were found across six subject areas not
-- touched in the first pass: two more Standards and Labelling Programme
-- chains (LED lamps, induction hobs), a transmission-scheme modify/
-- de-notify pair, Bhakra Beas Management Board Rules, Electricity Rules
-- 2005 (captive generation), and Energy Conservation Rules 2012 (PAT
-- scheme). One stray Note fragment (an out-of-context "S.O. 1033(E)"
-- reference inside the LED-lamp text) was flagged by the research agent as
-- a likely copy-paste drafting artifact in the source gazette itself, not
-- a real cross-reference, and is correctly NOT modeled here.
--
-- Two further real leads cite their target only by a bare Gazette ID with
-- no G.S.R./S.O./S.R.O. number at all (a transmission-authorization order
-- citing "Gazette Notification No. CG-DL-E-27012026-269591"; a CEA
-- transmission-scheme de-notification citing only a File No. + date) —
-- deliberately not modeled, the same class of gap as every other
-- unnumbered-citation lead in this project.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('power', 'Ministry of Power', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('it-act-2000-s70', 'Information Technology Act, 2000 — section 70 (protected systems)', 2000),
  ('standards-labelling-tfl-programme', 'Standards and Labelling Programme for Tubular Fluorescent Lamps', NULL),
  ('electricity-act-2003-s89', 'Electricity Act, 2003 — section 89 (JERC conditions of service)', 2003),
  ('standards-labelling-led-programme', 'Standards and Labelling Programme for self-ballasted LED lamps', NULL),
  ('standards-labelling-induction-hob-programme', 'Standards and Labelling Programme for induction hobs', NULL),
  ('transmission-scheme-lakadia-evacuation', 'Common Transmission System for evacuation of power from Lakadia', NULL),
  ('transmission-scheme-kandla-green-hydrogen', 'Transmission System for Green Hydrogen/Ammonia Manufacturing, Kandla', NULL),
  ('bbmb-rules-1974', 'Bhakra Beas Management Board Rules, 1974 (Punjab Reorganisation Act, 1966, s.97)', 1974),
  ('electricity-rules-2005', 'Electricity Rules, 2005 (captive generating plant)', 2005),
  ('energy-conservation-rules-2012-pat', 'Energy Conservation (Designated Consumers) Rules, 2012 — PAT scheme', 2012);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('power-protected-systems', 'Ministry of Power protected-system notifications and amendments', 'active'),
  ('power-tfl-standards', 'Tubular Fluorescent Lamp standards programme: amendments then repeal', 'superseded'),
  ('power-tfl-standards-companion', 'TFL standards programme, parallel tariff item: repeal', 'superseded'),
  ('power-jerc-rules', 'JERC (Union Territories) conditions-of-service rules and amendments', 'active'),
  ('power-led-standards', 'Self-ballasted LED lamp standards: amendment chain plus a separate supersession', 'active'),
  ('power-induction-hob-standards', 'Induction hob standards applicability-date amendment', 'active'),
  ('power-transmission-lakadia', 'Lakadia power-evacuation transmission scheme modification', 'active'),
  ('power-transmission-kandla', 'Kandla green-hydrogen transmission scheme de-notification', 'superseded'),
  ('power-bbmb-rules', 'Bhakra Beas Management Board Rules and its amendments', 'active'),
  ('power-electricity-rules-2005', 'Electricity Rules, 2005 (captive generation) and its amendments', 'active'),
  ('power-pat-scheme-rules', 'PAT scheme oil-equivalent-value rules and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Protected systems (unchanged from first pass)
  ('power-so-5852-2022', 'Power', 'S.O. 5852(E)', 2022, 'so-only', '2022-12-13', 'S.O. 5852(E)', 'power', 'it-act-2000-s70', 'power-protected-systems'),
  ('power-so-3520-2026', 'Power', 'S.O. 3520(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3520(E)', 'power', 'it-act-2000-s70', 'power-protected-systems'),
  -- TFL standards chain, now with the two intermediate amendments
  ('power-so-1034-2018', 'Power', 'S.O. 1034(E)', 2018, 'so-only', '2018-03-09', 'S.O. 1034(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards'),
  ('power-so-1930-2020', 'Power', 'S.O. 1930(E)', 2020, 'so-only', '2020-06-09', 'S.O. 1930(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards'),
  ('power-so-2789-2023', 'Power', 'S.O. 2789(E)', 2023, 'so-only', '2023-06-27', 'S.O. 2789(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards'),
  ('power-so-2978-2026', 'Power', 'S.O. 2978(E)', 2026, 'so-only', '2026-06-10', 'S.O. 2978(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards'),
  -- TFL companion (parallel tariff item), now verified
  ('power-so-1033-2018', 'Power', 'S.O. 1033(E)', 2018, 'so-only', '2018-03-09', 'S.O. 1033(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards-companion'),
  ('power-so-2979-2026', 'Power', 'S.O. 2979(E)', 2026, 'so-only', '2026-06-10', 'S.O. 2979(E)', 'power', 'standards-labelling-tfl-programme', 'power-tfl-standards-companion'),
  -- JERC rules chain, now with the intermediate amendment
  ('power-gsr-211-2007', 'Power', 'G.S.R. 211(E)', 2007, 'so-only', '2007-03-19', 'G.S.R. 211(E)', 'power', 'electricity-act-2003-s89', 'power-jerc-rules'),
  ('power-gsr-488-2021', 'Power', 'G.S.R. 488(E)', 2021, 'so-only', '2021-07-13', 'G.S.R. 488(E)', 'power', 'electricity-act-2003-s89', 'power-jerc-rules'),
  ('power-gsr-259-2026', 'Power', 'G.S.R. 259(E)', 2026, 'so-only', '2026-04-08', 'G.S.R. 259(E)', 'power', 'electricity-act-2003-s89', 'power-jerc-rules'),
  -- LED lamp standards: six-node amendment chain
  ('power-so-4097-2017', 'Power', 'S.O. 4097(E)', 2017, 'so-only', '2017-12-27', 'S.O. 4097(E)', 'power', 'standards-labelling-led-programme', 'power-led-standards'),
  ('power-so-938-2019',  'Power', 'S.O. 938(E)',  2019, 'so-only', '2019-02-21', 'S.O. 938(E)',  'power', 'standards-labelling-led-programme', 'power-led-standards'),
  ('power-so-3631-2019', 'Power', 'S.O. 3631(E)', 2019, 'so-only', '2019-10-09', 'S.O. 3631(E)', 'power', 'standards-labelling-led-programme', 'power-led-standards'),
  ('power-so-2178-2020', 'Power', 'S.O. 2178(E)', 2020, 'so-only', '2020-07-01', 'S.O. 2178(E)', 'power', 'standards-labelling-led-programme', 'power-led-standards'),
  ('power-so-2793-2023', 'Power', 'S.O. 2793(E)', 2023, 'so-only', '2023-06-27', 'S.O. 2793(E)', 'power', 'standards-labelling-led-programme', 'power-led-standards'),
  ('power-so-2976-2026', 'Power', 'S.O. 2976(E)', 2026, 'so-only', '2026-06-10', 'S.O. 2976(E)', 'power', 'standards-labelling-led-programme', 'power-led-standards'),
  -- LED lamp standards: separate supersession, different subject_thread from the amendment chain above
  ('power-so-2792-2023', 'Power', 'S.O. 2792(E)', 2023, 'so-only', '2023-06-27', 'S.O. 2792(E)', 'power', 'standards-labelling-led-programme', 'power-led-standards'),
  ('power-so-2977-2026', 'Power', 'S.O. 2977(E)', 2026, 'so-only', '2026-06-10', 'S.O. 2977(E)', 'power', 'standards-labelling-led-programme', 'power-led-standards'),
  -- Induction hob standards
  ('power-so-5665-2025', 'Power', 'S.O. 5665(E)', 2025, 'so-only', '2025-12-08', 'S.O. 5665(E)', 'power', 'standards-labelling-induction-hob-programme', 'power-induction-hob-standards'),
  ('power-so-1738-2026', 'Power', 'S.O. 1738(E)', 2026, 'so-only', '2026-04-04', 'S.O. 1738(E)', 'power', 'standards-labelling-induction-hob-programme', 'power-induction-hob-standards'),
  -- Transmission scheme modify/de-notify
  ('power-so-725-2026',  'Power', 'S.O. 725(E)',  2026, 'so-only', '2026-02-12', 'S.O. 725(E)',  'power', 'transmission-scheme-lakadia-evacuation', 'power-transmission-lakadia'),
  ('power-so-4639-2026', 'Power', 'S.O. 4639(E)', 2026, 'so-only', '2026-08-21', 'S.O. 4639(E)', 'power', 'transmission-scheme-lakadia-evacuation', 'power-transmission-lakadia'),
  ('power-so-3706-2024', 'Power', 'S.O. 3706(E)', 2024, 'so-only', '2024-08-30', 'S.O. 3706(E)', 'power', 'transmission-scheme-kandla-green-hydrogen', 'power-transmission-kandla'),
  ('power-so-4640-2026', 'Power', 'S.O. 4640(E)', 2026, 'so-only', '2026-08-21', 'S.O. 4640(E)', 'power', 'transmission-scheme-kandla-green-hydrogen', 'power-transmission-kandla'),
  -- BBMB Rules chain, principal in bare pre-1974 form
  ('power-gsr-1330-1974', 'Power', 'G.S.R. 1330',  1974, 'bare',    '1974-12-11', 'G.S.R. 1330',  'power', 'bbmb-rules-1974', 'power-bbmb-rules'),
  ('power-gsr-94-2023',   'Power', 'G.S.R. 94(E)', 2023, 'so-only', '2023-02-13', 'G.S.R. 94(E)', 'power', 'bbmb-rules-1974', 'power-bbmb-rules'),
  ('power-gsr-278-2026',  'Power', 'G.S.R. 278(E)', 2026, 'so-only', '2026-04-13', 'G.S.R. 278(E)', 'power', 'bbmb-rules-1974', 'power-bbmb-rules'),
  -- Electricity Rules 2005 chain
  ('power-gsr-379-2005', 'Power', 'G.S.R. 379(E)', 2005, 'so-only', '2005-06-08', 'G.S.R. 379(E)', 'power', 'electricity-rules-2005', 'power-electricity-rules-2005'),
  ('power-gsr-688-2025', 'Power', 'G.S.R. 688(E)', 2025, 'so-only', '2025-09-19', 'G.S.R. 688(E)', 'power', 'electricity-rules-2005', 'power-electricity-rules-2005'),
  ('power-gsr-186-2026', 'Power', 'G.S.R. 186(E)', 2026, 'so-only', '2026-03-14', 'G.S.R. 186(E)', 'power', 'electricity-rules-2005', 'power-electricity-rules-2005'),
  -- PAT scheme rules chain
  ('power-gsr-269-2012', 'Power', 'G.S.R. 269(E)', 2012, 'so-only', '2012-03-30', 'G.S.R. 269(E)', 'power', 'energy-conservation-rules-2012-pat', 'power-pat-scheme-rules'),
  ('power-gsr-916-2023', 'Power', 'G.S.R. 916(E)', 2023, 'so-only', '2023-12-26', 'G.S.R. 916(E)', 'power', 'energy-conservation-rules-2012-pat', 'power-pat-scheme-rules'),
  ('power-gsr-157-2026', 'Power', 'G.S.R. 157(E)', 2026, 'so-only', '2026-03-06', 'G.S.R. 157(E)', 'power', 'energy-conservation-rules-2012-pat', 'power-pat-scheme-rules');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('power-so-3520-2026', 'power-so-5852-2022', 'amends', 'research-agent-quoted', '2026-09-03'),
  -- TFL chain: two amendments then a repeal, plus the repeal notification's own direct citation of the principal
  ('power-so-1930-2020', 'power-so-1034-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-2789-2023', 'power-so-1930-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-2978-2026', 'power-so-1034-2018', 'repeals', 'research-agent-quoted', '2026-09-04'),
  ('power-so-2979-2026', 'power-so-1033-2018', 'repeals', 'research-agent-quoted', '2026-09-04'),
  ('power-gsr-488-2021', 'power-gsr-211-2007', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-gsr-259-2026', 'power-gsr-488-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- LED lamp chain
  ('power-so-938-2019',  'power-so-4097-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-3631-2019', 'power-so-938-2019',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-2178-2020', 'power-so-3631-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-2793-2023', 'power-so-2178-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-2976-2026', 'power-so-2793-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-2977-2026', 'power-so-2792-2023', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- Induction hob
  ('power-so-1738-2026', 'power-so-5665-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Transmission schemes
  ('power-so-4639-2026', 'power-so-725-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-so-4640-2026', 'power-so-3706-2024', 'repeals', 'research-agent-quoted', '2026-09-04'),
  -- BBMB Rules
  ('power-gsr-94-2023',  'power-gsr-1330-1974', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-gsr-278-2026', 'power-gsr-94-2023',   'amends', 'research-agent-quoted', '2026-09-04'),
  -- Electricity Rules 2005
  ('power-gsr-688-2025', 'power-gsr-379-2005', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-gsr-186-2026', 'power-gsr-688-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- PAT scheme rules
  ('power-gsr-916-2023', 'power-gsr-269-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('power-gsr-157-2026', 'power-gsr-916-2023', 'amends', 'research-agent-quoted', '2026-09-04');
