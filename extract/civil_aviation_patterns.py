"""
Citation extraction for Ministry of Civil Aviation corrigenda.

A sixth confirmation of the "corrigendum-substitution" template (see
extract.common_templates), alongside MoEFCC, MoHFW, MCA, Labour, and MeitY.

Verified against one real example: G.S.R. 124(E) corrects the English text
of G.S.R. 77(E), the Protection of Interests in Aircraft Objects Rules,
2026 (see db/seed_civil_aviation.sql for provenance). A research agent
found a second real pair (G.S.R. 647(E) amending the Aircraft Investigation
of Accidents and Incidents Rules, 2025) — a real lead, not modeled this
round purely for time.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'civil aviation'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
