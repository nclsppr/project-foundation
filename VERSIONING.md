# Versioning and upgrades

The foundation uses `vMAJOR.MINOR.PATCH` tags.

Before `v1.0.0`, a minor version can still reorganize the adoption pack. `CHANGELOG.md` identifies each incompatibility explicitly.

The `VERSION` file is the canonical source for the current version. `PROJECT.md`, `STATUS.md`, the first entry in `CHANGELOG.md`, and the release tag must match it. `./scripts/verify.sh` checks this consistency.

## Version types

| Version | Change |
| --- | --- |
| Major | An invariant is removed or changed, the adoption format is incompatible, or migration is mandatory |
| Minor | A new profile, default, template, or capability that is compatible with existing snapshots |
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
12. Monitor the available remote checks before you declare the release complete.

The readable tag helps discussions. The complete commit remains the immutable reference.

## Adopt a version

The consuming project records the following information in `FOUNDATION.md`:

- the source;
- the tag;
- the complete commit;
- the enabled profiles;
- the documentation contract and its catalog;
- the deviations and compensating controls.

The snapshot is copied to `docs/foundation/` and committed with the project.
The `docs-nimbus/` scaffold, its lockfile, the `documentation-nimbus` profile,
`compose.yaml`, the Compose checker, and the CI workflow are mandatory in
each adopted version.

## Upgrade a project

1. Read the changelog entries between the two versions.
2. Check the incompatible changes and migration notes.
3. Replace the snapshot. Do not merge it silently line by line.
4. Review the diff for invariants, defaults, profiles, and quality gates.
5. Reconcile the local deviations.
6. Compare the new baselines for `scripts/check_markdown.py`, `scripts/check_compose.py`, `scripts/documentation_catalog.py`, `scripts/verify.sh`, `compose.yaml`, and the CI workflow. Explicitly merge the applicable corrections without overwriting local quality gates.
7. Regenerate the documentation catalog and review the audiences.
8. Run the project verification.
9. Deliver the snapshot, version, and adaptations as one unit.
10. Push this unit immediately in accordance with `P18`, and verify its remote SHA.

An automatic upgrade can propose a diff. It must never silently change the local rules or project protections.

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
