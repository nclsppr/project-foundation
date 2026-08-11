# Infrastructure and production profile

Activate this profile for a change to a server, network, DNS, CI/CD, secrets, backups, or a production service.

This profile implements `P05`, `P08`, `P09`, `P10`, `P11`, `P14`, and `P15`. It defines controls, not authorization. Explicit task authority and local policy are still necessary before an external or production modification.

## Before any action

- Read the runbook and architecture decisions.
- Verify the current state, versions, services, and loaded configuration.
- Resolve the exact target of each destructive command.
- List contents before deletion or synchronization that deletes files.
- Make a backup that is suitable for the change.
- Define rollback before deployment.
- Stop at the human checkpoint for a secret, purchase, access, sensitive DNS change, or irreversible operation.

## Secrets and access

- Do not commit, print, or paste a private key or token.
- Prefer a secret manager and short-lived or federated credentials. An ignored file with restrictive permissions is a documented local exception.
- Give CI the minimum permissions.
- Avoid shared accounts.
- Protect administrator accounts with MFA. Separate administrator, deployment, and runtime access when possible.
- Verify a host fingerprint. Do not silently trust network discovery.
- Treat a group or socket that provides root access as a root privilege.
- If a secret is exposed, revoke or rotate it. Remove it from exposed output and history. Assess possible access and notify according to the incident policy.

## Deployment

Canonical sequence:

```text
immutable build
-> verification
-> deployment
-> health check
-> critical path
-> observation
-> closure or rollback
```

- Deploy a digest, version, or SHA. Do not deploy only a mutable tag.
- Separate build and deployment.
- Pin third-party CI actions. Limit secrets for untrusted contributions.
- Add provenance, a component inventory, and scans according to software supply chain risk.
- Avoid direct modification of a production surface.
- Use atomic releases or an equivalent strategy when file deletion is possible.
- Validate configuration before reload.
- Verify the exposed ports and routes.

## Data and backups

- Combine snapshots, versioned configuration, and off-site backups according to risk.
- Encrypt sensitive backups. Separate their access from production and verify their integrity.
- Use immutable retention when the threat model requires it.
- Back up databases before migration.
- Define an explicit retention policy. Retention deletion is an authorized and audited operation, not a hidden exception.
- Regularly restore a file and a database to an isolated target.
- Measure RPO and RTO when continuity is important.

## Observability

- Local health checks.
- External monitoring to detect loss of the server or network.
- Log rotation.
- Actionable metrics and alerts.
- Incident procedure and escalation contact.
- Verification after restart if automatic restart is part of the requirement.
- Threat model and misuse scenarios for a critical system.

## Minimum gate

- validated configuration;
- dry run or diff when available;
- backup and rollback ready;
- immutable artifact;
- permissions and secrets controlled;
- deployment;
- health, ports, routes, logs, and critical path;
- observation for a suitable period;
- periodic restore proven;
- configuration and runbook committed.
