"""
Translate a notification's human-readable fields (ministry, instrument,
thread, summary) into an Indian scheduled language, so the citation index
is reachable by someone who doesn't read English or legal-register Hindi.

    python3 -m render.translate cus-45-2025 --lang hi --db gazette.db
    python3 -m render.translate cus-45-2025 --lang ta --db gazette.db

This translates the index's own generated English descriptions -- the
ministry/instrument/thread text and the one-sentence summary from
render.llm_export -- NOT the notification's original legal text. The
government's own primary source is often already bilingual (many gazette
notifications print an official Hindi column alongside English; this
project's `verified_by` tier `primary-source-egazette-hindi-column`
already tracks that), and this tool does not try to replace or improve on
that. It exists for the metadata this project itself writes: ministry
names, instrument titles, thread summaries -- so a reader can find and
understand a citation chain in their own language, then go to the
official bilingual source (pdf_url / egazette.gov.in) for the legal text
itself.

Language coverage, in priority order:
  1. All 22 languages of the Eighth Schedule to the Constitution --
     `INDIAN_LANGUAGES` below. This is the actual constitutional list
     (Assamese through Urdu), not a "major Indian languages" shortlist.
  2. A secondary set of major world languages plus India's immediate
     neighbors' languages (Sinhala, Burmese, Tibetan, Nepali is already
     in tier 1) -- `FOREIGN_LANGUAGES` below.
  3. Anything else: pass --lang-name "<language>" and it's sent to the
     model as free text, no code needed.

Backend: Gemini by default, via GEMINI_API_KEY (environment or the
canonical credential store, ~/.config/market-secrets/credentials.env --
never printed, read line-by-line for this one key). This needs no setup
and covers every language above adequately, but it is a paid per-call API
and its Indian-language quality is general-purpose, not specialized.

Two self-hosted alternatives exist as documented extension points (not
wired in here -- each is a real infrastructure decision, not a drop-in
swap):
  - **AI4Bharat/IndicTrans2** (github.com/AI4Bharat/IndicTrans2, MIT) --
    purpose-built for exactly the 22 languages in INDIAN_LANGUAGES, by
    IIT Madras's AI4Bharat lab, trained specifically for Indian-language
    quality rather than general multilingual coverage. The right choice
    if Indian-language translation quality or per-call cost at volume
    ever matters more than zero setup. Needs a GPU-hosted inference
    server (e.g. the same Colab-GPU pattern already used in this repo for
    Mistral -- see notebooks/serve_mistral_colab.ipynb).
  - **LibreTranslate** (github.com/LibreTranslate/LibreTranslate, AGPL) --
    self-hosted, 100+ languages including everything in
    FOREIGN_LANGUAGES, Docker-simple. The right choice for foreign-
    language coverage at volume without per-call API cost. Its Indian-
    language quality is general-purpose, same tradeoff as Gemini.
  - (Meta's NLLB-200 covers 200+ languages but ships CC-BY-NC-4.0 --
    non-commercial only -- so it's noted, not adopted, for a public repo.)

To add either: implement a `translate_record_<backend>()` alongside
`translate_record()` with the same signature, and select it with a
`--backend` flag on this module's CLI.
"""
from __future__ import annotations

import argparse
import json
import os
import sqlite3
import sys
import time
import urllib.request
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from render.llm_export import build_record  # noqa: E402

CREDENTIALS_FILE = os.path.expanduser("~/.config/market-secrets/credentials.env")
GEMINI_URL_TEMPLATE = "https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={key}"
DEFAULT_MODEL = "gemini-3.6-flash"

# All 22 languages of the Eighth Schedule to the Constitution of India --
# the authoritative complete list, not a "major languages" shortlist.
# ISO 639-1 codes where one exists; 639-2/3 codes otherwise (Bodo, Dogri,
# Konkani, Maithili, Manipuri, Santali have no widely used 639-1 code).
INDIAN_LANGUAGES = {
    "as": "Assamese", "bn": "Bengali", "brx": "Bodo", "doi": "Dogri",
    "gu": "Gujarati", "hi": "Hindi", "kn": "Kannada", "ks": "Kashmiri",
    "kok": "Konkani", "mai": "Maithili", "ml": "Malayalam", "mni": "Manipuri (Meitei)",
    "mr": "Marathi", "ne": "Nepali", "or": "Odia", "pa": "Punjabi",
    "sa": "Sanskrit", "sat": "Santali", "sd": "Sindhi", "ta": "Tamil",
    "te": "Telugu", "ur": "Urdu",
}

# Major world languages, plus languages of India's immediate neighbors
# not already in INDIAN_LANGUAGES (Nepali is there; Bengali/Urdu already
# serve Bangladesh/Pakistan readers).
FOREIGN_LANGUAGES = {
    "fr": "French", "es": "Spanish", "ar": "Arabic", "zh": "Chinese (Simplified)",
    "ru": "Russian", "pt": "Portuguese", "de": "German", "ja": "Japanese",
    "si": "Sinhala", "my": "Burmese", "bo": "Tibetan",
}

SUPPORTED_LANGUAGES = {**INDIAN_LANGUAGES, **FOREIGN_LANGUAGES}

