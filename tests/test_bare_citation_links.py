"""
Regression test for extract.common_templates.find_bare_citation_links
against two real, independently-sourced examples with no ministry-name
anchor at all — Ministry of Statistics and Programme Implementation
(two different lead-in phrasings) and Ministry of Ports, Shipping and
Waterways — quoted from primary "Full Text" by research agents.
"""
from extract.common_templates import find_bare_citation_links

MOSPI_VIDE_NOTIFICATION_NUMBER = (
    "S.O. 1767(E). In the Gazette of India, Extraordinary, Part II, Section 3, Sub-section (ii), "
    "vide notification number S.O. 1398(E) dated the 16th March, 2026 [F. No. "
    "M-12011/8/2024/ASSSE (E-68445)], published on 18th March 2026, in Schedule-III, against "
    "Serial Number 4, under the column \"Jurisdiction\", for the words \"Andhra Pradesh, "
    "Telangana, Karnataka\", read \"Andhra Pradesh, Telangana, Karnataka, Tamil Nadu\"."
)

MOSPI_IN_THE_NOTIFICATION = (
    "S.O. 949(E). — In the Notification S.O. 174(E) dated 12th January, 2026, published in the "
    "Gazette of India, Extraordinary, Part II, Section III, Sub-section (ii), at Serial No. 1, "
    "the name of the office is partially modified as under:- \"Regional Office, Darbhanga\" may "
    "be read as \"Sub Regional Office, Darbhanga\". All other contents of the said Notification "
    "shall remain unchanged."
)

PORTS_VIDE_IN_THE_NOTIFICATION = (
    "S.O. 4353(E). In exercise of the powers conferred by Section 4 of the Merchant Shipping "
    "Act, 1958(44 of 1958) read with Rule 4 of the National Shipping Board Rules, 1960, the "
    "Central Government hereby makes the following amendment in the notification vide "
    "S.O.1935(E) dated the 30th April, 2025 ... 'For serial number 11 and entry relating "
    "thereto, may be read as Captain Savio Ramos.'"
)


def test_vide_notification_number_lead_in():
    links = find_bare_citation_links(MOSPI_VIDE_NOTIFICATION_NUMBER, self_citation='S.O. 1767(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1398(E)' in targets


def test_in_the_notification_lead_in():
    links = find_bare_citation_links(MOSPI_IN_THE_NOTIFICATION, self_citation='S.O. 949(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 174(E)' in targets


def test_second_ministry_confirms_the_shape():
    links = find_bare_citation_links(PORTS_VIDE_IN_THE_NOTIFICATION, self_citation='S.O. 4353(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1935(E)' in targets


def test_self_citation_excluded():
    links = find_bare_citation_links(MOSPI_VIDE_NOTIFICATION_NUMBER, self_citation='S.O. 1767(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 1767(E)' not in targets
