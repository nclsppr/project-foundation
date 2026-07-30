# PROJECT.md

## Identité

| Champ | Valeur |
| --- | --- |
| Nom | Project Foundation |
| Propriétaire | Nicolas Pieper |
| Classe | Produit interne |
| Surface de production | Aucune |
| Version | 0.5.1 |
| Licence | Dépôt public, aucune licence accordée |

## Problème

Les projets créés au fil du temps accumulent de bonnes règles, mais celles-ci restent dispersées, dupliquées et trop liées à une stack ou à un outil d'agent.

## Utilisateurs

| Utilisateur | Situation | Besoin | Risque principal |
| --- | --- | --- | --- |
| Nicolas | Démarre ou reprend un projet | Retrouver un cadre commun immédiatement | Repartir de zéro ou copier des règles obsolètes |
| Agent de développement | Intervient dans un dépôt | Découvrir les sources, limites et gates locales | Inventer le contexte ou appliquer un conseil générique |

## Résultat attendu

Un nouveau dépôt peut adopter un noyau cohérent, choisir ses profils, documenter ses dérogations et rester autonome après copie du snapshot.

### Preuves de succès

| Preuve | Cible | Source |
| --- | --- | --- |
| Bootstrap compréhensible | Un nouveau projet peut remplir les documents sans contexte caché | `PROJECT-BOOTSTRAP.md` et templates |
| Socle cohérent | Liens valides, fichiers requis présents, aucune valeur à compléter dans le noyau | `./scripts/verify.sh` |
| Adoption traçable | Version, profils et dérogations enregistrés | `templates/FOUNDATION.md` |
| Documentation exhaustive | Chaque Markdown est classé une fois, possède une audience et passe dans Nimbus | `documentation.json`, catalogue, build Nimbus et `./scripts/verify.sh` |
| Évolution commune | Un challenge général remonte dans le dépôt du socle avant mise à niveau | `ADOPTION.md` et `templates/FOUNDATION.md` |
| Travail durablement livré | Chaque tranche vérifiée possède un SHA distant reprenable | `P18`, adaptateurs `AGENTS.md` et définition de done |
| Environnement local contractuel | Tout pack possède Compose et tout projet durable déclare un service contrôlé | `P19`, `compose.yaml`, `scripts/check_compose.py` et tests du bootstrap |

## Périmètre

### Inclus

- principes de travail universels ;
- defaults révocables ;
- profils web, backend et données, production et expérience ;
- profils d'artefacts générés et de changement de dépendance ;
- moteur Nimbus obligatoire, scaffold officiel, adaptateur et lockfile ;
- templates de contrat, statut, roadmap, agents, ADR et design ;
- templates de runbook et de preuve de livraison ;
- manifeste et catalogue documentaires communs à tous les packs ;
- procédure d'adoption, de contribution amont et de mise à niveau ;
- discipline universelle de commit et push des tranches validées ;
- orchestration locale Docker Compose obligatoire et contrôlée ;
- workflow CI copié dans chaque pack ;
- définition de done et audit d'origine ;
- vérification locale et CI du socle.

### Non-objectifs

- imposer une stack applicative, un hébergeur Git ou un modèle unique de revue ;
- fournir un framework applicatif ;
- synchroniser automatiquement les dépôts existants ;
- devenir une dépendance runtime ;
- remplacer les décisions locales ou les instructions de sécurité.

### Conditions de réévaluation

- un principe produit des exceptions dans plusieurs projets ;
- le snapshot vendorisé devient trop coûteux à mettre à jour ;
- un générateur apporte une réduction mesurable des erreurs de bootstrap ;
- une nouvelle catégorie de projet nécessite un profil distinct.

## État et séquencement

- L'état vérifié vit dans [`STATUS.md`](STATUS.md).
- L'ordre de livraison vit dans [`ROADMAP.md`](ROADMAP.md).
- Les choix structurants vivent dans `docs/decisions/`.

## Sources de vérité

