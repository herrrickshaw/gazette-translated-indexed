-- Ministry of Communications (Department of Telecommunications) pilot.
--
-- Modeled: G.S.R. 863(E) (25 Nov 2025) rescinds G.S.R. 796(E) (22 Oct 2025)
-- — relation_type 'rescinds', the first rescission modeled (verified_by
-- 'research-agent-quoted').
--
-- Real chain found but only partly modeled — worth reading in full because
-- it is precisely the invisible link this index exists for:
--   G.S.R. 720(E) (21 Nov 2024)  Telecom Cyber Security Rules, 2024 (principal)
--   G.S.R. 771(E) (22 Oct 2025)  Amendment Rules, 2025 — amends 720(E)
--   G.S.R. 796(E) (22 Oct 2025)  appears to be the SAME amendment published
--                                 a second time (published 29 Oct 2025)
--   G.S.R. 863(E) (25 Nov 2025)  rescinds 796(E) — i.e. withdraws the
--                                 duplicate, leaving 771(E) in force
-- Also modeled (2026-09-04): 771->720 (720(E)'s own citation, confirmed on
-- its own page, is what "the principal rules" in 771(E)'s text refers to)
-- and G.S.R. 625(E) amends the Lawful Interception Rules, 2024 (G.S.R.
-- 754(E)) — its further reference to rules 419/419A of the Indian
-- Telegraph Rules, 1951 is a citation to numbered RULES within an Act, not
-- a gazette notification, and stays unmodeled (a different citation form
-- this schema doesn't represent, not a deferred-for-time gap).
--
-- Data-quality flag from the research agent: gazettetracker.com's page
-- TITLE for CG-DL-E-29102025-267236 is a different notification's subject
-- (77-81 GHz automotive radar); its Full Text is G.S.R. 796(E). Trust the
-- Full Text, not the title — third such title mismatch seen this project.
--
-- Not modeled: a Dept. of Posts RPLI-bonus corrigendum
-- (CG-DL-E-09042025-262363) was login-gated on the aggregator; the agent
-- correctly declined to assert its content rather than guess.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('communications', 'Ministry of Communications', 'Department of Telecommunications');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('telecommunications-act-2023-s56', 'Telecommunications Act, 2023 — section 56', 2023);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('lawful-interception-rules-2024', 'Telecommunications (Procedures and Safeguards for Lawful Interception of Messages) Rules, 2024', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('telecom-cyber-security-rules', 'Telecommunications (Telecom Cyber Security) Rules and their amendments', 'active'),
  ('telecom-lawful-interception-rules', 'Lawful Interception Rules and their amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('comms-gsr-796-2025', 'Communications', 'G.S.R. 796(E)', 2025, 'so-only', '2025-10-22', 'G.S.R. 796(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-863-2025', 'Communications', 'G.S.R. 863(E)', 2025, 'so-only', '2025-11-25', 'G.S.R. 863(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-720-2024', 'Communications', 'G.S.R. 720(E)', 2024, 'so-only', '2024-11-21', 'G.S.R. 720(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-771-2025', 'Communications', 'G.S.R. 771(E)', 2025, 'so-only', '2025-10-22', 'G.S.R. 771(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-754-2024', 'Communications', 'G.S.R. 754(E)', 2024, 'so-only', '2024-12-06', 'G.S.R. 754(E)', 'communications', 'lawful-interception-rules-2024', 'telecom-lawful-interception-rules'),
  ('comms-gsr-625-2025', 'Communications', 'G.S.R. 625(E)', 2025, 'so-only', '2025-09-12', 'G.S.R. 625(E)', 'communications', 'lawful-interception-rules-2024', 'telecom-lawful-interception-rules');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('comms-gsr-863-2025', 'comms-gsr-796-2025', 'rescinds', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-771-2025', 'comms-gsr-720-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('comms-gsr-625-2025', 'comms-gsr-754-2024', 'amends', 'research-agent-quoted', '2026-09-04');
