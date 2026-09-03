"""
Citation extraction for Ministry of Railways corrigenda.

A fourth, genuinely distinct drafting shape — not a fit for either shared
template in extract.common_templates. Real text: "S.O. <self>.— In the
Notification S.O. <target>, dated <date>, issued by the Ministry of
Railways [<zonal railway division>] ...". Two things make this different
from MoRTH/MHA/MoEFCC/MoHFW:

  1. The target citation follows "In the Notification" directly, not a
     "Ministry of <name>" phrase — "Ministry of Railways" comes *after*
     the citation here, reversed from every other ministry checked so far.
  2. Zonal railway divisions (Central Railway, Western Railway, South
     Western Railway, ...) draft their own corrigenda somewhat
     independently — a research agent found three real Railways
     corrigenda in three visibly different formats from three different
     divisions. This module is verified against exactly one of those
     (the South Western Railway survey-number correction) — see
     db/seed_railways.sql for the other two, left unmodeled as real leads.
"""
from __future__ import annotations

from dataclasses import dataclass

from .citation_patterns import find_gazette_citations

_ANCHOR = 'in the notification'
_WINDOW_CHARS = 100  # the citation follows almost immediately: "In the Notification S.O. X, dated..."
_SCOPE_GUARD = 'ministry of railways'  # require this appear somewhere, so this module doesn't fire on unrelated text


@dataclass(frozen=True)
class RailwaysCandidateLink:
    target_citation: str


def find_candidate_links(text: str, self_citation: str | None = None) -> list[RailwaysCandidateLink]:
    if _SCOPE_GUARD not in text.lower():
        return []

    lower = text.lower()
    citations = find_gazette_citations(text)
    out: list[RailwaysCandidateLink] = []
    start = 0
    while True:
        idx = lower.find(_ANCHOR, start)
        if idx == -1:
            break
        window_end = idx + len(_ANCHOR) + _WINDOW_CHARS
        for c in citations:
            if idx < c.start < window_end and c.normalized != self_citation:
                out.append(RailwaysCandidateLink(target_citation=c.normalized))
        start = idx + len(_ANCHOR)

    seen = set()
    deduped = []
    for link in out:
        if link.target_citation not in seen:
            seen.add(link.target_citation)
            deduped.append(link)
    return deduped
