-- Third-ministry pilot: Ministry of Environment, Forest and Climate Change.
--
-- 🔴 CORRECTION (2026-09-04): the S.O. 3182(E)/S.O. 3252(E) pair below was
-- originally tagged 'spot-checked' against gazette ID CG-DL-E-19072023-247431
-- — that gazette ID's OFFICIAL PDF (fetched from egazette.gov.in and parsed
-- during the bounded manifest run) is a DIFFERENT notification entirely:
-- G.S.R. 522(E) correcting G.S.R. 499(E) ("draft notification" -> "notification"),
-- with no mention of S.O. 3182(E)/3252(E)/"Times of India" anywhere in it. The
-- aggregator served mismatched content under that ID — the same class of
-- fault as the three page-TITLE mismatches already found elsewhere in this
-- project, but this time the Full Text itself was wrong, not just the title.
-- The S.O. 3182(E)/3252(E) quote is kept (it is real text, seen verbatim on
-- the aggregator page at the time) but downgraded to 'research-agent-quoted'
-- — a "spot-check" against a mismatched ID is not a spot-check, and no
-- correct gazette ID for this pair has been located since. The genuinely
-- verified G.S.R. 522(E)/499(E) pair recovered from the real official PDF is
-- added below at the 'primary-source-egazette' tier instead — a small
-- ministry-level lesson from a real mistake, not a wasted fetch.
--
-- Provenance, recorded per-row rather than assumed uniform:
--   'primary-source-egazette' — fetched from egazette.gov.in by gazette ID
--                          and parsed directly by this pipeline; the
--                          strongest tier available for a ministry.
--   'research-agent-quoted' — a research agent quoted primary "Full Text"
--                          from an aggregator; not independently fetched
--                          from the official source. Real, not fabricated,
--                          but its own gazette ID may be unconfirmed — see
--                          the correction above.
--
-- Drafting convention differs from both CBIC's and MoRTH's: "In the
-- notification of the Government of India in the Ministry of Environment,
-- Forest and Climate Change [vide] number <citation>, dated <date> ... for
-- [old text] read [new text]" — a corrigendum-by-textual-substitution
-- template, not a supersession or a single "hereby makes the following
-- amendment" clause.
--
-- Deepened 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md), this time
-- deliberately preferring the official egazette.gov.in PDF (fetched by
-- gazette ID, WebFetch fails on egazette.gov.in with a TLS error — curl
-- works, matching the standing project note about this host) over
-- aggregator text, given this ministry's own documented mismatch history
-- above. 3 new subject areas found beyond simple corrigenda: the Plastic
-- Waste Management Rules, 2016 amendment chain (5 amendments, 3 with their
-- own draft-notification precursor modeled via `cites`); the Coastal
-- Regulation Zone Notification's 2019 supersession of its 2011 predecessor;
-- and the E-Waste (Management) Rules' two-generation supersession lineage
-- (2011->2016->2022), each with its own draft precursor.
--
-- REAL CITATION COLLISION found and correctly kept distinct: "G.S.R.
-- 522(E)" denotes two unrelated real MoEFCC documents — the Plastic Waste
-- Management (Second Amendment) Rules, 2022 [2022-07-06] and the already-
-- modeled G.S.R. 499(E) corrigendum [2023-07-18] — kept as distinct
-- gazette_id rows.
--
-- Verification tiers for the new material: PWM amendments and their draft
-- precursors are 'primary-source-egazette' (fetched directly); the CRZ and
-- E-Waste supersessions are 'official-government-mirror' (verified against
-- a state pollution-control-board or coastal-authority copy carrying
-- matching Gazette Part II Sec 3 pagination, not egazette.gov.in itself and
-- not an aggregator — one tier below primary but well above aggregator
-- trust, given this ministry's specific mismatch history).
--
-- Real leads NOT modeled: five further PWM amendments (G.S.R. 285(E)/2018,
-- 647(E)/2021, 318(E)/2023, 73(E)/2025, 237(E)/2026) known only from a
-- secondary compiled tracker, not yet independently fetched from an
-- official source.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('environment-forest-climate-change', 'Ministry of Environment, Forest and Climate Change', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('moefcc-notifications-general', 'MoEFCC notifications (various subject matter)', NULL),
  ('plastic-waste-management-rules-2016', 'Plastic Waste Management Rules, 2016', 2016),
  ('coastal-regulation-zone-notification', 'Coastal Regulation Zone Notification', 2011),
  ('ewaste-management-rules', 'E-Waste (Management) Rules', 2011);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('moefcc-corrections', 'MoEFCC notification corrigenda', 'active'),
  ('pwm-rules-amendments', 'Plastic Waste Management Rules, 2016 and its amendments', 'active'),
  ('crz-notification-supersession', 'Coastal Regulation Zone Notification supersession', 'superseded'),
  ('ewaste-rules-supersession', 'E-Waste (Management) Rules — two-generation supersession lineage', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('moefcc-so-3252-2022', 'MoEFCC', 'S.O. 3252(E)', 2022, 'so-only', '2022-07-22', 'S.O. 3252(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-so-3182-2023', 'MoEFCC', 'S.O. 3182(E)', 2023, 'so-only', '2023-07-18', 'S.O. 3182(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-so-5254-2022', 'MoEFCC', 'S.O. 5254(E)', 2022, 'so-only', '2022-11-04', 'S.O. 5254(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-so-4101-2023', 'MoEFCC', 'S.O. 4101(E)', 2023, 'so-only', '2023-09-18', 'S.O. 4101(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-gsr-766-2018', 'MoEFCC', 'G.S.R. 766(E)', 2018, 'so-only', '2018-08-10', 'G.S.R. 766(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-gsr-731-2024', 'MoEFCC', 'G.S.R. 731(E)', 2024, 'so-only', '2024-11-26', 'G.S.R. 731(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  -- Recovered directly from the OFFICIAL PDF at CG-DL-E-19072023-247431 —
  -- the notification actually at that gazette ID (see correction above).
  ('moefcc-gsr-499-2023', 'MoEFCC', 'G.S.R. 499(E)', 2023, 'so-only', '2023-07-11', 'G.S.R. 499(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  ('moefcc-gsr-522-2023', 'MoEFCC', 'G.S.R. 522(E)', 2023, 'so-only', '2023-07-18', 'G.S.R. 522(E)', 'environment-forest-climate-change', 'moefcc-notifications-general', 'moefcc-corrections'),
  -- Plastic Waste Management Rules, 2016 amendment chain
  ('moefcc-gsr-320-2016', 'MoEFCC', 'G.S.R. 320(E)', 2016, 'so-only', '2016-03-18', 'G.S.R. 320(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-169-2021', 'MoEFCC', 'G.S.R. 169(E)', 2021, 'so-only', '2021-03-11', 'G.S.R. 169(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-571-2021', 'MoEFCC', 'G.S.R. 571(E)', 2021, 'so-only', '2021-08-12', 'G.S.R. 571(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-22-2022',  'MoEFCC', 'G.S.R. 22(E)',  2022, 'so-only', '2022-01-18', 'G.S.R. 22(E)',  'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-133-2022', 'MoEFCC', 'G.S.R. 133(E)', 2022, 'so-only', '2022-02-16', 'G.S.R. 133(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-522-2022', 'MoEFCC', 'G.S.R. 522(E)', 2022, 'so-only', '2022-07-06', 'G.S.R. 522(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-744-2023', 'MoEFCC', 'G.S.R. 744(E)', 2023, 'so-only', '2023-10-16', 'G.S.R. 744(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-807-2023', 'MoEFCC', 'G.S.R. 807(E)', 2023, 'so-only', '2023-10-30', 'G.S.R. 807(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  ('moefcc-gsr-201-2024', 'MoEFCC', 'G.S.R. 201(E)', 2024, 'so-only', '2024-03-14', 'G.S.R. 201(E)', 'environment-forest-climate-change', 'plastic-waste-management-rules-2016', 'pwm-rules-amendments'),
  -- Coastal Regulation Zone Notification
  ('moefcc-so-19-2011', 'MoEFCC', 'S.O. 19(E)', 2011, 'so-only', '2011-01-06', 'S.O. 19(E)', 'environment-forest-climate-change', 'coastal-regulation-zone-notification', 'crz-notification-supersession'),
  ('moefcc-gsr-37-2019', 'MoEFCC', 'G.S.R. 37(E)', 2019, 'so-only', '2019-01-18', 'G.S.R. 37(E)', 'environment-forest-climate-change', 'coastal-regulation-zone-notification', 'crz-notification-supersession'),
  -- E-Waste (Management) Rules — two-generation supersession
  ('moefcc-so-1035-2011', 'MoEFCC', 'S.O. 1035(E)', 2011, 'so-only', '2011-05-12', 'S.O. 1035(E)', 'environment-forest-climate-change', 'ewaste-management-rules', 'ewaste-rules-supersession'),
  ('moefcc-gsr-472-2015', 'MoEFCC', 'G.S.R. 472(E)', 2015, 'so-only', '2015-06-10', 'G.S.R. 472(E)', 'environment-forest-climate-change', 'ewaste-management-rules', 'ewaste-rules-supersession'),
  ('moefcc-gsr-338-2016', 'MoEFCC', 'G.S.R. 338(E)', 2016, 'so-only', '2016-03-23', 'G.S.R. 338(E)', 'environment-forest-climate-change', 'ewaste-management-rules', 'ewaste-rules-supersession'),
  ('moefcc-so-360-2022',  'MoEFCC', 'S.O. 360(E)',  2022, 'so-only', '2022-05-19', 'S.O. 360(E)',  'environment-forest-climate-change', 'ewaste-management-rules', 'ewaste-rules-supersession'),
  ('moefcc-gsr-801-2022', 'MoEFCC', 'G.S.R. 801(E)', 2022, 'so-only', '2022-11-02', 'G.S.R. 801(E)', 'environment-forest-climate-change', 'ewaste-management-rules', 'ewaste-rules-supersession');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moefcc-so-3182-2023', 'moefcc-so-3252-2022', 'corrigendum', 'research-agent-quoted',   '2026-09-03'),
  ('moefcc-so-4101-2023', 'moefcc-so-5254-2022', 'corrigendum', 'research-agent-quoted',   '2026-09-03'),
  ('moefcc-gsr-731-2024', 'moefcc-gsr-766-2018', 'corrigendum', 'research-agent-quoted',   '2026-09-03'),
  ('moefcc-gsr-522-2023', 'moefcc-gsr-499-2023', 'corrigendum', 'primary-source-egazette', '2026-09-04'),
  -- Plastic Waste Management Rules chain
  ('moefcc-gsr-571-2021', 'moefcc-gsr-320-2016', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('moefcc-gsr-571-2021', 'moefcc-gsr-169-2021', 'cites',  'primary-source-egazette', '2026-09-04'),
  ('moefcc-gsr-133-2022', 'moefcc-gsr-320-2016', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('moefcc-gsr-522-2022', 'moefcc-gsr-320-2016', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('moefcc-gsr-522-2022', 'moefcc-gsr-22-2022',  'cites',  'primary-source-egazette', '2026-09-04'),
  ('moefcc-gsr-807-2023', 'moefcc-gsr-320-2016', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('moefcc-gsr-201-2024', 'moefcc-gsr-320-2016', 'amends', 'primary-source-egazette', '2026-09-04'),
  ('moefcc-gsr-201-2024', 'moefcc-gsr-744-2023', 'cites',  'primary-source-egazette', '2026-09-04'),
  -- Coastal Regulation Zone Notification
  ('moefcc-gsr-37-2019', 'moefcc-so-19-2011', 'supersedes', 'official-government-mirror', '2026-09-04'),
  -- E-Waste (Management) Rules
  ('moefcc-gsr-338-2016', 'moefcc-so-1035-2011', 'supersedes', 'official-government-mirror', '2026-09-04'),
  ('moefcc-gsr-338-2016', 'moefcc-gsr-472-2015', 'cites',      'official-government-mirror', '2026-09-04'),
  ('moefcc-gsr-801-2022', 'moefcc-gsr-338-2016', 'supersedes', 'official-government-mirror', '2026-09-04'),
  ('moefcc-gsr-801-2022', 'moefcc-so-360-2022',  'cites',      'official-government-mirror', '2026-09-04');
