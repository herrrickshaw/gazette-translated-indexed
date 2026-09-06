"""
Query egazette.gov.in's own search — not the third-party gazettetracker.com
aggregator `ingest/freshness_check.py` otherwise relies on — for newly
published central gazette notifications.

    python3 -m ingest.egazette_search --list-ministries | grep -i steel
    python3 -m ingest.egazette_search --ministry-value 34 --since 2026-01-01
    python3 -m ingest.egazette_search --from 2026-09-01 --to 2026-09-01

Why this exists: `docs/DATA_PIPELINE.md`'s Gap 1 — freshness detection today
depends entirely on gazettetracker.com, a third-party aggregator. This client
talks to the official source directly, so a gap in the aggregator's coverage
becomes checkable instead of invisible. It only reads and reports; nothing
here writes to the database.

How the site actually works (reverse-engineered live, Sep 2026 — there is no
public API or documentation): egazette.gov.in is classic ASP.NET WebForms
with *cookieless* session state — the session id is embedded in the URL path
itself as `(S(...))`, not a cookie (confirmed live: the cookie jar stays
empty across a whole session). Every page carries `__VIEWSTATE` /
`__VIEWSTATEGENERATOR` / `__EVENTVALIDATION` hidden fields that must be
replayed verbatim on the next POST, and the site's menu (`SearchMenu.aspx`)
branches into several distinct search modes depending on which submit
button is clicked (Search by Ministry, by Publish Date, by Gazette ID, ...).
This module drives two of them:

  - **Search by Ministry** (`SearchMinistry.aspx`, month/year granularity):
    its `ddlMinistry` dropdown alone has 607 options — every ministry name
    the site has ever used, including predecessor names (e.g. "Ministry of
    Steel" and "Ministry of Steel and Mines" are separate entries) —
    `list_ministries()` scrapes it live rather than hardcoding a copy that
    would silently go stale.
  - **Search by Publish Date** (`SearchPublishDate.aspx`, a from/to date
    range in `DD-Mon-YYYY` format): returns every central ministry's
    gazettes in the window, unfiltered — useful for a quick cross-check
    against gazettetracker.com, not for exhaustive per-ministry coverage
    (see the pagination limitation below).

TLS: same finding as `ingest.egazette` — Python's `ssl` module cannot verify
this host's certificate chain even against the OS trust store (confirmed:
both certifi's bundle and `/etc/ssl/cert.pem` fail identically with
"unable to get local issuer certificate"), while system curl succeeds.
Every request in this module shells out to curl, carrying a per-call
temporary Netscape cookie jar for session continuity across the
GET -> POST -> POST sequence a single search requires. Never disables TLS
verification — curl's own OS-trust-store handling is what makes this work.

Known limitation — pagination: `SearchPublishDate.aspx` returns 15 rows per
page behind a GridView `__doPostBack` postback that could not be gotten past
a server-side 500 (three independent field-set variations tried live, no
error detail exposed remotely, since the site's custom errors are off for
remote clients). A single day's central-government-wide gazette volume
regularly exceeds 15 (confirmed live: several single days in a row each hit
the 15-row cap), so `search_by_publish_date()` is a single-page spot-check
only — it does not claim to be exhaustive over a wide window, and never
silently pretends otherwise (see `possibly_truncated` below).
`search_by_ministry_since()` sidesteps the problem entirely by querying one
ministry at a time, one month at a time: a single already-modeled ministry
issuing more than 15 notifications in one month has never been observed in
this project's coverage (Ministry of Power's depth pass, the deepest pass
run so far, found 34 across its *entire* indexed history) — so this is the
function this project's freshness checks should actually use. Any month
that does return exactly 15 rows is flagged `possibly_truncated=True`
rather than silently accepted as complete.

Politeness: one request at a time, a fixed delay between requests, and a
descriptive User-Agent, matching `ingest.egazette`. There is no documented
rate limit; treat the site gently anyway.
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
import tempfile
import time
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from urllib.parse import urljoin

_BASE_URL = 'https://egazette.gov.in/'
_USER_AGENT = 'gazette-translated-indexed/0.1 (+https://github.com/herrrickshaw/gazette-translated-indexed)'
DEFAULT_DELAY_S = 1.0
PAGE_SIZE = 15  # SearchPublishDate.aspx / SearchMinistry.aspx's fixed GridView page size

_HIDDEN_RE = re.compile(
    r'<input[^>]+type=["\']hidden["\'][^>]*name=["\'](?P<name>[^"\']+)["\'][^>]*value=["\'](?P<value>[^"\']*)["\']',
    re.IGNORECASE,
)
_HIDDEN_RE_REORDERED = re.compile(
    r'<input[^>]+name=["\'](?P<name>[^"\']+)["\'][^>]*type=["\']hidden["\'][^>]*value=["\'](?P<value>[^"\']*)["\']',
    re.IGNORECASE,
)
_MINISTRY_SELECT_RE = re.compile(r'<select name="ddlMinistry"[^>]*>(.*?)</select>', re.IGNORECASE | re.DOTALL)
_OPTION_RE = re.compile(r'<option[^>]*value="(?P<value>[^"]*)"[^>]*>(?P<text>[^<]*)</option>')
_ROW_FIELD_RE = re.compile(r'lbl_(?P<field>\w+)_(?P<idx>\d+)"><font[^>]*>(?P<value>[^<]*)</font>')
_TITLE_RE = re.compile(r'<title>\s*([^<]*?)\s*</title>')

_ROW_FIELDS = ('Ministry', 'Department', 'Office', 'Subject', 'Category', 'PartSection',
               'IssueDate', 'PublishDate', 'UGID')


class EGazetteSearchError(RuntimeError):
    """Raised when the site returns something this client can't make sense
    of (an error page, an unexpected redirect, no search form found)."""


@dataclass
class GazetteSearchResult:
    gazette_id: str
    ministry: str
    department: str | None
    office: str | None
    subject: str
    category: str | None
    part_section: str | None
    issue_date: date | None
    publish_date: date | None


def _egz_date(d: date) -> str:
    """DD-Mon-YYYY, the exact format SearchPublishDate.aspx's txtDateFrom/
    txtDateTo and SearchMinistry.aspx's rendered dates use."""
    return d.strftime('%d-%b-%Y')


