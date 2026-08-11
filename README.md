# Project Foundation

A common foundation to start, resume, and develop a project without redefining the work rules each time.

This repository is not a framework, a code generator, or a large `AGENTS.md` file to copy without review. It separates stable rules from choices that depend on the product, risk, and stack.

## Why this foundation has a separate repository

The foundation applies to all projects. It must not be in an infrastructure repository, an application project, or the configuration of a specific agent.

A separate repository provides:

- versioned history;
- one canonical source;
- local, VPS, or CI use without coupling to one project;
- changes that can be reviewed and reverted;
- small adapters for Codex, Claude Code, or another tool.

The decision not to put this foundation in `vps/ai` is documented in [`AUDIT.md`](AUDIT.md). The permanent principle is simple. Rules that apply to multiple projects remain separate from server operations. VPS production rules are a foundation profile, not the container for the foundation.

## The three levels

1. **Invariants**: Rules that apply to every project. They are in [`PRINCIPLES.md`](PRINCIPLES.md).
2. **Defaults**: Initial choices that an explicit decision can override. They are in [`DEFAULTS.md`](DEFAULTS.md).
3. **Local profiles**: Permanent policies enabled for the contexts that the project must control. They are in [`profiles/`](profiles/). Their gates apply only to applicable work units.

A local project can make the foundation requirements stronger. It does not copy the complete foundation and does not silently contradict it.

## Delivery discipline

`P18` makes Git publication mandatory for each work unit when the task permits repository changes. Verify the work unit, commit it, and push it immediately. Push directly to the canonical branch when its policy permits this. Use a dedicated branch when the canonical branch is protected or requires review. Do not keep a completed delivery only in the local repository.

## Local orchestration

`P19` makes Docker Compose mandatory. Each project receives a root `compose.yaml` file, a checker, and a CI workflow. Standard, Full, and Critical packs fail verification until they declare at least one actual service. External images are pinned by digest. Long-running services have a health check. Finite commands are identified as jobs.

A host command can provide a shortcut. The common integrated path remains `docker compose up --build --wait`. The `verify` command rejects removal of the contract or its gate.

## Documentation contract

Each maintained Markdown file is part of the project documentation, but it is not necessarily public. `documentation.json` classifies each `.md` file exactly once as public, internal, reference, or archive. [`DOCUMENTATION-CATALOG.md`](DOCUMENTATION-CATALOG.md) provides complete navigation. The `verify` command rejects orphan files.

Markdown files remain the editorial sources. Nimbus is the mandatory engine for all projects through [`profiles/documentation-nimbus.md`](profiles/documentation-nimbus.md). All packs copy the scaffold, pinned version, and lockfile, including the Minimal pack. The complete contract is in [`DOCUMENTATION.md`](DOCUMENTATION.md).

## Contents

| File | Purpose |
| --- | --- |
| [`PROJECT.md`](PROJECT.md) | Stable contract for this repository |
| [`STATUS.md`](STATUS.md) | Verified state of this repository |
| [`ROADMAP.md`](ROADMAP.md) | Sequence for this repository |
| [`VERSION`](VERSION) | Canonical current version |
| [`CHANGELOG.md`](CHANGELOG.md) | History of each delivered change and its effect |
| [`PRINCIPLES.md`](PRINCIPLES.md) | Universal invariants and required minimum evidence |
| [`DEFAULTS.md`](DEFAULTS.md) | Initial values and decisions that must become explicit |
| [`PROJECT-BOOTSTRAP.md`](PROJECT-BOOTSTRAP.md) | Procedure to create a project from zero |
| [`DEFINITION-OF-DONE.md`](DEFINITION-OF-DONE.md) | Common completion criteria and gates for each change type |
| [`VERSIONING.md`](VERSIONING.md) | Compatibility, releases, and snapshot upgrades |
| [`ADOPTION.md`](ADOPTION.md) | Project inclusion and contribution to the upstream foundation |
| [`DOCUMENTATION.md`](DOCUMENTATION.md) | Classification, audiences, and rendering for all Markdown files |
| [`DOCUMENTATION-CATALOG.md`](DOCUMENTATION-CATALOG.md) | Complete navigation generated from the manifest |
| [`docs-nimbus/`](docs-nimbus/) | Mandatory Nimbus scaffold, adapter, configuration, and lockfile |
| `compose.yaml` | Foundation Compose path with a pinned image |
| `scripts/check_compose.py` | Generic check for `P19` |
| [`AUDIT.md`](AUDIT.md) | Origin of rules, exclusions, and observed drift |
| [`templates/AGENTS.md`](templates/AGENTS.md) | Short local contract that agents can find |
| [`templates/PROJECT.md`](templates/PROJECT.md) | Product record, sources of truth, and commands |
| [`templates/STATUS.md`](templates/STATUS.md) | Dated snapshot of the verified state |
| [`templates/ROADMAP.md`](templates/ROADMAP.md) | Sequence authority and exit criteria |
| [`templates/FOUNDATION.md`](templates/FOUNDATION.md) | Adopted foundation version, profiles, and exceptions |
| `templates/compose.yaml` | Initial Compose contract for all packs |
| `templates/.github/workflows/verify.yml` | Verification CI copied to each project |
| [`templates/README.md`](templates/README.md) | Entry point for a minimal project |
| [`templates/README-standard.md`](templates/README-standard.md) | Entry point for a prototype or product |
| [`templates/CHANGELOG.md`](templates/CHANGELOG.md) | Mandatory history of delivered changes |
| [`templates/BRIEF.md`](templates/BRIEF.md) | Small contract for an exploration |
| [`templates/AGENTS-minimal.md`](templates/AGENTS-minimal.md) | Short adapter for an exploration |
| [`templates/ADR.md`](templates/ADR.md) | Versioned structural decision |
| [`templates/DESIGN.md`](templates/DESIGN.md) | Visual and user experience contract for an interface |
| [`templates/RUNBOOK.md`](templates/RUNBOOK.md) | Operating procedure with checkpoints and rollback |
| [`templates/DELIVERY-EVIDENCE.md`](templates/DELIVERY-EVIDENCE.md) | Dated evidence for a work unit |
| [`profiles/web.md`](profiles/web.md) | Web, accessibility, responsive design, SEO, and performance |
| [`profiles/backend-data.md`](profiles/backend-data.md) | APIs, data, migrations, and integrations |
| [`profiles/infrastructure-production.md`](profiles/infrastructure-production.md) | Production, secrets, backups, and risky changes |
| [`profiles/experiment.md`](profiles/experiment.md) | Isolated, truthful, and removable prototype |
| [`profiles/generated-artifacts.md`](profiles/generated-artifacts.md) | Sources, derived artifacts, provenance, and consumers |
| [`profiles/dependency-change.md`](profiles/dependency-change.md) | Need, license, supply chain, cost, and third-party removal |
| [`profiles/documentation-nimbus.md`](profiles/documentation-nimbus.md) | Mandatory, derived, versioned, and verified Nimbus documentation |
| [`examples/minimal-web/`](examples/minimal-web/) | Fictional description of the Minimal path, not a generated repository |

