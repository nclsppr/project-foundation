#!/usr/bin/env python3
"""Integration tests for the Project Foundation release synchronizer."""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SYNC_SOURCE = Path(__file__).with_name("foundation_sync.py")


class FoundationSyncTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory(prefix="foundation-sync-test-")
        self.root = Path(self.temporary.name)
        self.upstream = self.root / "upstream"
        self.project = self.root / "project"
        self.upstream.mkdir()
        self.project.mkdir()
        self.git("init", "-q", "-b", "main", cwd=self.upstream)
        self.git("config", "user.name", "Foundation Tests", cwd=self.upstream)
        self.git(
            "config",
            "user.email",
            "foundation-tests@example.invalid",
            cwd=self.upstream,
        )
        self.write_release("1.0.0", "Principle version one.\n", "Control version one.\n")
        self.release_one = self.commit_and_tag("v1.0.0")
        self.create_project(self.release_one)
        self.write_release("1.1.0", "Principle version two.\n", "Control version two.\n")
        self.release_two = self.commit_and_tag("v1.1.0")

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def command(
        self,
        *arguments: str,
        cwd: Path | None = None,
        expected: int = 0,
    ) -> subprocess.CompletedProcess[str]:
        result = subprocess.run(
            list(arguments),
            cwd=cwd,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding="utf-8",
            env={
                **os.environ,
                "GIT_TERMINAL_PROMPT": "0",
                "PROJECT_FOUNDATION_TRUSTED_SOURCE": str(self.upstream),
            },
        )
        self.assertEqual(
            expected,
            result.returncode,
            msg=(
                f"Command returned {result.returncode}, expected {expected}: {arguments}\n"
                f"stdout:\n{result.stdout}\nstderr:\n{result.stderr}"
            ),
        )
        return result

    def git(self, *arguments: str, cwd: Path) -> str:
        return self.command("git", *arguments, cwd=cwd).stdout.strip()

    def write(self, root: Path, relative: str, content: str, executable: bool = False) -> None:
        path = root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        if executable:
            path.chmod(0o755)

    def distribution(self, extra_managed: list[dict[str, str]] | None = None) -> dict[str, object]:
        managed = [
            {
                "source": "scripts/foundation_sync.py",
                "target": "scripts/foundation_sync.py",
            },
            {
                "source": "managed/control.txt",
                "target": ".foundation/control.txt",
            },
        ]
        if extra_managed:
            managed.extend(extra_managed)
        return {
            "schemaVersion": 1,
            "snapshotFiles": [
                {
                    "source": "PRINCIPLES.md",
                    "target": "docs/foundation/PRINCIPLES.md",
                },
                {
                    "source": "DEFAULTS.md",
                    "target": "docs/foundation/DEFAULTS.md",
                },
                {
                    "source": "DEFINITION-OF-DONE.md",
                    "target": "docs/foundation/DEFINITION-OF-DONE.md",
                },
            ],
            "managedFiles": managed,
            "profile": {
                "sourcePattern": "profiles/{profile}.md",
                "targetPattern": "docs/foundation/profiles/{profile}.md",
            },
        }

    def write_release(
        self,
        version: str,
        principle: str,
        control: str,
        extra_managed: list[dict[str, str]] | None = None,
    ) -> None:
        self.write(self.upstream, "VERSION", f"{version}\n")
        self.write(self.upstream, "PRINCIPLES.md", principle)
        self.write(self.upstream, "DEFAULTS.md", f"Defaults for {version}.\n")
        self.write(
            self.upstream,
            "DEFINITION-OF-DONE.md",
            f"Definition for {version}.\n",
        )
        self.write(
            self.upstream,
            "profiles/documentation-nimbus.md",
            f"Nimbus profile for {version}.\n",
        )
        self.write(self.upstream, "managed/control.txt", control)
        (self.upstream / "scripts").mkdir(parents=True, exist_ok=True)
        shutil.copy2(SYNC_SOURCE, self.upstream / "scripts/foundation_sync.py")
        (self.upstream / "scripts/foundation_sync.py").chmod(0o755)
        self.write(
            self.upstream,
            "foundation-distribution.json",
            json.dumps(self.distribution(extra_managed), indent=2) + "\n",
        )

    def commit_and_tag(self, tag: str) -> str:
        self.git("add", "--all", cwd=self.upstream)
        self.git("commit", "-q", "-m", f"Release {tag}", cwd=self.upstream)
        self.git("tag", "-a", tag, "-m", f"Release {tag}", cwd=self.upstream)
        return self.git("rev-parse", "HEAD", cwd=self.upstream)

    def create_project(self, commit: str) -> None:
        mappings = [
            ("PRINCIPLES.md", "docs/foundation/PRINCIPLES.md"),
            ("DEFAULTS.md", "docs/foundation/DEFAULTS.md"),
            ("DEFINITION-OF-DONE.md", "docs/foundation/DEFINITION-OF-DONE.md"),
            (
                "profiles/documentation-nimbus.md",
                "docs/foundation/profiles/documentation-nimbus.md",
            ),
            ("scripts/foundation_sync.py", "scripts/foundation_sync.py"),
            ("managed/control.txt", ".foundation/control.txt"),
        ]
        for source, target in mappings:
            destination = self.project / target
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(self.upstream / source, destination)
        self.write(
            self.project,
            "FOUNDATION.md",
            "\n".join(
                (
                    "# FOUNDATION.md",
                    "",
                    "## Version",
                    "",
                    "| Field | Value |",
                    "| --- | --- |",
                    f"| Source | `{self.upstream}` |",
                    "| Readable version | `v1.0.0` |",
                    f"| Immutable commit | `{commit}` |",
                    "| Adopted pack | `minimal` |",
                    "| Adopted on | 2026-08-11 |",
                    "| Adopted by | test |",
                    "",
                    "## Activated profiles",
                    "",
                    "- `documentation-nimbus`",
                    "",
                    "## Exceptions",
                    "",
                    "None.",
                    "",
                )
            ),
        )
        self.write(self.project, "local.txt", "Preserve this local file.\n")
        self.command(
            sys.executable,
            str(self.project / "scripts/foundation_sync.py"),
            "init-lock",
            "--source",
            str(self.upstream),
            "--tag",
            "v1.0.0",
            "--commit",
            commit,
            "--pack",
            "minimal",
            "--profiles",
            "documentation-nimbus",
            "--upstream-root",
            str(self.upstream),
            cwd=self.project,
        )

    def sync(self, command: str, expected: int = 0) -> subprocess.CompletedProcess[str]:
        return self.command(
            sys.executable,
            str(self.project / "scripts/foundation_sync.py"),
            command,
            cwd=self.project,
            expected=expected,
        )

    def test_obsolete_release_is_rejected(self) -> None:
        result = self.sync("check", expected=1)
        self.assertIn("v1.0.0 is obsolete", result.stderr)
        self.assertIn("v1.1.0", result.stderr)

    def test_update_replaces_only_managed_content(self) -> None:
        self.sync("update")
        self.assertEqual(
            "Principle version two.\n",
            (self.project / "docs/foundation/PRINCIPLES.md").read_text(encoding="utf-8"),
        )
        self.assertEqual(
            "Control version two.\n",
            (self.project / ".foundation/control.txt").read_text(encoding="utf-8"),
        )
        self.assertEqual(
            "Preserve this local file.\n",
            (self.project / "local.txt").read_text(encoding="utf-8"),
        )
        lock = json.loads((self.project / "foundation.lock.json").read_text(encoding="utf-8"))
        self.assertEqual("v1.1.0", lock["release"]["tag"])
        self.assertEqual(self.release_two, lock["release"]["commit"])
        self.sync("check")

    def test_enforce_prepares_update_and_blocks_commit(self) -> None:
        result = self.sync("enforce", expected=3)
        self.assertIn("commit is blocked", result.stderr)
        foundation = (self.project / "FOUNDATION.md").read_text(encoding="utf-8")
        self.assertIn("| Readable version | `v1.1.0` |", foundation)

    def test_snapshot_drift_is_rejected(self) -> None:
        path = self.project / "docs/foundation/PRINCIPLES.md"
        path.write_text("Local drift.\n", encoding="utf-8")
        result = self.sync("check", expected=1)
        self.assertIn("differs from the adopted release", result.stderr)

    def test_recalculated_local_hash_is_rejected_against_release(self) -> None:
        path = self.project / "docs/foundation/PRINCIPLES.md"
        path.write_text("Locally rewritten rule.\n", encoding="utf-8")
        lock_path = self.project / "foundation.lock.json"
        lock = json.loads(lock_path.read_text(encoding="utf-8"))
        for entry in lock["snapshot"]:
            if entry["target"] == "docs/foundation/PRINCIPLES.md":
                entry["sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
        lock_path.write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")
        result = self.sync("check", expected=1)
        self.assertIn("differ from the adopted release", result.stderr)

    def test_symbolic_link_snapshot_is_rejected(self) -> None:
        path = self.project / "docs/foundation/PRINCIPLES.md"
        path.unlink()
        path.symlink_to(self.project / "local.txt")
        result = self.sync("check", expected=1)
        self.assertIn("must not use a symbolic link", result.stderr)

    def test_unavailable_source_is_rejected(self) -> None:
        unavailable = self.root / "unavailable"
        self.upstream.rename(unavailable)
        result = self.sync("check", expected=1)
        self.assertIn("does not appear to be a git repository", result.stderr)

    def test_lock_cannot_change_the_trusted_source(self) -> None:
        replacement = str(self.root / "other-source")
        lock_path = self.project / "foundation.lock.json"
        lock = json.loads(lock_path.read_text(encoding="utf-8"))
        lock["source"] = replacement
        lock_path.write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")
        foundation_path = self.project / "FOUNDATION.md"
        foundation = foundation_path.read_text(encoding="utf-8").replace(
            f"| Source | `{self.upstream}` |",
            f"| Source | `{replacement}` |",
        )
        foundation_path.write_text(foundation, encoding="utf-8")
        result = self.sync("check", expected=1)
        self.assertIn("recorded Foundation source is not trusted", result.stderr)

    def test_moved_tag_is_rejected(self) -> None:
        self.sync("update")
        self.write(self.upstream, "moved.txt", "Moved tag target.\n")
        self.git("add", "moved.txt", cwd=self.upstream)
        self.git("commit", "-q", "-m", "Move release target", cwd=self.upstream)
        self.git(
            "tag",
            "-f",
            "-a",
            "v1.1.0",
            "-m",
            "Moved release",
            cwd=self.upstream,
        )
        result = self.sync("check", expected=1)
        self.assertIn("Release tag v1.1.0 moved", result.stderr)

    def test_new_managed_target_collision_is_rejected(self) -> None:
        self.write(self.upstream, "managed/new.txt", "New managed content.\n")
        extra = [{"source": "managed/new.txt", "target": "local.txt"}]
        self.write_release("1.2.0", "Principle version three.\n", "Control version three.\n", extra)
        self.commit_and_tag("v1.2.0")
        result = self.sync("update", expected=1)
        self.assertIn("collides with a local path: local.txt", result.stderr)
        self.assertEqual(
            "Preserve this local file.\n",
            (self.project / "local.txt").read_text(encoding="utf-8"),
        )

    def test_git_metadata_target_is_rejected(self) -> None:
        self.write(self.upstream, "managed/new.txt", "Unsafe managed content.\n")
        extra = [{"source": "managed/new.txt", "target": ".git/foundation-control"}]
        self.write_release("1.2.0", "Principle version three.\n", "Control version three.\n", extra)
        self.commit_and_tag("v1.2.0")
        result = self.sync("update", expected=1)
        self.assertIn("must not address Git metadata", result.stderr)


if __name__ == "__main__":
    unittest.main()
