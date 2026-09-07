-- Ministry of External Affairs. First deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3 pairs),
-- reaching 23 notifications / 16 cross-references across 7 subject threads.
-- Second depth-pass return trip 2026-09-06/07: found and verified 4 further
-- real note-chain threads this project had explicitly flagged but not yet
-- opened (DRC, Libya, Haiti, Iraq UNSC-sanctions Orders), plus a real gap
-- closure inserting a missing intermediate amendment into the existing
-- baseline-coordinates thread. 14 new notifications / 10 new
-- cross-references added this round (23 -> 37 notifications, 16 -> 26
-- cross-references).
--
-- Three threads from the first pass (Threads 2-4 in that pass's own words)
-- share a recurring MEA drafting convention: a trailing "Note.— The
-- [Order/Rules] ... was published ... vide number X ... and last amended
-- vide notification number Y" clause naming only the ORIGIN and the
-- IMMEDIATELY-PRECEDING amendment (never the full history). This still fits
-- the existing find_note_chain template unchanged (item[i] amends
-- item[i-1], the citing document amends the last item). This return trip
-- confirms the same convention independently across 4 MORE UNSC-sanctions
-- Order families (Democratic Republic of Congo, Libya, Haiti, Iraq) — the
-- exact 4 "further UNSC-sanctions Orders ... almost certainly carry the
-- identical note-chain pattern" the first pass flagged but deliberately did
-- not open. All 4 Full Texts were independently opened and quoted this
-- round; extract/external_affairs_patterns.py now wires up
-- find_note_chain (extract.common_templates) as its 4th combined pattern,
-- exactly as this file's own prior header predicted it eventually would.
--
-- New threads this round (each independently confirmed via its own
-- document's trailing Note clause):
--   - Implementation of the UN Security Council Resolutions on Democratic
--     Republic of Congo Order, 2016 (S.O. 2874(E), 2016-09-05) — last
--     amended vide S.O. 1894(E) (2024-05-03) before S.O. 1443(E)
--     (2026-03-19, this round's amendment) further amended it.
--   - Implementation of the UN Security Council Resolutions on Libya Order,
--     2016 (S.O. 2158(E), 2016-06-20) — last amended vide S.O. 3052(E)
--     (2024-07-26) before S.O. 1305(E) (2026-03-12) further amended it.
--   - Implementation of the UN Security Council Resolutions on Haiti order,
--     2024 (S.O. 445(E), 2024-02-02) — last amended vide S.O. 2830(E)
--     (2025-06-24) before S.O. 1001(E) (2026-02-24) further amended it.
--   - Implementation of the UN Security Council Resolutions on Iraq Order,
--     2016 (S.O. 2272(E), 2016-06-30) — last amended vide S.O. 5297(E)
--     (2023-12-12) before S.O. 703(E) (dated 2026-02-03, published
--     2026-02-12) further amended it.
--
-- Gap closure this round: G.S.R. 216(E) (2025-04-02, already modeled as the
-- baseline-coordinates thread's origin) turns out to itself be an amendment
-- to an EARLIER notification — its own operative clause says "the Central
-- Government hereby makes the following amendments to the notification
-- number S.O. 1197(E) dated the 11th May, 2009", and its own trailing Note
-- confirms "The principal notification was published ... vide number S.O.
-- 1197(E) dated the 11th May, 2009 and subsequently amended vide S.O.
-- 2962(E) dated the 20th November, 2009." Both S.O. 1197(E) (the true
-- origin of India's baseline-coordinates system under the Territorial
-- Waters Act, 1976) and S.O. 2962(E) (its first amendment) are added to the
-- existing 'territorial-waters-baseline-notification' instrument and
-- 'baseline-coordinates-corrigendum' thread, with G.S.R. 216(E) now
-- correctly modeled as amending S.O. 1197(E) directly (the operative
-- clause's literal target), not S.O. 2962(E) — the Note lists S.O. 2962(E)
-- purely as prior history of the same instrument, and nothing in the
-- primary text supports treating it as G.S.R. 216(E)'s own direct target.
--
-- Real leads NOT modeled (checked this round, still deferred): a further
-- Emigration Act, 1983 exemption notification (S.O. 767(E), dated
-- 2026-01-16, published 2026-02-13, exempting employers in 191 ECNR
-- countries from section 16(b)) was independently opened and confirmed to
-- carry no cross-reference of any kind, the same conclusion the first pass
-- reached for a different Emigration Act exemption notification — this
-- project has now checked two independent examples of this drafting form
-- and found neither carries a citation.
--
-- Real leads NOT modeled (from the first pass, still open): an Emigration
-- Act, 1983 exemption notification confirmed to carry no cross-reference of
-- any kind (see above — now two such confirmed instances).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('external-affairs', 'Ministry of External Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('territorial-waters-baseline-notification', 'Territorial waters baseline-coordinates notification', NULL),
  ('maritime-designated-areas-2009', 'Maritime zones designated-areas notification, 2009', 2009),
  ('passports-act-1967-prosecution-sanction', 'Passports Act, 1967 — prosecution-sanction authority notification', 1967),
  ('passports-act-1967-s19-yemen-travel', 'Passports Act, 1967 — s.19 Yemen travel-conditions notification', 1967),
  ('terrorism-implementation-order-2007', 'Prevention and Suppression of Terrorism (Implementation of Security Council Resolutions) Order, 2007', 2007),
  ('sudan-unsc-implementation-order-2016', 'Implementation of the United Nations Security Council Resolutions on Sudan Order, 2016', 2016),
  ('passports-rules-1980-fee-schedule', 'Passports Rules, 1980 — Schedule IV fee schedule (s.24 rule-making power)', 1980),
  ('drc-unsc-implementation-order-2016', 'Implementation of the United Nations Security Council Resolutions on Democratic Republic of Congo Order, 2016', 2016),
  ('libya-unsc-implementation-order-2016', 'Implementation of the United Nations Security Council Resolutions on Libya Order, 2016', 2016),
  ('haiti-unsc-implementation-order-2024', 'Implementation of the United Nations Security Council Resolutions on Haiti order, 2024', 2024),
  ('iraq-unsc-implementation-order-2016', 'Implementation of the United Nations Security Council Resolutions on Iraq Order, 2016', 2016);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('baseline-coordinates-corrigendum', 'Territorial waters baseline-coordinates notification and its amendments/corrigendum', 'active'),
  ('maritime-designated-areas-amendment', 'Maritime designated-areas notification and its amendment', 'active'),
  ('passports-act-prosecution-sanction', 'Passports Act prosecution-sanction authority', 'superseded'),
  ('yemen-travel-conditions-rescission', 'Yemen travel-conditions notification rescission', 'superseded'),
  ('terrorism-order-2007-amendments', 'Terrorism Implementation Order, 2007 and its recent amendments', 'active'),
  ('sudan-order-2016-amendments', 'Sudan UNSC Implementation Order, 2016 and its recent amendments', 'active'),
  ('passports-rules-fee-schedule-amendments', 'Passports Rules, 1980 fee-schedule amendments', 'active'),
  ('drc-order-2016-amendments', 'Democratic Republic of Congo UNSC Implementation Order, 2016 and its recent amendments', 'active'),
  ('libya-order-2016-amendments', 'Libya UNSC Implementation Order, 2016 and its recent amendments', 'active'),
  ('haiti-order-2024-amendments', 'Haiti UNSC Implementation Order, 2024 and its recent amendments', 'active'),
  ('iraq-order-2016-amendments', 'Iraq UNSC Implementation Order, 2016 and its recent amendments', 'active');

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
  ('mea-gsr-516-2026', 'MEA', 'G.S.R. 516(E)', 2026, 'so-only', '2026-06-25', 'G.S.R. 516(E)', 'external-affairs', 'passports-rules-1980-fee-schedule', 'passports-rules-fee-schedule-amendments'),
  -- Baseline-coordinates chain, extended backward (gap closure): true origin
  -- S.O. 1197(E) and its first amendment S.O. 2962(E), both recovered from
  -- G.S.R. 216(E)'s own trailing Note.
  ('mea-so-1197-2009', 'MEA', 'S.O. 1197(E)', 2009, 'so-only', '2009-05-11', 'S.O. 1197(E)', 'external-affairs', 'territorial-waters-baseline-notification', 'baseline-coordinates-corrigendum'),
  ('mea-so-2962-2009', 'MEA', 'S.O. 2962(E)', 2009, 'so-only', '2009-11-20', 'S.O. 2962(E)', 'external-affairs', 'territorial-waters-baseline-notification', 'baseline-coordinates-corrigendum'),
  -- Democratic Republic of Congo UNSC Implementation Order, 2016 (note-chain)
  ('mea-so-2874-2016', 'MEA', 'S.O. 2874(E)', 2016, 'so-only', '2016-09-05', 'S.O. 2874(E)', 'external-affairs', 'drc-unsc-implementation-order-2016', 'drc-order-2016-amendments'),
  ('mea-so-1894-2024', 'MEA', 'S.O. 1894(E)', 2024, 'so-only', '2024-05-03', 'S.O. 1894(E)', 'external-affairs', 'drc-unsc-implementation-order-2016', 'drc-order-2016-amendments'),
  ('mea-so-1443-2026', 'MEA', 'S.O. 1443(E)', 2026, 'so-only', '2026-03-19', 'S.O. 1443(E)', 'external-affairs', 'drc-unsc-implementation-order-2016', 'drc-order-2016-amendments'),
  -- Libya UNSC Implementation Order, 2016 (note-chain)
  ('mea-so-2158-2016', 'MEA', 'S.O. 2158(E)', 2016, 'so-only', '2016-06-20', 'S.O. 2158(E)', 'external-affairs', 'libya-unsc-implementation-order-2016', 'libya-order-2016-amendments'),
  ('mea-so-3052-2024', 'MEA', 'S.O. 3052(E)', 2024, 'so-only', '2024-07-26', 'S.O. 3052(E)', 'external-affairs', 'libya-unsc-implementation-order-2016', 'libya-order-2016-amendments'),
  ('mea-so-1305-2026', 'MEA', 'S.O. 1305(E)', 2026, 'so-only', '2026-03-12', 'S.O. 1305(E)', 'external-affairs', 'libya-unsc-implementation-order-2016', 'libya-order-2016-amendments'),
  -- Haiti UNSC Implementation Order, 2024 (note-chain)
  ('mea-so-445-2024',  'MEA', 'S.O. 445(E)',  2024, 'so-only', '2024-02-02', 'S.O. 445(E)',  'external-affairs', 'haiti-unsc-implementation-order-2024', 'haiti-order-2024-amendments'),
  ('mea-so-2830-2025', 'MEA', 'S.O. 2830(E)', 2025, 'so-only', '2025-06-24', 'S.O. 2830(E)', 'external-affairs', 'haiti-unsc-implementation-order-2024', 'haiti-order-2024-amendments'),
  ('mea-so-1001-2026', 'MEA', 'S.O. 1001(E)', 2026, 'so-only', '2026-02-24', 'S.O. 1001(E)', 'external-affairs', 'haiti-unsc-implementation-order-2024', 'haiti-order-2024-amendments'),
  -- Iraq UNSC Implementation Order, 2016 (note-chain)
  ('mea-so-2272-2016', 'MEA', 'S.O. 2272(E)', 2016, 'so-only', '2016-06-30', 'S.O. 2272(E)', 'external-affairs', 'iraq-unsc-implementation-order-2016', 'iraq-order-2016-amendments'),
  ('mea-so-5297-2023', 'MEA', 'S.O. 5297(E)', 2023, 'so-only', '2023-12-12', 'S.O. 5297(E)', 'external-affairs', 'iraq-unsc-implementation-order-2016', 'iraq-order-2016-amendments'),
  ('mea-so-703-2026',  'MEA', 'S.O. 703(E)',  2026, 'so-only', '2026-02-03', 'S.O. 703(E)',  'external-affairs', 'iraq-unsc-implementation-order-2016', 'iraq-order-2016-amendments');

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
  ('mea-gsr-516-2026', 'mea-gsr-156-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Baseline-coordinates chain, gap closure: G.S.R. 216(E)'s own operative
  -- clause names S.O. 1197(E) as its direct target ("amendments to the
  -- notification number S.O. 1197(E) dated the 11th May, 2009"); its Note
  -- separately records S.O. 2962(E) as an earlier amendment to the same
  -- S.O. 1197(E) (not as G.S.R. 216(E)'s own target).
  ('mea-gsr-216-2025', 'mea-so-1197-2009', 'amends', 'research-agent-quoted', '2026-09-07'),
  ('mea-so-2962-2009', 'mea-so-1197-2009', 'amends', 'research-agent-quoted', '2026-09-07'),
  -- Democratic Republic of Congo Order, 2016 chain
  ('mea-so-1894-2024', 'mea-so-2874-2016', 'amends', 'research-agent-quoted', '2026-09-07'),
  ('mea-so-1443-2026', 'mea-so-1894-2024', 'amends', 'research-agent-quoted', '2026-09-07'),
  -- Libya Order, 2016 chain
  ('mea-so-3052-2024', 'mea-so-2158-2016', 'amends', 'research-agent-quoted', '2026-09-07'),
  ('mea-so-1305-2026', 'mea-so-3052-2024', 'amends', 'research-agent-quoted', '2026-09-07'),
  -- Haiti Order, 2024 chain
  ('mea-so-2830-2025', 'mea-so-445-2024',  'amends', 'research-agent-quoted', '2026-09-07'),
  ('mea-so-1001-2026', 'mea-so-2830-2025', 'amends', 'research-agent-quoted', '2026-09-07'),
  -- Iraq Order, 2016 chain
  ('mea-so-5297-2023', 'mea-so-2272-2016', 'amends', 'research-agent-quoted', '2026-09-07'),
  ('mea-so-703-2026',  'mea-so-5297-2023', 'amends', 'research-agent-quoted', '2026-09-07');
