-- Ministry of Tribal Affairs pilot. The ministry's own gazettetracker.com
-- listing has only 2 notifications total; one real amendment pair exists
-- between them, researched 2026-09-04 and modeled via
-- extract/tribal_affairs_patterns.py (corrigendum-substitution template).
--
-- A second real lead (a Scheduled Castes/Scheduled Tribes Orders
-- (Amendment) Act corrigendum) was found but is issued by the Ministry of
-- LAW AND JUSTICE, not Tribal Affairs, and cites only an Act number ("6 of
-- 2024") — both the wrong ministry and a bare/unusable citation form
-- consistent with Law and Justice's full abandonment this project already
-- recorded (see GATES.md history) — not modeled here either.
--
-- Depth pass (2026-09-05): gazettetracker's own listing is still just 2
-- items (drifted to a different pair than the brief described — S.O.
-- 3786(E) was never actually on the listing, only cited by it). All 292
-- ministry slugs and ~1,470 titles across 8 other ministries' listings
-- were keyword-swept for misfiled Tribal Affairs material: none found.
-- The real expansion came from archive.org's `in.gazette.central.e.*`
-- mirror (18 unique MoTA gazettes, 2002-2019, some OCR'd from scans) plus
-- egazette.gov.in PDFs for the 2014+ items: three new subject threads
-- (NCST appointment chain extended back to 2004; a 2002-2004 Scheduled
-- Areas and Scheduled Tribes Commission tenure-extension chain; the 2007
-- draft-to-2008-final Forest Rights Rules pair plus its corrigendum).
-- Five cited targets (S.O. 1271(E)/2002, an unnumbered 20-03-2003
-- amendment, S.O. 1277(E)/2003, S.O. 430(E)/2004, S.O. 427(E)/2011) are
-- named by number and date in primary text but were not independently
-- locatable in any public archive; modeled as stub nodes (no PDF/source
-- beyond the citing quote) rather than left out, since the citation
-- itself is real.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('tribal-affairs', 'Ministry of Tribal Affairs', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('ncst-chairperson-appointment', 'National Commission for Scheduled Tribes Chairperson/Member appointment', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('ncst-chairperson-membership', 'NCST Chairperson/Member appointment and its amendment', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mota-so-3786-2021', 'MoTA', 'S.O. 3786(E)', 2021, 'so-only', '2021-09-15', 'S.O. 3786(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-3566-2023', 'MoTA', 'S.O. 3566(E)', 2023, 'so-only', '2023-08-08', 'S.O. 3566(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mota-so-3566-2023', 'mota-so-3786-2021', 'amends', 'research-agent-quoted', '2026-09-04');

-- New threads found in the 2026-09-05 depth pass:
INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('scheduled-areas-st-commission-art339', 'Scheduled Areas and Scheduled Tribes Commission, article 339(1)', NULL),
  ('forest-rights-rules-2007', 'Scheduled Tribes and Other Traditional Forest Dwellers (Recognition of Forest Rights) Rules', 2007);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('mota-scheduled-areas-st-commission', 'Scheduled Areas and Scheduled Tribes Commission (art. 339) tenure extensions', 'superseded'),
  ('mota-forest-rights-rules-2007-08', 'Scheduled Tribes and Other Traditional Forest Dwellers (Recognition of Forest Rights) Rules, 2007-08 draft to final', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mota-so-274-2004', 'MoTA', 'S.O. 274(E)', 2004, 'so-only', '2004-02-28', 'S.O. 274(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-430-2004', 'MoTA', 'S.O. 430(E)', 2004, 'so-only', '2004-03-31', 'S.O. 430(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-456-2004', 'MoTA', 'S.O. 456(E)', 2004, 'so-only', '2004-04-02', 'S.O. 456(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-1104-2006', 'MoTA', 'S.O. 1104(E)', 2006, 'so-only', '2006-07-13', 'S.O. 1104(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-689-2007', 'MoTA', 'S.O. 689(E)', 2007, 'so-only', '2007-04-30', 'S.O. 689(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-1401-2007', 'MoTA', 'S.O. 1401(E)', 2007, 'so-only', '2007-08-13', 'S.O. 1401(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-1904-2008', 'MoTA', 'S.O. 1904(E)', 2008, 'so-only', '2008-07-31', 'S.O. 1904(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-427-2011', 'MoTA', 'S.O. 427(E)', 2011, 'so-only', '2011-02-24', 'S.O. 427(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-962-2014', 'MoTA', 'S.O. 962(E)', 2014, 'so-only', '2014-03-27', 'S.O. 962(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-963-2014', 'MoTA', 'S.O. 963(E)', 2014, 'so-only', '2014-03-27', 'S.O. 963(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-3866-2024', 'MoTA', 'S.O. 3866(E)', 2024, 'so-only', '2024-09-04', 'S.O. 3866(E)', 'tribal-affairs', 'ncst-chairperson-appointment', 'ncst-chairperson-membership'),
  ('mota-so-1271-2002', 'MoTA', 'S.O. 1271(E)', 2002, 'so-only', '2002-07-18', 'S.O. 1271(E)', 'tribal-affairs', 'scheduled-areas-st-commission-art339', 'mota-scheduled-areas-st-commission'),
  ('mota-so-817-2003', 'MoTA', 'S.O. 817(E)', 2003, 'so-only', '2003-07-17', 'S.O. 817(E)', 'tribal-affairs', 'scheduled-areas-st-commission-art339', 'mota-scheduled-areas-st-commission'),
  ('mota-so-1277-2003', 'MoTA', 'S.O. 1277(E)', 2003, 'so-only', '2003-11-07', 'S.O. 1277(E)', 'tribal-affairs', 'scheduled-areas-st-commission-art339', 'mota-scheduled-areas-st-commission'),
  ('mota-so-362-2004', 'MoTA', 'S.O. 362(E)', 2004, 'so-only', '2004-03-15', 'S.O. 362(E)', 'tribal-affairs', 'scheduled-areas-st-commission-art339', 'mota-scheduled-areas-st-commission'),
  ('mota-gsr-437-2007', 'MoTA', 'G.S.R. 437(E)', 2007, 'so-only', '2007-06-19', 'G.S.R. 437(E)', 'tribal-affairs', 'forest-rights-rules-2007', 'mota-forest-rights-rules-2007-08'),
  ('mota-gsr-1-2008', 'MoTA', 'G.S.R. 1(E)', 2008, 'so-only', '2008-01-01', 'G.S.R. 1(E)', 'tribal-affairs', 'forest-rights-rules-2007', 'mota-forest-rights-rules-2007-08'),
  ('mota-gsr-73-2008', 'MoTA', 'G.S.R. 73(E)', 2008, 'so-only', '2008-02-06', 'G.S.R. 73(E)', 'tribal-affairs', 'forest-rights-rules-2007', 'mota-forest-rights-rules-2007-08');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mota-so-456-2004', 'mota-so-274-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-456-2004', 'mota-so-430-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-1104-2006', 'mota-so-274-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-1104-2006', 'mota-so-430-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-1104-2006', 'mota-so-456-2004', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-689-2007', 'mota-so-274-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-689-2007', 'mota-so-430-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-1401-2007', 'mota-so-274-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-1401-2007', 'mota-so-430-2004', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-1401-2007', 'mota-so-1104-2006', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-962-2014', 'mota-so-427-2011', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-963-2014', 'mota-so-1904-2008', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-817-2003', 'mota-so-1271-2002', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-362-2004', 'mota-so-1271-2002', 'amends', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-362-2004', 'mota-so-817-2003', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('mota-so-362-2004', 'mota-so-1277-2003', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('mota-gsr-1-2008', 'mota-gsr-437-2007', 'cites', 'research-agent-quoted', '2026-09-05'),
  ('mota-gsr-73-2008', 'mota-gsr-1-2008', 'corrigendum', 'research-agent-quoted', '2026-09-05');

