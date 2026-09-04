"""
Tests for ingest.egazette's gazette-ID -> official-PDF-URL mapping. Pure
functions only — no network. The URL pattern itself was verified live once
(HTTP 200, application/pdf) and against an Internet Archive mirror that
uses the same trailing file-id; these tests pin the parsing, not the site.
"""
import pytest

from ingest.egazette import gazette_id_to_pdf_url, parse_gazette_id


def test_maps_the_live_verified_id():
    # Downloaded successfully during development: MoRTH corrigendum S.O. 4848(E)
    assert gazette_id_to_pdf_url('CG-DL-E-03092026-275956') == \
        'https://egazette.gov.in/WriteReadData/2026/275956.pdf'


def test_maps_the_archive_corroborated_id():
    # archive.org item in.gazette.central.e.2024-09-27.257550 uses file-id 257550
    assert gazette_id_to_pdf_url('CG-DL-E-27092024-257550') == \
        'https://egazette.gov.in/WriteReadData/2024/257550.pdf'


def test_weekly_series_parses_too():
    parts = parse_gazette_id('CG-DL-W-02092026-275935')
    assert parts['series'] == 'W'
    assert parts['yyyy'] == '2026'
    assert parts['fileid'] == '275935'


def test_state_gazette_prefix_parses():
    parts = parse_gazette_id('SG-DL-E-04092026-275980')
    assert parts['gov'] == 'SG'


def test_year_comes_from_the_id_date_segment_not_today():
    # 2019 ID must resolve under /2019/, whatever year the fetch runs in
    assert '/2019/' in gazette_id_to_pdf_url('CG-DL-E-30092019-000001')


@pytest.mark.parametrize('bad', ['', 'CG-DL-E-275956', 'CG-DL-X-03092026-275956',
                                 'cg-dl-e-03092026-275956', 'CG-DL-E-3092026-275956'])
def test_rejects_malformed_ids(bad):
    with pytest.raises(ValueError):
        parse_gazette_id(bad)
