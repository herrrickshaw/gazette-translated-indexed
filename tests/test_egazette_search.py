"""
Tests for ingest.egazette_search's HTML parsing. Pure functions only — no
network, matching tests/test_egazette.py's convention. The fixtures below
are real markup excerpts captured live from egazette.gov.in while building
this module (Sep 2026, "Search by Publish Date" for 2026-09-01..2026-09-06
and "Search by Ministry" for Ministry of Steel / January 2026) — these
tests pin the parsing against real site output, not synthetic HTML.

The one exception is the per-month retry/failure tests below, which mock
search_by_ministry() itself (no real network either way) to exercise
search_by_ministry_since()'s retry-and-continue behavior -- confirmed
necessary live on 2026-09-07, when a multi-year scan hit both a transient
connection failure and a real server 500 partway through and, before this
fix, lost every already-fetched month along with it.
"""
from datetime import date
from unittest.mock import patch

from ingest.egazette_search import (
    MONTH_RETRIES,
    PAGE_SIZE,
    EGazetteSearchError,
    GazetteSearchResult,
    _egz_date,
    _extract_hidden,
    _iter_months,
    _rows_from_results_page,
    _strptime_egz,
    search_by_ministry_since,
)

# Two real rows from a live "Search by Publish Date" result page (2026-09-01..2026-09-06).
RESULTS_PAGE_FIXTURE = """
<table cellspacing="0" cellpadding="4" rules="all" id="gvGazetteList" width="100%">
<tr>
<td align="left">
    <span id="gvGazetteList_lbl_Ministry_0"><font color="Black">Bureau of Indian Standards</font></span>
</td><td align="left">
    <span id="gvGazetteList_lbl_Department_0"><font color="Black">Not Applicable</font></span>
</td><td align="left">
    <span id="gvGazetteList_lbl_Office_0"><font color="Black">Not Applicable</font></span>
</td><td align="left">
    <span id="gvGazetteList_lbl_Subject_0"><font color="Black">In pursuance of Sub rule 1 of Rule 15 of the Bureau of Indian Standards Rules, 2018, the Bureau of Indian Standards hereby notifies that Amendments to Indian standards,</font></span>
</td><td>
    <span id="gvGazetteList_lbl_Category_0"><font color="Black">Extra Ordinary</font></span>
</td><td>
    <span id="gvGazetteList_lbl_PartSection_0"><font color="Black">Part III-Section 4</font></span>
</td><td>
    <span id="gvGazetteList_lbl_IssueDate_0"><font color="Black">01-Sep-2026</font></span>
</td><td>
    <span id="gvGazetteList_lbl_PublishDate_0"><font color="Black">05-Sep-2026</font></span>
</td><td>
    <span id="gvGazetteList_lbl_UGID_0"><font color="Black">CG-DL-E-05092026-276018</font></span>
</td>
</tr>
<tr>
<td align="left">
    <span id="gvGazetteList_lbl_Ministry_1"><font color="Black">International Financial Services Centres Authority</font></span>
</td><td align="left">
    <span id="gvGazetteList_lbl_Department_1"><font color="Black">Not Applicable</font></span>
</td><td align="left">
    <span id="gvGazetteList_lbl_Office_1"><font color="Black">Not Applicable</font></span>
</td><td align="left">
    <span id="gvGazetteList_lbl_Subject_1"><font color="Black">In exercise of the powers conferred by sub sections 1 and 2 of section 11, read with section 28 of the International Financial Services Centres Authority Act,</font></span>
</td><td>
    <span id="gvGazetteList_lbl_Category_1"><font color="Black">Extra Ordinary</font></span>
</td><td>
    <span id="gvGazetteList_lbl_PartSection_1"><font color="Black">Part III-Section 4</font></span>
</td><td>
    <span id="gvGazetteList_lbl_IssueDate_1"><font color="Black">01-Sep-2026</font></span>
</td><td>
    <span id="gvGazetteList_lbl_PublishDate_1"><font color="Black">05-Sep-2026</font></span>
</td><td>
    <span id="gvGazetteList_lbl_UGID_1"><font color="Black">CG-GJ-E-05092026-276019</font></span>
</td>
</tr>
</table>
"""

# A real "no results" render: the grid renders with zero lbl_UGID_N spans at all.
EMPTY_RESULTS_FIXTURE = "<table id=\"gvGazetteList\"><tr><td>No Record Found</td></tr></table>"

# Real hidden-field markup from SearchMenu.aspx (values truncated — length is what these tests check).
HIDDEN_FIELDS_FIXTURE = """
<form method="post" action="./SearchMenu.aspx" id="Form1">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="42I/vt9o1JANcvUaigToVsIc06Mvg56iAMM8l1777hGE2o8JXpgw85AOxMHBF1KOfTiS+EE4nuaEGVNshwqWVy1CE9J0ScIzjn6o0kk3LCQ3MmAOkKb2N+LoBQQ7GWx135V16F99mzMFcPs536et99SZ2w9BMGfbNNRYRlueNzGJhTgxRpW+ZhrERoHOuTpRzm0+RnF37FleFPuPkZellQ==" />
<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="7EF44B2B" />
<input type="hidden" name="__VIEWSTATEENCRYPTED" id="__VIEWSTATEENCRYPTED" value="" />
<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="70kiQKHy0lzDR4ERcd4tjXpXkUq" />
<input name="hidden1" type="hidden" id="hidden1" style="width: 10px" value="8dc644aaf9787944f699b063e0151f69" />
<input type="submit" name="btneSearch" value="Search by TEXT" id="btneSearch" />
</form>
"""


