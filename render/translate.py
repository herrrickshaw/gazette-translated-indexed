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

A self-hosted alternative is wired in as --backend libretranslate:
  - **LibreTranslate** (github.com/LibreTranslate/LibreTranslate, AGPL) --
    self-hosted, no per-call quota. Its underlying Argos Translate models
    cover only LIBRETRANSLATE_CODES though -- confirmed live against
    Argos's own package index: just 3 of the 22 INDIAN_LANGUAGES (Bengali,
    Hindi, Urdu -- nothing else, including Marathi/Telugu/Tamil, has an
    en-> Argos model) and 8 of the 11 FOREIGN_LANGUAGES (missing Sinhala,
    Burmese, Tibetan). Run it locally (no GPU needed, small CTranslate2
    models): `libretranslate --port 5001 --load-only en,hi,bn` (add more
    codes from LIBRETRANSLATE_CODES as needed), or point --lang at a
    non-default host via the LIBRETRANSLATE_URL credential.

**AI4Bharat/IndicTrans2** (github.com/AI4Bharat/IndicTrans2, MIT) was
attempted first -- purpose-built for exactly the 22 INDIAN_LANGUAGES, by
IIT Madras's AI4Bharat lab -- but its remote model code (loaded via HF's
trust_remote_code) is incompatible with current transformers' reworked
KV-cache internals in a way that goes past reasonable monkey-patching (5
separate compatibility bugs were found and fixed live -- tokenizer import
location, a removed `transformers.onnx` module, special-tokens-map init
order, `tie_weights()` signature drift at two call sites, a removed
`_tie_or_clone_weights` helper -- before hitting a 6th, in the KV-cache
object itself, that would need reverse-engineering an undocumented
internal API). Pinning an old, actually-matching transformers version
was tried and is a dead end on this Colab image's Python 3.13: the
matching old `tokenizers` release's Rust/PyO3 bindings predate Python
3.13's C API and fail to build from source even with a fresh Rust
toolchain. See notebooks/serve_indictrans2_colab.ipynb for the full
diagnosis if transformers ever catches up on that front -- not adopted.

  - (Meta's NLLB-200 covers 200+ languages but ships CC-BY-NC-4.0 --
    non-commercial only -- so it's noted, not adopted, for a public repo.)

To add another backend: implement a `translate_record_<backend>()`
alongside `translate_record()` with the same signature, and select it
with a `--backend` flag on this module's CLI.
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
# "gemini-flash-latest" -- an alias, not a dated model name -- so this stays
# on a current model without needing an edit here every time Google renames
# one. Deliberately NOT the credential store's GEMINI_MODEL: that value
# (gemini-3.6-flash) is pinned to a free-tier quota of 20 requests/day,
# shared with another automated process on this machine, and unusable for
# translation at this project's scale (confirmed via a live 429
# RESOURCE_EXHAUSTED / GenerateRequestsPerDayPerProjectPerModel-FreeTier
# response). "gemini-flash-latest" draws from a separate, much larger quota.
DEFAULT_MODEL = "gemini-flash-latest"

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
            # 429 = rate-limited/quota; 503 = model temporarily overloaded (observed
            # in practice on gemini-flash-latest under load) -- both are transient,
            # everything else (400 bad request, 404 unknown model, ...) is not.
            if e.code in (429, 503) and attempt < retries:
                time.sleep(2 ** (attempt + 1))  # 2s, 4s, 8s
                continue
            if e.code not in (429, 503):
                raise
        except (TimeoutError, urllib.error.URLError) as e:
            last_error = e
    raise TimeoutError(f"Gemini call failed after {retries + 1} attempts: {last_error}")


def translate_record(record: dict, lang: str | None = None, lang_name: str | None = None,
                      api_key: str | None = None, model: str | None = None,
                      fields: tuple[str, ...] = TRANSLATABLE_FIELDS) -> dict:
    """Returns a copy of `record` with each field in `fields` translated,
    plus '<field>_en' holding the original English. Untranslated (list/id) fields
    are passed through unchanged -- this never touches gazette_id, dates, or numbers,
    which are not language-dependent.

    Pass `lang` (a code from SUPPORTED_LANGUAGES) for the curated priority list, or
    `lang_name` (free text, e.g. "Sinhala" or "Swahili") for anything else -- exactly
    one of the two is required. `fields` defaults to all of TRANSLATABLE_FIELDS
    (ministry/instrument/thread/summary); pass a narrower tuple -- e.g. ("summary",)
    -- to cut per-record API calls when translating at corpus scale."""
    if bool(lang) == bool(lang_name):
        raise ValueError("pass exactly one of lang= or lang_name=")
    if lang is not None:
        if lang not in SUPPORTED_LANGUAGES:
            raise ValueError(f"unsupported language code {lang!r}; choose from {sorted(SUPPORTED_LANGUAGES)}, or pass lang_name= for any other language")
        lang_name = SUPPORTED_LANGUAGES[lang]
    key = api_key or _read_credential("GEMINI_API_KEY")
    if not key:
        raise SystemExit("GEMINI_API_KEY not found in environment or credential store")
    # Deliberately not falling back to the credential store's GEMINI_MODEL --
    # see the DEFAULT_MODEL comment above for why.
    model = model or DEFAULT_MODEL

    out = dict(record)
    out["lang"] = lang or lang_name
    for field in fields:
        value = record.get(field)
        if not value:
            continue
        out[f"{field}_en"] = value
        out[field] = _translate_text(value, lang_name, key, model)
    return out


DEFAULT_LIBRETRANSLATE_URL = "http://127.0.0.1:5001"

# LibreTranslate's underlying Argos Translate models -- confirmed live against
# https://raw.githubusercontent.com/argosopentech/argospm-index/main/index.json
# -- cover only 3 of the 22 INDIAN_LANGUAGES (Bengali, Hindi, Urdu; nothing
# else has an en-> Argos model at all, including Marathi/Telugu/Tamil) and 8
# of the 11 FOREIGN_LANGUAGES (missing Sinhala, Burmese, Tibetan). Attempted
# as a self-hosted alternative to IndicTrans2 after IndicTrans2's remote
# model code proved incompatible with current transformers' reworked
# KV-cache internals (see notebooks/serve_indictrans2_colab.ipynb's header
# for that diagnosis) -- LibreTranslate is plain, actively-maintained
# software with no trust_remote_code fragility, at the cost of much
# narrower language coverage.
LIBRETRANSLATE_CODES = {"bn", "hi", "ur", "fr", "es", "ar", "zh", "ru", "pt", "de", "ja"}


def libretranslate_status(timeout: float = 5.0) -> str:
    """One of: 'endpoint_down', 'ready'. Never raises."""
    url = _read_credential("LIBRETRANSLATE_URL") or DEFAULT_LIBRETRANSLATE_URL
    try:
        with urllib.request.urlopen(f"{url.rstrip('/')}/languages", timeout=timeout):
            return "ready"
    except Exception:
        return "endpoint_down"


def _translate_text_libretranslate(text: str, tgt_code: str, url: str, timeout: int = 30, retries: int = 3) -> str:
    payload = json.dumps({"q": text, "source": "en", "target": tgt_code, "format": "text"}).encode()
    endpoint = f"{url.rstrip('/')}/translate"
    last_error: Exception | None = None
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(endpoint, data=payload, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                return json.loads(resp.read())["translatedText"].strip()
        except (TimeoutError, urllib.error.URLError, urllib.error.HTTPError) as e:
            last_error = e
            if attempt < retries:
                time.sleep(2 ** (attempt + 1))
    raise TimeoutError(f"LibreTranslate call failed after {retries + 1} attempts: {last_error}")


def translate_record_libretranslate(record: dict, lang: str, url: str | None = None,
                                     fields: tuple[str, ...] = TRANSLATABLE_FIELDS) -> dict:
    """Same contract as translate_record(), served by a self-hosted LibreTranslate
    instance instead of Gemini -- no per-call quota, but only LIBRETRANSLATE_CODES
    languages. Defaults to DEFAULT_LIBRETRANSLATE_URL (localhost:5001); override
    via url= or the LIBRETRANSLATE_URL credential for a non-default host/port."""
    if lang not in LIBRETRANSLATE_CODES:
        raise ValueError(f"libretranslate backend only supports {sorted(LIBRETRANSLATE_CODES)}, got {lang!r}")
    endpoint = url or _read_credential("LIBRETRANSLATE_URL") or DEFAULT_LIBRETRANSLATE_URL

    out = dict(record)
    out["lang"] = lang
    for field in fields:
        value = record.get(field)
        if not value:
            continue
        out[f"{field}_en"] = value
        out[field] = _translate_text_libretranslate(value, lang, endpoint)
    return out


DEFAULT_KRUTRIM_URL = "http://127.0.0.1:5002"

# krutrim-ai-labs/Krutrim-Translate (extends AI4Bharat/IndicTrans2's
# architecture with a longer context window, served via CTranslate2 --
# confirmed live to run cleanly on CPU, no GPU needed, ~0.1-0.2s/call).
# Unlike the raw IndicTrans2-via-transformers path (abandoned, see
# notebooks/serve_indictrans2_colab.ipynb), CTranslate2 is a standalone C++
# inference engine with no trust_remote_code/transformers-version
# fragility -- confirmed by getting it running end-to-end where the
# transformers path could not. Covers 9 of 22 INDIAN_LANGUAGES (all 5 of
# this project's priority languages -- hi/bn/mr/te/ta -- plus kn/ml/gu/pa);
# no FOREIGN_LANGUAGES. License: Krutrim Community License (free for
# non-commercial/research use under 1M MAU, requires attribution to
# Krutrim -- see ~/krutrim-translate/LICENSE.md).
#
# Codes are IndicTrans2's own FLORES-200-style codes (language_Script),
# matching the mapping the abandoned indictrans2 backend used.
KRUTRIM_CODES = {
    "bn": "ben_Beng", "gu": "guj_Gujr", "hi": "hin_Deva", "kn": "kan_Knda",
    "ml": "mal_Mlym", "mr": "mar_Deva", "pa": "pan_Guru", "ta": "tam_Taml",
    "te": "tel_Telu",
}


def krutrim_status(timeout: float = 5.0) -> str:
    """One of: 'endpoint_down', 'ready'. Never raises."""
    url = _read_credential("KRUTRIM_URL") or DEFAULT_KRUTRIM_URL
    try:
        with urllib.request.urlopen(f"{url.rstrip('/')}/health", timeout=timeout):
            return "ready"
    except Exception:
        return "endpoint_down"


def _translate_text_krutrim(text: str, tgt_flores: str, url: str, timeout: int = 30, retries: int = 3) -> str:
    payload = json.dumps({"text": text, "tgt_lang": tgt_flores}).encode()
    endpoint = f"{url.rstrip('/')}/translate"
    last_error: Exception | None = None
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(endpoint, data=payload, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                return json.loads(resp.read())["translation"].strip()
        except (TimeoutError, urllib.error.URLError, urllib.error.HTTPError) as e:
            last_error = e
            if attempt < retries:
                time.sleep(2 ** (attempt + 1))
    raise TimeoutError(f"Krutrim call failed after {retries + 1} attempts: {last_error}")


def translate_record_krutrim(record: dict, lang: str, url: str | None = None,
                              fields: tuple[str, ...] = TRANSLATABLE_FIELDS) -> dict:
    """Same contract as translate_record(), served by a local Krutrim-Translate
    CTranslate2 server (~/krutrim-translate/server.py) instead of Gemini -- no
    per-call quota, only KRUTRIM_CODES languages (all 9 of this project's
    priority Indian languages). Defaults to DEFAULT_KRUTRIM_URL (localhost:5002);
    override via url= or the KRUTRIM_URL credential for a non-default host/port."""
    if lang not in KRUTRIM_CODES:
        raise ValueError(f"krutrim backend only supports {sorted(KRUTRIM_CODES)}, got {lang!r}")
    endpoint = url or _read_credential("KRUTRIM_URL") or DEFAULT_KRUTRIM_URL
    tgt_flores = KRUTRIM_CODES[lang]

    out = dict(record)
    out["lang"] = lang
    for field in fields:
        value = record.get(field)
        if not value:
            continue
        out[f"{field}_en"] = value
        out[field] = _translate_text_krutrim(value, tgt_flores, endpoint)
    return out


BACKEND_FNS = {
    "krutrim": translate_record_krutrim,
    "libretranslate": translate_record_libretranslate,
    "gemini": translate_record,
}


def resolve_backend(lang: str) -> str:
    """Pick the best backend for `lang` automatically, so a caller doesn't need
    to know which self-hosted service happens to cover which language: krutrim
    first (self-hosted, no quota, covers this project's 5 priority Indian
    languages at the best quality available), then libretranslate (self-hosted,
    no quota, covers the foreign-language tier and a couple of Indian
    languages krutrim doesn't), then gemini as the fallback that covers
    everything else in SUPPORTED_LANGUAGES but is quota-limited. Raises
    ValueError if `lang` isn't in SUPPORTED_LANGUAGES at all."""
    if lang in KRUTRIM_CODES:
        return "krutrim"
    if lang in LIBRETRANSLATE_CODES:
        return "libretranslate"
    if lang in SUPPORTED_LANGUAGES:
        return "gemini"
    raise ValueError(f"unsupported language code {lang!r}; choose from {sorted(SUPPORTED_LANGUAGES)}")


def translate_record_auto(record: dict, lang: str, fields: tuple[str, ...] = TRANSLATABLE_FIELDS) -> dict:
    """translate_record() with the backend picked automatically via resolve_backend().
    Every backend here shares the same (record, lang=..., fields=...) call shape,
    so this is a thin dispatch, not a re-implementation."""
    backend = resolve_backend(lang)
    return BACKEND_FNS[backend](record, lang=lang, fields=fields)


def _print_language_list() -> None:
    print("Indian languages (Eighth Schedule, priority 1):")
    for code, name in sorted(INDIAN_LANGUAGES.items(), key=lambda kv: kv[1]):
        print(f"  {code:5s} {name}")
    print("\nForeign languages (priority 2):")
    for code, name in sorted(FOREIGN_LANGUAGES.items(), key=lambda kv: kv[1]):
        print(f"  {code:5s} {name}")
    print('\nAny other language: pass --lang-name "<language>" instead of --lang')


def _fetch_record(conn: sqlite3.Connection, gazette_id: str) -> dict:
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
        (gazette_id,),
    ).fetchone()
    if row is None:
        raise SystemExit(f"no notification found for gazette_id {gazette_id!r}")
    return build_record(conn, dict(row))


def _dispatch(record: dict, args: argparse.Namespace) -> dict:
    if args.backend in ("krutrim", "libretranslate"):
        return BACKEND_FNS[args.backend](record, lang=args.lang)
    return translate_record(record, lang=args.lang, lang_name=args.lang_name)


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("gazette_id", nargs="?", help="required unless --list-languages")
    lang_group = parser.add_mutually_exclusive_group()
    lang_group.add_argument("--lang", choices=sorted(SUPPORTED_LANGUAGES), help="target language code from the priority list")
    lang_group.add_argument("--lang-name", help='any other language by name, e.g. "Swahili" -- no code needed')
    parser.add_argument("--list-languages", action="store_true", help="print the priority language list and exit")
    parser.add_argument("--backend", choices=["gemini", "libretranslate", "krutrim"], default="gemini",
                         help="gemini (default, all SUPPORTED_LANGUAGES), libretranslate "
                              "(self-hosted, LIBRETRANSLATE_CODES languages only, needs a server on "
                              "http://127.0.0.1:5001), or krutrim (self-hosted, KRUTRIM_CODES languages "
                              "only -- covers all 5 priority Indian languages -- needs "
                              "~/krutrim-translate/server.py running on http://127.0.0.1:5002)")
    parser.add_argument("--db", default="gazette.db")
    return parser


def main() -> None:
    parser = _build_parser()
    args = parser.parse_args()

    if args.list_languages:
        _print_language_list()
        return

    if not args.gazette_id or not (args.lang or args.lang_name):
        parser.error("gazette_id and one of --lang/--lang-name are required unless --list-languages")
    if args.backend in ("libretranslate", "krutrim") and not args.lang:
        parser.error(f"--backend {args.backend} requires --lang, not --lang-name")

    conn = sqlite3.connect(args.db)
    record = _fetch_record(conn, args.gazette_id)
    translated = _dispatch(record, args)
    print(json.dumps(translated, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
