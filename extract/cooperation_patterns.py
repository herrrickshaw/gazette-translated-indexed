"""
Citation extraction for Ministry of Cooperation notifications.

Combines two existing templates (see extract.common_templates), since
real examples from this ministry fit both:
  - amendment-in-notification: "...makes the following amendment in the
    Notification of the Ministry of Cooperation published vide
    G.S.R.93(E)..." and "...makes the following amendments in the
    notification of the Government of India, Ministry of Cooperation, ...
    vide number S.O. 3247(E)..."
  - supersession-preamble: "...in supersession of the notification of the
    Government of India, Ministry of Agriculture & Farmers Welfare
    (Department of Agriculture, Cooperation & Farmers Welfare) number
    G.S.R. 427(E)..." — a real cross-ministry supersession (Cooperation's
    own principal notification supersedes a prior Ministry of Agriculture
    one), which is exactly why that template doesn't anchor on a ministry
    name.

Verified against real examples (see db/seed_cooperation.sql).
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_amendment_in_notification_links,
    find_supersession_links,
)

MINISTRY_NAME = 'cooperation'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_supersession_links(text, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
