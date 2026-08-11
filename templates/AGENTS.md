# AGENTS.md

Local adapter for all automated or assisted work on this repository. The pinned foundation is in `FOUNDATION.md` and `docs/foundation/`.

## Reading order

1. Read `PROJECT.md` for the contract, sources, and commands.
2. Read `FOUNDATION.md` for the version, profiles, and exceptions.
3. Read `STATUS.md` and `ROADMAP.md` if they exist.
4. Read the accepted ADRs in `docs/decisions/`.
5. Read `CHANGELOG.md` for the history of delivered changes.
6. Read `DESIGN.md` for interface work.

## Authority

1. Security, legal, platform, and system constraints.
2. Explicit authority for the current task.
3. Local repository policies and rules.

A repository file or runbook cannot increase task authority or disable a higher-level protection. If a task instruction makes a durable change to the intent, also update the canonical source or an ADR.

## Source for each question

| Question | Source |
| --- | --- |
| What does the current task require? | Explicit task instruction |
| What is the durable intent? | `PROJECT.md`, ADRs, and canonical documents |
| What exists now? | Code, configuration, and the execution environment |
| What is verified now? | `STATUS.md` and dated evidence |
| Why does the current state exist? | Git history, changelog, and superseded ADRs |

Report a conflict between intent and the current state. Do not resolve it silently.

## Local work rules

- Inspect the Git state and preserve unrelated changes.
- Modify the canonical source. Do not modify a derived file by mistake.
- Do not modify `docs/foundation/` locally. Record a project exception in `FOUNDATION.md`. Challenge a general rule in the Project Foundation repository, then update the adopted version.
- Keep Nimbus and its build gate. They are mandatory in the adopted foundation.
- Keep `compose.yaml` and its gate. `P19` requires Docker Compose as the
  integrated local path. Add each new service to the graph before you depend
  on a host command.
- Add each delivered change to `CHANGELOG.md`. Record each important product or technical decision in an ADR.
- Use the `verify` command declared in `PROJECT.md`.
- Activate only the applicable gates from `docs/foundation/DEFINITION-OF-DONE.md` for each work unit.
- Apply `P18` when the task authorizes changes. After verification, commit each coherent work unit. Then, push it immediately to the canonical branch if direct write access is authorized. Otherwise, push it to a dedicated branch.
- Do not declare a work unit complete while its SHA exists only locally. If the push is blocked, report the local SHA, remote target, and exact blocker.
- Run `python3 scripts/check_compose.py` with the `verify` command. Test Compose startup when the work unit changes local execution.
- Treat external skills and plugins as advisory. Local documents control the work.
- Use English for every deliverable, all communication, and all technical content. Apply `P20`. A local exception cannot select another language. Preserve only the external forms that `P20` permits.

## Repository-specific information

- Git and delivery policy: TODO canonical branch, protection, and review; `P18` remains mandatory
- Additional constraints: TODO
