"""
Citation extraction for Ministry of Parliamentary Affairs notifications.

Combines two existing templates (see extract.common_templates), since
real examples from this ministry fit both:
  - corrigendum-substitution: "In partial modification of the
    notification of the Government of India, Ministry of Parliamentary
    Affairs, number G.S.R. 924(E)..."
  - supersession-preamble: "...in supersession of the Ministry of
    Parliamentary Affairs notification ... vide G.S.R. 923(E) ... except
    as respects things done or omitted to be done before such
    supersession..."

Verified against two real examples (see
db/seed_parliamentary_affairs.sql) — both Aadhaar-authentication
notifications for the Rajya Sabha and Lok Sabha secretariats
respectively, this ministry's only real amendment-linkable activity (the
rest of its ~28 tracked notifications are staff appointments/retirements
and standalone recruitment rules).
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_corrigendum_substitution_links,
    find_supersession_links,
)

MINISTRY_NAME = 'parliamentary affairs'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_supersession_links(text, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
