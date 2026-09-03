"""
Regression test for extract.citation_patterns against the 31 real predecessor
notifications listed in Notification No. 45/2025-Customs's own preamble —
a genuine gold-standard set (transcribed from primary-source text during the
design conversation), not synthetic fixtures.
"""
from extract.citation_patterns import find_citations, find_gazette_ids
from extract.cross_ref import find_candidate_links

# (as-listed roman numeral, number, year_or_None, numbering_form, gsr) —
# exactly as printed in the notification's own preamble, items (i)-(xxxi).
GOLD_STANDARD = [
    ('i', '1/2025', 2025, '4-digit-year', 'G.S.R. 63(E)'),
    ('ii', '57/2022', 2022, '4-digit-year', 'G.S.R. 822(E)'),
    ('iii', '32/2019', 2019, '4-digit-year', 'G.S.R. 726(E)'),
    ('iv', '19/2019', 2019, '4-digit-year', 'G.S.R. 476(E)'),
    ('v', '86/2017', 2017, '4-digit-year', 'G.S.R. 1404(E)'),
    ('vi', '50/2017', 2017, '4-digit-year', 'G.S.R. 785(E)'),
    ('vii', '41/2017', 2017, '4-digit-year', 'G.S.R. 776(E)'),
    ('viii', '37/2017', 2017, '4-digit-year', 'G.S.R. 772(E)'),
    ('ix', '36/2017', 2017, '4-digit-year', 'G.S.R. 771(E)'),
    ('x', '32/2017', 2017, '4-digit-year', 'G.S.R. 767(E)'),
    ('xi', '30/2017', 2017, '4-digit-year', 'G.S.R. 765(E)'),
    ('xii', '29/2017', 2017, '4-digit-year', 'G.S.R. 764(E)'),
    ('xiii', '16/2017', 2017, '4-digit-year', 'G.S.R. 394(E)'),
    ('xiv', '5/2017', 2017, '4-digit-year', 'G.S.R. 89(E)'),
    ('xv', '130/2010', 2010, '4-digit-year', 'G.S.R. 1008(E)'),
    ('xvi', '81/2005', 2005, '4-digit-year', 'G.S.R. 569(E)'),
    ('xvii', '121/2003', 2003, '4-digit-year', 'G.S.R. 623(E)'),
    ('xviii', '25/1998', 1998, '4-digit-year', 'G.S.R. 290(E)'),
    ('xix', '51/1996', 1996, '4-digit-year', 'G.S.R. 303(E)'),
    ('xx', '50/1996', 1996, '4-digit-year', 'G.S.R. 302(E)'),
    ('xxi', '39/1996', 1996, '4-digit-year', 'G.S.R. 291(E)'),
    ('xxii', '154/1994', 1994, '4-digit-year', 'G.S.R. 583(E)'),
    ('xxiii', '152/1994', 1994, '4-digit-year', 'G.S.R. 581(E)'),
    ('xxiv', '148/1994', 1994, '4-digit-year', 'G.S.R. 577(E)'),
    ('xxv', '147/1994', 1994, '4-digit-year', 'G.S.R. 576(E)'),
    ('xxvi', '146/1994', 1994, '4-digit-year', 'G.S.R. 575(E)'),
    ('xxvii', '104/1994', 1994, '4-digit-year', 'G.S.R. 319(E)'),
    ('xxviii', '207/89', 1989, '2-digit-year', 'G.S.R. 702(E)'),
    # Bare-form citations carry no year in the number itself (only in the
    # surrounding "dated ..." prose, which this extractor doesn't parse) —
    # so `year` is None here, per the Citation dataclass contract, even
    # though the notifications themselves are dated 1993/1970/1957.
    ('xxix', '326', None, 'bare', 'G.S.R. 912(E)'),
    ('xxx', '80', None, 'bare', 'G.S.R. 1246(E)'),
    ('xxxi', '3', None, 'bare', 'G.S.R. 98(E)'),
]


def _preamble_line(number: str, gsr: str) -> str:
    return f'No.{number}-Customs, dated ..., vide number {gsr} dated ...;'


def test_extracts_all_31_predecessors_correctly():
    text = '\n'.join(_preamble_line(number, gsr) for _, number, _, _, gsr in GOLD_STANDARD)
    citations = find_citations(text)
    assert len(citations) == 31

    by_number = {c.number: c for c in citations}
    for _, number, year, form, _ in GOLD_STANDARD:
        c = by_number[number]
        assert c.year == year, f'{number}: expected year {year}, got {c.year}'
        assert c.numbering_form == form, f'{number}: expected {form}, got {c.numbering_form}'


def test_extracts_gsr_numbers():
    text = '\n'.join(_preamble_line(number, gsr) for _, number, _, _, gsr in GOLD_STANDARD)
    ids = find_gazette_ids(text)
    assert len(ids) == 31
    assert 'G.S.R. 98(E)' in ids
    assert 'G.S.R. 63(E)' in ids


def test_bare_number_not_confused_with_slash_year():
    # "No.3-Customs" must not be parsed as if '3' were a year fragment of
    # some other citation, and a real slash/4-digit-year citation nearby
    # must not swallow the bare one.
    text = 'No.45/2025-Customs and, separately, No.3-Customs, dated 1957.'
    citations = find_citations(text)
    numbers = {c.number for c in citations}
    assert numbers == {'45/2025', '3'}


def test_supersession_preamble_proposes_supersedes_links():
    text = (
        'in supersession of the following notifications ... namely: '
        + '\n'.join(_preamble_line(number, gsr) for _, number, _, _, gsr in GOLD_STANDARD[:5])
    )
    links = find_candidate_links(text, self_number='45/2025')
    assert len(links) == 5
    assert all(link.relation_type == 'supersedes' for link in links)


def test_self_citation_excluded_from_candidate_links():
    text = 'Notification No. 45/2025-Customs, in supersession of No. 1/2025-Customs, dated ...'
    links = find_candidate_links(text, self_number='45/2025')
    numbers = {link.citation.number for link in links}
    assert '45/2025' not in numbers
    assert '1/2025' in numbers
