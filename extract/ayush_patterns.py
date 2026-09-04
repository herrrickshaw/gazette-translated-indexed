"""
Citation extraction for Ministry of Ayush corrigenda.

An eighth confirmation of the "corrigendum-substitution" template (see
extract.common_templates) — real text uses two different closing verbs
("for X read Y" and "the words X shall be read as Y") for the same
"Ministry of Ayush ... number <citation>" anchor shape; the template
doesn't need to distinguish them, it only anchors on the ministry name.

Verified against one real example: G.S.R. 660(E) corrects G.S.R. 669(E), a
Drugs (Fifth Amendment) Rules, 2024 notification (see db/seed_ayush.sql).
A second real corrigendum (G.S.R. 717(E)/G.S.R. 637(E)) and a real
three-item note-chain (S.O. 563(E) -> S.O. 221(E) -> S.O. 2281(E), NCISM
Act appointments) are also modeled — see the seed file.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'ayush'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
