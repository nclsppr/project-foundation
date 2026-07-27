# Project Foundation

Socle commun pour démarrer, reprendre et faire évoluer un projet sans réinventer les règles de travail à chaque fois.

Ce dépôt n'est ni un framework, ni un générateur de code, ni un méga `AGENTS.md` à copier sans réfléchir. Il sépare ce qui doit rester stable de ce qui dépend du produit, du risque et de la stack.

## Pourquoi un dépôt autonome

Le socle concerne tous les projets. Il ne doit donc pas vivre dans un dépôt d'infrastructure, un projet applicatif ou la configuration d'un agent particulier.

Un dépôt autonome apporte :

- un historique versionné ;
- une source canonique unique ;
- une utilisation locale, sur un VPS ou en CI sans couplage à un projet ;
- des évolutions relisibles et réversibles ;
- des adaptateurs minces pour Codex, Claude Code ou un autre outil.

La décision de ne pas placer ce socle sous `vps/ai` est documentée dans [`AUDIT.md`](AUDIT.md). Le principe durable est simple : les règles multi-projets restent séparées de l'exploitation d'un serveur. Les règles de production VPS sont un profil du socle, pas son conteneur.

## Les trois niveaux

1. **Invariants** : règles qui s'appliquent à tout projet, dans [`PRINCIPLES.md`](PRINCIPLES.md).
2. **Defaults** : choix de départ raisonnables, révocables par une décision explicite, dans [`DEFAULTS.md`](DEFAULTS.md).
3. **Profils locaux** : politiques durables activées pour les contextes que le projet doit encadrer, dans [`profiles/`](profiles/). Leurs gates ne s'appliquent ensuite qu'aux unités concernées.

Un projet local peut renforcer le socle. Il ne le copie pas intégralement et ne le contredit pas silencieusement.

## Contrat documentaire

Tout fichier Markdown maintenu fait partie de la documentation du projet, mais
tout fichier Markdown n'est pas forcément public. `documentation.json` classe
chaque `.md` exactement une fois comme public, interne, référence ou archive.
[`DOCUMENTATION-CATALOG.md`](DOCUMENTATION-CATALOG.md) fournit la navigation
exhaustive et la commande `verify` refuse les fichiers orphelins.

Les Markdown restent les sources éditoriales. Nimbus est le moteur obligatoire
de tous les projets via
[`profiles/documentation-nimbus.md`](profiles/documentation-nimbus.md). Le
scaffold, la version épinglée et le lockfile sont copiés par tous les packs, y
compris Minimal. Le contrat complet vit dans
[`DOCUMENTATION.md`](DOCUMENTATION.md).

## Contenu

| Fichier | Rôle |
| --- | --- |
| [`PROJECT.md`](PROJECT.md) | Contrat stable de ce dépôt |
| [`STATUS.md`](STATUS.md) | État réellement vérifié de ce dépôt |
| [`ROADMAP.md`](ROADMAP.md) | Séquencement de ce dépôt |
| [`VERSION`](VERSION) | Version courante canonique |
| [`CHANGELOG.md`](CHANGELOG.md) | Historique de chaque changement livré et de son impact |
| [`PRINCIPLES.md`](PRINCIPLES.md) | Invariants universels et preuve minimale attendue |
| [`DEFAULTS.md`](DEFAULTS.md) | Valeurs de départ et décisions à rendre explicites |
| [`PROJECT-BOOTSTRAP.md`](PROJECT-BOOTSTRAP.md) | Séquence pour créer un projet de zéro |
| [`DEFINITION-OF-DONE.md`](DEFINITION-OF-DONE.md) | Critères de fin communs et gates par type de changement |
| [`VERSIONING.md`](VERSIONING.md) | Compatibilité, releases et mise à niveau d'un snapshot |
| [`ADOPTION.md`](ADOPTION.md) | Inclusion dans un projet et contribution au socle amont |
| [`DOCUMENTATION.md`](DOCUMENTATION.md) | Classement, audiences et rendu de tous les Markdown |
| [`DOCUMENTATION-CATALOG.md`](DOCUMENTATION-CATALOG.md) | Navigation exhaustive générée depuis le manifeste |
| [`docs-nimbus/`](docs-nimbus/) | Scaffold Nimbus obligatoire, adaptateur, configuration et lockfile |
| [`AUDIT.md`](AUDIT.md) | Origine des règles, exclusions et dérives observées |
| [`templates/AGENTS.md`](templates/AGENTS.md) | Contrat local, court et découvrable par les agents |
| [`templates/PROJECT.md`](templates/PROJECT.md) | Fiche produit, sources de vérité et commandes |
| [`templates/STATUS.md`](templates/STATUS.md) | Snapshot daté de l'état réellement vérifié |
| [`templates/ROADMAP.md`](templates/ROADMAP.md) | Autorité de séquencement et critères de sortie |
| [`templates/FOUNDATION.md`](templates/FOUNDATION.md) | Version du socle adoptée, profils et dérogations |
| [`templates/README.md`](templates/README.md) | Entrée d'un projet minimal |
| [`templates/README-standard.md`](templates/README-standard.md) | Entrée d'un prototype ou produit |
| [`templates/CHANGELOG.md`](templates/CHANGELOG.md) | Historique obligatoire des changements livrés |
| [`templates/BRIEF.md`](templates/BRIEF.md) | Contrat léger d'une exploration |
| [`templates/AGENTS-minimal.md`](templates/AGENTS-minimal.md) | Adaptateur court pour une exploration |
| [`templates/ADR.md`](templates/ADR.md) | Décision structurante versionnée |
| [`templates/DESIGN.md`](templates/DESIGN.md) | Contrat visuel et UX pour une interface |
| [`templates/RUNBOOK.md`](templates/RUNBOOK.md) | Procédure opératoire avec checkpoints et rollback |
| [`templates/DELIVERY-EVIDENCE.md`](templates/DELIVERY-EVIDENCE.md) | Preuves datées d'une unité de travail |
| [`profiles/web.md`](profiles/web.md) | Web, accessibilité, responsive, SEO et performance |
| [`profiles/backend-data.md`](profiles/backend-data.md) | API, données, migrations et intégrations |
| [`profiles/infrastructure-production.md`](profiles/infrastructure-production.md) | Production, secrets, sauvegardes et changements risqués |
| [`profiles/experiment.md`](profiles/experiment.md) | Prototype isolé, honnête et supprimable |
| [`profiles/generated-artifacts.md`](profiles/generated-artifacts.md) | Sources, dérivés, provenance et consommateurs |
| [`profiles/dependency-change.md`](profiles/dependency-change.md) | Besoin, licence, supply chain, coût et retrait d'un tiers |
| [`profiles/documentation-nimbus.md`](profiles/documentation-nimbus.md) | Documentation Nimbus obligatoire, dérivée, versionnée et vérifiée |
| [`examples/minimal-web/`](examples/minimal-web/) | Exemple narratif fictif du parcours Minimal, pas un dépôt généré |

