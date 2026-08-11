# ADR-0001: Standalone, versioned foundation

- Status: accepted
- Implementation status: delivered
- Date: 2026-07-26
- Last verification: 2026-07-26, local verification passed and release `v0.1.0` published
- Owner: Nicolas Pieper
- Supersedes: none

## Context

Applicable rules are distributed across Surplasse, the personal site, Papers Empire, and a VPS runbook. At the time of this decision, the `vps` directory is not version-controlled and has a specific operations scope.

The foundation must support local projects, agents, CI, and possibly the VPS without becoming a hidden dependency.

## Decision problem

Where must the foundation be stored, and how can each project use it independently?

## Considered options

### Store the foundation under `vps/ai`

Advantage: It is close to the future resident server agent.

Limitations: This option mixes multi-project rules with infrastructure, has no current Git history, and has VPS-specific semantics.

### Use a global file outside the repositories

Advantage: There is only one local copy.

Limitations: A clone cannot discover it, CI cannot use it portably, and it depends on a machine-specific path.

### Create a standalone repository and vendor a snapshot

Advantages: The foundation has an independent history and an explicit version. The consuming project is standalone and can select profiles.

Limitation: A foundation upgrade must replace the snapshot in each project and produce a diff for review.

## Decision

Create `project-foundation` as a standalone, agent-neutral, and versioned repository.

Each project copies a snapshot of `PRINCIPLES.md`, `DEFAULTS.md`, `DEFINITION-OF-DONE.md`, and the selected profiles to `docs/foundation/`. It records the version and deviations in `FOUNDATION.md`.

Local agent files remain short. No project depends on a relative path to this repository or on a symlink between repositories.

## Consequences

### Positive

- The foundation can change independently of the VPS.
- A project clone remains complete.
- Deviations are visible.
- An upgrade can be reviewed as a diff.

### Negative

- Snapshots do not update automatically.
- A comparison and upgrade tool will be useful if adoption becomes frequent.

## Verification

- The Git repository is initialized on `main`.
- The first version has a tag.
- The bootstrap and `FOUNDATION.md` template are consistent.
- Local links and the structure are verified.

## Review

Review the snapshot method if several projects experience recurring divergence, or if package distribution provides a measured benefit without a runtime dependency.
