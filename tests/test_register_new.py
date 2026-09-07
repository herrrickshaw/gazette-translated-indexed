"""
Tests for ingest.register_new. No network: fetch()/extract_text() are
mocked, but the DB fixture seeds real, already-verified rows (Ministry of
Steel's actual series label and one of its real S.O. citations — see
db/seed_steel.sql) so a passing test also exercises the real data shape
series_for_ministry() reads from.
"""
import sqlite3
from pathlib import Path
from unittest.mock import patch

import pytest

from extract.citation_patterns import GazetteCitation
from ingest.pdf_text import LikelyScannedError
from ingest.register_new import CBIC_MINISTRY_ID, register_for_ministry, register_item, series_for_ministry

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('steel', 'Ministry of Steel')")
    c.execute(
        "INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id) "
        "VALUES ('steel-so-3716-2024', 'Steel', 'S.O. 3716(E)', 2024, 'so-only', '2024-08-29', 'S.O. 3716(E)', 'steel')"
    )
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('multi', 'Ministry of Multi')")
    c.execute(
        "INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id) "
        "VALUES ('multi-a-1-2024', 'SeriesA', 'S.O. 1(E)', 2024, 'so-only', '2024-01-01', 'S.O. 1(E)', 'multi')"
    )
    c.execute(
        "INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id) "
        "VALUES ('multi-b-2-2024', 'SeriesB', 'S.O. 2(E)', 2024, 'so-only', '2024-01-02', 'S.O. 2(E)', 'multi')"
    )
    yield c
    c.close()


# --- series_for_ministry ---

def test_series_for_ministry_returns_the_single_real_value(conn):
    assert series_for_ministry(conn, "steel") == "Steel"


def test_series_for_ministry_raises_when_no_data_yet(conn):
    conn.execute("INSERT INTO ministry (ministry_id, name) VALUES ('empty', 'Ministry of Empty')")
    with pytest.raises(ValueError, match="no existing series value"):
        series_for_ministry(conn, "empty")


def test_series_for_ministry_raises_when_ambiguous(conn):
    with pytest.raises(ValueError, match="ambiguous series"):
        series_for_ministry(conn, "multi")


# --- register_item ---

def test_register_item_skips_already_registered(conn):
    item = {"gazette_id": "steel-so-3716-2024", "date": "2024-08-29", "url": "https://example.com"}
    result = register_item(conn, item, "steel")
    assert result == {"gazette_id": "steel-so-3716-2024", "status": "already_registered"}


