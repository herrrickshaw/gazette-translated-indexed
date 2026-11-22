"""ingest.coverage_ledger: argument parsing / CLI paths and the finer semantics of
record_coverage, scan_and_record and render_ledger. The egazette client is faked."""
import json
import sqlite3
import sys
from datetime import date
from pathlib import Path

import pytest

from ingest import coverage_ledger as cl
from ingest.egazette_search import GazetteSearchResult

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


def res(gid, d=date(2020, 1, 5)):
    return GazetteSearchResult(gid, "m", None, None, "s", None, None, d, d)


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('steel', 'Ministry of Steel')")
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('coal', 'Ministry of Coal')")
    yield c
    c.close()


@pytest.fixture
def dbfile(tmp_path):
    p = tmp_path / "g.db"
    c = sqlite3.connect(p)
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('steel', 'Ministry of Steel')")
    c.commit()
    c.close()
    return str(p)


def _main(monkeypatch, argv):
    monkeypatch.setattr(sys, "argv", ["coverage_ledger", *argv])
    return cl.main()


# ------------------------------------------------------------ record_coverage

def test_record_coverage_sorts_ids_and_stores_nulls_for_empty_lists(conn):
    cid = cl.record_coverage(conn, "steel", "src", date(2020, 1, 1), date(2020, 1, 31), ["b", "a"],
                             possibly_truncated=[], failed_months=[])
    row = conn.execute("SELECT * FROM extraction_coverage WHERE coverage_id = ?", (cid,)).fetchone()
    assert row[5] == '["a", "b"]'
    assert row[6] is None and row[7] is None  # empty list stored as NULL, not "[]"


def test_record_coverage_checked_at_is_utc_iso_seconds(conn):
    cid = cl.record_coverage(conn, "steel", "src", date(2020, 1, 1), date(2020, 1, 31), [])
    checked = conn.execute("SELECT checked_at FROM extraction_coverage WHERE coverage_id = ?", (cid,)).fetchone()[0]
    assert checked.endswith("+00:00") and "." not in checked


def test_record_coverage_commits_and_returns_increasing_ids(conn):
    a = cl.record_coverage(conn, "steel", "src", date(2020, 1, 1), date(2020, 1, 31), [])
    b = cl.record_coverage(conn, "steel", "src", date(2020, 1, 1), date(2020, 1, 31), [])  # same window: no dedupe
    assert b == a + 1
    assert conn.in_transaction is False
    assert conn.execute("SELECT COUNT(*) FROM extraction_coverage").fetchone()[0] == 2


def test_record_coverage_unknown_ministry_violates_fk(conn):
    with pytest.raises(sqlite3.IntegrityError):
        cl.record_coverage(conn, "ghost", "src", date(2020, 1, 1), date(2020, 1, 31), [])


# ------------------------------------------------------------ scan_and_record

def test_scan_defaults_until_to_today_and_passes_single_value(conn, monkeypatch):
    seen = []
    monkeypatch.setattr(cl, "search_by_ministry_since",
                        lambda value, since, until: seen.append((value, since, until)) or ([res("g1")], [], []))
    out = cl.scan_and_record(conn, "steel", date(2020, 1, 1))
    assert seen == [(cl.EGAZETTE_MINISTRY_VALUES["steel"][0], date(2020, 1, 1), date.today())]
    assert out["date_to"] == date.today().isoformat() and out["date_from"] == "2020-01-01"
    assert out["gazette_ids_found"] == ["g1"] and out["possibly_truncated"] == [] and out["failed_months"] == []
    row = conn.execute("SELECT source, possibly_truncated, failed_months FROM extraction_coverage").fetchone()
    assert row == (cl.SOURCE_EGAZETTE_SEARCH, None, None)


