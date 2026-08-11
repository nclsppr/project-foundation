# STATUS.md

Snapshot verified on 2026-08-11. Local verification limits are listed below.

## Reference

| Field | Value |
| --- | --- |
| Canonical branch | `main` |
| Review branch | `agent/add-structured-logging`, stacked on `agent/add-controlled-technical-english` |
| Version | `v0.5.2` |
| Change state | Unreleased controlled-English migration and structured-logging policy after `v0.5.2` |
| Environment | Linux `x86_64`, Node `24.14.0`, npm `11.9.0`, Python `3.12.13`; Docker unavailable |
| Production | Not applicable |
| Remote repository | `https://github.com/nclsppr/project-foundation.git` |
| Visibility | Public, no license granted |

## Delivered state and current verification

| Capability | Actual scope | Evidence | Known limit |
| --- | --- | --- | --- |
| Core | Twenty-one invariants, defaults, and definition of done | Cross-review, ADR-0004 through ADR-0007, local checks, and GitHub Actions run `31493111439` for the controlled-English base | Remote P21 verification is pending |
| Bootstrap | Four packs, mandatory Nimbus and Compose, generated CI, six supplementary profiles, dry run, atomic copy without overwrite, and P21 propagation | `scripts/test_bootstrap.sh` passes locally with a Docker command stub; the controlled-English base passes remotely in run `31493111439` | Remote P21 verification is pending; business content and services for a durable pack require completion |
| Profiles | Mandatory Nimbus documentation; optional web, backend and data, infrastructure, experiment, generated-artifact, and dependency profiles | Snapshots and declarations verified | No native mobile or data-science profile |
| Documentation | 48 classified Markdown files, 53 generated Nimbus pages, and 54 linted files | Catalog, tests, type checking, clean build, English-only Pagefind index, and lint | Do not publish the complete local build without an audience filter |
| Upstream adoption | Separate official source, immutable snapshot, local exception, and foundation challenge | Parkventory adopts `v0.5.2` at SHA `b3d908b5f54d19ef6229393568cdb984216e83c8`; CI run `30526141976` is successful | Only one actual adoption observed |
| Provenance | Audit of retained, rejected, and local rules | `AUDIT.md` | Dated snapshot |
| Local orchestration | Root Compose file, pinned Nimbus image, checked lifecycles, copied checker, and direct CI call | `scripts/check_compose.py`, container job, and tests that remove the integration | Review is still required to detect a hidden process outside Compose |
| Verification | Structure, links, anchors, style, placeholders, Nimbus, Compose, bootstrap security, and propagation of `P18` through `P21` | Local checks with a Docker command stub; run `31493111439` verifies the controlled-English base | Remote P21 verification is pending; the checks do not establish formal conformance with ASD-STE100, OpenTelemetry, or OWASP |

## Phase state

| Roadmap phase | Observed state | Next evidence |
| --- | --- | --- |
| `F01` | `done`: `v0.5.2` at SHA `708d7374f87060809a805c57abc2cf7e7b66c182`; runs `30525884714` and `30525894423` are successful | Maintain the foundation without reopening the phase |
| `F02` | `done`: Parkventory is independent, pushed, and verified from a public clone | Prepare F03 without changing the consuming project |
| `F03` | `planned`: assisted upgrade not started | Define the diff and dry run without implicit overwrite |

## Target not delivered

- command to audit an adopted project;
- command to assist an upgrade between two foundation versions.

## Local verification limit

The local environment does not provide Docker. `./scripts/verify.sh` completes
the catalog and Markdown checks, then stops at the Compose prerequisite. With a
narrow Docker command stub, `scripts/test_bootstrap.sh` verifies the generated
packs and P21 propagation. The complete Nimbus check also passes locally.
GitHub Actions run `31493111439` completed the full verification of the
controlled-English base through Docker Compose. Remote verification of P21 is
pending. A second adoption can extend the evidence, but it does not invalidate
the F02 exit.

## Known drift

Contradictions in source projects remain documented in `AUDIT.md`. This repository does not correct them. The catalog confirms that a Markdown file can be found. It does not confirm that the content is editorially correct or suitable for publication.

No phase is active after the F02 exit. F03 remains the next planned phase.
