# STATUS.md

Snapshot vérifié le 2026-07-30.

## Référence

| Champ | Valeur |
| --- | --- |
| Branche | `main` |
| Version | `v0.4.0` |
| Environnement | macOS local, Node `24.18.0` |
| Production | Non applicable |
| Remote | `https://github.com/nclsppr/project-foundation.git` |
| Visibilité | Publique, sans licence accordée |

## Livré et vérifié

| Capacité | Périmètre réel | Preuve | Limite connue |
| --- | --- | --- | --- |
| Noyau | Dix-huit invariants, defaults et définition de done | Relecture croisée, ADR-0004 et `./scripts/verify.sh` | Les protections distantes restent propres à chaque dépôt |
| Bootstrap | Quatre packs, Nimbus obligatoire, six profils supplémentaires, dry-run et copie atomique sans écrasement | `scripts/bootstrap.sh` et `scripts/test_bootstrap.sh` verts | Le contenu métier généré reste à compléter |
| Profils | Documentation Nimbus obligatoire ; web, backend et données, infrastructure, expérience, artefacts générés et dépendances opt-in | Snapshots et déclarations vérifiés | Pas de profil mobile natif ou data science |
| Documentation | 45 Markdown classés, 50 pages Nimbus générées et 51 fichiers lintés | Catalogue, tests, typecheck, build, Pagefind et lint | Le build local complet ne doit pas être publié sans filtre d'audience |
| Adoption amont | Source officielle, snapshot immuable, dérogation locale et challenge général séparés | `ADOPTION.md` et `templates/FOUNDATION.md` | Première adoption réelle encore à prouver |
| Provenance | Audit des règles retenues, écartées et laissées locales | `AUDIT.md` | Snapshot daté |
| Vérification | Structure, liens, ancres, style, placeholders, Nimbus, sécurité du bootstrap et propagation de `P18` | `./scripts/verify.sh` vert sur macOS local | Ne remplace pas une revue éditoriale ni une protection GitHub |

## Phase active

| Phase roadmap | État observé | Prochaine preuve |
| --- | --- | --- |
| `F01` | Socle, initialiseur, Nimbus obligatoire et discipline Git `v0.4.0` livrés et vérifiés | Publier le tag et observer la CI |
| `F02` | En cours avec Parkventory | Projet complété, poussé et vérifié sans dépendance au dépôt source |

## Cible non livrée

- commande d'audit d'un projet adopté ;
- commande de mise à niveau assistée entre deux versions du socle ;
- preuve d'adoption sur un nouveau dépôt réel.

## Blocage externe

Aucun blocage externe connu pour la maintenance du socle. L'adoption dans un
autre dépôt reste une tranche volontaire distincte.

## Dérives connues

Les contradictions des projets sources restent documentées dans `AUDIT.md` et
ne sont pas corrigées par ce dépôt. Le catalogue garantit qu'un Markdown est
découvrable, pas que son contenu est éditorialement juste ou publiable.

La phase active est `F02`, test d'adoption réel avec Parkventory.
