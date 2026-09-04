-- Ministry of New and Renewable Energy pilot. Real chain researched via
-- gazettetracker.com (Full Text section, primary), 2026-09-04.
--
-- No dedicated extractor module: the three notifications reference each
-- other in plain narrative prose ("...was extended up to DATE1 ... vide
-- S.O. 3597(E) ... the implementation ... stands extended till DATE2...")
-- rather than any of the four templates' boilerplate phrasing. Only one
-- real example of this shape has been seen so far, so per this project's
-- own rule (never design a template from a single example), it is not
-- generalized into extract.common_templates yet — modeled directly here
-- instead, the same way Coal/WCD/Petroleum/Rural Development's pure
-- note-chain leads were modeled without new extractor code.
--
-- The chain's true origin, the "Solar Photovoltaics, Systems, Devices and
-- Components Goods (Requirements for Compulsory Registration) Order,
-- 2017" that S.O. 492(E) itself supersedes, is never given a citation
-- number in the quoted text — so that edge is not modeled; the chain
-- starts at S.O. 492(E), the earliest citable node.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('new-and-renewable-energy', 'Ministry of New and Renewable Energy', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('solar-systems-goods-order-2025', 'Solar Systems, Devices and Components Goods Order, 2025', 2025);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('solar-goods-order-self-certification-deadline', 'Solar Systems Goods Order self-certification deadline extensions', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('mnre-so-492-2025',  'MNRE', 'S.O. 492(E)',  2025, 'so-only', '2025-01-27', 'S.O. 492(E)',  'new-and-renewable-energy', 'solar-systems-goods-order-2025', 'solar-goods-order-self-certification-deadline'),
  ('mnre-so-3597-2025', 'MNRE', 'S.O. 3597(E)', 2025, 'so-only', '2025-08-05', 'S.O. 3597(E)', 'new-and-renewable-energy', 'solar-systems-goods-order-2025', 'solar-goods-order-self-certification-deadline'),
  ('mnre-so-3706-2026', 'MNRE', 'S.O. 3706(E)', 2026, 'so-only', '2026-07-03', 'S.O. 3706(E)', 'new-and-renewable-energy', 'solar-systems-goods-order-2025', 'solar-goods-order-self-certification-deadline');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('mnre-so-3597-2025', 'mnre-so-492-2025',  'amends', 'research-agent-quoted', '2026-09-04'),
  ('mnre-so-3706-2026', 'mnre-so-3597-2025', 'amends', 'research-agent-quoted', '2026-09-04');
