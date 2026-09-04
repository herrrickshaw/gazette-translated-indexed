"""
Citation extraction for Ministry of Culture amendment notifications.

Uses the "corrigendum-substitution" template's anchor (see
extract.common_templates) — real text reads "in partial modification of the
notification of the Ministry of Culture, S.O. 3514(E) dated ..., S.O.
2985(E), dated ... and S.O. 2637(E), dated ...": the ministry-name anchor is
followed by a *list* of three target citations, so the template's forward
window returns all three. This is the project's first genuine one-to-many
example modeled from a single source sentence.

Verified against one real example (S.O. 441(E) partially modifies three
earlier Registering-Officer notifications under the Antiquities and Art
Treasures Act, 1972 — see db/seed_culture.sql). Note the three targets'
own gazette pages were NOT independently located by the research agent;
their citations are corroborated only as quoted inside the 2026 amendment's
primary text. A second real pair cites its original by a bare "No. 108,
File No. ..." rather than a G.S.R./S.O. citation — the same DGFT-style
shape deferred for Commerce, not modeled here.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'culture'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
