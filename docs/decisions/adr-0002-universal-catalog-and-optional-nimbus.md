# ADR-0002: Universal catalog and optional Nimbus

- Status: superseded
- Implementation status: removed
- Date: 2026-07-27
- Last verification: 2026-07-27, catalog and bootstrap verified locally
- Owner: Nicolas Pieper
- Supersedes: none
- Superseded by: ADR-0003

## Context

Projects must make all their Markdown files discoverable. They must distinguish
public documentation, internal documentation, references, and archives.
Surplasse uses Nimbus successfully, but its adapter, theme, base paths, and
publication topology are specific to that product.

Project Foundation must remain usable from a new clone with Git, Bash, and
Python. Adding Astro, Node, and Nimbus to the core would change a portable
contract into a mandatory web toolchain.

## Decision problem

How can the foundation make sure that each Markdown file is classified while it
provides Nimbus without requiring it for each exploration or service?

## Considered options

### Require Nimbus in all projects

Advantage: Navigation and rendering are immediately consistent.

Limitations: The dependencies are excessive for small projects. Internal
publication is not defined. The foundation becomes coupled to a new engine.

### Provide only an editorial recommendation

Advantage: No additional tool is necessary.

Limitation: No control detects a new unclassified Markdown file or a file that
is published to the wrong audience.

### Universal catalog and Nimbus profile

Advantages: The rule can be verified without a web runtime. Audiences are
explicit. Nimbus is available when it provides a measured value. Sources remain
independent of the engine.

Limitation: A project that publishes documentation must still configure and
maintain its rendering adapter.

## Decision

All projects that adopt the foundation have `documentation.json`,
`DOCUMENTATION.md`, and a generated Markdown catalog. Verification rejects each
maintained Markdown file that does not belong to exactly one collection.

Nimbus is the default for durable published documentation through
`profiles/documentation-nimbus.md`. It is not installed in the Project
Foundation runtime in `v0.2.0`.

Markdown files remain the editorial source. Each Nimbus collection, navigation
structure, or site is derived. By default, internal audiences must never be in
public output.

## Consequences

### Positive

- Each Markdown file has a location and an audience.
- The control operates without Node or network access.
- Nimbus can be adopted without becoming a core dependency.
- An engine change does not move the editorial sources.

### Negative

- The manifest must change with the documentation architecture.
- The generated catalog is an additional artifact to commit.
- Each Nimbus integration has a local adapter that requires testing.

## Verification

- `python3 scripts/documentation_catalog.py --check`;
- `./scripts/verify.sh`;
- bootstrap tests for all packs;
- build and final-surface review in projects that enable Nimbus.

## Review

Review the installation of Nimbus in this repository if Project Foundation
publishes its own documentation, if several projects use the same adapter, or
if the rendering-engine-neutral catalog is no longer sufficient.
