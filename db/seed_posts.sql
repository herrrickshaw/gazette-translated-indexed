-- Department of Posts (Ministry of Communications) pilot. A 4-node chain
-- researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04, distinct from the Department of Telecommunications side of
-- this ministry already modeled in db/seed_communications.sql. Pure
-- note-chain shape (extract.common_templates.find_note_chain,
-- already tested), no new extractor code.
--
-- The Sixth Amendment (S.O. 4241(E)) was independently confirmed on its
-- own gazette page; S.O. 4053(E) (the Fifth Amendment) was not
-- independently opened this session but is quoted directly from the
-- Sixth Amendment's own primary Note text, the same evidentiary standard
-- used throughout this project.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('posts', 'Ministry of Communications', 'Department of Posts');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('post-office-regulations-2024', 'Post Office Regulations, 2024', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('post-office-regulations-amendments', 'Post Office Regulations, 2024 and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('dop-so-5440-2024', 'DoP', 'S.O. 5440(E)', 2024, 'so-only', '2024-12-16', 'S.O. 5440(E)', 'posts', 'post-office-regulations-2024', 'post-office-regulations-amendments'),
  ('dop-so-4053-2026', 'DoP', 'S.O. 4053(E)', 2026, 'so-only', '2026-07-23', 'S.O. 4053(E)', 'posts', 'post-office-regulations-2024', 'post-office-regulations-amendments'),
  ('dop-so-4241-2026', 'DoP', 'S.O. 4241(E)', 2026, 'so-only', '2026-07-31', 'S.O. 4241(E)', 'posts', 'post-office-regulations-2024', 'post-office-regulations-amendments'),
  ('dop-so-4537-2026', 'DoP', 'S.O. 4537(E)', 2026, 'so-only', '2026-08-12', 'S.O. 4537(E)', 'posts', 'post-office-regulations-2024', 'post-office-regulations-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('dop-so-4053-2026', 'dop-so-5440-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dop-so-4241-2026', 'dop-so-4053-2026', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dop-so-4537-2026', 'dop-so-4241-2026', 'amends', 'research-agent-quoted', '2026-09-04');