TRANSLATABLE_FIELDS = ("ministry", "instrument", "thread", "summary")


def _read_credential(name: str) -> str | None:
    value = os.environ.get(name)
    if value:
        return value
    if os.path.exists(CREDENTIALS_FILE):
        with open(CREDENTIALS_FILE, encoding="utf-8") as f:
            for line in f:
                if line.startswith(f"{name}="):
                    return line.split("=", 1)[1].strip()
    return None


def _translate_text(text: str, lang_name: str, api_key: str, model: str, timeout: int = 60, retries: int = 3) -> str:
    prompt = (
        f"Translate the following short administrative/legal phrase into {lang_name}. "
        f"Keep proper nouns and Act/Order titles recognizable; output ONLY the translation, "
        f"nothing else.\n\nTEXT: {text}"
    )
    payload = json.dumps({"contents": [{"parts": [{"text": prompt}]}]}).encode()
    url = GEMINI_URL_TEMPLATE.format(model=model, key=api_key)
    last_error: Exception | None = None
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(url, data=payload, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                body = json.loads(resp.read())
            return body["candidates"][0]["content"]["parts"][0]["text"].strip()
        except urllib.error.HTTPError as e:
            last_error = e
            if e.code == 429 and attempt < retries:
                # rate-limited -- back off (2s, 4s, 8s) rather than hammer the same limit again
                time.sleep(2 ** (attempt + 1))
                continue
            if e.code != 429:
                raise
        except (TimeoutError, urllib.error.URLError) as e:
            last_error = e
    raise TimeoutError(f"Gemini call failed after {retries + 1} attempts: {last_error}")


def translate_record(record: dict, lang: str | None = None, lang_name: str | None = None,
                      api_key: str | None = None, model: str | None = None) -> dict:
    """Returns a copy of `record` with each field in TRANSLATABLE_FIELDS translated,
    plus '<field>_en' holding the original English. Untranslated (list/id) fields
    are passed through unchanged -- this never touches gazette_id, dates, or numbers,
    which are not language-dependent.

    Pass `lang` (a code from SUPPORTED_LANGUAGES) for the curated priority list, or
    `lang_name` (free text, e.g. "Sinhala" or "Swahili") for anything else -- exactly
    one of the two is required."""
    if bool(lang) == bool(lang_name):
        raise ValueError("pass exactly one of lang= or lang_name=")
    if lang is not None:
        if lang not in SUPPORTED_LANGUAGES:
            raise ValueError(f"unsupported language code {lang!r}; choose from {sorted(SUPPORTED_LANGUAGES)}, or pass lang_name= for any other language")
        lang_name = SUPPORTED_LANGUAGES[lang]
    key = api_key or _read_credential("GEMINI_API_KEY")
    if not key:
        raise SystemExit("GEMINI_API_KEY not found in environment or credential store")
    model = model or _read_credential("GEMINI_MODEL") or DEFAULT_MODEL

    out = dict(record)
    out["lang"] = lang or lang_name
    for field in TRANSLATABLE_FIELDS:
        value = record.get(field)
        if not value:
            continue
        out[f"{field}_en"] = value
        out[field] = _translate_text(value, lang_name, key, model)
    return out


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("gazette_id", nargs="?", help="required unless --list-languages")
    lang_group = parser.add_mutually_exclusive_group()
    lang_group.add_argument("--lang", choices=sorted(SUPPORTED_LANGUAGES), help="target language code from the priority list")
    lang_group.add_argument("--lang-name", help='any other language by name, e.g. "Swahili" -- no code needed')
    parser.add_argument("--list-languages", action="store_true", help="print the priority language list and exit")
    parser.add_argument("--db", default="gazette.db")
    args = parser.parse_args()

    if args.list_languages:
        print("Indian languages (Eighth Schedule, priority 1):")
        for code, name in sorted(INDIAN_LANGUAGES.items(), key=lambda kv: kv[1]):
            print(f"  {code:5s} {name}")
        print("\nForeign languages (priority 2):")
        for code, name in sorted(FOREIGN_LANGUAGES.items(), key=lambda kv: kv[1]):
            print(f"  {code:5s} {name}")
        print('\nAny other language: pass --lang-name "<language>" instead of --lang')
        return

    if not args.gazette_id or not (args.lang or args.lang_name):
        parser.error("gazette_id and one of --lang/--lang-name are required unless --list-languages")

    conn = sqlite3.connect(args.db)
    conn.row_factory = sqlite3.Row
    row = conn.execute(
        """
        SELECT g.*, m.name AS ministry_name, a.title AS instrument_title, t.subject_summary AS thread_summary
        FROM gazette_notification g
        LEFT JOIN ministry m ON m.ministry_id = g.ministry_id
        LEFT JOIN act_or_rule a ON a.instrument_id = g.instrument_id
        LEFT JOIN subject_thread t ON t.thread_id = g.thread_id
        WHERE g.gazette_id = ?
        """,
        (args.gazette_id,),
    ).fetchone()
    if row is None:
        raise SystemExit(f"no notification found for gazette_id {args.gazette_id!r}")

    record = build_record(conn, dict(row))
    translated = translate_record(record, lang=args.lang, lang_name=args.lang_name)
    print(json.dumps(translated, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
