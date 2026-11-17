"""Read one named setting from the environment, falling back to the local
credential store. The store is read line-by-line for just the requested key;
values are never printed, logged or written anywhere."""
from __future__ import annotations

import os

CREDENTIALS_FILE = os.path.expanduser("~/.config/market-secrets/credentials.env")


def read_credential(name: str, credentials_file: str | None = None) -> str | None:
    """Return $name if set, else the `name=value` line from `credentials_file`
    (default CREDENTIALS_FILE), else None."""
    value = os.environ.get(name)
    if value:
        return value
    path = credentials_file or CREDENTIALS_FILE
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            for line in f:
                if line.startswith(f"{name}="):
                    return line.split("=", 1)[1].strip()
    return None