def _strptime_egz(s: str) -> date:
    from datetime import datetime
    return datetime.strptime(s.strip(), '%d-%b-%Y').date()


class _Session:
    """One egazette.gov.in browsing session: a temp cookie jar plus curl.

    A fresh `_Session` per logical search — this site's session/postback
    state turned out NOT to tolerate being resumed across unrelated
    navigations (confirmed live: reusing a jar across two different search
    flows silently reset form state, then a stale object-reference `id=`
    query param on a later request produced a 500). Isolating one jar per
    search sidesteps that entirely, at the cost of a few extra requests.
    """

    def __init__(self, timeout: float = 30.0):
        self._jar = tempfile.NamedTemporaryFile(prefix='egazette_jar_', suffix='.txt', delete=False).name
        self._timeout = timeout

    def close(self) -> None:
        Path(self._jar).unlink(missing_ok=True)

    def __enter__(self) -> '_Session':
        return self

    def __exit__(self, *exc) -> None:
        self.close()

    def _curl(self, url: str, referer: str | None, data: list[tuple[str, str]] | None) -> tuple[int, str, str]:
        cmd = ['curl', '-sS', '-L', '-c', self._jar, '-b', self._jar, '-A', _USER_AGENT,
               '--max-time', str(int(self._timeout)),
               '-w', '\n__STATUS__%{http_code}__URL__%{url_effective}']
        if referer:
            cmd += ['-e', referer]
        for k, v in data or []:
            cmd += ['--data-urlencode', f'{k}={v}']
        cmd.append(url)
        proc = subprocess.run(cmd, capture_output=True, text=True, timeout=self._timeout + 5)
        if proc.returncode != 0:
            raise EGazetteSearchError(f'curl failed for {url}: {proc.stderr.strip()}')
        m = re.search(r'__STATUS__(\d+)__URL__(\S+)$', proc.stdout, re.DOTALL)
        if not m:
            raise EGazetteSearchError(f'curl produced no status marker for {url} (empty/killed response?)')
        body = proc.stdout[: m.start()]
        return int(m.group(1)), m.group(2), body

    def get(self, url: str, referer: str | None = None) -> tuple[int, str, str]:
        return self._curl(url, referer, None)

    def post(self, url: str, data: list[tuple[str, str]], referer: str | None = None) -> tuple[int, str, str]:
        return self._curl(url, referer, data)


def _extract_hidden(html: str) -> dict[str, str]:
    fields: dict[str, str] = {}
    for rx in (_HIDDEN_RE, _HIDDEN_RE_REORDERED):
        for m in rx.finditer(html):
            fields[m.group('name')] = m.group('value')
    return fields


