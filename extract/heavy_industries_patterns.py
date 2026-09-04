"""
Citation extraction for Ministry of Heavy Industries corrigenda and
amendments.

Uses the "corrigendum-substitution" template's ministry-name anchor (see
extract.common_templates) — real text reads "In the Notification of the
Ministry of Heavy Industries, Government of India, S.O.1334(E) dated the
13th March, 2024 ... the following amendments ... are hereby made" and
"In partial modification of the ... Scheme ... which was notified by the
Ministry of Heavy Industries vide S.O. No. 3946(E) dated 23rd September
2021". Neither uses this template's usual "for X read Y" closing verb, but
the template never checks the closing verb — only the ministry-name
anchor followed by a nearby citation — so both fit without new code.

Verified against three real examples (see db/seed_heavy_industries.sql):
two Hindi-text-only corrigenda (EMPS-2024, PM E-DRIVE) and one substantive
"partial modification" amendment (PLI-Auto Scheme).
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'heavy industries'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
