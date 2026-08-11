# Adopt and upgrade Project Foundation

This document explains how a project consumes a release without creating a
runtime dependency or a divergent local copy.

The recommended inclusion method is a vendored snapshot that is committed with
the consuming project. It is not a submodule, symlink, or runtime dependency.
The project remains complete after a clone. Each version upgrade produces an
explicit diff.

## Official source

- Repository: `https://github.com/nclsppr/project-foundation.git`
- Current release: `v0.5.2`
- Immutable reference: the complete SHA recorded in `FOUNDATION.md`

Always adopt a tag and its commit. Never adopt the moving state of `main`.

## New project

```bash
git clone --branch v0.5.2 --depth 1 \
  https://github.com/nclsppr/project-foundation.git \
  /tmp/project-foundation-v0.5.2

/tmp/project-foundation-v0.5.2/scripts/bootstrap.sh \
  --target /absolute/path/to/the-new-project \
  --class product \
  --profiles web
```

The bootstrap does not create the project Git repository and does not overwrite
files. It records the foundation source, tag, and commit in `FOUNDATION.md`.

Nimbus, `documentation-nimbus`, `compose.yaml`, the Compose checker, and CI are
always included. `--profiles` selects only the additional profiles.

## Existing project

The bootstrap requires a target that does not exist. For an existing repository:

1. Generate the pack in an adjacent temporary directory.
2. Inspect collisions with existing canonical sources.
3. Copy the `docs/foundation/` snapshot without modification.
4. Merge the local adapters and documentation contracts. Do not replace the project rules without review.
5. Complete `FOUNDATION.md`, the deviations, and the local sources.
6. Regenerate the documentation catalog.
7. Run the project verification.
8. Commit the adoption as a reversible unit.
9. Push immediately to the canonical branch if direct write access is permitted. Otherwise, push to a dedicated branch.

## Local exception or foundation challenge

An unsuitable rule can follow one of two paths.

### The requirement is specific to the project

Document a limited deviation in `FOUNDATION.md`. Include the reason,
compensating control, owner, and review date. Do not modify the snapshot.

### The problem is general

Modify the Project Foundation repository:

1. Create a branch or worktree from the official repository.
2. Modify the canonical source, its templates, controls, and tests.
3. Run `./scripts/verify.sh`.
4. Review and verify the change. Commit it as one coherent unit.
5. Push the commit in accordance with `P18`.
6. Publish a new version in accordance with `VERSIONING.md`.
7. Then upgrade the consuming project to this tag and SHA.

Direct modification of `docs/foundation/` is prohibited. The next upgrade would
overwrite the modification and hide the discussion from other projects.

## Upgrade

1. Read `CHANGELOG.md` between the two tags.
2. Replace the snapshot from the new commit.
3. Review the diff for invariants, defaults, profiles, and quality gates.
4. Reconcile the local deviations.
5. Compare the new script baselines with the local adaptations.
6. Regenerate the documentation catalog.
7. Verify and commit the snapshot, provenance, and adaptations together.
8. Push immediately to the canonical branch if direct write access is permitted. Otherwise, push to a dedicated branch.

A future upgrade command can prepare this diff. It must never silently overwrite
a deviation or local quality gate.

### Migration from v0.2.0 to v0.3.1

This upgrade is incompatible without adaptation:

1. Install Node `22.12.0` or later and npm in the local and CI environments.
2. Copy `docs-nimbus/`, its lockfile, and the mandatory profile from `v0.3.1`.
3. Add `CHANGELOG.md` from the template if the project does not have this file.
4. Merge the new baselines for `scripts/check_markdown.py` and `scripts/verify.sh`.
5. Declare `documentation-nimbus` in `FOUNDATION.md`.
6. Define the Nimbus variables only if the local default values are not suitable.
7. Run `./scripts/verify.sh` before you publish the upgrade.

### Migration from v0.3.0 to v0.3.1

`v0.3.0` builds the foundation repository correctly, but its Nimbus guide
contains two non-portable links. These links cause lint to fail in a generated
pack. Replace the scaffold and verification scripts with the files from
`v0.3.1`. Then run `./scripts/verify.sh` again.

### Migration from v0.3.1 to v0.4.0

This version adds invariant `P18`:

1. Replace `PRINCIPLES.md`, `DEFAULTS.md`, and `DEFINITION-OF-DONE.md` with the files from `v0.4.0`.
2. Merge the new baseline for the `AGENTS.md` adapter.
3. Specify the canonical branch in `PROJECT.md`. Also specify whether the project uses direct pushes or reviewed branches.
4. Preserve the local application quality gates. Then run `./scripts/verify.sh`.
5. Commit the snapshot, provenance, and adaptations as one unit.
6. Push this unit in accordance with `P18`, and verify its remote SHA.

A local deviation cannot cancel `P18`. The only exceptions are a task that is
explicitly read-only or local-only, a higher-level prohibition, no remote, or a
documented external blocker.

### Migration from v0.4.0 to v0.5.0

This version adds invariant `P19` and a Docker Compose prerequisite:

1. Install Docker and Docker Compose `2.20.0` or later in the local and CI environments.
2. Replace `PRINCIPLES.md`, `DEFAULTS.md`, and `DEFINITION-OF-DONE.md` with the files from `v0.5.0`.
3. Add or merge `compose.yaml` at the repository root.
4. Copy `scripts/check_compose.py` and call this checker from `scripts/verify.sh`.
5. Merge the `.github/workflows/verify.yml` baseline without removing the local application quality gates.
6. Add each application and dependency that the integrated local path requires to Compose.
7. Pin external images by digest, add health checks, and label finite commands.
8. Run `python3 scripts/check_compose.py`, the `docker compose up --build --wait` path, and then `./scripts/verify.sh`.
9. Commit and push the snapshot, provenance, Compose configuration, CI configuration, and adaptations as one unit.

A local deviation cannot remove `compose.yaml`, its checker, or its quality gate.
A check that is independent of repository content also requires the platform to
make the verification workflow mandatory on the branch.

### Migration from v0.5.0 to v0.5.1

This correction applies to `compose.yaml` in the Project Foundation repository.
The sources are mounted as read-only, and the checks run in an anonymous
workspace. Generated projects do not have this documentation service and do not
require an additional adaptation. However, each new adoption must use `v0.5.1`.
This release permits verification of `main` and tag runs without permission
conflicts.

### Migration from v0.5.1 to v0.5.2

This correction strengthens the Compose quality gate wiring. Merge the new
baselines for `scripts/check_markdown.py` and `.github/workflows/verify.yml`.
The workflow now calls `scripts/check_compose.py` directly before the project
quality gate. The documentation checker rejects removal of this call or the
call in `scripts/verify.sh`. The control remains versioned with the repository.
An independent root of trust still requires the verification workflow to be a
required check in the GitHub rules of the consuming project.
