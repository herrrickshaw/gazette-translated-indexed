"""Tests for ingest.freshness_check with all network faked (subprocess.run and
the egazette search client are replaced; nothing leaves the process)."""
import sqlite3
import sys
from datetime import date
from pathlib import Path
from types import SimpleNamespace

import pytest

from ingest import freshness_check as fc
from ingest.egazette_search import EGazetteSearchError, GazetteSearchResult

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


def _card(raw_date, gid, title):
    return (f'<div class="feed-card" data-date="{raw_date}"><span>x</span>'
            f'<a href="https://gazettetracker.com/g/{gid}" class="feed-subject">{title}</a></div>')


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('steel', 'Ministry of Steel')")
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('power', 'Ministry of Power')")
    c.execute(
        "INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, ministry_id) "
        "VALUES ('s1', 'Steel', 'S.O. 1(E)', 2026, 'so-only', '2026-03-10', 'steel')")
    c.execute(
        "INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, ministry_id, archived_at) "
        "VALUES ('s2', 'Steel', 'S.O. 2(E)', 2026, 'so-only', '2026-09-30', 'steel', '2026-10-01T00:00:00+00:00')")
    yield c
    c.close()


def item(gid, d, title="t", url=None):
    return fc.TrackerItem(gazette_id=gid, url=url or f"https://gazettetracker.com/g/{gid}", title=title, date=d)


# ---------------------------------------------------------------- fetch_listing

def test_fetch_listing_parses_cards_and_builds_url(monkeypatch):
    calls = []
    html = _card("05 Sep 2026", "CG-DL-E-05092026-1", " Title A ") + _card("1 Jan 2026", "CG-DL-E-01012026-2", "Title B")

    def fake_run(cmd, **kw):
        calls.append((cmd, kw))
        return SimpleNamespace(stdout=html, returncode=0)

    monkeypatch.setattr(fc.subprocess, "run", fake_run)
    items = fc.fetch_listing("my-slug", page=3, timeout=7)
    assert [(i.gazette_id, i.title, i.date) for i in items] == [
        ("CG-DL-E-05092026-1", "Title A", date(2026, 9, 5)),
        ("CG-DL-E-01012026-2", "Title B", date(2026, 1, 1)),
    ]
    assert items[0].url == "https://gazettetracker.com/g/CG-DL-E-05092026-1"
    cmd, kw = calls[0]
    assert cmd == ["curl", "-s", "--max-time", "7", "https://gazettetracker.com/ministry/my-slug?page=3"]
    assert kw["capture_output"] is True and kw["text"] is True


def test_fetch_listing_defaults_page_one_timeout_twenty(monkeypatch):
    seen = []
    monkeypatch.setattr(fc.subprocess, "run", lambda cmd, **kw: seen.append(cmd) or SimpleNamespace(stdout=""))
    assert fc.fetch_listing("s") == []
    assert seen[0][3] == "20" and seen[0][-1].endswith("?page=1")


def test_fetch_listing_skips_unparseable_dates_but_keeps_others(monkeypatch):
    html = _card("not a date", "A-1", "bad") + _card("02 Feb 2026", "B-2", "good")
    monkeypatch.setattr(fc.subprocess, "run", lambda cmd, **kw: SimpleNamespace(stdout=html))
    items = fc.fetch_listing("s")
    assert [i.gazette_id for i in items] == ["B-2"]


def test_fetch_listing_old_markup_matches_nothing(monkeypatch):
    html = '<li class="browse-item" data-date="05 Sep 2026"><a href="https://gazettetracker.com/g/X-1">t</a></li>'
    monkeypatch.setattr(fc.subprocess, "run", lambda cmd, **kw: SimpleNamespace(stdout=html))
    assert fc.fetch_listing("s") == []


def test_parse_tracker_date_strips_whitespace():
    assert fc._parse_tracker_date("  05 Sep 2026 \n") == date(2026, 9, 5)
    with pytest.raises(ValueError):
        fc._parse_tracker_date("2026-09-05")


# --------------------------------------------------------------- fetch_official

