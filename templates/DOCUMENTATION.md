# Documentation contract

Every Markdown file maintained by this project belongs to one collection in
`documentation.json` and appears in `DOCUMENTATION-CATALOG.md`.

## Rules

- Classify each file as `public`, `internal`, `reference`, or `archive`.
- Do not publish an internal collection for convenience.
- Keep one editorial source.
- Treat the catalog and each web rendering as derived artifacts.
- Verify navigation, links, search, and audience on the final surface.

Visibility controls rendering, not Git permissions. In a public repository,
an `internal` file remains accessible through Git. Do not commit secrets or
confidential content.

## Commands

```bash
python3 scripts/documentation_catalog.py --write
./scripts/verify.sh
```

Nimbus is mandatory. Its generated collection remains ignored by Git. Its
complete build command is part of `scripts/verify.sh`. Commit its version,
lockfile, and configuration with the project.

The local build can combine all audiences for navigation. Never publish it
without an explicit and verified filter for authorized collections.

## Add a Markdown file

1. Create the file in its canonical source location.
2. Verify that only one manifest glob classifies the file.
3. Regenerate the catalog.
4. Review its visibility and its position in navigation.
5. Verify the applicable public or internal rendering.
