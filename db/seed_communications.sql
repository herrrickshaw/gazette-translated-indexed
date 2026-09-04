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
-- Only the 863->796 edge is modeled: its target number is stated in the
-- rescinding clause itself. 771->720 is stated only as "the principal
-- rules" in 771(E)'s own text (the number is on 720(E)'s page and in the
-- aggregator's AI summary) — the deferred principal-rules shape.
--
-- Data-quality flag from the research agent: gazettetracker.com's page
-- TITLE for CG-DL-E-29102025-267236 is a different notification's subject
-- (77-81 GHz automotive radar); its Full Text is G.S.R. 796(E). Trust the
-- Full Text, not the title — third such title mismatch seen this project.
--
-- Also real, not modeled: G.S.R. 625(E) (12 Sep 2025) amends the Lawful
-- Interception Rules, 2024 (G.S.R. 754(E), 6 Dec 2024), which itself
-- supersedes rules 419 and 419A of the Indian Telegraph Rules, 1951. A
-- Dept. of Posts RPLI-bonus corrigendum (CG-DL-E-09042025-262363) was
-- login-gated; the agent correctly declined to assert it.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('communications', 'Ministry of Communications', 'Department of Telecommunications');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('telecommunications-act-2023-s56', 'Telecommunications Act, 2023 — section 56', 2023);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('telecom-cyber-security-rules', 'Telecommunications (Telecom Cyber Security) Rules and their amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('comms-gsr-796-2025', 'Communications', 'G.S.R. 796(E)', 2025, 'so-only', '2025-10-22', 'G.S.R. 796(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules'),
  ('comms-gsr-863-2025', 'Communications', 'G.S.R. 863(E)', 2025, 'so-only', '2025-11-25', 'G.S.R. 863(E)', 'communications', 'telecommunications-act-2023-s56', 'telecom-cyber-security-rules');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('comms-gsr-863-2025', 'comms-gsr-796-2025', 'rescinds', 'research-agent-quoted', '2026-09-04');
