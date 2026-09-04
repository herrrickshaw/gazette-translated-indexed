"""
Citation extraction for Ministry of Finance departments OTHER than
Revenue/CBIC (already modeled separately, see extract/citation_patterns.py
and db/seed_cbic.sql) — Department of Economic Affairs, Department of
Expenditure, Department of Financial Services, DIPAM.

Uses the "corrigendum-substitution" template's ministry-name anchor (see
extract.common_templates) — real text reads "In the Notification of the
Government of India, Ministry of Finance, Department of Expenditure, ...
vide number G.S.R. 859(E)...".

Verified against one real example (see db/seed_finance_other.sql). A
second real pair (FEMA Non-debt Instrument Rules) is a note-chain, modeled
via extract.common_templates.find_note_chain instead — genuinely PARTIAL,
since only the first and last of its 18 listed intermediate amendments
were transcribed, not all 18 (an artifact of this session's own research
pass, not a website limitation) — the 16-item gap between them is real
and left unbridged. A third real lead (a cross-department DEA-amends-DFS
notification) is bare "Notification No." form on both ends and is
deliberately not modeled.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'finance'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
