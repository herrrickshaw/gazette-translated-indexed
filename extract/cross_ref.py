"""
Boilerplate-phrase matching: pairs relation-indicating phrases with the
citations that follow them to propose candidate CROSS_REFERENCE rows.

These are *candidates* only — see verify.review_queue. A phrase followed by a
citation is a strong signal, not proof: OCR noise, multi-notification lists,
and unrelated nearby citations can all produce false positives.
"""
from __future__ import annotations

from dataclasses import dataclass

from .citation_patterns import Citation, find_citations

# Ordered by how strongly each phrase implies a specific relation. Checked in
# order; first match wins for a given phrase occurrence.
_RELATION_PHRASES = [
    ('in supersession of', 'supersedes'),
    ('in partial modification of', 'amends'),
    ('seeks to further amend', 'amends'),
    ('further amend', 'amends'),
    ('read with', 'cites'),
]

# How far past a relation phrase to look for citations it governs. A fixed
# character count doesn't work here: real preambles enumerate the superseded
# notifications one per line (i, ii, iii, ...) and a 31-item list runs well
# past a few thousand characters once PDF-extraction whitespace is included.
# Instead, look for the actual legal boilerplate that closes the enumerated
# list ("except as respects things done or omitted...") and stop there; only
# fall back to a fixed cap when that terminator isn't found, so a malformed
# or unusually long document can't make this scan run away across 168 pages.
_LIST_TERMINATORS = ('except as respects', 'the central government, on being satisfied')
_FALLBACK_WINDOW_CHARS = 4000
_MAX_WINDOW_CHARS = 20000


@dataclass(frozen=True)
class CandidateLink:
    relation_type: str
    citation: Citation
    phrase: str
    phrase_start: int


def find_candidate_links(text: str, self_number: str | None = None) -> list[CandidateLink]:
    """
    self_number: the citing document's own "no." field (e.g. '45/2025'), so
    its own self-references in the header aren't proposed as a link to itself.
    """
    lower = text.lower()
    citations = find_citations(text)
    out: list[CandidateLink] = []

    for phrase, relation in _RELATION_PHRASES:
        start = 0
        while True:
            idx = lower.find(phrase, start)
            if idx == -1:
                break
            search_from = idx + len(phrase)
            terminator_positions = [
                lower.find(t, search_from) for t in _LIST_TERMINATORS
            ]
            terminator_positions = [p for p in terminator_positions if p != -1]
            if terminator_positions:
                window_end = min(min(terminator_positions), search_from + _MAX_WINDOW_CHARS)
            else:
                window_end = search_from + _FALLBACK_WINDOW_CHARS
            for c in citations:
                if idx < c.start < window_end and c.number != self_number:
                    out.append(CandidateLink(
                        relation_type=relation, citation=c,
                        phrase=phrase, phrase_start=idx,
                    ))
            start = idx + len(phrase)

    # De-duplicate: same citation matched by more than one phrase occurrence
    # (e.g. it falls inside two overlapping windows) keeps only its first hit.
    seen = set()
    deduped = []
    for link in out:
        key = (link.citation.series, link.citation.number, link.relation_type)
        if key not in seen:
            seen.add(key)
            deduped.append(link)
    return deduped
