"""Offline tests for the parts of ingest.egazette_search that drive the site:
the curl-backed _Session, error-page detection, the three-step search flows,
month-range boundaries/sleep schedule and the CLI. subprocess.run, time.sleep
and the Session's get/post are faked; no network is touched."""
import sys
import tempfile
from datetime import date
from pathlib import Path
from types import SimpleNamespace

import pytest

from ingest import egazette_search as es
from ingest.egazette_search import EGazetteSearchError

# ------------------------------------------------------------------ helpers

def _row(idx, ugid="CG-DL-E-05092026-1", publish="05-Sep-2026", issue="01-Sep-2026", **over):
    vals = {"Ministry": "Ministry of Steel", "Department": "Not Applicable", "Office": "O",
            "Subject": "subj", "Category": "Extra Ordinary", "PartSection": "Part II",
            "IssueDate": issue, "PublishDate": publish, "UGID": ugid}
    vals.update(over)
    return "".join(f'<span id="gv_lbl_{k}_{idx}"><font color="Black">{v}</font></span>'
                   for k, v in vals.items() if v is not None)


class Script:
    """Replaces _Session.get/post with a scripted queue and records calls."""

    def __init__(self, monkeypatch, responses):
        self.responses = list(responses)
        self.calls = []
        monkeypatch.setattr(es._Session, "get",
                            lambda s, url, referer=None: self._pop(("GET", url, None, referer)))
        monkeypatch.setattr(es._Session, "post",
                            lambda s, url, data, referer=None: self._pop(("POST", url, data, referer)))

    def _pop(self, call):
        self.calls.append(call)
        return self.responses.pop(0)


HOME = (200, "https://egazette.gov.in/(S(abc))/default.aspx", "<html><title>Home</title></html>")
MENU = (200, "https://egazette.gov.in/(S(abc))/SearchMenu.aspx",
        '<input type="hidden" name="__VIEWSTATE" value="vs1" /><input type="hidden" name="__EVENTVALIDATION" value="ev1" />')


@pytest.fixture(autouse=True)
def tmp_jar_dir(tmp_path, monkeypatch):
    monkeypatch.setattr(tempfile, "tempdir", str(tmp_path))


@pytest.fixture
def sleeps(monkeypatch):
    s = []
    monkeypatch.setattr(es.time, "sleep", lambda x: s.append(x))
    return s


# ------------------------------------------------------------------ _Session

def test_session_creates_and_removes_cookie_jar(tmp_path):
    with es._Session() as s:
        jar = Path(s._jar)
        assert jar.exists() and jar.parent == tmp_path and jar.name.startswith("egazette_jar_")
    assert not jar.exists()


def test_session_close_is_idempotent():
    s = es._Session()
    s.close()
    s.close()  # missing_ok


def test_session_removes_jar_even_when_body_raises():
    jar = None
    with pytest.raises(KeyError):
        with es._Session() as s:
            jar = Path(s._jar)
            raise KeyError("x")
    assert not jar.exists()


def _proc(rc=0, out="", err=""):
    return SimpleNamespace(returncode=rc, stdout=out, stderr=err)


def test_curl_get_builds_command_and_parses_marker(monkeypatch):
    seen = {}

    def fake_run(cmd, **kw):
        seen.update(cmd=cmd, kw=kw)
        return _proc(out="<html>b</html>\n__STATUS__200__URL__https://final/x")

    monkeypatch.setattr(es.subprocess, "run", fake_run)
    with es._Session(timeout=12.9) as s:
        status, url, body = s.get("https://a/b", referer="https://ref/")
        jar = s._jar
    cmd = seen["cmd"]
    assert (status, url, body) == (200, "https://final/x", "<html>b</html>\n")
    assert cmd == ["curl", "-sS", "-L", "-c", jar, "-b", jar, "-A", es._USER_AGENT, "--max-time", "12",
                   "-w", "\n__STATUS__%{http_code}__URL__%{url_effective}", "-e", "https://ref/", "https://a/b"]
    assert seen["kw"]["timeout"] == 17.9  # curl timeout + 5s grace
    assert seen["kw"]["capture_output"] is True and seen["kw"]["text"] is True


