#!/usr/bin/env python3

from __future__ import annotations

import argparse
import difflib
import json
import sys
from pathlib import Path, PurePosixPath
from urllib.parse import quote


if sys.version_info < (3, 9):
    detected = ".".join(str(part) for part in sys.version_info[:3])
    print(
        f"Python >= 3.9 is required. Detected version: {detected}.",
        file=sys.stderr,
    )
    raise SystemExit(2)


ROOT = Path(__file__).resolve().parent.parent
MANIFEST = ROOT / "documentation.json"
CATALOG = ROOT / "DOCUMENTATION-CATALOG.md"
VISIBILITIES = {"public", "internal", "reference", "archive"}


class ManifestError(ValueError):
    pass


def validate_pattern(pattern: object, location: str) -> str:
    if not isinstance(pattern, str) or not pattern:
        raise ManifestError(f"{location} must be a non-empty glob")
    pure = PurePosixPath(pattern)
    if pure.is_absolute() or ".." in pure.parts or "\\" in pattern:
        raise ManifestError(f"{location} resolves outside the repository: {pattern!r}")
    return pattern


def load_manifest() -> dict[str, object]:
    if not MANIFEST.is_file():
        raise ManifestError("documentation.json is missing")
    try:
        data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeError) as error:
        raise ManifestError(f"documentation.json is invalid: {error}") from error

    if not isinstance(data, dict) or data.get("schemaVersion") != 1:
        raise ManifestError("documentation.json must use schemaVersion 1")

    renderer = data.get("renderer")
    if not isinstance(renderer, dict):
        raise ManifestError("renderer must be an object")
    if not isinstance(renderer.get("name"), str) or not renderer["name"].strip():
        raise ManifestError("renderer.name is required")
    if not isinstance(renderer.get("config"), str) or not renderer["config"].strip():
        raise ManifestError("renderer.config is required")

    collections = data.get("collections")
    if not isinstance(collections, list) or not collections:
        raise ManifestError("at least one documentation collection is required")

    identifiers: set[str] = set()
    for index, collection in enumerate(collections):
        location = f"collections[{index}]"
        if not isinstance(collection, dict):
            raise ManifestError(f"{location} must be an object")
        identifier = collection.get("id")
        title = collection.get("title")
        visibility = collection.get("visibility")
        patterns = collection.get("include")
        if not isinstance(identifier, str) or not identifier:
            raise ManifestError(f"{location}.id is required")
        if identifier in identifiers:
            raise ManifestError(f"duplicate collection: {identifier}")
        identifiers.add(identifier)
        if not isinstance(title, str) or not title:
            raise ManifestError(f"{location}.title is required")
        if visibility not in VISIBILITIES:
            raise ManifestError(f"{location}.visibility is invalid")
        if not isinstance(patterns, list) or not patterns:
            raise ManifestError(f"{location}.include must contain globs")
        for pattern_index, pattern in enumerate(patterns):
            validate_pattern(pattern, f"{location}.include[{pattern_index}]")

    ignored = data.get("ignored", [])
    if not isinstance(ignored, list):
        raise ManifestError("ignored must be a list")
    for index, item in enumerate(ignored):
        location = f"ignored[{index}]"
        if not isinstance(item, dict):
            raise ManifestError(f"{location} must be an object")
        validate_pattern(item.get("pattern"), f"{location}.pattern")
        if not isinstance(item.get("reason"), str) or not item["reason"].strip():
            raise ManifestError(f"{location}.reason is required")

    return data


def markdown_files() -> set[Path]:
    return {
        path.resolve()
        for path in ROOT.rglob("*.md")
        if ".git" not in path.relative_to(ROOT).parts
    }


def expand(pattern: str) -> set[Path]:
    return {
        path.resolve()
        for path in ROOT.glob(pattern)
        if path.is_file() and path.suffix.lower() == ".md"
    }


