# STATUS.md

Snapshot vérifié le 2026-07-26.

## Référence

| Champ | Valeur |
| --- | --- |
| Branche | `main` |
| Version | `v0.1.0` |
| Environnement | macOS local |
| Production | Non applicable |
| Remote | Non configuré |

## Livré et vérifié

| Capacité | Périmètre réel | Preuve | Limite connue |
| --- | --- | --- | --- |
| Noyau | Invariants, defaults et définition de done | Relecture croisée des quatre zones sources et `AUDIT.md` | Première version |
| Bootstrap | Quatre packs, six profils, dry-run et copie atomique sans écrasement | `scripts/bootstrap.sh` et `scripts/test_bootstrap.sh` verts | Le contenu métier généré reste à compléter |
| Profils | Web, backend et données, infrastructure, expérience, artefacts générés et dépendances | Profils opt-in vérifiés | Pas de profil mobile natif ou data science |
| Provenance | Audit des règles retenues, écartées et laissées locales | `AUDIT.md` | Snapshot daté |
| Vérification | Structure, liens, ancres, style, placeholders et sécurité du bootstrap | `./scripts/verify.sh` vert sur macOS local | Ne remplace pas une revue éditoriale |

## Phase active

| Phase roadmap | État observé | Prochaine preuve |
| --- | --- | --- |
| `F01` | Socle et initialiseur livrés, vérifiés et versionnés | Première adoption réelle |
| `F02` | Planifiée | Projet neuf complété et vérifié sans dépendance au dépôt source |

## Cible non livrée

- commande d'audit d'un projet adopté ;
- commande de mise à niveau assistée entre deux versions du socle ;
- preuve d'adoption sur un nouveau dépôt réel.

## Blocage externe

La création d'un remote privé et sa publication nécessitent une décision du propriétaire. Elles ne bloquent pas la release locale et aucun remote n'est supposé.

## Dérives connues

Le workflow GitHub Actions est configuré mais n'a pas été exécuté sur une forge, faute de remote. Les contradictions des projets sources restent documentées dans `AUDIT.md` et ne sont pas corrigées par ce dépôt.

Après `F01`, la phase suivante est `F02`, test d'adoption sur un dépôt neuf.
