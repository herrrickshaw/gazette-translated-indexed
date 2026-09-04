"""
Regression test for extract.external_affairs_patterns against three real
Ministry of External Affairs notifications (see
db/seed_external_affairs.sql for provenance), quoted from primary "Full
Text" by a research agent — a corrigendum, an amendment, and a
double-target supersession.
"""
from extract.external_affairs_patterns import find_candidate_links

CORRIGENDUM = (
    "G.S.R. 253(E). In the notification of the Government of India in the Ministry of External "
    "Affairs, number G.S.R. 216(E), dated the 2nd April, 2025, published in the Gazette of "
    "India, Extraordinary, Part II, Section 3, Sub-section (i), dated the 3rd April, 2025, in "
    "the SCHEDULE, in serial number 16, under the heading \"Geographical Name\", for \"BASELINE "
    "POINT 15\" read \"BASELINE POINT 17\"."
)

AMENDMENT = (
    "the Central Government hereby makes the following amendments in the notification of the "
    "Government of India in the Ministry of External Affairs, published in the Gazette of "
    "India, Extraordinary, Part-II, Section 3, Sub-section (ii), vide number S.O. 135 (E), "
    "dated the 13th January, 2009."
)

DOUBLE_TARGET_SUPERSESSION = (
    "In exercise of the powers conferred by section 15 of the Passports Act, 1967 (15 of 1967), "
    "and in supersession of the notifications of the Government of India in the Ministry of "
    "External Affairs number G.S.R. 662 (E), dated the 1st December, 1979 and G.S.R. 370 (E), "
    "dated the 9th February, 2010, the Central Government hereby authorises."
)


def test_corrigendum_shape():
    links = find_candidate_links(CORRIGENDUM, self_citation='G.S.R. 253(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 216(E)' in targets


def test_amendment_shape():
    links = find_candidate_links(AMENDMENT, self_citation='S.O. 2565(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 135(E)' in targets


def test_double_target_supersession():
    links = find_candidate_links(DOUBLE_TARGET_SUPERSESSION, self_citation='S.O. 3022(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 662(E)' in targets
    assert 'G.S.R. 370(E)' in targets
