"""
Parse a manifest of gazette IDs against the OFFICIAL PDFs fetched from
egazette.gov.in, and report what the pipeline recovers from primary text.

    python3 -m ingest.parse_manifest data/manifest/collected_ids.csv \
        --pdf-dir "<dropbox>/gazette-translated-indexed/egazette" \
        --report data/manifest/parse_report.md [--update-db gazette.db]

For every row this checks, from the official PDF's own text:
  1. self-consistency — does the PDF contain its own expected citation
     number? (catches a wrong ID -> PDF mapping, or a mis-attributed ID)
  2. recovery — does the ministry's extractor recover the expected
     target(s)? Rows flagged modeled=1 are the index's existing claims and
     MUST recover; modeled=0 rows are deferred shapes, reported for
     information only (a miss there is expected, not a failure).
  3. scanned? — LikelyScannedError means the OCR path is needed.

--update-db upgrades verified_by to 'primary-source-egazette' ONLY for
modeled cross_reference rows whose (self_citation -> target) was recovered
from the official text. Nothing is downgraded and nothing unrecovered is
touched — provenance only moves on evidence.
"""
from __future__ import annotations

import argparse
import csv
import importlib
import inspect
import sqlite3
import sys
from pathlib import Path

from extract.citation_patterns import find_gazette_citations
from ingest.egazette import parse_gazette_id
from ingest.pdf_text import LikelyScannedError, extract_text

# ministry_id -> extractor module (each exposes find_candidate_links).
# Ministries with no extractor yet fall through to the generic citation scan.
EXTRACTORS = {
    'road-transport-highways': 'extract.morth_patterns',
    'environment-forest-climate-change': 'extract.moefcc_patterns',
    'home-affairs': 'extract.mha_patterns',
    'health-family-welfare': 'extract.health_patterns',
    'railways': 'extract.railways_patterns',
    'corporate-affairs': 'extract.mca_patterns',
    'consumer-affairs-food-public-distribution': 'extract.consumer_affairs_patterns',
    'labour-and-employment': 'extract.labour_patterns',
    'power': 'extract.power_patterns',
    'agriculture-and-farmers-welfare': 'extract.agriculture_patterns',
    'electronics-and-information-technology': 'extract.meity_patterns',
    'civil-aviation': 'extract.civil_aviation_patterns',
    'housing-and-urban-affairs': 'extract.mohua_patterns',
    'culture': 'extract.culture_patterns',
    'steel': 'extract.steel_patterns',
    'communications': 'extract.communications_patterns',
    'ayush': 'extract.ayush_patterns',
    'mines': 'extract.mines_patterns',
    'defence': 'extract.defence_patterns',
    'skill-development-entrepreneurship': 'extract.skill_development_patterns',
}


def _run_extractor(ministry_id: str, text: str, self_citation: str) -> list[str] | None:
    mod_name = EXTRACTORS.get(ministry_id)
    if not mod_name:
        return None
    fn = importlib.import_module(mod_name).find_candidate_links
    # morth uses `self_so`; every later module standardized on `self_citation`.
    kw = 'self_so' if 'self_so' in inspect.signature(fn).parameters else 'self_citation'
    return [l.target_citation for l in fn(text, **{kw: self_citation or None})]


def _pdf_path(pdf_dir: Path, gazette_id: str) -> Path:
    return pdf_dir / parse_gazette_id(gazette_id)['yyyy'] / f'{gazette_id}.pdf'


