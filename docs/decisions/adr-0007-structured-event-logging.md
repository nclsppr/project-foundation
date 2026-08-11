# ADR-0007: Structured runtime log records

- Status: accepted
- Implementation status: delivered
- Date: 2026-08-11
- Last verification: 2026-08-11, catalog, Markdown, Nimbus, Compose, and generated-pack propagation verified in GitHub Actions run `31499654216`; local generated-pack verification used a Docker command stub
- Owner: Nicolas Pieper
- Supersedes: none
- Superseded by: none

## Context

Projects need log records that people can read and systems can query. A free-text
message helps a person, but its wording changes and is not a stable alert or
dashboard key. An opaque numeric code is stable, but it does not explain the
event without a separate catalog.

Projects also use different languages, frameworks, deployment platforms, and
log backends. The foundation must define common event semantics without
requiring one logging library, vendor, collector, or serialized field name.

The OpenTelemetry log data model separates event name, message body, severity,
resource context, trace context, and attributes. OWASP recommends consistent
event classification, sufficient context, data minimization, sanitization, and
verification of logging failure and resource exhaustion.

The OpenTelemetry event conventions remain in Development status on
2026-08-11. This decision uses their semantic separation and stable naming
guidance. It does not depend on an experimental SDK interface or serialized
field name.

## Decision problem

How can every project emit log records that support people, automated consumers,
correlation, and incident response without creating an opaque code registry,
duplicate error records, alert noise, or a sensitive-data store?

## Considered options

### Use only free-text messages

Advantage: The first implementation is simple and readable.

Limitations: Queries and alerts depend on wording. Variable values become hard
to extract. Message changes can break operations without a contract change.

### Use only numeric log codes

Advantage: A numeric value is compact and stable.

Limitations: An operator needs a separate catalog. Sequential values do not
describe the domain. The catalog can drift from code. A numeric log code also
conflicts with protocol, domain, public error, and severity codes.

### Use a stable event name and a human-readable message

Advantages: The event name provides a stable machine contract. The message
explains the occurrence to a person. Structured fields preserve variable
context. The design maps to different log backends.

Limitations: Projects must define event names and schemas deliberately. Tests
must protect any event that an operational consumer uses.

## Decision

Add `P21` to `PRINCIPLES.md`. `P21` is the sole normative source for
first-party runtime log records. It defines the log-record contract, severity
meanings, failure reporting, data controls, audit separation, volume controls,
alert use, platform mapping, and exception boundary. Supporting documents
reference `P21`. They do not maintain a second copy of its rules.

Select the hybrid option. A stable event name gives automated consumers a
machine key. A short English message explains the occurrence to a person.
Typed structured fields carry values for that occurrence. An opaque numeric
code is not the primary log identifier. A public or API error code remains a
separate product contract. `P21` contains the authoritative details.

Use four portable severity meanings: `DEBUG`, `INFO`, `WARN`, and `ERROR`.
Map framework-specific levels by meaning, not by numeric value. RFC 5424 and
OpenTelemetry use different numeric directions. `P21` contains the
authoritative meaning of each level.

Add `D09` as a reversible implementation default. It selects OpenTelemetry log
data model semantics without requiring an OpenTelemetry SDK, one backend, one
serialized schema, or a formal conformance claim. A project records its actual
platform mapping and operational choices in its canonical operations source.

Keep event-name definitions close to the implementation. Generate a catalog
from that canonical source only when a consumer needs one. Do not require a
second manually maintained event catalog.

Keep exact retention periods, sink technology, sampling rates, volume budgets,
and alert thresholds outside the invariant. Each project selects these values
according to its risk and operating environment. `P21` remains authoritative
for the permitted platform mappings and limited exceptions.

## Consequences

### Positive

- Operators receive a readable message and a stable query key.
- Alerts, dashboards, runbooks, and tests do not depend on message wording.
- Correlation connects logs to an operation without putting identifiers in
  event names.
- Severity reflects service behavior instead of catch blocks or status-code
  families.
- One final failure record reduces duplicate stack traces and retry noise.
- Data minimization and bounded logging reduce disclosure and availability
  risks.
- The rule remains independent of a logging library or backend.

### Negative

- Each project that emits runtime log records must define a schema mapping and tests.
- Existing free-text logs require migration.
- Consumed event names and required fields become compatibility contracts.
- Redaction, correlation, audit separation, and volume controls require local
  design according to project risk.

## Verification

- Verify that generated Minimal and Full packs contain the complete `P21`
  source and a short adapter reference.
- Apply the minimum evidence in `P21` to each consuming project that emits
  first-party runtime log records.
- Review supporting documents for references to `P21`, not parallel normative
  rules.
- Run the foundation catalog, Markdown, Nimbus, bootstrap, and Compose checks.

These controls verify the foundation contract. They do not establish formal
conformance with OpenTelemetry, OWASP, or another external standard.

## References

- [OpenTelemetry logs data model](https://opentelemetry.io/docs/specs/otel/logs/data-model/)
- [OpenTelemetry event conventions](https://opentelemetry.io/docs/specs/semconv/general/events/)
- [OpenTelemetry exception conventions for logs](https://opentelemetry.io/docs/specs/semconv/exceptions/exceptions-logs/)
- [OpenTelemetry naming guidance](https://opentelemetry.io/docs/specs/semconv/general/naming/)
- [OpenTelemetry guidance for sensitive data](https://opentelemetry.io/docs/security/handling-sensitive-data/)
- [OWASP Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)
- [RFC 5424: The Syslog Protocol](https://www.rfc-editor.org/rfc/rfc5424.html)
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)

## Review

Review this decision if projects repeatedly need the same platform mapping, if
an event schema changes break operational consumers, if logging causes an
availability incident, if sensitive data reaches a log sink, or if an external
standard provides stable semantics that replace part of this contract.
