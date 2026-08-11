# Versioning and upgrades

The foundation uses `vMAJOR.MINOR.PATCH` tags.

Before `v1.0.0`, a minor version can add an invariant, reorganize the adoption
pack, or require a migration. `CHANGELOG.md` identifies each incompatibility
explicitly. Version `v1.0.0` will stabilize this public adoption contract.

The `VERSION` file is the canonical source for the current version. `PROJECT.md`, `STATUS.md`, the first entry in `CHANGELOG.md`, and the release tag must match it. `./scripts/verify.sh` checks this consistency.

A stable release is an annotated `vMAJOR.MINOR.PATCH` tag. The greatest tag by
Semantic Versioning precedence is the current stable release. A release never
uses the moving `main` branch as its content reference. Publish each official
tag as a release record on the official hosting platform. Enable immutable
releases when the platform provides this control. A consuming project still
records and verifies the complete commit.

## Version types

| Version | Change |
| --- | --- |
| Major | After `v1.0.0`, an invariant is removed or changed, the adoption format is incompatible, or migration is mandatory |
| Minor | A new invariant, profile, default, template, or capability; before `v1.0.0`, this can require a documented migration |
| Patch | A clarification, a link correction, or a more precise check that does not change the intent |

## Create a release

1. Update `VERSION`.
2. Update `CHANGELOG.md`.
3. Update `PROJECT.md`, `STATUS.md`, and `ROADMAP.md` if their state changes.
4. Regenerate `DOCUMENTATION-CATALOG.md`.
5. Run `./scripts/verify.sh`.
6. Review the complete diff.
7. Create one coherent commit.
8. Create an annotated `vMAJOR.MINOR.PATCH` tag.
9. Run `./scripts/verify.sh --release` again in the clean worktree.
10. Push the commit to `main` if direct write access is permitted. Otherwise, push it to a dedicated branch.
11. Publish the tag when the release commit is present on the remote.
12. Publish the release record. Verify that its tag and commit match the release commit.
13. Monitor the available remote checks before you declare the release complete.

The readable tag helps discussions. The complete commit remains the immutable reference.

## Adopt a version

The consuming project records the following information in `FOUNDATION.md`:

- the source;
- the tag;
- the complete commit;
- the enabled profiles;
- the documentation contract and its catalog;
- the deviations and compensating controls;
- the SHA-256 hashes in `foundation.lock.json`.

The snapshot is copied to `docs/foundation/` and committed with the project.
The `docs-nimbus/` scaffold, its lockfile, the `documentation-nimbus` profile,
`compose.yaml`, the Compose checker, and the CI workflow are mandatory in
each adopted version.

Each adopted version also includes `scripts/foundation_sync.py`, the versioned
pre-commit hook, its installer, and the independent CI freshness check. Run the
installer after Git initialization. Make the CI result required on the
canonical branch.

## Upgrade a project

1. Run `python3 scripts/foundation_sync.py update`, or let the pre-commit gate prepare the update.
2. Read the changelog entries between the two versions.
3. Check the incompatible changes and migration notes.
4. Review the replaced snapshot, managed controls, and release lock.
5. Apply each new or changed rule to the project.
6. Reconcile the local deviations.
7. Compare the new baselines for `scripts/check_markdown.py`, `scripts/check_compose.py`, `scripts/documentation_catalog.py`, `scripts/verify.sh`, `compose.yaml`, and the local verification workflow. Explicitly merge the applicable corrections without overwriting local quality gates.
8. Regenerate the documentation catalog and review the audiences.
9. Add the upgrade and its observable effect to the project changelog.
10. Run the project verification. The pre-commit hook runs it again.
11. Deliver the snapshot, lock, version, and adaptations as one unit.
12. Push this unit immediately in accordance with `P18`, and verify its remote SHA.

The controlled updater changes only the read-only snapshot and
Foundation-managed controls. It stops the first commit attempt after an update.
It never silently changes a local exception, project rule, or application
quality gate.

If a project finds that a general rule must change, it must not modify its
vendored snapshot. It contributes to the official repository, publishes a
release, and then follows this upgrade procedure. The complete protocol is in
[`ADOPTION.md`](ADOPTION.md).

## Deprecation

A replaced rule or profile remains documented until at least the next major version. Include the following information:

- its replacement;
- the reason;
- the migration procedure;
- the planned removal date or version.
