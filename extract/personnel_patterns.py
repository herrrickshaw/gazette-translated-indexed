"""
Citation extraction for Ministry of Personnel, Public Grievances and
Pensions (Department of Personnel and Training) corrigenda.

A genuinely distinct drafting shape from every existing template: real
text reads "In partial modification of the Notification G.S.R. 331(E)
dated 21st May, 2025 [File No. ...] issued by the Ministry of Personnel,
P.G. & Pensions (Department of Personnel & Training), ... the post name
X may be read as Y" — the target citation comes right after "the
Notification", BEFORE the ministry name is even mentioned (same reversed
order that justified extract.railways_patterns as its own module rather
than forced into corrigendum-substitution). Reuses
extract.common_templates.find_after_anchor with its own anchor.

Verified against two real examples (near-identical corrigenda issued the
same day under two different G.S.R. numbers — a genuine site/administrative
duplicate, not a data error; see db/seed_personnel.sql).
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_after_anchor

_ANCHOR = 'in partial modification of the notification'
_WINDOW_CHARS = 60  # the citation follows almost immediately


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_after_anchor(text, _ANCHOR, self_citation, window_chars=_WINDOW_CHARS)
