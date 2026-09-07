"""
Regression test for extract.defence_patterns against a real Ministry of
Defence corrigendum (see db/seed_defence.sql for provenance), quoted from
primary "Full Text" by a research agent.

Also covers the second depth pass (2026-09-07): a real "cites" shape (a
Cantonment Board "constitution" notification's opening recital, citing the
immediately preceding "variation" notification for the same cycle) that
the existing anchor-and-window extractor already recovers correctly with
no code changes, plus a bare-form Note-chain citation this ministry's
established precedent already documents as unrecoverable by the live
regex (no parenthetical letter).
"""
from extract.common_templates import find_note_chain
from extract.defence_patterns import find_candidate_links

CANTONMENT_BOARD_AMENDMENT = (
    "the Central Government hereby makes the following amendment in the notification of the "
    "Government of India in the Ministry of Defence vide number S.R.O. 19(E), dated the 12nd "
    "November, 2025, published in the Gazette of India (Extraordinary), Part II, Section 4, "
    "dated the 12nd November, 2025, namely:- (i) in serial number 3, in column (3), for clause "
    "(c), the following clause shall be substituted, namely:- \"(c) Shri Rishi Dutt Sharma\"."
)


def test_finds_the_real_amendment_link():
    links = find_candidate_links(CANTONMENT_BOARD_AMENDMENT, self_citation='S.R.O. 18(E)')
    targets = {l.target_citation for l in links}
    assert 'S.R.O. 19(E)' in targets


def test_self_citation_excluded():
    links = find_candidate_links(CANTONMENT_BOARD_AMENDMENT, self_citation='S.R.O. 18(E)')
    targets = {l.target_citation for l in links}
    assert links, 'found no links at all'
    assert 'S.R.O. 18(E)' not in targets


# Real text of S.R.O. 1(E), dated 3rd January 2025 (Gazette ID
# CG-DL-E-09012025-260084), found in the 2026-09-07 depth pass — quoted
# verbatim (whitespace only) from the notification's own "Full Text"
# section. This is a "cites" relationship (the constitution notification
# references the earlier variation notification for context; it does not
# amend it), not a substitution — but the shared corrigendum-substitution
# scan (anchor "ministry of defence", then any nearby gazette citation)
# recovers the real target citation correctly either way, since it never
# actually required "for ... read" wording, only the ministry-name anchor.
CANTONMENT_BOARD_CONSTITUTION_CITES_VARIATION = (
    "S.R.O. 1(E).—In pursuance of sub-section (3) of section 13 of the Cantonments Act, 2006 "
    "(41 of 2006) read with the notification of the Government of India in the Ministry of "
    "Defence number S.R.O 206(E), dated the 31st December, 2024, published in the Gazette of "
    "India (Extraordinary), Part II, Section 4, dated the 31th December, 2024 containing the "
    "declaration varying certain Cantonment Boards, the Central Government hereby notifies the "
    "constitution of the Cantonment Boards specified in column (2) of the Table given below "
    "consisting of members indicated in column (3) thereof, with effect from 11th day of "
    "February, 2025."
)


def test_finds_the_real_cites_link_to_the_variation_notification():
    links = find_candidate_links(CANTONMENT_BOARD_CONSTITUTION_CITES_VARIATION, self_citation='S.R.O. 1(E)')
    targets = {l.target_citation for l in links}
    assert 'S.R.O. 206(E)' in targets, f'expected S.R.O. 206(E) in {targets}'
    assert 'S.R.O. 1(E)' not in targets


# Real trailing Note from S.R.O. 7(E), dated 30th April 2025 (Gazette ID
# CG-DL-E-01052025-262811, Canteen Stores Department (Joint General
# Manager Grade-II) Recruitment (Amendment) Rules, 2025) — found in the
# 2026-09-07 depth pass. Quoted verbatim (whitespace only) from the
# notification's own "Full Text" section.
CSD_JGM2_RR_NOTE = (
    "Note. - The principal rules were published, vide notification number S.R.O. 58 dated the "
    "28th March, 1994 in the Gazette of India, Part II, Section 4."
)


def test_csd_jgm2_note_chain_bare_sro_not_recovered_by_live_regex():
    # Documents a known, already-established limitation for this ministry
    # (see db/seed_defence.sql): the live S.R.O. regex requires a
    # parenthetical letter ("(E)"), so a genuinely bare "S.R.O. 58" with no
    # such suffix is not recovered here even though it is real and is
    # modeled as a bare row in the seed on the strength of this same
    # primary-text quote. This test exists so a future regex change that
    # silently starts (or stops) matching bare S.R.O. citations is caught.
    assert find_note_chain(CSD_JGM2_RR_NOTE) == []
