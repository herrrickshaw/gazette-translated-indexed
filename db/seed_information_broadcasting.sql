-- Ministry of Information and Broadcasting. Deepened 2026-09-04 (depth
-- pass — see docs/DEPTH_PASS_PLAN.md) beyond the original bounded pass
-- (3 pairs/chains).
--
-- 8 new subject threads found, plus two new edges on already-known nodes
-- (S.O. 2693(E) has a second, independent amendment branch beyond the DD
-- Tamil-renaming chain already modeled; S.O. 3011(E) also supersedes an
-- older sports-events list). The richest find is a 29-node Cable
-- Television Networks Rules, 1994 chain (principal + 27 listed amendments
-- + current), cross-checked against three independently-opened
-- documents' own Notes.
--
-- REAL CITATION COLLISIONS found within that one chain and correctly kept
-- distinct (gazette_id encodes chain position, not the reused citation
-- number, to avoid any ambiguity): "G.S.R. 459(E)" appears twice, 1996 and
-- 2006 (10 years apart); "G.S.R. 719(E)" appears twice, 2000 and 2023 (23
-- years apart) — both textually confirmed as genuinely different real
-- amendments to the same instrument, not transcription errors.
--
-- One date is a documented, unresolved discrepancy rather than a silent
-- pick: G.S.R. 820(E) is dated "29th December, 1995" in one primary
-- source and "28th December, 1995" in another; 1995-12-28 is used here
-- (matching the most-recently-read of the two sources), flagged per this
-- project's established discipline of recording rather than resolving
-- such conflicts.
--
-- Real leads NOT modeled: four Recruitment/Certification Rules
-- supersessions whose superseded targets are cited by title/year only
-- (Cinematograph Certification Rules 1983, two Recruitment Rules of 2013,
-- Prasar Bharati DDA Recruitment Rules 2018); Cinematograph Amendment Act
-- and Jan Vishwas Act commencement notifications, which cite an Act
-- Schedule serial number rather than another gazette notification and so
-- do not fit this schema's notification-to-notification model.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('information-and-broadcasting', 'Ministry of Information and Broadcasting', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('sports-broadcast-mandatory-list-2026', 'Sports Broadcasting Signals (Mandatory Sharing) list notification, 2026', 2026),
  ('press-council-of-india-reconstitution-2023', 'Press Council of India reconstitution, 2023', 2023),
  ('cable-tv-networks-act-1995-channel-designation', 'Cable Television Networks (Regulation) Act, 1995 — DD channel designation', 1995),
  ('press-council-of-india-reconstitution-2021', 'Press Council of India reconstitution notification, 2021 (principal that the 2023 amendments actually target)', 2021),
  ('national-film-awards-69th-2021', '69th National Film Awards, 2021 notification', 2021),
  ('press-council-of-india-members-s5', 'Press Council of India members notified under s.5(3)(b)/(e)', NULL),
  ('cinematograph-act-1952-ua-markers', 'Cinematograph Act, 1952 s.5B(2) — film certification guidelines (UA markers)', 1952),
  ('cinematograph-certification-rules-2024', 'Cinematograph (Certification) Rules, 2024', 2024),
  ('dd-sansad-tv-channel-categories', 'DD/Sansad TV channel categorisation (Cable TV Networks Act, 1995)', 1995),
  ('cable-tv-networks-rules-1994', 'Cable Television Networks Rules, 1994', 1994),
  ('prasar-bharati-dda-recruitment-rules-2023', 'Prasar Bharati (Broadcasting Corporation of India) Deputy Director of Administration Recruitment Rules, 2023', 2023),
  ('press-registration-periodicals-rules-2024', 'Press and Registration of Periodicals Rules, 2024', 2024),
  ('cable-tv-networks-act-1995-registering-authorities', 'Cable Television Networks (Regulation) Act, 1995 — MSO/LCO registering authorities', 1995);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('sports-broadcast-corrigendum', 'Sports Broadcasting mandatory-sharing list corrigendum', 'active'),
  ('press-council-reconstitution-corrigendum', 'Press Council of India reconstitution corrigendum', 'active'),
  ('dd-podhigai-tamil-renaming', 'DD Podhigai to DD Tamil channel renaming and its amendments', 'active'),
  ('press-council-reconstitution-2021-amendments', 'Press Council reconstitution 2021 principal and its amendments', 'active'),
  ('national-film-awards-69th-corrigendum', '69th National Film Awards corrigendum', 'active'),
  ('press-council-members-s5-amendment', 'Press Council of India s.5(3) members notification amendment', 'active'),
  ('ua-markers-film-certification', 'Film certification UA-markers guidelines and its amendments', 'active'),
  ('cinematograph-certification-rules-2024-amendment', 'Cinematograph (Certification) Rules, 2024 amendment', 'active'),
  ('dd-sansad-tv-category-amendment', 'DD/Sansad TV channel category amendment (second branch off S.O. 2693(E))', 'active'),
  ('cable-tv-networks-rules-amendments', 'Cable Television Networks Rules, 1994 and its 27-amendment history', 'active'),
  ('prasar-bharati-dda-recruitment-rules-amendment', 'Prasar Bharati DDA Recruitment Rules, 2023 amendment', 'active'),
  ('press-registration-periodicals-rules-draft', 'Press and Registration of Periodicals Rules, 2024 draft-to-final', 'active'),
  ('mso-lco-registering-authorities', 'MSO/LCO registering authorities supersession', 'superseded');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain (unchanged)
  ('mib-so-3011-2026', 'MIB', 'S.O. 3011(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3011(E)', 'information-and-broadcasting', 'sports-broadcast-mandatory-list-2026', 'sports-broadcast-corrigendum'),
  ('mib-so-3348-2026', 'MIB', 'S.O. 3348(E)', 2026, 'so-only', '2026-06-23', 'S.O. 3348(E)', 'information-and-broadcasting', 'sports-broadcast-mandatory-list-2026', 'sports-broadcast-corrigendum'),
  -- Pair 2: two-node chain (unchanged)
  ('mib-so-2942-2023', 'MIB', 'S.O. 2942(E)', 2023, 'so-only', '2023-07-03', 'S.O. 2942(E)', 'information-and-broadcasting', 'press-council-of-india-reconstitution-2023', 'press-council-reconstitution-corrigendum'),
  ('mib-so-3339-2023', 'MIB', 'S.O. 3339(E)', 2023, 'so-only', '2023-07-21', 'S.O. 3339(E)', 'information-and-broadcasting', 'press-council-of-india-reconstitution-2023', 'press-council-reconstitution-corrigendum'),
  -- Pair 3: eight-node chain (unchanged)
  ('mib-so-2693-2013', 'MIB', 'S.O. 2693(E)', 2013, 'so-only', '2013-09-05', 'S.O. 2693(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-1388-2015', 'MIB', 'S.O. 1388(E)', 2015, 'so-only', '2015-05-25', 'S.O. 1388(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-1699-2019', 'MIB', 'S.O. 1699(E)', 2019, 'so-only', '2019-05-07', 'S.O. 1699(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-4136-2019', 'MIB', 'S.O. 4136(E)', 2019, 'so-only', '2019-11-15', 'S.O. 4136(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-3792-2021', 'MIB', 'S.O. 3792(E)', 2021, 'so-only', '2021-09-15', 'S.O. 3792(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-4796-2021', 'MIB', 'S.O. 4796(E)', 2021, 'so-only', '2021-11-22', 'S.O. 4796(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-2467-2022', 'MIB', 'S.O. 2467(E)', 2022, 'so-only', '2022-05-31', 'S.O. 2467(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-292-2024',  'MIB', 'S.O. 292(E)',  2024, 'so-only', '2024-01-19', 'S.O. 292(E)',  'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  -- Press Council reconstitution 2021 principal + amendments
  ('mib-so-4107-2021', 'MIB', 'S.O. 4107(E)', 2021, 'so-only', '2021-10-06', 'S.O. 4107(E)', 'information-and-broadcasting', 'press-council-of-india-reconstitution-2021', 'press-council-reconstitution-2021-amendments'),
  ('mib-so-4701-2021', 'MIB', 'S.O. 4701(E)', 2021, 'so-only', '2021-11-11', 'S.O. 4701(E)', 'information-and-broadcasting', 'press-council-of-india-reconstitution-2021', 'press-council-reconstitution-2021-amendments'),
  ('mib-so-2943-2023', 'MIB', 'S.O. 2943(E)', 2023, 'so-only', '2023-07-03', 'S.O. 2943(E)', 'information-and-broadcasting', 'press-council-of-india-reconstitution-2021', 'press-council-reconstitution-2021-amendments'),
  -- 69th National Film Awards corrigendum (bare file-number form)
  ('mib-04-19-2021-ffd-notif', 'MIB', '04/19/2021-FFD', 2023, 'bare', '2023-10-12', '04/19/2021-FFD', 'information-and-broadcasting', 'national-film-awards-69th-2021', 'national-film-awards-69th-corrigendum'),
  ('mib-04-19-2021-ffd-corr',  'MIB', '04/19/2021-FFD', 2023, 'bare', '2023-11-07', '04/19/2021-FFD', 'information-and-broadcasting', 'national-film-awards-69th-2021', 'national-film-awards-69th-corrigendum'),
  -- Press Council members s.5(3)
  ('mib-so-5509-2024', 'MIB', 'S.O. 5509(E)', 2024, 'so-only', '2024-12-19', 'S.O. 5509(E)', 'information-and-broadcasting', 'press-council-of-india-members-s5', 'press-council-members-s5-amendment'),
  ('mib-so-5560-2025', 'MIB', 'S.O. 5560(E)', 2025, 'so-only', '2025-12-02', 'S.O. 5560(E)', 'information-and-broadcasting', 'press-council-of-india-members-s5', 'press-council-members-s5-amendment'),
  -- UA markers / film certification guidelines
  ('mib-so-836-1991', 'MIB', 'S.O. 836(E)', 1991, 'so-only', '1991-12-06', 'S.O. 836(E)', 'information-and-broadcasting', 'cinematograph-act-1952-ua-markers', 'ua-markers-film-certification'),
  ('mib-so-655-1997', 'MIB', 'S.O. 655(E)', 1997, 'so-only', '1997-09-15', 'S.O. 655(E)', 'information-and-broadcasting', 'cinematograph-act-1952-ua-markers', 'ua-markers-film-certification'),
  ('mib-so-2440-2025', 'MIB', 'S.O. 2440(E)', 2025, 'so-only', '2025-05-30', 'S.O. 2440(E)', 'information-and-broadcasting', 'cinematograph-act-1952-ua-markers', 'ua-markers-film-certification'),
  -- Cinematograph (Certification) Rules, 2024
  ('mib-gsr-214-2024', 'MIB', 'G.S.R. 214(E)', 2024, 'so-only', '2024-03-15', 'G.S.R. 214(E)', 'information-and-broadcasting', 'cinematograph-certification-rules-2024', 'cinematograph-certification-rules-2024-amendment'),
  ('mib-gsr-385-2026', 'MIB', 'G.S.R. 385(E)', 2026, 'so-only', '2026-05-20', 'G.S.R. 385(E)', 'information-and-broadcasting', 'cinematograph-certification-rules-2024', 'cinematograph-certification-rules-2024-amendment'),
  -- DD/Sansad TV channel categories (second branch off S.O. 2693(E))
  ('mib-so-325-2025', 'MIB', 'S.O. 325(E)', 2025, 'so-only', '2025-01-17', 'S.O. 325(E)', 'information-and-broadcasting', 'dd-sansad-tv-channel-categories', 'dd-sansad-tv-category-amendment'),
  -- Cable Television Networks Rules, 1994 — 29-node chain
  ('mib-ctv-00-1994', 'MIB', 'G.S.R. 729(E)', 1994, 'so-only', '1994-09-29', 'G.S.R. 729(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-01-1995', 'MIB', 'G.S.R. 453(E)', 1995, 'so-only', '1995-05-29', 'G.S.R. 453(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-02-1995', 'MIB', 'G.S.R. 820(E)', 1995, 'so-only', '1995-12-28', 'G.S.R. 820(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-03-1996', 'MIB', 'G.S.R. 459(E)', 1996, 'so-only', '1996-10-08', 'G.S.R. 459(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-04-1999', 'MIB', 'G.S.R. 597(E)', 1999, 'so-only', '1999-08-20', 'G.S.R. 597(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-05-2000', 'MIB', 'G.S.R. 710(E)', 2000, 'so-only', '2000-09-08', 'G.S.R. 710(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-06-2000', 'MIB', 'G.S.R. 719(E)', 2000, 'so-only', '2000-09-13', 'G.S.R. 719(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-07-2001', 'MIB', 'G.S.R. 26(E)',  2001, 'so-only', '2001-01-18', 'G.S.R. 26(E)',  'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-08-2006', 'MIB', 'G.S.R. 282(E)', 2006, 'so-only', '2006-05-11', 'G.S.R. 282(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-09-2006', 'MIB', 'G.S.R. 452(E)', 2006, 'so-only', '2006-07-31', 'G.S.R. 452(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-10-2006', 'MIB', 'G.S.R. 459(E)', 2006, 'so-only', '2006-08-02', 'G.S.R. 459(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-11-2006', 'MIB', 'G.S.R. 469(E)', 2006, 'so-only', '2006-08-09', 'G.S.R. 469(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-12-2006', 'MIB', 'G.S.R. 697(E)', 2006, 'so-only', '2006-11-11', 'G.S.R. 697(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-13-2007', 'MIB', 'G.S.R. 286(E)', 2007, 'so-only', '2007-04-11', 'G.S.R. 286(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-14-2007', 'MIB', 'G.S.R. 482(E)', 2007, 'so-only', '2007-07-12', 'G.S.R. 482(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-15-2007', 'MIB', 'G.S.R. 774(E)', 2007, 'so-only', '2007-12-03', 'G.S.R. 774(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-16-2008', 'MIB', 'G.S.R. 104(E)', 2008, 'so-only', '2008-02-25', 'G.S.R. 104(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-17-2008', 'MIB', 'G.S.R. 413(E)', 2008, 'so-only', '2008-05-29', 'G.S.R. 413(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-18-2009', 'MIB', 'G.S.R. 138(E)', 2009, 'so-only', '2009-02-27', 'G.S.R. 138(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-19-2009', 'MIB', 'G.S.R. 411(E)', 2009, 'so-only', '2009-06-12', 'G.S.R. 411(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-20-2012', 'MIB', 'S.O. 940(E)',   2012, 'so-only', '2012-04-28', 'S.O. 940(E)',   'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-21-2012', 'MIB', 'S.O. 1521(E)',  2012, 'so-only', '2012-07-06', 'S.O. 1521(E)',  'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-22-2015', 'MIB', 'G.S.R. 216(E)', 2015, 'so-only', '2015-03-21', 'G.S.R. 216(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-23-2016', 'MIB', 'G.S.R. 804(E)', 2016, 'so-only', '2016-08-19', 'G.S.R. 804(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-24-2021', 'MIB', 'G.S.R. 416(E)', 2021, 'so-only', '2021-06-17', 'G.S.R. 416(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-25-2023', 'MIB', 'G.S.R. 121',    2023, 'bare',    '2023-09-18', 'G.S.R. 121',    'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-26-2023', 'MIB', 'G.S.R. 719(E)', 2023, 'so-only', '2023-10-03', 'G.S.R. 719(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-27-2025', 'MIB', 'G.S.R. 65(E)',  2025, 'so-only', '2025-01-17', 'G.S.R. 65(E)',  'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  ('mib-ctv-28-2026', 'MIB', 'G.S.R. 751(E)', 2026, 'so-only', '2026-08-21', 'G.S.R. 751(E)', 'information-and-broadcasting', 'cable-tv-networks-rules-1994', 'cable-tv-networks-rules-amendments'),
  -- Prasar Bharati DDA Recruitment Rules, 2023
  ('mib-gsr-678-2023', 'MIB', 'G.S.R. 678(E)', 2023, 'so-only', '2023-09-19', 'G.S.R. 678(E)', 'information-and-broadcasting', 'prasar-bharati-dda-recruitment-rules-2023', 'prasar-bharati-dda-recruitment-rules-amendment'),
  ('mib-gsr-364-2024', 'MIB', 'G.S.R. 364(E)', 2024, 'so-only', '2024-06-21', 'G.S.R. 364(E)', 'information-and-broadcasting', 'prasar-bharati-dda-recruitment-rules-2023', 'prasar-bharati-dda-recruitment-rules-amendment'),
  -- Press and Registration of Periodicals Rules, 2024 (draft-to-final)
  ('mib-so-73-2024',  'MIB', 'S.O. 73(E)',  2024, 'so-only', '2024-01-05', 'S.O. 73(E)',  'information-and-broadcasting', 'press-registration-periodicals-rules-2024', 'press-registration-periodicals-rules-draft'),
  ('mib-gsr-151-2024', 'MIB', 'G.S.R. 151(E)', 2024, 'so-only', '2024-03-01', 'G.S.R. 151(E)', 'information-and-broadcasting', 'press-registration-periodicals-rules-2024', 'press-registration-periodicals-rules-draft'),
  -- New edge: S.O. 2160(E), superseded by the already-known S.O. 3011(E)
  ('mib-so-2160-2022', 'MIB', 'S.O. 2160(E)', 2022, 'so-only', '2022-05-09', 'S.O. 2160(E)', 'information-and-broadcasting', 'sports-broadcast-mandatory-list-2026', 'sports-broadcast-corrigendum'),
  -- MSO/LCO registering authorities
  ('mib-so-718-1994', 'MIB', 'S.O. 718(E)', 1994, 'so-only', '1994-09-29', 'S.O. 718(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-registering-authorities', 'mso-lco-registering-authorities'),
  ('mib-so-315-2025', 'MIB', 'S.O. 315(E)', 2025, 'so-only', '2025-01-17', 'S.O. 315(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-registering-authorities', 'mso-lco-registering-authorities');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mib-so-3348-2026', 'mib-so-3011-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-3339-2023', 'mib-so-2942-2023', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-1388-2015', 'mib-so-2693-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-1699-2019', 'mib-so-1388-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-4136-2019', 'mib-so-1699-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-3792-2021', 'mib-so-4136-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-4796-2021', 'mib-so-3792-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-2467-2022', 'mib-so-4796-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-292-2024',  'mib-so-2467-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Press Council reconstitution 2021 principal + amendments (hub: both 2943 and 2942 amend 4701 directly)
  ('mib-so-4701-2021', 'mib-so-4107-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-2943-2023', 'mib-so-4701-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-2942-2023', 'mib-so-4701-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- 69th National Film Awards
  ('mib-04-19-2021-ffd-corr', 'mib-04-19-2021-ffd-notif', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  -- Press Council members s.5(3)
  ('mib-so-5560-2025', 'mib-so-5509-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- UA markers
  ('mib-so-655-1997',  'mib-so-836-1991', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-2440-2025', 'mib-so-655-1997', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Cinematograph Certification Rules 2024
  ('mib-gsr-385-2026', 'mib-gsr-214-2024', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- DD/Sansad TV categories (second branch off S.O. 2693(E))
  ('mib-so-325-2025', 'mib-so-2693-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Cable TV Networks Rules, 1994 (28 chained edges)
  ('mib-ctv-01-1995', 'mib-ctv-00-1994', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-02-1995', 'mib-ctv-01-1995', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-03-1996', 'mib-ctv-02-1995', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-04-1999', 'mib-ctv-03-1996', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-05-2000', 'mib-ctv-04-1999', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-06-2000', 'mib-ctv-05-2000', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-07-2001', 'mib-ctv-06-2000', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-08-2006', 'mib-ctv-07-2001', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-09-2006', 'mib-ctv-08-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-10-2006', 'mib-ctv-09-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-11-2006', 'mib-ctv-10-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-12-2006', 'mib-ctv-11-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-13-2007', 'mib-ctv-12-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-14-2007', 'mib-ctv-13-2007', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-15-2007', 'mib-ctv-14-2007', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-16-2008', 'mib-ctv-15-2007', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-17-2008', 'mib-ctv-16-2008', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-18-2009', 'mib-ctv-17-2008', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-19-2009', 'mib-ctv-18-2009', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-20-2012', 'mib-ctv-19-2009', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-21-2012', 'mib-ctv-20-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-22-2015', 'mib-ctv-21-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-23-2016', 'mib-ctv-22-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-24-2021', 'mib-ctv-23-2016', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-25-2023', 'mib-ctv-24-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-26-2023', 'mib-ctv-25-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-27-2025', 'mib-ctv-26-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-ctv-28-2026', 'mib-ctv-27-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Prasar Bharati DDA Recruitment Rules
  ('mib-gsr-364-2024', 'mib-gsr-678-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  -- Press and Registration of Periodicals Rules (draft-to-final)
  ('mib-gsr-151-2024', 'mib-so-73-2024', 'cites', 'research-agent-quoted', '2026-09-04'),
  -- New edge on existing sports-broadcast node
  ('mib-so-3011-2026', 'mib-so-2160-2022', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  -- MSO/LCO registering authorities
  ('mib-so-315-2025', 'mib-so-718-1994', 'supersedes', 'research-agent-quoted', '2026-09-04');
