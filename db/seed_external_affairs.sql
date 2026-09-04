-- Ministry of External Affairs. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3 pairs).
--
-- 4 new subject threads found. Three (Threads 2-4) share a recurring MEA
-- drafting convention not seen from any other ministry this session: a
-- trailing "Note.— The [Order/Rules] ... was published ... vide number
-- X ... and last amended vide notification number Y" clause naming only
-- the ORIGIN and the IMMEDIATELY-PRECEDING amendment (never the full
-- history), rather than an enumerated full list. This still fits the
-- existing find_note_chain template unchanged (item[i] amends item[i-1],
-- the citing document amends the last item) — each successive real
-- document's own Note supplies one more link, assembled here across
-- several documents into one linear chain rather than read from a single
-- document's full enumeration. extract/external_affairs_patterns.py
-- should gain this as a fourth combined pattern in a future extractor
-- pass; not added this batch since seed-only modeling was sufter for
-- three real Orders under different subject areas (terrorism sanctions,
-- Sudan sanctions, Passports Rules fee schedule) with only 2-3 own-notes
-- opened per thread rather than every node independently opened.
--
-- Real leads NOT modeled: four further UNSC-sanctions Orders (DRC, Libya,
-- Haiti, Iraq) that almost certainly carry the identical note-chain
-- pattern but whose own Full Text was not independently opened this pass
-- (flagged, not fabricated); an Emigration Act, 1983 exemption notification
-- confirmed to carry no cross-reference of any kind.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('external-affairs', 'Ministry of External Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('territorial-waters-baseline-notification', 'Territorial waters baseline-coordinates notification', NULL),
  ('maritime-designated-areas-2009', 'Maritime zones designated-areas notification, 2009', 2009),
  ('passports-act-1967-prosecution-sanction', 'Passports Act, 1967 — prosecution-sanction authority notification', 1967),
  ('passports-act-1967-s19-yemen-travel', 'Passports Act, 1967 — s.19 Yemen travel-conditions notification', 1967),
  ('terrorism-implementation-order-2007', 'Prevention and Suppression of Terrorism (Implementation of Security Council Resolutions) Order, 2007', 2007),
  ('sudan-unsc-implementation-order-2016', 'Implementation of the United Nations Security Council Resolutions on Sudan Order, 2016', 2016),
  ('passports-rules-1980-fee-schedule', 'Passports Rules, 1980 — Schedule IV fee schedule (s.24 rule-making power)', 1980);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('baseline-coordinates-corrigendum', 'Territorial waters baseline-coordinates corrigendum', 'active'),
  ('maritime-designated-areas-amendment', 'Maritime designated-areas notification and its amendment', 'active'),
  ('passports-act-prosecution-sanction', 'Passports Act prosecution-sanction authority', 'superseded'),
  ('yemen-travel-conditions-rescission', 'Yemen travel-conditions notification rescission', 'superseded'),
  ('terrorism-order-2007-amendments', 'Terrorism Implementation Order, 2007 and its recent amendments', 'active'),
  ('sudan-order-2016-amendments', 'Sudan UNSC Implementation Order, 2016 and its recent amendments', 'active'),
  ('passports-rules-fee-schedule-amendments', 'Passports Rules, 1980 fee-schedule amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mea-gsr-216-2025', 'MEA', 'G.S.R. 216(E)', 2025, 'so-only', '2025-04-02', 'G.S.R. 216(E)', 'external-affairs', 'territorial-waters-baseline-notification', 'baseline-coordinates-corrigendum'),
  ('mea-gsr-253-2025', 'MEA', 'G.S.R. 253(E)', 2025, 'so-only', '2025-04-22', 'G.S.R. 253(E)', 'external-affairs', 'territorial-waters-baseline-notification', 'baseline-coordinates-corrigendum'),
  ('mea-so-135-2009',  'MEA', 'S.O. 135(E)',  2009, 'so-only', '2009-01-13', 'S.O. 135(E)',  'external-affairs', 'maritime-designated-areas-2009', 'maritime-designated-areas-amendment'),
  ('mea-so-2565-2025', 'MEA', 'S.O. 2565(E)', 2025, 'so-only', '2025-06-12', 'S.O. 2565(E)', 'external-affairs', 'maritime-designated-areas-2009', 'maritime-designated-areas-amendment'),
  ('mea-gsr-662-1979', 'MEA', 'G.S.R. 662(E)', 1979, 'so-only', '1979-12-01', 'G.S.R. 662(E)', 'external-affairs', 'passports-act-1967-prosecution-sanction', 'passports-act-prosecution-sanction'),
  ('mea-gsr-370-2010', 'MEA', 'G.S.R. 370(E)', 2010, 'so-only', '2010-02-09', 'G.S.R. 370(E)', 'external-affairs', 'passports-act-1967-prosecution-sanction', 'passports-act-prosecution-sanction'),
  ('mea-so-3022-2026', 'MEA', 'S.O. 3022(E)', 2026, 'so-only', '2026-05-26', 'S.O. 3022(E)', 'external-affairs', 'passports-act-1967-prosecution-sanction', 'passports-act-prosecution-sanction'),
  -- Yemen travel-conditions rescission
  ('mea-so-3223-2017', 'MEA', 'S.O. 3223(E)', 2017, 'so-only', '2017-10-03', 'S.O. 3223(E)', 'external-affairs', 'passports-act-1967-s19-yemen-travel', 'yemen-travel-conditions-rescission'),
  ('mea-so-3760-2026', 'MEA', 'S.O. 3760(E)', 2026, 'so-only', '2026-07-10', 'S.O. 3760(E)', 'external-affairs', 'passports-act-1967-s19-yemen-travel', 'yemen-travel-conditions-rescission'),
  -- Terrorism Implementation Order, 2007 (note-chain: principal + last-amended per document)
  ('mea-so-460-2007',  'MEA', 'S.O. 460(E)',  2007, 'so-only', '2007-03-28', 'S.O. 460(E)',  'external-affairs', 'terrorism-implementation-order-2007', 'terrorism-order-2007-amendments'),
  ('mea-so-5039-2025', 'MEA', 'S.O. 5039(E)', 2025, 'so-only', '2025-09-18', 'S.O. 5039(E)', 'external-affairs', 'terrorism-implementation-order-2007', 'terrorism-order-2007-amendments'),
  ('mea-so-361-2026',  'MEA', 'S.O. 361(E)',  2026, 'so-only', '2026-01-23', 'S.O. 361(E)',  'external-affairs', 'terrorism-implementation-order-2007', 'terrorism-order-2007-amendments'),
  ('mea-so-1304-2026', 'MEA', 'S.O. 1304(E)', 2026, 'so-only', '2026-03-13', 'S.O. 1304(E)', 'external-affairs', 'terrorism-implementation-order-2007', 'terrorism-order-2007-amendments'),
  ('mea-so-2449-2026', 'MEA', 'S.O. 2449(E)', 2026, 'so-only', '2026-05-14', 'S.O. 2449(E)', 'external-affairs', 'terrorism-implementation-order-2007', 'terrorism-order-2007-amendments'),
  ('mea-so-4039-2026', 'MEA', 'S.O. 4039(E)', 2026, 'so-only', '2026-07-27', 'S.O. 4039(E)', 'external-affairs', 'terrorism-implementation-order-2007', 'terrorism-order-2007-amendments'),
  -- Sudan UNSC Implementation Order, 2016 (same note-chain shape)
  ('mea-so-2875-2016', 'MEA', 'S.O. 2875(E)', 2016, 'so-only', '2016-09-06', 'S.O. 2875(E)', 'external-affairs', 'sudan-unsc-implementation-order-2016', 'sudan-order-2016-amendments'),
  ('mea-so-592-2025',  'MEA', 'S.O. 592(E)',  2025, 'so-only', '2025-01-31', 'S.O. 592(E)',  'external-affairs', 'sudan-unsc-implementation-order-2016', 'sudan-order-2016-amendments'),
  ('mea-so-1905-2026', 'MEA', 'S.O. 1905(E)', 2026, 'so-only', '2026-04-15', 'S.O. 1905(E)', 'external-affairs', 'sudan-unsc-implementation-order-2016', 'sudan-order-2016-amendments'),
  ('mea-so-2690-2026', 'MEA', 'S.O. 2690(E)', 2026, 'so-only', '2026-05-29', 'S.O. 2690(E)', 'external-affairs', 'sudan-unsc-implementation-order-2016', 'sudan-order-2016-amendments'),
  -- Passports Rules, 1980 fee schedule (same note-chain shape)
  ('mea-gsr-691-1980', 'MEA', 'G.S.R. 691(E)', 1980, 'so-only', '1980-12-11', 'G.S.R. 691(E)', 'external-affairs', 'passports-rules-1980-fee-schedule', 'passports-rules-fee-schedule-amendments'),
  ('mea-gsr-675-2023', 'MEA', 'G.S.R. 675(E)', 2023, 'so-only', '2023-09-15', 'G.S.R. 675(E)', 'external-affairs', 'passports-rules-1980-fee-schedule', 'passports-rules-fee-schedule-amendments'),
  ('mea-gsr-156-2025', 'MEA', 'G.S.R. 156(E)', 2025, 'so-only', '2025-02-28', 'G.S.R. 156(E)', 'external-affairs', 'passports-rules-1980-fee-schedule', 'passports-rules-fee-schedule-amendments'),
  ('mea-gsr-516-2026', 'MEA', 'G.S.R. 516(E)', 2026, 'so-only', '2026-06-25', 'G.S.R. 516(E)', 'external-affairs', 'passports-rules-1980-fee-schedule', 'passports-rules-fee-schedule-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mea-gsr-253-2025', 'mea-gsr-216-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-2565-2025', 'mea-so-135-2009',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-3022-2026', 'mea-gsr-662-1979', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-3022-2026', 'mea-gsr-370-2010', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-3760-2026', 'mea-so-3223-2017', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  -- Terrorism Order, 2007 chain
  ('mea-so-5039-2025', 'mea-so-460-2007',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-361-2026',  'mea-so-5039-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-1304-2026', 'mea-so-361-2026',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-2449-2026', 'mea-so-1304-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-4039-2026', 'mea-so-2449-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Sudan Order, 2016 chain
  ('mea-so-592-2025',  'mea-so-2875-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-1905-2026', 'mea-so-592-2025',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-so-2690-2026', 'mea-so-1905-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Passports Rules, 1980 fee schedule chain
  ('mea-gsr-675-2023', 'mea-gsr-691-1980', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-gsr-156-2025', 'mea-gsr-675-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mea-gsr-516-2026', 'mea-gsr-156-2025', 'amends', 'research-agent-quoted', '2026-09-04');