def _check_not_error_page(status: int, body: str, context: str) -> None:
    title = _TITLE_RE.search(body)
    title_text = title.group(1) if title else ''
    if status >= 400 or 'error' in title_text.lower():
        raise EGazetteSearchError(
            f'{context}: egazette.gov.in returned status {status}'
            + (f' ({title_text!r})' if title_text else '')
        )


def _rows_from_results_page(html: str) -> list[GazetteSearchResult]:
    by_idx: dict[str, dict[str, str]] = {}
    for m in _ROW_FIELD_RE.finditer(html):
        by_idx.setdefault(m.group('idx'), {})[m.group('field')] = m.group('value').strip()
    results = []
    for idx in sorted(by_idx, key=int):
        row = by_idx[idx]
        if 'UGID' not in row:
            continue
        results.append(GazetteSearchResult(
            gazette_id=row['UGID'],
            ministry=row.get('Ministry', ''),
            department=row.get('Department') or None,
            office=row.get('Office') or None,
            subject=row.get('Subject', ''),
            category=row.get('Category') or None,
            part_section=row.get('PartSection') or None,
            issue_date=_strptime_egz(row['IssueDate']) if row.get('IssueDate') else None,
            publish_date=_strptime_egz(row['PublishDate']) if row.get('PublishDate') else None,
        ))
    return results


def _open_search_menu(session: _Session) -> tuple[str, dict[str, str]]:
    status, url, body = session.get(_BASE_URL)
    _check_not_error_page(status, body, 'fetching home page')
    status, url, body = session.get(urljoin(url, 'SearchMenu.aspx'), referer=url)
    _check_not_error_page(status, body, 'fetching SearchMenu.aspx')
    return url, _extract_hidden(body)


def list_ministries(*, timeout: float = 30.0) -> dict[str, str]:
    """Scrape the live `ddlMinistry` dropdown from SearchMinistry.aspx:
    ministry/organization display text -> the numeric option value
    `search_by_ministry()` expects. 607 entries as of Sep 2026, including
    historical predecessor names — deliberately not cached to a static
    file, since the whole point is that this is the site's own current
    list, not a copy this project would have to remember to refresh."""
    with _Session(timeout=timeout) as session:
        url, fields = _open_search_menu(session)
        data = list(fields.items()) + [('btnMinistry', 'Search by Ministry')]
        status, url2, body = session.post(url, data, referer=url)
        _check_not_error_page(status, body, 'opening Search by Ministry')
        m = _MINISTRY_SELECT_RE.search(body)
        if not m:
            raise EGazetteSearchError('ddlMinistry dropdown not found on SearchMinistry.aspx')
        return {text.strip(): value for value, text in _OPTION_RE.findall(m.group(1))
                if value and text.strip() != 'Select Ministry'}


def search_by_ministry(ministry_value: str, month: int, year: int, *, timeout: float = 30.0) -> list[GazetteSearchResult]:
    """One ministry (by its `ddlMinistry` option value — see
    `list_ministries()`), one calendar month. Month/year granularity is
    the site's own coarsest search mode, and coarse is fine here: it keeps
    a single query's result count well under the 15-row page limit for any
    already-modeled ministry (see the module docstring)."""
    with _Session(timeout=timeout) as session:
        url, fields = _open_search_menu(session)
        data = list(fields.items()) + [('btnMinistry', 'Search by Ministry')]
        status, url2, body = session.post(url, data, referer=url)
        _check_not_error_page(status, body, 'opening Search by Ministry')

        fields2 = _extract_hidden(body)
        data2 = list(fields2.items()) + [
            ('ddlMinistry', ministry_value),
            ('rdb_Option', '0'),  # "Month / Year Wise" (the site's other mode, "Date Wise", is untested here)
            ('ddlmonth', str(month)),
            ('ddlyear', str(year)),
            ('ImgSubmitDetails.x', '10'),
            ('ImgSubmitDetails.y', '10'),
        ]
        status, url3, body3 = session.post(url2, data2, referer=url2)
        _check_not_error_page(status, body3, f'searching ministry={ministry_value} {month}/{year}')
        return _rows_from_results_page(body3)


def _iter_months(since: date, until: date):
    y, m = since.year, since.month
    while (y, m) <= (until.year, until.month):
        yield y, m
        m += 1
        if m > 12:
            m, y = 1, y + 1


