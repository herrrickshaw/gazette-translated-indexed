"""
Tests for ingest.freshness_check's gazettetracker.com listing parser and
paging. No network: the fixture is a real excerpt (three consecutive cards,
SVG icons stripped) captured live from
https://gazettetracker.com/ministry/ministry-of-commerce-and-industry?page=1
on 2026-11-09, after the site moved to its feed-card markup -- which the
previous browse-item regex silently matched zero times for every ministry.
"""
from datetime import date
from unittest.mock import patch

from ingest import freshness_check as fc
from ingest.freshness_check import TrackerItem, fetch_listing_since, parse_listing

# Real markup excerpt (Ministry of Commerce and Industry listing, page 1, 2026-11-09).
FEED_CARDS_FIXTURE = """
<div class="feed-card" data-gazette-id="CG-DL-E-23102026-277356">
        <div class="feed-card-header">
            <span class="feed-ministry">Ministry of Commerce and Industry</span>
            <div class="feed-header-right">
                <button class="feed-share-btn"
                        data-gazette-id="CG-DL-E-23102026-277356"
                        data-subject="Publication of the notification of Amendment Nomination of Members to SEEPZ SEZ Authority"
                        data-ministry="Ministry of Commerce and Industry"
                        data-date="23 Oct 2026"
                        title="Share this gazette">
                </button>
            </div>
        </div>
        <a href="https://gazettetracker.com/g/CG-DL-E-23102026-277356" class="feed-subject">Publication of the notification of Amendment Nomination of Members to SEEPZ SEZ Authority</a>
        <div class="feed-purpose">The Central Government amends notification S.O.3067(E) dated 29.07.2024 to include new members in the SEEPZ SEZ Authority.</div>
        <div class="feed-actions">
            <a href="/auth/login?message=Log+in+to+view+full+text+and+summaries" class="feed-gated-link" title="Log in to view full text">
                <span class="lock-icon">🔒</span> Full Text
            </a>
            <a href="/auth/login?message=Log+in+to+view+full+text+and+summaries" class="feed-gated-link" title="Log in to view summary">
                <span class="lock-icon">🔒</span> Summary
            </a>
            <a href="https://gazettetracker.com/pdf/CG-DL-E-23102026-277356.pdf" class="feed-download-btn" target="_blank" rel="noopener noreferrer">
                Download PDF
            </a>
            <span class="feed-gazette-id-inline">
                <span class="feed-gazette-id-label">Gazette ID:</span>
                <a href="https://gazettetracker.com/g/CG-DL-E-23102026-277356" class="feed-gazette-id">CG-DL-E-23102026-277356</a>
            </span>
        </div>
    </div>
    <div class="feed-card" data-gazette-id="CG-DL-E-23102026-277357">
        <div class="feed-card-header">
            <span class="feed-ministry">Ministry of Commerce and Industry</span>
            <div class="feed-header-right">
                <button class="feed-share-btn"
                        data-gazette-id="CG-DL-E-23102026-277357"
                        data-subject="Publication of the notification of Amendment Nomination of Members to Falta SEZ Authority"
                        data-ministry="Ministry of Commerce and Industry"
                        data-date="23 Oct 2026"
                        title="Share this gazette">
                </button>
            </div>
        </div>
        <a href="https://gazettetracker.com/g/CG-DL-E-23102026-277357" class="feed-subject">Publication of the notification of Amendment Nomination of Members to Falta SEZ Authority</a>
        <div class="feed-purpose">The Central Government makes an amendment to Notification S.O. 2067(E) dated 1st February 2021, concerning the Special Economic Zones Act, 2005.</div>
        <div class="feed-actions">
            <a href="/auth/login?message=Log+in+to+view+full+text+and+summaries" class="feed-gated-link" title="Log in to view full text">
                <span class="lock-icon">🔒</span> Full Text
            </a>
            <a href="/auth/login?message=Log+in+to+view+full+text+and+summaries" class="feed-gated-link" title="Log in to view summary">
                <span class="lock-icon">🔒</span> Summary
            </a>
            <a href="https://gazettetracker.com/pdf/CG-DL-E-23102026-277357.pdf" class="feed-download-btn" target="_blank" rel="noopener noreferrer">
                Download PDF
            </a>
            <span class="feed-gazette-id-inline">
                <span class="feed-gazette-id-label">Gazette ID:</span>
                <a href="https://gazettetracker.com/g/CG-DL-E-23102026-277357" class="feed-gazette-id">CG-DL-E-23102026-277357</a>
            </span>
        </div>
    </div>
        <div class="feed-date-separator">
            <span class="feed-date-label">Thursday, October 22, 2026</span>
        </div>
    <div class="feed-card" data-gazette-id="CG-DL-E-22102026-277355">
        <div class="feed-card-header">
            <span class="feed-ministry">Ministry of Commerce and Industry</span>
            <div class="feed-header-right">
                <button class="feed-share-btn"
                        data-gazette-id="CG-DL-E-22102026-277355"
                        data-subject="SSR investigation on imports of Natural Mica based Pearl Industrial Pigments excluding Cosmetic Grade from China PR"
                        data-ministry="Ministry of Commerce and Industry"
                        data-date="22 Oct 2026"
                        title="Share this gazette">
                </button>
            </div>
        </div>
        <a href="https://gazettetracker.com/g/CG-DL-E-22102026-277355" class="feed-subject">SSR investigation on imports of Natural Mica based Pearl Industrial Pigments excluding Cosmetic Grade from China PR</a>
        <div class="feed-purpose">This notification contains the final findings of the sunset review investigation recommending the continuation of anti-dumping duties on imports of &#34;Natural Mica based Pearl Industrial Pigments excluding Cosmetic Grade&#34; originating in or exported from China PR for a further period of five years.</div>
        <div class="feed-actions">
            <a href="/auth/login?message=Log+in+to+view+full+text+and+summaries" class="feed-gated-link" title="Log in to view full text">
                <span class="lock-icon">🔒</span> Full Text
            </a>
            <a href="/auth/login?message=Log+in+to+view+full+text+and+summaries" class="feed-gated-link" title="Log in to view summary">
                <span class="lock-icon">🔒</span> Summary
            </a>
            <a href="https://gazettetracker.com/pdf/CG-DL-E-22102026-277355.pdf" class="feed-download-btn" target="_blank" rel="noopener noreferrer">
                Download PDF
            </a>
            <span class="feed-gazette-id-inline">
                <span class="feed-gazette-id-label">Gazette ID:</span>
                <a href="https://gazettetracker.com/g/CG-DL-E-22102026-277355" class="feed-gazette-id">CG-DL-E-22102026-277355</a>
            </span>
        </div>
    </div>
    
"""


