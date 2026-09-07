"""
Tests for ingest.coverage_ledger. record_coverage()/render_ledger() are
pure DB functions, tested directly with no network. scan_and_record()'s
network call (ingest.egazette_search.search_by_ministry_since) is mocked.
"""
import sqlite3
from datetime import date
from pathlib import Path
from unittest.mock import patch

import pytest

from ingest.coverage_ledger import SOURCE_EGAZETTE_SEARCH, record_coverage, render_ledger, scan_and_record
from ingest.egazette_search import GazetteSearchResult

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('steel', 'Ministry of Steel')")
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('atomic-energy', 'Department of Atomic Energy')")
    yield c
    c.close()


def test_record_coverage_stores_a_row(conn):
    coverage_id = record_coverage(
        conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 12, 31),
        ["CG-DL-E-01012020-100000", "CG-DL-E-02022020-100001"],
    )
    row = conn.execute("SELECT * FROM extraction_coverage WHERE coverage_id = ?", (coverage_id,)).fetchone()
    assert row is not None
    assert row[1] == "steel"
    assert row[2] == SOURCE_EGAZETTE_SEARCH
    assert row[3] == "2020-01-01"
    assert row[4] == "2020-12-31"


def test_record_coverage_allows_an_empty_result(conn):
    coverage_id = record_coverage(conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2021, 1, 1), date(2021, 1, 31), [])
    row = conn.execute("SELECT gazette_ids_found FROM extraction_coverage WHERE coverage_id = ?", (coverage_id,)).fetchone()
    assert row[0] == "[]"


def test_record_coverage_stores_truncated_months(conn):
    coverage_id = record_coverage(
        conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 2, 28),
        ["CG-DL-E-01012020-100000"], possibly_truncated=[(2020, 1)],
    )
    row = conn.execute("SELECT possibly_truncated FROM extraction_coverage WHERE coverage_id = ?", (coverage_id,)).fetchone()
    assert row[0] == "[[2020, 1]]"


def test_record_coverage_stores_failed_months(conn):
    coverage_id = record_coverage(
        conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 2, 28),
        ["CG-DL-E-01012020-100000"], failed_months=[(2020, 2)],
    )
    row = conn.execute("SELECT failed_months FROM extraction_coverage WHERE coverage_id = ?", (coverage_id,)).fetchone()
    assert row[0] == "[[2020, 2]]"


def test_render_ledger_shows_failed_months(conn):
    record_coverage(
        conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 2, 28),
        ["a"], failed_months=[(2020, 2)],
    )
    table = render_ledger(conn)
    # JSON round-trips a tuple as a 2-element list, so [2020, 2] (not the
    # tuple repr) is what actually appears in the rendered cell.
    assert "[[2020, 2]]" in table
    assert "none" not in table.split("\n")[-1]  # the failed-months cell isn't the "none" placeholder here


def test_render_ledger_shows_none_when_no_failed_months(conn):
    record_coverage(conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 12, 31), ["a"])
    table = render_ledger(conn)
    assert "| none |" in table


def test_render_ledger_empty_says_so(conn):
    table = render_ledger(conn)
    assert "no coverage recorded yet" in table


def test_render_ledger_shows_recorded_windows(conn):
    record_coverage(conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 12, 31), ["a", "b"])
    table = render_ledger(conn)
    assert "Ministry of Steel" in table
    assert "2020-01-01..2020-12-31" in table
    assert "| 2 |" in table


def test_render_ledger_filters_by_ministry(conn):
    record_coverage(conn, "steel", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 12, 31), ["a"])
    record_coverage(conn, "atomic-energy", SOURCE_EGAZETTE_SEARCH, date(2020, 1, 1), date(2020, 12, 31), ["b"])
    table = render_ledger(conn, ministry_id="steel")
    assert "Ministry of Steel" in table
    assert "Atomic Energy" not in table


def test_scan_and_record_raises_for_unmapped_ministry(conn):
    conn.execute("INSERT INTO ministry (ministry_id, name) VALUES ('unmapped', 'Ministry of Nowhere')")
    with pytest.raises(ValueError, match="no egazette.gov.in ddlMinistry value mapped"):
        scan_and_record(conn, "unmapped", date(2020, 1, 1))


def test_scan_and_record_merges_across_multiple_dropdown_values(conn):
    # atomic-energy maps to two ddlMinistry values (see db/egazette_ministry_map.py) --
    # scan_and_record should merge results from both into one coverage row.
    results_by_value = {
        "375": ([GazetteSearchResult(
            gazette_id="CG-DL-E-01012020-100000", ministry="Ministry of Atomic Energy",
            department=None, office=None, subject="s1", category=None, part_section=None,
            issue_date=date(2020, 1, 1), publish_date=date(2020, 1, 1),
        )], [], []),
        "157": ([GazetteSearchResult(
            gazette_id="CG-DL-E-02012020-100001", ministry="PMO --> Department of Atomic Energy",
            department=None, office=None, subject="s2", category=None, part_section=None,
            issue_date=date(2020, 1, 2), publish_date=date(2020, 1, 2),
        )], [(2020, 1)], [(2020, 2)]),
    }

    def fake_search(value, since, until):
        return results_by_value[value]

    with patch("ingest.coverage_ledger.search_by_ministry_since", side_effect=fake_search):
        result = scan_and_record(conn, "atomic-energy", date(2020, 1, 1), date(2020, 1, 31))

    assert result["gazette_ids_found"] == ["CG-DL-E-01012020-100000", "CG-DL-E-02012020-100001"]
    assert result["possibly_truncated"] == [(2020, 1)]
    assert result["failed_months"] == [(2020, 2)]
    row = conn.execute("SELECT COUNT(*) FROM extraction_coverage WHERE ministry_id = 'atomic-energy'").fetchone()
    assert row[0] == 1  # one merged row, not one per dropdown value
