# Invariant Principles

These principles apply to every project, independent of its stack. Each principle defines a rule, its reason, and minimum evidence. An exception must be explicit, limited, and documented.

## P01. Understand the actual problem before you select the solution

**Rule.** Start with the users, context, constraints, risks, non-goals, and expected result. Select the technology after you understand these items.

**Reason.** An elegant solution to the wrong problem adds debt and creates no value.

**Minimum evidence.** Before the first stack decision, a short brief for an exploration or `PROJECT.md` for a durable project describes the problem, users, scope, and success criteria.

## P02. State the truth, including when it is incomplete

**Rule.** Never invent a fact, metric, customer, capability, verification result, responsibility, or production state. Clearly distinguish `current`, `target`, `experiment`, `example`, and `assumption`.

**Reason.** Plausible but false information quickly becomes a decision, commitment, or risk.

**Minimum evidence.** Important claims have a source. Unknown information and verification that cannot be completed are identified. Synthetic data is identified as synthetic.

## P03. Map the sources of truth

**Rule.** Identify one canonical source for each important concept. These concepts include the product, roadmap, architecture, contract, schema, design, configuration, operations, and decisions.

**Reason.** The term "canonical" has no value if it refers to multiple competing files.

**Minimum evidence.** `PROJECT.md` contains a source table. Derived artifacts, archives, and snapshots are identified as such.

## P04. Define one normative concept in one location

**Rule.** Do not copy a rule, command, or data that requires manual synchronization. Reference its source or automate its generation.

**Reason.** Duplicate documentation eventually contains incompatible instructions.

**Minimum evidence.** A search for the concept finds one normative source and its references. It does not find multiple editable copies. Generated files identify their source and are not edited manually.

## P05. Separate intent from reality

**Rule.** ADRs and canonical documents define intent. Code, configuration, and the environment that actually runs define the operational state. Make any difference between them visible as drift.

**Reason.** Desired documentation and an isolated local test do not prove what actually runs.

**Minimum evidence.** Before a decision or delivery, inspect the repository, worktree, versions, configuration, and, when relevant, the running process or service.

## P06. Select proportional complexity

**Rule.** Use the simplest architecture and dependencies that satisfy demonstrated constraints. Do not add a tool because it is new or because it duplicates an existing capability.

**Reason.** Each dependency creates costs for comprehension, updates, security, and operations.

**Minimum evidence.** A structural decision describes the unmet need, alternatives, and operating cost. The project can explain why each important layer exists.

## P07. Document decisions, not only results

**Rule.** Version each structural decision, including an important product decision. Record its context, alternatives, consequences, verification plan, and review conditions.

**Reason.** Without explicit trade-offs, a team repeats the same discussions or retains a decision that is no longer valid.

**Minimum evidence.** An accepted ADR exists before or with the implementation. A superseded decision references its replacement.

## P08. Respect authority and deliver a coherent work unit

**Rule.** A change includes one specific result, its tests, its documentation, and its derived artifacts. Preserve unrelated changes. Do not include opportunistic cleanup. A runbook describes a procedure. It does not grant permission to execute the procedure. An explicit target does not grant permission. Keep each external mutation, publication, or production action within the explicit authority of the task and the local policy.

**Reason.** A focused diff is easier to understand, verify, revert, and attribute.

**Minimum evidence.** The final diff matches the stated scope. Each file in the commit has a direct relation to the result. Each external mutation was authorized, and its target is identified.

## P09. Make execution reproducible

**Rule.** Specify versions, dependencies, variables, and commands for start, stop, verification, and reset. Put critical checks in a tool-neutral command that a person, an agent, and CI can run.

**Reason.** A tool-specific hook or a command known to one person is not a control.

**Minimum evidence.** A new clone can install, start, and verify the project with documented commands. Pin lockfiles and images according to the risk level.

## P10. Verify in proportion to risk

**Rule.** Verification covers the layer that changed and the affected final surface. Combine automation, inspection, and manual tests when each method provides different evidence.

**Reason.** A successful build does not prove that an interface is correct, a contract is compatible, a deployment is healthy, or restoration is possible.

**Minimum evidence.** The definition of done enables the applicable gates. The delivery report lists the commands, environments, and observed results. It does not make broader claims than the evidence supports.

## P11. Secure changes and test rollback

**Rule.** Do not store secrets in Git, logs, or conversations. Resolve the exact target before each destructive action. Back up important data before a migration, and test the restoration.

**Reason.** An untested backup, an exposed secret, or an implicit target is not a control.

**Minimum evidence.** A dedicated mechanism injects secrets. Risky changes have a checkpoint and a rollback procedure. Data changes also have restoration evidence.

## P12. Isolate experiments

**Rule.** Clearly identify an experiment. Separate it from the canonical surface. Do not use real data by default. Provide a command or procedure to remove it.

**Reason.** A prototype that silently shares production routes, data, or contracts becomes an accidental migration.

**Minimum evidence.** The experiment profile documents its purpose, owner, duration, limits, access, data, and removal path.

## P13. Design for accessibility, resilience, and actual cost

**Rule.** Accessibility, performance, error states, fallbacks, and operations are not final refinements. Design them with the product.

**Reason.** A feature is not complete if it is inaccessible, too slow, not observable, or not recoverable.

**Minimum evidence.** Define and test applicable budgets and scenarios. Depending on the project, these can include keyboard access, focus, contrast, reduced motion, mobile use, load, errors, degraded operation, health, and restoration.

