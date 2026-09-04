"""
Citation extraction for Ministry of Statistics and Programme
Implementation (MoSPI) corrigenda.

Uses the "bare-citation-reference" template (see extract.common_templates)
— real text names its target with no "Ministry of MoSPI" anchor at all:
"...vide notification number S.O. 1398(E) dated..." and, in a second real
example, "In the Notification S.O. 174(E) dated...". This is one of the
two ministries whose evidence justified writing that template.

Verified against two real corrigenda (see db/seed_mospi.sql). A third real
lead cites its target only by date and File No. (no S.O. number in the
amending text itself) and a fourth is a bare file-number-only pair — both
deliberately not modeled.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_bare_citation_links


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_bare_citation_links(text, self_citation=self_citation)
