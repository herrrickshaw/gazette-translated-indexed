"""
Regression test for extract.ports_shipping_patterns against three real
Ministry of Ports, Shipping and Waterways notifications (see
db/seed_ports_shipping.sql for provenance), quoted from primary "Full
Text" by a research agent — one corrigendum, one supersession, one
bare-citation-reference amendment.
"""
from extract.ports_shipping_patterns import find_candidate_links

CORRIGENDUM = (
    "G.S.R. 677(E).— In exercise of the powers conferred by sub-section (1) of Section 3 of the "
    "Major Port Authorities Act 2021, the Central Government hereby makes the following "
    "Corrigendum in the notification of the Government of India in the Ministry of Ports, "
    "Shipping and Waterways published vide G. S. R. No. 651 (E), dated 22nd July, 2026 "
    "published in the Extraordinary Gazette of India dated 22nd July, 2026 as under namely, In "
    "the said Notification: \"Principal Secretary\" Shall be deleted."
)

SUPERSESSION = (
    "G.S.R. 651(E). — In exercise of the powers ... and in supersession of the Notification of "
    "the Government of India in the Ministry of Ports, Shipping and Waterways G.S.R. No. 641 "
    "(E) dated 15th October, 2024, except as respects things done or omitted to be done before "
    "such supersession, the Central Government hereby appoints Principal Secretary."
)

BARE_CITATION_AMENDMENT = (
    "S.O. 4353(E). In exercise of the powers conferred by Section 4 of the Merchant Shipping "
    "Act, 1958(44 of 1958) read with Rule 4 of the National Shipping Board Rules, 1960, the "
    "Central Government hereby makes the following amendment in the notification vide "
    "S.O.1935(E) dated the 30th April, 2025."
)


def test_corrigendum_shape():
    links = find_candidate_links(CORRIGENDUM, self_citation='G.S.R. 677(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 651(E)' in targets


def test_supersession_shape():
    links = find_candidate_links(SUPERSESSION, self_citation='G.S.R. 651(E)')
    targets = {l.target_citation for l in links}
    assert 'G.S.R. 641(E)' in targets


def test_bare_citation_shape():
    links = find_candidate_links(BARE_CITATION_AMENDMENT, self_citation='S.O. 4353(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1935(E)' in targets
