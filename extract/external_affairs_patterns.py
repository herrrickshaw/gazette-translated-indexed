"""
Citation extraction for Ministry of External Affairs (MEA) notifications.

Combines three existing templates (see extract.common_templates), since
real examples from this ministry fit all three:
  - corrigendum-substitution: "...notification of the Government of India
    in the Ministry of External Affairs, number G.S.R. 216(E) ... for X
    read Y."
  - amendment-in-notification: "...makes the following amendments in the
    notification of the Government of India in the Ministry of External
    Affairs, ... vide number S.O. 135(E)..."
  - supersession-preamble: "...in supersession of the notifications of the
    Government of India in the Ministry of External Affairs number G.S.R.
    662(E) ... and G.S.R. 370(E)..." — a real example of superseding TWO
    prior notifications at once; the template's while-loop over all
    citations in the (here, fallback-window) range already returns both.

Verified against three real examples (see db/seed_external_affairs.sql).
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_amendment_in_notification_links,
    find_corrigendum_substitution_links,
    find_supersession_links,
)

MINISTRY_NAME = 'external affairs'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_supersession_links(text, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
