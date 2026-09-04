-- Ministry of Statistics and Programme Implementation (MoSPI). Deepened
-- 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the
-- original bounded pass (2 corrigendum pairs). Genuinely small-volume (44
-- total tracked notifications) but not thin on real citation material.
--
-- 4 new subject areas found: an ISI Act Committee amendment (clean
-- amendment-in-notification); the Annual Survey of Industries 2023-24
-- notification, independently amended twice (a hub, not a chain — this
-- closes the previously deferred S.O. 4544(E) lead, whose target is cited
-- only by date + File No., cross-matched here against the target's own
-- Full Text); the NSS North-East Monitoring Committee, reconstituted
-- twice in succession, each time explicitly superseding the SAME two
-- pre-2020 predecessors (a real "same file number reissue that never
-- self-cites its own immediate predecessor" pattern — the 2026
-- reconstitution is NOT modeled as superseding the 2025 one, since
-- neither text says so); and the ACNAS reconstitution, now a confirmed
-- 3-node bare-file-number chain (the file number alone is ambiguous, but
-- each corrigendum also quotes the principal's own e-Gazette press ID,
-- CG-DL-E-28062024-254997, an unambiguous cross-match).
--
-- Real leads NOT modeled: a recurring MoSPI house style where Rules-
-- making/guidelines instruments supersede their predecessor by title/year
-- only, never by number (seen independently in 3 separate 2024-2026
-- notifications: Collection of Statistics Rules 2011->2024, Indian
-- Statistical Service Rules 2016->2026, GSDD 2019->2026); a National
-- Statistical Commission service-conditions amendment whose target is
-- cited as bare "No. 465" with no further identifying number.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('statistics-and-programme-implementation', 'Ministry of Statistics and Programme Implementation', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('assse-jurisdiction-notification-2026', 'ASSSE jurisdiction notification, 2026', 2026),
  ('regional-office-designation-notification-2026', 'Regional-office designation notification, 2026', 2026),
  ('isi-act-1959-s8-committee', 'Indian Statistical Institute Act, 1959 — s.8(1) Committee', 1959),
  ('asi-2023-24-notification', 'Annual Survey of Industries 2023-24 notification', 2024),
  ('nss-northeast-monitoring-committee', 'NSS North-East Zone Monitoring Committee', 2007),
  ('acnas-reconstitution', 'Advisory Committee on National Accounts Statistics (ACNAS) reconstitution', 2024);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('assse-jurisdiction-corrigendum', 'ASSSE jurisdiction corrigendum', 'active'),
  ('regional-office-designation-corrigendum', 'Regional-office designation corrigendum', 'active'),
  ('isi-committee-amendment', 'ISI Act Committee Chairperson substitution', 'active'),
  ('asi-2023-24-amendments', 'ASI 2023-24 notification — two independent Schedule amendments', 'active'),
  ('nss-northeast-committee-supersessions', 'NSS North-East Monitoring Committee successive reconstitutions', 'active'),
  ('acnas-corrigenda', 'ACNAS reconstitution and its two corrigenda', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mospi-so-1398-2026', 'MoSPI', 'S.O. 1398(E)', 2026, 'so-only', '2026-03-16', 'S.O. 1398(E)', 'statistics-and-programme-implementation', 'assse-jurisdiction-notification-2026', 'assse-jurisdiction-corrigendum'),
  ('mospi-so-1767-2026', 'MoSPI', 'S.O. 1767(E)', 2026, 'so-only', '2026-04-01', 'S.O. 1767(E)', 'statistics-and-programme-implementation', 'assse-jurisdiction-notification-2026', 'assse-jurisdiction-corrigendum'),
  ('mospi-so-174-2026',  'MoSPI', 'S.O. 174(E)',  2026, 'so-only', '2026-01-12', 'S.O. 174(E)',  'statistics-and-programme-implementation', 'regional-office-designation-notification-2026', 'regional-office-designation-corrigendum'),
  ('mospi-so-949-2026',  'MoSPI', 'S.O. 949(E)',  2026, 'so-only', '2026-01-30', 'S.O. 949(E)',  'statistics-and-programme-implementation', 'regional-office-designation-notification-2026', 'regional-office-designation-corrigendum'),
  -- ISI Act Committee
  ('mospi-so-4252-2023', 'MoSPI', 'S.O. 4252(E)', 2023, 'so-only', '2023-09-26', 'S.O. 4252(E)', 'statistics-and-programme-implementation', 'isi-act-1959-s8-committee', 'isi-committee-amendment'),
  ('mospi-so-1333-2024', 'MoSPI', 'S.O. 1333(E)', 2024, 'so-only', '2024-03-06', 'S.O. 1333(E)', 'statistics-and-programme-implementation', 'isi-act-1959-s8-committee', 'isi-committee-amendment'),
  -- ASI 2023-24 (hub: two independent amendments)
  ('mospi-so-3047-2024', 'MoSPI', 'S.O. 3047(E)', 2024, 'so-only', '2024-07-25', 'S.O. 3047(E)', 'statistics-and-programme-implementation', 'asi-2023-24-notification', 'asi-2023-24-amendments'),
  ('mospi-so-4232-2024', 'MoSPI', 'S.O. 4232(E)', 2024, 'so-only', '2024-09-18', 'S.O. 4232(E)', 'statistics-and-programme-implementation', 'asi-2023-24-notification', 'asi-2023-24-amendments'),
  ('mospi-so-4544-2024', 'MoSPI', 'S.O. 4544(E)', 2024, 'so-only', '2024-10-11', 'S.O. 4544(E)', 'statistics-and-programme-implementation', 'asi-2023-24-notification', 'asi-2023-24-amendments'),
  -- NSS North-East Monitoring Committee (bare file-number predecessors + 2 reconstitutions)
  ('mospi-file-o120011-1-2004', 'MoSPI', 'No. O-120011/1/2004-Admn.III', 2007, 'bare', '2007-08-01', 'No. O-120011/1/2004-Admn.III', 'statistics-and-programme-implementation', 'nss-northeast-monitoring-committee', 'nss-northeast-committee-supersessions'),
  ('mospi-file-n11011-15-2018', 'MoSPI', 'No. N-11011/15/2018-NSSO(CPD)', 2018, 'bare', '2018-07-12', 'No. N-11011/15/2018-NSSO(CPD)', 'statistics-and-programme-implementation', 'nss-northeast-monitoring-committee', 'nss-northeast-committee-supersessions'),
  ('mospi-file-240-zo-nez-2025', 'MoSPI', 'No. 240/ZO/NEZ/MCM/DES/2022-23', 2025, 'bare', '2025-07-23', 'No. 240/ZO/NEZ/MCM/DES/2022-23', 'statistics-and-programme-implementation', 'nss-northeast-monitoring-committee', 'nss-northeast-committee-supersessions'),
  ('mospi-file-240-zo-nez-2026', 'MoSPI', 'F.No. 240/ZO/NEZ/MCM/DES/2022-23', 2026, 'bare', '2026-01-12', 'F.No. 240/ZO/NEZ/MCM/DES/2022-23', 'statistics-and-programme-implementation', 'nss-northeast-monitoring-committee', 'nss-northeast-committee-supersessions'),
  -- ACNAS reconstitution (bare file number, cross-matched by e-Gazette press ID)
  ('mospi-acnas-principal', 'MoSPI', 'No. U-11014/9/2023-NAD-2B', 2024, 'bare', '2024-06-27', 'No. U-11014/9/2023-NAD-2B', 'statistics-and-programme-implementation', 'acnas-reconstitution', 'acnas-corrigenda'),
  ('mospi-acnas-corr1', 'MoSPI', 'No. U-11014/9/2023-NAD-2B', 2024, 'bare', '2024-07-05', 'No. U-11014/9/2023-NAD-2B', 'statistics-and-programme-implementation', 'acnas-reconstitution', 'acnas-corrigenda'),
  ('mospi-acnas-corr2', 'MoSPI', 'No. U-11014/9/2023-NAD-2B', 2024, 'bare', '2024-10-09', 'No. U-11014/9/2023-NAD-2B', 'statistics-and-programme-implementation', 'acnas-reconstitution', 'acnas-corrigenda');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mospi-so-1767-2026', 'mospi-so-1398-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mospi-so-949-2026',  'mospi-so-174-2026',  'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mospi-so-1333-2024', 'mospi-so-4252-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mospi-so-4232-2024', 'mospi-so-3047-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mospi-so-4544-2024', 'mospi-so-3047-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mospi-file-240-zo-nez-2025', 'mospi-file-o120011-1-2004',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mospi-file-240-zo-nez-2025', 'mospi-file-n11011-15-2018',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mospi-file-240-zo-nez-2026', 'mospi-file-o120011-1-2004',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mospi-file-240-zo-nez-2026', 'mospi-file-n11011-15-2018',  'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('mospi-acnas-corr1', 'mospi-acnas-principal', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mospi-acnas-corr2', 'mospi-acnas-principal', 'corrigendum', 'research-agent-quoted', '2026-09-04');
