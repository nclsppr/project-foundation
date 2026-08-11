# STATUS.md

Snapshot verified on 2026-08-11. Local verification limits are listed below.

## Reference

| Field | Value |
| --- | --- |
| Canonical branch | `main` |
| Review branch | `agent/require-foundation-sync` |
| Version | `v0.6.0` |
| Change state | Release candidate with controlled English, structured logging, public Nimbus deployment, and continuous Foundation release verification |
| Environment | Linux `x86_64`, Node `24.14.0`, npm `11.9.0`, Python `3.12.13`; Docker unavailable |
| Production | Not applicable |
| Remote repository | `https://github.com/nclsppr/project-foundation.git` |
| Visibility | Public, no license granted |

## Delivered state and current verification

| Capability | Actual scope | Evidence | Known limit |
| --- | --- | --- | --- |
| Core | Twenty-two invariants, defaults, and definition of done | ADR-0004 through ADR-0009, local checks, and generated-pack propagation | Remote protections remain specific to each repository |
| Bootstrap | Four packs, mandatory Nimbus, Compose, Foundation lock, pre-commit hook, synchronizer, and independent CI check | `scripts/test_bootstrap.sh` passes locally with a Docker command stub | Business content and services for a durable pack require completion |
| Foundation synchronization | Stable annotated-tag resolution, complete commit verification, SHA-256 integrity, controlled update, and collision stop | Eleven integration tests in `scripts/test_foundation_sync.py` pass | A project on an earlier release needs one reviewed migration to `v0.6.0` before `P22` can enforce itself |
| Profiles | Mandatory Nimbus documentation; optional web, backend and data, infrastructure, experiment, generated-artifact, and dependency profiles | Snapshots and declarations verified | No native mobile or data-science profile |
| Documentation | 50 classified Markdown files, 55 generated Nimbus pages, and an audience-filtered publication path | Catalog generation, Markdown checks, type checking, and a clean Nimbus build | GitHub Pages source selection remains an external repository setting |
| Upstream adoption | Separate official source, stable tag, complete commit, hashed snapshot, local exception, and Foundation challenge | Parkventory still adopts `v0.5.2` at SHA `b3d908b5f54d19ef6229393568cdb984216e83c8` | Parkventory has not completed the one-time `v0.6.0` migration |
| Local orchestration | Root Compose file, pinned Nimbus image, checked lifecycles, copied checker, and direct CI call | `scripts/check_compose.py`, container job, and bypass tests | Local Compose execution uses a parser stub because Docker is unavailable |
| Verification | Structure, links, anchors, style, version, placeholders, Nimbus, Compose, synchronization security, bootstrap security, and propagation of `P18` through `P22` | `./scripts/verify.sh` passes locally with the narrow Docker command stub | Real Docker and remote GitHub Actions evidence remain pending for this branch |

## Phase state

| Roadmap phase | Observed state | Next evidence |
| --- | --- | --- |
| `F01` | `done`: versioned core, bootstrap, and prior releases exist | Maintain the foundation without reopening the phase |
| `F02` | `done`: Parkventory is independent, pushed, and verified from a public clone | Migrate the consumer separately after `v0.6.0` is published |
| `F03` | `done`: controlled update prepares an explicit diff and preserves unrelated local files | Confirm the same tests in remote CI |
| `F04` | `done`: local and CI checks detect obsolete releases, moved tags, unavailable sources, and drift | Require the CI result in each consuming repository |

## Target not delivered

- the `v0.6.0` tag and release record before the release commit reaches `main`;
- automatic migration of a repository that has not yet adopted the `P22` control surface;
- branch rules that require `Foundation Current` in each consuming repository.

## Local verification limit

The local environment does not provide Docker. A narrow Docker command stub
parses `compose.yaml` and permits structural verification of the Compose gate.
This stub does not execute a container. GitHub Actions must provide the final
Docker Compose evidence for the release candidate.

## Known drift

Parkventory remains on `v0.5.2` until a separate authorized migration applies
`v0.6.0`. Project Foundation cannot retroactively install a hook in an existing
clone. The first migration adds the lock, synchronizer, hook, and CI check. Each
later commit then follows `P22`.
