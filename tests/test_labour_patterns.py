"""
Regression test for extract.labour_patterns against one real Labour
Ministry corrigendum (see db/seed_labour.sql for provenance: S.O. 4573(E)
corrects S.O. 2455(E)), quoted from primary "Full Text" by a research agent.
"""
from extract.labour_patterns import find_candidate_links

EXAMPLE = (
    'S.O. 4573(E).— In the notification of the Government of India in the Ministry of Labour and '
    'Employment, published in Gazette of India, Extraordinary, Part II, Section 3, Sub-section (ii), '
    'Issue No.2363, vide number S.O. 2455(E), dated 12th May, 2026, in page 3, for "to compound the '
    'offences punishable with imprisonment only, or with imprisonment and also with fine," read "to '
    'compound any offence under the Code on Wages, 2019, other than an offence punishable with '
    'imprisonment only or with imprisonment and also with fine".'
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 4573(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 2455(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 4573(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 4573(E)' not in targets