def search_by_ministry_since(
    ministry_value: str, since: date, until: date | None = None, *,
    delay_s: float = DEFAULT_DELAY_S, timeout: float = 30.0,
) -> tuple[list[GazetteSearchResult], list[tuple[int, int]]]:
    """Every result for one ministry from `since` through `until`
    (default: today), inclusive, queried one month at a time and filtered
    down to `publish_date >= since` / `<= until` (month granularity
    naturally over-fetches at the edges). Returns `(results,
    possibly_truncated_months)` — the second list names any (year, month)
    that came back with exactly `PAGE_SIZE` rows, i.e. might have more that
    this client can't see (see the module docstring's pagination note)."""
    until = until or date.today()
    seen: dict[str, GazetteSearchResult] = {}
    truncated: list[tuple[int, int]] = []
    months = list(_iter_months(since, until))
    for i, (y, m) in enumerate(months):
        rows = search_by_ministry(ministry_value, m, y, timeout=timeout)
        if len(rows) == PAGE_SIZE:
            truncated.append((y, m))
        for r in rows:
            if r.publish_date and since <= r.publish_date <= until:
                seen[r.gazette_id] = r
        if i < len(months) - 1:
            time.sleep(delay_s)
    return sorted(seen.values(), key=lambda r: r.publish_date or date.min), truncated


def search_by_publish_date(date_from: date, date_to: date, *, timeout: float = 30.0) -> list[GazetteSearchResult]:
    """All central ministries, one date range, ONE PAGE ONLY (see the
    module docstring's pagination limitation — this is a spot-check, not
    an exhaustive scan of a busy multi-day window)."""
    with _Session(timeout=timeout) as session:
        url, fields = _open_search_menu(session)
        data = list(fields.items()) + [('btnPublish', 'Search by Publish Date')]
        status, url2, body = session.post(url, data, referer=url)
        _check_not_error_page(status, body, 'opening Search by Publish Date')

        fields2 = _extract_hidden(body)
        data2 = list(fields2.items()) + [
            ('txtDateFrom', _egz_date(date_from)),
            ('txtDateTo', _egz_date(date_to)),
            ('ImgSubmit.x', '10'),
            ('ImgSubmit.y', '10'),
        ]
        status, url3, body3 = session.post(url2, data2, referer=url2)
        _check_not_error_page(status, body3, f'searching publish date {date_from}..{date_to}')
        return _rows_from_results_page(body3)


def _build_parser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--list-ministries', action='store_true',
                     help='print every "display text\\tvalue" pair from the live ddlMinistry dropdown')
    ap.add_argument('--ministry-value', help='ddlMinistry option value (see --list-ministries)')
    ap.add_argument('--since', help='YYYY-MM-DD, used with --ministry-value (search_by_ministry_since)')
    ap.add_argument('--until', help='YYYY-MM-DD, default today')
    ap.add_argument('--from', dest='date_from', help='YYYY-MM-DD, used without --ministry-value (search_by_publish_date)')
    ap.add_argument('--to', dest='date_to', help='YYYY-MM-DD')
    return ap


def main() -> int:
    from datetime import datetime
    args = _build_parser().parse_args()

    if args.list_ministries:
        for text, value in sorted(list_ministries().items()):
            print(f'{text}\t{value}')
        return 0

    if args.ministry_value:
        if not args.since:
            print('--since is required with --ministry-value', file=sys.stderr)
            return 2
        since = datetime.strptime(args.since, '%Y-%m-%d').date()
        until = datetime.strptime(args.until, '%Y-%m-%d').date() if args.until else None
        results, truncated = search_by_ministry_since(args.ministry_value, since, until)
        for r in results:
            print(f'{r.gazette_id}\t{r.publish_date}\t{r.ministry}\t{r.subject[:80]}')
        if truncated:
            print(f'WARNING: possibly-truncated months (hit the {PAGE_SIZE}-row page limit): {truncated}',
                  file=sys.stderr)
        return 0

    if args.date_from and args.date_to:
        date_from = datetime.strptime(args.date_from, '%Y-%m-%d').date()
        date_to = datetime.strptime(args.date_to, '%Y-%m-%d').date()
        results = search_by_publish_date(date_from, date_to)
        for r in results:
            print(f'{r.gazette_id}\t{r.publish_date}\t{r.ministry}\t{r.subject[:80]}')
        if len(results) == PAGE_SIZE:
            print(f'WARNING: exactly {PAGE_SIZE} rows returned — this window may be truncated '
                  f'(see the module docstring\'s pagination limitation)', file=sys.stderr)
        return 0

    print('Nothing to do — pass --list-ministries, --ministry-value + --since, or --from + --to', file=sys.stderr)
    return 2


if __name__ == '__main__':
    sys.exit(main())
