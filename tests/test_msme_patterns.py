"""
Regression test for extract.msme_patterns against a real Ministry of MSME
amendment (see db/seed_msme.sql for provenance), quoted from primary "Full
Text" by a research agent.
"""
from extract.msme_patterns import find_candidate_links

MSME_CLASSIFICATION_AMENDMENT = (
    "the Central Government ... hereby makes the following amendments in the notification of "
    "Government of India, Ministry of Micro, Small and Medium Enterprises number S.O. 2119 (E), "
    "dated the 26th June, 2020 ... Note: The principal notification was published in the Gazette "
    "of India, Extraordinary, Part-II, Section 3, Sub-section (ii), vide number S.O. 2119(E), "
    "dated the 26th June, 2020."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(MSME_CLASSIFICATION_AMENDMENT, self_citation='S.O. 1364(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 2119(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(MSME_CLASSIFICATION_AMENDMENT, self_citation='S.O. 1364(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 1364(E)' not in targets
