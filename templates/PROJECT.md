# PROJECT.md

## Identity

| Field | Value |
| --- | --- |
| Name | TODO |
| Owner | TODO |
| Class | TODO exploration, prototype, product, or critical |
| Production surface | TODO URL, environment, or not applicable |
| Adopted foundation | [`FOUNDATION.md`](FOUNDATION.md) |

## Problem

TODO Describe the actual problem in one sentence.

## Users

| User | Situation | Need | Primary risk |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

## Expected result

TODO Describe the observable change for the user or operator.

### Evidence of success

| Evidence | Known baseline | Target | Source | Deadline |
| --- | --- | --- | --- | --- |
| TODO | TODO or unknown | TODO | TODO | TODO |

Do not present a target as an achieved result.

## Scope

### Included

- TODO

### Non-goals

- TODO

### Stop or review conditions

- TODO

## State and sequence

- The verified state is in [`STATUS.md`](STATUS.md).
- The delivery order and exit criteria are in [`ROADMAP.md`](ROADMAP.md).
- An intrinsic priority does not replace the delivery order.

## Sources of truth

| Concept | Canonical source | Type | Notes |
| --- | --- | --- | --- |
| Product | TODO | normative | |
| Current state | `STATUS.md` | operational snapshot | Dated and verified |
| Roadmap | `ROADMAP.md` | normative | Sequence authority |
| Change history | `CHANGELOG.md` | historical | Each delivered change and its observable effect |
| Architecture | TODO | normative | |
| API contract | TODO | normative or not applicable | |
| Data schema | TODO | normative or not applicable | |
| Design system | TODO | normative or not applicable | |
| Configuration | `compose.yaml` and TODO additional configuration | operational | Compose provides the integrated local path required by `P19` |
| Delivered code | TODO | operational | |
| Operations | TODO | normative | |
| Decisions | `docs/decisions/` | normative | |
| Documentation | `DOCUMENTATION.md`, `documentation.json`, `docs-nimbus/`, and the generated catalog | normative and derived | Each Markdown file has an audience and passes through Nimbus |
| Generated artifacts | TODO | derived | Identify their source |
| Archives | TODO | historical | Never normative |
| Experiments | TODO | experimental | Isolated |

## Architecture

For a small project, this section can be the canonical source, and the "Architecture" row above points to `PROJECT.md#architecture`. For a larger project, replace the detailed content with a summary and a link to the canonical document. Do not maintain two complete descriptions.

### Components

| Component | Role | Status | Execution | Version | Source | Evidence and date | Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TODO | TODO | current, target, experiment, or removed | development, build, CI, or production | TODO | TODO | TODO | TODO |

### Primary flow

TODO

### External dependencies

| Dependency | Use | Transmitted data | Failure mode | Alternative |
| --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO |

## Environments

| Environment | Platform | Canonical configuration | URL or access | Verification |
| --- | --- | --- | --- | --- |
| Development | Docker Compose and TODO host platform | `compose.yaml` | TODO URL or access | `python3 scripts/check_compose.py`, then path probes |
| CI | TODO | `.github/workflows/verify.yml` | Platform runs | `./scripts/verify.sh` |
| Production | TODO | TODO | TODO | TODO |

## Canonical commands

| Action | Command | Expected result |
| --- | --- | --- |
| Install | TODO | TODO |
| Develop | `docker compose up --build --wait` | All required services become healthy |
| Verify | `./scripts/verify.sh` | Valid catalog, Markdown, tests, type checks, Nimbus build, and Nimbus lint |
| Verify Compose | `python3 scripts/check_compose.py` | Configuration, services, digests, and health checks comply with `P19` |
| Build | TODO | TODO |
| Build documentation | `npm run build --prefix docs-nimbus` | Static Nimbus site generated from classified Markdown files |
| Stop | `docker compose down` | Services stopped and volumes preserved |
| Reset development | TODO command with explicit targets | Only the named development data is removed |
| Deploy | TODO | TODO |
| Check health | TODO | TODO |
| Back up | TODO or not applicable | TODO |
| Restore | TODO or not applicable | TODO |

## Data, security, and confidentiality

- Data classification: TODO
- Secret injection: TODO
- Authentication and authorization: TODO
- Isolation: TODO
- Retention: TODO
- Backup and restore: TODO
- Logging without sensitive data: TODO

## Quality

The applicable project profiles and exceptions exist only in `FOUNDATION.md`.

Verification matrix:

| Risk | Automated control | Manual control | Environment |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

## Delivery

`P18` requires a commit and push for each verified work unit. The local policy
selects the destination. It cannot select no remote delivery.

`P19` requires `compose.yaml` as the integrated local path. A host command can
remain documented as a shortcut. It cannot be the only reproducible procedure.

- Canonical branch: TODO
- Direct push or branch with review: TODO
- Commit convention: TODO
- Artifact: TODO
- Deployment: TODO
- Rollback: TODO
- Final verification: TODO
- Observability: TODO
- Escalation: TODO

## Responsibilities

| Area | Owner | Alternate | Runbook |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

Current risks, blockers, and next evidence are in `STATUS.md`.
Delivered changes are in `CHANGELOG.md`. Important product or technical
decisions are in ADRs.
