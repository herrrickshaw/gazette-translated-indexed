"""
Direct unit tests for extract.common_templates and the shared citation
finder, using short synthetic sentences shaped like the real drafting
templates documented in the module header. The per-ministry test files
exercise these through real quoted text; these pin the shared contract
(ordering, windows, anchors, self-exclusion) independently of any ministry.
"""
from extract.citation_patterns import find_gazette_citations, find_citations, _expand_two_digit_year
from extract.common_templates import (
    find_after_anchor,
    find_amendment_in_notification_links,
    find_bare_citation_links,
    find_corrigendum_substitution_links,
    find_note_chain,
    find_supersession_links,
)
from extract.cross_ref import find_candidate_links


def _targets(links):
    return [l.target_citation for l in links]


# --- find_gazette_citations ------------------------------------------------

def test_gazette_citations_are_returned_in_document_order_across_series():
    text = 'S.O. 100(E) then G.S.R. 200(E) then S.R.O. 7(E) then S.O. 300(E)'
    got = [c.normalized for c in find_gazette_citations(text)]
    assert got == ['S.O. 100(E)', 'G.S.R. 200(E)', 'S.R.O. 7(E)', 'S.O. 300(E)']


def test_gazette_citation_spacing_variants_normalize():
    text = 'S. O. 3514(E), S.O 12 (E), G.S.R - 165(E), S.O, 2281(E), S.O. No. 1436 (E)'
    got = [c.normalized for c in find_gazette_citations(text)]
    assert got == ['S.O. 3514(E)', 'S.O. 12(E)', 'G.S.R. 165(E)', 'S.O. 2281(E)', 'S.O. 1436(E)']


def test_sro_is_not_also_reported_as_an_so():
    got = [c.normalized for c in find_gazette_citations('vide S.R.O. 12(E) dated')]
    assert got == ['S.R.O. 12(E)']


def test_no_citations_in_empty_text():
    assert find_gazette_citations('') == []
    assert find_note_chain('') == []
    assert find_bare_citation_links('') == []
    assert find_supersession_links('') == []


# --- CBIC numbering --------------------------------------------------------

def test_two_digit_year_pivot():
    assert _expand_two_digit_year('89') == 1989
    assert _expand_two_digit_year('69') == 1969
    assert _expand_two_digit_year('68') == 2068
    assert _expand_two_digit_year('05') == 2005


def test_cbic_three_numbering_forms():
    got = [(c.number, c.year, c.numbering_form)
           for c in find_citations('No. 45/2025-Customs, No. 207/89 - Customs and No. 3–Customs')]
    assert got == [('45/2025', 2025, '4-digit-year'), ('207/89', 1989, '2-digit-year'), ('3', None, 'bare')]


def test_cross_ref_window_stops_at_terminator():
    text = ('In supersession of the notification No. 1/2020-Customs, except as respects things '
            'done. Later text mentions No. 2/2021-Customs unrelated.')
    links = find_candidate_links(text)
    assert [(l.relation_type, l.citation.number) for l in links] == [('supersedes', '1/2020')]


def test_cross_ref_excludes_self_number():
    text = 'No. 9/2025-Customs. In supersession of No. 9/2025-Customs and No. 4/2019-Customs except as respects'
    assert [l.citation.number for l in find_candidate_links(text, self_number='9/2025')] == ['4/2019']


# --- ministry-anchored templates ------------------------------------------

AMEND = ('S.O. 900(E). The Central Government hereby makes the following amendments in the '
         'notification of the Government of India in the Ministry of Road Transport and '
         'Highways, number S.O. 50(E), dated the 1st January, 2020.')


def test_amendment_template_finds_target_and_excludes_self():
    assert _targets(find_amendment_in_notification_links(
        AMEND, 'road transport and highways', self_citation='S.O. 900(E)')) == ['S.O. 50(E)']


def test_amendment_template_requires_ministry_name():
    assert find_amendment_in_notification_links(AMEND, 'home affairs') == []


def test_amendment_template_survives_line_wrap_and_further():
    text = AMEND.replace('the following amendments', 'the following\nfurther amendments')
    assert _targets(find_amendment_in_notification_links(text, 'road transport and highways',
                                                         'S.O. 900(E)')) == ['S.O. 50(E)']


def test_corrigendum_template():
    text = ('In the notification of the Government of India in the Ministry of Environment, '
            'Forest and Climate Change vide number G.S.R. 77(E), dated ..., for "x" read "y".')
    assert _targets(find_corrigendum_substitution_links(
        text, 'environment, forest and climate change')) == ['G.S.R. 77(E)']


def test_after_anchor_window_limit():
    text = 'anchor ' + 'x' * 50 + ' S.O. 1(E)'
    assert _targets(find_after_anchor(text, 'anchor', None, window_chars=100)) == ['S.O. 1(E)']
    assert find_after_anchor(text, 'anchor', None, window_chars=20) == []


# --- supersession ----------------------------------------------------------

def test_supersession_collects_list_and_stops_at_terminator():
    text = ('G.S.R. 10(E). In supersession of the notification of the Ministry of Labour vide '
            'G.S.R. 1(E) and S.O. 2(E), except as respects things done. See also S.O. 3(E).')
    assert _targets(find_supersession_links(text, self_citation='G.S.R. 10(E)')) == [
        'G.S.R. 1(E)', 'S.O. 2(E)']


# --- bare citation ---------------------------------------------------------

def test_bare_citation_vide_word():
    assert _targets(find_bare_citation_links('published vide S.O. 12(E) dated')) == ['S.O. 12(E)']


def test_bare_citation_vide_does_not_match_inside_provided():
    # 'vide' is meant as the word "vide"; "provided"/"divide" are not lead-ins.
    assert find_bare_citation_links('Save as otherwise provided in S.O. 55(E), this applies.') == []
    assert find_bare_citation_links('to divide S.O. 55(E) into parts') == []


# --- note chain ------------------------------------------------------------

def test_note_chain_order_is_printed_order_across_series():
    text = ('Note: The principal rules were published vide number S.O. 100(E), dated 1st January, '
            '2020 and subsequently amended vide G.S.R. 200(E), dated 2nd February, 2021 and '
            'S.O. 300(E), dated 3rd March, 2022.')
    assert find_note_chain(text) == ['S.O. 100(E)', 'G.S.R. 200(E)', 'S.O. 300(E)']


def test_note_chain_dedupes_repeat_mentions():
    text = 'Note.- published vide G.S.R. 1(E) and amended vide G.S.R. 2(E), G.S.R. 1(E).'
    assert find_note_chain(text) == ['G.S.R. 1(E)', 'G.S.R. 2(E)']
