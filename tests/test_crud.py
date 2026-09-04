"""
Tests for db.crud — Create/Read/Update/Delete over an in-memory schema
seeded with two real, already-verified notifications and their real
cross-reference (Ministry of Power: S.O. 3520(E) amends S.O. 5852(E) —
see db/seed_power.sql), not synthetic placeholder rows, so a passing test
also exercises the actual data shape the pipeline runs on.
"""
import sqlite3
from pathlib import Path

import pytest

from db.crud import (
    ConflictError, NotFoundError, ReferencedError,
    NotificationFields,
    create_notification, get_notification, list_notifications,
    update_notification, archive_notification, restore_notification,
    hard_delete_notification,
    create_cross_reference, get_cross_reference, list_cross_references,
    verify_cross_reference, archive_cross_reference, restore_cross_reference,
    hard_delete_cross_reference,
    get_lineage,
)

SCHEMA = Path(__file__).parent.parent / 'db' / 'schema.sql'


@pytest.fixture
def conn():
    c = sqlite3.connect(':memory:')
    c.execute('PRAGMA foreign_keys = ON')
    c.executescript(SCHEMA.read_text())
    # real rows, not placeholders
    c.execute("INSERT INTO ministry (ministry_id, name) VALUES ('power', 'Ministry of Power')")
    c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id) "
              "VALUES ('power-so-5852-2022', 'Power', 'S.O. 5852(E)', 2022, 'so-only', '2022-12-13', 'S.O. 5852(E)', 'power')")
    c.execute("INSERT INTO gazette_notification (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so, ministry_id) "
              "VALUES ('power-so-3520-2026', 'Power', 'S.O. 3520(E)', 2026, 'so-only', '2026-06-11', 'S.O. 3520(E)', 'power')")
    yield c
    c.close()


# --- Create ---

def test_create_notification_stores_url_not_bytes(conn):
    n = create_notification(
        conn, 'test-1', 'Power', 'S.O. 999(E)', '2026-01-01', 'so-only',
        NotificationFields(pdf_url='https://egazette.gov.in/WriteReadData/2026/999.pdf'),
    )
    assert n['pdf_url'].startswith('https://egazette.gov.in/')
    assert 'pdf_bytes' not in n and 'pdf_content' not in n  # schema literally has no such column


def test_create_notification_conflict(conn):
    with pytest.raises(ConflictError):
        create_notification(conn, 'power-so-5852-2022', 'Power', 'S.O. 5852(E)', '2022-12-13', 'so-only')


def test_create_cross_reference_requires_both_endpoints_to_exist(conn):
    with pytest.raises(NotFoundError):
        create_cross_reference(conn, 'power-so-3520-2026', 'nonexistent-id', 'amends')


def test_create_cross_reference_conflict_on_duplicate_triple(conn):
    create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    with pytest.raises(ConflictError):
        create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')


# --- Read ---

def test_get_notification_found_and_missing(conn):
    assert get_notification(conn, 'power-so-5852-2022')['gsr_or_so'] == 'S.O. 5852(E)'
    assert get_notification(conn, 'nope') is None


def test_list_notifications_filters_by_ministry(conn):
    create_notification(conn, 'other-ministry-1', 'X', '1', '2020-01-01', 'so-only',
                        NotificationFields(ministry_id=None))
    assert len(list_notifications(conn, ministry_id='power')) == 2
    assert len(list_notifications(conn)) == 3


def test_list_cross_references_by_source_and_target(conn):
    ref = create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    assert [r['ref_id'] for r in list_cross_references(conn, source_gazette_id='power-so-3520-2026')] == [ref['ref_id']]
    assert [r['ref_id'] for r in list_cross_references(conn, target_gazette_id='power-so-5852-2022')] == [ref['ref_id']]
    assert list_cross_references(conn, source_gazette_id='power-so-5852-2022') == []  # wrong direction


def test_get_lineage_both_directions(conn):
    create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    lineage = get_lineage(conn, 'power-so-5852-2022')
    assert lineage['pointed_at_by'][0]['source_gazette_id'] == 'power-so-3520-2026'
    assert lineage['points_at'] == []


# --- Update ---

def test_update_notification_rejects_unknown_column(conn):
    with pytest.raises(ValueError):
        update_notification(conn, 'power-so-5852-2022', pdf_bytes=b'not allowed')


def test_update_notification_missing_row(conn):
    with pytest.raises(NotFoundError):
        update_notification(conn, 'nope', subject='x')


def test_verify_cross_reference_is_the_human_confirms_step(conn):
    ref = create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    assert ref['verified_by'] is None
    confirmed = verify_cross_reference(conn, ref['ref_id'], verified_by='reviewer-a')
    assert confirmed['verified_by'] == 'reviewer-a'
    assert confirmed['verified_at'] is not None


# --- Delete: soft vs hard ---

def test_archive_hides_from_default_list_but_get_still_finds_it(conn):
    archive_notification(conn, 'power-so-5852-2022')
    assert [n['gazette_id'] for n in list_notifications(conn)] == ['power-so-3520-2026']
    assert get_notification(conn, 'power-so-5852-2022')['archived_at'] is not None
    assert get_notification(conn, 'power-so-5852-2022', include_archived=False) is None


def test_restore_undoes_archive(conn):
    archive_notification(conn, 'power-so-5852-2022')
    restore_notification(conn, 'power-so-5852-2022')
    assert get_notification(conn, 'power-so-5852-2022')['archived_at'] is None
    assert 'power-so-5852-2022' in [n['gazette_id'] for n in list_notifications(conn)]


def test_hard_delete_refuses_when_referenced(conn):
    create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    with pytest.raises(ReferencedError):
        hard_delete_notification(conn, 'power-so-5852-2022')
    assert get_notification(conn, 'power-so-5852-2022') is not None  # refused, not partially applied


def test_hard_delete_cascade_true_removes_the_edge_too(conn):
    ref = create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    hard_delete_notification(conn, 'power-so-5852-2022', cascade=True)
    assert get_notification(conn, 'power-so-5852-2022') is None
    assert get_cross_reference(conn, ref['ref_id']) is None


def test_hard_delete_notification_missing_row(conn):
    with pytest.raises(NotFoundError):
        hard_delete_notification(conn, 'nope')


def test_archive_and_restore_cross_reference(conn):
    ref = create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    archive_cross_reference(conn, ref['ref_id'])
    assert list_cross_references(conn, source_gazette_id='power-so-3520-2026') == []
    assert get_cross_reference(conn, ref['ref_id'])['archived_at'] is not None
    restore_cross_reference(conn, ref['ref_id'])
    assert len(list_cross_references(conn, source_gazette_id='power-so-3520-2026')) == 1


def test_hard_delete_cross_reference(conn):
    ref = create_cross_reference(conn, 'power-so-3520-2026', 'power-so-5852-2022', 'amends')
    hard_delete_cross_reference(conn, ref['ref_id'])
    assert get_cross_reference(conn, ref['ref_id']) is None
    with pytest.raises(NotFoundError):
        hard_delete_cross_reference(conn, ref['ref_id'])
