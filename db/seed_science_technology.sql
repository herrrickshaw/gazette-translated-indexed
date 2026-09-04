-- Ministry of Science and Technology pilot (Department of Science and
-- Technology / Biotechnology / Scientific and Industrial Research all
-- share one tracker listing). Two real note-chains researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04 — both pure
-- note-chain shapes, no dedicated extractor module.
--
-- Pair 2's principal is cited as "G.S.R. 57" with no "(E)" suffix at all
-- — a bare pre-2023-style form, modeled per the established WCD/DoPT
-- precedent (numbering_form='bare'), a real fact even though the live
-- citation regex can't extract it unaided.
--
-- A third real lead (SERB rescission of two 2014 notifications) cites
-- both rescinded targets only as "number NNN/YYYY/F.No.X" — bare form,
-- deliberately not modeled. Pair 1's own target (G.S.R. 383(E)) also
-- itself supersedes a 2018 Recruitment Rules with no citation number
-- given — that further-back edge is likewise not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('science-and-technology', 'Ministry of Science and Technology', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('soi-stenographer-grade2-rules-2025', 'Survey of India, Stenographer Grade II, Group ''C'' Post Recruitment Rules, 2025', 2025),
  ('staff-car-driver-recruitment-rules-2022', 'Staff Car Driver Recruitment Rules, 2022', 2022);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('soi-stenographer-rules-amendment', 'Survey of India Stenographer Grade II Rules amendment', 'active'),
  ('staff-car-driver-rules-amendment', 'Staff Car Driver Recruitment Rules amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('dst-gsr-383-2025', 'DST', 'G.S.R. 383(E)', 2025, 'so-only', '2025-06-13', 'G.S.R. 383(E)', 'science-and-technology', 'soi-stenographer-grade2-rules-2025', 'soi-stenographer-rules-amendment'),
  ('dst-gsr-635-2026', 'DST', 'G.S.R. 635(E)', 2026, 'so-only', '2026-07-13', 'G.S.R. 635(E)', 'science-and-technology', 'soi-stenographer-grade2-rules-2025', 'soi-stenographer-rules-amendment'),
  ('dst-gsr-57-2022',  'DST', 'G.S.R. 57',     2022, 'bare',    '2022-03-31', 'G.S.R. 57',     'science-and-technology', 'staff-car-driver-recruitment-rules-2022', 'staff-car-driver-rules-amendment'),
  ('dst-gsr-660-2026', 'DST', 'G.S.R. 660(E)', 2026, 'so-only', '2026-07-23', 'G.S.R. 660(E)', 'science-and-technology', 'staff-car-driver-recruitment-rules-2022', 'staff-car-driver-rules-amendment');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('dst-gsr-635-2026', 'dst-gsr-383-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dst-gsr-660-2026', 'dst-gsr-57-2022',  'amends', 'research-agent-quoted', '2026-09-04');
