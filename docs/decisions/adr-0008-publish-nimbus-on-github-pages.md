# ADR-0008: Publish Nimbus on GitHub Pages

- Status: accepted
- Implementation status: in progress
- Date: 2026-08-11
- Last verification: 2026-08-11, local audience-filtered build with the `/project-foundation` base path
- Owner: Nicolas Pieper
- Supersedes: none
- Superseded by: none

## Context

Project Foundation builds Nimbus during verification, but it does not publish
the generated site. Selecting `main` as a GitHub Pages branch does not run the
Astro build. The branch contains source files and no root `index.html` file.

The complete local Nimbus build also includes every documentation visibility.
ADR-0003 prohibits publication of that build without an audience filter. A
deployment must exclude internal content and must support the repository base
path used by GitHub Pages.

## Decision problem

How can Project Foundation publish useful Nimbus documentation after each
verified change without committing generated files or exposing an unauthorized
documentation audience?

## Considered options

### Publish `main` as a branch source

Advantage: GitHub Pages configuration is small.

Limitations: GitHub Pages receives the repository sources, not the built Astro
site. No root `index.html` file exists. This option also has no audience gate.

### Commit the generated site to a publication branch

Advantage: GitHub Pages can serve the committed output directly.

Limitations: Generated files enter Git history and can drift from their
Markdown sources. A failed or interrupted update can leave stale pages.

### Deploy a verified Actions artifact

Advantages: The workflow builds from the selected commit, applies an explicit
audience filter, verifies the output, and deploys one immutable artifact. The
generated site does not enter Git history.

Limitations: Publication depends on GitHub Actions and GitHub Pages. The target
repository must enable Pages.

## Decision

Use a dedicated GitHub Actions workflow to publish Nimbus from `main`. Build the
site with the URL metadata returned by GitHub Pages. Upload `docs-nimbus/dist`
as a Pages artifact and deploy it to the `github-pages` environment.

Authorize the `public` and `reference` visibility values for this repository.
Exclude `internal` and `archive`. The reference collection contains the
foundation decisions, profiles, templates, examples, and Nimbus maintenance
guide. These files are stable inputs for foundation users and are suitable for
the public documentation surface.

Use `NIMBUS_VISIBILITIES` as the generic publication filter. Require a
publication source URL. If an included page links to an excluded source file,
link to the immutable repository source for the deployed commit instead of
generating an unauthorized Nimbus page.

Clear the generated site, Astro content cache, and Nimbus cache before each
build. This prevents a filtered build from retaining a route that a previous
complete local build generated.

Apply `NIMBUS_BASE_PATH` to site routes and generated metadata. Verify that the
publication contains no origin-root URL that would leave the repository path.

Pin each third-party action by commit SHA. Keep the GitHub Pages workflow local
to Project Foundation. Do not copy this hosting choice into generated projects.

## Consequences

### Positive

- The documentation has a stable public URL.
- Each deployment corresponds to one repository commit.
- Internal and archive pages do not enter the artifact.
- Git history contains sources and build logic, not generated site files.
- Repository-subpath navigation, search, metadata, and agent indexes use the
  correct base path.

### Negative

- GitHub Actions and GitHub Pages become deployment dependencies for this
  repository.
- A Pages configuration or permission error can block publication while normal
  repository verification remains successful.
- Reference visibility requires an explicit review before its scope changes.

## Verification

- Run the complete foundation verifier.
- Run the audience-filtered publication build with the production base path.
- Verify that no generated page has `internal` or `archive` visibility.
- Verify that origin-root URLs are absent from the artifact.
- Verify the Pages workflow and deployment for the final `main` commit.
- Open the deployed root page, one reference page, search assets, `llms.txt`,
  and `sitemap-index.xml`.

## Rollback

Revert the workflow and adapter change. GitHub Pages keeps the last successful
artifact until an administrator disables the site or another deployment
replaces it. Restore the last verified workflow commit to republish a known
artifact.

## Review

Review this decision if the repository becomes private, the authorized
visibility set changes, a custom domain replaces the repository path, or
GitHub Pages no longer satisfies the publication requirements.