def test_register_item_refuses_cbic(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999999", "date": "2026-01-01", "url": "https://example.com"}
    result = register_item(conn, item, CBIC_MINISTRY_ID)
    assert result["status"] == "skipped_cbic_numbering_not_derivable"


def test_register_item_refuses_ambiguous_series(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999998", "date": "2026-01-01", "url": "https://example.com"}
    result = register_item(conn, item, "multi")
    assert result["status"].startswith("skipped_ambiguous_series")


def test_register_item_skips_scanned_pdf(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999997", "date": "2026-01-01", "url": "https://example.com"}
    with patch("ingest.register_new.fetch", return_value=Path("/fake.pdf")), \
         patch("ingest.register_new.extract_text", side_effect=LikelyScannedError("scanned")):
        result = register_item(conn, item, "steel")
    assert result["status"] == "skipped_needs_ocr"


def test_register_item_skips_fetch_failure(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999996", "date": "2026-01-01", "url": "https://example.com"}
    with patch("ingest.register_new.fetch", side_effect=RuntimeError("network down")):
        result = register_item(conn, item, "steel")
    assert result["status"] == "skipped_fetch_failed: network down"


def test_register_item_skips_when_no_self_citation_found(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999995", "date": "2026-01-01", "url": "https://example.com"}
    with patch("ingest.register_new.fetch", return_value=Path("/fake.pdf")), \
         patch("ingest.register_new.extract_text", return_value="no citation in this text at all"), \
         patch("ingest.register_new.find_gazette_citations", return_value=[]):
        result = register_item(conn, item, "steel")
    assert result["status"] == "skipped_no_self_citation_found"


def test_register_item_success_derives_real_fields_and_creates_the_row(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999994", "date": "2026-01-01", "url": "https://egazette.gov.in/WriteReadData/2026/999994.pdf"}
    fake_citation = GazetteCitation(kind="S.O.", normalized="S.O. 4242(E)", start=10, end=25)
    with patch("ingest.register_new.fetch", return_value=Path("/fake.pdf")), \
         patch("ingest.register_new.extract_text", return_value="...S.O. 4242(E)...notification text..."), \
         patch("ingest.register_new.find_gazette_citations", return_value=[fake_citation]):
        result = register_item(conn, item, "steel")

    assert result == {"gazette_id": "CG-DL-E-01012026-999994", "status": "registered"}
    row = conn.execute(
        "SELECT gazette_id, series, number, gsr_or_so, numbering_form, year, publish_date, ministry_id, pdf_url "
        "FROM gazette_notification WHERE gazette_id = ?",
        ("CG-DL-E-01012026-999994",),
    ).fetchone()
    assert tuple(row) == (
        "CG-DL-E-01012026-999994", "Steel", "S.O. 4242(E)", "S.O. 4242(E)", "so-only", 2026, "2026-01-01",
        "steel", "https://egazette.gov.in/WriteReadData/2026/999994.pdf",
    )


def test_register_item_never_touches_cross_reference(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999993", "date": "2026-01-01", "url": "https://example.com"}
    fake_citation = GazetteCitation(kind="S.O.", normalized="S.O. 7777(E)", start=0, end=10)
    with patch("ingest.register_new.fetch", return_value=Path("/fake.pdf")), \
         patch("ingest.register_new.extract_text", return_value="S.O. 7777(E) text"), \
         patch("ingest.register_new.find_gazette_citations", return_value=[fake_citation]):
        register_item(conn, item, "steel")
    assert conn.execute("SELECT COUNT(*) FROM cross_reference").fetchone()[0] == 0


def test_register_item_series_override_bypasses_ambiguity(conn):
    item = {"gazette_id": "CG-DL-E-01012026-999992", "date": "2026-01-01", "url": "https://example.com"}
    fake_citation = GazetteCitation(kind="S.O.", normalized="S.O. 5555(E)", start=0, end=10)
    with patch("ingest.register_new.fetch", return_value=Path("/fake.pdf")), \
         patch("ingest.register_new.extract_text", return_value="S.O. 5555(E) text"), \
         patch("ingest.register_new.find_gazette_citations", return_value=[fake_citation]):
        result = register_item(conn, item, "multi", series="SeriesA")
    assert result["status"] == "registered"


# --- register_for_ministry ---

def test_register_for_ministry_reports_freshness_check_failure(conn):
    with patch("ingest.register_new.check_ministry", return_value={"ministry_id": "steel", "status": "no_existing_data", "new_items": []}):
        outcomes = register_for_ministry(conn, "steel")
    assert len(outcomes) == 1
    assert outcomes[0]["status"] == "freshness_check_failed: no_existing_data"


def test_register_for_ministry_registers_every_new_item(conn):
    fake_new_items = [
        {"gazette_id": "CG-DL-E-01012026-999991", "date": "2026-01-01", "url": "https://example.com", "title": "t", "source": "both"},
        {"gazette_id": "steel-so-3716-2024", "date": "2024-08-29", "url": "https://example.com", "title": "t", "source": "both"},
    ]
    fake_citation = GazetteCitation(kind="S.O.", normalized="S.O. 8888(E)", start=0, end=10)
    with patch("ingest.register_new.check_ministry",
               return_value={"ministry_id": "steel", "status": "ok", "new_items": fake_new_items}), \
         patch("ingest.register_new.fetch", return_value=Path("/fake.pdf")), \
         patch("ingest.register_new.extract_text", return_value="S.O. 8888(E) text"), \
         patch("ingest.register_new.find_gazette_citations", return_value=[fake_citation]):
        outcomes = register_for_ministry(conn, "steel")
    statuses = {o["gazette_id"]: o["status"] for o in outcomes}
    assert statuses["CG-DL-E-01012026-999991"] == "registered"
    assert statuses["steel-so-3716-2024"] == "already_registered"
