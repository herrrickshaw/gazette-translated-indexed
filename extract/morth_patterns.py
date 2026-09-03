"""
Citation extraction for Ministry of Road Transport and Highways notifications
under the National Highways Act, 1956.

This is deliberately a separate module from extract.citation_patterns, not a
parameterisation of it: MoRTH notifications carry no ministry-internal
sequential number at all ("No. X/YYYY-series", CBIC's convention) — the only
citation a MoRTH notification has is its own S.O. gazette number. Reusing
CBIC's citation-number regex here would be reusing a shape that doesn't
exist in this ministry's text, not genuine code sharing.

Verified against three real examples (see db/seed_morth.sql for provenance
on each) spanning 2024-2026 — a genuine second and third data point, not
just the first pilot pair. See GATES.md G4.

Earlier version of this module used the phrase "to amend notification",
taken from a gazette aggregator's AI-generated summary sentence rather than
the notification's own legal text — even though the real primary text was
available on the same page. The actual recurring boilerplate across every
real example checked is "hereby makes the following amendment in [the]
notification..." — found by reading the primary text properly instead of
its paraphrase. This is the same class of mistake as the CBIC en-dash bug:
trusting a cleaner-looking secondary description over messier ground truth.
"""
from __future__ import annotations

import re
from dataclasses import dataclass

from .citation_patterns import find_gazette_citations  # S.O./G.S.R. regex is shared; it's generic gazette-citation syntax, not CBIC-specific

# The real, recurring MoRTH corrigendum boilerplate: "the Central Government
# hereby makes the following amendment in [the] notification ... S.O. X(E)".
# "the" before "notification" is inconsistent across real examples (present
# in one, absent in two others) — matched on the stable common substring.
_RELATION_PHRASES = [
    ('hereby makes the following amendment in', 'corrigendum'),
]

_WINDOW_CHARS = 800  # covers "...amendment in [the notification of the Government of India in the Ministry of X], S.O. Y(E)"


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
