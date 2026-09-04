"""
Citation extraction for Ministry of Ports, Shipping and Waterways
corrigenda and amendments.

Combines three existing templates (see extract.common_templates), since
real examples from this ministry fit all three:
  - corrigendum-substitution: "...Corrigendum in the notification of the
    Government of India in the Ministry of Ports, Shipping and Waterways
    published vide G.S.R. No. 651(E)..."
  - supersession-preamble: "...in supersession of the Notification ...
    G.S.R. No. 641(E) dated 15th October, 2024..."
  - bare-citation-reference (no ministry anchor at all): "...the following
    amendment in the notification vide S.O.1935(E) dated..." — the second
    of the two ministries whose evidence justified that template.

Verified against three real examples (see db/seed_ports_shipping.sql). A
fourth real lead (Inland Vessels Rules amendment) is a plain note-chain,
modeled via extract.common_templates.find_note_chain instead.
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_bare_citation_links,
    find_corrigendum_substitution_links,
    find_supersession_links,
)

MINISTRY_NAME = 'ports, shipping and waterways'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_supersession_links(text, self_citation=self_citation)
    links += find_bare_citation_links(text, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
