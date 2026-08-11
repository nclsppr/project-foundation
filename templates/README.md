# TODO project name

TODO Describe the exploration question and the target observable result in one sentence.

> Limited exploration. Scope, assumptions, verified state, and conclusion are in [`BRIEF.md`](BRIEF.md).

## Start

Foundation prerequisites: Git, Python `3.9` or later, Node `22.12.0` or later,
npm, Docker, and Docker Compose `2.20.0` or later. Exploration-specific
prerequisites: TODO or none.

| Action | Command | Expected result |
| --- | --- | --- |
| Install commit verification | `./scripts/install_foundation_hook.sh` | Git uses the versioned Foundation pre-commit hook |
| Install | TODO or not applicable | TODO |
| Start | TODO | TODO URL, output, or file |
| Verify | `./scripts/verify.sh` | Valid catalog, Markdown, and Nimbus build |
| Verify Compose | `python3 scripts/check_compose.py` | Compose contract complies with `P19` |
| Stop or clean up | TODO or not applicable | TODO |

Mark a missing command as not applicable. Do not present a future command as available.

## Documentation map

- [`BRIEF.md`](BRIEF.md): Question, scope, facts, assumptions, and dated conclusion.
- [`CHANGELOG.md`](CHANGELOG.md): Delivered changes and observable effects.
- [`FOUNDATION.md`](FOUNDATION.md): Foundation version, activated profiles, and local exceptions.
- `foundation.lock.json`: Exact Foundation release, commit, and managed-file hashes.
- [`DOCUMENTATION-CATALOG.md`](DOCUMENTATION-CATALOG.md): Complete navigation for Markdown files and their audiences.
- `docs-nimbus/`: Mandatory documentation engine, adapter, configuration, and lockfile.
- [`AGENTS.md`](AGENTS.md): Minimum routing for assisted work.
- `docs/foundation/`: Vendored snapshot of the core and profiles. Do not modify it locally.

This README provides navigation only. It does not copy the brief, foundation rules, or evidence.
