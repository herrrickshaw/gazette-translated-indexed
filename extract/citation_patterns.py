"""
Regex extraction of CBIC notification citations and G.S.R./S.O. gazette
numbers from raw notification text.

Three numbering forms exist side by side in real CBIC text (verified against
the 31 predecessors listed in Notification No. 45/2025-Customs's own preamble):

  - 4-digit year:  "No. 45/2025-Customs"   (standard since ~1994)
  - 2-digit year:  "No. 207/89-Customs"    (seen once, 1989)
  - bare number:   "No. 3-Customs"          (1957-1993, no year in the number at all)

A citation's own series/number/year is not the same identifier as its gazette
citation — every notification also carries a separate G.S.R. (or S.O.) number
assigned when it's gazetted. Both are extracted, kept distinct, and neither is
guessed when it isn't present in the text.
"""
from __future__ import annotations

import re
from dataclasses import dataclass

# Real notification text is inconsistently spaced around the number/series
# separator — sometimes a plain hyphen with no space ("45/2025-Customs"),
# sometimes a hyphen with a trailing space ("1/2025- Customs"), and the
# notification's own header can use an en dash instead ("45/2025 –Customs").
# `_SEP` tolerates all of that rather than assuming clean formatting.
_SEP = r'\s*[-–]\s*'

_CITATION_RE = re.compile(
    r'No\.?\s*(?P<num4>\d+)/(?P<year4>\d{4})' + _SEP + r'(?P<series4>Customs(?:\s*\([A-Za-z.]+\))?)'
    r'|'
    r'No\.?\s*(?P<num2>\d+)/(?P<year2>\d{2})(?!\d)' + _SEP + r'(?P<series2>Customs(?:\s*\([A-Za-z.]+\))?)'
    r'|'
    r'No\.?\s*(?P<numB>\d+)' + _SEP + r'(?P<seriesB>Customs(?:\s*\([A-Za-z.]+\))?)'
)

_GSR_RE = re.compile(r'G\.S\.R\.?\s*(\d+)\s*\(([A-Z])\)')
_SO_RE = re.compile(r'S\.O\.?\s*(\d+)\s*\(([A-Z])\)')

# Pivot for expanding a 2-digit year (e.g. the '89' in "No. 207/89-Customs",
# which is 1989, not 2089). Same convention as POSIX strptime %y: values at
# or above the pivot are 19xx, below it are 20xx. This numbering form only
# appears in the pre-1994 era of CBIC notifications, so 68/69 (chosen to
# comfortably cover the whole 20th century tail) is a safe default — revisit
# if a 2-digit-year notification from the 2000s ever turns up.
_TWO_DIGIT_YEAR_PIVOT = 69


def _expand_two_digit_year(yy: str) -> int:
    n = int(yy)
    return 1900 + n if n >= _TWO_DIGIT_YEAR_PIVOT else 2000 + n


@dataclass(frozen=True)
class Citation:
    raw: str
    series: str
    number: str          # e.g. '45', '207/89', '3' — kept as the full "no." field
    year: int | None      # None for bare pre-1994 numbers
    numbering_form: str   # 'bare' | '2-digit-year' | '4-digit-year'
    start: int
    end: int


def find_citations(text: str) -> list[Citation]:
    out = []
    for m in _CITATION_RE.finditer(text):
        if m.group('num4'):
            out.append(Citation(
                raw=m.group(0), series=m.group('series4'),
                number=f"{m.group('num4')}/{m.group('year4')}",
                year=int(m.group('year4')), numbering_form='4-digit-year',
                start=m.start(), end=m.end(),
            ))
        elif m.group('num2'):
            out.append(Citation(
                raw=m.group(0), series=m.group('series2'),
                number=f"{m.group('num2')}/{m.group('year2')}",
                year=_expand_two_digit_year(m.group('year2')), numbering_form='2-digit-year',
                start=m.start(), end=m.end(),
            ))
        else:
            out.append(Citation(
                raw=m.group(0), series=m.group('seriesB'),
                number=m.group('numB'),
                year=None, numbering_form='bare',
                start=m.start(), end=m.end(),
            ))
    return out


@dataclass(frozen=True)
class GazetteCitation:
    kind: str          # 'G.S.R.' | 'S.O.'
    normalized: str    # e.g. 'S.O. 4872(E)' — always this exact spacing, regardless of source formatting
    start: int         # position of the match in the ORIGINAL text — not of `normalized`,
    end: int           # which may not even appear verbatim in the source (e.g. "S.O 4872(E)" with no period)


def find_gazette_citations(text: str) -> list[GazetteCitation]:
    """
    Position-aware G.S.R./S.O. citation finder. Use this (not find_gazette_ids)
    whenever a caller needs to know *where* a citation is, e.g. to pair it
    with a nearby relation phrase — `normalized` is a display string, not
    something safe to re-search for in the source text, because real text is
    inconsistently formatted (e.g. "S.O 4872(E)" with no period at all).
    """
    out = []
    for m in _GSR_RE.finditer(text):
        out.append(GazetteCitation(
            kind='G.S.R.', normalized=f'G.S.R. {m.group(1)}({m.group(2)})',
            start=m.start(), end=m.end(),
        ))
    for m in _SO_RE.finditer(text):
        out.append(GazetteCitation(
            kind='S.O.', normalized=f'S.O. {m.group(1)}({m.group(2)})',
            start=m.start(), end=m.end(),
        ))
    return out


def find_gazette_ids(text: str) -> list[str]:
    """G.S.R./S.O. citations as display strings only — no position info.
    Kept for callers that just need the set of ids; see find_gazette_citations
    for anything that needs to locate a citation in the source text."""
    return [c.normalized for c in find_gazette_citations(text)]