| Concept | Source canonique | Type |
| --- | --- | --- |
| But et périmètre | `PROJECT.md` | normative |
| Version courante | `VERSION` | normative |
| État courant | `STATUS.md` | snapshot opérationnel |
| Séquencement | `ROADMAP.md` | normative |
| Invariants | `PRINCIPLES.md` | normative |
| Defaults | `DEFAULTS.md` | normative révocable |
| Gates | `DEFINITION-OF-DONE.md` | normative |
| Profils | `profiles/` | normative, Nimbus obligatoire et autres profils opt-in |
| Décisions | `docs/decisions/` | normative |
| Historique de versions | `CHANGELOG.md` | historique |
| Politique de version | `VERSIONING.md` | normative |
| Origine des règles | `AUDIT.md` | snapshot historique |
| Contrat documentaire | `DOCUMENTATION.md` et `documentation.json` | normative |
| Navigation documentaire | `DOCUMENTATION-CATALOG.md` | dérivée |
| Adoption et contribution amont | `ADOPTION.md` | normative |
| Templates | `templates/` | dérivée et copiable |
| Orchestration locale | `compose.yaml` et `scripts/check_compose.py` | opérationnelle et contrôlée |

## Architecture

Le dépôt est composé de Markdown portable, de scripts Bash 3.2 ou plus récent,
de contrôles Python 3.9 ou plus récent, d'un site Nimbus sous `docs-nimbus/` et
d'un contrat Docker Compose. Git porte l'historique, la provenance et les
contrôles de diff.
Un projet adopte un snapshot local des fichiers nécessaires et enregistre sa
version dans `FOUNDATION.md`. Le manifeste `documentation.json` classe tous les
Markdown ; Nimbus les rend avec Node 22.12 ou plus récent.

## Environnements

| Environnement | Support | Vérification |
| --- | --- | --- |
| macOS | Référence locale, Git, Bash 3.2, Python 3.9, Node 22.12 ou plus et Docker Compose 2.20 ou plus | `./scripts/verify.sh` |
| Linux | Supporté, mêmes prérequis | `./scripts/verify.sh` et workflow CI |
| Windows | Via WSL2 avec les mêmes prérequis | `./scripts/verify.sh` |

## Commandes canoniques

| Action | Commande | Résultat attendu |
| --- | --- | --- |
| Prérequis | `git --version && bash --version && python3 --version && node --version && npm --version && docker compose version` | Git, Bash 3.2, Python 3.9, Node 22.12, npm et Docker Compose 2.20 disponibles |
| Vérifier | `./scripts/verify.sh` | Catalogue, Markdown, tests, typecheck, build, lint Nimbus et bootstrap valides |
| Vérifier Compose | `python3 scripts/check_compose.py` | Contrat Compose, digests et cycles de vie valides |
| Vérifier Nimbus dans Compose | `docker compose run --rm documentation-check` | Contrôles Nimbus exécutés dans l'image épinglée |
| Vérifier une release | `./scripts/verify.sh --release` | Worktree propre, version cohérente et tag annoté sur HEAD |
| Régénérer la navigation | `python3 scripts/documentation_catalog.py --write` | Catalogue aligné sur le manifeste et les Markdown |
| Construire la documentation | `npm run build --prefix docs-nimbus` | Site Nimbus statique généré depuis les Markdown classés |
| Déployer | Non applicable | Le dépôt est consommé par copie versionnée |

## Données et sécurité

- Aucune donnée personnelle ou secret n'est nécessaire.
- Les exemples ne doivent contenir aucune valeur réelle sensible.
- Le dépôt public n'accorde aucune licence de réutilisation tant qu'un fichier `LICENSE` n'est pas décidé.

## Livraison

- Branche canonique : `main`, publiée sur `origin`.
- Un changement de principe explique sa raison, sa preuve et son niveau.
- Chaque version met à jour `CHANGELOG.md`.
- Les versions stables portent un tag.
- Dépôt officiel : `https://github.com/nclsppr/project-foundation.git`.

## Responsabilité

| Zone | Propriétaire | Reprise |
| --- | --- | --- |
| Socle et décisions | Nicolas Pieper | Documentation et historique Git |