def _res(gid, d, subject="subj"):
    return GazetteSearchResult(gazette_id=gid, ministry="m", department=None, office=None, subject=subject,
                               category=None, part_section=None, issue_date=d, publish_date=d)


def test_fetch_official_unmapped_ministry_raises():
    with pytest.raises(EGazetteSearchError, match="no egazette.gov.in ddlMinistry value mapped for 'nonesuch'"):
        fc.fetch_official("nonesuch", date(2026, 1, 1))


def test_fetch_official_merges_values_dedupes_and_sorts(monkeypatch):
    monkeypatch.setitem(fc.EGAZETTE_MINISTRY_VALUES, "zz", ["10", "20"])
    until = date(2026, 12, 1)
    payload = {
        "10": ([_res("CG-DL-E-05092026-300", date(2026, 9, 5), "late"), _res("CG-DL-E-01092026-100", date(2026, 9, 1))],
               [(2026, 9)], [(2026, 7)]),
        "20": ([_res("CG-DL-E-05092026-300", date(2026, 9, 5), "dupe-wins"), _res("CG-DL-E-02092026-200", date(2026, 9, 2))],
               [(2026, 9), (2026, 8)], []),
    }
    seen = []

    def fake_search(value, since, until_):
        seen.append((value, since, until_))
        return payload[value]

    monkeypatch.setattr(fc, "search_by_ministry_since", fake_search)
    items, truncated, failed = fc.fetch_official("zz", date(2026, 8, 1), until)
    assert seen == [("10", date(2026, 8, 1), until), ("20", date(2026, 8, 1), until)]
    assert [i.gazette_id for i in items] == ["CG-DL-E-01092026-100", "CG-DL-E-02092026-200", "CG-DL-E-05092026-300"]
    assert [i.title for i in items][2] == "dupe-wins"  # later value overwrites same gazette_id
    assert items[0].url == "https://egazette.gov.in/WriteReadData/2026/100.pdf"
    assert truncated == [(2026, 8), (2026, 9)]  # unique + sorted
    assert failed == [(2026, 7)]


def test_fetch_official_until_defaults_to_none(monkeypatch):
    monkeypatch.setitem(fc.EGAZETTE_MINISTRY_VALUES, "zz", ["1"])
    seen = []
    monkeypatch.setattr(fc, "search_by_ministry_since", lambda v, s, u: seen.append(u) or ([], [], []))
    assert fc.fetch_official("zz", date(2026, 1, 1)) == ([], [], [])
    assert seen == [None]


# ---------------------------------------------------------------- high_water_mark

def test_high_water_mark_ignores_archived_rows(conn):
    # s2 (2026-09-30) is archived, so the mark is s1's date
    assert fc.high_water_mark(conn, "steel") == date(2026, 3, 10)


def test_high_water_mark_none_when_no_rows(conn):
    assert fc.high_water_mark(conn, "power") is None
    assert fc.high_water_mark(conn, "unknown") is None


# ---------------------------------------------------------------- fetch_fulltext

def test_fetch_fulltext_pipes_curl_into_trafilatura(monkeypatch):
    calls = []

    def fake_run(cmd, **kw):
        calls.append((cmd, kw))
        if cmd[0] == "curl":
            return SimpleNamespace(stdout="<html>page</html>")
        return SimpleNamespace(stdout="  extracted text \n")

    monkeypatch.setattr(fc.subprocess, "run", fake_run)
    assert fc.fetch_fulltext("https://x/y", timeout=9) == "extracted text"
    assert calls[0][0] == ["curl", "-s", "--max-time", "9", "https://x/y"]
    assert calls[1][0] == ["trafilatura"]
    assert calls[1][1]["input"] == "<html>page</html>"
    assert calls[1][1]["timeout"] == 9


# ---------------------------------------------------------------- check_ministry

def test_check_ministry_no_slug(conn):
    r = fc.check_ministry(conn, "not-a-ministry", False)
    assert r == {"ministry_id": "not-a-ministry", "status": "no_slug_mapped", "new_items": []}


