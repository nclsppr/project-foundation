# Delivery evidence: TODO result

This document records observations for one work unit. It does not create a standard or increase authority.

## Document type

| Layer | Role |
| --- | --- |
| Standard | `P02`, `P03`, `P05`, `P08`, `P09`, `P10`, `P11`, `P14`, `P18`, `P19`, `P20`, `P21`, and the durable profiles activated in `FOUNDATION.md` |
| Form | This file structures the report and the verification limitations |
| Evidence | A command, output, SHA, digest, file, screenshot, or dated observation in the named environment |

Text in this form is not evidence without an associated observable result. Do not paste a secret or unnecessary personal data into this file.

## Reference

| Field | Value |
| --- | --- |
| Work unit | TODO |
| Request or source authority | TODO issue, task, instruction, or decision |
| Author | TODO |
| Verifier | TODO |
| Date | TODO YYYY-MM-DD |
| Branch | TODO |
| Final commit | TODO full SHA or not applicable |
| Final artifact | TODO digest, version, path, or not applicable |
| Profiles applicable to this unit | TODO subset of the profiles activated in FOUNDATION.md, or none |

## Scope

### Requested target

TODO Describe the expected result.

### Observed current result

TODO Describe only what was verified.

### Exclusions

- TODO

### Evidence limitations

- TODO unavailable environment, access, external service, or control.

## Initial state

| Item | Observation | Evidence |
| --- | --- | --- |
| Worktree and unrelated changes | TODO | TODO command or diff |
| Initial version or SHA | TODO | TODO |
| Environment and tool versions | TODO | TODO |
| Target surface state | TODO | TODO |

## Sources and derived artifacts

| Concept or artifact | Canonical source | Derived artifact or consumer | Alignment verified by |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

## Applied gates

Use the `Pxx` identifiers, the profiles that apply to this unit, and the applicable sections of `DEFINITION-OF-DONE.md`. Do not modify the vendored snapshot to mark a delivery as complete.

| Gate or source | Applicable | Reason if not applicable | Performed control | Environment | Result | Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| TODO Pxx, profile, or section | TODO yes or no | TODO | TODO | TODO | TODO success or failure | TODO |

## Automated controls

| Exact command | Directory | Environment and versions | Result | Scope | Evidence |
| --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO exit code and summary | TODO what the control proves and does not prove | TODO |

## Manual or perceptual controls

| Surface | Scenario | Environment | Observation | Result | Evidence |
| --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO browser, device, service, or file | TODO | TODO | TODO |

## External actions and checkpoints

| Action | Exact target | Authority or checkpoint | Executed | Result | Rollback available | Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| TODO or none | TODO | TODO | TODO yes or no | TODO | TODO | TODO |

An action that is described but not authorized remains unexecuted and appears in the remaining actions.

## Rollback, backup, and restore

| Control | Isolated target | Command or procedure | Result | Date | Evidence | Limitation |
| --- | --- | --- | --- | --- | --- | --- |
| Backup | TODO or not applicable | TODO | TODO | TODO | TODO | TODO |
| Restore | TODO isolated target, never the production system that serves users | TODO | TODO | TODO | TODO | TODO |
| Rollback | TODO | TODO | TODO tested, simulated, or not tested | TODO | TODO | TODO |

## Final artifact and surface

| Surface | Environment | SHA, digest, version, or file | Final control | Observed on | Evidence |
| --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO YYYY-MM-DD | TODO |

Do not generalize local evidence to CI, a container, production, or a public URL without a control on that surface.

## Diff and delivery

- Result files: TODO.
- Unrelated changes preserved: TODO.
- Source, derived artifacts, and consumers delivered together: TODO or not applicable.
- Commit and push required by `P18`: TODO SHA, remote, and branch.
- Compose path required by `P19`: TODO services, health, and probes, or a Minimal pack without a local process.
- Runtime logging required by `P21`: TODO applicable schema and failure-path evidence, or emits no first-party runtime log records.
- Deployment required by the scope: TODO or not applicable.
- Final worktree state: TODO.

## Conclusion

| Field | Value |
| --- | --- |
| Observed status | TODO delivered, partial, blocked, or not verified |
| Proven result | TODO |
| Remaining risks | TODO |
| Controls not performed | TODO |
| Remaining external actions and owner | TODO |
| `STATUS.md` or `ROADMAP.md` update | TODO |
