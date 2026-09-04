"""
Citation extraction for Ministry of Micro, Small and Medium Enterprises
(MSME) amendment notifications.

Uses the "amendment-in-notification" template (see extract.common_templates)
— real text reads "...hereby makes the following amendments in the
notification of Government of India, Ministry of Micro, Small and Medium
Enterprises number S.O. 2119(E), dated the 26th June, 2020...". No new
template needed.

Verified against one real example: S.O. 1364(E) amends S.O. 2119(E), an
MSME classification financial-limits notification (see db/seed_msme.sql).
A second real pair (KVIC member appointment) is a note-chain, modeled via
extract.common_templates.find_note_chain instead. A third real lead (a
Recruitment Rules corrigendum) cites its target as "GSR 381" — a real
number but missing the "(E)" suffix this project's citation regex
requires — and is deliberately not modeled.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'micro, small and medium enterprises'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
