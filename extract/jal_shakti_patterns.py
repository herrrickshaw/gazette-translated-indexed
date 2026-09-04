"""
Citation extraction for Ministry of Jal Shakti amendment notifications.

Uses the "amendment-in-notification" template (see extract.common_templates)
— but real text uses TWO different ministry names for the same shape,
depending on when the citing notification was drafted: "...Ministry of
Jal Shakti..." in a 2025 example, and "...the erstwhile Ministry of Water
Resources, River Development, and Ganga Rejuvenation..." (Jal Shakti's
pre-2019 name) in another. Both are tried and merged, the same pattern
extract.information_broadcasting_patterns uses for a shortened ministry
name.

Verified against two real examples (see db/seed_jal_shakti.sql). A third
real pair (Ravi and Beas Waters Tribunal) is an exceptionally long
note-chain (36 nodes — the longest in this project), modeled via
extract.common_templates.find_note_chain instead.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

_MINISTRY_NAMES = ('jal shakti', 'water resources, river development')


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links: list[TemplateLink] = []
    for name in _MINISTRY_NAMES:
        links += find_amendment_in_notification_links(text, name, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
