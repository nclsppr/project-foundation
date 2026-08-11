# Bootstrap a New Project

Objective: Convert an idea into a first usable, verifiable, and transferable increment. Do not install a complete architecture too early.

## Phase 0. Classify the project

Select one initial class:

| Class | Purpose | Primary requirement |
| --- | --- | --- |
| Exploration | Answer a question | Time limit and written conclusion |
| Prototype | Test an experience or feasibility | Isolation and easy removal |
| Product | Serve actual users | Quality, operations, and continuity |
| Critical | Process money, identity, sensitive data, or a vital operation | Security, audit, restoration, and stronger gates |

An exploration must not inherit all infrastructure from a critical product. Reclassify a prototype if it receives actual data.

## Phase 1. Establish the facts

- [ ] Describe the problem in one sentence.
- [ ] Identify the users and their situation.
- [ ] Describe the expected observable result.
- [ ] State the non-goals.
- [ ] List known constraints and their source.
- [ ] Identify the applicable data, secrets, payments, or rights.
- [ ] Separate facts from assumptions.
- [ ] Define the conditions that stop the project.

Do not select the stack until these items have sufficient answers.

## Phase 2. Define the repository contract

Select the pack before you copy files:

| Class | Pack | Required files |
| --- | --- | --- |
| Exploration | Minimal | `README.md`, `BRIEF.md`, `CHANGELOG.md`, `AGENTS.md`, `FOUNDATION.md` |
| Prototype | Standard | `README.md`, `PROJECT.md`, `STATUS.md`, `ROADMAP.md`, `CHANGELOG.md`, `AGENTS.md`, `FOUNDATION.md` |
| Product | Full | Standard, an ADR for each structural decision, and `DESIGN.md` for an interface |
| Critical | Critical | Full, `RUNBOOK.md`, delivery evidence, and risk profiles |

All packs also add `DOCUMENTATION.md`, `documentation.json`, `DOCUMENTATION-CATALOG.md`, the `docs-nimbus/` scaffold, `compose.yaml`, CI, and their checks. Nimbus and Docker Compose are mandatory, including for an exploration. These files do not make the complete repository public. They give each Markdown file a classification and make it accessible to the correct audience.

- [ ] Initialize Git according to the selected default or local policy.
- [ ] Copy only the selected pack.
- [ ] Record the pack in `FOUNDATION.md` and the applicable class in the brief or `PROJECT.md`.
- [ ] Add the `CLAUDE.md` stub only when necessary.
- [ ] Select the permanent profiles that the project must support.
- [ ] Enable `backend-data` or `infrastructure-production` for a critical project.
- [ ] Confirm that all technical content uses English and follows `P20`.
- [ ] Define the license or explicitly state that the project remains private.
- [ ] Add `.gitignore` and a configuration example without a secret.
- [ ] Identify the project owner.
- [ ] Copy the core and selected profiles to `docs/foundation/`.
- [ ] Classify existing Markdown files as public, internal, reference, or archive.
- [ ] Verify that the mandatory `documentation-nimbus` profile is enabled.
- [ ] Verify that `compose.yaml`, `scripts/check_compose.py`, and the CI workflow are present.

Delete non-applicable sections instead of completing a long list with `N/A`. At the end of this phase, no input marker remains in the copied files.

The gates of a permanent profile apply only to work units that meet its trigger. If a later work unit requires a new profile, vendor it from the pinned foundation commit. Update `FOUNDATION.md` in the same work unit.

## Phase 3. Map the sources of truth

For a Standard or larger pack, complete these sources in `PROJECT.md`:

- [ ] vision and scope;
- [ ] roadmap and delivery order;
- [ ] architecture;
- [ ] API contract or data schema;
- [ ] design system;
- [ ] environment configuration;
- [ ] operations;
- [ ] decisions;
- [ ] history of delivered changes;
- [ ] generated artifacts and their source;
- [ ] archives and experiments;
- [ ] documentation collections and audiences.

A missing source requires a decision. It does not permit information duplication. An exploration keeps this map in its brief only if the map supports the tested question.

The stable contract remains in `PROJECT.md`. The verified state is in `STATUS.md`. The delivery order and exit criteria are in `ROADMAP.md`.

Add each new `.md` file to a collection in `documentation.json`. Web renderings remain derived from the classified sources. Record the Nimbus version, configuration, and build command as local sources of truth.

## Phase 4. Make the first decisions

