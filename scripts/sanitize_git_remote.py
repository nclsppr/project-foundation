#!/usr/bin/env python3

from __future__ import annotations

import re
import sys
from urllib.parse import urlsplit, urlunsplit


FORBIDDEN_CHARACTERS = ("\r", "\n", "`", "|")


def sanitize(remote: str) -> str:
    if any(character in remote for character in FORBIDDEN_CHARACTERS):
        raise ValueError("remote contains an unsafe Markdown character")

    if "://" in remote:
        parts = urlsplit(remote)
        host = parts.hostname
        port = parts.port
        if not host:
            raise ValueError("remote URL has no host")
        if ":" in host and not host.startswith("["):
            host = f"[{host}]"
        netloc = host if port is None else f"{host}:{port}"
        remote = urlunsplit((parts.scheme, netloc, parts.path, "", ""))
    else:
        scp_style = re.fullmatch(r"[^/@]+@([^:]+):(.+)", remote)
        if scp_style:
            host, path = scp_style.groups()
            remote = f"ssh://{host}/{path.lstrip('/')}"

    if any(character in remote for character in FORBIDDEN_CHARACTERS):
        raise ValueError("sanitized remote contains an unsafe Markdown character")
    return remote


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: sanitize_git_remote.py REMOTE", file=sys.stderr)
        return 2
    try:
        sanitized = sanitize(sys.argv[1])
    except (ValueError, UnicodeError) as error:
        print(f"remote refusé : {error}", file=sys.stderr)
        return 1
    print(sanitized)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