## Démarrer un projet

Cloner une release du [dépôt officiel](https://github.com/nclsppr/project-foundation),
lire [`ADOPTION.md`](ADOPTION.md) et [`PROJECT-BOOTSTRAP.md`](PROJECT-BOOTSTRAP.md),
puis choisir un pack proportionné :

| Pack | Usage | Documents locaux |
| --- | --- | --- |
| Minimal | Exploration courte | README, brief, changelog, adaptateur agent, version du socle |
| Standard | Prototype | Contrat projet, statut vérifié, roadmap, changelog, adaptateur agent, version du socle |
| Full | Produit durable | Standard, ADR pour les décisions structurantes, design selon besoin |
| Critical | Données sensibles, argent ou production critique | Full, runbook, preuve de livraison et profils renforcés |

La commande de bootstrap copie le pack, le snapshot du noyau et les profils sélectionnés sans écraser de fichier :

```bash
./scripts/bootstrap.sh \
  --target /chemin/absolu/vers/le-projet \
  --class prototype \
  --profiles web,experiment
```

Prérequis du bootstrap : Git, Bash 3.2 ou plus récent et Python 3.9 ou plus
récent, sans package Python tiers. La vérification du projet exige aussi Node
22.12.0 ou plus récent et npm pour Nimbus.

Utiliser `--dry-run` pour voir les cibles avant toute écriture. Le parcours manuel reste documenté dans `PROJECT-BOOTSTRAP.md`.

Un bootstrap réel exige une version du socle commitée et un worktree propre. La provenance enregistre le commit complet et un remote nettoyé de ses credentials, jamais le contenu non commité.

Le projet ne dépend pas de ce dépôt au runtime et ne requiert aucun chemin relatif vers un clone voisin. Le snapshot vendorisé est versionné avec le projet. Il n'est pas édité localement : les dérogations vivent dans `FOUNDATION.md`, `PROJECT.md` ou une ADR. Une mise à jour remplace le snapshot depuis une nouvelle version du socle et fait l'objet d'un diff relu.

Cette frontière est volontaire. Si une règle ne convient qu'à un projet, le
projet documente une dérogation. Si la règle générale doit être challengée, le
changement se fait dans le Git officiel de Project Foundation, avec ses tests et
une nouvelle release ; le projet consommateur adopte ensuite ce tag et ce SHA.
Modifier directement `docs/foundation/` créerait un fork silencieux.

Les profils déclarés dans `FOUNDATION.md` sont des politiques durables ; une preuve de livraison n'en active que le sous-ensemble pertinent pour son unité. Les scripts de vérification copiés sont des adaptateurs locaux : lors d'une mise à niveau, comparer leur nouvelle baseline et fusionner les corrections sans écraser les gates du projet.

## Hiérarchie de vérité

Il faut distinguer la vérité normative de la vérité opérationnelle :

- les ADR acceptées et les documents canoniques disent ce qui est voulu ;
- le code, la configuration exécutable et le système réellement lancé disent ce qui existe ;
- les artefacts générés, archives, changelogs et audits datés sont des preuves ou un historique, pas une norme actuelle.

Si ces couches divergent, on ne choisit pas silencieusement la version la plus pratique. On décrit l'écart, on vérifie son impact, puis on aligne la documentation et l'implémentation dans une unité de travail explicite.

## Faire évoluer le socle

Une nouvelle règle doit répondre à quatre questions :

1. Quel problème récurrent évite-t-elle ?
2. Est-elle universelle, un default ou un profil ?
3. Comment prouve-t-on qu'elle est respectée ?
4. Comment et pourquoi peut-on y déroger ?

Une règle sans raison, sans contrôle possible ou sans frontière claire ne doit pas entrer dans le noyau.

Le protocole de contribution amont et de mise à niveau est détaillé dans
[`ADOPTION.md`](ADOPTION.md).

Le dépôt est public mais n'accorde actuellement aucune licence de
réutilisation. L'ajout d'un fichier `LICENSE` reste une décision explicite du
propriétaire.