def test_curl_without_referer_omits_dash_e(monkeypatch):
    cmds = []
    monkeypatch.setattr(es.subprocess, "run",
                        lambda cmd, **kw: cmds.append(cmd) or _proc(out="\n__STATUS__200__URL__u"))
    with es._Session() as s:
        s.get("https://a")
    assert "-e" not in cmds[0] and cmds[0][-1] == "https://a"


def test_curl_post_encodes_each_field_in_order_before_the_url(monkeypatch):
    cmds = []
    monkeypatch.setattr(es.subprocess, "run",
                        lambda cmd, **kw: cmds.append(cmd) or _proc(out="x\n__STATUS__302__URL__u2"))
    with es._Session() as s:
        status, url, body = s.post("https://a/p", [("k1", "v=1"), ("k2", "")], referer="r")
    cmd = cmds[0]
    assert status == 302
    tail = cmd[cmd.index("-e"):]
    assert tail == ["-e", "r", "--data-urlencode", "k1=v=1", "--data-urlencode", "k2=", "https://a/p"]


def test_curl_nonzero_exit_raises_with_stderr(monkeypatch):
    monkeypatch.setattr(es.subprocess, "run", lambda cmd, **kw: _proc(rc=28, err=" timed out \n"))
    with es._Session() as s, pytest.raises(EGazetteSearchError, match=r"curl failed for https://a: timed out$"):
        s.get("https://a")


def test_curl_missing_marker_raises(monkeypatch):
    monkeypatch.setattr(es.subprocess, "run", lambda cmd, **kw: _proc(out="<html>no marker</html>"))
    with es._Session() as s, pytest.raises(EGazetteSearchError, match="no status marker"):
        s.get("https://a")


def test_curl_marker_must_be_at_end_of_output(monkeypatch):
    monkeypatch.setattr(es.subprocess, "run",
                        lambda cmd, **kw: _proc(out="\n__STATUS__200__URL__u\ntrailing junk with spaces"))
    with es._Session() as s, pytest.raises(EGazetteSearchError):
        s.get("https://a")


def test_curl_body_may_itself_contain_marker_like_text(monkeypatch):
    out = "mentions __STATUS__999__URL__zzz in page\n__STATUS__200__URL__https://real"
    monkeypatch.setattr(es.subprocess, "run", lambda cmd, **kw: _proc(out=out))
    with es._Session() as s:
        status, url, body = s.get("https://a")
    assert status == 200 and url == "https://real"


# ---------------------------------------------------- _check_not_error_page

@pytest.mark.parametrize("status", [200, 301, 399])
def test_check_error_page_accepts_below_400(status):
    es._check_not_error_page(status, "<html></html>", "ctx")


@pytest.mark.parametrize("status", [400, 404, 500])
def test_check_error_page_rejects_400_and_above(status):
    with pytest.raises(EGazetteSearchError, match=f"ctx: egazette.gov.in returned status {status}"):
        es._check_not_error_page(status, "<html></html>", "ctx")


def test_check_error_page_rejects_error_title_case_insensitively_and_quotes_it():
    with pytest.raises(EGazetteSearchError, match=r"status 200 \('Runtime ERROR page'\)"):
        es._check_not_error_page(200, "<title>  Runtime ERROR page </title>", "ctx")


def test_check_error_page_title_without_error_is_fine():
    es._check_not_error_page(200, "<title>Search Results</title>", "ctx")


def test_check_error_page_status_error_without_title_has_no_title_suffix():
    with pytest.raises(EGazetteSearchError) as ei:
        es._check_not_error_page(500, "no title", "ctx")
    assert str(ei.value) == "ctx: egazette.gov.in returned status 500"


# ---------------------------------------------------------- hidden fields / rows

def test_extract_hidden_handles_both_attribute_orders_and_empty_values():
    html = ('<input type="hidden" name="A" value="1" />'
            "<input name='B' type='hidden' value='2' />"
            '<input type="hidden" name="C" value="" />'
            '<input type="text" name="D" value="no" />')
    assert es._extract_hidden(html) == {"A": "1", "B": "2", "C": ""}


