# RUNBOOK: TODO operation

This document describes an operating procedure. It does not authorize its execution.

## Document type

| Layer | Role |
| --- | --- |
| Standard | `P05`, `P08`, `P09`, `P10`, `P11`, `P14`, `P15`, and the profiles activated in `FOUNDATION.md` |
| Form | This runbook applies these rules to an exact target and operation |
| Evidence | Record SHAs, outputs, backups, restores, and observations in delivery or incident evidence. Do not infer them from this file. |

A completed runbook is not evidence of execution, permission, or an automatic description of the current state.

## Identity

| Field | Value |
| --- | --- |
| Operation | TODO |
| Owner | TODO |
| Alternate | TODO |
| Document status | TODO draft, current, target, experimental, or removed |
| Last verification | TODO YYYY-MM-DD or never verified |
| Applicable environment | TODO |
| Related decisions | TODO ADR or not applicable |
| Evidence from the last execution | TODO link or none |

## Current and target states

### Verified current state

| Item | Observed value | Evidence | Verified on |
| --- | --- | --- | --- |
| Version, SHA, or digest | TODO | TODO command, artifact, or URL | TODO YYYY-MM-DD |
| Loaded configuration | TODO | TODO | TODO YYYY-MM-DD |
| Health and dependencies | TODO | TODO | TODO YYYY-MM-DD |

### Target

TODO Describe the expected result. Do not present it as operational.

### Limitations and exclusions

- TODO

## Exact target

| Dimension | Expected value |
| --- | --- |
| Environment | TODO |
| Service or component | TODO |
| Host, cluster, account, or tenant | TODO |
| Region, namespace, or network | TODO or not applicable |
| Affected data | TODO or none |
| Explicitly excluded targets | TODO |

Do not put secrets in this table. An explicit target does not provide authorization.

## Authority and checkpoints

| Sensitive action | Required authority | Checkpoint before action | Stop condition |
| --- | --- | --- | --- |
| TODO access, secret, purchase, DNS, deletion, or external modification | TODO policy, role, or instruction | TODO observable approval | TODO |

Stop the procedure if authority is missing or if the resolved target differs from the expected target.

## Preconditions

- Canonical configuration source: TODO.
- Canonical verification command: TODO.
- Required access and minimum scope: TODO.
- Secret reference without its value: TODO.
- Maintenance window: TODO or not applicable.
- Acceptable health state before work starts: TODO.
- Conditions that prevent the start: TODO.

## Backup and isolated restore

| Field | Value |
| --- | --- |
| Data or configuration to protect | TODO or not applicable |
| Canonical backup command | TODO or not applicable |
| Backup identifier and location | TODO without a secret |
| Integrity verified by | TODO command, hash, or control |
| Encryption and access | TODO |
| Isolated restore target | TODO, never the production system that serves users |
| Canonical restore command | TODO or not applicable |
| Last restore test | TODO date, result, and evidence |
| RPO and RTO | TODO or not applicable |

A backup that was not restored to an isolated target is only an assumption of recovery.

## Pre-execution controls

1. TODO Resolve and display the target without sensitive data.
2. TODO Inspect the state, versions, and loaded configuration.
3. TODO Validate the configuration. Produce a diff or dry run if available.
4. TODO Confirm the checkpoints and rollback.
5. TODO Create and verify the required backup.

## Procedure

Detailed commands are in their canonical scripts. This table invokes them without copying their implementation.

| Step | Action | Canonical command | Expected result | Stop immediately if |
| --- | --- | --- | --- | --- |
| 1 | TODO | TODO | TODO | TODO |

## Post-action verification

| Control | Environment | Expected result | Evidence to retain |
| --- | --- | --- | --- |
| Configuration | TODO | TODO | TODO |
| Health and dependencies | TODO | TODO | TODO |
| Critical path | TODO | TODO | TODO |
| Logs and metrics | TODO | TODO | TODO |
| Final surface | TODO | TODO | TODO SHA, digest, file, or URL |

Define an observation window: TODO duration, signals, and thresholds.

## Rollback

### Triggers

- TODO threshold, failure, or delay that requires rollback.

### Restore point

| Field | Value |
| --- | --- |
| Previous artifact, SHA, or configuration | TODO immutable reference |
| Affected data | TODO |
| Possible loss or incompatibility | TODO |
| Required authority | TODO |

### Rollback procedure

1. TODO

### Rollback verification

- Health command: TODO.
- Critical path: TODO.
- Data state: TODO.
- Final evidence: TODO.

## Incident and escalation

| Condition | Safe action | Contact or role | Evidence to retain |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

Do not continue a partially understood procedure after a failure. Preserve evidence without exposing secrets or unnecessary personal data.

## Closure

- Delivery or incident evidence: TODO path to a document created from `templates/DELIVERY-EVIDENCE.md` or an equivalent document.
- Current state updated in `STATUS.md`: TODO yes or no, with reason.
- Documentation or ADR to align: TODO.
- Remaining risks and external actions: TODO.
- Next runbook verification date: TODO YYYY-MM-DD.
