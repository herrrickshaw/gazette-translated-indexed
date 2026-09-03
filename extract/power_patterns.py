"""
Citation extraction for Ministry of Power amendment notifications.

A fourth confirmation of the "amendment-in-notification" template (see
extract.common_templates), alongside MoRTH, MHA, and Consumer Affairs/Food
and Public Distribution.

Note: ministry_name is 'ministry of power', not just 'power' — the anchor
phrase itself ("hereby makes the following amendment in the notification...
in exercise of the *powers* conferred by...") contains the word "power" as a
substring, which would make a bare 'power' scope guard match almost any
ministry's text. Caught before it became a bug, not after.

Verified against one real example: S.O. 3520(E) amends S.O. 5852(E) (see
db/seed_power.sql for provenance). A research agent found two further real
pairs (a repeal chain for Tubular Fluorescent Lamp standards, and a JERC
salary-rules amendment) that cite prior amendment history in a trailing
"Note", closer to the amendment-history-citation shape already deferred for
MCA/Labour than a single amendment-in-notification pair — not modeled here.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'ministry of power'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
