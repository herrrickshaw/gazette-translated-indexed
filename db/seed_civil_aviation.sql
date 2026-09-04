-- Ministry of Civil Aviation. Deepened 2026-09-04 (depth pass — see
-- docs/DEPTH_PASS_PLAN.md) beyond the original 2-pair pass.
--
-- Eight further real pairs/chains found, several of them the standard
-- Indian rule-making pattern of a draft notification (published under
-- Section 23 for objections/suggestions) followed by a final notification
-- finalizing it unchanged — modeled with relation_type='cites' for the
-- draft-to-final link (the same convention already used for Petroleum's
-- own draft notification), since a draft has no independent legal effect
-- of its own to "amend".
--
-- Aircraft Rules, 1937 (the long-history instrument specifically checked)
-- has a real bare pre-independence principal citation ("V-26", dated 23
-- March 1937 — not even in G.S.R./S.O. form at all) — modeled as a real
-- historical fact per the established bare-form precedent, even though
-- the live citation regex can't discover it unaided.
--
-- Four further real leads are supersessions with NO usable citation on
-- the superseded side (Aircraft Demolition of Obstructions Rules, 1994;
-- Aircraft Carriage of Dangerous Goods Rules, 2003; Aircraft Security
-- Rules, 2011; a DGCA Recruitment Rules supersession) plus one bare
-- file-number-only supersession (Diu aerodrome licensing) — deliberately
-- not modeled.

INSERT OR IGNORE INTO ministry (ministry_id, name, department) VALUES
  ('civil-aviation', 'Ministry of Civil Aviation', NULL);

INSERT OR IGNORE INTO act_or_rule (instrument_id, title, year) VALUES
  ('protection-interests-aircraft-objects-rules-2026', 'Protection of Interests in Aircraft Objects Rules, 2026', 2026),
  ('aircraft-investigation-accidents-incidents-rules-2025', 'Aircraft (Investigation of Accidents and Incidents) Rules, 2025', 2025),
  ('aircraft-demolition-obstructions-rules-2026', 'Aircraft (Demolition of Obstructions caused by Buildings and Trees etc.) Rules, 2026', 2026),
  ('aircraft-carriage-dangerous-goods-rules-2026', 'Aircraft (Carriage of Dangerous Goods) Rules, 2026', 2026),
  ('carriage-by-air-act-1972-third-schedule', 'Carriage by Air Act, 1972 — Third Schedule liability limits', 1972),
  ('bcas-deputy-aviation-security-officer-rr', 'BCAS Deputy Aviation Security Officer, Group C Posts Recruitment Rules', NULL),
  ('aircraft-rules-1937', 'Aircraft Rules, 1937', 1937),
  ('aircraft-security-rules-2023', 'Aircraft (Security) Rules, 2023', 2023),
  ('height-restrictions-safeguarding-aircraft-rules-2015', 'Height Restrictions for Safeguarding of Aircraft Operations Rules, 2015', 2015);

INSERT OR IGNORE INTO subject_thread (thread_id, subject_summary, status) VALUES
  ('civil-aviation-corrections', 'Ministry of Civil Aviation notification corrigenda', 'active'),
  ('civil-aviation-accident-investigation-rules', 'Aircraft accident-investigation rules and their amendments', 'active'),
  ('civil-aviation-demolition-obstructions-rules', 'Aircraft demolition-of-obstructions rules, draft to final', 'active'),
  ('civil-aviation-dangerous-goods-rules', 'Aircraft carriage-of-dangerous-goods rules, draft to final', 'active'),
  ('civil-aviation-carriage-by-air-liability', 'Carriage by Air Act liability-limit revisions', 'active'),
  ('civil-aviation-bcas-security-officer-rr', 'BCAS Deputy Aviation Security Officer Recruitment Rules amendments', 'active'),
  ('civil-aviation-aircraft-rules-1937', 'Aircraft Rules, 1937 and its amendment history', 'active'),
  ('civil-aviation-security-rules', 'Aircraft Security Rules and their amendment', 'active'),
  ('civil-aviation-height-restrictions', 'Height Restrictions for Safeguarding Aircraft Operations Rules and their amendments', 'active');

INSERT OR IGNORE INTO gazette_notification
  (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id, instrument_id, thread_id)
