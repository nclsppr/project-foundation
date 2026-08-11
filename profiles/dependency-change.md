# Dependency change profile

Activate this profile when you add, update, replace, or remove a package, runtime, image, CI action, model, external service, or other third-party component.

Record activation durably in `FOUNDATION.md`. The gates in this profile apply
only to work units that modify a dependency. If the profile is not vendored,
add it from the pinned foundation commit before you make the change.

## Document type

- **Opt-in standard.** This profile implements `P01`, `P02`, `P03`, `P05`, `P06`, `P07`, `P08`, `P09`, `P10`, `P11`, `P13`, and, for a production dependency, `P14`.
- **Form.** Record the durable choice in `PROJECT.md`, the canonical inventory, or an ADR according to its effect. This profile is not a dependency register.
- **Evidence.** Record the lockfile, digest, dated scans, tests, build, measurements, and observed removal plan in delivery evidence. A dependency name or one successful build is not sufficient evidence.

## Need and alternatives

- Describe the specific unmet need.
- Verify that an existing capability, the standard platform, or a simpler solution is not sufficient.
- Identify the consumers, owner, and criticality of the dependency.
- Classify the dependency as development, build, test, CI, runtime, data, or external service.
- Document the cost of a local implementation and the operating cost of the third-party component.
- Create an ADR if the dependency structures multiple modules, modifies a contract or data, causes a durable risk increase, or makes removal costly.

## Origin and trust

- Use an official or explicitly approved source.
- Verify the identity of the package, image, publisher, or provider. Prevent adoption of a namesake or compromised dependency.
- Review maintenance activity, release frequency, security advisories, and relevant ownership changes.
- Identify transitive dependencies, installation scripts, downloaded binaries, and requested permissions.
- Verify a signature, checksum, digest, or provenance when it is available and proportional to the risk.
- Record the dependency in the project inventory or SBOM.

## License and rights

- Identify the license and verify that it is compatible with the planned use and distribution.
- Keep the required notices, attributions, and redistribution obligations.
- Verify the terms for supplied code, data, models, and content separately.
- Document each restriction on use, territory, volume, or modification.
- Block adoption for a distributed or public surface while a required license or right is unknown.

## Version and reproducibility

- Pin an immutable version or digest according to the component type and risk.
- Record the observed current version and the target version separately. Do not present the target as installed.
- Update and commit the lockfile or canonical inventory.
- Declare compatible platforms, runtimes, and versions.
- Read release notes, migrations, and incompatible changes before an update.
- Define the update policy, review frequency, and owner.
- Provide rollback to a known version without dependence on an uncertain rebuild.

## Vulnerabilities and software supply chain

- Run the project vulnerability and provenance controls.
- Date the results. Record the tool, tool version, consulted database, and scan limitations.
- Correct each applicable vulnerability. Otherwise, document the actual exposure, compensating control, owner, and review date.
- Limit permissions, secrets, network access, and build actions to the minimum.
- Test untrusted contributions without access to secrets or protected environments.
- Do not present an empty scanner result as proof that no vulnerability exists.

## Data and confidentiality

For a dependency that receives, stores, or produces data, document:

- the data categories and purpose;
- data minimization and the fields that are transmitted;
- retention, deletion, export, and portability;
- applicable subprocessors, regions, or transfers;
- possible data use for training, analysis, or advertising;
- authentication scopes and permissions;
- encryption, logging, and incident procedures;
- the method to test without real data when possible.

## Cost, reliability, and operations

- Measure fixed, variable, and labor costs. Define alert thresholds.
- Document quotas, limits, latency, availability, and support policy.
- Define timeouts, retries, idempotency, and unavailable behavior when applicable.
- Provide observability and diagnostics. Do not make the third-party service necessary for project observability.
- Identify technical or contractual lock-in and the data migration cost.
- Test a degraded mode, fallback, or safe stop according to criticality.

## Removal or replacement

- Define how to disable the dependency without silently breaking its consumers.
- Identify the files, configurations, secrets, data, contracts, and artifacts to remove.
- Provide verifiable data export, migration, or deletion.
- Identify the alternative or behavior without the dependency.
- Test update rollback and the removal procedure when they are critical.
- Revoke credentials and permissions that become unnecessary after removal.

## Minimum gate

- unmet need and alternatives recorded;
- origin, owner, and consumers identified;
- compatible license and obligations;
- pinned version or digest and aligned lockfile;
- vulnerabilities, provenance, and permissions assessed on a specified date;
- transmitted data, retention, and rights documented;
- cost, limits, failure modes, and observability assessed;
- tests, build, and final surface verified in applicable environments;
- concrete rollback and removal procedures;
- SHA, versions, results, and limitations retained in the delivery evidence.
