# ADR-0009: Continuous Foundation release verification

- Status: accepted
- Implementation status: delivered
- Date: 2026-08-11
- Last verification: 2026-08-11, complete local verification with eleven synchronizer integration tests and four generated packs; GitHub Actions run `31518800954` passed with Docker Compose
- Owner: Nicolas Pieper
- Supersedes: none
- Superseded by: none

## Context

Each project vendors a Project Foundation snapshot. The snapshot makes the
project independent, but it can become obsolete after Foundation publishes a
new rule, correction, or control. The existing adoption process records a tag
and complete commit. It does not require a freshness check before each commit.

A local Git hook can stop a commit before creation. Git also permits
`--no-verify`, and local hook configuration is not part of a clone. A separate
CI check is necessary to protect the canonical branch.

An automatic overwrite is unsafe. Projects contain local exceptions,
application quality gates, and adapters that Foundation does not own. An update
must preserve these files and make each rule change visible for review.

## Decision problem

How can each new and existing consuming project prove before every commit that
it uses the latest stable Foundation rules, and update safely when it does not?

## Considered options

### Perform a periodic manual review

Advantage: The project controls the update date.

Limitations: The interval is inconsistent. A security or quality correction can
remain unapplied for many commits. There is no blocking evidence.

### Track the moving `main` branch or use a submodule

Advantage: The project can observe upstream changes quickly.

Limitations: A moving branch is not a release. A submodule makes the project
clone incomplete by default and changes the established snapshot boundary.
Neither option proves that local rules and controls were reviewed and applied.

### Overwrite all files from the newest release

Advantage: The project receives the newest baseline automatically.

Limitations: This option can delete exceptions, project rules, service
configuration, and stronger local gates. It can also create an unreviewed
supply-chain change inside an unrelated commit.

### Verify each commit and prepare a controlled update

Advantages: A stable tag and complete commit identify the release. Hashes detect
drift. The updater modifies only declared Foundation-owned files. The first
commit attempt stops so that the contributor can review and apply the release.
CI provides an independent control.

Limitation: A commit needs network access to the release source. A Foundation
release can require a separate migration work unit before product work resumes.

## Decision

Add `P22` to `PRINCIPLES.md`. A consuming project must use the latest stable
annotated `vMAJOR.MINOR.PATCH` tag from the source recorded in
`foundation.lock.json`. Compare versions by Semantic Versioning precedence.
Keep the complete commit as the immutable content reference.

Add `foundation-distribution.json` as the canonical list of the snapshot and
Foundation-managed controls. Activated profiles expand the snapshot list. The
project lock records each source path, target path, and SHA-256 value.

Keep `https://github.com/nclsppr/project-foundation.git` as the default trust
anchor in the managed synchronizer. A change to only the lock and its
human-readable projection cannot select another source. An externally managed
environment can set
`PROJECT_FOUNDATION_TRUSTED_SOURCE` for an approved mirror. The lock and
`FOUNDATION.md` must record that exact source. The mirror must preserve the
official tags and commits.

Add `scripts/foundation_sync.py` with these operations:

- `check` verifies the lock, local hashes, release tag, release commit, and
  latest stable version;
- `update` clones the newest stable tag and replaces only declared snapshot and
  managed targets;
- `enforce` prepares the update and returns a blocking result when the project
  is obsolete;
- `hook-status` verifies that local Git uses the versioned hook.

The updater does not remove a previously managed target. It does not overwrite
a new target that collides with a local path. It does not replace content that
already differs from the recorded hash. These cases require a manual migration.

The versioned pre-commit hook runs the complete project verification command.
Local verification first runs `hook-status` and `enforce`. CI uses `check` and
does not mutate the checkout. Add a dedicated GitHub Actions check for pushes,
pull requests, workflow dispatches, and merge-queue candidates. A consuming
repository must make this result required on its canonical branch.

The CI check is independent of the local hook, but it is not independent of
repository administration. Branch rules and review must protect changes to the
workflow, lock, synchronizer, hook, and verification wiring. A contributor must
not approve a change that weakens these controls in the same pull request.

Keep application adapters local and editable. An update replaces the normative
snapshot and the small Foundation-specific control surface. The contributor
reviews the release changelog and diff, applies rule changes to the project,
merges applicable adapter corrections, updates the project changelog, and runs
verification before the next commit attempt.

Prepare release `v0.6.0` as the first release with this contract. Each existing
consumer performs one reviewed migration to `v0.6.0`. Later commits use the
continuous gate.

## Consequences

### Positive

- Each commit receives an immediate freshness check.
- A tag, complete commit, and file hashes identify the adopted rule set.
- A moved release tag and local snapshot drift become blocking errors.
- Local rules, exceptions, and stronger gates remain outside automatic writes.
- CI prevents a local hook bypass from reaching a protected canonical branch.
- The update mechanism remains independent of an application stack.

### Negative

- Offline work cannot create a compliant commit because freshness cannot be
  proved.
- The complete verification command can make commits slower.
- Each existing project needs one manual migration to `v0.6.0`.
- Repository administrators must activate the hook locally and require the CI
  result on the canonical branch.
- Repository rules and review remain part of the trust boundary for the managed
  CI control surface.

## Verification

- Check a project that uses the latest stable release.
- Reject a project that uses an older stable release.
- Reject a release tag that no longer identifies the recorded commit.
- Reject an unavailable release source.
- Reject a lock-only change to the trusted source.
- Reject a Foundation target inside Git metadata.
- Reject a changed or missing snapshot or managed file.
- Reject a locally recalculated lock hash that differs from the release content.
- Reject a symbolic link in the managed snapshot path.
- Prepare an update and preserve unrelated local files.
- Reject a new managed target that collides with a local file.
- Verify propagation to Minimal, Standard, Full, and Critical packs.
- Remove the hook, lock, synchronizer, verification call, or CI call and verify
  that the generated-project checker rejects the removal.
- Run the complete Foundation and generated-project verification paths.

## References

- [Git pre-commit hook](https://git-scm.com/docs/githooks#_pre_commit)
- [Git `core.hooksPath`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corehooksPath)
- [Semantic Versioning 2.0.0](https://semver.org/)
- [GitHub required status checks](https://docs.github.com/en/pull-requests/reference/status-checks)
- [GitHub immutable releases](https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases)
- [GitHub Actions workflow events](https://docs.github.com/actions/using-workflows/events-that-trigger-workflows)

## Rollback

Revert the `v0.6.0` adoption in a consuming project only as an explicit rollback
work unit. Restore the prior snapshot, lock, and controls from Git. The next
commit remains blocked until the project adopts the latest stable release again
or higher authority removes the project from Project Foundation governance.

## Review

Review this decision if commit latency becomes excessive, several projects need
the same adapter merge, the official source changes release semantics, or a
signed release manifest provides stronger portable provenance.
