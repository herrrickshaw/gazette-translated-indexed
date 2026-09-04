-- Ministry of Personnel, Public Grievances and Pensions (Department of
-- Personnel and Training) pilot. Three real notifications researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04.
--
-- Pairs 1/2 are a genuine real oddity, not a research error: TWO
-- separately-numbered corrigenda (G.S.R. 471(E) and G.S.R. 472(E)), both
-- dated 11 June 2026, both making the IDENTICAL correction to the same
-- target G.S.R. 331(E) — two distinct real gazette entries, kept as two
-- distinct rows rather than merged or treated as a duplicate to clean up.
--
-- Pair 3's principal notification is cited only as "S.O. 3703" (no "(E)"
-- suffix at all — a pre-1965 bare form, the same class of gap as the
-- CBIC pre-1994 bare numbers and Ministry of WCD's "S.O. 2071"). Modeled
-- as a real row (numbering_form='bare') per that established precedent,
-- even though the live citation regex can't extract it from raw text —
-- this is a hand/agent-verified fact, not something the automated
-- extractor needs to discover unaided.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('personnel-public-grievances-pensions', 'Ministry of Personnel, Public Grievances and Pensions', 'Department of Personnel and Training');

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('ais-cadre-post-designation-2025', 'All India Services cadre post-designation notification, 2025', 2025),
  ('ccs-cca-rules-1965', 'Central Civil Services (Classification, Control and Appeal) Rules, 1965', 1965);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('ais-post-designation-corrigenda', 'AIS cadre post-designation corrigenda (two separate real entries)', 'active'),
  ('ccs-cca-rules-amendments', 'CCS (CCA) Rules, 1965 and its amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pairs 1/2: one target, two independent corrigenda
  ('dopt-gsr-331-2025', 'DoPT', 'G.S.R. 331(E)', 2025, 'so-only', '2025-05-21', 'G.S.R. 331(E)', 'personnel-public-grievances-pensions', 'ais-cadre-post-designation-2025', 'ais-post-designation-corrigenda'),
  ('dopt-gsr-471-2026', 'DoPT', 'G.S.R. 471(E)', 2026, 'so-only', '2026-06-11', 'G.S.R. 471(E)', 'personnel-public-grievances-pensions', 'ais-cadre-post-designation-2025', 'ais-post-designation-corrigenda'),
  ('dopt-gsr-472-2026', 'DoPT', 'G.S.R. 472(E)', 2026, 'so-only', '2026-06-11', 'G.S.R. 472(E)', 'personnel-public-grievances-pensions', 'ais-cadre-post-designation-2025', 'ais-post-designation-corrigenda'),
  -- Pair 3: three-node chain, principal in bare pre-1965 form
  ('dopt-so-3703-1965', 'DoPT', 'S.O. 3703', 1965, 'bare', '1965-11-20', 'S.O. 3703', 'personnel-public-grievances-pensions', 'ccs-cca-rules-1965', 'ccs-cca-rules-amendments'),
  ('dopt-gsr-337-2024', 'DoPT', 'G.S.R. 337(E)', 2024, 'so-only', '2024-05-29', 'G.S.R. 337(E)', 'personnel-public-grievances-pensions', 'ccs-cca-rules-1965', 'ccs-cca-rules-amendments'),
  ('dopt-gsr-21-2026',  'DoPT', 'G.S.R. 21(E)',  2026, 'so-only', '2026-01-12', 'G.S.R. 21(E)',  'personnel-public-grievances-pensions', 'ccs-cca-rules-1965', 'ccs-cca-rules-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('dopt-gsr-471-2026', 'dopt-gsr-331-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('dopt-gsr-472-2026', 'dopt-gsr-331-2025', 'corrigendum', 'research-agent-quoted', '2026-09-04'),
  ('dopt-gsr-337-2024', 'dopt-so-3703-1965', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('dopt-gsr-21-2026',  'dopt-gsr-337-2024', 'amends', 'research-agent-quoted', '2026-09-04');
