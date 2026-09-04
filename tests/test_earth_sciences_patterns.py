"""
Regression test for extract.earth_sciences_patterns against a real Ministry
of Earth Sciences amendment (see db/seed_earth_sciences.sql for
provenance), quoted from primary "Full Text" by a research agent.
"""
from extract.earth_sciences_patterns import find_candidate_links

ANTARCTIC_COMMITTEE_AMENDMENT = (
    "the Central Government hereby re-nominate the following persons as expert members of the "
    "Committee for a period of three years from the date of publication of this notification and "
    "for that purpose makes the following amendments in the notification of the Government of "
    "India in the Ministry of Earth Sciences number S.O. 3508 (E), dated the 7th August, 2023... "
    "Note: - The principal notification was published in the Gazette of India, Extraordinary, "
    "Part II, Section 3, Sub-section (ii), vide number S.O. 3508 (E), dated the 7th August, 2023."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(ANTARCTIC_COMMITTEE_AMENDMENT, self_citation='S.O. 4331(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3508(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(ANTARCTIC_COMMITTEE_AMENDMENT, self_citation='S.O. 4331(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 4331(E)' not in targets