def test_check_ministry_no_existing_data(conn):
    r = fc.check_ministry(conn, "power", False)
    assert r == {"ministry_id": "power", "status": "no_existing_data", "new_items": []}


def _patch_sources(monkeypatch, tracker=None, official=None):
    def listing(slug, page=1, timeout=20):
        if isinstance(tracker, Exception):
            raise tracker
        return tracker or []

    def off(mid, since, until=None):
        if isinstance(official, Exception):
            raise official
        return official or ([], [], [])

    monkeypatch.setattr(fc, "fetch_listing", listing)
    monkeypatch.setattr(fc, "fetch_official", off)


def test_check_ministry_three_way_diff_and_date_filter(conn, monkeypatch):
    mark = date(2026, 3, 10)
    tracker = [
        item("T-only", date(2026, 4, 1), "tracker title"),
        item("BOTH", date(2026, 5, 1), "tracker both", url="https://tracker/BOTH"),
        item("OLD", mark, "same day as mark: not new"),
        item("OLDER", date(2026, 1, 1)),
    ]
    official = ([item("BOTH", date(2026, 5, 1), "official both", url="https://egazette/BOTH.pdf"),
                 item("O-only", date(2026, 6, 1), "official title", url="https://egazette/O.pdf"),
                 item("OFF-OLD", mark)],
                [(2026, 6)], [(2026, 2)])
    _patch_sources(monkeypatch, tracker, official)
    r = fc.check_ministry(conn, "steel", do_extract=False)
    assert r["status"] == "ok"
    assert r["high_water_mark"] == "2026-03-10"
    assert r["tracker_status"] == "ok" and r["official_status"] == "ok"
    assert r["truncated_months"] == [(2026, 6)] and r["failed_months"] == [(2026, 2)]
    got = [(e["gazette_id"], e["source"], e["url"], e["title"], e["date"]) for e in r["new_items"]]
    assert got == [
        ("T-only", "tracker_only", "https://gazettetracker.com/g/T-only", "tracker title", "2026-04-01"),
        ("BOTH", "both", "https://egazette/BOTH.pdf", "official both", "2026-05-01"),  # official url+title win
        ("O-only", "official_only", "https://egazette/O.pdf", "official title", "2026-06-01"),
    ]


def test_check_ministry_tracker_only_skips_official(conn, monkeypatch):
    def boom(*a, **k):
        raise AssertionError("official source must not be queried")

    _patch_sources(monkeypatch, [item("T", date(2026, 4, 1))])
    monkeypatch.setattr(fc, "fetch_official", boom)
    r = fc.check_ministry(conn, "steel", False, tracker_only=True)
    assert r["official_status"] == "skipped"
    assert [e["source"] for e in r["new_items"]] == ["tracker_only"]


def test_check_ministry_both_fail_reports_combined_status(conn, monkeypatch):
    _patch_sources(monkeypatch, RuntimeError("tracker down"), RuntimeError("official down"))
    r = fc.check_ministry(conn, "steel", False)
    assert r["status"] == "tracker_fetch_failed: tracker down; official_fetch_failed: official down"
    assert r["new_items"] == []


def test_check_ministry_tracker_fails_official_ok(conn, monkeypatch):
    _patch_sources(monkeypatch, RuntimeError("nope"), ([item("O", date(2026, 7, 1))], [], []))
    r = fc.check_ministry(conn, "steel", False)
    assert r["status"] == "ok"
    assert r["tracker_status"] == "tracker_fetch_failed: nope"
    assert [e["source"] for e in r["new_items"]] == ["official_only"]


def test_check_ministry_tracker_fails_with_tracker_only_is_still_ok_and_empty(conn, monkeypatch):
    # tracker failed, official skipped: only the (tracker AND official-failed) combo aborts
    _patch_sources(monkeypatch, RuntimeError("nope"))
    r = fc.check_ministry(conn, "steel", False, tracker_only=True)
    assert r["status"] == "ok" and r["new_items"] == []
    assert r["tracker_status"].startswith("tracker_fetch_failed")


