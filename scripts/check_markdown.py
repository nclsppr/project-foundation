#!/usr/bin/env python3

from __future__ import annotations

import html
import re
import stat
import sys
import unicodedata
from pathlib import Path
from urllib.parse import unquote


MINIMUM_PYTHON = (3, 9)

if sys.version_info < MINIMUM_PYTHON:
    detected = ".".join(str(part) for part in sys.version_info[:3])
    print(
        f"Python >= 3.9 est requis (version détectée : {detected}).",
        file=sys.stderr,
    )
    raise SystemExit(2)


ROOT = Path(__file__).resolve().parent.parent
TEMPLATES = ROOT / "templates"

REQUIRED_PATHS = (
    ".github/workflows/verify.yml",
    ".gitignore",
    "compose.yaml",
    "README.md",
    "PROJECT.md",
    "STATUS.md",
    "ROADMAP.md",
    "VERSION",
    "AGENTS.md",
    "CLAUDE.md",
    "PRINCIPLES.md",
    "DEFAULTS.md",
    "DEFINITION-OF-DONE.md",
    "CHANGELOG.md",
    "AUDIT.md",
    "ADOPTION.md",
    "DOCUMENTATION.md",
    "DOCUMENTATION-CATALOG.md",
    "documentation.json",
    "VERSIONING.md",
    "docs/decisions/adr-0001-standalone-versioned-foundation.md",
    "docs/decisions/adr-0002-catalogue-universel-nimbus-optionnel.md",
    "docs/decisions/adr-0003-nimbus-obligatoire.md",
    "docs/decisions/adr-0005-docker-compose-obligatoire.md",
    "docs-nimbus/AGENT.md",
    "docs-nimbus/.env.example",
    "docs-nimbus/astro.config.ts",
    "docs-nimbus/nimbus.json",
    "docs-nimbus/package-lock.json",
    "docs-nimbus/package.json",
    "docs-nimbus/scripts/sync-content.mjs",
    "docs-nimbus/scripts/sync-content.test.mjs",
    "docs-nimbus/src/content.config.ts",
    "examples/minimal-web/README.md",
    "profiles/web.md",
    "profiles/backend-data.md",
    "profiles/infrastructure-production.md",
    "profiles/experiment.md",
    "profiles/generated-artifacts.md",
    "profiles/dependency-change.md",
    "profiles/documentation-nimbus.md",
    "scripts/check_markdown.py",
    "scripts/check_compose.py",
    "scripts/documentation_catalog.py",
    "scripts/verify.sh",
    "scripts/bootstrap.sh",
    "scripts/test_bootstrap.sh",
    "scripts/sanitize_git_remote.py",
    "templates/README.md",
    "templates/.github/workflows/verify.yml",
    "templates/compose.yaml",
    "templates/README-standard.md",
    "templates/CHANGELOG.md",
    "templates/BRIEF.md",
    "templates/PROJECT.md",
    "templates/STATUS.md",
    "templates/ROADMAP.md",
    "templates/FOUNDATION.md",
    "templates/AGENTS.md",
    "templates/AGENTS-minimal.md",
    "templates/CLAUDE.md",
    "templates/ADR.md",
    "templates/DESIGN.md",
    "templates/RUNBOOK.md",
    "templates/DELIVERY-EVIDENCE.md",
    "templates/DOCUMENTATION.md",
    "templates/documentation.json",
    "templates/scripts/check_markdown.py",
    "templates/scripts/verify.sh",
)

EXECUTABLE_PATHS = (
    "scripts/check_markdown.py",
    "scripts/check_compose.py",
    "scripts/documentation_catalog.py",
    "scripts/verify.sh",
    "scripts/bootstrap.sh",
    "scripts/test_bootstrap.sh",
    "scripts/sanitize_git_remote.py",
    "templates/scripts/check_markdown.py",
    "templates/scripts/verify.sh",
)

# Le catalogue n'est pas un template : le bootstrap le génère après avoir
# copié le README. Les tests de bootstrap vérifient ensuite sa présence.
GENERATED_BOOTSTRAP_LINKS = {
    (Path("templates/README.md"), "DOCUMENTATION-CATALOG.md"),
    (Path("templates/README-standard.md"), "DOCUMENTATION-CATALOG.md"),
}

FORBIDDEN_DASHES = {
    "\u2013": "demi-cadratin",
    "\u2014": "cadratin",
    "\u2015": "barre horizontale",
}

