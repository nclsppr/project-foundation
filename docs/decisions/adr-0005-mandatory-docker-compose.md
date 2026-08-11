# ADR-0005: Mandatory Docker Compose for the local environment

- Status: accepted
- Implementation status: delivered
- Date: 2026-07-30
- Last verification: 2026-07-30, Compose control, CI wiring, and tests for all four packs
- Owner: Nicolas Pieper
- Supersedes: none
- Superseded by: none

## Context

`P09` required reproducible execution, but Project Foundation did not define a
common contract to run an application and its dependencies together. A project
could document several host commands, start only its database with Compose, or
let its CI ignore the integrated environment.

This defect occurred in Parkventory. PostgreSQL was declared in `compose.yaml`,
but Quarkus and Vite remained host processes. The path operated correctly, but
it did not prove that another machine could start the same service graph.

## Decision problem

How can the foundation require an integrated local path that is portable and
verified by CI without requiring an application stack or prohibiting a faster
host development loop?

## Considered options

### Let each project select its orchestrator

Advantage: Each technology stack has maximum freedom.

Limitation: No universal command proves the required service graph, and
dependencies can remain implicit.

### Recommend Docker Compose as a default

Advantage: Adoption is progressive and has few constraints.

Limitation: A project can override a default. Therefore, this option does not
prevent an absent file, a service that runs outside Compose, or CI that ignores
the configuration.

### Require Docker Compose as a verified invariant

Advantages: Each project uses the same configuration contract. There is one
integrated path. Images, health states, and shutdown behavior are verifiable.
Host shortcuts remain available for an internal development loop.

Limitations: Docker becomes a verification prerequisite, and each new service
must be added to the Compose graph.

## Decision

The canonical rule is `P19` in `PRINCIPLES.md`. Each project versions a
`compose.yaml` file at its root. Docker Compose is the canonical path to start
the applications and dependencies that local development requires.

The bootstrap always copies:

- `compose.yaml`;
- `scripts/check_compose.py`;
- `.github/workflows/verify.yml`;
- the call to the Compose checker from `scripts/verify.sh`.

The workflow also calls the checker directly before `verify`. The documentation
checker rejects removal of either call to detect accidental bypass of the
quality gate wiring.

A Minimal pack can keep `services: {}` while it starts no local process.
Standard, Full, and Critical packs must declare at least one service.
External images are pinned by digest. Long-running services have a health check.
Finite commands without a health check have the
`foundation.lifecycle=job` label.

A host command remains permitted as a shortcut, but not as the only integrated
path. A local deviation cannot remove the file, checker, or quality gate. A
platform without Docker can prevent execution, but the contract and CI control
remain versioned.

## Consequences

### Positive

- A new clone shows the local graph in a standard file.
- `verify` rejects a durable project that has no actual service.
- The checker detects mutable images and services without a health signal.
- Generated CI runs the same control as the developer.
- Stopping and diagnostic commands are consistent across technology stacks.

### Negative

- Docker Compose `2.20.0` or later becomes mandatory for `verify`.
- A Standard or higher bootstrap remains intentionally failing until its first actual service replaces the empty mapping.
- The checker cannot detect an undocumented process outside Compose. Review must still compare the architecture with the declared graph.
- Independent protection also requires a mandatory CI check and a branch policy in the consuming repository.

## Implementation

1. Add `P19` and its quality gates to the definition of done.
2. Add the generic checker and a finite service to verify the foundation.
3. Generate Compose and CI configuration in all four packs.
4. Make these files mandatory in the consuming project's Markdown checker.
5. Test the empty Minimal pack, rejection of an empty Full pack, digests, health checks, removal of safeguards, and removal of quality gate calls.
6. Make Parkventory adopt the new release and put its Quarkus, Vite, and PostgreSQL path under Compose.

## Verification

- `python3 scripts/check_compose.py` passes on Project Foundation.
- `docker compose run --rm documentation-check` passes.
- `./scripts/verify.sh` passes.
- All four generated trees contain Compose, the checker, and CI configuration.
- Bootstrap bypass cases fail with an actionable message.
- The release commit and tag are published and then verified by CI.

## Review

Review this decision if Docker Compose is no longer available on a supported
platform or if several projects demonstrate that they cannot represent their
local path with it. The replacement must retain a common executable contract
and a quality gate that is independent of agent tools.
