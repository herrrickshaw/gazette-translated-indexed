"""
Regression test for extract.ayush_patterns against two real Ministry of
Ayush corrigenda (see db/seed_ayush.sql for provenance), quoted from
primary "Full Text" by a research agent. The two examples use different
closing verbs for the same shape ("for X, read Y" vs. "the words X shall be
read as Y") — the template anchors only on the ministry name, not the verb.
"""
from extract.ayush_patterns import find_candidate_links

EXAMPLE_1 = (
    "G.S.R. 660(E).––In the Notification of the Government of India, Ministry of Ayush number "
    "G.S.R. 669(E) dated the 28th October, 2024, published in Gazette of India Extraordinary, Part II, "
    "Section 3, Sub-section(i) dated the 28th October, 2024, Issue No. 611, in sub point 2 of point 10 "
    "on page no-16 of English version of Gazette notification, for (क) and (ख), read (a) and (b)."
)

EXAMPLE_2 = (
    "G.S.R. 717(E).—In the Notification of the Government of India, Ministry of Ayush published in "
    "the Gazette of India, Extraordinary, Part II, Section 3, Sub-section (i) dated 14th October, 2024 "
    "vide G.S.R 637 (E) – (1) at page 14, column (1), the words \"Deputy Secretary.\" shall be read as "
    "\"1. Deputy Secretary.\"."
)

CASES = [
    (EXAMPLE_1, 'G.S.R. 660(E)', 'G.S.R. 669(E)'),
    (EXAMPLE_2, 'G.S.R. 717(E)', 'G.S.R. 637(E)'),
]


def test_finds_the_real_corrigendum_link_with_either_closing_verb():
    for text, self_citation, expected_target in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        assert expected_target in targets, f'{self_citation}: expected {expected_target} in {targets}'


def test_self_citation_excluded_in_both():
    for text, self_citation, _ in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        assert links, f'{self_citation}: found no links at all'
        assert self_citation not in targets
