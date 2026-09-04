# Gates: part 2 — official source (egazette.gov.in), plus Communications closed out

OWNS: db/**, extract/**, ingest/**, tests/**, data/raw_md/**

Scope: "finish 1 then 2". (1) closed: Communications' relaunched agent returned and is modeled (17 ministries). (2) egazette.gov.in — the Government of India's own portal — exposes every notification PDF at a deterministic, unauthenticated URL derived from the gazette ID. That replaces the third-party aggregator as the text source for the pipeline; the aggregator remains useful only for *discovering* which IDs to fetch.

- [x] G1: Communications (Dept. of Telecommunications) is modeled — the first `rescinds` edge.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_communications_patterns.py -q
  EXPECT: 2 passed
  EVIDENCE: met — G.S.R. 863(E) rescinds G.S.R. 796(E); the full 720→771→796(duplicate)→863(rescinds) chain is documented in db/seed_communications.sql, only the edge stated in the rescinding clause itself is modeled.

- [x] G2: The gazette-ID → official-PDF-URL mapping is pinned by tests, including weekly (W) series, state (SG) prefix, malformed IDs, and year-from-ID-not-today.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/test_egazette.py -q
  EXPECT: 10 passed
  EVIDENCE: met — pattern `WriteReadData/<YYYY>/<file-id>.pdf`, corroborated by an Internet Archive mirror item that carries the same file-id (in.gazette.central.e.2024-09-27.257550).

- [x] G3: A live fetch through ingest.egazette produced a cached, valid PDF (this gate checks the cached artifact; the live download itself was observed once: HTTP 200, application/pdf, 569,251 bytes).
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -c "p='data/raw/egazette/2026/CG-DL-E-03092026-275956.pdf'; d=open(p,'rb').read(5); assert d==b'%PDF-', d; print('CACHED_PDF_OK')"
  EXPECT: CACHED_PDF_OK
  EVIDENCE: met — second invocation returned from cache in 0.05 s with no network call and no politeness sleep.

- [x] G4: End-to-end from the OFFICIAL PDF: fetch → PyMuPDF text → MoRTH extractor recovers the known cross-reference. No aggregator text anywhere in this path.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -c "from ingest.pdf_text import extract_text; from extract.morth_patterns import find_candidate_links; t=extract_text('data/raw/egazette/2026/CG-DL-E-03092026-275956.pdf'); l=[x.target_citation for x in find_candidate_links(t, self_so='S.O. 4848(E)')]; assert l==['S.O. 4872(E)'], l; print('E2E_OFFICIAL_OK')" 2>/dev/null
  EXPECT: E2E_OFFICIAL_OK
  EVIDENCE: met — the same pair earlier verified from the aggregator's transcription now verifies from the primary source, which also retires the `search-index-excerpt` tier for any ID that can be re-fetched this way.

- [x] G5: TLS verification is never disabled anywhere in the fetcher — the SSL-chain fallback is system curl with the OS trust store, not `verify=False` / `-k`. (Negative check with an inline positive control.)
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -c "import re; bad=re.compile(r\"verify\s*=\s*False|['\\\"]-k['\\\"]|--insecure\"); assert bad.search('requests.get(u, verify=False)'), 'positive control failed'; assert bad.search(\"['curl','-k',u]\"), 'positive control 2 failed'; s=open('ingest/egazette.py').read(); assert not bad.search(s), 'insecure TLS found'; print('NO_INSECURE_TLS')"
  EXPECT: NO_INSECURE_TLS
  EVIDENCE: met — observed live: Python `requests` raised SSLError on this host (missing intermediate in the served chain); the module then used curl, which verified the chain against the macOS trust store (`ssl_verify_result=0`).

- [x] G6: Full suite passes with 17 ministries seeded and the fetcher's tests included.
  CHECK: cd /Users/umashankar/gazette-translated-indexed && /Users/umashankar/.venvs/gazette-trail/bin/python3 -m pytest tests/ -q
  EXPECT: 51 passed
  EVIDENCE: met.

- [x] G7: The URL scheme is confirmed beyond the single 2026 Delhi-region ID it was verified on — for an earlier year and non-DL region codes.
  EVIDENCE: met — three range-request probes (first 1 KB each, 2 s apart), all HTTP 206 / application/pdf / `%PDF-` magic / TLS verified: CG-DL-E-19072023-247431 → /2023/247431.pdf (earlier year); CG-MH-E-16102023-249453 → /2023/249453.pdf (Maharashtra region); CG-KA-E-02092026-275945 → /2026/275945.pdf (Karnataka region). The region code is not part of the path at all — `gazette_id_to_pdf_url` correctly ignores it. Boundary that remains: a web-search hit showed a 1966 file at `WriteReadData/1966/O-1665-1966-0041-75918.pdf`, a different file-id scheme, so the mapping is verified for the modern numeric-file-id era (at least 2023–2026) and explicitly NOT claimed for legacy scans — those would need their own ID scheme and, being scans, the OCR path.