def test_rows_skip_entries_without_ugid_and_sort_numerically():
    html = (_row(10, ugid="G10") + _row(2, ugid="G2") + _row(1, ugid=None))
    assert [r.gazette_id for r in es._rows_from_results_page(html)] == ["G2", "G10"]


def test_rows_optional_fields_become_none_and_values_are_stripped():
    html = _row(0, Ministry="  Spaced  ", Department="", Office="", Category="", PartSection="",
                IssueDate="", PublishDate="")
    r = es._rows_from_results_page(html)[0]
    assert r.ministry == "Spaced"
    assert (r.department, r.office, r.category, r.part_section) == (None, None, None, None)
    assert r.issue_date is None and r.publish_date is None


def test_rows_parse_dates_and_defaults_for_missing_text_fields():
    html = _row(0, Ministry=None, Subject=None)
    r = es._rows_from_results_page(html)[0]
    assert r.ministry == "" and r.subject == ""
    assert r.issue_date == date(2026, 9, 1) and r.publish_date == date(2026, 9, 5)


def test_strptime_egz_strips_whitespace_and_rejects_other_formats():
    assert es._strptime_egz(" 05-Sep-2026 ") == date(2026, 9, 5)
    with pytest.raises(ValueError):
        es._strptime_egz("2026-09-05")


def test_iter_months_crosses_year_boundary_and_empty_when_reversed():
    assert list(es._iter_months(date(2025, 11, 15), date(2026, 2, 1))) == [(2025, 11), (2025, 12), (2026, 1), (2026, 2)]
    assert list(es._iter_months(date(2026, 3, 1), date(2026, 2, 28))) == []


# ---------------------------------------------------------------- flows

def test_open_search_menu_chains_home_then_menu_with_referer(monkeypatch):
    sc = Script(monkeypatch, [HOME, MENU])
    with es._Session() as s:
        url, fields = es._open_search_menu(s)
    assert url == MENU[1]
    assert fields == {"__VIEWSTATE": "vs1", "__EVENTVALIDATION": "ev1"}
    assert sc.calls[0] == ("GET", "https://egazette.gov.in/", None, None)
    # SearchMenu.aspx is resolved relative to the (session-bearing) home URL, referer = that URL
    assert sc.calls[1] == ("GET", "https://egazette.gov.in/(S(abc))/SearchMenu.aspx", None, HOME[1])


def test_open_search_menu_error_on_home_or_menu(monkeypatch):
    Script(monkeypatch, [(500, "u", "x")])
    with es._Session() as s, pytest.raises(EGazetteSearchError, match="fetching home page"):
        es._open_search_menu(s)
    Script(monkeypatch, [HOME, (404, "u", "x")])
    with es._Session() as s, pytest.raises(EGazetteSearchError, match="fetching SearchMenu.aspx"):
        es._open_search_menu(s)


MINISTRY_PAGE = (200, "https://egazette.gov.in/(S(abc))/SearchMinistry.aspx",
                 '<input type="hidden" name="__VIEWSTATE" value="vs2" />'
                 '<select name="ddlMinistry" id="x"><option value="">x</option>'
                 '<option value="0">Select Ministry</option>'
                 '<option value="34">Ministry of Steel</option>'
                 '<option value="35"> Ministry of Mines </option></select>')


def test_list_ministries_parses_dropdown_and_posts_menu_button(monkeypatch):
    sc = Script(monkeypatch, [HOME, MENU, MINISTRY_PAGE])
    out = es.list_ministries(timeout=9)
    assert out == {"Ministry of Steel": "34", "Ministry of Mines": "35"}
    kind, url, data, referer = sc.calls[2]
    assert kind == "POST" and url == MENU[1] and referer == MENU[1]
    assert data == [("__VIEWSTATE", "vs1"), ("__EVENTVALIDATION", "ev1"), ("btnMinistry", "Search by Ministry")]