def test_scan_dedupes_ids_and_dedupes_failed_but_keeps_truncated_duplicates(conn, monkeypatch):
    payload = {
        "375": ([res("a"), res("b")], [(2020, 1)], [(2020, 3), (2020, 2)]),
        "157": ([res("b"), res("c")], [(2020, 1)], [(2020, 2)]),
    }
    monkeypatch.setattr(cl, "search_by_ministry_since", lambda v, s, u: payload[v])
    monkeypatch.setitem(cl.EGAZETTE_MINISTRY_VALUES, "steel", ["375", "157"])
    out = cl.scan_and_record(conn, "steel", date(2020, 1, 1), date(2020, 3, 31))
    assert out["gazette_ids_found"] == ["a", "b", "c"]
    assert out["failed_months"] == [(2020, 2), (2020, 3)]  # unique, sorted
    assert out["possibly_truncated"] == [(2020, 1), (2020, 1)]  # extended, not deduped
    row = conn.execute("SELECT gazette_ids_found, possibly_truncated, failed_months FROM extraction_coverage").fetchone()
    assert json.loads(row[0]) == ["a", "b", "c"]
    assert json.loads(row[1]) == [[2020, 1], [2020, 1]]
    assert json.loads(row[2]) == [[2020, 2], [2020, 3]]


def test_scan_empty_mapping_value_list_raises(conn, monkeypatch):
    monkeypatch.setitem(cl.EGAZETTE_MINISTRY_VALUES, "steel", [])
    with pytest.raises(ValueError, match="no egazette.gov.in ddlMinistry value mapped for 'steel'"):
        cl.scan_and_record(conn, "steel", date(2020, 1, 1))
    assert conn.execute("SELECT COUNT(*) FROM extraction_coverage").fetchone()[0] == 0


def test_scan_search_exception_records_nothing(conn, monkeypatch):
    def boom(*a):
        raise RuntimeError("down")

    monkeypatch.setattr(cl, "search_by_ministry_since", boom)
    with pytest.raises(RuntimeError):
        cl.scan_and_record(conn, "steel", date(2020, 1, 1), date(2020, 2, 1))
    assert conn.execute("SELECT COUNT(*) FROM extraction_coverage").fetchone()[0] == 0


# ------------------------------------------------------------ render_ledger

def test_render_ledger_header_and_row_format(conn):
    cl.record_coverage(conn, "steel", "egazette_search", date(2020, 1, 1), date(2020, 6, 30), ["a", "b"],
                       possibly_truncated=[(2020, 3)], failed_months=[(2020, 4)])
    lines = cl.render_ledger(conn).split("\n")
    assert lines[0] == ("| Ministry | Source | Date range | Gazettes found | Possibly truncated "
                        "| Failed months (not covered) | Checked at |")
    assert lines[1] == "|---|---|---|---:|---|---|---|"
    cells = [c.strip() for c in lines[2].strip("|").split("|")]
    assert cells[:4] == ["Ministry of Steel", "egazette_search", "2020-01-01..2020-06-30", "2"]
    assert cells[4] == "yes: [[2020, 3]]" and cells[5] == "[[2020, 4]]"
    assert len(lines) == 3


def test_render_ledger_no_flags_prints_no_and_none(conn):
    cl.record_coverage(conn, "steel", "s", date(2020, 1, 1), date(2020, 1, 31), [])
    cells = [c.strip() for c in cl.render_ledger(conn).split("\n")[2].strip("|").split("|")]
    assert cells[3] == "0" and cells[4] == "no" and cells[5] == "none"


def test_render_ledger_orders_by_ministry_then_date_from(conn):
    cl.record_coverage(conn, "steel", "s", date(2021, 1, 1), date(2021, 1, 31), [])
    cl.record_coverage(conn, "steel", "s", date(2019, 1, 1), date(2019, 1, 31), [])
    cl.record_coverage(conn, "coal", "s", date(2022, 1, 1), date(2022, 1, 31), [])
    rows = cl.render_ledger(conn).split("\n")[2:]
    assert [r.split("|")[1].strip() + " " + r.split("|")[3].strip()[:4] for r in rows] == [
        "Ministry of Coal 2022", "Ministry of Steel 2019", "Ministry of Steel 2021"]


def test_render_ledger_filter_with_no_rows_says_none_recorded(conn):
    cl.record_coverage(conn, "steel", "s", date(2020, 1, 1), date(2020, 1, 31), [])
    table = cl.render_ledger(conn, ministry_id="coal")
    assert table.split("\n")[2] == "| *(no coverage recorded yet)* | | | | | | |"


# ------------------------------------------------------------ main

def test_main_scan_requires_ministry_and_since(monkeypatch, dbfile, capsys):
    assert _main(monkeypatch, ["--db", dbfile]) == 2
    assert "--ministry and --since are required unless --render is given" in capsys.readouterr().err
    assert _main(monkeypatch, ["--db", dbfile, "--ministry", "steel"]) == 2
    assert _main(monkeypatch, ["--db", dbfile, "--since", "2020-01-01"]) == 2


