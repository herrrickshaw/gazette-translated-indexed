-- Ministry of Railways pilot.
--
-- Modeled: S.O. 4815(E) corrects survey numbers in S.O. 2950(E) — the South
-- Western Railway (Construction Organisation) example, verified_by
-- 'research-agent-quoted'. This is the exact "minor survey-number
-- correction, hard to trace back" pattern the whole project targets.
--
-- Note: S.O. 2950(E) is cited as "dated 08.09.2026" in the corrigendum's own
-- primary text, which post-dates the corrigendum itself (31 Aug 2026) — an
-- internal inconsistency in the source document (likely an OCR/typo
-- artifact), flagged by the research agent and kept as printed rather than
-- silently corrected.
--
-- Real leads found but NOT modeled here (each from a different zonal
-- railway division, each in a visibly different corrigendum format —
-- confirming zonal divisions draft somewhat independently even within one
-- ministry):
--   - Central Railway: corrigendum to E-Gazette Notification No. 5681
--     (16 Dec 2025, S.O. 5877(E)), issued as S.O. 2196(E) on 29 Apr 2026 —
--     cites the original by gazette issue number, not directly by S.O.
--     number, in the quoted text.
--   - Western Railway (Construction Organization): S.O. 4509(E)
--     (14 Oct 2023) "supersedes" S.O. 4445(E) (11 Oct 2023) — uses
--     "supersedes", not a corrigendum-substitution phrase; the original's
--     own gazette page/ID was not independently located.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('railways', 'Ministry of Railways', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('railways-act-1989-s20', 'Railways Act, 1989 — section 20A/20E land acquisition', 1989);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('railways-land-acquisition-corrections', 'Railways land-acquisition notifications and their corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('railways-so-2950-2026', 'Railways Act 1989', 'S.O. 2950(E)', 2026, 'so-only', '2026-09-08', 'S.O. 2950(E)', 'railways', 'railways-act-1989-s20', 'railways-land-acquisition-corrections'),
  ('railways-so-4815-2026', 'Railways Act 1989', 'S.O. 4815(E)', 2026, 'so-only', '2026-08-31', 'S.O. 4815(E)', 'railways', 'railways-act-1989-s20', 'railways-land-acquisition-corrections');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('railways-so-4815-2026', 'railways-so-2950-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03');