def classify(
    manifest: dict[str, object],
) -> tuple[list[tuple[dict[str, object], list[Path]]], list[tuple[dict[str, str], int]]]:
    files = markdown_files()
    owners: dict[Path, list[str]] = {path: [] for path in files}
    classified: list[tuple[dict[str, object], list[Path]]] = []

    for collection in manifest["collections"]:
        matched: set[Path] = set()
        for pattern in collection["include"]:
            matched.update(expand(pattern))
        for path in matched:
            owners.setdefault(path, []).append(f"collection:{collection['id']}")
        classified.append(
            (
                collection,
                sorted(matched, key=lambda path: path.relative_to(ROOT).as_posix()),
            )
        )

    ignored_counts: list[tuple[dict[str, str], int]] = []
    for item in manifest.get("ignored", []):
        matched = expand(item["pattern"])
        for path in matched:
            owners.setdefault(path, []).append(f"ignored:{item['pattern']}")
        ignored_counts.append((item, len(matched)))

    errors: list[str] = []
    for path in sorted(files, key=lambda value: value.relative_to(ROOT).as_posix()):
        relative = path.relative_to(ROOT).as_posix()
        path_owners = owners.get(path, [])
        if not path_owners:
            errors.append(f"Unclassified Markdown file: {relative}")
        elif len(path_owners) > 1:
            errors.append(
                f"Markdown file classified more than once: {relative} ({', '.join(path_owners)})"
            )

    if errors:
        raise ManifestError("\n".join(errors))
    return classified, ignored_counts


def markdown_link(path: Path) -> str:
    relative = path.relative_to(ROOT).as_posix()
    label = relative.replace("[", "\\[").replace("]", "\\]")
    target = quote(relative, safe="/-._~")
    return f"[{label}]({target})"


def render_catalog(
    manifest: dict[str, object],
    classified: list[tuple[dict[str, object], list[Path]]],
    ignored_counts: list[tuple[dict[str, str], int]],
) -> str:
    renderer = manifest["renderer"]
    lines = [
        "<!-- Generated by scripts/documentation_catalog.py. Do not edit manually. -->",
        "",
        "# Documentation catalog",
        "",
        "This catalog classifies all maintained Markdown files from "
        "`documentation.json`.",
        "",
        f"Declared renderer: `{renderer['name']}`.",
        "",
        "| Collection | Visibility | Files |",
        "| --- | --- | ---: |",
    ]
    for collection, paths in classified:
        lines.append(
            f"| {collection['title']} | `{collection['visibility']}` | {len(paths)} |"
        )

    for collection, paths in classified:
        lines.extend(["", f"## {collection['title']}", ""])
        if paths:
            lines.extend(f"- {markdown_link(path)}" for path in paths)
        else:
            lines.append("- No files.")

    if ignored_counts:
        lines.extend(["", "## Ignored paths", ""])
        lines.append(
            "These paths contain dependencies or generated outputs. They do not "
            "contain maintained documentation sources."
        )
        lines.extend(["", "| Reason | Glob |", "| --- | --- |"])
        for item, _count in ignored_counts:
            lines.append(f"| {item['reason']} | `{item['pattern']}` |")

    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate or verify the catalog of all project Markdown files."
    )
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--json", action="store_true")
    args = parser.parse_args()

    try:
        manifest = load_manifest()
        if args.write and not CATALOG.exists():
            CATALOG.touch()
        classified, ignored_counts = classify(manifest)
        expected = render_catalog(manifest, classified, ignored_counts)
    except ManifestError as error:
        print(error, file=sys.stderr)
        return 1

    if args.json:
        payload = {
            "renderer": manifest["renderer"],
            "collections": [
                {
                    "id": collection["id"],
                    "title": collection["title"],
                    "visibility": collection["visibility"],
                    "files": [
                        path.relative_to(ROOT).as_posix() for path in paths
                    ],
                }
                for collection, paths in classified
            ],
        }
        print(json.dumps(payload, ensure_ascii=False, sort_keys=True))
        return 0

    if args.write:
        CATALOG.write_text(expected, encoding="utf-8")
        count = sum(len(paths) for _collection, paths in classified)
        print(f"Documentation catalog generated: {count} Markdown files.")
        return 0

    if not CATALOG.is_file():
        print("DOCUMENTATION-CATALOG.md is missing. Run with --write.", file=sys.stderr)
        return 1
    current = CATALOG.read_text(encoding="utf-8")
    if current != expected:
        print("DOCUMENTATION-CATALOG.md is outdated:", file=sys.stderr)
        print(
            "".join(
                difflib.unified_diff(
                    current.splitlines(keepends=True),
                    expected.splitlines(keepends=True),
                    fromfile="DOCUMENTATION-CATALOG.md",
                    tofile="expected catalog",
                )
            ),
            file=sys.stderr,
        )
        return 1
    print("Documentation catalog is valid.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
