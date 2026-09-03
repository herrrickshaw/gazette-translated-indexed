"""
Citation extraction for Department of Food and Public Distribution
(Ministry of Consumer Affairs, Food and Public Distribution) amendment
orders under the Essential Commodities Act, 1955.

A third independent confirmation of the shared "amendment-in-notification"
template (see extract.common_templates) — real text says "...amendment in
the order of the Government of India in the Department of Food and Public
Distribution ... vide S.O. <citation> dated <date>" (an "order", not a
"notification", but the same shape). Confirms this template is a genuine
cross-government drafting convention, not a coincidence between two
ministries.

Verified against two real examples that both amend the same parent order
(see db/seed_consumer_affairs.sql) — two distinct amendment edges into one
original, not two independent pairs.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

DEPARTMENT_NAME = 'food and public distribution'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, DEPARTMENT_NAME, self_citation=self_citation)
