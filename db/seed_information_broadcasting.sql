-- Ministry of Information and Broadcasting pilot. Three real pairs
-- researched via gazettetracker.com (Full Text section, primary),
-- 2026-09-04, modeled via extract/information_broadcasting_patterns.py
-- (pairs 1/2) and the note-chain template (pair 3). Pair 3's own closing
-- clause is labeled "Footnote:" — the real-text find that fixed
-- extract.common_templates.find_note_chain's anchor regex this batch
-- (see tests/test_note_chain.py::test_footnote_variant_is_recognized).

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('information-and-broadcasting', 'Ministry of Information and Broadcasting', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('sports-broadcast-mandatory-list-2026', 'Sports Broadcasting Signals (Mandatory Sharing) list notification, 2026', 2026),
  ('press-council-of-india-reconstitution-2023', 'Press Council of India reconstitution, 2023', 2023),
  ('cable-tv-networks-act-1995-channel-designation', 'Cable Television Networks (Regulation) Act, 1995 — DD channel designation', 1995);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('sports-broadcast-corrigendum', 'Sports Broadcasting mandatory-sharing list corrigendum', 'active'),
  ('press-council-reconstitution-corrigendum', 'Press Council of India reconstitution corrigendum', 'active'),
  ('dd-podhigai-tamil-renaming', 'DD Podhigai to DD Tamil channel renaming and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain
  ('mib-so-3011-2026', 'MIB', 'S.O. 3011(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3011(E)', 'information-and-broadcasting', 'sports-broadcast-mandatory-list-2026', 'sports-broadcast-corrigendum'),
  ('mib-so-3348-2026', 'MIB', 'S.O. 3348(E)', 2026, 'so-only', '2026-06-23', 'S.O. 3348(E)', 'information-and-broadcasting', 'sports-broadcast-mandatory-list-2026', 'sports-broadcast-corrigendum'),
  -- Pair 2: two-node chain
  ('mib-so-2942-2023', 'MIB', 'S.O. 2942(E)', 2023, 'so-only', '2023-07-03', 'S.O. 2942(E)', 'information-and-broadcasting', 'press-council-of-india-reconstitution-2023', 'press-council-reconstitution-corrigendum'),
  ('mib-so-3339-2023', 'MIB', 'S.O. 3339(E)', 2023, 'so-only', '2023-07-21', 'S.O. 3339(E)', 'information-and-broadcasting', 'press-council-of-india-reconstitution-2023', 'press-council-reconstitution-corrigendum'),
  -- Pair 3: eight-node chain (principal + 6 listed amendments + current)
  ('mib-so-2693-2013', 'MIB', 'S.O. 2693(E)', 2013, 'so-only', '2013-09-05', 'S.O. 2693(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-1388-2015', 'MIB', 'S.O. 1388(E)', 2015, 'so-only', '2015-05-25', 'S.O. 1388(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-1699-2019', 'MIB', 'S.O. 1699(E)', 2019, 'so-only', '2019-05-07', 'S.O. 1699(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-4136-2019', 'MIB', 'S.O. 4136(E)', 2019, 'so-only', '2019-11-15', 'S.O. 4136(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-3792-2021', 'MIB', 'S.O. 3792(E)', 2021, 'so-only', '2021-09-15', 'S.O. 3792(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-4796-2021', 'MIB', 'S.O. 4796(E)', 2021, 'so-only', '2021-11-22', 'S.O. 4796(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-2467-2022', 'MIB', 'S.O. 2467(E)', 2022, 'so-only', '2022-05-31', 'S.O. 2467(E)', 'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming'),
  ('mib-so-292-2024',  'MIB', 'S.O. 292(E)',  2024, 'so-only', '2024-01-19', 'S.O. 292(E)',  'information-and-broadcasting', 'cable-tv-networks-act-1995-channel-designation', 'dd-podhigai-tamil-renaming');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mib-so-3348-2026', 'mib-so-3011-2026', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-3339-2023', 'mib-so-2942-2023', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-1388-2015', 'mib-so-2693-2013', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-1699-2019', 'mib-so-1388-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-4136-2019', 'mib-so-1699-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-3792-2021', 'mib-so-4136-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-4796-2021', 'mib-so-3792-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-2467-2022', 'mib-so-4796-2021', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mib-so-292-2024',  'mib-so-2467-2022', 'amends', 'research-agent-quoted', '2026-09-04');
