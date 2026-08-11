# ADR-0006: Controlled technical English

- Status: accepted
- Implementation status: delivered
- Date: 2026-08-11
- Last verification: 2026-08-11, catalog, Markdown, Nimbus, and generated-pack propagation verified locally; Docker unavailable locally
- Owner: Nicolas Pieper
- Supersedes: none
- Superseded by: none

## Context

Project Foundation required French for technical prose. The foundation owner
now requires English for all technical content and communication. The owner
also requires precise and consistent technical terminology.

A language rule in `DEFAULTS.md` is reversible. This location cannot make
English mandatory for every project. A universal rule must be in
`PRINCIPLES.md` and must propagate to every generated pack.

External contracts can require an identifier, proper name, quotation, or term
in its original form. Preserving that form must not create a general language
exception.

## Decision problem

How can the foundation require clear technical English in every project while
it preserves required external forms and avoids an unsupported conformance
claim?

## Considered options

### Keep French as the required language

Advantage: Existing documentation requires no migration.

Limitation: This option conflicts with the current owner requirement.

### Make English a reversible default

Advantage: A project can select another language without a foundation update.

Limitations: The rule is not universal. Generated projects can silently return
to another language. This option also duplicates the normative rule.

### Add a universal controlled-English principle

Advantages: One invariant controls all technical content. The same rule applies
to the foundation, generated projects, templates, comments, logs, and
communication. Limited external forms remain exact.

Limitations: Existing French content requires migration. Editorial review is
necessary because an automated language check cannot prove clarity or term
consistency.

## Decision

Add `P20` to `PRINCIPLES.md`. Require English for all deliverables,
communication, documentation, code comments, logs, and other technical content.

Apply the principles of ASD-STE100 Simplified Technical English. Use precise
and unambiguous terms. Use short declarative sentences. Use the active voice
when appropriate. Use one term for each concept. Avoid unnecessary synonyms,
vague language, marketing language, and unnecessary jargon. Use
ISO/IEC/IEEE 24765 terminology when it applies.

Preserve proper names, external identifiers, quotations, and terms that an
external contract requires. These preservation cases do not permit a project
to select another language. Record each externally required term, its source,
scope, and reason.

Do not declare formal conformance with ASD-STE100. This decision applies its
principles. It does not perform a formal conformance assessment.

Keep the normative rule only in `PRINCIPLES.md`. Root and generated
`AGENTS.md` files provide operational references to `P20`. `DEFAULTS.md`
identifies `P20` as a non-reversible invariant. `FOUNDATION.md` cannot disable
the language requirement.

Migrate maintained documentation, templates, validation messages, interface
text, and the Nimbus locale from French to English. Propagate `P20` and its key
clauses to every generated pack.

## Consequences

### Positive

- Each project uses one required language for technical content.
- Contributors receive the same terminology and sentence rules.
- Generated projects retain the rule in their vendored foundation and local adapter.
- External identifiers and contract terms remain exact.
- The repository does not make an unsupported conformance claim.

### Negative

- The initial migration creates a large documentation diff.
- Editorial review remains necessary.
- Some external forms can contain non-English terms and require an explicit reason.

## Verification

- Review changed technical content for English, clear sentences, consistent terms, and unexplained jargon.
- Run `python3 scripts/documentation_catalog.py --check`.
- Run `python3 scripts/check_markdown.py`.
- Run the Nimbus test, type check, clean build, Pagefind index, and lint.
- Verify that Pagefind indexes only English pages.
- Run `scripts/test_bootstrap.sh` and verify the P20 heading, ASD-STE100 clause, ISO/IEC/IEEE 24765 clause, and local exception limit in generated packs.
- Run `./scripts/verify.sh` in an environment that provides Docker.
- Do not report formal ASD-STE100 conformance from these checks.

## Review

Review this decision if an external contract requires another documentation
language, if ISO/IEC/IEEE 24765 terminology conflicts with a binding domain
contract, or if a formal ASD-STE100 assessment becomes necessary. A review can
refine the preservation mechanism. It cannot create a silent local language
override.
