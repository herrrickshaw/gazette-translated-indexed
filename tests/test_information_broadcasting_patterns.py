"""
Regression test for extract.information_broadcasting_patterns against two
real Ministry of Information and Broadcasting corrigenda (see
db/seed_information_broadcasting.sql for provenance), quoted from primary
"Full Text" by a research agent — one uses the full ministry name, the
other a shortened "Ministry of Information" alone.
"""
from extract.information_broadcasting_patterns import find_candidate_links

SPORTS_BROADCAST_CORRIGENDUM = (
    "In the notification of the Government of India, Ministry of Information and Broadcasting, "
    "dated the 11th June, 2026, published in Gazette of India, Extraordinary, Part II, Section "
    "3, Sub-Section (ii), vide number S.O. 3011(E), dated the 11th June, 2026, in the english "
    "version of the said notification, at page 3, in lines 24-25, for 'All official One-Day...' "
    "read 'All official One-Day...'."
)

PRESS_COUNCIL_CORRIGENDUM = (
    "In the Notification of the Government of India, Ministry of Information number "
    "S.O.2942(E) dated the 3rd July, 2023, published in Gazette of India Extraordinary, Part "
    "II, Section 3, Sub-section(ii) dated the 5th July, 2023, Issue No. 2817, in line 11, for "
    "'English', read 'Indian'."
)


def test_full_ministry_name_shape():
    links = find_candidate_links(SPORTS_BROADCAST_CORRIGENDUM, self_citation='S.O. 3348(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 3011(E)' in targets


def test_shortened_ministry_name_shape():
    links = find_candidate_links(PRESS_COUNCIL_CORRIGENDUM, self_citation='S.O. 3339(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 2942(E)' in targets
