# TODO project name

TODO Describe the problem and the target observable result in one sentence.

## Start

The prerequisites, canonical commands, and expected results are in [`PROJECT.md`](PROJECT.md). Do not copy a procedure here if it must remain unique and executable.

The foundation requires Node `22.12.0` or later, npm, Docker, and Docker Compose
`2.20.0` or later to run `verify`.

## Documentation map

- [`PROJECT.md`](PROJECT.md): Product contract, sources of truth, architecture, and commands.
- [`STATUS.md`](STATUS.md): State verified on a specified date.
- [`ROADMAP.md`](ROADMAP.md): Delivery order and exit criteria.
- [`CHANGELOG.md`](CHANGELOG.md): Delivered changes and observable effects.
- [`FOUNDATION.md`](FOUNDATION.md): Foundation version, profiles, and exceptions.
- [`DOCUMENTATION-CATALOG.md`](DOCUMENTATION-CATALOG.md): Complete navigation for Markdown files and their audiences.
- `docs-nimbus/`: Mandatory documentation engine, adapter, configuration, and lockfile.
- [`AGENTS.md`](AGENTS.md): Local adapter for assisted work.
- `docs/decisions/`: Architectural decisions.
- `docs/foundation/`: Vendored snapshot of the core and profiles. Do not edit it locally.

Specialized documents, such as `DESIGN.md` and runbooks, remain linked from `PROJECT.md`.

This README provides navigation. It is not a second roadmap, a second architecture document, or a copy of the commands.
