-- Ministry of Commerce and Industry. Deepened 2026-09-04 (depth pass —
-- see docs/DEPTH_PASS_PLAN.md) beyond the original 3-pair pass.
--
-- The known SEZ Rules and Ammonium Nitrate Rules chains were confirmed to
-- have NO further amendments beyond what was already modeled (both
-- "current" links' own pages were independently re-opened and checked).
--
-- Six new real pairs/chains found: a Tea Rules amendment, and FIVE
-- Special Economic Zone de-notification/area-adjustment chains, each
-- modeled from a real "WHEREAS ... had notified and de-notified the
-- following areas ... as per the details given below" table listing every
-- prior S.O. for that SEZ — a genuinely different real citation format
-- from the "Note:" clauses used elsewhere, not forced into any existing
-- template since only one ministry's evidence exists for this shape.
--
-- Also found: the known Ammonium Nitrate chain's final link (G.S.R.
-- 659(E)) was itself first published as a draft, G.S.R. 104(E) — modeled
-- with relation_type='cites' (same draft-to-final convention as
-- Petroleum's and Coal's own draft notifications). A SECOND, separate
-- Ammonium Nitrate draft (G.S.R. 454(E), 2026-06-08) proposes further
-- amendments but had not been finalized as of this research pass — a
-- real, live thread with nothing yet to link it to, so deliberately not
-- modeled as its own row (there is no confirmed relationship to record
-- yet, only a pending proposal).
--
-- Real source-text oddity, kept as observed rather than resolved: G.S.R.
-- 659(E)'s and G.S.R. 454(E)'s own Notes disagree by one day on two dates
-- in the identical Ammonium Nitrate amendment history (G.S.R. 938(E):
-- 28 vs. 27 September 2018; G.S.R. 608(E): 1 vs. 31 August 2021) — the
-- already-modeled dates come from the original directly-quoted source and
-- are unchanged; this is flagged for awareness, not corrected against.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('commerce-and-industry', 'Ministry of Commerce and Industry', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('sez-rules-2006', 'Special Economic Zones Rules, 2006', 2006),
  ('rudradev-infopark-sez', 'Rudradev Infopark SEZ notification', NULL),
  ('ammonium-nitrate-rules-2012', 'Ammonium Nitrate Rules, 2012', 2012),
  ('tea-holding-inquiry-appeal-rules-2024', 'Tea (Holding Inquiry and Appeal) Rules, 2024', 2024),
  ('sez-gidc-apparel-park-khokhra', 'GIDC Apparel Park SEZ, Khokhra, Ahmedabad', NULL),
  ('sez-mangalore-baikampady', 'Mangalore SEZ Limited, Baikampady', NULL),
  ('sez-lanco-hills-manikonda', 'Lanco Hills Technology Park SEZ, Manikonda, Telangana', NULL),
  ('sez-kerala-pallipuram', 'Kerala State IT Infrastructure SEZ, Pallipuram, Alappuzha', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('sez-rules-amendments', 'SEZ Rules, 2006 and its amendments', 'active'),
  ('rudradev-infopark-sez-rescission', 'Rudradev Infopark SEZ rescission', 'superseded'),
  ('ammonium-nitrate-rules-amendments', 'Ammonium Nitrate Rules, 2012 and its amendments', 'active'),
  ('tea-rules-amendment', 'Tea (Holding Inquiry and Appeal) Rules, 2024 amendment', 'active'),
  ('sez-gidc-apparel-park-denotifications', 'GIDC Apparel Park SEZ area de-notifications', 'active'),
  ('sez-mangalore-baikampady-adjustments', 'Mangalore SEZ Baikampady area adjustments', 'active'),
  ('sez-lanco-hills-bifurcation', 'Lanco Hills SEZ bifurcation and de-notification', 'active'),
  ('sez-kerala-pallipuram-denotifications', 'Kerala IT Infrastructure SEZ area de-notifications', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: three-node chain, now with its draft precursor
  ('moci-gsr-54-2006',  'MoCI', 'G.S.R. 54(E)',  2006, 'so-only', '2006-02-10', 'G.S.R. 54(E)',  'commerce-and-industry', 'sez-rules-2006', 'sez-rules-amendments'),
  ('moci-gsr-114-2026', 'MoCI', 'G.S.R. 114(E)', 2026, 'so-only', '2026-02-03', 'G.S.R. 114(E)', 'commerce-and-industry', 'sez-rules-2006', 'sez-rules-amendments'),
  ('moci-gsr-609-2026', 'MoCI', 'G.S.R. 609(E)', 2026, 'so-only', '2026-07-09', 'G.S.R. 609(E)', 'commerce-and-industry', 'sez-rules-2006', 'sez-rules-amendments'),
  -- Pair 2: two-node chain, rescission
  ('moci-so-837-2007',  'MoCI', 'S.O. 837(E)',  2007, 'so-only', '2007-05-18', 'S.O. 837(E)',  'commerce-and-industry', 'rudradev-infopark-sez', 'rudradev-infopark-sez-rescission'),
  ('moci-so-4056-2026', 'MoCI', 'S.O. 4056(E)', 2026, 'so-only', '2026-07-22', 'S.O. 4056(E)', 'commerce-and-industry', 'rudradev-infopark-sez', 'rudradev-infopark-sez-rescission'),
  -- Pair 3: eight-node chain, now with its draft precursor
  ('moci-gsr-553-2012', 'MoCI', 'G.S.R. 553(E)', 2012, 'so-only', '2012-07-11', 'G.S.R. 553(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-469-2013', 'MoCI', 'G.S.R. 469(E)', 2013, 'so-only', '2013-07-09', 'G.S.R. 469(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-938-2018', 'MoCI', 'G.S.R. 938(E)', 2018, 'so-only', '2018-09-28', 'G.S.R. 938(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-608-2021', 'MoCI', 'G.S.R. 608(E)', 2021, 'so-only', '2021-09-01', 'G.S.R. 608(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-239-2025', 'MoCI', 'G.S.R. 239(E)', 2025, 'so-only', '2025-04-17', 'G.S.R. 239(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-377-2025', 'MoCI', 'G.S.R. 377(E)', 2025, 'so-only', '2025-06-09', 'G.S.R. 377(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-104-2026', 'MoCI', 'G.S.R. 104(E)', 2026, 'so-only', '2026-02-03', 'G.S.R. 104(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  ('moci-gsr-659-2026', 'MoCI', 'G.S.R. 659(E)', 2026, 'so-only', '2026-07-16', 'G.S.R. 659(E)', 'commerce-and-industry', 'ammonium-nitrate-rules-2012', 'ammonium-nitrate-rules-amendments'),
  -- New: Tea Rules amendment
  ('moci-gsr-487-2024', 'MoCI', 'G.S.R. 487(E)', 2024, 'so-only', '2024-08-08', 'G.S.R. 487(E)', 'commerce-and-industry', 'tea-holding-inquiry-appeal-rules-2024', 'tea-rules-amendment'),
  ('moci-gsr-669-2026', 'MoCI', 'G.S.R. 669(E)', 2026, 'so-only', '2026-07-20', 'G.S.R. 669(E)', 'commerce-and-industry', 'tea-holding-inquiry-appeal-rules-2024', 'tea-rules-amendment'),
  -- GIDC Apparel Park SEZ: 3-node chain
  ('moci-so-543-2007',  'MoCI', 'S.O. 543(E)',  2007, 'so-only', '2007-04-10', 'S.O. 543(E)',  'commerce-and-industry', 'sez-gidc-apparel-park-khokhra', 'sez-gidc-apparel-park-denotifications'),
  ('moci-so-3639-2024', 'MoCI', 'S.O. 3639(E)', 2024, 'so-only', '2024-08-28', 'S.O. 3639(E)', 'commerce-and-industry', 'sez-gidc-apparel-park-khokhra', 'sez-gidc-apparel-park-denotifications'),
  ('moci-so-4849-2026', 'MoCI', 'S.O. 4849(E)', 2026, 'so-only', '2026-08-31', 'S.O. 4849(E)', 'commerce-and-industry', 'sez-gidc-apparel-park-khokhra', 'sez-gidc-apparel-park-denotifications'),
  -- Mangalore SEZ Baikampady: 7-node chain
  ('moci-so-1885-2007', 'MoCI', 'S.O. 1885(E)', 2007, 'so-only', '2007-11-06', 'S.O. 1885(E)', 'commerce-and-industry', 'sez-mangalore-baikampady', 'sez-mangalore-baikampady-adjustments'),
  ('moci-so-1477-2011', 'MoCI', 'S.O. 1477(E)', 2011, 'so-only', '2011-06-28', 'S.O. 1477(E)', 'commerce-and-industry', 'sez-mangalore-baikampady', 'sez-mangalore-baikampady-adjustments'),
  ('moci-so-1909-2011', 'MoCI', 'S.O. 1909(E)', 2011, 'so-only', '2011-08-18', 'S.O. 1909(E)', 'commerce-and-industry', 'sez-mangalore-baikampady', 'sez-mangalore-baikampady-adjustments'),
  ('moci-so-2298-2014', 'MoCI', 'S.O. 2298(E)', 2014, 'so-only', '2014-09-08', 'S.O. 2298(E)', 'commerce-and-industry', 'sez-mangalore-baikampady', 'sez-mangalore-baikampady-adjustments'),
  ('moci-so-3719-2017', 'MoCI', 'S.O. 3719(E)', 2017, 'so-only', '2017-11-13', 'S.O. 3719(E)', 'commerce-and-industry', 'sez-mangalore-baikampady', 'sez-mangalore-baikampady-adjustments'),
  ('moci-so-544-2022',  'MoCI', 'S.O. 544(E)',  2022, 'so-only', '2022-02-09', 'S.O. 544(E)',  'commerce-and-industry', 'sez-mangalore-baikampady', 'sez-mangalore-baikampady-adjustments'),
  ('moci-so-4512-2026', 'MoCI', 'S.O. 4512(E)', 2026, 'so-only', '2026-06-12', 'S.O. 4512(E)', 'commerce-and-industry', 'sez-mangalore-baikampady', 'sez-mangalore-baikampady-adjustments'),
  -- Lanco Hills SEZ: 3-node chain
  ('moci-so-550-2007',  'MoCI', 'S.O. 550(E)',  2007, 'so-only', '2007-04-10', 'S.O. 550(E)',  'commerce-and-industry', 'sez-lanco-hills-manikonda', 'sez-lanco-hills-bifurcation'),
  ('moci-so-2899-2013', 'MoCI', 'S.O. 2899(E)', 2013, 'so-only', '2013-09-24', 'S.O. 2899(E)', 'commerce-and-industry', 'sez-lanco-hills-manikonda', 'sez-lanco-hills-bifurcation'),
  ('moci-so-4037-2026', 'MoCI', 'S.O. 4037(E)', 2026, 'so-only', '2026-07-21', 'S.O. 4037(E)', 'commerce-and-industry', 'sez-lanco-hills-manikonda', 'sez-lanco-hills-bifurcation'),
  -- Kerala IT Infrastructure SEZ: 3-node chain
  ('moci-so-1426-2009', 'MoCI', 'S.O. 1426(E)', 2009, 'so-only', '2009-06-08', 'S.O. 1426(E)', 'commerce-and-industry', 'sez-kerala-pallipuram', 'sez-kerala-pallipuram-denotifications'),
  ('moci-so-3020-2024', 'MoCI', 'S.O. 3020(E)', 2024, 'so-only', '2024-07-15', 'S.O. 3020(E)', 'commerce-and-industry', 'sez-kerala-pallipuram', 'sez-kerala-pallipuram-denotifications'),
  ('moci-so-4036-2026', 'MoCI', 'S.O. 4036(E)', 2026, 'so-only', '2026-07-13', 'S.O. 4036(E)', 'commerce-and-industry', 'sez-kerala-pallipuram', 'sez-kerala-pallipuram-denotifications');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moci-gsr-114-2026', 'moci-gsr-54-2006',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-609-2026', 'moci-gsr-114-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-4056-2026', 'moci-so-837-2007',  'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-469-2013', 'moci-gsr-553-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-938-2018', 'moci-gsr-469-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-608-2021', 'moci-gsr-938-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-239-2025', 'moci-gsr-608-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-377-2025', 'moci-gsr-239-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-659-2026', 'moci-gsr-377-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-659-2026', 'moci-gsr-104-2026', 'cites',  'research-agent-quoted', '2026-09-04'),
  ('moci-gsr-669-2026', 'moci-gsr-487-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-3639-2024', 'moci-so-543-2007',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-4849-2026', 'moci-so-3639-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-1477-2011', 'moci-so-1885-2007', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-1909-2011', 'moci-so-1477-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-2298-2014', 'moci-so-1909-2011', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-3719-2017', 'moci-so-2298-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-544-2022',  'moci-so-3719-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-4512-2026', 'moci-so-544-2022',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-2899-2013', 'moci-so-550-2007',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-4037-2026', 'moci-so-2899-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-3020-2024', 'moci-so-1426-2009', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('moci-so-4036-2026', 'moci-so-3020-2024', 'amends', 'research-agent-quoted', '2026-09-04');
