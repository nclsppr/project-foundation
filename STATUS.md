# STATUS.md

Snapshot reviewed on 2026-08-11. Verification limits are listed below.

## Reference

| Field | Value |
| --- | --- |
| Canonical branch | `main` |
| Review branch | `agent/add-controlled-technical-english` |
| Version | `v0.5.2` |
| Change state | Unreleased controlled-English migration after `v0.5.2` |
| Environment | Linux `x86_64`, Node `24.14.0`, npm `11.9.0`, Python `3.12.13`; Docker unavailable |
| Production | Not applicable |
| Remote repository | `https://github.com/nclsppr/project-foundation.git` |
| Visibility | Public, no license granted |

## Delivered state and current verification

| Capability | Actual scope | Evidence | Known limit |
| --- | --- | --- | --- |
| Core | Twenty invariants, defaults, and definition of done | Cross-review, ADR-0004, ADR-0005, ADR-0006, catalog check, and Markdown check | Remote protections remain specific to each repository |
| Bootstrap | Four packs, mandatory Nimbus and Compose, generated CI, six supplementary profiles, dry run, and atomic copy without overwrite | `scripts/test_bootstrap.sh` passes with a Docker command stub | GitHub Actions must provide the actual Docker evidence for the proposed commit |
| Profiles | Mandatory Nimbus documentation; optional web, backend and data, infrastructure, experiment, generated-artifact, and dependency profiles | Snapshots and declarations verified | No native mobile or data-science profile |
| Documentation | 47 classified Markdown files, 52 generated Nimbus pages, and 53 linted files | Catalog, tests, type checking, clean build, English-only Pagefind index, and lint | Do not publish the complete local build without an audience filter |
| Upstream adoption | Separate official source, immutable snapshot, local exception, and foundation challenge | Parkventory adopts `v0.5.2` at SHA `b3d908b5f54d19ef6229393568cdb984216e83c8`; CI run `30526141976` is successful | Only one actual adoption observed |
| Provenance | Audit of retained, rejected, and local rules | `AUDIT.md` | Dated snapshot |
| Local orchestration | Root Compose file, pinned Nimbus image, checked lifecycles, copied checker, and direct CI call | `scripts/check_compose.py`, container job, and tests that remove the integration | Review is still required to detect a hidden process outside Compose |
| Verification | Structure, links, anchors, style, placeholders, Nimbus, bootstrap security, and propagation of `P18`, `P19`, and `P20` | Catalog and Markdown checks, `npm run check --prefix docs-nimbus`, and bootstrap tests with a Docker command stub | Local `./scripts/verify.sh` stops at the Docker prerequisite; the checks do not establish formal conformance with ASD-STE100 |

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
the catalog and Markdown checks, then stops at the Compose prerequisite. GitHub
Actions must provide the complete verification for the proposed commit. A
second adoption can extend the evidence, but it does not invalidate the F02
exit.

## Known drift

Contradictions in source projects remain documented in `AUDIT.md`. This repository does not correct them. The catalog confirms that a Markdown file can be found. It does not confirm that the content is editorially correct or suitable for publication.

No phase is active after the F02 exit. F03 remains the next planned phase.
