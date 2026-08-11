# Backend and data profile

Activate this profile for an API, service, database, payment, or external integration.

This profile implements `P03`, `P04`, `P09`, `P10`, `P11`, `P13`, `P14`, and `P21`.

## Contract

- Identify one canonical contract: OpenAPI specification, schema, events, or versioned interface.
- Update the contract before or with the implementation.
- Generate clients and artifacts from this source.
- Detect incompatibilities before delivery.
- Document error codes and authorization rules.

## Data

- Use versioned migrations. Do not use untracked manual DDL.
- Back up data before a high-risk migration.
- Test the migration on a representative state.
- Define an explicit rollback or correction strategy.
- Test restore to an isolated target. Never restore to the production system that serves users.
- Document retention and deletion.
- Make identifiers and constraints consistent with business invariants.

## Concurrency and recovery

- Identify duplicate submissions, retries, duplicate webhooks, and race conditions.
- Use idempotency, a lock, or a transaction constraint according to the risk.
- Do not infer a financial state only from the browser response.
- Separate intent, external confirmation, and business state.
- Test prohibited transitions and recovery after a failure.

## Security

- Keep authentication and authorization separate.
- Apply authorization in the backend. Do not rely only on the user interface.
- Test isolation between users, organizations, or tenants.
- Inject secrets and make them rotatable.
- Send the minimum data to third parties and AI systems.
- Apply the `P21` data protections to first-party runtime log records from the application and its integrations.
- Set timeouts and limits for external calls.

## Operations

- Use useful and accurate health checks.
- Apply `P21` to each first-party runtime log record.
- Define the public or API error-code contract separately from runtime logging.
- Use technical and business metrics without personally identifiable information.
- Do not make observability necessary for service operation.
- Define procedures to start, stop, restart, and diagnose the service.
- Define explicit resource limits.

## Minimum gate

- formatting, static analysis, and unit tests;
- integration tests with the important real boundaries;
- contract validation and diff detection;
- forward migration, restore, or correction strategy;
- authorization and isolation;
- idempotency and external errors;
- production artifact build;
- startup in the target environment;
- health check and critical path.
