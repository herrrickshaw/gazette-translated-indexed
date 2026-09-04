"""
Regression test for extract.finance_other_patterns against a real Ministry
of Finance, Department of Expenditure corrigendum (see
db/seed_finance_other.sql for provenance), quoted from primary "Full Text"
by a research agent.
"""
from extract.finance_other_patterns import find_candidate_links

PFMS_CORRIGENDUM = (
    "G.S.R. 580(E).— In the Notification of the Government of India, Ministry of Finance, "
    "Department of Expenditure, in pursuance of Section 4(4)(b)(ii) of the Aadhaar Act, 2016 "
    "vide number G.S.R. 859(E), dated the 21st November 2025, at page 3,- for \"PFMS Mobile "
    "Application\" read \"PFMS Web and Mobile Applications\"."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(PFMS_CORRIGENDUM, self_citation='G.S.R. 580(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 859(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(PFMS_CORRIGENDUM, self_citation='G.S.R. 580(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'G.S.R. 580(E)' not in targets
