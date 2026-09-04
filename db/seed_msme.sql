-- Ministry of Micro, Small and Medium Enterprises (MSME). Deepened
-- 2026-09-04 (depth pass — see docs/DEPTH_PASS_PLAN.md) beyond the
-- original bounded pass (2 pairs/chains).
--
-- CORRECTION to the existing KVIC membership thread: S.O. 3820(E)'s own
-- operative clause targets S.O. 3193(E) directly (not S.O. 5403(E) as
-- first modeled) — its own trailing Note independently reconfirms S.O.
-- 5403(E) as a SEPARATE amendment to the same principal. Both S.O.
-- 5403(E) and S.O. 3820(E) now correctly amend S.O. 3193(E) independently
-- (a hub, not a linear chain).
--
-- 3 new subject threads found: a TReDS onboarding-mandate supersession (a
-- hub, one preamble naming two superseded numbers); a KVIC government-
-- representative nomination supersession (s.9(3), distinct from the
-- existing s.4/s.7 membership thread); and a Recruitment Rules corrigendum
-- that closes the previously-deferred "GSR 381" lead (now dated and
-- modeled as a bare-form citation, matching this project's precedent for
-- pre-"(E)" numbering).
--
-- Real leads NOT modeled: seven Recruitment Rules supersessions whose
-- targets are cited by title/year only, no G.S.R./S.O./bare number; a
-- Coir Industry Act commencement notification citing only the parent Act;
-- a same-subject 2026 TReDS continuation notification with no citation
-- language at all.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('msme', 'Ministry of Micro, Small and Medium Enterprises', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('msme-classification-notification-2020', 'MSME classification financial-limits notification, 2020', 2020),
  ('kvic-act-1956', 'Khadi and Village Industries Commission Act, 1956 (membership notification)', 1956),
  ('msmed-act-2006-s9-treds-mandate', 'MSMED Act, 2006 s.9 — TReDS onboarding mandate', 2006),
  ('kvic-act-1956-s9-govt-representative', 'Khadi and Village Industries Commission Act, 1956 s.9(3) — Central Government representative nomination', 1956),
  ('msme-recruitment-rules-2000', 'MSME (Assistant Director Gr. I, GAD) Recruitment Rules', 2000);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('msme-classification-limits', 'MSME classification financial limits and their amendments', 'active'),
  ('kvic-membership', 'Khadi and Village Industries Commission membership', 'active'),
  ('msme-treds-mandate-supersession', 'TReDS onboarding-mandate supersession', 'active'),
  ('kvic-govt-representative-supersession', 'KVIC Central Government representative nomination supersession', 'active'),
  ('msme-recruitment-rules-corrigendum', 'MSME Recruitment Rules corrigendum', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: two-node chain
  ('msme-so-2119-2020', 'MSME', 'S.O. 2119(E)', 2020, 'so-only', '2020-06-26', 'S.O. 2119(E)', 'msme', 'msme-classification-notification-2020', 'msme-classification-limits'),
  ('msme-so-1364-2025', 'MSME', 'S.O. 1364(E)', 2025, 'so-only', '2025-03-21', 'S.O. 1364(E)', 'msme', 'msme-classification-notification-2020', 'msme-classification-limits'),
  -- Pair 2: three-node chain (now a hub: 5403 and 3820 both amend 3193 independently)
  ('msme-so-3193-2022', 'MSME', 'S.O. 3193(E)', 2022, 'so-only', '2022-07-14', 'S.O. 3193(E)', 'msme', 'kvic-act-1956', 'kvic-membership'),
  ('msme-so-5403-2022', 'MSME', 'S.O. 5403(E)', 2022, 'so-only', '2022-11-21', 'S.O. 5403(E)', 'msme', 'kvic-act-1956', 'kvic-membership'),
  ('msme-so-3820-2023', 'MSME', 'S.O. 3820(E)', 2023, 'so-only', '2023-08-28', 'S.O. 3820(E)', 'msme', 'kvic-act-1956', 'kvic-membership'),
  -- TReDS onboarding-mandate supersession (hub: one preamble, two targets)
  ('msme-so-5621-2018', 'MSME', 'S.O. 5621(E)', 2018, 'so-only', '2018-11-02', 'S.O. 5621(E)', 'msme', 'msmed-act-2006-s9-treds-mandate', 'msme-treds-mandate-supersession'),
  ('msme-so-5622-2018', 'MSME', 'S.O. 5622(E)', 2018, 'so-only', '2018-11-02', 'S.O. 5622(E)', 'msme', 'msmed-act-2006-s9-treds-mandate', 'msme-treds-mandate-supersession'),
  ('msme-so-4845-2024', 'MSME', 'S.O. 4845(E)', 2024, 'so-only', '2024-11-07', 'S.O. 4845(E)', 'msme', 'msmed-act-2006-s9-treds-mandate', 'msme-treds-mandate-supersession'),
  -- KVIC government-representative nomination
  ('msme-so-2218-2019', 'MSME', 'S.O. 2218(E)', 2019, 'so-only', '2019-06-28', 'S.O. 2218(E)', 'msme', 'kvic-act-1956-s9-govt-representative', 'kvic-govt-representative-supersession'),
  ('msme-so-3533-2023', 'MSME', 'S.O. 3533(E)', 2023, 'so-only', '2023-08-08', 'S.O. 3533(E)', 'msme', 'kvic-act-1956-s9-govt-representative', 'kvic-govt-representative-supersession'),
  -- Recruitment Rules corrigendum (bare-form target)
  ('msme-gsr-381-2000', 'MSME', 'GSR 381', 2000, 'bare', '2000-10-07', 'GSR 381', 'msme', 'msme-recruitment-rules-2000', 'msme-recruitment-rules-corrigendum'),
  ('msme-gsr-524-2023', 'MSME', 'G.S.R. 524(E)', 2023, 'so-only', '2023-07-20', 'G.S.R. 524(E)', 'msme', 'msme-recruitment-rules-2000', 'msme-recruitment-rules-corrigendum');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('msme-so-1364-2025', 'msme-so-2119-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('msme-so-5403-2022', 'msme-so-3193-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('msme-so-3820-2023', 'msme-so-3193-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('msme-so-4845-2024', 'msme-so-5621-2018', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('msme-so-4845-2024', 'msme-so-5622-2018', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('msme-so-3533-2023', 'msme-so-2218-2019', 'supersedes', 'research-agent-quoted', '2026-09-04'),
  ('msme-gsr-524-2023', 'msme-gsr-381-2000', 'corrigendum', 'research-agent-quoted', '2026-09-04');