def test_list_ministries_drops_placeholder_and_blank_entries(monkeypatch):
    Script(monkeypatch, [HOME, MENU, MINISTRY_PAGE])
    out = es.list_ministries()
    assert "Select Ministry" not in out and "x" not in out  # placeholder text and empty-value option dropped
    assert out == {"Ministry of Steel": "34", "Ministry of Mines": "35"}


def test_list_ministries_missing_dropdown_raises(monkeypatch):
    Script(monkeypatch, [HOME, MENU, (200, "u", "<html>no select</html>")])
    with pytest.raises(EGazetteSearchError, match="ddlMinistry dropdown not found"):
        es.list_ministries()


def test_list_ministries_error_page_raises(monkeypatch):
    Script(monkeypatch, [HOME, MENU, (500, "u", "x")])
    with pytest.raises(EGazetteSearchError, match="opening Search by Ministry"):
        es.list_ministries()


def test_list_ministries_passes_timeout_to_session(monkeypatch):
    seen = []
    orig = es._Session.__init__
    monkeypatch.setattr(es._Session, "__init__", lambda self, timeout=30.0: (seen.append(timeout), orig(self, timeout))[1])
    Script(monkeypatch, [HOME, MENU, MINISTRY_PAGE])
    es.list_ministries(timeout=3.5)
    assert seen == [3.5]


def test_search_by_ministry_posts_expected_form_and_returns_rows(monkeypatch):
    page2 = (200, "https://egazette.gov.in/(S(abc))/SearchMinistry.aspx",
             '<input type="hidden" name="__VIEWSTATE" value="vs2" />')
    results = (200, "https://egazette.gov.in/(S(abc))/Results.aspx", _row(0, ugid="G1") + _row(1, ugid="G2"))
    sc = Script(monkeypatch, [HOME, MENU, page2, results])
    rows = es.search_by_ministry("34", 3, 2026)
    assert [r.gazette_id for r in rows] == ["G1", "G2"]
    k1, u1, d1, r1 = sc.calls[2]
    assert (k1, u1, r1) == ("POST", MENU[1], MENU[1])
    assert d1 == [("__VIEWSTATE", "vs1"), ("__EVENTVALIDATION", "ev1"), ("btnMinistry", "Search by Ministry")]
    k2, u2, d2, r2 = sc.calls[3]
    assert (k2, u2, r2) == ("POST", page2[1], page2[1])  # posts back to the URL the previous POST landed on
    assert d2 == [("__VIEWSTATE", "vs2"), ("ddlMinistry", "34"), ("rdb_Option", "0"), ("ddlmonth", "3"),
                  ("ddlyear", "2026"), ("ImgSubmitDetails.x", "10"), ("ImgSubmitDetails.y", "10")]


def test_search_by_ministry_error_on_results_names_ministry_and_month(monkeypatch):
    page2 = (200, "https://e/s", "")
    Script(monkeypatch, [HOME, MENU, page2, (500, "u", "x")])
    with pytest.raises(EGazetteSearchError, match="searching ministry=34 3/2026"):
        es.search_by_ministry("34", 3, 2026)


def test_search_by_ministry_error_when_opening_search_page(monkeypatch):
    Script(monkeypatch, [HOME, MENU, (500, "u", "x")])
    with pytest.raises(EGazetteSearchError, match="opening Search by Ministry"):
        es.search_by_ministry("34", 3, 2026)


def test_search_by_publish_date_posts_formatted_range(monkeypatch):
    page2 = (200, "https://e/p", '<input type="hidden" name="__VIEWSTATE" value="vsP" />')
    results = (200, "https://e/r", _row(0, ugid="P1"))
    sc = Script(monkeypatch, [HOME, MENU, page2, results])
    rows = es.search_by_publish_date(date(2026, 9, 1), date(2026, 9, 6))
    assert [r.gazette_id for r in rows] == ["P1"]
    assert sc.calls[2][2][-1] == ("btnPublish", "Search by Publish Date")
    assert sc.calls[3][2] == [("__VIEWSTATE", "vsP"), ("txtDateFrom", "01-Sep-2026"), ("txtDateTo", "06-Sep-2026"),
                              ("ImgSubmit.x", "10"), ("ImgSubmit.y", "10")]


