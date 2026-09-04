"""
Regression test for extract.citation_patterns' S.R.O. ("Statutory Rules and
Orders") support — a third citation series alongside G.S.R./S.O., added
after three real Ministry of Defence notifications turned up using S.R.O.
exclusively (Cantonment Board and Navy Act amendments never cite G.S.R./S.O.
at all), quoted from primary "Full Text" by a research agent.
"""
from extract.citation_patterns import find_gazette_citations, find_gazette_ids

CANTONMENT_BOARD_AMENDMENT = (
    "the Central Government hereby makes the following amendment in the notification of the "
    "Government of India in the Ministry of Defence vide number S.R.O. 19(E), dated the 12nd "
    "November, 2025, published in the Gazette of India (Extraordinary), Part II, Section 4, "
    "dated the 12nd November, 2025, namely:- (i) in serial number 3, in column (3), for clause "
    "(c), the following clause shall be substituted."
)

NAVY_ACT_NOTE = (
    "Note: The principal notification was published in the Gazette of India, Extraordinary, "
    "Part II, section 4, dated the 23rd June, 2022 vide number S.R.O. 9(E), dated the 23rd "
    "June, 2022."
)


def test_finds_sro_citation():
    ids = find_gazette_ids(CANTONMENT_BOARD_AMENDMENT)
    assert ids == ['S.R.O. 19(E)']


def test_sro_kind_is_reported():
    citations = find_gazette_citations(NAVY_ACT_NOTE)
    assert len(citations) == 1
    assert citations[0].kind == 'S.R.O.'
    assert citations[0].normalized == 'S.R.O. 9(E)'


def test_sro_not_confused_with_so_or_gsr():
    # "S.R.O." must not also register as a "S.O." match (no second "S" for
    # _SO_RE to anchor on) or a "G.S.R." match (no "G" at all).
    ids = find_gazette_ids('S.R.O. 42(E)')
    assert ids == ['S.R.O. 42(E)']
