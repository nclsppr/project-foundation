# Nimbus site maintenance

This directory contains the mandatory Nimbus scaffold for Project Foundation.
`nimbus.json` continues to track it, but its commands and adapter implement the
foundation documentation contract.

The normative rules are in [`DOCUMENTATION.md`](../DOCUMENTATION.md).
In an adopted project, the mandatory profile is vendored at
`docs/foundation/profiles/documentation-nimbus.md`. The original decision remains
in Project Foundation at
`docs/decisions/adr-0003-mandatory-nimbus.md`.

## Sources and derived files

- The Markdown files classified by `documentation.json` are the only editorial sources.
- `scripts/sync-content.mjs` generates `src/content/docs/` from this inventory.
- Never edit or commit the generated collection, `dist/`, `.astro/`, or `node_modules/`.
- This file belongs to the reference documentation collection.

## Prerequisites

- Node `22.12.0` or later;
- npm;
- Python `3.9` or later for the source catalog.

npm is the canonical package manager. Do not introduce a second lockfile.

## Canonical commands

Run these commands from the project root:

| Action | Command |
| --- | --- |
| Install the exact lockfile | `npm ci --prefix docs-nimbus` |
| Synchronize the sources | `npm run sync --prefix docs-nimbus` |
| Start development | `npm run dev --prefix docs-nimbus` |
| Test, type-check, build, and lint | `npm run check --prefix docs-nimbus` |
| Check the upstream scaffold | `npm run outdated --prefix docs-nimbus` |
| Verify the complete project | `./scripts/verify.sh` |

## Modify the scaffold

1. Read `nimbus.json` and check the target upstream version.
2. Compare the new scaffold in an isolated temporary directory.
3. Apply only changes that you understand. Do not overwrite the adapter, content schema, audience configuration, or project scripts.
4. Update the exact dependency and `package-lock.json` in the same change.
5. Run `./scripts/verify.sh`.
6. Record the decision if the documentation contract, audiences, or minimum Node version changes.

## Publication

The local build contains all audiences so that the corpus is navigable.
Do not publish it as is. A published surface explicitly selects its permitted
collections and proves that it exposes no internal document.
