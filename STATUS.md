# STATUS.md

Snapshot vérifié le 2026-07-30.

## Référence

| Champ | Valeur |
| --- | --- |
| Branche | `main` |
| Version | `v0.5.1` |
| Environnement | macOS local, Node `24.18.0`, Docker Compose `5.1.2` |
| Production | Non applicable |
| Remote | `https://github.com/nclsppr/project-foundation.git` |
| Visibilité | Publique, sans licence accordée |

## Livré et vérifié

| Capacité | Périmètre réel | Preuve | Limite connue |
| --- | --- | --- | --- |
| Noyau | Dix-neuf invariants, defaults et définition de done | Relecture croisée, ADR-0004, ADR-0005 et `./scripts/verify.sh` | Les protections distantes restent propres à chaque dépôt |
| Bootstrap | Quatre packs, Nimbus et Compose obligatoires, CI générée, six profils supplémentaires, dry-run et copie atomique sans écrasement | `scripts/bootstrap.sh` et `scripts/test_bootstrap.sh` verts | Le contenu métier et les services d'un pack durable restent à compléter |
| Profils | Documentation Nimbus obligatoire ; web, backend et données, infrastructure, expérience, artefacts générés et dépendances opt-in | Snapshots et déclarations vérifiés | Pas de profil mobile natif ou data science |
| Documentation | 46 Markdown classés, 51 pages Nimbus générées et 52 fichiers lintés | Catalogue, tests, typecheck, build, Pagefind et lint | Le build local complet ne doit pas être publié sans filtre d'audience |
| Adoption amont | Source officielle, snapshot immuable, dérogation locale et challenge général séparés | Parkventory au SHA `d9a50adb04ad1c7e038d7c672723c6dd4bba07d4`, clone propre et CI verte | Une seule adoption réelle observée |
| Provenance | Audit des règles retenues, écartées et laissées locales | `AUDIT.md` | Snapshot daté |
| Orchestration locale | Compose racine, image Nimbus épinglée, cycles de vie contrôlés et checker copié | `scripts/check_compose.py`, `docker compose run --rm documentation-check` et tests de contournement | La présence d'un processus caché hors Compose reste un sujet de revue |
| Vérification | Structure, liens, ancres, style, placeholders, Nimbus, Compose, sécurité du bootstrap et propagation de `P18` et `P19` | `./scripts/verify.sh` vert sur macOS local | Ne remplace pas une revue éditoriale ni une protection GitHub |

## Phase active

| Phase roadmap | État observé | Prochaine preuve |
| --- | --- | --- |
| `F01` | `done` : socle `v0.5.1`, tag et runs main/tag à vérifier après publication | Runs distants verts sur le SHA de release |
| `F02` | `done` : Parkventory autonome, poussé et vérifié depuis un clone public | Préparer F03 sans modifier le projet consommateur |
| `F03` | `planned` : mise à niveau assistée non commencée | Définir le diff et le dry-run sans écrasement implicite |

## Cible non livrée

- commande d'audit d'un projet adopté ;
- commande de mise à niveau assistée entre deux versions du socle.

## Blocage externe

Aucun blocage externe connu pour la maintenance du socle. Une seconde adoption
reste utile pour élargir la preuve, sans remettre en cause la sortie de F02.

## Dérives connues

Les contradictions des projets sources restent documentées dans `AUDIT.md` et
ne sont pas corrigées par ce dépôt. Le catalogue garantit qu'un Markdown est
découvrable, pas que son contenu est éditorialement juste ou publiable.

Aucune phase n'est active après la sortie de F02. F03 reste la prochaine phase
planifiée.
