-- Ministry of Coal pilot — previously fully deferred (all three real leads
-- found were Note-chain shaped, and that template didn't exist yet). Now
-- modeled using extract.common_templates.find_note_chain, from the same
-- citation+date facts a research agent already reported this session —
-- no new research needed, only the tool to represent what was already found.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('coal', 'Ministry of Coal', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('coal-blocks-allocation-rules-2017', 'Coal Blocks Allocation Rules, 2017', 2017),
  ('colliery-control-rules-2004', 'Colliery Control Rules, 2004', 2004),
  ('coal-mines-pension-scheme-1998', 'Coal Mines Pension Scheme, 1998', 1998);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('coal-blocks-allocation-amendments', 'Coal Blocks Allocation Rules and its amendments', 'active'),
  ('colliery-control-amendments', 'Colliery Control Rules and its amendments', 'active'),
  ('coal-mines-pension-amendments', 'Coal Mines Pension Scheme and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Coal Blocks Allocation Rules chain: 877(E) [2017] -> 300(E) [2020] -> 394(E) [2023] -> 508(E) [2026, current]
  ('coal-gsr-877-2017', 'Coal', 'G.S.R. 877(E)', 2017, 'so-only', '2017-07-13', 'G.S.R. 877(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  ('coal-gsr-300-2020', 'Coal', 'G.S.R. 300(E)', 2020, 'so-only', '2020-05-18', 'G.S.R. 300(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  ('coal-gsr-394-2023', 'Coal', 'G.S.R. 394(E)', 2023, 'so-only', '2023-05-29', 'G.S.R. 394(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  ('coal-gsr-508-2026', 'Coal', 'G.S.R. 508(E)', 2026, 'so-only', '2026-06-22', 'G.S.R. 508(E)', 'coal', 'coal-blocks-allocation-rules-2017', 'coal-blocks-allocation-amendments'),
  -- Colliery Control Rules chain: 540(E) [2004] -> 917(E) [2025] -> 710(E) [2026, current]
  ('coal-gsr-540-2004', 'Coal', 'G.S.R. 540(E)', 2004, 'so-only', '2004-08-25', 'G.S.R. 540(E)', 'coal', 'colliery-control-rules-2004', 'colliery-control-amendments'),
  ('coal-gsr-917-2025', 'Coal', 'G.S.R. 917(E)', 2025, 'so-only', '2025-12-23', 'G.S.R. 917(E)', 'coal', 'colliery-control-rules-2004', 'colliery-control-amendments'),
  ('coal-gsr-710-2026', 'Coal', 'G.S.R. 710(E)', 2026, 'so-only', '2026-08-06', 'G.S.R. 710(E)', 'coal', 'colliery-control-rules-2004', 'colliery-control-amendments'),
  -- Coal Mines Pension Scheme: 18-item Note-chain, only the endpoints this
  -- session captured verbatim (item 1 principal, item 18 most recent named)
  -- are modeled — items 2-17 are real but their individual citations were
  -- not transcribed, so no edge bridges the gap between them.
  ('coal-gsr-123-1998', 'Coal', 'G.S.R. 123(E)', 1998, 'so-only', '1998-03-05', 'G.S.R. 123(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-165-2024', 'Coal', 'G.S.R. 165(E)', 2024, 'so-only', '2024-03-08', 'G.S.R. 165(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments'),
  ('coal-gsr-370-2026', 'Coal', 'G.S.R. 370(E)', 2026, 'so-only', '2026-05-15', 'G.S.R. 370(E)', 'coal', 'coal-mines-pension-scheme-1998', 'coal-mines-pension-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('coal-gsr-300-2020', 'coal-gsr-877-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-394-2023', 'coal-gsr-300-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-508-2026', 'coal-gsr-394-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-917-2025', 'coal-gsr-540-2004', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-710-2026', 'coal-gsr-917-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('coal-gsr-370-2026', 'coal-gsr-165-2024', 'amends', 'research-agent-quoted', '2026-09-04');
