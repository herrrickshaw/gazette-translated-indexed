"""
Citation extraction for Ministry of Defence corrigenda.

A ninth confirmation of the "corrigendum-substitution" template (see
extract.common_templates) — the Cantonment Board member-substitution text
anchors on "Ministry of Defence" exactly like every other ministry using
this shape, the only difference being it cites via S.R.O. (see
extract.citation_patterns) rather than G.S.R./S.O., which the shared
find_gazette_citations already handles.

Verified against one real example: S.R.O. 18(E) corrects S.R.O. 19(E), a
Cantonments Act, 2006 board-member notification (see db/seed_defence.sql).
A second real example (S.R.O. 22(E) amends S.R.O. 9(E), Navy Act service-
branch listing) is a note-chain, not this template — modeled via
extract.common_templates.find_note_chain instead, see the seed file.

Second depth pass (2026-09-07, see db/seed_defence.sql's own header comment
for the full account): the same anchor-and-window scan this module already
reuses also correctly recovers a related but distinct real shape — a
Cantonment Board "constitution" notification's opening recital, "... read
with the notification of the Government of India in the Ministry of
Defence [number] S.R.O. X(E), dated ... containing the declaration varying
certain Cantonment Boards" — even though it is a contextual "cites", not a
"for ... read" substitution. No code change was needed; see
tests/test_defence_patterns.py for the real-text confirmation (S.R.O. 1(E)
[2025-01-03] citing S.R.O. 206(E) [2024-12-31]).
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'defence'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
