"""
Regression test for extract.personnel_patterns against a real Ministry of
Personnel, Public Grievances and Pensions corrigendum (see
db/seed_personnel.sql for provenance), quoted from primary "Full Text" by
a research agent.
"""
from extract.personnel_patterns import find_candidate_links

CORRIGENDUM = (
    "CORRIGENDUM — G.S.R. 472(E).—In partial modification of the Notification G.S.R. 331(E) "
    "dated 21st May, 2025 [File No. 11052/03/2021-AIS-II(A)] issued by the Ministry of "
    "Personnel, P.G. & Pensions (Department of Personnel & Training), at page no. 6, the post "
    "name \"Deputy Inspector General of Police, Special Investigation Bureau\" may be read as "
    "\"Deputy Inspector General of Police, Special Intelligence Branch\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(CORRIGENDUM, self_citation='G.S.R. 472(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 331(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(CORRIGENDUM, self_citation='G.S.R. 472(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'G.S.R. 472(E)' not in targets
