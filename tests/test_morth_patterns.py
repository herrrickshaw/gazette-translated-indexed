"""
Regression test for extract.morth_patterns against three real MoRTH
corrigendum sentences (see db/seed_morth.sql for full provenance on each).

Example A is the primary-source "Full Text" of S.O. 4848(E), read directly
off Gazette Tracker's page for that notification. Examples B and C are
literal indexed excerpts from Gazette Tracker's full-text search results for
"corrigendum National Highways Act" — genuine document text, not an AI
summary, though sourced from a search snippet rather than an independently
downloaded gazette PDF (a real but slightly weaker provenance tier than A;
see db/seed_morth.sql).

An earlier version of this test used Gazette Tracker's *AI-generated summary*
sentence for example A instead of its actual primary text, even though both
were on the same page — which is why the extractor's original phrase list
("to amend notification") didn't match any of these three real examples.
Fixed by reading the primary text and rebuilding the fixtures from it.
"""
from extract.morth_patterns import find_candidate_links

# A: full primary text of S.O. 4848(E), corrigendum to S.O. 4872(E)
EXAMPLE_A = (
    "S.O. 4848(E). In exercise of powers conferred by clause (a) of section 3 of the National Highways "
    "Act, 1956 (48of 1956), the Central Government, hereby makes the following amendment in the "
    "notification of the Government of India in the Ministry of Road Transport and Highways, S.O 4872(E) "
    "dated 24.10.2025 (Principal Notification) & published in the Gazette of India, Extraordinary, "
    "Part-II, Section 3 Sub-Section (ii) as per the schedule given below."
)

# B: indexed search excerpt, corrigendum S.O. 2432(E) (30 May 2025) to S.O. 732(E) (11.02.2025)
EXAMPLE_B = (
    "CORRIGENDUM New Delhi, the 30th May, 2025 S.O. 2432(E).—In exercise of powers conferred by clause "
    "(a) of Section 3 of the National Highways Act, 1956 (48 of 1956), the Central Government hereby "
    "makes the following amendment in notification of the government of India in the Ministry of Road "
    "Transport and Highways, S.O. 732(E) dated 11.02.2025, by substituting an entry in the schedule."
)

# C: indexed search excerpt, corrigendum S.O. 4689(E) (25 Oct 2024) to S.O. 1265(E) (16.03.2018)
EXAMPLE_C = (
    "CORRIGENDUM New Delhi, the 25th October, 2024 S.O. 4689(E).—In exercise of powers conferred by "
    "clause (a) of section 3 of the National Highways Act, 1956(48 of 1956), the Central Government "
    "hereby makes the following amendment in notification of the government of India in the Ministry of "
    "Road Transport and Highways, S.O. 1265(E) dated 16.03.2018, substituting the designated Competent "
    "Authority."
)

CASES = [
    (EXAMPLE_A, 'S.O. 4848(E)', 'S.O. 4872(E)'),
    (EXAMPLE_B, 'S.O. 2432(E)', 'S.O. 732(E)'),
    (EXAMPLE_C, 'S.O. 4689(E)', 'S.O. 1265(E)'),
]


def test_finds_the_real_corrigendum_link_in_every_example():
    for text, self_so, expected_target in CASES:
        links = find_candidate_links(text, self_so=self_so)
        targets = {l.target_citation for l in links}
        assert expected_target in targets, f'{self_so}: expected {expected_target} in {targets}'


def test_self_citation_excluded_in_every_example():
    for text, self_so, _ in CASES:
        links = find_candidate_links(text, self_so=self_so)
        targets = {l.target_citation for l in links}
        assert self_so not in targets


def test_positive_control_links_are_never_empty():
    # A negative check (self-exclusion, above) is meaningless if nothing was
    # found at all — assert the positive control explicitly.
    for text, self_so, expected_target in CASES:
        links = find_candidate_links(text, self_so=self_so)
        assert links, f'{self_so}: found no links at all'
