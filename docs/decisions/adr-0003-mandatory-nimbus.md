# ADR-0003: Mandatory Nimbus

- Status: accepted
- Implementation status: delivered
- Date: 2026-07-27
- Last verification: 2026-07-27, four packs, 44 Markdown files, 49 Nimbus pages, routes, and search verified locally
- Owner: Nicolas Pieper
- Supersedes: ADR-0002
- Superseded by: none

## Context

ADR-0002 required the exhaustive catalog but kept Nimbus optional. This
separation kept the bootstrap small, but it permitted several documentation
engines and required each project to create a Nimbus integration.

The foundation owner now requires Nimbus to be the common documentation surface
for all projects. The Markdown inventory, its audiences, and one editorial
source remain necessary.

## Decision problem

How can the foundation require Nimbus without publishing internal documents by
mistake or making the bootstrap depend on the network?

## Considered options

### Keep Nimbus optional

Advantage: Small projects do not require a Node dependency.

Limitation: The documentation experience varies, and each project must create
the integration later.

### Download Nimbus during each bootstrap

Advantage: The scaffold always comes from the upstream source.

Limitations: The bootstrap depends on the network. The result can change if the
generator or its template changes.

### Vendor the official scaffold in the foundation

Advantages: The bootstrap operates offline. The version and lockfile are
identical. The upgrade diff can be reviewed. The foundation and each project can
verify the build.

Limitations: Node becomes mandatory, and the Nimbus snapshot increases the size
of the foundation.

## Decision

Nimbus is a Project Foundation invariant. All packs automatically enable
`documentation-nimbus` and include the official Nimbus scaffold that
`nimbus.json` tracks.

The minimum Node version is `22.12.0`. `@cloudflare/nimbus-docs` is pinned to
`0.8.2`, and the lockfile is version-controlled. The `verify` command runs the
adapter tests, type check, Nimbus build, and lint.

The Markdown files that `documentation.json` classifies remain the only
editorial sources. The `docs-nimbus/src/content/docs/` collection is regenerated
and ignored by Git.

The local build contains all audiences so that the corpus is navigable.
It does not authorize publication. Each publication process must explicitly
define the permitted collections and prove that it exposes no internal content.

Another engine can supplement Nimbus for a local requirement, but it cannot
replace Nimbus without a new foundation version that supersedes this ADR.

## Consequences

### Positive

- All projects use the same documentation engine.
- A new project receives a scaffold and lockfile that it can verify offline.
- Nimbus build failures cause `verify` to fail.
- The sources remain independent of the generated collection.

### Negative

- Node and npm become universal prerequisites.
- An exploration project also contains a documentation site.
- Nimbus starter updates require review and redistribution.
- Publication requires an audience filter that is separate from the complete local build.

## Implementation

1. Include the official `@cloudflare/create-nimbus-docs` `0.6.3` scaffold.
2. Pin Nimbus and commit the lockfile.
3. Generate the collection from `documentation.json`.
4. Enable the profile automatically in all packs.
5. Add the Nimbus build to local and CI verification.
6. Document migration from `v0.2.0`.

## Verification

- The catalog has no unclassified or duplicate Markdown file.
- The Nimbus profile is present in all four packs.
- Conversion tests pass.
- The Nimbus type check, build, and lint pass.
- The generated collection is absent from Git.
- CI passes for the branch and tag.

## Review

Supersede this decision only if Nimbus is no longer maintained, does not support
the audience requirements, or has a measured and disproportionate cost in
several projects.