def test_search_by_publish_date_error_pages(monkeypatch):
    Script(monkeypatch, [HOME, MENU, (500, "u", "x")])
    with pytest.raises(EGazetteSearchError, match="opening Search by Publish Date"):
        es.search_by_publish_date(date(2026, 9, 1), date(2026, 9, 1))
    Script(monkeypatch, [HOME, MENU, (200, "u", ""), (500, "u", "x")])
    with pytest.raises(EGazetteSearchError, match=r"searching publish date 2026-09-01\.\.2026-09-02"):
        es.search_by_publish_date(date(2026, 9, 1), date(2026, 9, 2))


# -------------------------------------------------- search_by_ministry_since

def _res(gid, d):
    return es.GazetteSearchResult(gid, "m", None, None, "s", None, None, d, d)


def test_since_filters_inclusive_bounds_and_sorts(monkeypatch, sleeps):
    since, until = date(2026, 2, 10), date(2026, 3, 20)
    monthly = {
        (2026, 2): [_res("below", date(2026, 2, 9)), _res("lo", since), _res("mid", date(2026, 2, 20))],
        (2026, 3): [_res("hi", until), _res("above", date(2026, 3, 21)),
                    es.GazetteSearchResult("nodate", "m", None, None, "s", None, None, None, None)],
    }
    monkeypatch.setattr(es, "search_by_ministry", lambda v, m, y, timeout: monthly[(y, m)])
    results, truncated, failed = es.search_by_ministry_since("1", since, until)
    assert [r.gazette_id for r in results] == ["lo", "mid", "hi"]
    assert truncated == [] and failed == []


def test_since_truncation_is_exactly_page_size(monkeypatch, sleeps):
    def fake(v, m, y, timeout):
        n = {1: es.PAGE_SIZE - 1, 2: es.PAGE_SIZE, 3: es.PAGE_SIZE + 1}[m]
        return [_res(f"g{m}-{i}", date(2026, m, 15)) for i in range(n)]

    monkeypatch.setattr(es, "search_by_ministry", fake)
    results, truncated, failed = es.search_by_ministry_since("1", date(2026, 1, 1), date(2026, 3, 31))
    assert truncated == [(2026, 2)]
    assert len(results) == 14 + 15 + 16


def test_since_sleep_schedule_between_months_and_backoff(monkeypatch, sleeps):
    calls = []

    def fake(v, m, y, timeout):
        calls.append((m, timeout))
        if m == 2 and calls.count((2, timeout)) <= 2:
            raise EGazetteSearchError("500")
        return []

    monkeypatch.setattr(es, "search_by_ministry", fake)
    es.search_by_ministry_since("1", date(2026, 1, 1), date(2026, 3, 31), delay_s=0.7, timeout=11)
    # month1 ok -> delay; month2 fails twice (backoff 2s, 4s) then ok -> delay; month3 ok -> no trailing delay
    assert sleeps == [0.7, 2, 4, 0.7]
    assert all(t == 11 for _, t in calls)


def test_since_exhausted_retries_do_not_sleep_after_last_attempt(monkeypatch, sleeps):
    n = []
    monkeypatch.setattr(es, "search_by_ministry", lambda v, m, y, timeout: n.append(1) or (_ for _ in ()).throw(EGazetteSearchError("x")))
    results, truncated, failed = es.search_by_ministry_since("1", date(2026, 1, 1), date(2026, 1, 31))
    assert (results, truncated, failed) == ([], [], [(2026, 1)])
    assert len(n) == es.MONTH_RETRIES
    assert sleeps == [2, 4]  # MONTH_RETRIES-1 backoffs, none after the final attempt, no inter-month delay


def test_since_non_egazette_errors_are_not_swallowed(monkeypatch, sleeps):
    monkeypatch.setattr(es, "search_by_ministry", lambda *a, **k: (_ for _ in ()).throw(ValueError("bug")))
    with pytest.raises(ValueError):
        es.search_by_ministry_since("1", date(2026, 1, 1), date(2026, 1, 31))


