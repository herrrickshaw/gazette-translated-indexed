"""
Regression test for extract.tribal_affairs_patterns against the real
Ministry of Tribal Affairs amendment (see db/seed_tribal_affairs.sql for
provenance), quoted from primary "Full Text" by a research agent.
"""
from extract.tribal_affairs_patterns import find_candidate_links

NCST_AMENDMENT = (
    "Now, therefore, the Central Government hereby amends the notification of the Government of "
    "India in the Ministry of Tribal Affairs number S.O. 3786(E), dated the 15th September, 2021 "
    "namely:- \"In the said notification, serial number 1 and the entries relating thereto shall "
    "be omitted.\""
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(NCST_AMENDMENT, self_citation='S.O. 3566(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3786(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(NCST_AMENDMENT, self_citation='S.O. 3566(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 3566(E)' not in targets
