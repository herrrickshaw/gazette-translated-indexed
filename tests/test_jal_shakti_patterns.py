"""
Regression test for extract.jal_shakti_patterns against two real Ministry
of Jal Shakti amendments (see db/seed_jal_shakti.sql for provenance),
quoted from primary "Full Text" by a research agent — one uses the current
ministry name, the other its pre-2019 predecessor name.
"""
from extract.jal_shakti_patterns import find_candidate_links

DAM_SAFETY_AMENDMENT = (
    "the Central Government hereby makes the following amendments in the notification of the "
    "Government of India in the Ministry of Jal Shakti, published in the Gazette of India, "
    "Extraordinary, Part II, Section 3, Sub-section (ii), vide number S.O. 3395(E), dated the "
    "24th July, 2025, namely:- In the said notification, in the Table,- (i) for serial number "
    "11 and the entries relating thereto, the following serial number and entries shall be "
    "substituted."
)

CLEAN_GANGA_AMENDMENT = (
    "the Central Government hereby makes the following amendment in the notification of the "
    "Government of India in the erstwhile Ministry of Water Resources, River Development, and "
    "Ganga Rejuvenation number S.O. 3187 (E), dated the 7th October, 2016, namely: - In the "
    "said notification, in the SCHEDULE, in column (3), after item (i) the following item and "
    "entries shall be inserted."
)


def test_current_ministry_name_shape():
    links = find_candidate_links(DAM_SAFETY_AMENDMENT, self_citation='S.O. 4675(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3395(E)' in targets


def test_predecessor_ministry_name_shape():
    links = find_candidate_links(CLEAN_GANGA_AMENDMENT, self_citation='S.O. 3845')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3187(E)' in targets
