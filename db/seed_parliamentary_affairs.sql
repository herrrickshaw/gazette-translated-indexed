-- Ministry of Parliamentary Affairs pilot. Two real pairs researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04, modeled
-- via extract/parliamentary_affairs_patterns.py (corrigendum-substitution
-- + supersession-preamble combined). This ministry's ~28 tracked
-- notifications are otherwise almost entirely staff appointments,
-- retirements, and standalone recruitment rules — these two
-- Aadhaar-authentication notifications (for the Rajya Sabha and Lok
-- Sabha secretariats respectively) are its only real amendment-linkable
-- activity found. A third real lead (Leader of Opposition recognition
-- notifications, under the Salary and Allowances of Leaders of
-- Opposition in Parliament Act, 1977) cites only a bare "F. No."
-- file number and is deliberately not modeled.
--
-- Depth pass 2026-09-04: checked, corpus exhausted. All 28 tracker
-- notifications re-opened (plus 18 egazette PDFs read through the
-- login-truncated tails); both known pairs are closed at 2 nodes (nothing
-- cites G.S.R. 281(E) or G.S.R. 168(E)). The 8 Recruitment Rules, 2025
-- (G.S.R. 504(E)-510(E), 515(E)) each supersede a 2010-2014 predecessor
-- by title/year only, never by number. The Leader of Opposition lead was
-- re-tested against the bare-form rule and still fails: the citing texts
-- refer to the Speaker's act, not to any notification number/date (the
-- Speaker's act was separately gazetted as Lok Sabha Secretariat S.O.
-- 2457(E), 2024-06-26 — linking the two would be an inference across
-- documents, which this project forbids). G.S.R. 507(E)'s reference to
-- re-designation "order number 3/5/2016-Admn., dated 14th June, 2016" is
-- an internal administrative order, not a gazette notification — noted,
-- not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('parliamentary-affairs', 'Ministry of Parliamentary Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('rajya-sabha-aadhaar-authentication-rules', 'Rajya Sabha Secretariat Aadhaar-authentication rules', NULL),
  ('lok-sabha-svms-aadhaar-authentication-rules', 'Lok Sabha Secretariat (SVMS) Aadhaar-authentication rules', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('rajya-sabha-aadhaar-amendment', 'Rajya Sabha Aadhaar-authentication rules amendment', 'active'),
  ('lok-sabha-svms-supersession', 'Lok Sabha SVMS Aadhaar-authentication rules supersession', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain
  ('mopa-gsr-924-2025', 'MoPA', 'G.S.R. 924(E)', 2025, 'so-only', '2025-12-19', 'G.S.R. 924(E)', 'parliamentary-affairs', 'rajya-sabha-aadhaar-authentication-rules', 'rajya-sabha-aadhaar-amendment'),
  ('mopa-gsr-281-2026', 'MoPA', 'G.S.R. 281(E)', 2026, 'so-only', '2026-04-13', 'G.S.R. 281(E)', 'parliamentary-affairs', 'rajya-sabha-aadhaar-authentication-rules', 'rajya-sabha-aadhaar-amendment'),
  -- Pair 2: two-node chain, supersession
  ('mopa-gsr-923-2025', 'MoPA', 'G.S.R. 923(E)', 2025, 'so-only', '2025-12-26', 'G.S.R. 923(E)', 'parliamentary-affairs', 'lok-sabha-svms-aadhaar-authentication-rules', 'lok-sabha-svms-supersession'),
  ('mopa-gsr-168-2026', 'MoPA', 'G.S.R. 168(E)', 2026, 'so-only', '2026-03-10', 'G.S.R. 168(E)', 'parliamentary-affairs', 'lok-sabha-svms-aadhaar-authentication-rules', 'lok-sabha-svms-supersession');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mopa-gsr-281-2026', 'mopa-gsr-924-2025', 'amends',     'research-agent-quoted', '2026-09-04'),
  ('mopa-gsr-168-2026', 'mopa-gsr-923-2025', 'supersedes', 'research-agent-quoted', '2026-09-04');
