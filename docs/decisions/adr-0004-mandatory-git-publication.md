# ADR-0004: Mandatory Git publication of verified work units

- Status: accepted
- Implementation status: delivered
- Date: 2026-07-30
- Last verification: 2026-07-30, pack tests and complete local verification
- Owner: Nicolas Pieper
- Supersedes: none
- Superseded by: none

## Context

Default `D02` recommended small, coherent commits and then a conditional push
when a repository published or backed up the work. The definition of done only
required a required push to succeed. Therefore, a project or agent could
consider a work unit complete while it remained in a worktree or local history.

This ambiguity occurred during Parkventory development. The product,
documentation, and validation were complete locally, but no commit or push was
made because there was no sufficiently explicit universal rule.

## Decision problem

How can authorized, coherent, and verified work quickly become remotely
visible, recoverable, and verifiable without bypassing branch protection or
mixing unrelated changes?

## Considered options

### Keep publication as a default

Advantage: Each project selects its Git practices.

Limitation: Work that is declared complete can remain fragile and invisible on
the local machine, without CI or a shared recovery point.

### Always require a direct push to `main`

Advantage: The path is simple for personal repositories.

Limitations: This option is incompatible with branch protection, mandatory
reviews, and some team repositories.

### Require publication and let the policy select the branch

Advantages: No completed work unit remains only local. `main` remains the short
path when it is accessible. A dedicated branch complies with protection and
review requirements.

Limitation: Each project must still specify its canonical branch and review
policy.

## Decision

The canonical rule is principle `P18` in `PRINCIPLES.md`. Each task that permits
modification of a Git repository with a remote must deliver each coherent and
verified work unit with a commit followed by an immediate push.

The push goes directly to the canonical branch if its policy permits this
action. If the branch is protected or requires review, create or reuse a
dedicated branch for the task scope. Never bypass protection.

A local convenience deviation cannot disable `P18`. Exceptions are limited by
the principle: explicitly read-only or local-only work, a higher-level
restriction, no remote, or an external blocker. A blocker records a local SHA,
remote target, and explicit resume condition. It does not change the delivery
result to success.

## Consequences

### Positive

- Completed work is visible and recoverable quickly.
- CI and reviews can start without waiting for a large delivery.
- Commits remain smaller, and rollbacks are more precise.
- Protected branches remain protected.
- Delivery evidence can identify a remote SHA.

### Negative

- The process can produce more pushes and CI runs.
- A work unit must have a correct scope before the commit.
- A network or authentication incident becomes an explicit delivery blocker instead of a hidden local success.

## Implementation

1. Add `P18` to the invariants.
2. Remove commit and push frequency from `D02`. It retains only the default destination and review method.
3. Add `P18` to the `AGENTS.md` adapters of all packs.
4. Align the definition of done, bootstrap, adoption, versioning, and delivery evidence.
5. Test that the principle and its adapter text are present in generated projects.

## Verification

- `./scripts/verify.sh` passes.
- Each generated pack contains `P18` in its snapshot.
- The Minimal and Standard or higher adapters require a commit and push.
- The release commit exists on the remote.
- The annotated tag points to the verified commit.
- Parkventory then adopts the release and publishes its first commit.

## Review

Review this decision only if several projects demonstrate that this frequency
has a disproportionate CI cost and does not improve recovery or review. The
review can adjust the size of a coherent work unit or the CI strategy. It must
not permit work that exists only locally to be declared complete.
