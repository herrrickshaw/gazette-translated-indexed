"""
Citation extraction for Ministry of Agriculture and Farmers Welfare
amendment and corrigendum notifications.

Combines two templates (see extract.common_templates):
  - amendment-in-notification — "hereby makes the following amendments in
    the notification[s] of Government of India in the Ministry of
    Agriculture and Farmers Welfare ... vide number X" (Fertiliser Control
    Order, Public Premises Act pairs).
  - corrigendum-substitution — "In the Notification of the Government of
    India, Ministry of Agriculture and Farmers Welfare, ... vide number X
    ... for [old] read [new]" — a real corrigendum shape that never says
    "makes the following amendment" at all, so the first template alone
    misses it (a National Institute of Occupational Health name-typo
    corrigendum, S.O. 1935(E) correcting S.O. 1177(E)).

Verified against real examples across several subject areas — Fertiliser
Control Order, Public Premises Act, and the corrigendum above (see
db/seed_agriculture.sql for full provenance). The Protection of Plant
Varieties and Farmers' Rights Act chains (S.O. 1589(E), a 13-node chain,
and a separate S.O. 1536(E) chain) and a Coconut Development Board Act
chain are pure note-chains, modeled via
extract.common_templates.find_note_chain instead — no new code needed.
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_amendment_in_notification_links,
    find_corrigendum_substitution_links,
)

MINISTRY_NAME = 'agriculture and farmers welfare'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_amendment_in_notification_links(text, MINISTRY_NAME, self_citation=self_citation)
    links += find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
