"""
Regression test for extract.chemicals_fertilizers_patterns against three
real National Pharmaceutical Pricing Authority corrigenda (see
db/seed_chemicals_fertilizers.sql for provenance), quoted from primary
"Full Text" by a research agent.
"""
from extract.chemicals_fertilizers_patterns import find_candidate_links

RINGER_LACTATE_CORRIGENDUM = (
    "S.O. 2682(E).- In the National Pharmaceutical Pricing Authority's notification S.O. 1584(E), "
    "dated 25.03.2026 relating to the fixation of separate ceiling price of Ringer Lactate, "
    "published in the Gazette of India, Extraordinary, in the Table-B, the name of the "
    "manufacturer and product/ brand name mentioned in column no. 2 & 3 at Sl. No.4, is to be "
    "read as follows: ... 2. All the notes and other contents mentioned in the original order "
    "S.O. 1584(E), dated 25.03.2026 relating to Sl. No. 4 of the table shall remain the same."
)

RETAIL_PRICE_CORRIGENDUM = (
    "S.O. 1592(E), — In the National Pharmaceutical Pricing Authority's notification S.O. "
    "5635(E), dated 02.11.2018 relating to the fixation of retail price, published in the "
    "Gazette of India, Extraordinary, in the Table, the name of the manufacturer and marketing "
    "company mentioned in column no. 8 for the Sl. No. 7, is to be henceforth, read as 'M/s Sun "
    "Pharmaceutical Industries Limited' instead of 'M/s Pure and Cure Healthcare Pvt. Ltd. and "
    "M/s Sun Pharmaceutical Industries Limited'."
)


def test_finds_the_real_corrigendum_link():
    links = find_candidate_links(RINGER_LACTATE_CORRIGENDUM, self_citation='S.O. 2682(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 1584(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(RINGER_LACTATE_CORRIGENDUM, self_citation='S.O. 2682(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 2682(E)' not in targets


def test_second_real_example_different_closing_verb():
    # "is to be read as follows" vs. "is to be henceforth, read as" — the
    # anchor doesn't care about the closing verb, only the NPPA phrase.
    links = find_candidate_links(RETAIL_PRICE_CORRIGENDUM, self_citation='S.O. 1592(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 5635(E)' in targets


def test_qco_rescission_via_corrigendum_substitution():
    # A distinct real shape from Department of Chemicals and Petrochemicals
    # (not NPPA): "hereby rescinds the notification ... Ministry of
    # Chemicals and Fertilizers number X ... with immediate effect".
    rescission = (
        "S.O. 5527(E). — the Central Government being of the opinion that it is necessary so to do "
        "in the public interest, after consulting the Bureau of Indian Standards, hereby rescinds "
        "the notification of the Government of India in the Ministry of Chemicals and Fertilizers "
        "number S.O. 3929(E), dated the 13th September, 2021, relating to p-Xylene (Quality "
        "Control) Order, 2021 with immediate effect."
    )
    links = find_candidate_links(rescission, self_citation='S.O. 5527(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3929(E)' in targets