def test_check_ministry_official_fails_tracker_ok_keeps_tracker_items(conn, monkeypatch):
    _patch_sources(monkeypatch, [item("T", date(2026, 4, 1))], RuntimeError("503"))
    r = fc.check_ministry(conn, "steel", False)
    assert r["status"] == "ok"
    assert r["official_status"] == "official_fetch_failed: 503"
    assert [e["gazette_id"] for e in r["new_items"]] == ["T"]


def test_check_ministry_items_sorted_by_date(conn, monkeypatch):
    tracker = [item("B", date(2026, 8, 1)), item("A", date(2026, 4, 1)), item("C", date(2026, 12, 1))]
    _patch_sources(monkeypatch, tracker)
    r = fc.check_ministry(conn, "steel", False, tracker_only=True)
    assert [e["gazette_id"] for e in r["new_items"]] == ["A", "B", "C"]


def test_check_ministry_extract_only_runs_for_tracker_items(conn, monkeypatch):
    import ingest.mistral_extract as me

    fetched, extracted = [], []
    monkeypatch.setattr(fc, "fetch_fulltext", lambda url: fetched.append(url) or f"text of {url}")
    monkeypatch.setattr(me, "extract_candidates", lambda text: extracted.append(text) or [{"relation": "cites"}])
    tracker = [item("T", date(2026, 4, 1), url="https://gazettetracker.com/g/T"),
               item("BOTH", date(2026, 5, 1), url="https://gazettetracker.com/g/BOTH")]
    official = ([item("BOTH", date(2026, 5, 1), url="https://egazette/BOTH.pdf"),
                 item("O", date(2026, 6, 1), url="https://egazette/O.pdf")], [], [])
    _patch_sources(monkeypatch, tracker, official)
    r = fc.check_ministry(conn, "steel", do_extract=True)
    by_id = {e["gazette_id"]: e for e in r["new_items"]}
    assert by_id["T"]["candidates"] == [{"relation": "cites"}]
    assert by_id["BOTH"]["candidates"] == [{"relation": "cites"}]
    assert "candidates" not in by_id["O"] and "candidates_error" not in by_id["O"]
    # the Full Text is fetched from the tracker page, never the official PDF url
    assert sorted(fetched) == ["https://gazettetracker.com/g/BOTH", "https://gazettetracker.com/g/T"]


def test_check_ministry_extract_empty_text_gives_empty_candidates(conn, monkeypatch):
    import ingest.mistral_extract as me

    monkeypatch.setattr(fc, "fetch_fulltext", lambda url: "")
    monkeypatch.setattr(me, "extract_candidates", lambda text: pytest.fail("must not extract empty text"))
    _patch_sources(monkeypatch, [item("T", date(2026, 4, 1))])
    r = fc.check_ministry(conn, "steel", True, tracker_only=True)
    assert r["new_items"][0]["candidates"] == []


def test_check_ministry_extract_failure_is_isolated_per_item(conn, monkeypatch):
    import ingest.mistral_extract as me

    def fulltext(url):
        if url.endswith("/bad"):
            raise RuntimeError("curl died")
        return "ok text"

    monkeypatch.setattr(fc, "fetch_fulltext", fulltext)
    monkeypatch.setattr(me, "extract_candidates", lambda text: [{"relation": "amends"}])
    _patch_sources(monkeypatch, [item("bad", date(2026, 4, 1), url="https://gazettetracker.com/g/bad"),
                                 item("good", date(2026, 5, 1))])
    r = fc.check_ministry(conn, "steel", True, tracker_only=True)
    by_id = {e["gazette_id"]: e for e in r["new_items"]}
    assert by_id["bad"]["candidates_error"] == "curl died" and "candidates" not in by_id["bad"]
    assert by_id["good"]["candidates"] == [{"relation": "amends"}]


def test_check_ministry_no_extract_means_no_candidate_keys(conn, monkeypatch):
    _patch_sources(monkeypatch, [item("T", date(2026, 4, 1))])
    r = fc.check_ministry(conn, "steel", False, tracker_only=True)
    assert set(r["new_items"][0]) == {"gazette_id", "title", "date", "url", "source"}


