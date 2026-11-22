"""Boundary tests for db.crud paths the main suite leaves unexercised:
number lookup, thread filter, empty/real updates, missing-row errors,
include_archived semantics and lineage on archived rows."""
import sqlite3
from pathlib import Path

import pytest

from db.crud import (
    NotFoundError,
    NotificationFields,
    archive_cross_reference,
    archive_notification,
    create_cross_reference,
    create_notification,
    get_lineage,
    get_notification,
    get_notification_by_number,
    list_cross_references,
    list_notifications,
    restore_cross_reference,
    restore_notification,
    update_notification,
    verify_cross_reference,
)

SCHEMA = Path(__file__).parent.parent / "db" / "schema.sql"


@pytest.fixture
def conn():
    c = sqlite3.connect(":memory:")
    c.execute("PRAGMA foreign_keys = ON")
    c.executescript(SCHEMA.read_text())
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('customs', 'Ministry of Finance')")
    c.execute("INSERT INTO subject_thread (thread_id, subject_summary) VALUES ('t1', 'Duty')")
    create_notification(c, "cus-45-2025", "Customs", "45/2025", "2025-10-24", "4-digit-year",
                        NotificationFields(year=2025, thread_id="t1", ministry_id="customs"))
    create_notification(c, "cus-31-2024", "Customs", "31/2024", "2024-05-01", "4-digit-year",
                        NotificationFields(year=2024))
    yield c
    c.close()


def test_get_by_number_matches_series_case_insensitively(conn):
    assert get_notification_by_number(conn, "CUSTOMS", "45/2025")["gazette_id"] == "cus-45-2025"
    assert get_notification_by_number(conn, "customs", "45/2025")["gazette_id"] == "cus-45-2025"


def test_get_by_number_requires_exact_number(conn):
    assert get_notification_by_number(conn, "Customs", "45/2026") is None
    assert get_notification_by_number(conn, "Customs", "45") is None
    assert get_notification_by_number(conn, "Other", "45/2025") is None


def test_get_by_number_archived_rows_follow_include_archived(conn):
    archive_notification(conn, "cus-45-2025")
    assert get_notification_by_number(conn, "Customs", "45/2025")["gazette_id"] == "cus-45-2025"
    assert get_notification_by_number(conn, "Customs", "45/2025", include_archived=True) is not None
    assert get_notification_by_number(conn, "Customs", "45/2025", include_archived=False) is None
    # an un-archived row is still returned under include_archived=False
    assert get_notification_by_number(conn, "Customs", "31/2024", include_archived=False) is not None


def test_list_notifications_filters_by_thread_and_orders_by_publish_date(conn):
    assert [n["gazette_id"] for n in list_notifications(conn, thread_id="t1")] == ["cus-45-2025"]
    assert [n["gazette_id"] for n in list_notifications(conn)] == ["cus-31-2024", "cus-45-2025"]
    assert list_notifications(conn, ministry_id="customs", thread_id="nope") == []


def test_list_notifications_include_archived(conn):
    archive_notification(conn, "cus-31-2024")
    assert [n["gazette_id"] for n in list_notifications(conn)] == ["cus-45-2025"]
    assert len(list_notifications(conn, include_archived=True)) == 2


def test_update_notification_changes_only_named_columns(conn):
    out = update_notification(conn, "cus-45-2025", subject="New subject", ocr_status="needs_ocr")
    assert out["subject"] == "New subject"
    assert out["ocr_status"] == "needs_ocr"
    assert out["series"] == "Customs"  # untouched
    assert get_notification(conn, "cus-31-2024")["subject"] is None  # other row untouched


def test_update_with_no_fields_returns_current_row(conn):
    assert update_notification(conn, "cus-45-2025")["gazette_id"] == "cus-45-2025"


def test_update_with_no_fields_on_missing_row_raises(conn):
    with pytest.raises(NotFoundError):
        update_notification(conn, "nope")


def test_update_unknown_column_message_lists_it(conn):
    with pytest.raises(ValueError, match=r"\['bogus'\]"):
        update_notification(conn, "cus-45-2025", bogus=1)


def test_update_rejects_archived_at_directly(conn):
    # archived_at is only reachable through archive_/restore_, never update_
    with pytest.raises(ValueError):
        update_notification(conn, "cus-45-2025", archived_at="2026-01-01")


def test_archive_and_restore_missing_notification_raise(conn):
    with pytest.raises(NotFoundError):
        archive_notification(conn, "nope")
    with pytest.raises(NotFoundError):
        restore_notification(conn, "nope")


def test_archive_sets_iso_timestamp_and_restore_clears_it(conn):
    row = archive_notification(conn, "cus-45-2025")
    assert row["archived_at"].endswith("+00:00")
    assert restore_notification(conn, "cus-45-2025")["archived_at"] is None


def test_cross_reference_missing_row_errors(conn):
    for fn in (archive_cross_reference, restore_cross_reference):
        with pytest.raises(NotFoundError):
            fn(conn, 999)
    with pytest.raises(NotFoundError):
        verify_cross_reference(conn, 999, verified_by="x")


def test_create_cross_reference_missing_source_names_the_source(conn):
    with pytest.raises(NotFoundError, match="source 'ghost'"):
        create_cross_reference(conn, "ghost", "cus-45-2025", "amends")


def test_create_cross_reference_missing_target_names_the_target(conn):
    with pytest.raises(NotFoundError, match="target 'ghost'"):
        create_cross_reference(conn, "cus-45-2025", "ghost", "amends")


def test_verify_uses_explicit_timestamp_when_given(conn):
    ref = create_cross_reference(conn, "cus-45-2025", "cus-31-2024", "supersedes")
    out = verify_cross_reference(conn, ref["ref_id"], "rev", verified_at="2026-02-02T00:00:00+00:00")
    assert out["verified_at"] == "2026-02-02T00:00:00+00:00"


def test_list_cross_references_unverified_only_and_archived_flags(conn):
    a = create_cross_reference(conn, "cus-45-2025", "cus-31-2024", "supersedes")
    b = create_cross_reference(conn, "cus-45-2025", "cus-31-2024", "amends", verified_by="rev")
    assert {r["ref_id"] for r in list_cross_references(conn)} == {a["ref_id"], b["ref_id"]}
    assert [r["ref_id"] for r in list_cross_references(conn, unverified_only=True)] == [a["ref_id"]]
    archive_cross_reference(conn, a["ref_id"])
    assert [r["ref_id"] for r in list_cross_references(conn)] == [b["ref_id"]]
    assert {r["ref_id"] for r in list_cross_references(conn, include_archived=True)} == {a["ref_id"], b["ref_id"]}
    assert list_cross_references(conn, unverified_only=True) == []


def test_lineage_works_for_archived_notification_and_missing_raises(conn):
    create_cross_reference(conn, "cus-45-2025", "cus-31-2024", "supersedes")
    archive_notification(conn, "cus-31-2024")
    lineage = get_lineage(conn, "cus-31-2024")
    assert [r["source_gazette_id"] for r in lineage["pointed_at_by"]] == ["cus-45-2025"]
    with pytest.raises(NotFoundError):
        get_lineage(conn, "nope")
