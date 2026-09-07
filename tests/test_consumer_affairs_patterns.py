"""
Regression test for extract.consumer_affairs_patterns against two real
Department of Food and Public Distribution amendment orders that both
amend the same parent order (see db/seed_consumer_affairs.sql for
provenance) — two distinct amendment edges into one original, quoted from
primary "Full Text" by a research agent.

Also covers the depth pass (2026-09-07): a real "further amendment"
variant of the same shared template (fixed in extract.common_templates,
see that module's docstring) and two real note-chain shapes needing no new
extraction code.
"""
from extract.common_templates import find_note_chain
from extract.consumer_affairs_patterns import find_candidate_links

EXAMPLE_1 = (
    "S.O. 3926(E). In exercise of the powers conferred by Section 3 of the Essential Commodities Act, "
    "1955 (10 of 1955), the Central Government hereby makes the following amendment in the order of the "
    "Government of India in the Department of Food and Public Distribution published in the Gazette of "
    "India, Extraordinary, Part (II) Section-3, Sub Section(ii) vide S.O. 2359(E) dated 27th May 2025, "
    "namely: In the said Order, Paragraph 2(i) shall be replaced as under."
)

EXAMPLE_2 = (
    "S.O. 245(E). In exercise of the powers conferred by Section 3 of the Essential Commodities Act, "
    "1955 (10 of 1955), the Central Government hereby makes the following amendment in the order of the "
    "Government of India in the Department of Food and Public Distribution published in the Gazette of "
    "India vide S.O. 2359(E) dated 27th May 2025, namely: In the said Order, Paragraph 2(i) shall be "
    "replaced as under."
)

CASES = [
    (EXAMPLE_1, 'S.O. 3926(E)'),
    (EXAMPLE_2, 'S.O. 245(E)'),
]


def test_both_examples_link_to_the_same_parent_order():
    for text, self_citation in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        assert 'S.O. 2359(E)' in targets, f'{self_citation}: expected S.O. 2359(E) in {targets}'


def test_self_citation_excluded_in_both_examples():
    for text, self_citation in CASES:
        links = find_candidate_links(text, self_citation=self_citation)
        targets = {l.target_citation for l in links}
        assert links, f'{self_citation}: found no links at all'
        assert self_citation not in targets


# Real text of S.O. 3959(E), dated 17th September 2024 (published in the
# Gazette 18th September 2024), one of seven independent real amendments to
# the S.O. 371(E) Aadhaar-seeding notification found in the 2026-09-07
# depth pass — quoted verbatim (whitespace only) from the notification's
# own "Full Text" section.
AADHAAR_FURTHER_AMENDMENT_EXAMPLE = (
    "S.O. 3959(E).— In pursuance of the provisions of section 7 of the Aadhaar (Targeted Delivery of Financial "
    "and Other Subsidies, Benefits and Services) Act, 2016 (18 of 2016), the Central Government hereby makes the "
    "following further amendments in the notification of the Government of India in the Ministry of Consumer "
    "Affairs, Food and Public Distribution, Department of Food and Public Distribution, vide number S.O. 371(E), "
    "dated the 8th February, 2017, published in the Gazette of India, Extraordinary, Part II, section 3, "
    "sub-section (ii), namely : - In the said notification, - (a) in paragraph 1, in sub-paragraph (2), for the "
    "words, figures and letters “by 30th September, 2024”, the words, figures and letters “by 31st "
    "December, 2024” shall be substituted."
)


def test_further_amendment_variant_is_found():
    # Before the 2026-09-07 fix, the literal anchor 'makes the following
    # amendment' did not match 'makes the following FURTHER amendments'
    # (the inserted word breaks a literal substring match) and this real
    # notification's citation was silently missed.
    links = find_candidate_links(AADHAAR_FURTHER_AMENDMENT_EXAMPLE, self_citation='S.O. 3959(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 371(E)' in targets, f'expected S.O. 371(E) in {targets}'
    assert 'S.O. 3959(E)' not in targets


# Real trailing Note from G.S.R. 676(E), dated 18th September 2023 (Ministry
# of Consumer Affairs, Food and Public Distribution, Department of Food and
# Public Distribution) — recovers the Warehousing (Development and
# Regulation) Registration of Warehouses Rules, 2017's amendment history
# back to 2017 in one primary-text quote, comparable to Ministry of Coal's
# 18-item pension-scheme Note elsewhere in this project. Quoted verbatim
# (whitespace only) from the notification's own "Full Text" section.
#
# The principal citation is printed as "G.S.R - 165(E)" — a hyphen standing
# in for the "." previously required directly after "R" (same class of real
# drafting defect as the AYUSH comma-for-period typo already handled
# elsewhere). _GSR_RE was extended to tolerate this (see its own comment in
# extract/citation_patterns.py), so all seven real citations in this Note,
# including the hyphenated principal, are now recovered correctly.
WAREHOUSING_RULES_NOTE = (
    "Note: The principal rules were published in the Gazette of India, Extraordinary, Part II, Section 3, "
    "Subsection (i) vide number G.S.R - 165(E), dated the 23rd February, 2017 and subsequently amended vide "
    "G.S.R. 1040(E), dated the 22nd August, 2017, G.S.R. 251(E), dated the 20th March, 2018, G.S.R. 782(E), "
    "dated the 21st December, 2020, G.S.R. 786(E), dated the 3rd November, 2021, G.S.R. 287(E), dated the "
    "5th April, 2022 and G.S.R. 788(E), dated the 14th October, 2022."
)


def test_warehousing_rules_note_chain_recovers_all_seven_real_items():
    # The non-standard hyphenated principal ("G.S.R - 165(E)") is now
    # recovered too, since extract.citation_patterns._GSR_RE was extended
    # to tolerate a hyphen standing in for the period after "R" — see that
    # module's comment for the evidence. db/seed_consumer_affairs.sql's own
    # header still narrates the fix's history.
    assert find_note_chain(WAREHOUSING_RULES_NOTE) == [
        'G.S.R. 165(E)', 'G.S.R. 1040(E)', 'G.S.R. 251(E)', 'G.S.R. 782(E)',
        'G.S.R. 786(E)', 'G.S.R. 287(E)', 'G.S.R. 788(E)',
    ]


# Real trailing Note from G.S.R. 436(E), dated 1st July 2025 (Department of
# Consumer Affairs, Consumer Protection Act, 2019) — the fourth link in the
# National Consumer Disputes Redressal Commission (Group 'A' posts)
# Recruitment Rules, 2023 amendment chain; the body text names only the
# Rules' own title ("...hereby makes the following rules further to amend
# the National Consumer Disputes Redressal Commission (Group 'A' posts)
# Recruitment Rules, 2023...") with no "vide number" citation at all, so
# only the Note carries any citable numbers. Quoted verbatim (whitespace
# only) from the notification's own "Full Text" section.
NCDRC_RULES_NOTE = (
    "Note: The principal rules were published in the Gazette of India, Extraordinary, Part II, section 3, "
    "sub-section (i) vide number G.S.R. 120 (E), dated the 22nd February, 2023 and subsequently amended vide "
    "number G.S.R. 588 (E), dated the 24th September, 2024, G.S.R. 746 (E), dated the 3rd December, 2024 and "
    "G.S.R. 378 (E), dated the 10th June, 2025."
)


def test_ncdrc_recruitment_rules_note_chain():
    assert find_note_chain(NCDRC_RULES_NOTE) == [
        'G.S.R. 120(E)', 'G.S.R. 588(E)', 'G.S.R. 746(E)', 'G.S.R. 378(E)',
    ]