VALUES
  ('civav-gsr-77-2026', 'Civil Aviation', 'G.S.R. 77(E)', 2026, 'so-only', '2026-01-30', 'G.S.R. 77(E)', 'civil-aviation', 'protection-interests-aircraft-objects-rules-2026', 'civil-aviation-corrections'),
  ('civav-gsr-124-2026', 'Civil Aviation', 'G.S.R. 124(E)', 2026, 'so-only', '2026-02-12', 'G.S.R. 124(E)', 'civil-aviation', 'protection-interests-aircraft-objects-rules-2026', 'civil-aviation-corrections'),
  -- Accident Investigation Rules: draft (G.S.R. 136(E)) then final (already known G.S.R. 647(E))
  ('civav-gsr-829-2025', 'Civil Aviation', 'G.S.R. 829(E)', 2025, 'so-only', '2025-11-07', 'G.S.R. 829(E)', 'civil-aviation', 'aircraft-investigation-accidents-incidents-rules-2025', 'civil-aviation-accident-investigation-rules'),
  ('civav-gsr-136-2026', 'Civil Aviation', 'G.S.R. 136(E)', 2026, 'so-only', '2026-02-17', 'G.S.R. 136(E)', 'civil-aviation', 'aircraft-investigation-accidents-incidents-rules-2025', 'civil-aviation-accident-investigation-rules'),
  ('civav-gsr-647-2026', 'Civil Aviation', 'G.S.R. 647(E)', 2026, 'so-only', '2026-07-17', 'G.S.R. 647(E)', 'civil-aviation', 'aircraft-investigation-accidents-incidents-rules-2025', 'civil-aviation-accident-investigation-rules'),
  -- Demolition of Obstructions Rules: draft then final
  ('civav-gsr-396-2025', 'Civil Aviation', 'G.S.R. 396(E)', 2025, 'so-only', '2025-06-18', 'G.S.R. 396(E)', 'civil-aviation', 'aircraft-demolition-obstructions-rules-2026', 'civil-aviation-demolition-obstructions-rules'),
  ('civav-gsr-236-2026', 'Civil Aviation', 'G.S.R. 236(E)', 2026, 'so-only', '2026-03-31', 'G.S.R. 236(E)', 'civil-aviation', 'aircraft-demolition-obstructions-rules-2026', 'civil-aviation-demolition-obstructions-rules'),
  -- Carriage of Dangerous Goods Rules: draft then final
  ('civav-gsr-397-2025', 'Civil Aviation', 'G.S.R. 397(E)', 2025, 'so-only', '2025-06-18', 'G.S.R. 397(E)', 'civil-aviation', 'aircraft-carriage-dangerous-goods-rules-2026', 'civil-aviation-dangerous-goods-rules'),
  ('civav-gsr-137-2026', 'Civil Aviation', 'G.S.R. 137(E)', 2026, 'so-only', '2026-02-17', 'G.S.R. 137(E)', 'civil-aviation', 'aircraft-carriage-dangerous-goods-rules-2026', 'civil-aviation-dangerous-goods-rules'),
  -- Carriage by Air Act liability limits
  ('civav-so-987-2020',  'Civil Aviation', 'S.O. 987(E)',  2020, 'so-only', '2020-03-02', 'S.O. 987(E)',  'civil-aviation', 'carriage-by-air-act-1972-third-schedule', 'civil-aviation-carriage-by-air-liability'),
  ('civav-so-1694-2026', 'Civil Aviation', 'S.O. 1694(E)', 2026, 'so-only', '2026-04-01', 'S.O. 1694(E)', 'civil-aviation', 'carriage-by-air-act-1972-third-schedule', 'civil-aviation-carriage-by-air-liability'),
  -- BCAS Deputy Aviation Security Officer RR
  ('civav-gsr-873-2017', 'Civil Aviation', 'G.S.R. 873(E)', 2017, 'so-only', '2017-07-13', 'G.S.R. 873(E)', 'civil-aviation', 'bcas-deputy-aviation-security-officer-rr', 'civil-aviation-bcas-security-officer-rr'),
  ('civav-gsr-816-2019', 'Civil Aviation', 'G.S.R. 816(E)', 2019, 'so-only', '2019-10-23', 'G.S.R. 816(E)', 'civil-aviation', 'bcas-deputy-aviation-security-officer-rr', 'civil-aviation-bcas-security-officer-rr'),
  ('civav-gsr-123-2026', 'Civil Aviation', 'G.S.R. 123(E)', 2026, 'so-only', '2026-02-11', 'G.S.R. 123(E)', 'civil-aviation', 'bcas-deputy-aviation-security-officer-rr', 'civil-aviation-bcas-security-officer-rr'),
  -- Aircraft Rules, 1937 — bare pre-independence principal, two cited-only drafts, one confirmed prior amendment
  ('civav-v26-1937',     'Civil Aviation', 'V-26',         1937, 'bare',    '1937-03-23', 'V-26',         'civil-aviation', 'aircraft-rules-1937', 'civil-aviation-aircraft-rules-1937'),
  ('civav-gsr-289-2022', 'Civil Aviation', 'G.S.R. 289(E)', 2022, 'so-only', '2022-04-08', 'G.S.R. 289(E)', 'civil-aviation', 'aircraft-rules-1937', 'civil-aviation-aircraft-rules-1937'),
  ('civav-gsr-520-2022', 'Civil Aviation', 'G.S.R. 520(E)', 2022, 'so-only', '2022-07-06', 'G.S.R. 520(E)', 'civil-aviation', 'aircraft-rules-1937', 'civil-aviation-aircraft-rules-1937'),
  ('civav-gsr-812-2022', 'Civil Aviation', 'G.S.R. 812(E)', 2022, 'so-only', '2022-11-09', 'G.S.R. 812(E)', 'civil-aviation', 'aircraft-rules-1937', 'civil-aviation-aircraft-rules-1937'),
  ('civav-gsr-733-2023', 'Civil Aviation', 'G.S.R. 733(E)', 2023, 'so-only', '2023-10-10', 'G.S.R. 733(E)', 'civil-aviation', 'aircraft-rules-1937', 'civil-aviation-aircraft-rules-1937'),
  -- Aircraft Security Rules
  ('civav-gsr-596-2023', 'Civil Aviation', 'G.S.R. 596(E)', 2023, 'so-only', '2023-08-09', 'G.S.R. 596(E)', 'civil-aviation', 'aircraft-security-rules-2023', 'civil-aviation-security-rules'),
  ('civav-gsr-769-2024', 'Civil Aviation', 'G.S.R. 769(E)', 2024, 'so-only', '2024-12-09', 'G.S.R. 769(E)', 'civil-aviation', 'aircraft-security-rules-2023', 'civil-aviation-security-rules'),
  -- Height Restrictions Rules
  ('civav-gsr-751-2015', 'Civil Aviation', 'G.S.R. 751(E)', 2015, 'so-only', '2015-09-30', 'G.S.R. 751(E)', 'civil-aviation', 'height-restrictions-safeguarding-aircraft-rules-2015', 'civil-aviation-height-restrictions'),
  ('civav-gsr-877-2023', 'Civil Aviation', 'G.S.R. 877(E)', 2023, 'so-only', '2023-12-05', 'G.S.R. 877(E)', 'civil-aviation', 'height-restrictions-safeguarding-aircraft-rules-2015', 'civil-aviation-height-restrictions'),
  ('civav-gsr-335-2024', 'Civil Aviation', 'G.S.R. 335(E)', 2024, 'so-only', '2024-06-18', 'G.S.R. 335(E)', 'civil-aviation', 'height-restrictions-safeguarding-aircraft-rules-2015', 'civil-aviation-height-restrictions');

INSERT OR IGNORE INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at) VALUES
  ('civav-gsr-124-2026', 'civav-gsr-77-2026', 'corrigendum', 'research-agent-quoted', '2026-09-03'),
  ('civav-gsr-647-2026', 'civav-gsr-829-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-136-2026', 'civav-gsr-829-2025', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-647-2026', 'civav-gsr-136-2026', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-236-2026', 'civav-gsr-396-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-137-2026', 'civav-gsr-397-2025', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('civav-so-1694-2026', 'civav-so-987-2020', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-816-2019', 'civav-gsr-873-2017', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-123-2026', 'civav-gsr-816-2019', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-289-2022', 'civav-v26-1937', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-733-2023', 'civav-gsr-289-2022', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-733-2023', 'civav-gsr-520-2022', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-733-2023', 'civav-gsr-812-2022', 'cites', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-769-2024', 'civav-gsr-596-2023', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-877-2023', 'civav-gsr-751-2015', 'amends', 'research-agent-quoted', '2026-09-04'),
  ('civav-gsr-335-2024', 'civav-gsr-877-2023', 'amends', 'research-agent-quoted', '2026-09-04');
