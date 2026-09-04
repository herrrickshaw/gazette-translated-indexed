"""
Regression test for extract.culture_patterns against one real Ministry of
Culture amendment that partially modifies THREE earlier notifications in a
single clause (see db/seed_culture.sql for provenance). First one-to-many
case in the suite: the template's forward window must return all three
targets from one anchor, not just the first.
"""
from extract.culture_patterns import find_candidate_links

EXAMPLE = (
    "S.O. 441(E).—In exercise of the powers conferred by Section 15 of the Antiquities and Art "
    "Treasures Act, 1972 (52 of 1972) and in partial modification of the notification of the Ministry "
    "of Culture, S. O. 3514(E) dated 29th July, 2022, S.O. 2985(E), dated the 6th July, 2023 and "
    "S.O. 2637(E), dated the 5th July, 2024, the Central Government hereby appoints the persons "
    "mentioned in column 5 and 6 in the Table to be Registering Officers for the purpose of the said Act."
)

EXPECTED_TARGETS = {'S.O. 3514(E)', 'S.O. 2985(E)', 'S.O. 2637(E)'}


def test_finds_all_three_targets_from_one_clause():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 441(E)')
    targets = {l.target_citation for l in links}
    assert EXPECTED_TARGETS <= targets, f'missing {EXPECTED_TARGETS - targets}'


def test_self_citation_excluded():
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 441(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all — would make this exclusion check vacuous'
    assert 'S.O. 441(E)' not in targets


def test_spaced_citation_form_is_normalized():
    # Real text writes the first target as "S. O. 3514(E)" (space after "S.")
    # — confirm it normalizes to the canonical "S.O. 3514(E)" rather than
    # being dropped or reported in a second spelling.
    links = find_candidate_links(EXAMPLE, self_citation='S.O. 441(E)')
    assert 'S.O. 3514(E)' in {l.target_citation for l in links}