# ---------------------------------------------------------------- main

def _db(tmp_path):
    p = tmp_path / "g.db"
    c = sqlite3.connect(p)
    c.executescript(SCHEMA.read_text())
    c.close()
    return str(p)


def _run_main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["freshness_check", *argv])
    fc.main()


def test_main_prints_report_and_stderr_summary(tmp_path, monkeypatch, capsys):
    results = {
        "steel": {"status": "ok", "high_water_mark": "2026-03-10", "official_status": "official_fetch_failed: x",
                  "truncated_months": [(2026, 6)], "failed_months": [(2026, 2)],
                  "new_items": [
                      {"gazette_id": "a", "title": "A", "date": "2026-04-01", "url": "u1", "source": "both",
                       "candidates": [{"relation": "cites", "quote": "नमस्ते"}]},
                      {"gazette_id": "b", "title": "B", "date": "2026-05-01", "url": "u2", "source": "tracker_only"},
                      {"gazette_id": "c", "title": "C", "date": "2026-06-01", "url": "u3", "source": "official_only",
                       "candidates": []},
                  ]},
        "power": {"status": "no_existing_data", "new_items": []},
        "coal": {"status": "ok", "high_water_mark": "2026-01-01", "official_status": "ok", "new_items": []},
    }
    seen = []

    def fake_check(conn, mid, do_extract, tracker_only=False):
        seen.append((mid, do_extract, tracker_only))
        return results[mid]

    monkeypatch.setattr(fc, "check_ministry", fake_check)
    monkeypatch.setattr(fc, "MINISTRY_TRACKER_SLUGS", {"steel": "s", "power": "p", "coal": "c"})
    _run_main(monkeypatch, ["--db", _db(tmp_path), "--extract", "--tracker-only"])
    out, err = capsys.readouterr()
    assert seen == [("coal", True, True), ("power", True, True), ("steel", True, True)]  # sorted ids
    assert out.startswith("# Freshness check\n")
    assert "- **power**: no_existing_data" in out
    assert "- **steel**: official_fetch_failed: x (tracker-only result below)" in out
    assert "possibly-truncated official-source months (hit the page cap): [(2026, 6)]" in out
    assert "official-source months that failed after retries (not searched at all): [(2026, 2)]" in out
    assert "## steel (high-water mark: 2026-03-10)" in out
    assert "- [2026-04-01] A\n  u1" in out
    assert "- [2026-05-01] B (tracker only)\n  u2" in out
    assert "- [2026-06-01] C (**official source only** -- tracker may have missed this)\n  u3" in out
    assert 'candidates: [{"relation": "cites", "quote": "नमस्ते"}]' in out  # ensure_ascii=False
    assert out.count("candidates:") == 1  # empty list not printed
    assert "## coal" not in out  # no new items -> no section
    assert err.strip() == "3 new item(s) found across 3 ministry(ies) checked (1 seen only by the official source)."


def test_main_single_ministry_and_default_flags(tmp_path, monkeypatch, capsys):
    seen = []
    monkeypatch.setattr(fc, "check_ministry",
                        lambda conn, mid, do_extract, tracker_only=False: seen.append((mid, do_extract, tracker_only))
                        or {"status": "ok", "official_status": "ok", "new_items": []})
    _run_main(monkeypatch, ["--db", _db(tmp_path), "--ministry", "steel"])
    out, err = capsys.readouterr()
    assert seen == [("steel", False, False)]
    assert "0 new item(s) found across 1 ministry(ies) checked (0 seen only by the official source)." in err


def test_main_default_db_name_is_gazette_db(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    opened = []
    real = sqlite3.connect
    monkeypatch.setattr(fc.sqlite3, "connect", lambda p: opened.append(p) or real(":memory:"))
    monkeypatch.setattr(fc, "MINISTRY_TRACKER_SLUGS", {})
    _run_main(monkeypatch, [])
    assert opened == ["gazette.db"]

