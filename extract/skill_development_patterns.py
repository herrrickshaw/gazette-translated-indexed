"""
Citation extraction for Ministry of Skill Development and Entrepreneurship.

The first ministry this project has needed two different templates for in
one module: a plain corrigendum (G.S.R. 744(E) corrects G.S.R. 130(E), "for
2024 substitute 2025" — corrigendum-substitution template) alongside two
supersessions under the Apprentices Act, 1961 (S.O. 4072(E) supersedes a
Ministry of LABOUR notification G.S.R. 479(E); S.O. 4560(E) supersedes this
ministry's own S.O. 1348(E) reconstituting the Central Apprenticeship
Council) — the real evidence for the new "supersession-preamble" template
(see extract.common_templates). Both are tried and their results merged,
since a real document from this ministry can be either shape.

See db/seed_skill_development.sql. A fourth real lead (a scheme
modification via "Notification No. SL-11/01/2023-T&P dated ...") is a bare
form with no G.S.R./S.O./S.R.O. number and is deliberately not modeled.
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_corrigendum_substitution_links,
    find_supersession_links,
)

MINISTRY_NAME = 'skill development and entrepreneurship'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_supersession_links(text, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
