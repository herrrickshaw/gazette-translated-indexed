"""
Citation extraction for Ministry of Labour and Employment corrigenda.

A fourth confirmation of the "corrigendum-substitution" template (see
extract.common_templates), alongside MoEFCC, MoHFW, and MCA.

Verified against one real example: S.O. 4573(E) corrects wording in
S.O. 2455(E), a Code on Wages, 2019 compoundable-offences notification (see
db/seed_labour.sql for provenance). A research agent found two further real
corrigenda (G.S.R. 703(E)/704(E) correcting the EPF/EPS Schemes, 2026) that
cite a named Scheme directly ("In the Employees' Provident Funds Scheme,
2026, published ... vide number G.S.R. 525(E)") rather than "the
notification ... in the Ministry of Labour and Employment" — a different
anchor shape, not modeled here yet.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'labour and employment'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
