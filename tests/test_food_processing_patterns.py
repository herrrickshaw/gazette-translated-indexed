"""
Regression test for extract.food_processing_patterns against a real
Ministry of Food Processing Industries amendment (see
db/seed_food_processing.sql for provenance), quoted from primary "Full
Text" by a research agent.
"""
from extract.food_processing_patterns import find_candidate_links

NIFTEM_COUNCIL_AMENDMENT = (
    "the Central Government hereby makes the following amendment in the notification of the "
    "Government of India, Ministry of Food Processing Industries, published in the Gazette of "
    "India, Extraordinary, Part II, Section 3, Sub-section (ii) vide number S.O. 5577(E), dated "
    "the 3rd December, 2025 ... In the said notification, in the table, against serial number 4, "
    "in column (2), for the entry under the sub-heading \"Council of State\", the entry \"Dr. "
    "Sikander Kumar\" shall be substituted."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(NIFTEM_COUNCIL_AMENDMENT, self_citation='S.O. 4784(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 5577(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(NIFTEM_COUNCIL_AMENDMENT, self_citation='S.O. 4784(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 4784(E)' not in targets
