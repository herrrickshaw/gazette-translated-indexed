"""
Citation extraction for Department of Food and Public Distribution and
Department of Consumer Affairs (Ministry of Consumer Affairs, Food and
Public Distribution) amendment orders and rules.

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

Depth pass (2026-09-07) found a second real shape sharing this same
template but tripping a real extractor gap: the S.O. 371(E) Aadhaar-seeding
notification's own deadline-extension series (seven independent real
amendments, 2023-2025) all read "...hereby makes the following FURTHER
amendments in the notification of the Government of India in the Ministry
of Consumer Affairs, Food and Public Distribution, Department of Food and
Public Distribution ... vide number S.O. 371(E), dated the 8th February,
2017..." — the inserted word "further" made every one of these silently
miss the shared template's literal "makes the following amendment" anchor.
Fixed at the shared-template level (extract.common_templates.
find_amendment_in_notification_links now tries a second literal anchor,
"makes the following further amendment", since the module's substring scan
has no way to make one word optional) rather than in this module, because
the gap was in shared code all ministries using this template rely on.

Two further real chains found the same pass do NOT fit this template and
need no new extraction code at all — both cite their target only in a
trailing Note, with the body text naming the amended RULES' TITLE rather
than a "vide number" citation, so they are read via
extract.common_templates.find_note_chain directly (see
tests/test_consumer_affairs_patterns.py and db/seed_consumer_affairs.sql):

  - Warehousing (Development and Regulation) Registration of Warehouses
    Rules, 2017 (Department of Food and Public Distribution) — an 8-item
    Note in one 2023 amendment (G.S.R. 676(E)) recovers this instrument's
    entire 2017-2022 amendment history in one primary-text quote, the same
    kind of gap-closing find as Ministry of Coal's 18-item pension-scheme
    Note elsewhere in this project.
  - National Consumer Disputes Redressal Commission (Group 'A' posts)
    Recruitment Rules, 2023 (Department of Consumer Affairs, under the
    Consumer Protection Act, 2019) — a 4-item Note chain across three real
    amendment rounds (2024-2025).
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

DEPARTMENT_NAME = 'food and public distribution'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, DEPARTMENT_NAME, self_citation=self_citation)
