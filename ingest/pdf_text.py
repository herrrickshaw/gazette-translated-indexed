"""
Extract text from a digital-native (not scanned) gazette notification PDF.

    python3 -m ingest.pdf_text some-notification.pdf > out.md

If a page has almost no extractable text, it's very likely a scanned image
rather than a digital PDF — pdf_text.py flags this instead of returning
near-empty output, so the caller knows to route it through
ingest.ocr_fallback instead.
"""
from __future__ import annotations

import sys
from pathlib import Path

MIN_CHARS_PER_PAGE = 20  # below this, treat the page as "probably scanned"


class LikelyScannedError(RuntimeError):
    """Raised when too few pages have extractable text — needs OCR instead."""


def extract_text(path: str | Path) -> str:
    import fitz  # PyMuPDF

    path = Path(path)
    with fitz.open(path) as doc:
        pages = [page.get_text().strip() for page in doc]

    thin_pages = sum(1 for p in pages if len(p) < MIN_CHARS_PER_PAGE)
    if pages and thin_pages / len(pages) > 0.5:
        raise LikelyScannedError(
            f'{path.name}: {thin_pages}/{len(pages)} pages had under '
            f'{MIN_CHARS_PER_PAGE} characters of extractable text — '
            'this looks scanned, not digital-native. Use ingest.ocr_fallback instead.'
        )

    return '\n\n'.join(f'<!-- page {i + 1} -->\n{text}' for i, text in enumerate(pages))


def main() -> int:
    if len(sys.argv) != 2:
        print('usage: python3 -m ingest.pdf_text <file.pdf>', file=sys.stderr)
        return 1
    try:
        print(extract_text(sys.argv[1]))
    except LikelyScannedError as e:
        print(str(e), file=sys.stderr)
        return 2
    return 0


if __name__ == '__main__':
    sys.exit(main())
