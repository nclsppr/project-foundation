# PROJECT.md

## Identité

| Champ | Valeur |
| --- | --- |
| Nom | TODO |
| Propriétaire | TODO |
| Classe | TODO exploration, prototype, produit ou critique |
| Surface de production | TODO URL, environnement ou non applicable |
| Socle adopté | [`FOUNDATION.md`](FOUNDATION.md) |

## Problème

TODO Décrire le problème réel en une phrase.

## Utilisateurs

| Utilisateur | Situation | Besoin | Risque principal |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

## Résultat attendu

TODO Décrire le changement observable pour l'utilisateur ou l'opérateur.

### Preuves de succès

| Preuve | Baseline connue | Cible | Source | Échéance |
| --- | --- | --- | --- | --- |
| TODO | TODO ou inconnue | TODO | TODO | TODO |

Ne jamais transformer une cible en résultat acquis.

## Périmètre

### Inclus

- TODO

### Non-objectifs

- TODO

### Conditions d'arrêt ou de réévaluation

- TODO

## État et séquencement

- L'état réellement vérifié vit dans [`STATUS.md`](STATUS.md).
- L'ordre de livraison et ses critères de sortie vivent dans [`ROADMAP.md`](ROADMAP.md).
- Une priorité intrinsèque ne remplace pas l'ordre de livraison.

## Sources de vérité

| Concept | Source canonique | Type | Notes |
| --- | --- | --- | --- |
| Produit | TODO | normative | |
| État courant | `STATUS.md` | snapshot opérationnel | Daté et vérifié |
| Roadmap | `ROADMAP.md` | normative | Autorité de séquencement |
| Historique des changements | `CHANGELOG.md` | historique | Chaque changement livré et son impact observable |
| Architecture | TODO | normative | |
| Contrat API | TODO | normative ou non applicable | |
| Schéma de données | TODO | normative ou non applicable | |
| Design system | TODO | normative ou non applicable | |
| Configuration | `compose.yaml` et TODO configuration complémentaire | opérationnelle | Compose porte le parcours local intégré imposé par `P19` |
| Code livré | TODO | opérationnelle | |
| Opérations | TODO | normative | |
| Décisions | `docs/decisions/` | normative | |
| Documentation | `DOCUMENTATION.md`, `documentation.json`, `docs-nimbus/` et catalogue généré | normative et dérivée | Chaque Markdown possède une audience et passe dans Nimbus |
| Artefacts générés | TODO | dérivée | Nommer leur source |
| Archives | TODO | historique | Jamais normative |
| Expériences | TODO | expérimentale | Isolées |

## Architecture

Pour un petit projet, cette section peut être la source canonique et la ligne « Architecture » ci-dessus pointe vers `PROJECT.md#architecture`. Pour un projet plus grand, remplacer le contenu détaillé par un résumé et un lien vers le document canonique. Ne jamais maintenir deux descriptions complètes.

### Composants

| Composant | Rôle | Statut | Exécution | Version | Source | Preuve et date | Propriétaire |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TODO | TODO | actuel, cible, expérience ou retiré | dev, build, CI ou prod | TODO | TODO | TODO | TODO |

### Flux principal

TODO

### Dépendances externes

| Dépendance | Usage | Données transmises | Mode d'échec | Alternative |
| --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO |

## Environnements

| Environnement | Plateforme | Configuration canonique | URL ou accès | Vérification |
| --- | --- | --- | --- | --- |
| Développement | Docker Compose et TODO plateforme hôte | `compose.yaml` | TODO URL ou accès | `python3 scripts/check_compose.py` puis sondes du parcours |
| CI | TODO | `.github/workflows/verify.yml` | Runs de la plateforme | `./scripts/verify.sh` |
| Production | TODO | TODO | TODO | TODO |

## Commandes canoniques

| Action | Commande | Résultat attendu |
| --- | --- | --- |
| Installer | TODO | TODO |
| Développer | `docker compose up --build --wait` | Tous les services requis deviennent sains |
| Vérifier | `./scripts/verify.sh` | Catalogue, Markdown, tests, typecheck, build et lint Nimbus valides |
| Vérifier Compose | `python3 scripts/check_compose.py` | Configuration, services, digests et healthchecks conformes à `P19` |
| Construire | TODO | TODO |
| Construire la documentation | `npm run build --prefix docs-nimbus` | Site Nimbus statique généré depuis les Markdown classés |
| Arrêter | `docker compose down` | Services arrêtés, volumes préservés |
| Réinitialiser le dev | TODO commande avec cibles explicites | Seules les données de développement nommées sont supprimées |
| Déployer | TODO | TODO |
| Contrôler la santé | TODO | TODO |
| Sauvegarder | TODO ou non applicable | TODO |
| Restaurer | TODO ou non applicable | TODO |

## Données, sécurité et confidentialité

- Classification des données : TODO
- Secrets et injection : TODO
- Authentification et autorisation : TODO
- Isolation : TODO
- Rétention : TODO
- Sauvegarde et restauration : TODO
- Journalisation sans données sensibles : TODO

## Qualité

Les profils applicables au projet et les dérogations vivent uniquement dans `FOUNDATION.md`.

Matrice de validation :

| Risque | Contrôle automatisé | Contrôle manuel | Environnement |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

## Livraison

`P18` impose le commit et le push de chaque tranche validée. La politique locale
choisit la destination, jamais l'absence de publication distante.

`P19` impose `compose.yaml` comme chemin local intégré. Une commande hôte peut
rester documentée comme raccourci, jamais comme unique procédure reproductible.

- Branche canonique : TODO
- Push direct ou branche avec revue : TODO
- Convention de commit : TODO
- Artefact : TODO
- Déploiement : TODO
- Rollback : TODO
- Vérification finale : TODO
- Observabilité : TODO
- Escalade : TODO

## Responsabilités

| Zone | Propriétaire | Suppléant | Runbook |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

Les risques courants, blocages et prochaines preuves vivent dans `STATUS.md`.
Les changements livrés vivent dans `CHANGELOG.md`. Les décisions produit ou
techniques importantes vivent dans les ADR.
