"""
Regression test for extract.education_patterns against three real Ministry
of Education notifications (see db/seed_education.sql for provenance),
quoted from primary "Full Text" by research agents — one uses the current
ministry name, one the pre-2020 predecessor name, one a rescission shape.
"""
from extract.education_patterns import find_candidate_links

NCTE_AMENDMENT_ERSTWHILE_MHRD = (
    "the Central Government, hereby makes the following amendments to the notification of the "
    "Government of India, in the erstwhile Ministry of Human Resource Development (Department "
    "of School Education and Literacy), vide number S.O.980(E), dated the 4th March, 2020, "
    "published in the Gazette of India, Extraordinary, Part II, Section 3, Sub-Section (ii), "
    "dated 4th March, 2020, namely:— In the said notification, — (i) for serial numbers 18 and "
    "19 and the entries relating thereto, the following serial numbers and entries shall be "
    "substituted."
)

SPA_AMENDMENT_ERSTWHILE_MHRD = (
    "the Central Government hereby makes the following amendments in the notification of the "
    "Government of India, erstwhile Ministry of Human Resource Development (Department of "
    "Higher Education), published in the Gazette of India, Extraordinary, Part-II, Section 3, "
    "Sub-section (ii) vide number S. O. 3239(E), dated the 3rd July, 2018."
)

PUNJAB_UNIVERSITY_RESCISSION = (
    "the Central Government hereby rescinds the notification of the Government of India in the "
    "Ministry of Education, Department of Higher Education, number S.O. 5023 (E), dated the "
    "4th November, 2025, published in the Gazette of India, Extraordinary, Part II, Section 3, "
    "Sub-section (ii), dated the 4th November, 2025."
)


def test_ncte_amendment_erstwhile_mhrd_name():
    links = find_candidate_links(NCTE_AMENDMENT_ERSTWHILE_MHRD, self_citation='S.O. 2247(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 980(E)' in targets


def test_spa_amendment_erstwhile_mhrd_name():
    links = find_candidate_links(SPA_AMENDMENT_ERSTWHILE_MHRD, self_citation='S.O. 4659(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3239(E)' in targets


def test_rescission_current_ministry_name():
    links = find_candidate_links(PUNJAB_UNIVERSITY_RESCISSION, self_citation='S.O. 5063(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 5023(E)' in targets
