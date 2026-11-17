"""Characterisation test: extraction/matching output on synthetic text must be
byte-identical to the baseline captured from the pre-refactor code."""
import json
from pathlib import Path

from tests.golden_corpus import run_all

BASELINE = Path(__file__).parent / "golden" / "extraction_baseline.json"


def test_extraction_matches_pre_refactor_baseline():
    expected = json.loads(BASELINE.read_text())
    actual = json.loads(json.dumps(run_all()))
    assert actual == expected
