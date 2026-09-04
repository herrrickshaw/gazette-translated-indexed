"""
Citation extraction for Ministry of Communications (Department of
Telecommunications) rescission notifications.

Uses the "corrigendum-substitution" template's ministry-name anchor (see
extract.common_templates): real text reads "hereby rescinds the notification
of the Government of India, in the Ministry of Communications, Department
of Telecommunications, dated ... vide number G.S.R.796(E)" — the anchor is
followed by the target citation within the window, same mechanics as a
corrigendum even though the relation is a rescission. Note "G.S.R.796(E)"
with no space before the digits; the citation regex tolerates that.

Verified against one real example: G.S.R. 863(E) rescinds G.S.R. 796(E)
(see db/seed_communications.sql). Two further real pairs amend "the
principal rules" by name without restating the principal's G.S.R. number in
the amending clause — the deferred principal-rules shape — not modeled.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'communications'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
