"""
Regenerate a compendium-style page from the database, in the same visual
style as the hand-authored artifacts this pipeline replaces.

    python3 -m render.pages --db gazette.db --notification "45/2025-Customs"

The output is the historical-lineage + current-chain HTML body (no <title>/
<style> wrapper is repeated here beyond what's needed for a standalone
preview) — meant to be diffed against, or dropped into, the existing
Artifact-published compendium page.

Pass --translate-widget to prepend Google's own translate.google.com page
widget, so anyone viewing the rendered page can read it in their own
language without this project maintaining any translations itself. This
is for the *rendered page* (a human browsing it); render/translate.py is
for the *data* (a single record's fields, translated on request). Off by
default so the plain HTML fragment still diffs cleanly against the
existing published compendium page.
"""
from __future__ import annotations

import argparse
import sqlite3
import sys
from datetime import date


def _fetch_notification(conn: sqlite3.Connection, series: str, number: str) -> sqlite3.Row:
    conn.row_factory = sqlite3.Row
    row = conn.execute(
        'SELECT * FROM gazette_notification WHERE series = ? AND number = ?',
        (series, number),
    ).fetchone()
    if row is None:
        raise SystemExit(f'no notification found for {series} {number}')
    return row


def _absorbed_history(conn: sqlite3.Connection, gazette_id: str) -> list[sqlite3.Row]:
    conn.row_factory = sqlite3.Row
    return conn.execute(
        """
        SELECT n.* FROM cross_reference r
        JOIN gazette_notification n ON n.gazette_id = r.target_gazette_id
        WHERE r.source_gazette_id = ? AND r.relation_type = 'supersedes'
        ORDER BY n.publish_date ASC
        """,
        (gazette_id,),
    ).fetchall()


def _amendments(conn: sqlite3.Connection, gazette_id: str) -> list[sqlite3.Row]:
    conn.row_factory = sqlite3.Row
    return conn.execute(
        """
        SELECT n.* FROM cross_reference r
        JOIN gazette_notification n ON n.gazette_id = r.source_gazette_id
        WHERE r.target_gazette_id = ? AND r.relation_type = 'amends'
        ORDER BY n.publish_date ASC
        """,
        (gazette_id,),
    ).fetchall()


def _row_html(row: sqlite3.Row, as_listed: str | None = None) -> str:
    d = date.fromisoformat(row['publish_date']).strftime('%-d %b %Y')
    gsr = row['gsr_or_so'] or '<span style="opacity:.6">unconfirmed</span>'
    order_cell = f'<td class="order">{as_listed}</td>' if as_listed else ''
    return (
        '<tr>' + order_cell +
        f'<td>No. {row["number"]}&#8209;{row["series"]}</td>'
        f'<td class="num">{d}</td>'
        f'<td class="num">{gsr}</td>'
        '</tr>'
    )


# Google's own hosted widget -- no API key, no translation this project
# maintains itself. `<div id="google_translate_element">` is the mount
# point; the script below initializes it against every language Google
# Translate supports (a strict superset of render.translate's priority
# list, which exists for translating the *data*, not the *page*).
TRANSLATE_WIDGET = '''<div id="google_translate_element" style="margin-bottom:1em"></div>
<script type="text/javascript">
function googleTranslateElementInit() {
  new google.translate.TranslateElement({pageLanguage: 'en'}, 'google_translate_element');
}
</script>
<script type="text/javascript" src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
'''


def render(conn: sqlite3.Connection, series: str, number: str, translate_widget: bool = False) -> str:
    current = _fetch_notification(conn, series, number)
    history = _absorbed_history(conn, current['gazette_id'])
    amendments = _amendments(conn, current['gazette_id'])

    pre1994 = [r for r in history if r['numbering_form'] != '4-digit-year']
    post1994 = [r for r in history if r['numbering_form'] == '4-digit-year']

    parts = []
    if translate_widget:
        parts.append(TRANSLATE_WIDGET)
    parts.append(f'<h2>No. {current["number"]}&#8209;{current["series"]} '
                 f'&mdash; generated from the database</h2>')

    if amendments:
        parts.append('<h3>Current chain</h3><table><tbody>')
        parts.append(_row_html(current))
        for a in amendments:
            parts.append(_row_html(a))
        parts.append('</tbody></table>')

    if pre1994:
        parts.append(f'<h3>Absorbed history &middot; before 4-digit-year numbering '
                      f'({len(pre1994)} notifications)</h3><table><tbody>')
        for r in pre1994:
            parts.append(_row_html(r))
        parts.append('</tbody></table>')

    if post1994:
        parts.append(f'<h3>Absorbed history &middot; 4-digit-year numbering '
                      f'({len(post1994)} notifications)</h3><table><tbody>')
        for r in post1994:
            parts.append(_row_html(r))
        parts.append('</tbody></table>')

    return '\n'.join(parts)


def main() -> int:
    ap = argparse.ArgumentParser(description='Regenerate a compendium page from the database')
    ap.add_argument('--db', required=True)
    ap.add_argument('--notification', required=True, help='e.g. "45/2025-Customs"')
    ap.add_argument('--out')
    ap.add_argument('--translate-widget', action='store_true',
                     help="prepend Google's translate.google.com page widget")
    args = ap.parse_args()

    number, series = args.notification.split('-', 1)
    conn = sqlite3.connect(args.db)
    try:
        html = render(conn, series, number, translate_widget=args.translate_widget)
    finally:
        conn.close()

    if args.out:
        with open(args.out, 'w') as f:
            f.write(html)
    else:
        print(html)
    return 0


if __name__ == '__main__':
    sys.exit(main())