## Start a project

Clone a release from the [official repository](https://github.com/nclsppr/project-foundation). Read [`ADOPTION.md`](ADOPTION.md) and [`PROJECT-BOOTSTRAP.md`](PROJECT-BOOTSTRAP.md). Then select a proportional pack:

| Pack | Use | Local documents |
| --- | --- | --- |
| Minimal | Short exploration | README, brief, changelog, agent adapter, foundation version |
| Standard | Prototype | Project contract, verified status, roadmap, changelog, agent adapter, foundation version |
| Full | Durable product | Standard, an ADR for each structural decision, and design documentation when necessary |
| Critical | Sensitive data, money, or critical production | Full, runbook, delivery evidence, and stronger profiles |

The bootstrap command copies the pack, core snapshot, and selected profiles without overwriting a file:

```bash
./scripts/bootstrap.sh \
  --target /absolute/path/to/project \
  --class prototype \
  --profiles web,experiment
```

The bootstrap requires Git, Bash 3.2 or later, and Python 3.9 or later. It does not require a third-party Python package. Project verification also requires Node 22.12.0 or later, npm, Docker, and Docker Compose 2.20.0 or later.

Use `--dry-run` to list the targets before a write. `PROJECT-BOOTSTRAP.md` documents the manual procedure.

An actual bootstrap requires a committed foundation version and a clean worktree. Provenance records the complete commit and a remote URL without credentials. It never records uncommitted content.

The project does not depend on this repository at runtime and does not require a relative path to another clone. The vendored snapshot is versioned with the project. Do not edit it locally. Put exceptions in `FOUNDATION.md`, `PROJECT.md`, or an ADR. An upgrade replaces the snapshot with a new foundation version and requires review of the diff.

This boundary is intentional. If a rule applies only to one project, that project documents an exception. If a general rule must change, make the change in the official Project Foundation Git repository. Include its tests and create a new release. The consuming project then adopts this tag and SHA. A direct change to `docs/foundation/` creates a silent fork.

Profiles declared in `FOUNDATION.md` are permanent policies. Delivery evidence enables only the applicable subset for its work unit. Copied verification scripts are local adapters. During an upgrade, compare their new baseline and merge corrections without overwriting project gates.

## Truth hierarchy

Separate normative truth from operational truth:

- accepted ADRs and canonical documents define the intended state;
- code, executable configuration, and the running system define the actual state;
- generated artifacts, archives, changelogs, and dated audits provide evidence or history. They are not a current rule.

If these layers differ, do not silently select the most convenient version. Describe the difference and verify its effect. Then align the documentation and implementation in an explicit work unit.

## Develop the foundation

A new rule must answer four questions:

1. Which recurring problem does it prevent?
2. Is it an invariant, a default, or a profile?
3. What evidence proves that the project follows it?
4. How and why can the project make an exception?

Do not add a rule to the core if it has no reason, no possible check, or no clear boundary.

[`ADOPTION.md`](ADOPTION.md) describes the upstream contribution and upgrade procedure.

The repository is public, but it does not currently grant a reuse license. Adding a `LICENSE` file remains an explicit owner decision.
