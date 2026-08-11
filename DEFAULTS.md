# New Project Defaults

These choices make project initialization faster. They are not universal. A project can replace them in `PROJECT.md` or with an ADR. The change must include a reason and its consequences.

## D01. Documentation style

- `P20` controls the language of all technical content. It is not a reversible default.
- Use a restrained, precise, and direct tone.
- Use absolute dates in `YYYY-MM-DD` format. Do not use relative dates.
- Do not use em dashes or en dashes in prose.
- Define one canonical command for each operation. Documentation does not copy its implementation.
- `README.md` provides direction. `PROJECT.md` defines the stable contract. `STATUS.md` defines the verified state. `ROADMAP.md` defines the sequence. `CHANGELOG.md` records delivered changes. `AGENTS.md` defines the change method. ADRs contain decisions.

## D02. Git and delivery

`P18` requires a commit and a push for each coherent and verified work unit. This default selects only the destination and review method. It does not permit a completed work unit to remain only in the local repository.

For a personal repository or a repository with one owner:

- use `main` as the canonical branch;
- push directly to `main` when the platform permits it;
- use a dedicated branch when `main` is protected or review is required;
- use an imperative commit message with a scope prefix;
- do not require a pull request.

For a team, public, regulated, or high-risk repository, define a review and branch-protection policy. The Git workflow is always local to the project.

These choices define a default workflow. They cannot extend task authority to a deployment or another external mutation that is outside the repository scope.

## D03. Architecture and dependencies

- Start with the minimum usable system. Do not start with the complete target architecture.
- Prefer one less dependency until a specific need justifies its cost.
- Use a version manager and lockfiles.
- Use the version manager for host tools. Use Docker Compose, as required by `P19`, for executable services and dependencies.
- Pin production images and artifacts to an immutable version or digest.
- Centralize configuration. Do not distribute fallback domain names, ports, keys, or environments in the code.
- Clearly separate development, build, CI, and production.

## D04. Commands

Each project provides these commands when possible:

```text
install   installs the exact required dependencies
dev       starts the development environment
verify    runs all mandatory checks
build     produces the deliverable artifact
stop      stops services correctly
reset     resets only the documented development state
```

The names can differ. The capability must not depend on a specific agent tool.

When applicable, `dev`, `stop`, and `reset` control the canonical `compose.yaml` file. `reset` identifies the exact volumes or data that it deletes. It must not be an implicit alias for `docker compose down --volumes`.

## D05. Quality

- Automate deterministic checks.
- Keep a human or visual check when the result requires perception.
- Make local hooks and CI call the same `verify` command.
- Test the final surface. Depending on the change, this can be a browser, API, image, PDF, container, or public URL.
- Correct or document an obsolete check. Do not present it as a control.

## D06. Interface

- Enable `profiles/web.md` for each user-facing web interface.
- Define the visual intent in `DESIGN.md` before a significant redesign.
- Use WCAG AA as the default level. A different target requires an explicit exception.
- Keep the identity, budgets, and verification matrix local to the project.

## D07. Mandatory local decisions

A new project must explicitly decide:

- whether it is an experiment, prototype, product, or critical system;
- its users and processed data;
- any externally required terms and documented exceptions to `P20`;
- its development and production platforms;
- its architecture and stack;
- its canonical contract or schema;
- its branch, review, version, and release policy;
- its environments and deployment method;
- its availability, backup, restoration, and observability requirements;
- its logging schema mapping, production threshold, sinks, sampling, retention, audit applicability, and alert ownership;
- its test matrix;
- its design system and brand constraints;
- its license, data rights, and use of AI;
- its owner and escalation procedure.

## D08. Navigable documentation

- Provide `documentation.json` and a complete catalog in all packs.
- Classify Markdown files as public, internal, reference, or archive before publication.
- Keep Markdown files as editorial sources and renderings as derived artifacts.
- Use Nimbus in all projects as specified by `P16` and `profiles/documentation-nimbus.md`.
- Pin Nimbus, test its adapter, and add its build to `verify`.
- Another engine can provide supplementary output. It cannot replace the canonical Nimbus build.

## D09. Runtime logging implementation

`P21` controls first-party runtime log records. This default selects a portable implementation. It cannot disable the invariant.

- Use the OpenTelemetry log data model semantics for timestamps, severity, event names, message bodies, resource context, trace context, attributes, and exceptions. This choice does not declare OpenTelemetry conformance.
- Use an existing OpenTelemetry semantic convention before a project-specific name. Namespace a project-specific event name or attribute. Use lowercase names with dot-delimited namespaces.
- Record the adopted OpenTelemetry specification and semantic-convention versions in the local schema mapping. Pin implementation packages when they apply.
- Use a native structured logging interface. Do not manually assemble JSON. Use JSON Lines when a text stream is the transport and no platform-native structured transport exists.
- Preserve the same fields in local human-readable output. A development renderer can change presentation, but it does not change the record contract.
- Use `INFO` as the default production threshold. Enable output that maps to `DEBUG` under `P21` only through controlled, time-limited configuration.
- Write container logs to the standard streams. Let the execution platform collect, protect, route, and retain them.
- Prefer metrics and traces to repetitive status logs. Document any sampling or rate limit. Do not let diagnostic log export create an unbounded queue or change the reported business result.
- Keep the event-name definitions close to their implementation or generate a catalog from one canonical source. Do not maintain a second manual list.

The project defines its actual schema mapping, sink, retention, access, redaction, volume budget, and security or audit stream and failure behavior in its canonical operations source.

## Override a default

A default can change without a formal discussion when its effect is local and clear. An ADR is required when the change:

- structures multiple modules;
- adds a durable dependency;
- changes a public contract or data;
- changes security, availability, or deployment;
- makes rollback costly;
- becomes a new rule for future contributions.
