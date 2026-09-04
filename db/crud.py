"""
CRUD data-access layer for gazette_notification and cross_reference.

Replaces ad-hoc raw SQL (the seed_*.sql files, one-off sqlite3 CLI
invocations) with a small set of explicit functions — one place that knows
the schema, instead of every caller writing its own SQL and its own way of
getting it slightly wrong.

Storage principle, already true of the schema and unchanged by this module:
NEVER store a PDF's bytes here. `pdf_url` holds the egazette.gov.in path
(see ingest.egazette.gazette_id_to_pdf_url) — every gazette in this index is
a public government document, re-fetchable by ID at any time, so the
database and this repo only ever carry the path/URL and the extracted text,
never the binary. `create_notification` accepts `pdf_url` for exactly this
reason and has no `pdf_bytes` parameter at all.

Delete has two real modes, not one:
  - archive_* / restore_* — soft delete. Sets/clears `archived_at`; the row
    stays, everything referencing it stays valid, and it drops out of the
    default (include_archived=False) read functions. Use this for "this
    turned out to be wrong" (like the MoEFCC gazette-ID mismatch this
    project already hit once) — the mistake and its correction both stay
    on the record.
  - hard_delete_* — an actual SQL DELETE. Refuses by default if a
    notification still has cross_reference rows pointing at it (from
    either side), so a hard delete can't silently orphan an edge; pass
    `cascade=True` to delete those edges first, deliberately.

Every function takes an open `sqlite3.Connection` and does not commit for
you — call `conn.commit()` (or use the connection as a context manager)
once you're done with a batch of operations. row_factory is not enforced;
callers get `sqlite3.Row`-if-you-set-it, or tuples otherwise. Read functions
here always set `conn.row_factory = sqlite3.Row` on the connection they were
given, to return dicts consistently — this changes the connection's default
for later calls on the same connection too, matching normal sqlite3 usage.
"""
from __future__ import annotations

import sqlite3
from dataclasses import dataclass
from datetime import datetime, timezone


class NotFoundError(LookupError):
    """Raised by an Update/Delete/Read-one call when the row doesn't exist."""


class ConflictError(ValueError):
    """Raised by Create when the primary key (or unique constraint) already exists."""


class ReferencedError(ValueError):
    """Raised by hard_delete_notification when cross_reference rows still point
    at it and cascade=False."""


def _now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec='seconds')


def _row(conn: sqlite3.Connection) -> None:
    conn.row_factory = sqlite3.Row


def _as_dict(row: sqlite3.Row | None) -> dict | None:
    return dict(row) if row is not None else None


# --------------------------------------------------------------------------- #
# gazette_notification
# --------------------------------------------------------------------------- #

@dataclass
class NotificationFields:
    """Optional fields for create_notification / update_notification. Required
    fields (gazette_id, series, number, publish_date, numbering_form) are
    passed as positional/keyword args to create_notification directly, not
    through this class, so a caller can't forget one — Python will refuse
    the call outright rather than silently defaulting it."""
    year: int | None = None
    gsr_or_so: str | None = None
    subject: str | None = None
    ministry_id: str | None = None
    instrument_id: str | None = None
    thread_id: str | None = None
    pdf_url: str | None = None
    ocr_status: str = 'not_needed'


