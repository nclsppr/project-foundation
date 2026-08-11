# PROJECT.md

## Identity

| Field | Value |
| --- | --- |
| Name | Project Foundation |
| Owner | Nicolas Pieper |
| Class | Internal product |
| Production surface | None |
| Version | 0.5.2 |
| License | Public repository, no license granted |

## Problem

Projects accumulate useful rules over time. These rules remain distributed, duplicated, and too closely related to one stack or agent tool.

## Users

| User | Situation | Need | Primary risk |
| --- | --- | --- | --- |
| Nicolas | Starts or resumes a project | Find the common foundation immediately | Start again from zero or copy obsolete rules |
| Development agent | Changes a repository | Find local sources, limits, and gates | Invent context or apply generic advice |

## Expected result

A new repository can adopt a consistent core, select its profiles, document its exceptions, and remain independent after it copies the snapshot.

### Success evidence

| Evidence | Target | Source |
| --- | --- | --- |
| Clear bootstrap | A new project can complete the documents without hidden context | `PROJECT-BOOTSTRAP.md` and templates |
| Consistent foundation | Valid links, required files present, and no incomplete value in the core | `./scripts/verify.sh` |
| Traceable adoption | Recorded version, profiles, and exceptions | `templates/FOUNDATION.md` |
| Complete documentation | Each Markdown file has one classification, has an audience, and passes Nimbus checks | `documentation.json`, catalog, Nimbus build, and `./scripts/verify.sh` |
| Common development | A foundation challenge returns to the foundation repository before an upgrade | `ADOPTION.md` and `templates/FOUNDATION.md` |
| Permanently delivered work | Each verified work unit has a resumable remote SHA | `P18`, `AGENTS.md` adapters, and the definition of done |
| Contractual local environment | Each pack has Compose, and each durable project declares a checked service | `P19`, `compose.yaml`, `scripts/check_compose.py`, and bootstrap tests |
| Actionable runtime logs | Each project that emits first-party runtime log records inherits `P21` | `P21`, adapters, and bootstrap tests |

## Scope

### Included

- universal work principles;
- reversible defaults;
- profiles for web, backend and data, production, and experiments;
- profiles for generated artifacts and dependency changes;
- mandatory Nimbus engine, official scaffold, adapter, and lockfile;
- templates for the contract, status, roadmap, agents, ADR, and design;
- runbook and delivery-evidence templates;
- documentation manifest and catalog common to all packs;
- adoption, upstream contribution, and upgrade procedure;
- universal discipline for commits and pushes of verified work units;
- mandatory and checked Docker Compose local orchestration;
- structured, correlatable, and safe first-party runtime log records;
- CI workflow copied to each pack;
- definition of done and origin audit;
- local and CI verification of the foundation.

### Out of scope

- require an application stack, Git hosting provider, or one review model;
- provide an application framework;
- automatically synchronize existing repositories;
- become a runtime dependency;
- replace local decisions or security instructions.

### Review conditions

- one principle causes exceptions in multiple projects;
- the cost to update the vendored snapshot becomes too high;
- a generator measurably reduces bootstrap errors;
- a new project category requires a separate profile.

## State and sequence

- The verified state is in [`STATUS.md`](STATUS.md).
- The delivery order is in [`ROADMAP.md`](ROADMAP.md).
- Structural decisions are in `docs/decisions/`.

## Sources of truth

| Concept | Canonical source | Type |
| --- | --- | --- |
| Purpose and scope | `PROJECT.md` | normative |
| Current version | `VERSION` | normative |
| Current state | `STATUS.md` | operational snapshot |
| Sequence | `ROADMAP.md` | normative |
| Invariants | `PRINCIPLES.md` | normative |
| Defaults | `DEFAULTS.md` | normative and reversible |
| Gates | `DEFINITION-OF-DONE.md` | normative |
| Profiles | `profiles/` | normative, mandatory Nimbus and other optional profiles |
| Decisions | `docs/decisions/` | normative |
| Version history | `CHANGELOG.md` | historical |
| Version policy | `VERSIONING.md` | normative |
| Origin of rules | `AUDIT.md` | historical snapshot |
| Documentation contract | `DOCUMENTATION.md` and `documentation.json` | normative |
| Documentation navigation | `DOCUMENTATION-CATALOG.md` | derived |
| Adoption and upstream contribution | `ADOPTION.md` | normative |
| Templates | `templates/` | derived and reusable |
| Local orchestration | `compose.yaml` and `scripts/check_compose.py` | operational and checked |
| Runtime logging invariant | `PRINCIPLES.md`, `P21` | normative |
| Runtime logging implementation default | `DEFAULTS.md`, `D09` | normative and reversible |
| Runtime logging decision history | `docs/decisions/adr-0007-structured-event-logging.md` | decision record |

## Architecture

The repository contains portable Markdown, Bash 3.2 or later scripts, Python 3.9 or later checks, a Nimbus site in `docs-nimbus/`, and a Docker Compose contract. Git provides history, provenance, and diff checks.

A project adopts a local snapshot of the required files and records its version in `FOUNDATION.md`. The `documentation.json` manifest classifies all Markdown files. Nimbus renders them with Node 22.12 or later.

## Environments

| Environment | Support | Verification |
| --- | --- | --- |
| macOS | Local reference with Git, Bash 3.2, Python 3.9, Node 22.12 or later, and Docker Compose 2.20 or later | `./scripts/verify.sh` |
| Linux | Supported with the same prerequisites | `./scripts/verify.sh` and CI workflow |
| Windows | Supported through WSL2 with the same prerequisites | `./scripts/verify.sh` |

## Canonical commands

| Action | Command | Expected result |
| --- | --- | --- |
| Check prerequisites | `git --version && bash --version && python3 --version && node --version && npm --version && docker compose version` | Git, Bash 3.2, Python 3.9, Node 22.12, npm, and Docker Compose 2.20 are available |
| Verify | `./scripts/verify.sh` | Valid catalog, Markdown, tests, type checking, Nimbus build and lint, and bootstrap |
| Verify Compose | `python3 scripts/check_compose.py` | Valid Compose contract, digests, and lifecycles |
| Verify Nimbus in Compose | `docker compose run --rm documentation-check` | Nimbus checks run in the pinned image |
| Verify a release | `./scripts/verify.sh --release` | Clean worktree, consistent version, and annotated tag on HEAD |
| Regenerate navigation | `python3 scripts/documentation_catalog.py --write` | Catalog aligned with the manifest and Markdown files |
| Build documentation | `npm run build --prefix docs-nimbus` | Static Nimbus site generated from classified Markdown files |
| Deploy | Not applicable | The repository is consumed through a versioned copy |

## Data and security

- The repository requires no personal data or secret.
- Examples must not contain actual sensitive values.
- The public repository grants no reuse license until the owner approves a `LICENSE` file.

## Delivery

- Canonical branch: `main`, published on `origin`.
- A principle change states its reason, evidence, and level.
- Each version updates `CHANGELOG.md`.
- Stable versions have a tag.
- Official repository: `https://github.com/nclsppr/project-foundation.git`.

## Responsibility

| Area | Owner | Recovery source |
| --- | --- | --- |
| Foundation and decisions | Nicolas Pieper | Documentation and Git history |
