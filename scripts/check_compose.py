#!/usr/bin/env python3
"""Validate the mandatory Docker Compose contract of a Foundation project."""

from __future__ import annotations

import json
import re
import shutil
import subprocess
import sys
from pathlib import Path


MINIMUM_PYTHON = (3, 9)
MINIMUM_COMPOSE = (2, 20, 0)
DURABLE_PACKS = {"standard", "full", "critical"}


if sys.version_info < MINIMUM_PYTHON:
    detected = ".".join(str(part) for part in sys.version_info[:3])
    print(
        f"Python >= 3.9 is required. Detected version: {detected}.",
        file=sys.stderr,
    )
    raise SystemExit(2)


ROOT = Path(__file__).resolve().parent.parent
COMPOSE_FILE = ROOT / "compose.yaml"
PACK_PATTERN = re.compile(
    r"^\| Adopted pack \| `(minimal|standard|full|critical)` \|$",
    re.MULTILINE,
)


def fail(message: str) -> None:
    print(f"Invalid Compose contract: {message}", file=sys.stderr)
    raise SystemExit(1)


def project_pack() -> str:
    foundation = ROOT / "FOUNDATION.md"
    if foundation.is_file():
        match = PACK_PATTERN.search(foundation.read_text(encoding="utf-8"))
        if not match:
            fail("FOUNDATION.md has no valid adopted pack")
        return match.group(1)
    if (ROOT / "VERSION").is_file() and (ROOT / "PRINCIPLES.md").is_file():
        return "foundation"
    fail("cannot determine the project pack")


def compose_version(docker: str) -> tuple[int, int, int]:
    result = subprocess.run(
        [docker, "compose", "version", "--short"],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        fail(f"Docker Compose v2 is required ({detail or 'command unavailable'})")
    numbers = [int(part) for part in re.findall(r"\d+", result.stdout)[:3]]
    if not numbers:
        fail(f"cannot parse the Docker Compose version: {result.stdout.strip()!r}")
    version = tuple((numbers + [0, 0, 0])[:3])
    if version < MINIMUM_COMPOSE:
        detected = ".".join(str(part) for part in version)
        fail(f"Docker Compose >= 2.20.0 is required. Detected version: {detected}")
    return version


def normalized_config(docker: str) -> dict[str, object]:
    result = subprocess.run(
        [
            docker,
            "compose",
            "--project-directory",
            str(ROOT),
            "-f",
            str(COMPOSE_FILE),
            "config",
            "--format",
            "json",
        ],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        fail(f"docker compose config failed: {detail}")
    try:
        config = json.loads(result.stdout)
    except json.JSONDecodeError as error:
        fail(f"cannot parse the Docker Compose JSON output: {error}")
    if not isinstance(config, dict):
        fail("the normalized configuration is not an object")
    return config


def service_labels(service: dict[str, object]) -> dict[str, str]:
    labels = service.get("labels", {})
    if isinstance(labels, dict):
        return {str(key): str(value) for key, value in labels.items()}
    return {}


def validate_services(pack: str, config: dict[str, object]) -> int:
    project_name = config.get("name")
    if not isinstance(project_name, str) or not project_name.strip():
        fail("the Compose project must have an explicit name")

    services = config.get("services", {})
    if not isinstance(services, dict):
        fail("services must be a table")
    if pack in DURABLE_PACKS | {"foundation"} and not services:
        fail(f"the {pack} pack requires at least one service in compose.yaml")

    for service_name, raw_service in services.items():
        if not isinstance(raw_service, dict):
            fail(f"service {service_name} is invalid")
        image = raw_service.get("image")
        build = raw_service.get("build")
        if not image and not build:
            fail(f"service {service_name} has no image or build source")
        if image and not build and "@sha256:" not in str(image):
            fail(
                f"external image for {service_name} is not pinned by digest: {image}"
            )

        lifecycle = service_labels(raw_service).get("foundation.lifecycle", "service")
        if lifecycle not in {"service", "job"}:
            fail(
                f"foundation.lifecycle is invalid for {service_name}: {lifecycle}"
            )
        healthcheck = raw_service.get("healthcheck")
        if lifecycle == "service" and (
            not isinstance(healthcheck, dict) or healthcheck.get("disable") is True
        ):
            fail(
                f"long-running service {service_name} has no healthcheck; "
                "use foundation.lifecycle=job only for a finite command"
            )
    return len(services)


def main() -> None:
    if not COMPOSE_FILE.is_file():
        fail("compose.yaml is required at the repository root")
    docker = shutil.which("docker")
    if docker is None:
        fail("the docker command is required")
    version = compose_version(docker)
    pack = project_pack()
    service_count = validate_services(pack, normalized_config(docker))
    rendered_version = ".".join(str(part) for part in version)
    print(
        f"Compose contract is valid: pack={pack}, services={service_count}, "
        f"version={rendered_version}."
    )


if __name__ == "__main__":
    main()
