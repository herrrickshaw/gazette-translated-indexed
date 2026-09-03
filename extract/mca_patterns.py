"""
Citation extraction for Ministry of Corporate Affairs corrigenda.

Uses the shared "corrigendum-substitution" template (see
extract.common_templates) — a third real confirmation of that template's
"ministry of <name> ... number <citation> ... for [old] read [new]" shape,
alongside MoEFCC and MoHFW.

Verified against one real example: G.S.R. 849(E) corrects a misspelled name
in G.S.R. 703(E) (see db/seed_mca.sql for provenance). A research agent
found two further real MCA pairs (Companies Rules amendments citing their
own amendment history, e.g. "last amended, vide number G.S.R. 360(E)") that
are amendment-history citations rather than a single corrigendum-to-original
pair — a different relationship shape, not modeled here yet.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'corporate affairs'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