def test_main_scan_prints_summary_and_warnings(monkeypatch, dbfile, capsys):
    seen = []
    monkeypatch.setattr(cl, "scan_and_record", lambda conn, mid, since, until: seen.append((mid, since, until)) or {
        "coverage_id": 7, "date_from": "2020-01-01", "date_to": "2020-06-30", "gazette_ids_found": ["a", "b", "c"],
        "possibly_truncated": [(2020, 2)], "failed_months": [(2020, 3)]})
    assert _main(monkeypatch, ["--db", dbfile, "--ministry", "steel", "--since", "2020-01-01", "--until", "2020-06-30"]) == 0
    out, err = capsys.readouterr()
    assert seen == [("steel", date(2020, 1, 1), date(2020, 6, 30))]
    assert out == "[steel] 2020-01-01..2020-06-30: 3 gazette(s) found (coverage_id=7)\n"
    assert "possibly-truncated months (hit the page cap): [(2020, 2)]" in err
    assert "months that failed after retries (not covered at all): [(2020, 3)]" in err


def test_main_scan_until_defaults_to_none_and_clean_run_has_no_warnings(monkeypatch, dbfile, capsys):
    seen = []
    monkeypatch.setattr(cl, "scan_and_record", lambda conn, mid, since, until: seen.append(until) or {
        "coverage_id": 1, "date_from": "a", "date_to": "b", "gazette_ids_found": [],
        "possibly_truncated": [], "failed_months": []})
    assert _main(monkeypatch, ["--db", dbfile, "--ministry", "steel", "--since", "2020-01-01"]) == 0
    assert seen == [None]
    assert capsys.readouterr().err == ""


def test_main_scan_end_to_end_writes_row(monkeypatch, dbfile, capsys):
    monkeypatch.setattr(cl, "search_by_ministry_since", lambda v, s, u: ([res("gX")], [], []))
    monkeypatch.setitem(cl.EGAZETTE_MINISTRY_VALUES, "steel", ["34"])
    assert _main(monkeypatch, ["--db", dbfile, "--ministry", "steel", "--since", "2020-01-01", "--until", "2020-01-31"]) == 0
    c = sqlite3.connect(dbfile)
    assert c.execute("SELECT ministry_id, gazette_ids_found FROM extraction_coverage").fetchone() == ("steel", '["gX"]')
    c.close()


def test_main_render_prints_table(monkeypatch, dbfile, capsys):
    assert _main(monkeypatch, ["--db", dbfile, "--render"]) == 0
    assert "no coverage recorded yet" in capsys.readouterr().out


def test_main_render_ministry_filter(monkeypatch, dbfile, capsys):
    c = sqlite3.connect(dbfile)
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('coal', 'Ministry of Coal')")
    c.commit()
    cl.record_coverage(c, "steel", "s", date(2020, 1, 1), date(2020, 1, 31), [])
    cl.record_coverage(c, "coal", "s", date(2020, 1, 1), date(2020, 1, 31), [])
    c.close()
    _main(monkeypatch, ["--db", dbfile, "--render", "--ministry", "coal"])
    out = capsys.readouterr().out
    assert "Ministry of Coal" in out and "Ministry of Steel" not in out


def test_main_render_out_writes_file_with_header(monkeypatch, dbfile, tmp_path, capsys):
    out_path = tmp_path / "ledger.md"
    assert _main(monkeypatch, ["--db", dbfile, "--render", "--out", str(out_path)]) == 0
    text = out_path.read_text()
    assert text.startswith("# Extraction coverage ledger\n\nRegenerated by `python3 -m ingest.coverage_ledger --render`")
    assert text.endswith("| *(no coverage recorded yet)* | | | | | | |\n")
    out, err = capsys.readouterr()
    assert out == "" and err == f"wrote {out_path}\n"


def test_main_default_db_is_gazette_db(monkeypatch, tmp_path):
    monkeypatch.chdir(tmp_path)
    opened = []
    real = sqlite3.connect
    monkeypatch.setattr(cl.sqlite3, "connect", lambda p: opened.append(p) or real(":memory:"))
    monkeypatch.setattr(cl, "render_ledger", lambda conn, mid: "T")
    _main(monkeypatch, ["--render"])
    assert opened == ["gazette.db"]
