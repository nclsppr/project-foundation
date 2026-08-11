# ROADMAP.md

Canonical source for the Project Foundation development sequence.

## Product result

A new or existing project can adopt the common foundation in a few minutes. It has no hidden dependency and does not import decisions from another repository.

## Overview

| Order | ID | Phase | Result | State | Exit criterion |
| --- | --- | --- | --- | --- | --- |
| 1 | `F01` | Foundation and bootstrap | Versioned core, templates, profiles, and initializer | done | Local verification passes and tag `v0.1.0` exists |
| 2 | `F02` | Adoption test | A new repository uses the foundation | done | Repeated bootstrap, independent links, remote commit, and successful project `verify` command |
| 3 | `F03` | Assisted upgrade | A project compares and then replaces its snapshot without losing its exceptions | done | Explicit diff, controlled replacement, collision stop, and no implicit overwrite |
| 4 | `F04` | Adoption audit | A project detects drift from its snapshot | done | Tool-neutral local and CI check with actionable messages |

## Phase F01: foundation and bootstrap

### Included

- invariants and defaults;
- optional profiles;
- stable templates and dated snapshots;
- definition of done;
- provenance and decisions;
- verification command;
- deterministic and atomic initializer without overwrite;
- structural tests for the four packs;
- local Git history and tag.

### Excluded

- changes to source projects;
- automatic upgrade tool.

### Exit criterion

- `./scripts/verify.sh` passes;
- the repository is on `main` with a clean commit;
- tag `v0.1.0` references the verified commit.

### Compatible maintenance delivered in v0.2.0

- official repository and published tags;
- complete catalog of all Markdown files;
- explicit documentation audiences;
- optional Nimbus profile;
- upstream contribution procedure from a consuming project.

### Documentation migration delivered in v0.3.0

- mandatory Nimbus in all four packs;
- vendored official scaffold and lockfile;
- generic adapter from `documentation.json`;
- tests, type checking, build, search, and lint in `verify`;
- documented incompatible migration from `v0.2.0`.

### Adoption correction delivered in v0.3.1

- portable Nimbus maintenance links in generated projects;
- Nimbus build of a Full pack added to bootstrap tests;
- copied lockfile compared byte for byte with the source.

### Publication discipline delivered in v0.4.0

- invariant `P18` to commit and push each verified work unit;
- direct push to the canonical branch when permitted, or a dedicated branch otherwise;
- aligned adapters, definition of done, bootstrap, and adoption;
- verified propagation to generated packs.

### Mandatory local orchestration delivered in v0.5.0

- invariant `P19` to make Docker Compose mandatory;
- file, checker, and CI workflow generated in each pack;
- checked digests, health checks, lifecycles, and durable packs;
- bootstrap tests for structural bypasses;
- Parkventory selected as the first actual version upgrade.

### Permission correction delivered in v0.5.1

- Compose job sources mounted as read-only;
- checks isolated in an anonymous workspace;
- tag verification can run again after container execution.

### Compose integration strengthened in v0.5.2

- generated workflow calls the Compose checker directly;
- structural verification of calls from `verify` and CI;
- tests that remove each integration from a generated project.

## Phase F02: adoption test

### Objective

Create a disposable repository or an actual small project. Follow only the bootstrap instructions. Then correct each item that still requires implicit context.

Parkventory is the first actual project used for this evidence. Its `v0.4.0` snapshot and six profiles are independent. The public repository was tested again from a clean clone. The commits were pushed to `main`. Parkventory CI is successful through SHA `d9a50adb04ad1c7e038d7c672723c6dd4bba07d4` in run `30517607760`. F02 exited on 2026-07-30.

### Exit criterion

- the cloned project remains independent and has no path to this repository;
- profiles and exceptions are traceable;
- another session can start and verify the project.

## Phase F03: assisted upgrade

### Result delivered in v0.6.0

- `foundation.lock.json` records exact release provenance and managed-file hashes;
- `scripts/foundation_sync.py update` resolves the greatest stable annotated tag;
- the updater replaces only the declared snapshot and Foundation-managed controls;
- local exceptions, project rules, adapters, and application gates remain outside automatic writes;
- a removed target, changed managed file, or local collision stops the update;
- the first commit attempt stops after an update so the contributor can review and apply the release.

### Exit evidence

Integration tests verify an obsolete release, a prepared update, preservation of
an unrelated local file, and a managed-target collision. Generated-pack tests
verify the distribution in all four packs.

## Phase F04: adoption audit

### Result delivered in v0.6.0

- the pre-commit path runs the complete project verification command;
- local verification checks hook activation and release freshness;
- CI resolves the release source independently without modifying the checkout;
- the lock detects missing or changed snapshot and managed files;
- the release resolver rejects an unavailable source and a moved tag;
- generated-project checks reject removal of the lock, hook, synchronizer, or CI wiring.

### Exit evidence

`scripts/test_foundation_sync.py`, `scripts/test_bootstrap.sh`, and the complete
Foundation verifier provide the local and CI evidence. Each consuming
repository must make the `Foundation Current` result required on its canonical
branch.

## Update rule

- A phase changes to `done` only when it meets its exit criterion.
- Current findings are in `STATUS.md`.
- A structural change to this sequence requires an ADR.
