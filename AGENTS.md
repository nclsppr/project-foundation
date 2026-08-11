# AGENTS.md

Maintenance rules for this foundation. Read `README.md` first. Then read `PRINCIPLES.md`.

## Canonical source

- A universal rule is in `PRINCIPLES.md`.
- A reversible choice is in `DEFAULTS.md`.
- A context-specific requirement is in `profiles/`.
- The files in `templates/` show how a project references these rules.
- `DOCUMENTATION.md` and `documentation.json` define the classification and audience of all Markdown files.
- `AUDIT.md` explains the origin of the choices. It is a historical, non-normative snapshot.
- `CLAUDE.md` is an adapter. It does not duplicate any rule.

## Change rules

- Never invent a source, repository state, or verification result.
- Preserve the separation between invariants, defaults, and profiles.
- Do not add a stack, brand, hosting provider, product language, or project-specific Git workflow to the core.
- A rule must state its reason, minimum evidence, and exception mechanism.
- Define a normative concept in one location only. Other files reference it or convert it into a check. They do not create a second rule.
- Put detailed commands in a canonical script when they are executable. The documentation explains how to run the script.
- External skills and plugins provide advice only. The rules, ADRs, and profiles in this repository control the work.
- Put input markers in `templates/`. The core must not contain values that require completion.
- Classify each new Markdown file exactly once in `documentation.json`. Then regenerate `DOCUMENTATION-CATALOG.md`.
- Nimbus is mandatory. Do not remove `docs-nimbus/`, its lockfile, or its `verify` gate without an ADR and a new foundation version.
- Apply `P19`. Keep `compose.yaml`. Declare each local service in Compose before you make it a dependency. Then run `python3 scripts/check_compose.py`. A host command can remain a shortcut. It must not be the only integrated path.
- Apply `P18`. After verification, commit each coherent work unit. Push it immediately to `main` when direct write access is permitted. Otherwise, push it to a dedicated branch.
- Do not keep a completed work unit only in the local repository. If the push is blocked, keep and report the local SHA, the remote target, and the exact blocker.
- Write all technical content in English. This requirement includes deliverables, communications, documentation, code comments, logs, and other technical content. Apply `P20`. Use absolute dates. Use English for new internal identifiers and paths. Preserve external identifiers as `P20` requires. Do not use em dashes or en dashes.
- Apply `P21` to each first-party runtime log record. Use its minimum evidence in the project verification command.

## Before each commit and push

- Check local Markdown links.
- Run `python3 scripts/documentation_catalog.py --write`. Then inspect the catalog diff.
- Check that core files contain no values that require completion.
- Check that a new rule does not already exist in another location.
- Run `python3 scripts/check_compose.py` and verify each change to `compose.yaml`.
- Run `git diff --check`.
- Inspect the complete diff. Commit only the foundation scope.
- Push immediately after the commit. Then verify that the SHA exists on the remote repository.
