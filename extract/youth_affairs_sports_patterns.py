"""
Citation extraction for Ministry of Youth Affairs and Sports notifications.

Uses the "corrigendum-substitution" template's ministry-name anchor (see
extract.common_templates) — real text reads "In partial modification of
Government of India, Ministry of Youth Affairs & Sports Notifications
S.O. 973(E) ..., S.O. 525(E) ... and S.O. 4478(E) ...", a real one-to-many
example (one clause naming three predecessor notifications at once, same
shape as extract.culture_patterns' first real example). Real text uses
"&" rather than spelling out "and", so both forms are tried and merged.

Verified against one real example (see db/seed_youth_affairs_sports.sql).
A second real lead (Khelo India Directorate renaming) cites its target
only as "Gazette Notification dated 04th March, 2022" — no G.S.R./S.O.
number at all — and is deliberately not modeled.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

_MINISTRY_NAMES = ('youth affairs & sports', 'youth affairs and sports')


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links: list[TemplateLink] = []
    for name in _MINISTRY_NAMES:
        links += find_corrigendum_substitution_links(text, name, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
