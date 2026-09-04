"""
Citation extraction for Ministry of Food Processing Industries amendment
notifications.

Uses the "amendment-in-notification" template (see extract.common_templates)
— real text reads "...hereby makes the following amendment in the
notification of the Government of India, Ministry of Food Processing
Industries, published in the Gazette of India ... vide number S.O.
5577(E), dated the 3rd December, 2025...". No new template needed.

Verified against one real example: S.O. 4784(E) amends S.O. 5577(E), a
NIFTEM Council membership substitution (see db/seed_food_processing.sql).
Two further real leads (Multi Tasking Staff and Staff Car Driver
Recruitment Rules, both superseding unnumbered 1994-era rules) and one
bare-form lead (a "Notification no." with no G.S.R./S.O. number) are
deliberately not modeled.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'food processing industries'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
