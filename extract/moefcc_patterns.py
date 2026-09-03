"""
Citation extraction for Ministry of Environment, Forest and Climate Change
(MoEFCC) corrigenda.

Uses the shared "corrigendum-substitution" template (see
extract.common_templates) — confirmed identical in shape to Ministry of
Health and Family Welfare corrigenda (extract.health_patterns), differing
only in ministry name and "read" vs "shall be substituted" wording (which
the template doesn't need to distinguish; it only anchors on the ministry
name and locates the nearby citation).

Verified against three real examples (see db/seed_moefcc.sql for
provenance). One of the three (S.O. 3182(E) -> S.O. 3252(E)) was
independently spot-checked against its source page during this session;
the other two rely on a research agent's quoted primary "Full Text"
excerpts, not a second independent read.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'environment, forest and climate change'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