For a Standard or larger pack, put an important product decision in an ADR if it permanently changes the users, commitment, scope, business rule, or structural priority. For a Full or Critical pack, also create an ADR for each technical choice that is costly to change:

- [ ] users, commitment, and structural product constraints;
- [ ] important business rules, pricing, or rights;
- [ ] repository structure and module boundaries;
- [ ] stack and versions;
- [ ] storage and migrations;
- [ ] authentication and data boundaries;
- [ ] public contract;
- [ ] deployment strategy;
- [ ] external dependencies;
- [ ] generation or AI approach.

Each ADR contains a simpler alternative and explains why it is not sufficient.

The bootstrap creates the `docs/decisions/` directory. It does not create an empty decision. Copy `templates/ADR.md` only when you can document an actual decision.

## Phase 5. Make the project reproducible

- [ ] Pin versions and commit lockfiles.
- [ ] Document prerequisites.
- [ ] Declare each application and dependency for integrated local execution in `compose.yaml`.
- [ ] Pin each external image by digest. Build locally only from an explicit source.
- [ ] Add a health check to each long-running service. Add `foundation.lifecycle=job` to a finite command.
- [ ] For a Standard, Full, or Critical pack, replace the empty `services` table with at least one actual service.
- [ ] Provide clean installation from a new clone when installation is necessary.
- [ ] Always provide `verify`. Provide `dev`, `build`, `stop`, and `reset` when they apply.
- [ ] Describe variables without providing secret values.
- [ ] Verify the environment that the running processes use.
- [ ] Make CI run `verify`.
- [ ] Run `python3 scripts/check_compose.py`. Then run `docker compose up --build --wait` and the applicable checks.
- [ ] Verify that `docker compose down` preserves volumes. Document each destructive reset separately.
- [ ] Install Node `22.12.0` or later and npm for the Nimbus build.
- [ ] Declare the supported platforms.

A guide is not complete if it cannot be used again. Remove actions that do not apply instead of assigning a false command to them.

## Phase 6. Define the controls

- [ ] Enable applicable format, lint, and test checks.
- [ ] Define the manual verification matrix.
- [ ] Add secret detection.
- [ ] Define the dependency policy.
- [ ] Document destructive changes.
- [ ] Provide backup and restoration if data persists.
- [ ] Define health, logs, and metrics if a service runs.
- [ ] Define accessibility and performance budgets if an interface exists.

Codex or Claude integrations can call these controls. They must not be the only implementation.

## Phase 7. Deliver a vertical work unit

The first work unit must include the complete system path with the minimum number of substitutes:

- [ ] one actual user or operational action;
- [ ] the minimum data path;
- [ ] a success state and a failure state;
- [ ] automated evidence;
- [ ] verification on the final surface;
- [ ] updated documentation;
- [ ] the change added to `CHANGELOG.md`;
- [ ] no future item presented as delivered.

Do not build all technical foundations before you demonstrate a useful flow.

## Phase 8. Prepare delivery

- [ ] Define the immutable artifact or delivered SHA if there is a delivery.
- [ ] Separate build, verification, and deployment.
- [ ] Describe rollback.
- [ ] Deploy to the target environment if the project has a deployed surface.
- [ ] Verify health, route, logs, and the critical path when they exist.
- [ ] Verify the publication or final URL if it exists.
- [ ] Record verification that is not possible or requires an external action.

## Phase 9. Close the bootstrap

- [ ] Run the applicable gates in `docs/foundation/DEFINITION-OF-DONE.md`.
- [ ] Search for input markers, fictitious examples, and obsolete paths.
- [ ] Check documentation links.
- [ ] Regenerate and then verify `DOCUMENTATION-CATALOG.md`.
- [ ] Inspect the diff.
- [ ] Commit one coherent work unit.
- [ ] Push immediately to the canonical branch if direct write access is permitted. Otherwise, push to a dedicated branch as required by `P18`.
- [ ] Verify that the SHA exists on the remote repository. Observe available remote checks.
- [ ] Put the next work unit in the roadmap. Do not create a competing list.

The bootstrap is complete when another person can understand, start, verify, and resume the project without an undocumented command.

Never edit the foundation snapshot in the consuming project. Put a local exception in `FOUNDATION.md`. Address a foundation challenge in the Project Foundation repository. Then return the change to the project in a new release as specified by [`ADOPTION.md`](ADOPTION.md).
