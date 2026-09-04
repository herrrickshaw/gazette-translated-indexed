-- Ministry of Women and Child Development pilot — previously fully
-- deferred (one lead cited a 1979 "then Department of Social Welfare",
-- which the ministry-name scope guard on the other two templates can't
-- match; the other was a Note-chain, which didn't have a template yet).
-- find_note_chain has no ministry-name parameter at all — it matches on
-- "note" and citation syntax alone — so the department-rename problem
-- turned out not to block this template; only the missing tool did.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('women-child-development', 'Ministry of Women and Child Development', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('charitable-endowments-act-1890', 'Charitable Endowments Act, 1890 — National Children''s Fund', 1890),
  ('ncpcr-rules-2006', 'National Commission for Protection of Child Rights Rules, 2006', 2006);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('wcd-national-childrens-fund', 'National Children''s Fund notification and its amendments', 'active'),
  ('wcd-ncpcr-rules-amendments', 'NCPCR Rules and their amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- National Children's Fund chain: S.O. 120(E) [1979, "then Dept. of Social
  -- Welfare" — a real ministry-reorganization case, kept as printed] ->
  -- S.O. 2071 [1980, bare form, pre-dates the modern citation convention] ->
  -- S.O. 1311(E) [2004] -> S.O. 4423(E) [2026, current]
  ('wcd-so-120-1979', 'WCD', 'S.O. 120(E)', 1979, 'so-only', '1979-03-02', 'S.O. 120(E)', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  ('wcd-so-2071-1980', 'WCD', 'S.O. 2071', 1980, 'bare', '1980-07-28', 'S.O. 2071', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  ('wcd-so-1311-2004', 'WCD', 'S.O. 1311(E)', 2004, 'so-only', '2004-11-24', 'S.O. 1311(E)', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  ('wcd-so-4423-2026', 'WCD', 'S.O. 4423(E)', 2026, 'so-only', '2026-06-08', 'S.O. 4423(E)', 'women-child-development', 'charitable-endowments-act-1890', 'wcd-national-childrens-fund'),
  -- NCPCR Rules chain: 450(E) [2006] -> 517(E) [2012] -> 207(E) [Mar 2014]
  -- -> 315(E) [May 2014] -> 613(E) [2021] -> 75(E) [2026, current]. No
  -- founding G.S.R. was captured for the 2006 principal rules themselves —
  -- the chain starts at its first named amendment, not a fabricated origin.
  ('wcd-gsr-450-2006', 'WCD', 'G.S.R. 450(E)', 2006, 'so-only', '2006-07-31', 'G.S.R. 450(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-517-2012', 'WCD', 'G.S.R. 517(E)', 2012, 'so-only', '2012-06-29', 'G.S.R. 517(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-207-2014', 'WCD', 'G.S.R. 207(E)', 2014, 'so-only', '2014-03-24', 'G.S.R. 207(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-315-2014', 'WCD', 'G.S.R. 315(E)', 2014, 'so-only', '2014-05-06', 'G.S.R. 315(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-613-2021', 'WCD', 'G.S.R. 613(E)', 2021, 'so-only', '2021-09-03', 'G.S.R. 613(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments'),
  ('wcd-gsr-75-2026', 'WCD', 'G.S.R. 75(E)', 2026, 'so-only', '2026-01-30', 'G.S.R. 75(E)', 'women-child-development', 'ncpcr-rules-2006', 'wcd-ncpcr-rules-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('wcd-so-2071-1980', 'wcd-so-120-1979', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-so-1311-2004', 'wcd-so-2071-1980', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-so-4423-2026', 'wcd-so-1311-2004', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-517-2012', 'wcd-gsr-450-2006', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-207-2014', 'wcd-gsr-517-2012', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-315-2014', 'wcd-gsr-207-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-613-2021', 'wcd-gsr-315-2014', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('wcd-gsr-75-2026', 'wcd-gsr-613-2021', 'amends', 'research-agent-quoted', '2026-09-04');
