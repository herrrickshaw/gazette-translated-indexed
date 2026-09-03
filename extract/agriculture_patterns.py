"""
Citation extraction for Ministry of Agriculture and Farmers Welfare
amendment notifications under the Fertiliser (Control) Order, 1985.

A fifth confirmation of the "amendment-in-notification" template (see
extract.common_templates), alongside MoRTH, MHA, Consumer Affairs/Food and
Public Distribution, and Ministry of Power.

Verified against one real example: S.O. 3666(E) amends S.O. 1018(E) (see
db/seed_agriculture.sql for provenance). A research agent found a third
pair (Protection of Plant Varieties and Farmers' Rights Act) with an
eleven-notification amendment history in its trailing "Note" — a genuine
long consolidated-instrument chain, structurally closer to CBIC's
45/2025-style consolidation than a single pair, and worth its own dedicated
pass rather than a rushed fit here.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_amendment_in_notification_links

MINISTRY_NAME = 'agriculture and farmers welfare'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
