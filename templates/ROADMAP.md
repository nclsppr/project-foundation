# ROADMAP.md

Canonical source for the delivery order. A feature list or MoSCoW priority describes intrinsic importance. It does not define sequence.

## Product result

TODO Describe the destination. Do not present it as delivered.

## Sequence principles

- Each phase produces an observable capability.
- A dependency comes before its dependent item.
- Each phase identifies its exclusions to prevent silent scope expansion.
- An exit criterion is evidence, not an impression of progress.
- A completed phase remains in the history.
- Detailed current state is in `STATUS.md`.

## Overview

| Order | ID | Phase | User or operational result | Macro state | Exit criterion | Observed evidence | Completed on |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | F01 | TODO | TODO | planned | TODO | empty until proven | |

Allowed states: `planned`, `in_progress`, `blocked`, `done`, `cancelled`.

## Phase F01: TODO

### Objective

TODO

### Dependencies

- TODO

### Included

- TODO

### Excluded

- TODO

### Risks

- TODO

### Exit criterion

- TODO observable evidence, environment, and expected result

### Rollback or abandonment

- TODO

## Update rule

- Update a phase state only with its evidence.
- Record current execution details and blockers in `STATUS.md`.
- Create an ADR if an architectural decision changes the sequence.
- Do not create a second roadmap in a tool, README, or changelog.