def parse_row(row: dict, pdf_dir: Path, md_dir: Path) -> dict:
    gid = row['gazette_id']
    out = {**row, 'status': '', 'self_found': None, 'citations': [], 'recovered': [], 'missing': []}
    pdf = _pdf_path(pdf_dir, gid)
    if not pdf.exists():
        out['status'] = 'NO_PDF'
        return out
    try:
        text = extract_text(pdf)
    except LikelyScannedError:
        out['status'] = 'NEEDS_OCR'
        return out
    md_dir.mkdir(parents=True, exist_ok=True)
    (md_dir / f'{gid}.md').write_text(
        f'---\nsource_url: https://egazette.gov.in/WriteReadData/{parse_gazette_id(gid)["yyyy"]}/'
        f'{parse_gazette_id(gid)["fileid"]}.pdf\ngazette_id: {gid}\n'
        f'extraction_method: ingest.pdf_text (PyMuPDF)\n---\n\n{text}'
    )
    cites = [c.normalized for c in find_gazette_citations(text)]
    out['citations'] = sorted(set(cites))
    if row['self_citation']:
        out['self_found'] = row['self_citation'] in cites
    expected = [t for t in row['expected_targets'].split(';') if t]
    found = _run_extractor(row['ministry_id'], text, row['self_citation'])
    if found is None:
        found = [c for c in out['citations'] if c != row['self_citation']]  # generic fallback
        out['status'] = 'GENERIC'
    out['recovered'] = [t for t in expected if t in found]
    out['missing'] = [t for t in expected if t not in found]
    out['found_all'] = found
    if not out['status']:
        if expected and not out['missing']:
            out['status'] = 'RECOVERED'
        elif expected:
            out['status'] = 'PARTIAL' if out['recovered'] else 'MISSED'
        else:
            out['status'] = 'TARGET_ONLY'
    return out


def write_report(results: list[dict], path: Path) -> None:
    modeled = [r for r in results if r['modeled'] == '1']
    lines = ['# Parse report — official egazette.gov.in PDFs vs. the index',
             '',
             f'Rows: {len(results)} · modeled claims: {len(modeled)} · '
             f'modeled recovered: {sum(1 for r in modeled if r["status"] == "RECOVERED")} · '
             f'self-citation found in own PDF: {sum(1 for r in results if r["self_found"])}'
             f'/{sum(1 for r in results if r["self_found"] is not None)} · '
             f'needs OCR: {sum(1 for r in results if r["status"] == "NEEDS_OCR")} · '
             f'no PDF: {sum(1 for r in results if r["status"] == "NO_PDF")}',
             '',
             '| gazette_id | ministry | self | self in PDF | expected | recovered | missing | status | modeled |',
             '|---|---|---|---|---|---|---|---|---|']
    for r in results:
        lines.append('| {gazette_id} | {ministry_id} | {self_citation} | {sf} | {expected_targets} | {rec} | {mis} | {status} | {modeled} |'.format(
            sf={True: 'yes', False: '**NO**', None: '—'}[r['self_found']],
            rec='; '.join(r['recovered']) or '—', mis='; '.join(r['missing']) or '—', **r))
    path.write_text('\n'.join(lines) + '\n')


def update_db(results: list[dict], db: Path) -> int:
    conn = sqlite3.connect(db)
    n = 0
    for r in results:
        if r['modeled'] != '1' or r['status'] != 'RECOVERED':
            continue
        for target in r['recovered']:
            cur = conn.execute(
                """UPDATE cross_reference SET verified_by='primary-source-egazette', verified_at=date('now')
                   WHERE source_gazette_id IN (SELECT gazette_id FROM gazette_notification WHERE gsr_or_so=?)
                     AND target_gazette_id IN (SELECT gazette_id FROM gazette_notification WHERE gsr_or_so=?)
                     AND verified_by != 'primary-source-egazette'""",
                (r['self_citation'], target))
            n += cur.rowcount
    conn.commit()
    conn.close()
    return n


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('manifest')
    ap.add_argument('--pdf-dir', required=True)
    ap.add_argument('--md-dir', default='data/raw_md')
    ap.add_argument('--report', default='data/manifest/parse_report.md')
    ap.add_argument('--update-db')
    args = ap.parse_args()

    rows = list(csv.DictReader(open(args.manifest, newline='')))
    results = [parse_row(r, Path(args.pdf_dir), Path(args.md_dir)) for r in rows]
    write_report(results, Path(args.report))
    for r in results:
        flag = '' if r['self_found'] in (True, None) else '  <-- SELF-CITATION NOT IN PDF'
        print(f'{r["gazette_id"]:<26} {r["status"]:<11} rec={len(r["recovered"])}/{len(r["recovered"])+len(r["missing"])}{flag}')
    if args.update_db:
        print(f'provenance upgraded on {update_db(results, Path(args.update_db))} cross_reference row(s)')
    modeled_missed = [r for r in results if r['modeled'] == '1' and r['status'] != 'RECOVERED']
    return 1 if modeled_missed else 0


if __name__ == '__main__':
    sys.exit(main())
