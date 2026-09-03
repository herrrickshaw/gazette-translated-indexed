"""
OCR fallback for scanned notification PDFs, via the existing ~/ocr
Unlimited-OCR client (opt-in, GPU-served remotely — see ~/ocr/serve/README.md).

    python3 -m ingest.ocr_fallback some-scanned-notification.pdf

Never blocks: if the endpoint isn't configured or isn't currently reachable
(the Colab GPU notebook isn't always running), this returns a clear status
instead of raising, so a caller can mark the document `needs_ocr` and move on.
"""
from __future__ import annotations

import sys
from pathlib import Path

# ~/ocr is a sibling of this project on the same machine, not a dependency
# vendored into gazette-trail — add it to the path rather than duplicating it.
sys.path.insert(0, str(Path.home()))

try:
    from ocr.unlimited_ocr import is_configured, ocr_pdf, ping
except ImportError:
    is_configured = lambda: False       # noqa: E731
    ping = lambda timeout=10.0: False   # noqa: E731
    ocr_pdf = None


def ocr_status() -> str:
    """One of: 'not_configured', 'endpoint_down', 'ready'."""
    if not is_configured():
        return 'not_configured'
    if not ping():
        return 'endpoint_down'
    return 'ready'


def try_ocr(path: str | Path) -> tuple[str | None, str]:
    """Returns (transcript_or_None, status). status explains a None result."""
    status = ocr_status()
    if status != 'ready':
        return None, status
    return ocr_pdf(path), 'ready'


def main() -> int:
    if len(sys.argv) != 2:
        print('usage: python3 -m ingest.ocr_fallback <file.pdf>', file=sys.stderr)
        return 1
    text, status = try_ocr(sys.argv[1])
    if text is None:
        print(f'OCR skipped: {status}', file=sys.stderr)
        return 2
    print(text)
    return 0


if __name__ == '__main__':
    sys.exit(main())