LINK_PATTERN = re.compile(
    r"!?\[[^\]]*\]\(\s*(?P<target><[^>]+>|[^\s)]+)"
    r"(?:\s+(?:\"[^\"]*\"|'[^']*'|\([^)]*\)))?\s*\)"
)
FENCE_PATTERN = re.compile(r"^\s*(`{3,}|~{3,})")
HEADING_PATTERN = re.compile(r"^\s{0,3}(#{1,6})\s+(.+?)\s*#*\s*$")
EXPLICIT_ANCHOR_PATTERN = re.compile(
    r"<(?:a|span)\b[^>]*(?:id|name)=[\"']([^\"']+)[\"']",
    re.IGNORECASE,
)
EXPLICIT_HEADING_ID_PATTERN = re.compile(r"\s*\{#([^}]+)\}\s*$")
URI_SCHEME_PATTERN = re.compile(r"^[A-Za-z][A-Za-z0-9+.-]*:")
ALLOWED_EXTERNAL_SCHEMES = ("http://", "https://", "mailto:", "tel:")
SEMVER_PATTERN = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+$")
REQUIRED_COMPOSE_WIRING = (
    (
        "scripts/verify.sh",
        re.compile(
            r'(?m)^\s*python3 "\$\{SCRIPT_DIR\}/check_compose\.py"\s*$'
        ),
    ),
    (
        ".github/workflows/verify.yml",
        re.compile(r"(?m)^\s*python3 scripts/check_compose\.py\s*$"),
    ),
    (
        "templates/scripts/verify.sh",
        re.compile(
            r'(?m)^\s*python3 "\$\{SCRIPT_DIR\}/check_compose\.py"\s*$'
        ),
    ),
    (
        "templates/.github/workflows/verify.yml",
        re.compile(r"(?m)^\s*python3 scripts/check_compose\.py\s*$"),
    ),
)


def markdown_files() -> list[Path]:
    return sorted(
        path
        for path in ROOT.rglob("*.md")
        if ".git" not in path.parts
        and "node_modules" not in path.parts
        and "dist" not in path.parts
        and ".astro" not in path.parts
        and path.relative_to(ROOT).parts[:4]
        != ("docs-nimbus", "src", "content", "docs")
    )


def line_number(text: str, offset: int) -> int:
    return text.count("\n", 0, offset) + 1


def check_required_paths(errors: list[str]) -> None:
    for relative in REQUIRED_PATHS:
        if not (ROOT / relative).is_file():
            errors.append(f"fichier requis absent : {relative}")


def check_executable_paths(errors: list[str]) -> None:
    for relative in EXECUTABLE_PATHS:
        path = ROOT / relative
        if not path.is_file():
            continue
        mode = path.stat().st_mode
        if not mode & (stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH):
            errors.append(f"fichier requis non exécutable : {relative}")


def check_compose_wiring(errors: list[str]) -> None:
    for relative, pattern in REQUIRED_COMPOSE_WIRING:
        path = ROOT / relative
        if path.is_file() and not pattern.search(path.read_text(encoding="utf-8")):
            errors.append(f"gate Compose non câblée : {relative}")


def check_version_consistency(errors: list[str]) -> None:
    version_path = ROOT / "VERSION"
    if not version_path.is_file():
        return

    version = version_path.read_text(encoding="utf-8").strip()
    if not SEMVER_PATTERN.fullmatch(version):
        errors.append(f"VERSION invalide : {version!r}")
        return

    expectations = (
        ("PROJECT.md", f"| Version | {version} |"),
        ("STATUS.md", f"| Version | `v{version}` |"),
        ("ADOPTION.md", f"- Release courante : `v{version}`"),
    )
    for relative, expected in expectations:
        path = ROOT / relative
        if path.is_file() and expected not in path.read_text(encoding="utf-8"):
            errors.append(
                f"{relative} : version différente de VERSION ({version})"
            )

    changelog = ROOT / "CHANGELOG.md"
    if changelog.is_file():
        text = changelog.read_text(encoding="utf-8")
        first_release = re.search(
            r"(?m)^## ([0-9]+\.[0-9]+\.[0-9]+) - [0-9]{4}-[0-9]{2}-[0-9]{2}$",
            text,
        )
        if not first_release or first_release.group(1) != version:
            errors.append(
                f"CHANGELOG.md : première release différente de VERSION ({version})"
            )


def check_style(path: Path, text: str, errors: list[str]) -> None:
    relative = path.relative_to(ROOT)

    for character, label in FORBIDDEN_DASHES.items():
        for match in re.finditer(character, text):
            errors.append(
                f"{relative}:{line_number(text, match.start())} : {label} interdit"
            )

    if not path.is_relative_to(TEMPLATES):
        for match in re.finditer(r"\bTODO\b", text):
            errors.append(
                f"{relative}:{line_number(text, match.start())} : "
                "marqueur de saisie hors templates"
            )


