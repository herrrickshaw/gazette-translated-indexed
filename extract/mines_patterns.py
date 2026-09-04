"""
Citation extraction for Ministry of Mines corrigenda.

A tenth confirmation of the "corrigendum-substitution" template (see
extract.common_templates) — real text anchors on "Ministry of Mines"
exactly like every other ministry using this shape.

Verified against one real example: G.S.R. 255(E) corrects G.S.R. 222(E),
a Minerals (Other than Atomic and Hydro Carbons Energy Minerals) Concession
(Second Amendment) Rules, 2026 notification (see db/seed_mines.sql). Two
further real note-chains (Mineral Conservation and Development Rules — an
eight-item chain; Mineral (Auction) Rules — a three-item chain) are also
modeled — see the seed file — via extract.common_templates.find_note_chain
instead, not this template.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'mines'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
