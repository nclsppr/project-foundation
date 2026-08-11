# AGENTS.md

Local adapter for an exploration. It does not redefine the core declared in [`FOUNDATION.md`](FOUNDATION.md).

Read [`BRIEF.md`](BRIEF.md), then [`README.md`](README.md), and the vendored profiles in `docs/foundation/`.

## Sources for each question

| Question | Source |
| --- | --- |
| What work is authorized now? | Explicit owner request, within the foundation security and confidentiality limits |
| What result does the exploration seek? | `BRIEF.md` |
| What exists and operates now? | Repository, configuration, commands, and processes observed now |
| Why was a previous choice made? | Git history or a dated decision, which are not normative for the current state |

An intention is not evidence of state. Report each conflict. Do not silently select one layer.

## Work rules

- Stay within the question, scope, and limit in the brief.
- Inspect the repository state before work starts. Preserve unrelated work.
- Use the canonical commands from the README. Report only evidence that you observed.
- Do not modify `docs/foundation/`. Record an exception in `FOUNDATION.md`. Change a general rule in the Project Foundation repository, then adopt the new version.
- Keep Nimbus and its build gate, including for this exploration.
- Keep `compose.yaml` and its gate. If the exploration starts a local process or
  dependency, declare it in Compose before you document its use.
- Add each delivered change to `CHANGELOG.md`. Record an important decision in the brief or an ADR if the exploration becomes durable.
- Apply `P18` when the task authorizes changes. After verification, commit each coherent work unit. Then, push it immediately to the canonical branch if direct write access is authorized. Otherwise, push it to a dedicated branch.
- Do not declare a work unit complete while its SHA exists only locally. If the push is blocked, report the local SHA, remote target, and exact blocker.
- Run `python3 scripts/check_compose.py` with the `verify` command.
- Use English for every deliverable, all communication, and all technical content. Apply `P20`. A local exception cannot select another language. Preserve only the external forms that `P20` permits.
- Apply `P21` to each first-party runtime log record. Use its minimum evidence in the project verification command.
- Update the conclusion and its limitations in `BRIEF.md`.
- If the exploration becomes a product, stop this lightweight process and use the standard bootstrap process.
