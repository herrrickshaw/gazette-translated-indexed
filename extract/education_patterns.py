"""
Citation extraction for Ministry of Education (Department of School
Education and Literacy + Department of Higher Education).

Both departments share one gazettetracker.com listing because the
Ministry of Education is the 2020 merger of the erstwhile Ministry of
Human Resource Development — and real text from BOTH departments still
sometimes cites the pre-merger name verbatim ("...erstwhile Ministry of
Human Resource Development (Department of Higher/School Education...)").
So this module tries the amendment-in-notification template under both
'education' and 'human resource development', plus corrigendum-
substitution under 'education' for a rescission-shaped real example that
doesn't use the "makes the following amendment" phrasing.

Verified against real examples from both departments (see
db/seed_education.sql): Architects Act and School of Planning and
Architecture Act amendments (Higher Education), NCTE General Body
amendment (School Education), and a Punjab University rescission (Higher
Education).
"""
from __future__ import annotations

from .common_templates import (
    TemplateLink,
    find_amendment_in_notification_links,
    find_corrigendum_substitution_links,
)

_MINISTRY_NAMES = ('education', 'human resource development')


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    links: list[TemplateLink] = []
    for name in _MINISTRY_NAMES:
        links += find_amendment_in_notification_links(text, name, self_citation=self_citation)
    links += find_corrigendum_substitution_links(text, 'education', self_citation=self_citation)
    seen = set()
    out = []
    for l in links:
        if l.target_citation not in seen:
            seen.add(l.target_citation)
            out.append(l)
    return out
