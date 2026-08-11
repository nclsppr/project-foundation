#!/usr/bin/env python3
"""Check and update a vendored Project Foundation release."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from typing import NoReturn, Sequence
from urllib.parse import urlsplit


MINIMUM_PYTHON = (3, 9)
TAG_PATTERN = re.compile(
    r"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$"
)
SHA_PATTERN = re.compile(r"^[0-9a-f]{40}(?:[0-9a-f]{24})?$")
PACKS = {"minimal", "standard", "full", "critical"}
LOCK_NAME = "foundation.lock.json"
DISTRIBUTION_NAME = "foundation-distribution.json"
OFFICIAL_SOURCE = "https://github.com/nclsppr/project-foundation.git"
GIT_TIMEOUT_SECONDS = 60


class SyncError(Exception):
    """A controlled synchronization failure."""


@dataclass(frozen=True)
class Release:
    tag: str
    commit: str

    @property
    def precedence(self) -> tuple[int, int, int]:
        match = TAG_PATTERN.fullmatch(self.tag)
        if match is None:
            raise SyncError(f"Invalid release tag: {self.tag}")
        return tuple(int(value) for value in match.groups())


@dataclass(frozen=True)
class FileEntry:
    source: str
    target: str
    sha256: str


@dataclass(frozen=True)
class Lock:
    source: str
    release: Release
    pack: str
    profiles: tuple[str, ...]
    snapshot: tuple[FileEntry, ...]
    managed: tuple[FileEntry, ...]


def fail(message: str, code: int = 1) -> NoReturn:
    print(f"Foundation synchronization failed: {message}", file=sys.stderr)
    raise SystemExit(code)


def project_root_from_script() -> Path:
    return Path(__file__).resolve().parent.parent


def safe_relative_path(value: object, label: str) -> str:
    if not isinstance(value, str) or not value:
        raise SyncError(f"{label} must be a non-empty relative path.")
    if "\\" in value or "\x00" in value or "\n" in value or "\r" in value:
        raise SyncError(f"{label} contains an invalid character: {value!r}")
    path = PurePosixPath(value)
    if path.is_absolute() or any(part in ("", ".", "..") for part in path.parts):
        raise SyncError(f"{label} is not a safe relative path: {value!r}")
    if ".git" in path.parts:
        raise SyncError(f"{label} must not address Git metadata: {value!r}")
    return value


def validate_source(value: object) -> str:
    if not isinstance(value, str) or not value:
        raise SyncError("The Foundation source is missing.")
    if value.startswith("-") or any(character in value for character in ("\x00", "\n", "\r", "`", "|")):
        raise SyncError("The Foundation source contains an invalid character.")
    parsed = urlsplit(value)
    if parsed.username is not None or parsed.password is not None:
        raise SyncError("The Foundation source must not contain credentials.")
    return value


def trusted_source() -> str:
    configured = os.environ.get("PROJECT_FOUNDATION_TRUSTED_SOURCE", OFFICIAL_SOURCE)
    return validate_source(configured)


def require_trusted_source(source: str) -> None:
    expected = trusted_source()
    if source != expected:
        raise SyncError(
            f"The recorded Foundation source is not trusted. Expected: {expected}"
        )


def validate_tag(value: object) -> str:
    if not isinstance(value, str) or TAG_PATTERN.fullmatch(value) is None:
        raise SyncError(f"Invalid Foundation release tag: {value!r}")
    return value


def validate_sha(value: object, label: str = "commit") -> str:
    if not isinstance(value, str) or SHA_PATTERN.fullmatch(value) is None:
        raise SyncError(f"Invalid Foundation {label}: {value!r}")
    return value


def validate_profile(value: object) -> str:
    if not isinstance(value, str) or re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", value) is None:
        raise SyncError(f"Invalid Foundation profile: {value!r}")
    return value


def validate_hash(value: object) -> str:
    if not isinstance(value, str) or re.fullmatch(r"[0-9a-f]{64}", value) is None:
        raise SyncError(f"Invalid SHA-256 value: {value!r}")
    return value


def parse_file_entries(value: object, label: str) -> tuple[FileEntry, ...]:
    if not isinstance(value, list) or not value:
        raise SyncError(f"{label} must be a non-empty list.")
    entries: list[FileEntry] = []
    targets: set[str] = set()
    for index, raw_entry in enumerate(value):
        if not isinstance(raw_entry, dict) or set(raw_entry) != {"source", "target", "sha256"}:
            raise SyncError(f"{label}[{index}] has an invalid structure.")
        source = safe_relative_path(raw_entry["source"], f"{label}[{index}].source")
        target = safe_relative_path(raw_entry["target"], f"{label}[{index}].target")
        if target in targets:
            raise SyncError(f"Duplicate Foundation target: {target}")
        targets.add(target)
        entries.append(FileEntry(source, target, validate_hash(raw_entry["sha256"])))
    return tuple(sorted(entries, key=lambda entry: entry.target))


def read_json(path: Path, label: str) -> object:
    if path.is_symlink():
        raise SyncError(f"{label} must not be a symbolic link: {path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as error:
        raise SyncError(f"{label} is missing: {path}") from error
    except (OSError, UnicodeError, json.JSONDecodeError) as error:
        raise SyncError(f"Cannot read {label}: {error}") from error


def read_lock(root: Path) -> Lock:
    raw = read_json(root / LOCK_NAME, "Foundation lock")
    if not isinstance(raw, dict) or set(raw) != {
        "schemaVersion",
        "source",
        "release",
        "pack",
        "profiles",
        "snapshot",
        "managed",
    }:
        raise SyncError("The Foundation lock has an invalid structure.")
    if raw["schemaVersion"] != 1:
        raise SyncError(f"Unsupported Foundation lock schema: {raw['schemaVersion']!r}")
    release_raw = raw["release"]
    if not isinstance(release_raw, dict) or set(release_raw) != {"tag", "commit"}:
        raise SyncError("The Foundation release lock has an invalid structure.")
    pack = raw["pack"]
    if pack not in PACKS:
        raise SyncError(f"Invalid adopted pack: {pack!r}")
    raw_profiles = raw["profiles"]
    if not isinstance(raw_profiles, list) or not raw_profiles:
        raise SyncError("The Foundation profile list is empty.")
    profiles = tuple(sorted(validate_profile(item) for item in raw_profiles))
    if len(set(profiles)) != len(profiles):
        raise SyncError("The Foundation profile list contains a duplicate.")
    if "documentation-nimbus" not in profiles:
        raise SyncError("The mandatory documentation-nimbus profile is missing.")
    snapshot = parse_file_entries(raw["snapshot"], "snapshot")
    managed = parse_file_entries(raw["managed"], "managed")
    overlap = {entry.target for entry in snapshot} & {entry.target for entry in managed}
    if overlap:
        raise SyncError(f"Foundation targets overlap: {', '.join(sorted(overlap))}")
    return Lock(
        source=validate_source(raw["source"]),
        release=Release(
            validate_tag(release_raw["tag"]),
            validate_sha(release_raw["commit"]),
        ),
        pack=pack,
        profiles=profiles,
        snapshot=snapshot,
        managed=managed,
    )


def lock_payload(lock: Lock) -> dict[str, object]:
    def entries(items: tuple[FileEntry, ...]) -> list[dict[str, str]]:
        return [
            {"source": item.source, "target": item.target, "sha256": item.sha256}
            for item in sorted(items, key=lambda entry: entry.target)
        ]

    return {
        "schemaVersion": 1,
        "source": lock.source,
        "release": {"tag": lock.release.tag, "commit": lock.release.commit},
        "pack": lock.pack,
        "profiles": list(sorted(lock.profiles)),
        "snapshot": entries(lock.snapshot),
        "managed": entries(lock.managed),
    }


def write_lock(root: Path, lock: Lock) -> None:
    path = root / LOCK_NAME
    payload = json.dumps(lock_payload(lock), ensure_ascii=False, indent=2) + "\n"
    atomic_write(path, payload.encode("utf-8"), 0o644)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    try:
        with path.open("rb") as stream:
            for block in iter(lambda: stream.read(1024 * 1024), b""):
                digest.update(block)
    except OSError as error:
        raise SyncError(f"Cannot hash {path}: {error}") from error
    return digest.hexdigest()


def controlled_path(root: Path, relative: str, label: str) -> Path:
    root = root.resolve()
    current = root
    for part in PurePosixPath(relative).parts:
        current = current / part
        if current.is_symlink():
            raise SyncError(f"{label} must not use a symbolic link: {relative}")
    if not current.resolve(strict=False).is_relative_to(root):
        raise SyncError(f"{label} leaves the controlled root: {relative}")
    return current


def verify_integrity(root: Path, lock: Lock) -> None:
    errors: list[str] = []
    for entry in (*lock.snapshot, *lock.managed):
        path = controlled_path(root, entry.target, "Foundation target")
        if not path.is_file():
            errors.append(f"managed file is missing: {entry.target}")
            continue
        actual = sha256(path)
        if actual != entry.sha256:
            errors.append(f"managed file differs from the adopted release: {entry.target}")
    if errors:
        raise SyncError("; ".join(errors))


def foundation_projection(root: Path, lock: Lock) -> None:
    path = root / "FOUNDATION.md"
    if path.is_symlink():
        raise SyncError("FOUNDATION.md must not be a symbolic link.")
    try:
        text = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        raise SyncError(f"Cannot read FOUNDATION.md: {error}") from error
    expected_lines = (
        f"| Source | `{lock.source}` |",
        f"| Readable version | `{lock.release.tag}` |",
        f"| Immutable commit | `{lock.release.commit}` |",
        f"| Adopted pack | `{lock.pack}` |",
    )
    for line in expected_lines:
        if line not in text:
            raise SyncError(f"FOUNDATION.md differs from {LOCK_NAME}: {line}")
    section = re.search(
        r"(?ms)^## Activated profiles\s*$\n(?P<body>.*?)(?=^##\s|\Z)", text
    )
    if section is None:
        raise SyncError("FOUNDATION.md has no Activated profiles section.")
    declared = set(re.findall(r"(?m)^- `([a-z0-9-]+)`\s*$", section.group("body")))
    if declared != set(lock.profiles):
        raise SyncError(f"FOUNDATION.md profiles differ from {LOCK_NAME}.")


def run_git(
    arguments: Sequence[str],
    cwd: Path | None = None,
    allowed_returncodes: tuple[int, ...] = (0,),
) -> str:
    environment = os.environ.copy()
    environment["GIT_TERMINAL_PROMPT"] = "0"
    try:
        result = subprocess.run(
            ["git", *arguments],
            cwd=cwd,
            env=environment,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding="utf-8",
            timeout=GIT_TIMEOUT_SECONDS,
        )
    except FileNotFoundError as error:
        raise SyncError("Git is required for Foundation synchronization.") from error
    except OSError as error:
        raise SyncError(f"Cannot run Git: {error}") from error
    except subprocess.TimeoutExpired as error:
        raise SyncError(
            f"Git command timed out after {GIT_TIMEOUT_SECONDS} seconds."
        ) from error
    if result.returncode not in allowed_returncodes:
        detail = result.stderr.strip() or result.stdout.strip() or "unknown Git error"
        raise SyncError(detail)
    return result.stdout


def remote_releases(source: str) -> dict[str, Release]:
    output = run_git(["ls-remote", "--tags", source])
    direct: dict[str, str] = {}
    peeled: dict[str, str] = {}
    for line in output.splitlines():
        fields = line.split("\t", 1)
        if len(fields) != 2:
            continue
        object_sha, reference = fields
        prefix = "refs/tags/"
        if not reference.startswith(prefix):
            continue
        name = reference[len(prefix) :]
        is_peeled = name.endswith("^{}")
        tag = name[:-3] if is_peeled else name
        if TAG_PATTERN.fullmatch(tag) is None or SHA_PATTERN.fullmatch(object_sha) is None:
            continue
        (peeled if is_peeled else direct)[tag] = object_sha
    releases = {
        tag: Release(tag, peeled[tag])
        for tag in direct
        if tag in peeled
    }
    if not releases:
        raise SyncError(
            "The Foundation source has no stable annotated vMAJOR.MINOR.PATCH tag."
        )
    return releases


def resolve_current_and_latest(lock: Lock) -> tuple[Release, Release]:
    releases = remote_releases(lock.source)
    current = releases.get(lock.release.tag)
    if current is None:
        raise SyncError(f"The adopted release is absent from the source: {lock.release.tag}")
    if current.commit != lock.release.commit:
        raise SyncError(
            f"Release tag {lock.release.tag} moved from {lock.release.commit} to {current.commit}."
        )
    latest = max(releases.values(), key=lambda release: release.precedence)
    if lock.release.precedence > latest.precedence:
        raise SyncError(
            f"The adopted release {lock.release.tag} is newer than source release {latest.tag}."
        )
    return current, latest


def read_distribution(upstream_root: Path) -> tuple[list[tuple[str, str]], list[tuple[str, str]], tuple[str, str]]:
    raw = read_json(upstream_root / DISTRIBUTION_NAME, "Foundation distribution manifest")
    if not isinstance(raw, dict) or set(raw) != {
        "schemaVersion",
        "snapshotFiles",
        "managedFiles",
        "profile",
    }:
        raise SyncError("The Foundation distribution manifest has an invalid structure.")
    if raw["schemaVersion"] != 1:
        raise SyncError(f"Unsupported Foundation distribution schema: {raw['schemaVersion']!r}")

    def mappings(value: object, label: str) -> list[tuple[str, str]]:
        if not isinstance(value, list) or not value:
            raise SyncError(f"{label} must be a non-empty list.")
        result: list[tuple[str, str]] = []
        for index, item in enumerate(value):
            if not isinstance(item, dict) or set(item) != {"source", "target"}:
                raise SyncError(f"{label}[{index}] has an invalid structure.")
            result.append(
                (
                    safe_relative_path(item["source"], f"{label}[{index}].source"),
                    safe_relative_path(item["target"], f"{label}[{index}].target"),
                )
            )
        return result

    profile = raw["profile"]
    if not isinstance(profile, dict) or set(profile) != {"sourcePattern", "targetPattern"}:
        raise SyncError("The Foundation profile mapping has an invalid structure.")
    source_pattern = profile["sourcePattern"]
    target_pattern = profile["targetPattern"]
    if not isinstance(source_pattern, str) or not isinstance(target_pattern, str):
        raise SyncError("The Foundation profile patterns must be strings.")
    if source_pattern.count("{profile}") != 1 or target_pattern.count("{profile}") != 1:
        raise SyncError("Each Foundation profile pattern must contain one {profile} marker.")
    return (
        mappings(raw["snapshotFiles"], "snapshotFiles"),
        mappings(raw["managedFiles"], "managedFiles"),
        (source_pattern, target_pattern),
    )


def expanded_distribution(upstream_root: Path, profiles: tuple[str, ...]) -> tuple[list[tuple[str, str]], list[tuple[str, str]]]:
    snapshot, managed, profile_pattern = read_distribution(upstream_root)
    for profile in profiles:
        snapshot.append(
            (
                safe_relative_path(
                    profile_pattern[0].replace("{profile}", profile), "profile source"
                ),
                safe_relative_path(
                    profile_pattern[1].replace("{profile}", profile), "profile target"
                ),
            )
        )
    all_targets = [target for _, target in (*snapshot, *managed)]
    if len(all_targets) != len(set(all_targets)):
        raise SyncError("The Foundation distribution contains duplicate targets.")
    for source, _ in (*snapshot, *managed):
        source_path = controlled_path(upstream_root, source, "distribution source")
        if not source_path.is_file():
            raise SyncError(f"The Foundation release is missing a distribution source: {source}")
    return snapshot, managed


def entries_from_project(root: Path, mappings: list[tuple[str, str]]) -> tuple[FileEntry, ...]:
    entries: list[FileEntry] = []
    for source, target in mappings:
        path = controlled_path(root, target, "Foundation target")
        if not path.is_file():
            raise SyncError(f"The project is missing a Foundation target: {target}")
        entries.append(FileEntry(source, target, sha256(path)))
    return tuple(sorted(entries, key=lambda entry: entry.target))


def entries_from_release(
    upstream_root: Path, mappings: list[tuple[str, str]]
) -> tuple[FileEntry, ...]:
    entries: list[FileEntry] = []
    for source, target in mappings:
        source_path = controlled_path(upstream_root, source, "distribution source")
        if not source_path.is_file():
            raise SyncError(f"The Foundation release is missing a distribution source: {source}")
        entries.append(FileEntry(source, target, sha256(source_path)))
    return tuple(sorted(entries, key=lambda entry: entry.target))


def verify_lock_against_release(root: Path, lock: Lock, upstream_root: Path) -> None:
    snapshot_mapping, managed_mapping = expanded_distribution(upstream_root, lock.profiles)
    expected_snapshot = entries_from_release(upstream_root, snapshot_mapping)
    expected_managed = entries_from_release(upstream_root, managed_mapping)
    if lock.snapshot != expected_snapshot:
        raise SyncError(
            "The snapshot entries in foundation.lock.json differ from the adopted release."
        )
    if lock.managed != expected_managed:
        raise SyncError(
            "The managed entries in foundation.lock.json differ from the adopted release."
        )
    verify_integrity(root, lock)


def atomic_write(path: Path, content: bytes, mode: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary_name = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "wb") as stream:
            stream.write(content)
            stream.flush()
            os.fsync(stream.fileno())
        os.chmod(temporary, mode & 0o777)
        os.replace(temporary, path)
    except Exception:
        temporary.unlink(missing_ok=True)
        raise


def copy_release_file(source: Path, destination: Path) -> None:
    if source.is_symlink():
        raise SyncError(f"A release file must not be a symbolic link: {source}")
    try:
        content = source.read_bytes()
        mode = source.stat().st_mode
    except OSError as error:
        raise SyncError(f"Cannot read release file {source}: {error}") from error
    atomic_write(destination, content, mode)


def clone_release(source: str, release: Release, destination: Path) -> None:
    run_git(
        [
            "clone",
            "--quiet",
            "--depth",
            "1",
            "--branch",
            release.tag,
            "--single-branch",
            source,
            str(destination),
        ]
    )
    actual = run_git(["rev-parse", "HEAD"], cwd=destination).strip()
    if actual != release.commit:
        raise SyncError(
            f"Cloned release {release.tag} resolved to {actual}, expected {release.commit}."
        )
    try:
        declared_version = (destination / "VERSION").read_text(encoding="utf-8").strip()
    except (OSError, UnicodeError) as error:
        raise SyncError(f"Cannot read the release VERSION file: {error}") from error
    if f"v{declared_version}" != release.tag:
        raise SyncError(
            f"Release {release.tag} differs from its VERSION file ({declared_version!r})."
        )


def update_foundation_projection(root: Path, release: Release) -> None:
    path = root / "FOUNDATION.md"
    if path.is_symlink():
        raise SyncError("FOUNDATION.md must not be a symbolic link.")
    try:
        text = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        raise SyncError(f"Cannot read FOUNDATION.md: {error}") from error
    replacements = (
        (
            r"(?m)^\| Readable version \| `v[0-9]+\.[0-9]+\.[0-9]+` \|$",
            f"| Readable version | `{release.tag}` |",
        ),
        (
            r"(?m)^\| Immutable commit \| `[0-9a-f]{40}(?:[0-9a-f]{24})?` \|$",
            f"| Immutable commit | `{release.commit}` |",
        ),
    )
    for pattern, replacement in replacements:
        text, count = re.subn(pattern, replacement, text, count=1)
        if count != 1:
            raise SyncError(f"Cannot update FOUNDATION.md field: {replacement}")
    atomic_write(path, text.encode("utf-8"), path.stat().st_mode)


def initialize_lock(args: argparse.Namespace, root: Path) -> None:
    source = validate_source(args.source)
    require_trusted_source(source)
    release = Release(validate_tag(args.tag), validate_sha(args.commit))
    if args.pack not in PACKS:
        raise SyncError(f"Invalid adopted pack: {args.pack!r}")
    profiles = tuple(sorted(validate_profile(item) for item in args.profiles.split(",") if item))
    if not profiles or "documentation-nimbus" not in profiles:
        raise SyncError("The mandatory documentation-nimbus profile is missing.")
    upstream_root = Path(args.upstream_root).resolve()
    snapshot_mapping, managed_mapping = expanded_distribution(upstream_root, profiles)
    lock = Lock(
        source=source,
        release=release,
        pack=args.pack,
        profiles=profiles,
        snapshot=entries_from_project(root, snapshot_mapping),
        managed=entries_from_project(root, managed_mapping),
    )
    releases = remote_releases(source)
    remote = releases.get(release.tag)
    if remote is None or remote.commit != release.commit:
        raise SyncError("The bootstrap release tag and commit do not match the source.")
    upstream_commit = run_git(["rev-parse", "HEAD"], cwd=upstream_root).strip()
    if upstream_commit != release.commit:
        raise SyncError("The bootstrap source worktree does not match the release commit.")
    verify_lock_against_release(root, lock, upstream_root)
    write_lock(root, lock)
    foundation_projection(root, lock)
    print(f"Foundation lock initialized at {release.tag} ({release.commit}).")


def check(root: Path) -> tuple[Lock, Release]:
    lock = read_lock(root)
    require_trusted_source(lock.source)
    verify_integrity(root, lock)
    foundation_projection(root, lock)
    current, latest = resolve_current_and_latest(lock)
    with tempfile.TemporaryDirectory(prefix="project-foundation-check-") as temporary:
        upstream_root = Path(temporary) / "release"
        clone_release(lock.source, current, upstream_root)
        verify_lock_against_release(root, lock, upstream_root)
    if lock.release.precedence < latest.precedence:
        raise SyncError(
            f"Project Foundation {lock.release.tag} is obsolete. Latest stable release: {latest.tag}."
        )
    print(f"Project Foundation is current: {lock.release.tag} ({lock.release.commit}).")
    return lock, latest


def apply_update(root: Path) -> bool:
    lock = read_lock(root)
    require_trusted_source(lock.source)
    verify_integrity(root, lock)
    foundation_projection(root, lock)
    current, latest = resolve_current_and_latest(lock)
    with tempfile.TemporaryDirectory(prefix="project-foundation-update-") as temporary:
        current_root = Path(temporary) / "current"
        clone_release(lock.source, current, current_root)
        verify_lock_against_release(root, lock, current_root)
        if lock.release.precedence == latest.precedence:
            print(f"Project Foundation is current: {lock.release.tag} ({lock.release.commit}).")
            return False

        upstream_root = Path(temporary) / "latest"
        clone_release(lock.source, latest, upstream_root)
        snapshot_mapping, managed_mapping = expanded_distribution(
            upstream_root, lock.profiles
        )
        new_targets = {target for _, target in (*snapshot_mapping, *managed_mapping)}
        old_targets = {entry.target for entry in (*lock.snapshot, *lock.managed)}
        removed = old_targets - new_targets
        if removed:
            raise SyncError(
                "The release removes managed targets and requires a manual migration: "
                + ", ".join(sorted(removed))
            )
        for _, target in (*snapshot_mapping, *managed_mapping):
            destination = controlled_path(root, target, "Foundation target")
            if target not in old_targets and (destination.exists() or destination.is_symlink()):
                raise SyncError(f"A new Foundation target collides with a local path: {target}")
        for source, target in (*snapshot_mapping, *managed_mapping):
            source_path = controlled_path(upstream_root, source, "distribution source")
            destination = controlled_path(root, target, "Foundation target")
            copy_release_file(source_path, destination)
        update_foundation_projection(root, latest)
        updated = Lock(
            source=lock.source,
            release=latest,
            pack=lock.pack,
            profiles=lock.profiles,
            snapshot=entries_from_project(root, snapshot_mapping),
            managed=entries_from_project(root, managed_mapping),
        )
        write_lock(root, updated)
        verify_integrity(root, updated)
        foundation_projection(root, updated)

    print(f"Project Foundation updated from {lock.release.tag} to {latest.tag}.")
    print("Review the complete diff and the Foundation changelog.")
    print("Apply required project adaptations, update the project changelog, and run verification.")
    return True


def hook_status(root: Path) -> None:
    git_root = Path(run_git(["rev-parse", "--show-toplevel"], cwd=root).strip()).resolve()
    if git_root != root.resolve():
        raise SyncError(f"The project must be the Git repository root: {root}")
    configured = run_git(
        ["config", "--local", "--get", "core.hooksPath"],
        cwd=root,
        allowed_returncodes=(0, 1),
    ).strip()
    if configured != ".githooks":
        raise SyncError(
            "The Foundation hook is not active. Run ./scripts/install_foundation_hook.sh."
        )
    hook = root / ".githooks" / "pre-commit"
    if not hook.is_file() or not os.access(hook, os.X_OK):
        raise SyncError("The Foundation pre-commit hook is missing or not executable.")
    print("Foundation pre-commit hook is active.")


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="command", required=True)
    subparsers.add_parser("check", help="Fail unless the adopted release is current and intact.")
    subparsers.add_parser("update", help="Update managed Foundation files to the latest stable release.")
    subparsers.add_parser(
        "enforce",
        help="Check the release and prepare an update when it is obsolete.",
    )
    subparsers.add_parser("hook-status", help="Verify the local pre-commit hook configuration.")
    initialize = subparsers.add_parser("init-lock", help=argparse.SUPPRESS)
    initialize.add_argument("--source", required=True)
    initialize.add_argument("--tag", required=True)
    initialize.add_argument("--commit", required=True)
    initialize.add_argument("--pack", required=True)
    initialize.add_argument("--profiles", required=True)
    initialize.add_argument("--upstream-root", required=True)
    return result


def main() -> int:
    if sys.version_info < MINIMUM_PYTHON:
        detected = ".".join(str(part) for part in sys.version_info[:3])
        fail(f"Python >= 3.9 is required. Detected version: {detected}.", 2)
    arguments = parser().parse_args()
    root = project_root_from_script()
    try:
        if arguments.command == "check":
            check(root)
        elif arguments.command == "update":
            apply_update(root)
        elif arguments.command == "enforce":
            if apply_update(root):
                print("The commit is blocked. Review and stage the Foundation update first.", file=sys.stderr)
                return 3
        elif arguments.command == "hook-status":
            hook_status(root)
        elif arguments.command == "init-lock":
            initialize_lock(arguments, root)
        else:
            raise SyncError(f"Unknown command: {arguments.command}")
    except SyncError as error:
        fail(str(error))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
