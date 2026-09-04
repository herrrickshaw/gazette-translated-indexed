"""
Citation extraction for Ministry of Tribal Affairs amendment notifications.

Uses the "corrigendum-substitution" template's ministry-name anchor (see
extract.common_templates) — real text reads "the Central Government hereby
amends the notification of the Government of India in the Ministry of
Tribal Affairs number S.O. 3786(E), dated the 15th September, 2021". The
verb here is "amends", not the template's usual "for X read Y", but the
template never checks the closing verb — only the ministry-name anchor
followed by a nearby citation.

Verified against the only real Ministry-of-Tribal-Affairs amendment pair
gazettetracker.com indexes (see db/seed_tribal_affairs.sql) — the
ministry's listing has just 2 notifications total, and only one of them
amends the other.
"""
from __future__ import annotations

from .common_templates import TemplateLink, find_corrigendum_substitution_links

MINISTRY_NAME = 'tribal affairs'


def find_candidate_links(text: str, self_citation: str | None = None) -> list[TemplateLink]:
    return find_corrigendum_substitution_links(text, MINISTRY_NAME, self_citation=self_citation)
