"""
Citation extraction for Ministry of Information and Broadcasting
corrigenda.

Uses the "corrigendum-substitution" template's ministry-name anchor (see
extract.common_templates) — real text reads "In the notification of the
Government of India, Ministry of Information and Broadcasting, ... vide
number S.O. 3011(E) ... for X read Y" (and a second real example anchors
on the shorter "Ministry of Information" alone).

Verified against two real corrigenda (see
db/seed_information_broadcasting.sql). A third real pair (DD Podhigai/DD
Tamil channel renaming) is a note-chain whose closing clause is labeled
"Footnote:" rather than "Note:" — the real-text discovery that fixed
extract.common_templates.find_note_chain's anchor regex this batch.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'information and broadcasting'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links = find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
    # A second real example anchors on the shorter "Ministry of
    # Information" alone (no "and Broadcasting"), so also try that.
    links += find_corrigendum_substitution_links(text, 'information', self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
