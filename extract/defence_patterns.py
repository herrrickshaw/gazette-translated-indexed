"""
Citation extraction for Ministry of Defence corrigenda.

A ninth confirmation of the "corrigendum-substitution" template (see
extract.common_templates) — the Cantonment Board member-substitution text
anchors on "Ministry of Defence" exactly like every other ministry using
this shape, the only difference being it cites via S.R.O. (see
extract.citation_patterns) rather than G.S.R./S.O., which the shared
find_gazette_citations already handles.

Verified against one real example: S.R.O. 18(E) corrects S.R.O. 19(E), a
Cantonments Act, 2006 board-member notification (see db/seed_defence.sql).
A second real example (S.R.O. 22(E) amends S.R.O. 9(E), Navy Act service-
branch listing) is a note-chain, not this template — modeled via
extract.common_templates.find_note_chain instead, see the seed file.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'defence'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
