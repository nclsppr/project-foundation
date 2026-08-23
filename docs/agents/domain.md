# Domain documentation

This repository uses the single-context layout.

## Before exploration

Follow the root agent instructions first. Then read these sources as they apply
to the task:

- `PROJECT.md` maps the repository scope and its sources of truth.
- `CONTEXT.md` at the repository root contains a domain glossary if it exists.
- `docs/decisions/` contains the structural decisions. Read each decision that
  affects the area under review, and follow a replacement when a decision is
  superseded.
- `PRINCIPLES.md`, `DEFAULTS.md`, and the enabled files in `profiles/` define
  invariants, reversible choices, and context-specific requirements.

If `CONTEXT.md` does not exist, continue without reporting its absence. The
domain-modeling skill creates it only after the project resolves terms that
need a glossary.

## Vocabulary

Use the terms from `PROJECT.md`, the applicable foundation rules, and
`CONTEXT.md` when present. Do not replace a defined term with a synonym. If the
required term is absent, verify that the task does not introduce project-specific
language into the foundation before proposing a glossary update.

## Decision conflicts

Report any proposal that conflicts with an accepted decision in
`docs/decisions/`. Name the decision and explain why it may need review. Do not
silently override it.
