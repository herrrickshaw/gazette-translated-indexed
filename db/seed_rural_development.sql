-- Ministry of Rural Development. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass (3 MGNREGA
-- note-chains). The tracker holds 34 MoRD notifications (the Department
-- of Land Resources is not listed separately; its items sit under the
-- same ministry slug). The two load-bearing new edges were confirmed
-- against the official egazette.gov.in PDFs.
--
-- The story since the first pass is a STATUTORY REPLACEMENT: the Viksit
-- Bharat - Guarantee for Rozgar and Ajeevika Mission (Gramin) Act, 2025
-- (36 of 2025) commenced on 1 July 2026 (S.O. 2382(E)) and MGNREGA, 2005
-- "together with all rules, notifications, schemes, orders and guidelines
-- made thereunder" stood repealed the same day (S.O. 2383(E)). That is an
-- Act-level repeal, not a gazette-to-gazette citation, so no
-- cross_reference edge is drawn for it; both MGNREGA subject threads are
-- marked 'superseded' instead. The new Act's FIRST wage-rate notification
-- (S.O. 3518(E), 2026-06-30) expressly supersedes S.O. 463(E) of 2013 —
-- the principal of the already-modeled 14-node wage chain — naming only
-- that root, so the chain is closed by one supersession edge to its root,
-- not extended. No March-2026 MGNREGA wage revision exists.
--
-- Four VB-G RAM G rule-sets were made by the ordinary draft->final
-- procedure (Transitional Provisions; Manner of Payment of Wages and
-- Unemployment Allowance; Excess-expenditure/UTs-without-legislature;
-- Administrative Expenses) — each final cites its 22 May 2026 draft by
-- number, modeled `cites`. Four further 22 May drafts (G.S.R. 396, 398,
-- 399, 401(E)) and a draft Audit of Schemes Rules (S.O. 4363(E)) have no
-- final yet and are not modeled. A Hindi Salahakar Samiti reconstitution
-- supersedes its 2022 predecessor by full file number and date — a bare-
-- form pair in which source and target carry the IDENTICAL file number
-- (E-11011/1/2020-Hindi), distinguished only by date: date-qualified
-- gazette_ids.
--
-- The Schedule I 2007-2022 gap is NOT closed: both 2025 Notes use only
-- the "first amended ... lastly amended" formula; S.O. 3126(E) (2022)
-- pre-dates tracker coverage and its egazette id is unknown.
--
-- Real leads NOT modeled: S.O. 3508(E) (Interim Arrangement Order, s.36)
-- cites the commencement/repeal notifications by date only, no number —
-- deferred per the citing-text rule even though the identity is
-- unambiguous; eleven Department of Land Resources RFCTLARR s.3(e)(v)
-- "appropriate Government" designations (2023-2026) that reference no
-- other notification; an Aadhaar s.7 notification citing only a Cabinet
-- Secretariat Office Memorandum.
--
-- Cross-ministry number collisions, kept distinct by ministry-prefixed
-- gazette_id: G.S.R. 396/397(E) (Civil Aviation 2025), 397(E) (Mines
-- 2021), 399(E) (DoPT 1989), 402(E) (MoHUA 2025), 548(E) (MoRTH 2025,
-- DoPT 1995).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('rural-development', 'Ministry of Rural Development', 'Department of Rural Development; Department of Land Resources');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('mgnrega-2005-schedule-1', 'MGNREGA, 2005 — Schedule I (repealed 2026-07-01)', 2005),
  ('mgnrega-2005-wage-schedule', 'MGNREGA, 2005 — wage-rate Schedule, s.6(1) (repealed 2026-07-01)', 2005),
  ('vbgramg-act-2025-s10-wage-rate', 'VB-G RAM G Act, 2025 s.10 — wage rate for unskilled manual work', 2025),
  ('vbgramg-transitional-provisions-rules-2026', 'Transitional Provisions under VB-G RAM G Rules, 2026', 2026),
  ('vbgramg-wages-unemployment-allowance-rules-2026', 'VB-G RAM G Manner of Payment of Wages and Unemployment Allowance Rules, 2026', 2026),
  ('vbgramg-excess-expenditure-ut-rules-2026', 'VB-G RAM G Excess-expenditure and UTs-without-legislature Rules, 2026', 2026),
  ('vbgramg-administrative-expenses-rules-2026', 'VB-G RAM G Administrative Expenses Rules, 2026', 2026),
  ('mord-hindi-salahakar-samiti', 'MoRD Hindi Salahakar Samiti reconstitution Resolution', 2022);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mgnrega-schedule-1-amendments', 'MGNREGA Schedule I paragraph amendments (Act repealed 2026-07-01)', 'superseded'),
  ('mgnrega-wage-rate-schedule', 'MGNREGA annual wage-rate Schedule, superseded at the root by the VB-G RAM G wage rate', 'superseded'),
  ('vbgramg-wage-rate', 'VB-G RAM G Act s.10 wage rate superseding the MGNREGA wage chain root', 'active'),
  ('vbgramg-transitional-rules-draft-final', 'Transitional Provisions Rules, 2026 draft->final', 'active'),
  ('vbgramg-wages-rules-draft-final', 'Wages and Unemployment Allowance Rules, 2026 draft->final', 'active'),
  ('vbgramg-excess-expenditure-rules-draft-final', 'Excess-expenditure/UT Rules, 2026 draft->final', 'active'),
  ('vbgramg-admin-expenses-rules-draft-final', 'Administrative Expenses Rules, 2026 draft->final', 'active'),
  ('mord-hindi-samiti-supersession', 'Hindi Salahakar Samiti reconstitution (same file number reused, date-qualified)', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Schedule I: documented origin point plus the two directly-evidenced edges (unchanged)
  ('mord-so-323-2007',  'Rural Development', 'S.O. 323(E)',  2007, 'so-only', '2007-03-06', 'S.O. 323(E)',  'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  ('mord-so-3126-2022', 'Rural Development', 'S.O. 3126(E)', 2022, 'so-only', '2022-07-07', 'S.O. 3126(E)', 'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  ('mord-so-3622-2025', 'Rural Development', 'S.O. 3622(E)', 2025, 'so-only', '2025-08-06', 'S.O. 3622(E)', 'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  ('mord-so-4288-2025', 'Rural Development', 'S.O. 4288(E)', 2025, 'so-only', '2025-09-23', 'S.O. 4288(E)', 'rural-development', 'mgnrega-2005-schedule-1', 'mgnrega-schedule-1-amendments'),
  -- Wage-rate Schedule: fourteen-node chain (unchanged; root now superseded)
  ('mord-so-463-2013',  'Rural Development', 'S.O. 463(E)',  2013, 'so-only', '2013-02-26', 'S.O. 463(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-400-2014',  'Rural Development', 'S.O. 400(E)',  2014, 'so-only', '2014-02-13', 'S.O. 400(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-2118-2014', 'Rural Development', 'S.O. 2118(E)', 2014, 'so-only', '2014-08-22', 'S.O. 2118(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-890-2015',  'Rural Development', 'S.O. 890(E)',  2015, 'so-only', '2015-03-31', 'S.O. 890(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1205-2016', 'Rural Development', 'S.O. 1205(E)', 2016, 'so-only', '2016-03-23', 'S.O. 1205(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-666-2017',  'Rural Development', 'S.O. 666(E)',  2017, 'so-only', '2017-02-28', 'S.O. 666(E)',  'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1406-2018', 'Rural Development', 'S.O. 1406(E)', 2018, 'so-only', '2018-03-28', 'S.O. 1406(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1424-2019', 'Rural Development', 'S.O. 1424(E)', 2019, 'so-only', '2019-03-26', 'S.O. 1424(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1203-2020', 'Rural Development', 'S.O. 1203(E)', 2020, 'so-only', '2020-03-23', 'S.O. 1203(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1206-2021', 'Rural Development', 'S.O. 1206(E)', 2021, 'so-only', '2021-03-15', 'S.O. 1206(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1427-2022', 'Rural Development', 'S.O. 1427(E)', 2022, 'so-only', '2022-03-28', 'S.O. 1427(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1425-2023', 'Rural Development', 'S.O. 1425(E)', 2023, 'so-only', '2023-03-24', 'S.O. 1425(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1562-2024', 'Rural Development', 'S.O. 1562(E)', 2024, 'so-only', '2024-03-27', 'S.O. 1562(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  ('mord-so-1463-2025', 'Rural Development', 'S.O. 1463(E)', 2025, 'so-only', '2025-03-27', 'S.O. 1463(E)', 'rural-development', 'mgnrega-2005-wage-schedule', 'mgnrega-wage-rate-schedule'),
  -- VB-G RAM G wage rate superseding the MGNREGA wage chain root
  ('mord-so-3518-2026', 'Rural Development', 'S.O. 3518(E)', 2026, 'so-only', '2026-06-30', 'S.O. 3518(E)', 'rural-development', 'vbgramg-act-2025-s10-wage-rate', 'vbgramg-wage-rate'),
  -- VB-G RAM G rule-sets, draft -> final
  ('mord-gsr-397-2026', 'Rural Development', 'G.S.R. 397(E)', 2026, 'so-only', '2026-05-22', 'G.S.R. 397(E)', 'rural-development', 'vbgramg-transitional-provisions-rules-2026', 'vbgramg-transitional-rules-draft-final'),
  ('mord-gsr-547-2026', 'Rural Development', 'G.S.R. 547(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 547(E)', 'rural-development', 'vbgramg-transitional-provisions-rules-2026', 'vbgramg-transitional-rules-draft-final'),
  ('mord-gsr-402-2026', 'Rural Development', 'G.S.R. 402(E)', 2026, 'so-only', '2026-05-22', 'G.S.R. 402(E)', 'rural-development', 'vbgramg-wages-unemployment-allowance-rules-2026', 'vbgramg-wages-rules-draft-final'),
  ('mord-gsr-548-2026', 'Rural Development', 'G.S.R. 548(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 548(E)', 'rural-development', 'vbgramg-wages-unemployment-allowance-rules-2026', 'vbgramg-wages-rules-draft-final'),
  ('mord-gsr-403-2026', 'Rural Development', 'G.S.R. 403(E)', 2026, 'so-only', '2026-05-22', 'G.S.R. 403(E)', 'rural-development', 'vbgramg-excess-expenditure-ut-rules-2026', 'vbgramg-excess-expenditure-rules-draft-final'),
  ('mord-gsr-549-2026', 'Rural Development', 'G.S.R. 549(E)', 2026, 'so-only', '2026-07-01', 'G.S.R. 549(E)', 'rural-development', 'vbgramg-excess-expenditure-ut-rules-2026', 'vbgramg-excess-expenditure-rules-draft-final'),
  ('mord-gsr-400-2026', 'Rural Development', 'G.S.R. 400(E)', 2026, 'so-only', '2026-05-22', 'G.S.R. 400(E)', 'rural-development', 'vbgramg-administrative-expenses-rules-2026', 'vbgramg-admin-expenses-rules-draft-final'),
  ('mord-gsr-642-2026', 'Rural Development', 'G.S.R. 642(E)', 2026, 'so-only', '2026-07-20', 'G.S.R. 642(E)', 'rural-development', 'vbgramg-administrative-expenses-rules-2026', 'vbgramg-admin-expenses-rules-draft-final'),
  -- Hindi Salahakar Samiti (same file number reused; date-qualified ids)
  ('mord-res-e11011-2022', 'Rural Development', 'Resolution No. E-11011/1/2020-Hindi', 2022, 'bare', '2022-02-01', 'Resolution No. E-11011/1/2020-Hindi', 'rural-development', 'mord-hindi-salahakar-samiti', 'mord-hindi-samiti-supersession'),
  ('mord-res-e11011-2025', 'Rural Development', 'Resolution No. E-11011/1/2020-Hindi', 2025, 'bare', '2025-08-25', 'Resolution No. E-11011/1/2020-Hindi', 'rural-development', 'mord-hindi-salahakar-samiti', 'mord-hindi-samiti-supersession');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mord-so-3622-2025', 'mord-so-3126-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-4288-2025', 'mord-so-3622-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-400-2014',  'mord-so-463-2013',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-2118-2014', 'mord-so-400-2014',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-890-2015',  'mord-so-2118-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1205-2016', 'mord-so-890-2015',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-666-2017',  'mord-so-1205-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1406-2018', 'mord-so-666-2017',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1424-2019', 'mord-so-1406-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1203-2020', 'mord-so-1424-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1206-2021', 'mord-so-1203-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1427-2022', 'mord-so-1206-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1425-2023', 'mord-so-1427-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1562-2024', 'mord-so-1425-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mord-so-1463-2025', 'mord-so-1562-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- VB-G RAM G
  ('mord-so-3518-2026', 'mord-so-463-2013', 'supersedes', 'primary-source-egazette', '2026-09-04'),
  ('mord-gsr-547-2026', 'mord-gsr-397-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mord-gsr-548-2026', 'mord-gsr-402-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mord-gsr-549-2026', 'mord-gsr-403-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mord-gsr-642-2026', 'mord-gsr-400-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('mord-res-e11011-2025', 'mord-res-e11011-2022', 'supersedes', 'primary-source-egazette', '2026-09-04');