def test_parse_listing_reads_current_feed_card_markup():
    items = parse_listing(FEED_CARDS_FIXTURE)
    assert [i.gazette_id for i in items] == [
        "CG-DL-E-23102026-277356",
        "CG-DL-E-23102026-277357",
        "CG-DL-E-22102026-277355",
    ]
    falta = items[1]
    assert falta.date == date(2026, 10, 23)
    assert falta.url == "https://gazettetracker.com/g/CG-DL-E-23102026-277357"
    assert falta.title == ("Publication of the notification of Amendment Nomination of "
                           "Members to Falta SEZ Authority")
    assert items[0].title.endswith("SEEPZ SEZ Authority")
    assert items[2].date == date(2026, 10, 22)


def test_parse_listing_never_borrows_fields_from_the_next_card():
    # A card whose subject link is missing must be dropped, not paired with
    # the following card's subject.
    broken = FEED_CARDS_FIXTURE.replace('class="feed-subject"', 'class="feed-subject-x"', 1)
    ids = [i.gazette_id for i in parse_listing(broken)]
    assert len(ids) == 2
    assert all(i.title for i in parse_listing(broken))


def test_parse_listing_unescapes_entities():
    html_text = FEED_CARDS_FIXTURE.replace("Falta SEZ Authority</a>", "Falta SEZ &amp; Authority</a>")
    assert parse_listing(html_text)[1].title.endswith("Falta SEZ & Authority")


def test_parse_listing_falls_back_to_legacy_browse_markup():
    # Minimal sample of the pre-2026-11 shape BROWSE_ITEM_RE was written for.
    legacy = (
        '<time class="browse-item-date">05 Sep 2026</time> ... '
        '<a href="https://gazettetracker.com/g/CG-DL-E-05092026-276000">Some Amendment Rules, 2026</a>'
    )
    items = parse_listing(legacy)
    assert [(i.gazette_id, i.date, i.title) for i in items] == [
        ("CG-DL-E-05092026-276000", date(2026, 9, 5), "Some Amendment Rules, 2026")
    ]


def test_parse_listing_empty_page():
    assert parse_listing("<html><body>No gazettes</body></html>") == []


def _page(start_day: int, n: int, month: int = 10) -> list[TrackerItem]:
    return [TrackerItem(gazette_id=f"G-{month}-{start_day - k}", url="u", title="t",
                        date=date(2026, month, start_day - k)) for k in range(n)]


def test_fetch_listing_since_pages_back_to_the_high_water_mark():
    full = [TrackerItem(gazette_id=f"A{k}", url="u", title="t", date=date(2026, 10, 30)) for k in range(50)]
    older = [TrackerItem(gazette_id=f"B{k}", url="u", title="t", date=date(2026, 9, 1)) for k in range(50)]
    pages = {1: full, 2: older, 3: AssertionError("should not fetch page 3")}
    with patch.object(fc, "fetch_listing", side_effect=lambda slug, page: pages[page]):
        items, n = fetch_listing_since("slug", date(2026, 9, 15), delay_s=0)
    assert n == 2
    assert len(items) == 100


def test_fetch_listing_since_stops_on_short_page_and_max_pages():
    with patch.object(fc, "fetch_listing", return_value=_page(30, 7)) as m:
        _, n = fetch_listing_since("slug", date(2026, 1, 1), delay_s=0)
    assert n == 1 and m.call_count == 1
    full = [TrackerItem(gazette_id=f"A{k}", url="u", title="t", date=date(2026, 10, 30)) for k in range(50)]
    with patch.object(fc, "fetch_listing", return_value=full) as m:
        _, n = fetch_listing_since("slug", date(2026, 1, 1), max_pages=3, delay_s=0)
    assert n == 3 and m.call_count == 3


def test_check_ministry_flags_an_empty_tracker_parse(tmp_path):
    import sqlite3
    conn = sqlite3.connect(tmp_path / "t.db")
    conn.execute("CREATE TABLE gazette_notification (ministry_id TEXT, publish_date TEXT, archived_at TEXT)")
    conn.execute("INSERT INTO gazette_notification VALUES ('steel', '2026-10-01', NULL)")
    with patch.object(fc, "fetch_listing_since", return_value=([], 1)):
        result = fc.check_ministry(conn, "steel", do_extract=False, tracker_only=True)
    assert result["status"] == "ok"
    assert result["tracker_status"] == "tracker_parse_empty"
    assert result["new_items"] == []
