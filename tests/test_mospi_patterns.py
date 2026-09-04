"""
Regression test for extract.mospi_patterns against two real Ministry of
Statistics and Programme Implementation corrigenda (see db/seed_mospi.sql
for provenance), quoted from primary "Full Text" by a research agent.
"""
from extract.mospi_patterns import find_candidate_links

VIDE_NOTIFICATION_NUMBER = (
    "S.O. 1767(E). In the Gazette of India, Extraordinary, Part II, Section 3, Sub-section (ii), "
    "vide notification number S.O. 1398(E) dated the 16th March, 2026, published on 18th March "
    "2026, in Schedule-III, against Serial Number 4, for the words \"Andhra Pradesh\", read "
    "\"Andhra Pradesh, Telangana\"."
)

IN_THE_NOTIFICATION = (
    "S.O. 949(E). — In the Notification S.O. 174(E) dated 12th January, 2026, published in the "
    "Gazette of India, Extraordinary, Part II, Section III, Sub-section (ii), at Serial No. 1, "
    "the name of the office is partially modified as under:- \"Regional Office, Darbhanga\" may "
    "be read as \"Sub Regional Office, Darbhanga\"."
)


def test_vide_notification_number_shape():
    links = find_candidate_links(VIDE_NOTIFICATION_NUMBER, self_citation='S.O. 1767(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1398(E)' in targets


def test_in_the_notification_shape():
    links = find_candidate_links(IN_THE_NOTIFICATION, self_citation='S.O. 949(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 174(E)' in targets