def test_extracts_all_five_hidden_fields():
    fields = _extract_hidden(HIDDEN_FIELDS_FIXTURE)
    assert set(fields) == {'__VIEWSTATE', '__VIEWSTATEGENERATOR', '__VIEWSTATEENCRYPTED',
                            '__EVENTVALIDATION', 'hidden1'}
    assert fields['hidden1'] == '8dc644aaf9787944f699b063e0151f69'
    assert fields['__VIEWSTATEENCRYPTED'] == ''  # empty value must still be captured, not skipped


def test_does_not_pick_up_the_visible_submit_button():
    fields = _extract_hidden(HIDDEN_FIELDS_FIXTURE)
    assert 'btneSearch' not in fields


def test_parses_both_real_rows_from_a_results_page():
    rows = _rows_from_results_page(RESULTS_PAGE_FIXTURE)
    assert len(rows) == 2
    first, second = rows
    assert first.gazette_id == 'CG-DL-E-05092026-276018'
    assert first.ministry == 'Bureau of Indian Standards'
    assert first.category == 'Extra Ordinary'
    assert first.part_section == 'Part III-Section 4'
    assert first.issue_date == date(2026, 9, 1)
    assert first.publish_date == date(2026, 9, 5)
    assert second.gazette_id == 'CG-GJ-E-05092026-276019'
    assert second.ministry == 'International Financial Services Centres Authority'


def test_empty_results_page_parses_to_no_rows():
    assert _rows_from_results_page(EMPTY_RESULTS_FIXTURE) == []


def test_egz_date_format_matches_the_site():
    # confirmed live: txtDateFrom/txtDateTo and rendered dates both use this exact format
    assert _egz_date(date(2026, 9, 5)) == '05-Sep-2026'
    assert _egz_date(date(2026, 1, 1)) == '01-Jan-2026'


def test_strptime_egz_round_trips_egz_date():
    d = date(2026, 3, 31)
    assert _strptime_egz(_egz_date(d)) == d


def test_iter_months_is_inclusive_of_both_endpoints():
    months = list(_iter_months(date(2025, 11, 15), date(2026, 2, 3)))
    assert months == [(2025, 11), (2025, 12), (2026, 1), (2026, 2)]


def test_iter_months_single_month_yields_one_entry():
    assert list(_iter_months(date(2026, 1, 5), date(2026, 1, 28))) == [(2026, 1)]


def test_page_size_constant_matches_the_site_grid():
    # confirmed live: SearchPublishDate.aspx and SearchMinistry.aspx both page at exactly this size
    assert PAGE_SIZE == 15


def _fake_result(month: int, year: int) -> GazetteSearchResult:
    return GazetteSearchResult(
        gazette_id=f"CG-DL-E-01{month:02d}{year}-100000", ministry="Ministry of Steel",
        department=None, office=None, subject="s", category=None, part_section=None,
        issue_date=date(year, month, 1), publish_date=date(year, month, 1),
    )


def test_search_by_ministry_since_continues_past_a_month_that_fails_every_retry(monkeypatch):
    # Confirmed live 2026-09-07: a multi-year scan hit a real server 500 for
    # one month in the middle of the range. Before this fix, that single
    # month's exception propagated all the way up and discarded every
    # month already successfully fetched.
    calls = []

    def flaky(ministry_value, month, year, timeout=30.0):
        calls.append((year, month))
        if (year, month) == (2020, 6):
            raise EGazetteSearchError("searching ministry=34 6/2020: egazette.gov.in returned status 500")
        return [_fake_result(month, year)]

    monkeypatch.setattr("ingest.egazette_search.search_by_ministry", flaky)
    monkeypatch.setattr("ingest.egazette_search.time.sleep", lambda _: None)  # skip real backoff delays

    results, truncated, failed = search_by_ministry_since("34", date(2020, 5, 1), date(2020, 7, 31))

    assert failed == [(2020, 6)]
    assert truncated == []
    assert {r.gazette_id for r in results} == {
        "CG-DL-E-01052020-100000", "CG-DL-E-01072020-100000",
    }
    # the failing month was attempted MONTH_RETRIES times, not once
    assert calls.count((2020, 6)) == MONTH_RETRIES


def test_search_by_ministry_since_retries_and_recovers_a_transient_failure(monkeypatch):
    attempts = {"n": 0}

    def flaky_then_ok(ministry_value, month, year, timeout=30.0):
        if (year, month) == (2020, 6):
            attempts["n"] += 1
            if attempts["n"] < MONTH_RETRIES:  # fails every attempt except the last
                raise EGazetteSearchError("curl failed: connection reset")
        return [_fake_result(month, year)]

    monkeypatch.setattr("ingest.egazette_search.search_by_ministry", flaky_then_ok)
    monkeypatch.setattr("ingest.egazette_search.time.sleep", lambda _: None)

    results, truncated, failed = search_by_ministry_since("34", date(2020, 6, 1), date(2020, 6, 30))

    assert failed == []
    assert {r.gazette_id for r in results} == {"CG-DL-E-01062020-100000"}
    assert attempts["n"] == MONTH_RETRIES
