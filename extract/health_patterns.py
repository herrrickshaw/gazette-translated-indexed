"""
Citation extraction for Ministry of Health and Family Welfare corrigenda.

Uses the shared "corrigendum-substitution" template (see
extract.common_templates) — same shape as MoEFCC's (extract.moefcc_patterns).

Verified against one real example: G.S.R. 11(E) corrects G.S.R. 10(E) (see
db/seed_health.sql for provenance). A research agent found two further real
pairs involving draft-to-final rule amendments under Drugs and Cosmetics Act
sections 12/33 — a legally distinct mechanism from a corrigendum, and not
modeled here yet; noted as real leads in the seed file.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'health and family welfare'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
