"""
Regression test for extract.moefcc_patterns against three real MoEFCC
corrigendum excerpts (see db/seed_moefcc.sql for provenance). Only the first
example was independently spot-checked against its source page during this
session; the other two rely on a research agent's quoted primary text.
"""
from extract.moefcc_patterns import find_candidate_links

# A: independently spot-checked (CG-DL-E-19072023-247431)
EXAMPLE_A = (
    'S.O. 3182(E).—In the notification of the Government of India in the Ministry of Environment, '
    'Forest and Climate Change number S.O. 3252(E), dated the 22nd July, 2022, published in the Gazette '
    'of India, Extraordinary, Part II, Section 3, Sub-section (ii), dated the 22nd July, 2022, at page 2, '
    'in the Schedule, against serial number 1, for the words "M/s Times of India" read "M/s The Times of India".'
)

# B: quoted by research agent from gazettetracker.com, not independently re-fetched
EXAMPLE_B = (
    'S.O. 4101(E).—In the notification of the Government of India in the Ministry of Environment, '
    'Forest and Climate Change vide number S.O. 5254(E), dated the 4th November, 2022, at page number 2, '
    '– (i) for serial number 3 "notification number S.O. (E) ...", read "notification number '
    'S.O. 5254 (E), dated the 4th November, 2022 in the Official Gazette".'
)

# C: quoted by research agent from gazettetracker.com, not independently re-fetched
EXAMPLE_C = (
    'G.S.R. 731(E). In the notification of the Government of India in the Ministry of Environment, '
    'Forest and Climate Change vide number G.S.R. 766 (E), dated the 10th August, 2018, in English '
    'version of the Compensatory Afforestation Fund Rules, 2018, at page 35, in line 15, for "The annual '
    'plan of operation of State Authority", read "39. The annual plan of operation of State Authority".'
)

CASES = [
    (EXAMPLE_A, 'S.O. 3182(E)', 'S.O. 3252(E)'),
    (EXAMPLE_B, 'S.O. 4101(E)', 'S.O. 5254(E)'),
    (EXAMPLE_C, 'G.S.R. 731(E)', 'G.S.R. 766(E)'),
]


def test_finds_the_real_corrigendum_link_in_every_example():
    for text, self_citation, expected_target in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        assert expected_target in targets, f'{self_citation}: expected {expected_target} in {targets}'


def test_self_citation_excluded_in_every_example():
    for text, self_citation, _ in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        # A negative check is meaningless if nothing was found at all — assert
        # the positive control (the real target) alongside the exclusion.
        assert targets, f'{self_citation}: found no links at all (would make the exclusion check vacuous)'
        assert self_citation not in targets