def test_since_dedupes_by_gazette_id_last_wins(monkeypatch, sleeps):
    monkeypatch.setattr(es, "search_by_ministry",
                        lambda v, m, y, timeout: [es.GazetteSearchResult("dup", "m", None, None, f"m{m}", None, None,
                                                                         date(2026, m, 15), date(2026, m, 15))])
    results, _, _ = es.search_by_ministry_since("1", date(2026, 1, 1), date(2026, 2, 28))
    assert len(results) == 1 and results[0].subject == "m2"


def test_since_until_defaults_to_today(monkeypatch, sleeps):
    months = []
    monkeypatch.setattr(es, "search_by_ministry", lambda v, m, y, timeout: months.append((y, m)) or [])
    today = date.today()
    es.search_by_ministry_since("1", today.replace(day=1))
    assert months == [(today.year, today.month)]


# ------------------------------------------------------------------- main

def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["egazette_search", *argv])
    return es.main()


def test_main_list_ministries_sorted_tab_separated(monkeypatch, capsys):
    monkeypatch.setattr(es, "list_ministries", lambda: {"B Ministry": "2", "A Ministry": "1"})
    assert _main(monkeypatch, ["--list-ministries"]) == 0
    assert capsys.readouterr().out == "A Ministry\t1\nB Ministry\t2\n"


def test_main_ministry_requires_since(monkeypatch, capsys):
    assert _main(monkeypatch, ["--ministry-value", "34"]) == 2
    assert "--since is required" in capsys.readouterr().err


def test_main_ministry_since_prints_rows_and_warnings(monkeypatch, capsys):
    r = es.GazetteSearchResult("G1", "Steel Min", None, None, "x" * 100, None, None, None, date(2026, 5, 1))
    seen = []

    def fake(value, since, until):
        seen.append((value, since, until))
        return [r], [(2026, 5)], [(2026, 4)]

    monkeypatch.setattr(es, "search_by_ministry_since", fake)
    assert _main(monkeypatch, ["--ministry-value", "34", "--since", "2026-01-01", "--until", "2026-06-30"]) == 0
    out, err = capsys.readouterr()
    assert seen == [("34", date(2026, 1, 1), date(2026, 6, 30))]
    assert out == f"G1\t2026-05-01\tSteel Min\t{'x' * 80}\n"  # subject cut to 80 chars
    assert "possibly-truncated months (hit the 15-row page limit): [(2026, 5)]" in err
    assert "months that failed after 3 attempts each (not covered at all): [(2026, 4)]" in err


def test_main_ministry_since_default_until_none_and_no_warnings(monkeypatch, capsys):
    seen = []
    monkeypatch.setattr(es, "search_by_ministry_since", lambda v, s, u: seen.append(u) or ([], [], []))
    assert _main(monkeypatch, ["--ministry-value", "34", "--since", "2026-01-01"]) == 0
    assert seen == [None]
    assert capsys.readouterr() == ("", "")


def test_main_publish_date_mode_and_truncation_warning(monkeypatch, capsys):
    rows = [_res(f"G{i}", date(2026, 9, 5)) for i in range(es.PAGE_SIZE)]
    seen = []
    monkeypatch.setattr(es, "search_by_publish_date", lambda a, b: seen.append((a, b)) or rows)
    assert _main(monkeypatch, ["--from", "2026-09-01", "--to", "2026-09-06"]) == 0
    out, err = capsys.readouterr()
    assert seen == [(date(2026, 9, 1), date(2026, 9, 6))]
    assert out.count("\n") == 15
    assert "exactly 15 rows returned" in err


def test_main_publish_date_below_page_size_has_no_warning(monkeypatch, capsys):
    monkeypatch.setattr(es, "search_by_publish_date", lambda a, b: [_res("G", date(2026, 9, 5))] * (es.PAGE_SIZE - 1))
    _main(monkeypatch, ["--from", "2026-09-01", "--to", "2026-09-06"])
    assert capsys.readouterr().err == ""


def test_main_nothing_to_do_returns_2(monkeypatch, capsys):
    assert _main(monkeypatch, []) == 2
    assert "Nothing to do" in capsys.readouterr().err
    assert _main(monkeypatch, ["--from", "2026-09-01"]) == 2  # --to missing
