"""
Regression test for extract.space_patterns against a real Department of
Space notification: S.O. 2018(E), dated 25 April 2022 (Gazette No. 1918,
29 April 2022), amending the Department of Space Employees' (Classification,
Control and Appeal) Rules, 1976 — fetched directly from egazette.gov.in
(data/raw_md/CG-KA-E-30042022-235463.md) via ingest.egazette, not from the
gazettetracker.com aggregator (see db/seed_space.sql for full provenance).

Quoted verbatim (English portion) from that primary-source PDF text, table
truncated to its first two and last row for brevity — the extractor must
still find only the principal citation named right after "vide", not any of
the row numbers from the truncated 39-row amendment-history table.
"""
from extract.space_patterns import find_candidate_links

DOS_2018E_2022_NOTIFICATION = (
    "DEPARTMENT OF SPACE NOTIFICATION Bangalore, the 25th April, 2022 "
    "S.O. 2018(E).—In exercise of the powers conferred by the proviso to Article 309 of the "
    "Constitution, the President hereby makes the following rules further to amend the Department "
    "of Space Employees' (Classification, Control and Appeal) Rules, 1976, namely:- "
    "1) These rules may be called the Department of Space Employees' (Classification, Control and "
    "Appeal) Amendment Rules, 2022. "
    "2) They shall come into force on the date of their publication in the Official Gazette. "
    "2. In the existing Schedule appended to the Department of Space Employees' (Classification, "
    "Control and Appeal) Rules, 1976, where the designation of Head, Personnel & General "
    "Administration exists under National Remote Sensing Centre (NRSC), it shall be substituted by "
    "“Sr. Head, Personnel & General Administration / Head, Personnel & General Administration”. "
    "[F.No.E.14015/1/2012-IV] SANDHYA VENUGOPAL SHARMA, Add.Secy. "
    "Note:The Principal rules were published vide No.S.O.270(E) dated 01.04.1976 in the Gazette of "
    "India (Extraordinary) Part-II, Section-3, Sub-Section(ii) dated 01.04.1976 and have been "
    "subsequently amended by:- "
    "Sl. No. Notification No. Date S.O. No. Date "
    "1 2/10(32)/76-I 10.02.1977 780 12.03.1977 "
    "2 2/10(32)/76-I 16.05.1977 2127 25.06.1977 "
    "38 E.14015/1/2012-IV 29.10.2019 4235(E) 22.11.2019"
)


def test_finds_the_real_principal_citation():
    links = find_candidate_links(DOS_2018E_2022_NOTIFICATION, self_citation='S.O. 2018(E)')
    targets = {l.target_citation for l in links}
    assert targets == {'S.O. 270(E)'}, targets


def test_self_citation_excluded():
    links = find_candidate_links(DOS_2018E_2022_NOTIFICATION, self_citation='S.O. 2018(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 2018(E)' not in targets


def test_truncated_table_rows_not_picked_up_as_targets():
    # The table's own row values (bare "780", "2127", and even the
    # (E)-suffixed "4235(E)" from a real later amendment) sit far outside
    # the 60-char 'vide' window and must not appear as spurious targets.
    links = find_candidate_links(DOS_2018E_2022_NOTIFICATION, self_citation='S.O. 2018(E)')
    targets = {l.target_citation for l in links}
    assert 'S.O. 4235(E)' not in targets
