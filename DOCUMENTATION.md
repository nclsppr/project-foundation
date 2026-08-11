# Documentation contract

All maintained Markdown files in this repository belong to the project
documentation system. No `.md` file remains unclassified in the tree.

## Sources of truth

- `documentation.json` classifies files by collection and visibility.
- `DOCUMENTATION-CATALOG.md` is the generated, exhaustive navigation catalog.
- The classified Markdown files remain the editorial sources.
- Nimbus is the mandatory engine. It uses a derived collection and never uses a second source.

## Visibility levels

| Visibility | Use |
| --- | --- |
| `public` | Can be rendered in public documentation |
| `internal` | Remains available in the internal documentation or repository |
| `reference` | A rule, template, decision, or reference material |
| `archive` | Preserved history that is explicitly not current |

An internal, sensitive, or operational file always belongs to the catalog,
but it is not published on a public surface. The rendering engine must enforce
this boundary.

These visibility levels control documentation rendering, not Git access rights.
In a public repository such as Project Foundation, each committed file remains
publicly readable, even if its classification is `internal`. Never add a secret
or actual confidential content to Git.

## Change cycle

After you add, move, or remove a Markdown file:

1. Adjust its collection in `documentation.json` if no existing glob covers it.
2. Run `python3 scripts/documentation_catalog.py --write`.
3. Review the catalog and the assigned visibility.
4. Run `./scripts/verify.sh`.
5. Check the final Nimbus output and the audience of the surface that you plan to publish.

Manifest ignore paths are reserved for dependencies and generated output.
Each ignore path always has an explicit reason.

## Mandatory engine

Nimbus is mandatory in Project Foundation and in each adopted project.
The official scaffold, `nimbus.json`, the pinned version, and the lockfile are
vendored with the project. Therefore, Node `22.12.0` or later and npm are
prerequisites for `verify`.

The catalog remains the exhaustive proof that is independent of rendering. The
adapter generates `docs-nimbus/src/content/docs/` from the classified sources.
Nimbus then runs its tests, type check, build, and lint. Git ignores this
collection. Never edit it.

The local build includes all audiences to make the corpus navigable.
By default, you cannot publish this build as is. A publication process defines
and verifies an explicit filter so that it never exposes an internal collection.
ADR-0003 defines this decision.

Set `NIMBUS_VISIBILITIES` to the comma-separated visibility values that the
publication authorizes. Set `NIMBUS_SITE_ORIGIN`, `NIMBUS_BASE_PATH`, and
`NIMBUS_SOURCE_URL` for the target. Then run
`npm run build:publication --prefix docs-nimbus`. This command builds the
static site, applies the deployment base path, and rejects content outside the
authorized audience.

Project Foundation publishes `public` and `reference` content through GitHub
Pages. It excludes `internal` and `archive` content. ADR-0008 authorizes this
surface and records the hosting decision.