## P14. Stay close to production

**Rule.** Delivery does not stop with local code. Document how to deploy, observe, back up, restore, and diagnose the project in its actual environment.

**Reason.** Production is where architecture assumptions meet dependencies, data, and users.

**Minimum evidence.** Verify the last delivered artifact or SHA on its target surface. Explicitly keep unverified external limits open.

## P15. Build a system, not a hero

**Rule.** Share context, responsibility, runbooks, and useful commands. A critical operation must not depend on one person's memory or an undocumented command.

**Reason.** Hidden knowledge increases recovery time and incident risk.

**Minimum evidence.** Each critical area has an owner, recovery documentation, and a verification path that another person or agent can execute.

## P16. Give each Markdown file a classification and an audience

**Rule.** Each maintained Markdown file belongs to the project documentation. Classify it as public, internal, reference, or archive. Keep it accessible from the catalog and Nimbus. Nimbus is the mandatory documentation engine for all projects. Another engine can supplement Nimbus but cannot replace it. A generated rendering never becomes a second editorial source.

**Reason.** An orphan file disappears from shared knowledge. Publishing all Markdown files without classification can expose runbooks, evidence, or internal information to the wrong audience.

**Minimum evidence.** `documentation.json` classifies each `.md` file exactly once. `DOCUMENTATION-CATALOG.md` provides complete navigation. The `verify` command checks the catalog, adapter, and Nimbus build. Do not edit the generated collection. A publication respects the defined audiences.

## P17. Record each delivered change

**Rule.** Add each delivered change to `CHANGELOG.md`. The entry describes the observable effect, the applicable date or version, and any required migration. Git contains the complete technical diff. The changelog provides a durable, project-oriented description.

**Reason.** A commit sequence alone does not explain what changed for users, operators, or future contributors.

**Minimum evidence.** The change is under an unreleased section or in the delivered version. The commit identifies the exact changed files. An important decision also references its ADR.

## P18. Commit and push each verified work unit

**Rule.** When a task permits changes to a Git repository that has a remote repository, commit each coherent and verified work unit. Then push it before you start other work. Push directly to the canonical branch when direct write access is permitted. If the canonical branch is protected or requires review, push to a dedicated branch for the scope. Do not keep a completed work unit only in the worktree or local history. Do not mix unrelated changes in the commit. Do not intentionally commit a state that is known to be invalid.

A default or a convenience exception cannot disable this principle. The only exceptions are a task that explicitly requires read-only or local-only work, a restriction from higher authority, no remote repository, or an external network, authentication, or platform blocker. In these cases, report the local SHA and the exact blocker. Resume the push when the blocker no longer exists.

**Reason.** Completed work that exists only locally is not visible, is fragile, is difficult to review, and cannot be reliably resumed by another person or CI. Small published work units reduce work loss, shorten reviews, and make rollback precise.

**Minimum evidence.** The commit contains one verified work unit. Its SHA exists on the expected remote branch, and the final worktree state is known. Use the canonical branch directly when its policy permits this. Otherwise, identify the remote branch and review path. Observe available remote checks before you report that delivery is complete.

## P19. Orchestrate the local environment with Docker Compose

**Rule.** Each project versions a `compose.yaml` file at its root and uses Docker Compose as the canonical path for integrated local execution. Declare the applications, databases, queues, email interceptors, storage services, proxies, and other dependencies required for local execution in this file. A command that runs directly on the host can make an internal loop faster, but it does not replace the common path. A Minimal pack with no local process can keep `services: {}`. A Standard, Full, or Critical pack declares at least one service.

Pin external images by digest. A long-running service has a health check. A finite command without a health check has the explicit label `foundation.lifecycle=job`. A default or local exception cannot disable this principle. A higher-level restriction or a platform without Docker can prevent execution, but it cannot remove the versioned contract or its CI gate. Document the exact blocker.

**Reason.** A collection of host commands and implicit versions creates different environments on different machines. It also excludes actual dependencies from verification. Compose provides a portable contract to start, wait for, diagnose, and stop the same service graph.

**Minimum evidence.** The `verify` command and CI call `scripts/check_compose.py`. The script verifies the configuration, digests, health checks, and pack. For each project that has a service, `docker compose up --build --wait` reaches a healthy state. The checks for the primary path pass. Then `docker compose down` stops the environment without deleting data by default.

## P20. Use controlled technical English

**Rule.** Use English for all deliverables, communications, documentation, code comments, logs, and other technical content. Follow the principles of ASD-STE100 Simplified Technical English. Use precise and unambiguous terms. Use short declarative sentences. Use the active voice when appropriate. Use one term consistently for each concept. Avoid unnecessary synonyms, vague language, marketing language, and unnecessary jargon. Use ISO/IEC/IEEE 24765 terminology when it applies. Preserve proper names, external identifiers, quotations, and terms that an external contract requires.

This principle does not declare formal conformance with ASD-STE100.

**Reason.** Variable or ambiguous terminology increases review time, differences in interpretation, and the risk of implementation or operation errors.

**Minimum evidence.** A review of changed content checks the use of English, term consistency, sentence structure, and unexplained jargon. If domain terminology differs from ISO/IEC/IEEE 24765, identify the canonical glossary or contract. An exception identifies the externally required term, its source, its scope, and its reason.
