"""
Citation extraction for Ministry of Housing and Urban Affairs (MoHUA)
corrigenda.

A seventh confirmation of the "corrigendum-substitution" template (see
extract.common_templates), alongside MoEFCC, MoHFW, MCA, Labour, MeitY, and
Civil Aviation.

Verified against one real example: S.O. 4041(E) corrects S.O. 3379(E), a
Directorate of Estates notification (see db/seed_mohua.sql for provenance —
the weakest-corroborated pair modeled so far: the research agent flagged it
as resting solely on gazettetracker.com's Full Text, with no independent
web-search corroboration found). A research agent found two further real
pairs (Ladakh RERA rule amendments, a RERA Central Advisory Council
amendment) that fit a Rules/consolidated-instrument shape rather than a
single corrigendum pair — not modeled this round.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'housing and urban affairs'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
