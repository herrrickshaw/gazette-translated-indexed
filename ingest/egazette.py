"""
Fetch a gazette notification PDF directly from egazette.gov.in — the
Government of India's own portal — by gazette ID.

    python3 -m ingest.egazette CG-DL-E-03092026-275956
    python3 -m ingest.egazette CG-DL-E-03092026-275956 --extract   # also write .md

Why this exists: every gazette ID collected so far (from a third-party
aggregator) maps to a deterministic, unauthenticated URL on the official
site:

    https://egazette.gov.in/WriteReadData/<YYYY>/<file-id>.pdf

where <YYYY> is the year in the ID's DDMMYYYY date segment and <file-id>
is the ID's trailing number. Verified against a live download (HTTP 200,
application/pdf, TLS verified with the OS trust store) and corroborated by
an Internet Archive mirror using the same file-id. This is the primary
source; nothing in this module touches an aggregator.

Politeness: one request at a time with a fixed delay, a descriptive
User-Agent, and a local cache so a PDF is never fetched twice. There is no
documented API and no stated rate limit; treat the site gently anyway.

TLS: Node-based fetchers fail on this host ("unable to verify the first
certificate" — a missing intermediate, common on Indian government sites),
while system curl succeeds. Python `requests` may go either way depending
on its CA bundle. On an SSL error this module falls back to system curl
(OS trust store) — it never disables verification.
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
import time
from pathlib import Path

_ID_RE = re.compile(r'^(?P<gov>[A-Z]{2})-(?P<region>[A-Z]{2})-(?P<series>[EW])-'
                    r'(?P<dd>\d{2})(?P<mm>\d{2})(?P<yyyy>\d{4})-(?P<fileid>\d+)$')
_BASE = 'https://egazette.gov.in/WriteReadData'
_USER_AGENT = 'gazette-translated-indexed/0.1 (+https://github.com/herrrickshaw/gazette-translated-indexed)'
DEFAULT_DELAY_S = 2.0


def parse_gazette_id(gazette_id: str) -> dict:
    m = _ID_RE.match(gazette_id.strip())
    if not m:
        raise ValueError(f'not a gazette ID: {gazette_id!r} (expected e.g. CG-DL-E-03092026-275956)')
    return m.groupdict()


def gazette_id_to_pdf_url(gazette_id: str) -> str:
    parts = parse_gazette_id(gazette_id)
    return f'{_BASE}/{parts["yyyy"]}/{parts["fileid"]}.pdf'


def _looks_like_pdf(data: bytes) -> bool:
    return data[:5] == b'%PDF-'


def _fetch_bytes(url: str, timeout: float) -> bytes:
    try:
        import requests
        r = requests.get(url, headers={'User-Agent': _USER_AGENT}, timeout=timeout)
        r.raise_for_status()
        ctype = r.headers.get('content-type', '')
        if not ctype.startswith('application/pdf') or not _looks_like_pdf(r.content):
            raise RuntimeError(f'{url}: not a PDF (content-type {ctype!r}, first bytes {r.content[:8]!r})')
        return r.content
    except Exception as e:  # noqa: BLE001 — narrow below
        import requests as _rq
        if not isinstance(e, _rq.exceptions.SSLError):
            raise
    # SSL chain problem in Python's CA bundle; use system curl (OS trust store).
    proc = subprocess.run(
        ['curl', '-sS', '-A', _USER_AGENT, '--max-time', str(int(timeout)), url],
        capture_output=True, check=False,
    )
    if proc.returncode != 0:
        raise RuntimeError(f'curl failed for {url}: {proc.stderr.decode(errors="replace").strip()}')
    if not _looks_like_pdf(proc.stdout):
        raise RuntimeError(f'{url}: curl response is not a PDF (first bytes {proc.stdout[:8]!r})')
    return proc.stdout


def fetch(gazette_id: str, out_dir: str | Path = 'data/raw/egazette',
          delay_s: float = DEFAULT_DELAY_S, timeout: float = 60.0) -> Path:
    """Download (or reuse cached) PDF for gazette_id. Returns the local path."""
    parts = parse_gazette_id(gazette_id)
    dest = Path(out_dir) / parts['yyyy'] / f'{gazette_id}.pdf'
    if dest.exists() and dest.stat().st_size > 0:
        return dest
    dest.parent.mkdir(parents=True, exist_ok=True)
    time.sleep(delay_s)
    data = _fetch_bytes(gazette_id_to_pdf_url(gazette_id), timeout=timeout)
    dest.write_bytes(data)
    return dest


def main() -> int:
    ap = argparse.ArgumentParser(description='Fetch a gazette PDF from egazette.gov.in by gazette ID')
    ap.add_argument('gazette_ids', nargs='+')
    ap.add_argument('--out', default='data/raw/egazette')
    ap.add_argument('--delay', type=float, default=DEFAULT_DELAY_S)
    ap.add_argument('--extract', action='store_true',
                    help='also write data/raw_md/<id>.md via ingest.pdf_text (flags scanned PDFs)')
    args = ap.parse_args()

    rc = 0
    for gid in args.gazette_ids:
        try:
            pdf = fetch(gid, out_dir=args.out, delay_s=args.delay)
            print(f'{gid}: {pdf} ({pdf.stat().st_size} bytes)')
        except Exception as e:  # noqa: BLE001
            print(f'{gid}: FAILED — {e}', file=sys.stderr)
            rc = 1
            continue
        if args.extract:
            from .pdf_text import LikelyScannedError, extract_text
            md = Path('data/raw_md') / f'{gid}.md'
            md.parent.mkdir(parents=True, exist_ok=True)
            try:
                md.write_text(
                    f'---\nsource_url: {gazette_id_to_pdf_url(gid)}\ngazette_id: {gid}\n'
                    f'extraction_method: ingest.pdf_text (PyMuPDF)\n---\n\n' + extract_text(pdf)
                )
                print(f'{gid}: extracted -> {md}')
            except LikelyScannedError as e:
                from .ocr_fallback import ocr_status
                print(f'{gid}: needs OCR ({e}); ocr endpoint: {ocr_status()}', file=sys.stderr)
                rc = 2
    return rc


if __name__ == '__main__':
    sys.exit(main())
