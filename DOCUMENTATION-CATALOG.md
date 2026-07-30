<!-- Généré par scripts/documentation_catalog.py. Ne pas modifier à la main. -->

# Catalogue documentaire

Tous les fichiers Markdown maintenus par le projet sont classés ici depuis `documentation.json`.

Moteur déclaré : `nimbus`.

| Collection | Visibilité | Fichiers |
| --- | --- | ---: |
| Guides publics | `public` | 9 |
| Gouvernance interne | `internal` | 7 |
| Décisions | `reference` | 5 |
| Profils | `reference` | 7 |
| Templates | `reference` | 16 |
| Exemples | `reference` | 1 |
| Maintenance Nimbus | `reference` | 1 |

## Guides publics

- [ADOPTION.md](ADOPTION.md)
- [CHANGELOG.md](CHANGELOG.md)
- [DEFAULTS.md](DEFAULTS.md)
- [DEFINITION-OF-DONE.md](DEFINITION-OF-DONE.md)
- [DOCUMENTATION.md](DOCUMENTATION.md)
- [PRINCIPLES.md](PRINCIPLES.md)
- [PROJECT-BOOTSTRAP.md](PROJECT-BOOTSTRAP.md)
- [README.md](README.md)
- [VERSIONING.md](VERSIONING.md)

## Gouvernance interne

- [AGENTS.md](AGENTS.md)
- [AUDIT.md](AUDIT.md)
- [CLAUDE.md](CLAUDE.md)
- [DOCUMENTATION-CATALOG.md](DOCUMENTATION-CATALOG.md)
- [PROJECT.md](PROJECT.md)
- [ROADMAP.md](ROADMAP.md)
- [STATUS.md](STATUS.md)

## Décisions

- [docs/decisions/adr-0001-standalone-versioned-foundation.md](docs/decisions/adr-0001-standalone-versioned-foundation.md)
- [docs/decisions/adr-0002-catalogue-universel-nimbus-optionnel.md](docs/decisions/adr-0002-catalogue-universel-nimbus-optionnel.md)
- [docs/decisions/adr-0003-nimbus-obligatoire.md](docs/decisions/adr-0003-nimbus-obligatoire.md)
- [docs/decisions/adr-0004-publication-git-obligatoire.md](docs/decisions/adr-0004-publication-git-obligatoire.md)
- [docs/decisions/adr-0005-docker-compose-obligatoire.md](docs/decisions/adr-0005-docker-compose-obligatoire.md)

## Profils

- [profiles/backend-data.md](profiles/backend-data.md)
- [profiles/dependency-change.md](profiles/dependency-change.md)
- [profiles/documentation-nimbus.md](profiles/documentation-nimbus.md)
- [profiles/experiment.md](profiles/experiment.md)
- [profiles/generated-artifacts.md](profiles/generated-artifacts.md)
- [profiles/infrastructure-production.md](profiles/infrastructure-production.md)
- [profiles/web.md](profiles/web.md)

## Templates

- [templates/ADR.md](templates/ADR.md)
- [templates/AGENTS-minimal.md](templates/AGENTS-minimal.md)
- [templates/AGENTS.md](templates/AGENTS.md)
- [templates/BRIEF.md](templates/BRIEF.md)
- [templates/CHANGELOG.md](templates/CHANGELOG.md)
- [templates/CLAUDE.md](templates/CLAUDE.md)
- [templates/DELIVERY-EVIDENCE.md](templates/DELIVERY-EVIDENCE.md)
- [templates/DESIGN.md](templates/DESIGN.md)
- [templates/DOCUMENTATION.md](templates/DOCUMENTATION.md)
- [templates/FOUNDATION.md](templates/FOUNDATION.md)
- [templates/PROJECT.md](templates/PROJECT.md)
- [templates/README-standard.md](templates/README-standard.md)
- [templates/README.md](templates/README.md)
- [templates/ROADMAP.md](templates/ROADMAP.md)
- [templates/RUNBOOK.md](templates/RUNBOOK.md)
- [templates/STATUS.md](templates/STATUS.md)

## Exemples

- [examples/minimal-web/README.md](examples/minimal-web/README.md)

## Maintenance Nimbus

- [docs-nimbus/AGENT.md](docs-nimbus/AGENT.md)

## Chemins ignorés

Ces chemins contiennent des dépendances ou sorties dérivées, pas des sources documentaires maintenues.

| Motif | Glob |
| --- | --- |
| Dépendances tierces | `node_modules/**/*.md` |
| Sorties générées | `dist/**/*.md` |
| Sorties générées | `build/**/*.md` |
| Environnement Python local | `.venv/**/*.md` |
| Collection Nimbus générée depuis les sources classées | `docs-nimbus/src/content/docs/**/*.md` |
| Dépendances Nimbus tierces | `docs-nimbus/node_modules/**/*.md` |
| Site Nimbus généré | `docs-nimbus/dist/**/*.md` |
