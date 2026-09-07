-- Ministry of Youth Affairs and Sports pilot. One real pair researched
-- via gazettetracker.com (Full Text section, primary), 2026-09-04,
-- modeled via extract/youth_affairs_sports_patterns.py (corrigendum-
-- substitution template, a real one-to-many example naming three
-- predecessor notifications in one clause).
--
-- This ministry's 2025-26 gazette activity is dominated by fresh
-- subordinate legislation under two new Acts (National Sports Governance
-- Act 2025, National Anti-Doping Act 2022) rather than amendments to
-- prior numbered instruments — a real, checked finding, not a research
-- gap. A second real lead (Khelo India Directorate renaming) cites its
-- target only as "Gazette Notification dated 04th March, 2022" — no
-- G.S.R./S.O. number at all — and is deliberately not modeled.
--
-- Depth pass (2026-09-05): the ministry's entire tracked corpus (24 items,
-- 1 listing page, egazette PDF-verified for every truncated Full Text) was
-- re-read in full. No new number/date-cited cross-reference exists beyond
-- the S.O. 2292(E) cluster above. Two candidate edges were found and
-- deliberately NOT modeled because the citing text names the target by
-- short title only, not by number or date (same "real but title-only"
-- discipline as elsewhere in this project): G.S.R. 404(E) [National
-- Sports Governance (National Sports Board) Rules, 2026] references both
-- the National Sports Board (Search-cum-Selection Committee) Rules, 2026
-- (= G.S.R. 12(E), 2026-01-08) and the National Sports Governance
-- (National Sports Bodies) Rules, 2026 (= G.S.R. 18(E), 2026-01-12) by
-- title in three separate clauses; both targets are unambiguous and
-- in-corpus but the citing text gives no G.S.R. number for either. The
-- Khelo India Directorate renaming lead (above) was re-checked: secondary
-- sources (an IIPA bibliography) identify the target as "F. No.
-- 40-1/MYAS/MDSD/2020 dated 04-03-2022", confirming it is a Part I
-- Section 1 file-number-only notification with no S.O./G.S.R. at all --
-- not a gap to close, there is no number to find. The 2026 Khelo India
-- Scheme renewal (F. No. K-15018/8/2026-KID) does not cite its 2022
-- predecessor at all, gazetted or otherwise.
--
-- Second depth-pass re-check (2026-09-07): dispatched independently of the
-- 2026-09-05 pass above, before knowing it had already run. gazettetracker.com's
-- ministry listing for Youth Affairs and Sports still shows the identical
-- 24 items (same gazette IDs, same dates) -- no new notification has been
-- indexed since 2026-09-05. Its "Full Text" section is now gated behind a
-- login wall on every item (a real site change from when the first depth
-- pass ran, worth recording for future batches), so this re-check instead
-- fetched the primary source directly -- egazette.gov.in's deterministic
-- WriteReadData/<year>/<gazette-id>.pdf URL -- for all 20 of the 24 items
-- not already modeled above, and grepped the extracted text (pdftotext) for
-- every citation/amendment keyword this project's templates recognize
-- (G.S.R./S.O., "supersession", "partial modification", "rescind",
-- "corrigendum", "substituted", "Note:", "last amended", "vide", etc.).
-- None hit. Concretely: the NSGA/NADA rule-making wave (G.S.R. 404(E)/
-- 405(E)/637(E)/638(E)/641(E)/678(E), S.O. 3898(E)/3929(E)/2406(E)/4566(E))
-- is each a first-instance rule or bare commencement notification citing
-- only its own parent Act section, not any prior numbered notification.
-- The Aadhaar-DBT notifications (ANSF, Scouting & Guiding, Academic
-- Training, Youth Hostel, Scholarship, National Youth Corps, plus SAI
-- Aadhaar authentication) each cite only a bare Cabinet Secretariat Office
-- Memorandum (No. D-26011/04/2017-DBT, dated 19th December, 2017) -- a
-- file-numbered OM, not a G.S.R./S.O./S.R.O., so correctly out of this
-- schema's scope per the same rule used throughout this project. G.S.R.
-- 404(E) (NSB Rules 2026) was independently re-read in full from the PDF
-- and still only names its two sibling instruments by title (no number),
-- confirming rather than adding to the 2026-09-05 finding. No file in this
-- repo besides this paragraph was changed by this second check.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('youth-affairs-and-sports', 'Ministry of Youth Affairs and Sports', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('nsdf-council-composition', 'National Sports Development Fund (NSDF) Council composition', NULL);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('nsdf-council-modification', 'NSDF Council composition and its modifications', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('moyas-so-973-1998',  'MoYAS', 'S.O. 973(E)',  1998, 'so-only', '1998-11-12', 'S.O. 973(E)',  'youth-affairs-and-sports', 'nsdf-council-composition', 'nsdf-council-modification'),
  ('moyas-so-525-2012',  'MoYAS', 'S.O. 525(E)',  2012, 'so-only', '2012-03-22', 'S.O. 525(E)',  'youth-affairs-and-sports', 'nsdf-council-composition', 'nsdf-council-modification'),
  ('moyas-so-4478-2019', 'MoYAS', 'S.O. 4478(E)', 2019, 'so-only', '2019-12-17', 'S.O. 4478(E)', 'youth-affairs-and-sports', 'nsdf-council-composition', 'nsdf-council-modification'),
  ('moyas-so-2292-2025', 'MoYAS', 'S.O. 2292(E)', 2025, 'so-only', '2025-05-21', 'S.O. 2292(E)', 'youth-affairs-and-sports', 'nsdf-council-composition', 'nsdf-council-modification');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('moyas-so-2292-2025', 'moyas-so-973-1998',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moyas-so-2292-2025', 'moyas-so-525-2012',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('moyas-so-2292-2025', 'moyas-so-4478-2019', 'amends', 'research-agent-quoted', '2026-09-04');