def create_notification(
    conn: sqlite3.Connection, gazette_id: str, series: str, number: str,
    publish_date: str, numbering_form: str, fields: NotificationFields | None = None,
) -> dict:
    """Insert a new notification. Raises ConflictError if gazette_id exists —
    unlike the seed files' INSERT OR IGNORE, Create is not silent about a
    collision; callers that genuinely want upsert semantics should read
    first (get_notification) and decide."""
    f = fields or NotificationFields()
    _row(conn)
    if conn.execute('SELECT 1 FROM gazette_notification WHERE gazette_id = ?', (gazette_id,)).fetchone():
        raise ConflictError(f'gazette_notification {gazette_id!r} already exists')
    conn.execute(
        """INSERT INTO gazette_notification
           (gazette_id, series, number, year, numbering_form, publish_date, gsr_or_so,
            subject, ministry_id, instrument_id, thread_id, pdf_url, ocr_status)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
        (gazette_id, series, number, f.year, numbering_form, publish_date, f.gsr_or_so,
         f.subject, f.ministry_id, f.instrument_id, f.thread_id, f.pdf_url, f.ocr_status),
    )
    return get_notification(conn, gazette_id)


def get_notification(conn: sqlite3.Connection, gazette_id: str, include_archived: bool = True) -> dict | None:
    """Single-row read. include_archived defaults True here (unlike list_notifications)
    — asking for a specific known ID should find it even if archived; only the
    *listing* functions hide archived rows by default."""
    _row(conn)
    row = conn.execute('SELECT * FROM gazette_notification WHERE gazette_id = ?', (gazette_id,)).fetchone()
    d = _as_dict(row)
    if d and not include_archived and d['archived_at'] is not None:
        return None
    return d


def list_notifications(
    conn: sqlite3.Connection, ministry_id: str | None = None,
    thread_id: str | None = None, include_archived: bool = False,
) -> list[dict]:
    _row(conn)
    where, params = [], []
    if ministry_id is not None:
        where.append('ministry_id = ?'); params.append(ministry_id)
    if thread_id is not None:
        where.append('thread_id = ?'); params.append(thread_id)
    if not include_archived:
        where.append('archived_at IS NULL')
    sql = 'SELECT * FROM gazette_notification'
    if where:
        sql += ' WHERE ' + ' AND '.join(where)
    sql += ' ORDER BY publish_date'
    return [dict(r) for r in conn.execute(sql, params).fetchall()]


def update_notification(conn: sqlite3.Connection, gazette_id: str, **fields) -> dict:
    """Update named columns only (no bulk **kwargs-as-SQL injection risk —
    the column allowlist below is exhaustive and fixed). Raises NotFoundError
    if gazette_id doesn't exist, ValueError for an unknown/disallowed field."""
    allowed = {'series', 'number', 'year', 'numbering_form', 'publish_date', 'gsr_or_so',
               'subject', 'ministry_id', 'instrument_id', 'thread_id', 'pdf_url', 'ocr_status'}
    bad = set(fields) - allowed
    if bad:
        raise ValueError(f'not an updatable column: {sorted(bad)}')
    if not fields:
        return get_notification(conn, gazette_id) or (_ for _ in ()).throw(NotFoundError(gazette_id))
    if get_notification(conn, gazette_id) is None:
        raise NotFoundError(f'gazette_notification {gazette_id!r} not found')
    set_clause = ', '.join(f'{k} = ?' for k in fields)
    conn.execute(f'UPDATE gazette_notification SET {set_clause} WHERE gazette_id = ?',
                 (*fields.values(), gazette_id))
    return get_notification(conn, gazette_id)


def archive_notification(conn: sqlite3.Connection, gazette_id: str) -> dict:
    if get_notification(conn, gazette_id) is None:
        raise NotFoundError(f'gazette_notification {gazette_id!r} not found')
    conn.execute('UPDATE gazette_notification SET archived_at = ? WHERE gazette_id = ?', (_now(), gazette_id))
    return get_notification(conn, gazette_id)


def restore_notification(conn: sqlite3.Connection, gazette_id: str) -> dict:
    if get_notification(conn, gazette_id) is None:
        raise NotFoundError(f'gazette_notification {gazette_id!r} not found')
    conn.execute('UPDATE gazette_notification SET archived_at = NULL WHERE gazette_id = ?', (gazette_id,))
    return get_notification(conn, gazette_id)


def hard_delete_notification(conn: sqlite3.Connection, gazette_id: str, cascade: bool = False) -> None:
    """Permanent DELETE. Refuses if cross_reference rows still point at this
    notification (from either side) unless cascade=True deletes those edges
    first. Prefer archive_notification for anything that isn't test data or
    a genuine duplicate row — an archived mistake keeps its correction on
    the record; a hard-deleted one doesn't."""
    if get_notification(conn, gazette_id) is None:
        raise NotFoundError(f'gazette_notification {gazette_id!r} not found')
    refs = conn.execute(
        'SELECT ref_id FROM cross_reference WHERE source_gazette_id = ? OR target_gazette_id = ?',
        (gazette_id, gazette_id),
    ).fetchall()
    if refs and not cascade:
        raise ReferencedError(
            f'{gazette_id!r} is referenced by {len(refs)} cross_reference row(s); '
            'pass cascade=True to delete them first, or archive_notification instead')
    if refs:
        conn.execute('DELETE FROM cross_reference WHERE source_gazette_id = ? OR target_gazette_id = ?',
                     (gazette_id, gazette_id))
    conn.execute('DELETE FROM gazette_notification WHERE gazette_id = ?', (gazette_id,))


# --------------------------------------------------------------------------- #
# cross_reference
# --------------------------------------------------------------------------- #

def create_cross_reference(
    conn: sqlite3.Connection, source_gazette_id: str, target_gazette_id: str,
    relation_type: str, verified_by: str | None = None, verified_at: str | None = None,
) -> dict:
    """Both endpoints must already exist (enforced by the schema's FK
    constraints — PRAGMA foreign_keys = ON must be set on this connection,
    as db/schema.sql does at load time). Raises ConflictError on the same
    (source, target, relation_type) triple twice."""
    _row(conn)
    if get_notification(conn, source_gazette_id) is None:
        raise NotFoundError(f'source {source_gazette_id!r} not found')
    if get_notification(conn, target_gazette_id) is None:
        raise NotFoundError(f'target {target_gazette_id!r} not found')
    existing = conn.execute(
        """SELECT ref_id FROM cross_reference
           WHERE source_gazette_id = ? AND target_gazette_id = ? AND relation_type = ?""",
        (source_gazette_id, target_gazette_id, relation_type),
    ).fetchone()
    if existing:
        raise ConflictError(f'cross_reference already exists: ref_id={existing["ref_id"]}')
    cur = conn.execute(
        """INSERT INTO cross_reference (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at)
           VALUES (?, ?, ?, ?, ?)""",
        (source_gazette_id, target_gazette_id, relation_type, verified_by, verified_at),
    )
    return get_cross_reference(conn, cur.lastrowid)


def get_cross_reference(conn: sqlite3.Connection, ref_id: int) -> dict | None:
    _row(conn)
    return _as_dict(conn.execute('SELECT * FROM cross_reference WHERE ref_id = ?', (ref_id,)).fetchone())


def list_cross_references(
    conn: sqlite3.Connection, source_gazette_id: str | None = None,
    target_gazette_id: str | None = None, unverified_only: bool = False,
    include_archived: bool = False,
) -> list[dict]:
    _row(conn)
    where, params = [], []
    if source_gazette_id is not None:
        where.append('source_gazette_id = ?'); params.append(source_gazette_id)
    if target_gazette_id is not None:
        where.append('target_gazette_id = ?'); params.append(target_gazette_id)
    if unverified_only:
        where.append('verified_by IS NULL')
    if not include_archived:
        where.append('archived_at IS NULL')
    sql = 'SELECT * FROM cross_reference'
    if where:
        sql += ' WHERE ' + ' AND '.join(where)
    sql += ' ORDER BY ref_id'
    return [dict(r) for r in conn.execute(sql, params).fetchall()]


def verify_cross_reference(conn: sqlite3.Connection, ref_id: int, verified_by: str,
                           verified_at: str | None = None) -> dict:
    """The 'a person confirms a machine-proposed link' operation — machines
    propose (create_cross_reference with verified_by=None), people confirm
    (this). Used by verify.review_queue instead of that module's own SQL."""
    if get_cross_reference(conn, ref_id) is None:
        raise NotFoundError(f'cross_reference ref_id={ref_id} not found')
    conn.execute('UPDATE cross_reference SET verified_by = ?, verified_at = ? WHERE ref_id = ?',
                 (verified_by, verified_at or _now(), ref_id))
    return get_cross_reference(conn, ref_id)


def archive_cross_reference(conn: sqlite3.Connection, ref_id: int) -> dict:
    if get_cross_reference(conn, ref_id) is None:
        raise NotFoundError(f'cross_reference ref_id={ref_id} not found')
    conn.execute('UPDATE cross_reference SET archived_at = ? WHERE ref_id = ?', (_now(), ref_id))
    return get_cross_reference(conn, ref_id)


def restore_cross_reference(conn: sqlite3.Connection, ref_id: int) -> dict:
    if get_cross_reference(conn, ref_id) is None:
        raise NotFoundError(f'cross_reference ref_id={ref_id} not found')
    conn.execute('UPDATE cross_reference SET archived_at = NULL WHERE ref_id = ?', (ref_id,))
    return get_cross_reference(conn, ref_id)


def hard_delete_cross_reference(conn: sqlite3.Connection, ref_id: int) -> None:
    if get_cross_reference(conn, ref_id) is None:
        raise NotFoundError(f'cross_reference ref_id={ref_id} not found')
    conn.execute('DELETE FROM cross_reference WHERE ref_id = ?', (ref_id,))


# --------------------------------------------------------------------------- #
# Read: lineage — the actual point of this whole project
# --------------------------------------------------------------------------- #

def get_lineage(conn: sqlite3.Connection, gazette_id: str) -> dict:
    """Everything this notification points at (what it amends/corrects/
    supersedes/rescinds) and everything that points at it (what later
    amended/corrected/superseded/rescinded IT). One hop each way, not a
    transitive closure — chaining calls is the caller's job."""
    if get_notification(conn, gazette_id, include_archived=True) is None:
        raise NotFoundError(f'gazette_notification {gazette_id!r} not found')
    return {
        'gazette_id': gazette_id,
        'points_at': list_cross_references(conn, source_gazette_id=gazette_id),
        'pointed_at_by': list_cross_references(conn, target_gazette_id=gazette_id),
    }
