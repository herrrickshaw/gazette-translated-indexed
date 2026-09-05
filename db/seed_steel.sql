-- Ministry of Steel pilot.
--
-- Modeled: S.O. 2685(E) corrects an address in S.O. 1868(E), a Collection of
-- Statistics Act notification (verified_by 'research-agent-quoted').
--
-- Also modeled (2026-09-04, extract.common_templates.find_note_chain):
-- S.O. 5134(E) and S.O. 3300(E) both amend the Steel and Steel Products
-- (Quality Control) Order, 2024 (S.O. 3716(E), 29 Aug 2024) — two edges
-- into one principal, same shape already modeled for Consumer Affairs.
--
-- Depth pass (2026-09-05): gazettetracker's single-page 32-item listing
-- was fully re-read; the older QCO layer (2012-2020) was recovered from
-- archive.org's `in.gazette.central.e.*` mirror (194-gazette Steel index,
-- one 2012 scan OCR'd). Ten new subject threads added: the full QCO
-- supersession spine 2018-2024 (chaining into the existing S.O. 3716(E)
-- node), the 2015 Order's amendment chain, the Stainless Steel Products
-- QCO chain, an extension of the Collection of Statistics thread back to
-- 2024 and forward to 2026, the Domestically Manufactured Iron & Steel
-- Products Policy's extension/amendment history, the Green Steel Taxonomy
-- notification and its rescission, a Recruitment Rules amendment, three
-- Petroleum and Minerals Pipelines Act declaration/acquisition pairs, a
-- bounded subset of the Factories Act "occupier" amendment chains (five
-- of roughly ten found — the richest and cleanest; the rest are real but
-- left for a future pass, see header note in the generator), and the
-- Estate Officer appointment chain under the Public Premises Act.
--
-- Deferred, not modeled (title-only or unlocatable targets, all
-- documented in the depth-pass agent's own report rather than repeated
-- here in full): S.O. 3966(E)/2999(E)/750(E)'s title-only supersession
-- chain back to 2012; S.O. 2998(E)'s title-only supersession; several
-- 2012-13 QCO amendment numbers (S.O. 2128(E) etc.) cited but not
-- independently located; the Cross Recessed Screws and Cookware QCO
-- threads (cross-ministry with DPIIT, title-only citations throughout);
-- five more Factories Act occupier pairs; a Green Steel Part I corrigendum
-- (no S.O./G.S.R. on either side); the Hindi Advisory Committee
-- resolution (cites nothing); a JPC constitution notification citing bare
-- numbers not independently located.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('steel', 'Ministry of Steel', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('collection-of-statistics-act-2008', 'Collection of Statistics Act, 2008', 2008),
  ('steel-quality-control-order-2024', 'Steel and Steel Products (Quality Control) Order, 2024', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('steel-corrections', 'Ministry of Steel notification corrigenda', 'active'),
  ('steel-quality-control-amendments', 'Steel and Steel Products (Quality Control) Order and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('steel-so-1868-2025', 'Steel', 'S.O. 1868(E)', 2025, 'so-only', '2025-04-25', 'S.O. 1868(E)', 'steel', 'collection-of-statistics-act-2008', 'steel-corrections'),
  ('steel-so-2685-2025', 'Steel', 'S.O. 2685(E)', 2025, 'so-only', '2025-06-16', 'S.O. 2685(E)', 'steel', 'collection-of-statistics-act-2008', 'steel-corrections'),
  ('steel-so-3716-2024', 'Steel', 'S.O. 3716(E)', 2024, 'so-only', '2024-08-29', 'S.O. 3716(E)', 'steel', 'steel-quality-control-order-2024', 'steel-quality-control-amendments'),
  ('steel-so-5134-2025', 'Steel', 'S.O. 5134(E)', 2025, 'so-only', '2025-11-20', 'S.O. 5134(E)', 'steel', 'steel-quality-control-order-2024', 'steel-quality-control-amendments'),
  ('steel-so-3300-2026', 'Steel', 'S.O. 3300(E)', 2026, 'so-only', '2026-06-20', 'S.O. 3300(E)', 'steel', 'steel-quality-control-order-2024', 'steel-quality-control-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('steel-so-2685-2025', 'steel-so-1868-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('steel-so-5134-2025', 'steel-so-3716-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('steel-so-3300-2026', 'steel-so-3716-2024', 'amends', 'research-agent-quoted', '2026-09-04');

-- New threads found in the 2026-09-05 depth pass:
INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('steel-qco-2015', 'Steel and Steel Products (Quality Control) Order, 2015', 2015),
  ('stainless-steel-qco-2016', 'Stainless Steel Products (Quality Control) Order, 2016', 2016),
  ('dmisp-policy', 'Domestically Manufactured Iron and Steel Products Policy', NULL),
  ('green-steel-taxonomy', 'Green Steel Taxonomy notification', NULL),
  ('steel-technical-wing-rr-2026', 'Ministry of Steel (Technical Wing) Recruitment Rules, 2026', 2026),
  ('petroleum-minerals-pipelines-act-1962-s3-6', 'Petroleum and Minerals Pipelines (Acquisition of Right of User in Land) Act, 1962 -- sections 3/6', 1962),
  ('factories-act-1948-s2n', 'Factories Act, 1948 -- section 2(n) occupier notification', 1948),
  ('public-premises-act-1971-s3-steel', 'Public Premises (Eviction of Unauthorised Occupants) Act, 1971 -- section 3 Estate Officer appointment (Steel)', 1971);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('steel-qco-supersession-spine', 'Steel and Steel Products QCO supersession spine, 2018-2024', 'superseded'),
  ('steel-qco-2015-amendments', 'Steel and Steel Products (QC) Order 2015 and its amendments', 'active'),
  ('steel-stainless-qco-amendments', 'Stainless Steel Products QCO 2016 and its amendments', 'active'),
  ('steel-collection-of-statistics-2024-26', 'Collection of Statistics Act notifications, 2024-26 extension of the existing corrections thread', 'active'),
  ('steel-dmisp-policy', 'Domestically Manufactured Iron and Steel Products Policy extensions/amendments', 'active'),
  ('steel-green-steel-taxonomy', 'Green Steel Taxonomy notification and its rescission', 'superseded'),
  ('steel-technical-wing-rr', 'Ministry of Steel (Technical Wing) Recruitment Rules 2026 and its amendment', 'active'),
  ('steel-pmp-act-declarations', 'Petroleum and Minerals Pipelines Act intention-to-acquire / acquisition pairs', 'active'),
  ('steel-factories-act-occupier', 'Factories Act occupier notifications and their amendments', 'active'),
  ('steel-estate-officer', 'Estate Officer appointments under the Public Premises Act (Steel-administered premises)', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('steel-so-750-2018', 'Steel', 'S.O. 750(E)', 2018, 'so-only', '2018-02-16', 'S.O. 750(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-2999-2018', 'Steel', 'S.O. 2999(E)', 2018, 'so-only', '2018-06-20', 'S.O. 2999(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-3966-2018', 'Steel', 'S.O. 3966(E)', 2018, 'so-only', '2018-08-13', 'S.O. 3966(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-2614-2019', 'Steel', 'S.O. 2614(E)', 2019, 'so-only', '2019-07-22', 'S.O. 2614(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-756-2020', 'Steel', 'S.O. 756(E)', 2020, 'so-only', '2020-02-14', 'S.O. 756(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-1673-2020', 'Steel', 'S.O. 1673(E)', 2020, 'so-only', '2020-05-27', 'S.O. 1673(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-2379-2020', 'Steel', 'S.O. 2379(E)', 2020, 'so-only', '2020-07-17', 'S.O. 2379(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-2404-2020', 'Steel', 'S.O. 2404(E)', 2020, 'so-only', '2020-07-21', 'S.O. 2404(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-4082-2020', 'Steel', 'S.O. 4082(E)', 2020, 'so-only', '2020-11-12', 'S.O. 4082(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-4637-2020', 'Steel', 'S.O. 4637(E)', 2020, 'so-only', '2020-12-22', 'S.O. 4637(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-574-2024', 'Steel', 'S.O. 574(E)', 2024, 'so-only', '2024-02-05', 'S.O. 574(E)', 'steel', 'steel-quality-control-order-2024', 'steel-qco-supersession-spine'),
  ('steel-so-3458-2015', 'Steel', 'S.O. 3458(E)', 2015, 'so-only', '2015-12-15', 'S.O. 3458(E)', 'steel', 'steel-qco-2015', 'steel-qco-2015-amendments'),
  ('steel-so-1149-2016', 'Steel', 'S.O. 1149(E)', 2016, 'so-only', '2016-03-17', 'S.O. 1149(E)', 'steel', 'steel-qco-2015', 'steel-qco-2015-amendments'),
  ('steel-so-2966-2016', 'Steel', 'S.O. 2966(E)', 2016, 'so-only', '2016-09-16', 'S.O. 2966(E)', 'steel', 'steel-qco-2015', 'steel-qco-2015-amendments'),
  ('steel-so-3307-2017', 'Steel', 'S.O. 3307(E)', 2017, 'so-only', '2017-10-13', 'S.O. 3307(E)', 'steel', 'steel-qco-2015', 'steel-qco-2015-amendments'),
  ('steel-so-2061-2016', 'Steel', 'S.O. 2061(E)', 2016, 'so-only', '2016-06-10', 'S.O. 2061(E)', 'steel', 'stainless-steel-qco-2016', 'steel-stainless-qco-amendments'),
  ('steel-so-2903-2016', 'Steel', 'S.O. 2903(E)', 2016, 'so-only', '2016-09-09', 'S.O. 2903(E)', 'steel', 'stainless-steel-qco-2016', 'steel-stainless-qco-amendments'),
  ('steel-so-3649-2016', 'Steel', 'S.O. 3649(E)', 2016, 'so-only', '2016-12-06', 'S.O. 3649(E)', 'steel', 'stainless-steel-qco-2016', 'steel-stainless-qco-amendments'),
  ('steel-so-2368-2024', 'Steel', 'S.O. 2368(E)', 2024, 'so-only', '2024-06-19', 'S.O. 2368(E)', 'steel', 'collection-of-statistics-act-2008', 'steel-collection-of-statistics-2024-26'),
  ('steel-so-2753-2024', 'Steel', 'S.O. 2753(E)', 2024, 'so-only', '2024-07-15', 'S.O. 2753(E)', 'steel', 'collection-of-statistics-act-2008', 'steel-collection-of-statistics-2024-26'),
  ('steel-so-3519-2026', 'Steel', 'S.O. 3519(E)', 2026, 'so-only', '2026-06-30', 'S.O. 3519(E)', 'steel', 'collection-of-statistics-act-2008', 'steel-collection-of-statistics-2024-26'),
  ('steel-gsr-385-2019', 'Steel', 'G.S.R. 385(E)', 2019, 'so-only', '2019-05-29', 'G.S.R. 385(E)', 'steel', 'dmisp-policy', 'steel-dmisp-policy'),
  ('steel-gsr-169-2024', 'Steel', 'G.S.R. 169(E)', 2024, 'so-only', '2024-03-11', 'G.S.R. 169(E)', 'steel', 'dmisp-policy', 'steel-dmisp-policy'),
  ('steel-gsr-747-2024', 'Steel', 'G.S.R. 747(E)', 2024, 'so-only', '2024-12-03', 'G.S.R. 747(E)', 'steel', 'dmisp-policy', 'steel-dmisp-policy'),
  ('steel-gsr-341-2025', 'Steel', 'G.S.R. 341(E)', 2025, 'so-only', '2025-05-26', 'G.S.R. 341(E)', 'steel', 'dmisp-policy', 'steel-dmisp-policy'),
  ('steel-gsr-502-2025', 'Steel', 'G.S.R. 502(E)', 2025, 'so-only', '2025-07-25', 'G.S.R. 502(E)', 'steel', 'dmisp-policy', 'steel-dmisp-policy'),
  ('steel-gsr-904-2025', 'Steel', 'G.S.R. 904(E)', 2025, 'so-only', '2025-12-17', 'G.S.R. 904(E)', 'steel', 'dmisp-policy', 'steel-dmisp-policy'),
  ('steel-gsr-720-2026', 'Steel', 'G.S.R. 720(E)', 2026, 'so-only', '2026-08-07', 'G.S.R. 720(E)', 'steel', 'dmisp-policy', 'steel-dmisp-policy'),
  ('steel-gsr-763-2024', 'Steel', 'G.S.R. 763(E)', 2024, 'so-only', '2024-12-12', 'G.S.R. 763(E)', 'steel', 'green-steel-taxonomy', 'steel-green-steel-taxonomy'),
  ('steel-gsr-780-2024', 'Steel', 'G.S.R. 780(E)', 2024, 'so-only', '2024-12-23', 'G.S.R. 780(E)', 'steel', 'green-steel-taxonomy', 'steel-green-steel-taxonomy'),
  ('steel-gsr-277-2026', 'Steel', 'G.S.R. 277(E)', 2026, 'so-only', '2026-04-13', 'G.S.R. 277(E)', 'steel', 'steel-technical-wing-rr-2026', 'steel-technical-wing-rr'),
  ('steel-gsr-482-2026', 'Steel', 'G.S.R. 482(E)', 2026, 'so-only', '2026-06-16', 'G.S.R. 482(E)', 'steel', 'steel-technical-wing-rr-2026', 'steel-technical-wing-rr'),
  ('steel-so-6063-2022', 'Steel', 'S.O. 6063(E)', 2022, 'so-only', '2022-12-23', 'S.O. 6063(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-5126-2024', 'Steel', 'S.O. 5126(E)', 2024, 'so-only', '2024-11-28', 'S.O. 5126(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-81-2018', 'Steel', 'S.O. 81(E)', 2018, 'so-only', '2018-01-03', 'S.O. 81(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-82-2018', 'Steel', 'S.O. 82(E)', 2018, 'so-only', '2018-01-03', 'S.O. 82(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-83-2018', 'Steel', 'S.O. 83(E)', 2018, 'so-only', '2018-01-03', 'S.O. 83(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-4411-2020', 'Steel', 'S.O. 4411(E)', 2020, 'so-only', '2020-12-04', 'S.O. 4411(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-4412-2020', 'Steel', 'S.O. 4412(E)', 2020, 'so-only', '2020-12-04', 'S.O. 4412(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-4413-2020', 'Steel', 'S.O. 4413(E)', 2020, 'so-only', '2020-12-04', 'S.O. 4413(E)', 'steel', 'petroleum-minerals-pipelines-act-1962-s3-6', 'steel-pmp-act-declarations'),
  ('steel-so-425-2026', 'Steel', 'S.O. 425(E)', 2026, 'so-only', '2026-01-29', 'S.O. 425(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-3549-2022', 'Steel', 'S.O. 3549(E)', 2022, 'so-only', '2022-07-27', 'S.O. 3549(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-1305-2017', 'Steel', 'S.O. 1305(E)', 2017, 'so-only', '2017-04-12', 'S.O. 1305(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-3220-2015', 'Steel', 'S.O. 3220(E)', 2015, 'so-only', '2015-11-19', 'S.O. 3220(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-4461-2021', 'Steel', 'S.O. 4461(E)', 2021, 'so-only', '2021-09-27', 'S.O. 4461(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-5748-2022', 'Steel', 'S.O. 5748(E)', 2022, 'so-only', '2022-11-28', 'S.O. 5748(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-1149-2014', 'Steel', 'S.O. 1149(E)', 2014, 'so-only', '2014-04-21', 'S.O. 1149(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-4462-2021', 'Steel', 'S.O. 4462(E)', 2021, 'so-only', '2021-10-22', 'S.O. 4462(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-1509-2015', 'Steel', 'S.O. 1509(E)', 2015, 'so-only', '2015-06-02', 'S.O. 1509(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-1746-2019', 'Steel', 'S.O. 1746(E)', 2019, 'so-only', '2019-05-09', 'S.O. 1746(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-4463-2021', 'Steel', 'S.O. 4463(E)', 2021, 'so-only', '2021-10-22', 'S.O. 4463(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-2053-2012', 'Steel', 'S.O. 2053(E)', 2012, 'so-only', '2012-09-04', 'S.O. 2053(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-1881-2014', 'Steel', 'S.O. 1881(E)', 2014, 'so-only', '2014-07-17', 'S.O. 1881(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-508-2014', 'Steel', 'S.O. 508(E)', 2014, 'so-only', '2014-02-12', 'S.O. 508(E)', 'steel', 'factories-act-1948-s2n', 'steel-factories-act-occupier'),
  ('steel-so-1982-2024', 'Steel', 'S.O. 1982', 2024, 'bare', '2024-05-13', 'S.O. 1982', 'steel', 'public-premises-act-1971-s3-steel', 'steel-estate-officer'),
  ('steel-so-4467-2021', 'Steel', 'S.O. 4467(E)', 2021, 'so-only', '2021-09-07', 'S.O. 4467(E)', 'steel', 'public-premises-act-1971-s3-steel', 'steel-estate-officer'),
  ('steel-so-482-2020', 'Steel', 'S.O. 482(E)', 2020, 'so-only', '2020-01-30', 'S.O. 482(E)', 'steel', 'public-premises-act-1971-s3-steel', 'steel-estate-officer'),
  ('steel-so-1435-2011', 'Steel', 'S.O. 1435', 2011, 'bare', '2011-05-20', 'S.O. 1435', 'steel', 'public-premises-act-1971-s3-steel', 'steel-estate-officer'),
  ('steel-so-2893-2016', 'Steel', 'S.O. 2893(E)', 2016, 'so-only', '2016-09-06', 'S.O. 2893(E)', 'steel', 'public-premises-act-1971-s3-steel', 'steel-estate-officer'),
  ('steel-so-1611-1999', 'Steel', 'S.O. 1611', 1999, 'bare', '1999-05-26', 'S.O. 1611', 'steel', 'public-premises-act-1971-s3-steel', 'steel-estate-officer');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('steel-so-3716-2024', 'steel-so-574-2024', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-574-2024', 'steel-so-4637-2020', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4637-2020', 'steel-so-4082-2020', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4082-2020', 'steel-so-2379-2020', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2404-2020', 'steel-so-2379-2020', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2379-2020', 'steel-so-1673-2020', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-1673-2020', 'steel-so-756-2020', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-756-2020', 'steel-so-2614-2019', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2614-2019', 'steel-so-3966-2018', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-1149-2016', 'steel-so-3458-2015', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2966-2016', 'steel-so-3458-2015', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2966-2016', 'steel-so-1149-2016', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-3307-2017', 'steel-so-3458-2015', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-3307-2017', 'steel-so-1149-2016', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-3307-2017', 'steel-so-2966-2016', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2903-2016', 'steel-so-2061-2016', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-3649-2016', 'steel-so-2061-2016', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-3649-2016', 'steel-so-2903-2016', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2753-2024', 'steel-so-2368-2024', 'corrigendum', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-1868-2025', 'steel-so-2368-2024', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-3519-2026', 'steel-so-1868-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-gsr-169-2024', 'steel-gsr-385-2019', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-gsr-747-2024', 'steel-gsr-385-2019', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-gsr-502-2025', 'steel-gsr-341-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-gsr-720-2026', 'steel-gsr-904-2025', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-gsr-780-2024', 'steel-gsr-763-2024', 'rescinds', 'research-agent-quoted', '2026-09-05'),
  ('steel-gsr-482-2026', 'steel-gsr-277-2026', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-5126-2024', 'steel-so-6063-2022', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4411-2020', 'steel-so-81-2018', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4412-2020', 'steel-so-82-2018', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4413-2020', 'steel-so-83-2018', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-425-2026', 'steel-so-3549-2022', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-3549-2022', 'steel-so-1305-2017', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4461-2021', 'steel-so-3220-2015', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-5748-2022', 'steel-so-3220-2015', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-5748-2022', 'steel-so-4461-2021', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4462-2021', 'steel-so-1149-2014', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-1509-2015', 'steel-so-1149-2014', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4463-2021', 'steel-so-1746-2019', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-1881-2014', 'steel-so-2053-2012', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-508-2014', 'steel-so-2053-2012', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-1982-2024', 'steel-so-4467-2021', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-4467-2021', 'steel-so-482-2020', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-482-2020', 'steel-so-1435-2011', 'supersedes', 'research-agent-quoted', '2026-09-05'),
  ('steel-so-2893-2016', 'steel-so-1611-1999', 'supersedes', 'research-agent-quoted', '2026-09-05');

