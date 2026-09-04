-- Ministry of Communications (Department of Telecommunications). Deepened
-- 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the
-- original bounded pass.
--
-- CONFIRMED: G.S.R. 796(E) [2025-10-29] is genuinely a duplicate
-- publication of the SAME Telecom Cyber Security (Amendment) Rules, 2025
-- text as G.S.R. 771(E) [2025-10-22] — both pages independently opened
-- and diffed word-for-word identical (same operative text, same Note,
-- same signatory). The already-modeled rescission (G.S.R. 863(E)
-- rescinds G.S.R. 796(E)) is confirmed correct as-is.
--
-- REAL CITATION COLLISION, flagged rather than silently resolved: a
-- SEPARATE, unrelated "G.S.R. 796(E)" exists — dated 22 December 2020,
-- part of the TRAI Salary/Allowances Rules chain — a completely different
-- real notification that happens to share the same citation number as
-- the 2025 duplicate above, because G.S.R. numbers reset and can collide
-- across different years. Modeled under its own gazette_id
-- (comms-gsr-796-2020) to keep the two documents distinct.
--
-- Six further real pairs/chains found across four new subject areas: TRAI
-- Act 1997 rules (two separate Recruitment/Salary rule chains), a
-- Removal of Difficulties Order under the Telecommunications Act 2023
-- (Digital Bharat Nidhi/USOF), Indian Telegraph Act 1885 rules (a real
-- G.S.R.-numbered amendment, not the numbered-rules-within-Act form
-- already correctly excluded), a draft-to-final Amateur Station Operator
-- Rules pair, and a Telecom Assistant Recruitment Rules amendment.
--
-- Three further real leads are supersessions with NO usable citation
-- given in THAT notification's own text (even where the target is
-- independently identifiable from a different document, this project
-- only models an edge when the SOURCE document itself states the
-- citation — an inference from context is not the same as a quote) —
-- deliberately not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('communications', 'Ministry of Communications', 'Department of Telecommunications');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('telecommunications-act-2023-s56', 'Telecommunications Act, 2023 — section 56', 2023),
  ('lawful-interception-rules-2024', 'Telecommunications (Procedures and Safeguards for Lawful Interception of Messages) Rules, 2024', 2024),
  ('trai-act-1997-recruitment-rules-2025', 'TRAI (Recruitment and Conditions of Service of Officers and Other Employees) Rules, 2025', 2025),
  ('trai-act-1997-salary-rules-2002', 'TRAI (Salary, Allowances and other Conditions of Service) Rules, 2002', 2002),
  ('telecommunications-removal-difficulties-order-2024', 'Telecommunications (Removal of Difficulties) Order, 2024', 2024),
  ('flight-maritime-connectivity-rules-2018', 'Flight and Maritime Connectivity Rules, 2018 (Indian Telegraph Act, 1885)', 2018),
  ('amateur-station-operator-rules-2024', 'Telecommunications (Amateur Station Operator) Rules, 2024', 2024),
  ('dot-telecom-assistant-rr-2024', 'DoT Telecom Assistant Group C Post Recruitment Rules, 2024', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('telecom-cyber-security-rules', 'Telecommunications (Telecom Cyber Security) Rules and their amendments', 'active'),
  ('telecom-lawful-interception-rules', 'Lawful Interception Rules and their amendments', 'active'),
  ('trai-recruitment-rules-amendment', 'TRAI Recruitment and Conditions of Service Rules amendment', 'active'),
  ('trai-salary-rules-chain', 'TRAI Salary/Allowances Rules amendment chain (superseded by the 2025 Recruitment Rules)', 'superseded'),
  ('telecom-removal-difficulties-order', 'Telecommunications Removal of Difficulties Order amendment', 'active'),
  ('flight-maritime-connectivity-amendments', 'Flight and Maritime Connectivity Rules and their amendments', 'active'),
  ('amateur-station-operator-draft-final', 'Amateur Station Operator Rules, draft to final', 'active'),
  ('dot-telecom-assistant-rr-amendment', 'DoT Telecom Assistant Recruitment Rules amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('comms-gsr-796-2025', 'Communications', 'G.S.R. 796(E)', 2025, 'so-only', '2025-10-22', 'G.S.R. 796(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-863-2025', 'Communications', 'G.S.R. 863(E)', 2025, 'so-only', '2025-11-25', 'G.S.R. 863(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-720-2024', 'Communications', 'G.S.R. 720(E)', 2024, 'so-only', '2024-11-21', 'G.S.R. 720(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-771-2025', 'Communications', 'G.S.R. 771(E)', 2025, 'so-only', '2025-10-22', 'G.S.R. 771(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-754-2024', 'Communications', 'G.S.R. 754(E)', 2024, 'so-only', '2024-12-06', 'G.S.R. 754(E)', 'communications', 'lawful-interception-rules-2024', 'telecom-lawful-interception-rules'),
  ('comms-gsr-625-2025', 'Communications', 'G.S.R. 625(E)', 2025, 'so-only', '2025-09-12', 'G.S.R. 625(E)', 'communications', 'lawful-interception-rules-2024', 'telecom-lawful-interception-rules'),
  -- TRAI Recruitment Rules 2025
  ('comms-gsr-909-2025', 'Communications', 'G.S.R. 909(E)', 2025, 'so-only', '2025-12-18', 'G.S.R. 909(E)', 'communications', 'trai-act-1997-recruitment-rules-2025', 'trai-recruitment-rules-amendment'),
  ('comms-gsr-413-2026', 'Communications', 'G.S.R. 413(E)', 2026, 'so-only', '2026-05-26', 'G.S.R. 413(E)', 'communications', 'trai-act-1997-recruitment-rules-2025', 'trai-recruitment-rules-amendment'),
  -- TRAI Salary Rules 2002 chain (a DIFFERENT "G.S.R. 796(E)", dated
  -- 2020 — a real citation collision with the 2025 one above, kept as a
  -- distinct row per this file's own header comment)
  ('comms-gsr-726-2002', 'Communications', 'G.S.R. 726(E)', 2002, 'so-only', '2002-10-25', 'G.S.R. 726(E)', 'communications', 'trai-act-1997-salary-rules-2002', 'trai-salary-rules-chain'),
  ('comms-gsr-796-2020', 'Communications', 'G.S.R. 796(E)', 2020, 'so-only', '2020-12-22', 'G.S.R. 796(E)', 'communications', 'trai-act-1997-salary-rules-2002', 'trai-salary-rules-chain'),
  ('comms-gsr-113-2022', 'Communications', 'G.S.R. 113(E)', 2022, 'so-only', '2022-02-11', 'G.S.R. 113(E)', 'communications', 'trai-act-1997-salary-rules-2002', 'trai-salary-rules-chain'),
  ('comms-gsr-423-2025', 'Communications', 'G.S.R. 423(E)', 2025, 'so-only', '2025-06-27', 'G.S.R. 423(E)', 'communications', 'trai-act-1997-salary-rules-2002', 'trai-salary-rules-chain'),
  -- Removal of Difficulties Order
  ('comms-so-3948-2024', 'Communications', 'S.O. 3948(E)', 2024, 'so-only', '2024-09-13', 'S.O. 3948(E)', 'communications', 'telecommunications-removal-difficulties-order-2024', 'telecom-removal-difficulties-order'),
  ('comms-so-2962-2025', 'Communications', 'S.O. 2962(E)', 2025, 'so-only', '2025-07-02', 'S.O. 2962(E)', 'communications', 'telecommunications-removal-difficulties-order-2024', 'telecom-removal-difficulties-order'),
  -- Flight and Maritime Connectivity Rules chain
  ('comms-gsr-1211-2018', 'Communications', 'G.S.R. 1211(E)', 2018, 'so-only', '2018-12-14', 'G.S.R. 1211(E)', 'communications', 'flight-maritime-connectivity-rules-2018', 'flight-maritime-connectivity-amendments'),
  ('comms-gsr-154-2022',  'Communications', 'G.S.R. 154(E)',  2022, 'so-only', '2022-02-23', 'G.S.R. 154(E)',  'communications', 'flight-maritime-connectivity-rules-2018', 'flight-maritime-connectivity-amendments'),
  ('comms-gsr-682-2024',  'Communications', 'G.S.R. 682(E)',  2024, 'so-only', '2024-10-28', 'G.S.R. 682(E)',  'communications', 'flight-maritime-connectivity-rules-2018', 'flight-maritime-connectivity-amendments'),
  -- Amateur Station Operator Rules: draft then final
  ('comms-gsr-447-2024', 'Communications', 'G.S.R. 447(E)', 2024, 'so-only', '2024-07-24', 'G.S.R. 447(E)', 'communications', 'amateur-station-operator-rules-2024', 'amateur-station-operator-draft-final'),
  ('comms-gsr-675-2024', 'Communications', 'G.S.R. 675(E)', 2024, 'so-only', '2024-10-29', 'G.S.R. 675(E)', 'communications', 'amateur-station-operator-rules-2024', 'amateur-station-operator-draft-final'),
  -- Telecom Assistant Recruitment Rules
  ('comms-gsr-762-2024', 'Communications', 'G.S.R. 762(E)', 2024, 'so-only', '2024-12-11', 'G.S.R. 762(E)', 'communications', 'dot-telecom-assistant-rr-2024', 'dot-telecom-assistant-rr-amendment'),
  ('comms-gsr-187-2025', 'Communications', 'G.S.R. 187(E)', 2025, 'so-only', '2025-03-24', 'G.S.R. 187(E)', 'communications', 'dot-telecom-assistant-rr-2024', 'dot-telecom-assistant-rr-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('comms-gsr-863-2025', 'comms-gsr-796-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-771-2025', 'comms-gsr-720-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-625-2025', 'comms-gsr-754-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-413-2026', 'comms-gsr-909-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-796-2020', 'comms-gsr-726-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-113-2022', 'comms-gsr-796-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-423-2025', 'comms-gsr-113-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-so-2962-2025', 'comms-so-3948-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-154-2022', 'comms-gsr-1211-2018', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-682-2024', 'comms-gsr-154-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-675-2024', 'comms-gsr-447-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-187-2025', 'comms-gsr-762-2024', 'amends', 'research-agent-quoted', '2026-09-04');
