"""
Citation extraction for Ministry of Road Transport and Highways notifications
under the National Highways Act, 1956.

This is deliberately a separate module from extract.citation_patterns, not a
parameterisation of it: MoRTH notifications carry no ministry-internal
sequential number at all ("No. X/YYYY-series", CBIC's convention) — the only
citation a MoRTH notification has is its own S.O. gazette number. Reusing
CBIC's citation-number regex here would be reusing a shape that doesn't
exist in this ministry's text, not genuine code sharing.

Verified against exactly one real example (see db/seed_morth.sql for
provenance) — this is a first pilot pattern, not yet validated the way
CBIC's is. See GATES.md G4.
"""
from __future__ import annotations

import re
from dataclasses import dataclass

from .citation_patterns import find_gazette_citations  # S.O./G.S.R. regex is shared; it's generic gazette-citation syntax, not CBIC-specific

# MoRTH corrigenda are described with "to amend notification S.O. X(E)" —
# distinct wording from CBIC's "in supersession of" / "in partial modification
# of". Order matters only if a document could contain multiple phrases; kept
# as a list for the same shape as extract.cross_ref, not because there's
# evidence yet that more than one phrase occurs in practice.
_RELATION_PHRASES = [
    ('to amend notification', 'corrigendum'),
    ('correcting', 'corrigendum'),
]

_WINDOW_CHARS = 500  # MoRTH corrigenda are single-sentence; no long enumerated list to span


@dataclass(frozen=True)
class MorthCandidateLink:
    relation_type: str
    target_so: str
    phrase: str
    phrase_start: int


def find_candidate_links(text: str, self_so: str | None = None) -> list[MorthCandidateLink]:
    """
    self_so: the citing document's own S.O. number (e.g. 'S.O. 4848(E)'), so
    it isn't proposed as a link to itself.
    """
    lower = text.lower()
    citations = find_gazette_citations(text)  # real match positions, not a re-search of normalized strings

    out: list[MorthCandidateLink] = []
    for phrase, relation in _RELATION_PHRASES:
        start = 0
        while True:
            idx = lower.find(phrase, start)
            if idx == -1:
                break
            window_end = idx + len(phrase) + _WINDOW_CHARS
            for c in citations:
                if idx < c.start < window_end and c.normalized != self_so:
                    out.append(MorthCandidateLink(
                        relation_type=relation, target_so=c.normalized,
                        phrase=phrase, phrase_start=idx,
                    ))
            start = idx + len(phrase)

    seen = set()
    deduped = []
    for link in out:
        if link.target_so not in seen:
            seen.add(link.target_so)
            deduped.append(link)
    return deduped
