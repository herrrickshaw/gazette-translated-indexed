-- Ministry of Petroleum and Natural Gas pilot. Three real pairs researched
-- via gazettetracker.com (Full Text section, primary), 2026-09-04.
--
-- Pair 2 (G.S.R. 781(E)) is a DRAFT amendment — published under the
-- ordinary "objections/suggestions within 30 days" rule-making procedure,
-- explicitly not yet in force. Modeled with relation_type='cites' rather
-- than 'amends': a draft doesn't yet amend anything as a matter of law,
-- so 'amends' would overstate what the real document says. If/when a
-- final notification supersedes this draft citation, that's a distinct
-- future notification, not this one.
--
-- Pair 3 — a Resolution (F. No. M-12043(11)/56/2025-OMC-PNG) amending an
-- earlier Resolution (No. P-12029(11)/2/2018-OMC-PNG) — is a bare form
-- with no G.S.R./S.O./S.R.O. number on either side and is deliberately
-- not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('petroleum-and-natural-gas', 'Ministry of Petroleum and Natural Gas', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('petroleum-products-maintenance-order-1999', 'Petroleum Products (Maintenance of Production, Storage and Supply) Order, 1999', 1999),
  ('petroleum-rules-2002', 'Petroleum Rules, 2002', 2002);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('petroleum-products-maintenance-order-amendments', 'Petroleum Products Maintenance Order and its amendments', 'active'),
  ('petroleum-rules-2002-amendments', 'Petroleum Rules, 2002 and its amendments (including a pending draft)', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  -- Pair 1: three-node chain
  ('mopng-gsr-272-1999', 'MoPNG', 'G.S.R. 272(E)', 1999, 'so-only', '1999-04-16', 'G.S.R. 272(E)', 'petroleum-and-natural-gas', 'petroleum-products-maintenance-order-1999', 'petroleum-products-maintenance-order-amendments'),
  ('mopng-gsr-870-2000', 'MoPNG', 'G.S.R. 870(E)', 2000, 'so-only', '2000-11-15', 'G.S.R. 870(E)', 'petroleum-and-natural-gas', 'petroleum-products-maintenance-order-1999', 'petroleum-products-maintenance-order-amendments'),
  ('mopng-gsr-730-2026', 'MoPNG', 'G.S.R. 730(E)', 2026, 'so-only', '2026-08-13', 'G.S.R. 730(E)', 'petroleum-and-natural-gas', 'petroleum-products-maintenance-order-1999', 'petroleum-products-maintenance-order-amendments'),
  -- Pair 2: three-node chain, current item is a draft (not yet in force)
  ('mopng-gsr-204-2002', 'MoPNG', 'G.S.R. 204(E)', 2002, 'so-only', '2002-03-13', 'G.S.R. 204(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments'),
  ('mopng-gsr-154-2024', 'MoPNG', 'G.S.R. 154(E)', 2024, 'so-only', '2024-03-04', 'G.S.R. 154(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments'),
  ('mopng-gsr-781-2026', 'MoPNG', 'G.S.R. 781(E)', 2026, 'so-only', '2026-08-03', 'G.S.R. 781(E)', 'petroleum-and-natural-gas', 'petroleum-rules-2002', 'petroleum-rules-2002-amendments');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mopng-gsr-870-2000', 'mopng-gsr-272-1999', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-730-2026', 'mopng-gsr-870-2000', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-154-2024', 'mopng-gsr-204-2002', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('mopng-gsr-781-2026', 'mopng-gsr-154-2024', 'cites',  'research-agent-quoted', '2026-09-04');
