# FOUNDATION.md

Contract for this project's adoption of the common foundation.

## Version

| Field | Value |
| --- | --- |
| Source | TODO origin URL or path |
| Readable version | TODO tag |
| Immutable commit | TODO full SHA |
| Adopted pack | TODO minimal, standard, full, or critical |
| Adopted on | TODO YYYY-MM-DD |
| Adopted by | TODO |

## Vendored snapshot

The following files are copied into `docs/foundation/`. Do not edit them locally:

- `PRINCIPLES.md`
- `DEFAULTS.md`
- `DEFINITION-OF-DONE.md`

The vendored profiles are exactly the profiles in the "Activated profiles" section.

An update replaces these files from a new foundation version. Review the diff before you change the version recorded in this file.

## Activated profiles

- TODO

Profiles are durable project policies. Their gates apply only to work units
that meet their activation conditions.

`documentation-nimbus` is the only mandatory profile. It applies to each work
unit that modifies a Markdown file or documentation. A local exception cannot
remove it.

## Exceptions and compensating controls

| Rule or default | Scope | Local choice | Reason | Compensating control | Owner | Review | ADR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |

An exception to an invariant requires a limited scope, a compensating control, and a review date.
`P18` cannot be disabled by a local exception. The project policy selects
either a direct push to the canonical branch or a dedicated branch. It cannot
keep a completed work unit only locally.

`P19` cannot be disabled by a local exception. `compose.yaml` and its gate
remain mandatory. Only a Minimal pack without a local process can keep an empty
`services` table.

`P20` cannot be disabled by a local exception. A local exception cannot select
another language. Preserve only the external forms that `P20` permits.

`P21` cannot be disabled for first-party runtime log records. Each platform
mapping or limited external or legacy exception must follow the boundary in
`P21`.

## Challenge the foundation

The `docs/foundation/` snapshot is read-only in this project.

- For a local requirement, record an exception in this file.
- If the rule must change for all projects, modify the repository identified by
  `Source`, run its tests, publish a new release, and then update this project
  to the new tag and its SHA.
- Do not modify the snapshot directly. A direct modification creates a silent
  fork and the next update will remove the modification.

The complete protocol is in `ADOPTION.md` in the Project Foundation repository.

## Additional local sources

Local rules belong in their natural documents. This table references them without copying them.

| Subject | Local source |
| --- | --- |
| TODO | TODO |

## Initialized local adapters

The following files start from the foundation baseline. They then become local
and editable:

- `scripts/check_markdown.py`
- `scripts/check_compose.py`
- `scripts/documentation_catalog.py`
- `scripts/verify.sh`

They can receive project-specific gates. An update compares their baseline with
the new version. It then merges useful corrections without replacing local
controls.

## Reclassification and later activation

When a project changes class:

1. Select the new pack.
2. Add the required documents.
3. Align `Adopted pack` in this file with `Class` in `PROJECT.md` or `BRIEF.md`.
4. Activate the required durable profiles.
5. Run verification and deliver all changes atomically.

During a downgrade, remove only stubs that were never used. Mark a runbook,
evidence record, or historical decision as inactive or archived. Do not remove
it silently.

When a work unit requires a profile that is not activated, copy that profile
from the same foundation commit. Add it to the list above. Then, record the
profile gates that apply to the unit in the delivery evidence.

## Update

1. Read the foundation changelog between the current version and the target version.
2. Replace the vendored snapshot.
3. Review changes to invariants, defaults, and profiles.
4. Update local exceptions if necessary.
5. Compare the new script baseline and merge useful corrections.
6. Regenerate the documentation catalog.
7. Run the project verification command.
8. Commit the snapshot, this file, and the adaptations as one unit.
9. Push immediately to the canonical branch if direct write access is authorized. Otherwise, push to a dedicated branch.