def mask_fenced_code(text: str) -> str:
    masked: list[str] = []
    active_fence: str | None = None

    for line in text.splitlines(keepends=True):
        match = FENCE_PATTERN.match(line)
        if match:
            marker = match.group(1)
            marker_char = marker[0]
            if active_fence is None:
                active_fence = marker_char
            elif active_fence == marker_char:
                active_fence = None
            masked.append("\n" if line.endswith("\n") else "")
            continue

        if active_fence is not None:
            masked.append("\n" if line.endswith("\n") else "")
        else:
            masked.append(line)

    return "".join(masked)


def github_slug(value: str) -> str:
    value = html.unescape(value)
    value = re.sub(r"!\[([^\]]*)\]\([^)]*\)", r"\1", value)
    value = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", value)
    value = re.sub(r"<[^>]+>", "", value)
    value = re.sub(r"[`*_~]", "", value)
    value = value.strip().lower()

    characters: list[str] = []
    for character in value:
        category = unicodedata.category(character)
        if character in ("-", "_") or character.isspace():
            characters.append(character)
        elif category[0] in ("L", "N", "M"):
            characters.append(character)

    return re.sub(r"\s+", "-", "".join(characters))


def markdown_anchors(path: Path, cache: dict[Path, set[str]]) -> set[str]:
    resolved = path.resolve()
    if resolved in cache:
        return cache[resolved]

    text = resolved.read_text(encoding="utf-8")
    anchors: set[str] = set()
    slug_counts: dict[str, int] = {}
    active_fence: str | None = None

    for line in text.splitlines():
        fence = FENCE_PATTERN.match(line)
        if fence:
            marker_char = fence.group(1)[0]
            if active_fence is None:
                active_fence = marker_char
            elif active_fence == marker_char:
                active_fence = None
            continue
        if active_fence is not None:
            continue

        for explicit in EXPLICIT_ANCHOR_PATTERN.findall(line):
            anchors.add(unquote(explicit).lower())

        heading = HEADING_PATTERN.match(line)
        if not heading:
            continue

        title = heading.group(2)
        explicit_heading = EXPLICIT_HEADING_ID_PATTERN.search(title)
        if explicit_heading:
            anchors.add(unquote(explicit_heading.group(1)).lower())
            title = EXPLICIT_HEADING_ID_PATTERN.sub("", title)

        base_slug = github_slug(title)
        if not base_slug:
            continue
        occurrence = slug_counts.get(base_slug, 0)
        slug_counts[base_slug] = occurrence + 1
        anchors.add(base_slug if occurrence == 0 else f"{base_slug}-{occurrence}")

    cache[resolved] = anchors
    return anchors


def split_link_target(raw_target: str) -> tuple[str, str]:
    target = raw_target.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    target = unquote(target)
    path_part, separator, anchor = target.partition("#")
    path_part = path_part.partition("?")[0]
    return path_part, anchor if separator else ""


def check_links(path: Path, text: str, errors: list[str]) -> None:
    relative = path.relative_to(ROOT)
    anchor_cache: dict[Path, set[str]] = {}
    prose = mask_fenced_code(text)

    for match in LINK_PATTERN.finditer(prose):
        raw_target = match.group("target")
        target_lower = raw_target.lower()
        location = f"{relative}:{line_number(prose, match.start())}"

        if target_lower.startswith(ALLOWED_EXTERNAL_SCHEMES):
            continue
        if URI_SCHEME_PATTERN.match(raw_target):
            errors.append(f"{location} : schéma de lien non autorisé : {raw_target}")
            continue

        target, anchor = split_link_target(raw_target)
        target_path = Path(target) if target else Path(".")
        if target_path.is_absolute() or raw_target.startswith("//"):
            errors.append(f"{location} : lien local absolu interdit : {raw_target}")
            continue

        resolved = (path.parent / target_path).resolve()
        if not resolved.is_relative_to(ROOT):
            errors.append(f"{location} : lien hors du dépôt interdit : {raw_target}")
            continue
        if not resolved.exists():
            if (relative, target) in GENERATED_BOOTSTRAP_LINKS:
                continue
            errors.append(f"{location} : lien local absent : {raw_target}")
            continue

        if not anchor:
            continue
        if not resolved.is_file() or resolved.suffix.lower() not in (".md", ".markdown"):
            errors.append(
                f"{location} : ancre locale sur une cible non Markdown : {raw_target}"
            )
            continue

        normalized_anchor = unquote(anchor).lower()
        if normalized_anchor not in markdown_anchors(resolved, anchor_cache):
            errors.append(f"{location} : ancre locale absente : {raw_target}")


def main() -> int:
    errors: list[str] = []
    files = markdown_files()

    check_required_paths(errors)
    check_executable_paths(errors)
    check_compose_wiring(errors)
    check_version_consistency(errors)

    for path in files:
        text = path.read_text(encoding="utf-8")
        check_style(path, text, errors)
        check_links(path, text, errors)

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1

    print(f"Markdown valide : {len(files)} fichiers")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
