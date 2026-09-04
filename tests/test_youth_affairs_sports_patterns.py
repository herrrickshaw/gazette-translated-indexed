"""
Regression test for extract.youth_affairs_sports_patterns against a real
Ministry of Youth Affairs and Sports notification (see
db/seed_youth_affairs_sports.sql for provenance), quoted from primary
"Full Text" by a research agent — a real one-to-many example (one clause
naming three predecessor notifications at once).
"""
from extract.youth_affairs_sports_patterns import find_candidate_links

NSDF_COUNCIL_MODIFICATION = (
    "S.O. 2292(E). In partial modification of Government of India, Ministry of Youth Affairs & "
    "Sports Notifications S.O. 973 (E) dated 12th November, 1998, S.O.525 (E) dated 22nd March "
    "2012 and S.O. 4478 (E) dated 17.12.2019, the Central Government makes the following "
    "changes in the Council of the National Sports Development Fund (NSDF)."
)


def test_finds_all_three_real_targets():
    links = find_candidate_links(NSDF_COUNCIL_MODIFICATION, self_citation='S.O. 2292(E)')
    targets = {l.target_citation for l in links}
    assert {'S.O. 973(E)', 'S.O. 525(E)', 'S.O. 4478(E)'} <= targets


def test_self_citation_excluded():
    links = find_candidate_links(NSDF_COUNCIL_MODIFICATION, self_citation='S.O. 2292(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.O. 2292(E)' not in targets
