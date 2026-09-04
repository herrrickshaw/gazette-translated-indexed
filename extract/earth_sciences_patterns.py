"""
Citation extraction for Ministry of Earth Sciences amendment notifications.

Uses the "amendment-in-notification" template (see extract.common_templates)
— real text reads "...makes the following amendments in the notification of
the Government of India in the Ministry of Earth Sciences number S.O.
3508(E), dated the 7th August, 2023...". No new template needed.

Verified against one real example: S.O. 4331(E) amends S.O. 3508(E), a
National Antarctic Committee expert-member re-nomination (see
db/seed_earth_sciences.sql). Two further real leads (Group 'A' and
Scientist 'B' Recruitment Rules supersessions) cite their targets without a
usable G.S.R./S.O.(E) number — one has no number at all, the other cites
"G.S.R. 137 RRs", a form this project's citation regex doesn't recognize —
and are deliberately not modeled.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'earth sciences'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
