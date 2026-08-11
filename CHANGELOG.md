# Changelog

This file describes foundation versions. It is historical and non-normative.

## Unreleased

- Adds `P20` to require English for all deliverables, communications, documentation, code comments, logs, and other technical content.
- Applies the principles of ASD-STE100 and applicable ISO/IEC/IEEE 24765 terminology without declaring formal conformance with ASD-STE100.
- Propagates the rule to adapters, documentation gates, and generated-pack tests.
- Migrates maintained documentation, templates, validation messages, and the Nimbus locale from French to English.
- Documents the invariant, its limited preservation cases, and its verification in ADR-0006.

## 0.5.2 - 2026-07-30

- Runs `scripts/check_compose.py` directly in the Foundation workflow and the generated project workflows before the canonical gate.
- Makes the documentation checker reject removal of the Compose integration from `scripts/verify.sh` or `.github/workflows/verify.yml`.
- Adds two adversarial tests that remove each call from a generated project.
- Keeps the trust boundary explicit. Only a GitHub rule that makes the workflow required prevents simultaneous changes to the check and workflow.

## 0.5.1 - 2026-07-30

- Runs the Compose documentation job in an anonymous workspace and mounts source files as read-only.
- Prevents the job that runs as root from leaving files that the runner user cannot replace during tag verification.
- Replaces `v0.5.0` as the recommended version. Its `main` run passes, but its tag run identified this Linux permission error.

## 0.5.0 - 2026-07-30

- Adds `P19`, an invariant that requires a root `compose.yaml` file and Docker Compose as the canonical path for integrated local execution.
- Adds `scripts/check_compose.py` to reject missing files, empty durable packs, external images without a digest, and long-running services without a health check.
- Generates `compose.yaml`, the Compose checker, and a GitHub Actions workflow in all four packs.
- Adds a finite service that is pinned by digest to verify the foundation documentation in Compose.
- Tests bypass attempts that remove the file, checker, or workflow. Also tests mutable images and missing health checks.
- Documents the decision in ADR-0005 and the migration from `v0.4.0`.
- Records the first actual adoption. Parkventory uses the `v0.4.0` snapshot, remains independent after a clean public clone, and passes its CI gate at SHA `d9a50adb04ad1c7e038d7c672723c6dd4bba07d4`.
- Marks adoption-test phase F02 as `done` before the Parkventory upgrade to this release.

## 0.4.0 - 2026-07-30

- Adds `P18`, an invariant that requires a commit and push for each coherent and verified work unit when the task permits repository changes.
- Requires `main` as the direct target when it is writable. Requires a dedicated branch when the canonical branch is protected or requires review.
- Prevents a local exception from silently keeping completed work only in the worktree or local history.
- Aligns `AGENTS.md` adapters, the definition of done, bootstrap, delivery evidence, adoption, and the release process with this discipline.
- Adds a bootstrap test that verifies propagation of `P18` and its operational implementation to all packs.
- Documents the decision in ADR-0004 and the migration from `v0.3.1`.

## 0.3.1 - 2026-07-27

- Corrects Nimbus guide links so that they remain valid in a generated project and do not depend on files specific to the Project Foundation repository.
- Adds the Nimbus build, search, and lint for a generated Full pack to the bootstrap tests.
- Verifies that the copied Nimbus lockfile remains identical to the release lockfile.
- Replaces `v0.3.0` as the recommended version for each new adoption.

## 0.3.0 - 2026-07-27

- Makes Nimbus mandatory in all packs, including Minimal.
- Adds the official Nimbus `0.6.3` scaffold, pinned `@cloudflare/nimbus-docs` `0.8.2`, and its npm lockfile.
- Pins `yaml` `2.9.0` to resolve the security advisory in the scaffold version.
- Adds a generic adapter that generates the Nimbus collection from classified Markdown files.
- Adds conversion tests, type checking, build, Pagefind, and Nimbus lint to `verify` and CI.
- Automatically enables `documentation-nimbus` during bootstrap and prevents its local removal.
- Supersedes ADR-0002 with ADR-0003 and documents the incompatible migration from `v0.2.0`.
- Requires Node `22.12.0` or later and npm to verify an adopted project.
- Makes `CHANGELOG.md` mandatory in all packs and requires an ADR to trace important product decisions.

## 0.2.0 - 2026-07-27

- Adds a contract that classifies each maintained Markdown file as public, internal, reference, or archive.
- Adds a manifest, complete catalog, and orphan Markdown check to all packs.
- Adds the Nimbus profile as an optional default for durable published documentation, without a web dependency in the core.
- Adds a procedure for adoption from the official repository and upgrade by tag and SHA.
- Prohibits silent changes to the vendored snapshot. A foundation challenge requires a change in the Project Foundation Git repository and a new release.
- Publishes the repository and its tags on `nclsppr/project-foundation` without adding a default license.

## 0.1.0 - 2026-07-26

- Creates invariants, defaults, and bootstrap rules.
- Adds the definition of done for each change type.
- Adds profiles for web, backend and data, production infrastructure, and experiments.
- Adds profiles for generated artifacts and dependency changes.
- Adds templates for the project, brief, status, roadmap, agents, ADR, design, runbook, and delivery evidence.
- Adds Minimal, Standard, Full, and Critical packs with a safe initializer.
- Adds local and CI verification for the foundation.
- Rejects bootstrap from a dirty worktree and removes credentials from provenance.
- Verifies structure, profiles, and placeholders in generated projects.
- Adds a canonical version that is checked against the repository, changelog, and tag.
- Documents the cross-audit of Surplasse, the personal website, Papers Empire, and the VPS runbook.
