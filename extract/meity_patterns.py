"""
Citation extraction for Ministry of Electronics and Information Technology
(MeitY) corrigenda.

A fifth confirmation of the "corrigendum-substitution" template (see
extract.common_templates), alongside MoEFCC, MoHFW, MCA, and Ministry of
Labour and Employment.

Verified against one real example: G.S.R. 148(E) corrects G.S.R. 120(E),
an IT (Intermediary Guidelines and Digital Media Ethics Code) Amendment
Rules, 2026 correction (see db/seed_meity.sql for provenance). A research
agent found a second real pair (G.S.R. 892(E) correcting the Digital
Personal Data Protection Rules, 2025) that fits the same template — a real
lead, not modeled this round purely for time.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'electronics and information technology'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
