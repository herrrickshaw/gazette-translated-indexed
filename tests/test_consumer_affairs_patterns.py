"""
Regression test for extract.consumer_affairs_patterns against two real
Department of Food and Public Distribution amendment orders that both
amend the same parent order (see db/seed_consumer_affairs.sql for
provenance) — two distinct amendment edges into one original, quoted from
primary "Full Text" by a research agent.
"""
from extract.consumer_affairs_patterns import find_candidate_links

EXAMPLE_1 = (
    "S.O. 3926(E). In exercise of the powers conferred by Section 3 of the Essential Commodities Act, "
    "1955 (10 of 1955), the Central Government hereby makes the following amendment in the order of the "
    "Government of India in the Department of Food and Public Distribution published in the Gazette of "
    "India, Extraordinary, Part (II) Section-3, Sub Section(ii) vide S.O. 2359(E) dated 27th May 2025, "
    "namely: In the said Order, Paragraph 2(i) shall be replaced as under."
)

EXAMPLE_2 = (
    "S.O. 245(E). In exercise of the powers conferred by Section 3 of the Essential Commodities Act, "
    "1955 (10 of 1955), the Central Government hereby makes the following amendment in the order of the "
    "Government of India in the Department of Food and Public Distribution published in the Gazette of "
    "India vide S.O. 2359(E) dated 27th May 2025, namely: In the said Order, Paragraph 2(i) shall be "
    "replaced as under."
)

CASES = [
    (EXAMPLE_1, 'S.O. 3926(E)'),
    (EXAMPLE_2, 'S.O. 245(E)'),
]


def test_both_examples_link_to_the_same_parent_order():
    for text, self_citation in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        assert 'S.O. 2359(E)' in targets, f'{self_citation}: expected S.O. 2359(E) in {targets}'


def test_self_citation_excluded_in_both_examples():
    for text, self_citation in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        assert links, f'{self_citation}: found no links at all'
        assert self_citation not in targets
