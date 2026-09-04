"""
Regression test for extract.atomic_energy_patterns against two real
Department of Atomic Energy amendments (see db/seed_atomic_energy.sql for
provenance), quoted from primary "Full Text" by a research agent.
"""
from extract.atomic_energy_patterns import find_candidate_links

CCA_AUTHORITY_AMENDMENT = (
    "the President hereby makes the following amendments in the Order of the Government of "
    "India, Department of Atomic Energy vide number S.O.3943(E), dated the 17th August, 2022, "
    "published in the Gazette of India, Extraordinary, Part II, Section 3, Sub-section (ii), "
    "dated the 23rd August, 2022, namely: —"
)

NUCLEAR_FUEL_COMPLEX_AMENDMENT = (
    "the President hereby makes the following amendments in the Order of the Government of "
    "India in the Department of Atomic Energy, vide number S.O.1317(E), dated the 16th May, "
    "2013, published in the Gazette of India, Extraordinary, Part II, Section 3, Sub-section "
    "(ii), dated the 22nd May, 2013, namely:-"
)


def test_finds_the_real_amendment_link_pair1():
    links = find_candidate_links(CCA_AUTHORITY_AMENDMENT, self_citation='S.O. 2152(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3943(E)' in targets


def test_finds_the_real_amendment_link_pair2():
    links = find_candidate_links(NUCLEAR_FUEL_COMPLEX_AMENDMENT, self_citation='S.O. 4585(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1317(E)' in targets
