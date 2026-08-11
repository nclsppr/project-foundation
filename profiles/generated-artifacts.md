# Generated artifacts profile

Activate this profile when a source produces a file, document, client, image, report, bundle, or other derived artifact that the project consumes.

## Document type

- **Opt-in standard.** This profile implements `P02`, `P03`, `P04`, `P05`, `P08`, `P09`, `P10`, and, for perceptible or public output, `P13` and `P14`.
- **Form.** The local inventory of sources, commands, derived artifacts, and consumers is in the canonical source identified by `PROJECT.md`.
- **Evidence.** Record commands, versions, hash values, diffs, renderings, and consumer controls in delivery evidence. The presence of a derived artifact is not evidence of correct generation.

## Source and editable boundary

- Identify one canonical source for each artifact family.
- Identify the canonical generation command or script.
- Explicitly identify derived paths and consumers.
- Distinguish the currently committed derived artifact, target result, and final observed result.
- Modify the source or generator. Do not modify the derived artifact manually.
- Mark the derived artifact as generated when its format permits it.
- Remove each former competing source or label it as a non-normative archive.

## Reproducibility

- Pin the generator, its dependencies, and input resources according to risk.
- Document parameters, variables, and prerequisites without secrets.
- Generate from a clean state and measure the resulting diff.
- Retain a seed, model, version, prompt, or input reference when it affects the result.
- Declare the non-deterministic part. Do not promise impossible bit-for-bit reproduction.
- If generation is declared deterministic, verify that a new generation without source changes causes no unexplained drift.

## Atomic delivery

- Deliver the source, generator, derived artifact, and consumer adaptations in one work unit.
- Verify all known consumers after generation.
- Invalidate caches, manifests, or resource versions when the public path does not change.
- Remove orphaned derived artifacts and their references during removal.
- Do not combine an unrelated global regeneration with a targeted change.

## Provenance and rights

For each artifact type, the canonical register must identify:

- the author or original source;
- the required license, rights, and attributions;
- the acquisition or generation date;
- the generator, its version, and significant parameters;
- inputs, references, prompts, or transformations;
- the hash value or identifier of the selected artifact;
- the intended use and authorized consumers;
- known reproduction or reuse limitations.

Do not include personal data, secrets, sensitive metadata, or content without established rights in a source or derived artifact.

## Derived artifact quality

- Validate the expected format, dimensions, file size, encoding, and transparency.
- Inspect the final output when it is visual, audio, printed, or interactive.
- Keep functional text and essential information in an accessible source. Do not keep them only in an image or media file.
- Verify compatibility, performance, and fallback behavior on representative consumers.
- Compare the result with the source and product criteria. Do not rely only on successful command execution.

## Minimum local inventory

| Required field | Purpose |
| --- | --- |
| Canonical source | Identify the editable item |
| Canonical generator | Repeat generation |
| Version and environment | Define reproducibility limits |
| Derived artifacts | Detect missing or orphaned output |
| Consumers | Verify effects |
| Provenance and rights | Authorize use and attribution |
| Determinism and limitations | Prevent incorrect interpretation of evidence |
| Removal procedure | Remove artifacts without residual references |

## Minimum gate

- canonical source, derived artifacts, and consumers identified;
- command repeated in a named environment;
- versions, significant parameters, and limitations recorded;
- generation diff inspected;
- no manual modification of the derived artifact;
- provenance, rights, and sensitive data controlled;
- format and final output verified for its use;
- consumers and cache invalidation verified;
- SHA, hash values, results, and limitations retained in the delivery evidence.
