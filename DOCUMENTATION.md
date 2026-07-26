# Contrat documentaire

Tous les fichiers Markdown maintenus dans ce dépôt appartiennent au système de
documentation du projet. Aucun `.md` ne reste orphelin dans le tree.

## Sources de vérité

- `documentation.json` classe les fichiers par collection et visibilité.
- `DOCUMENTATION-CATALOG.md` est la navigation exhaustive générée.
- les fichiers Markdown classés restent les sources éditoriales ;
- un rendu comme Nimbus est un consommateur dérivé, jamais une seconde source.

## Visibilités

| Visibilité | Usage |
| --- | --- |
| `public` | Peut être rendu sur une documentation publique |
| `internal` | Reste accessible dans la documentation interne ou le dépôt |
| `reference` | Règle, template, décision ou matériau de référence |
| `archive` | Historique conservé, explicitement non courant |

Un fichier interne, sensible ou opératoire appartient toujours au catalogue,
mais n'est pas publié sur une surface publique. Le moteur de rendu doit respecter
cette frontière.

Ces visibilités pilotent le rendu documentaire, pas les droits d'accès Git. Dans
un dépôt public comme Project Foundation, tout fichier commité reste lisible
publiquement, même s'il est classé `internal`. Un secret ou un contenu réellement
confidentiel ne doit jamais entrer dans Git.

## Cycle de modification

Après l'ajout, le déplacement ou la suppression d'un Markdown :

1. ajuster sa collection dans `documentation.json` si aucun glob existant ne le couvre ;
2. lancer `python3 scripts/documentation_catalog.py --write` ;
3. relire le catalogue et la visibilité attribuée ;
4. lancer `./scripts/verify.sh` ;
5. vérifier le rendu final si un moteur comme Nimbus est activé.

Les chemins ignorés du manifeste sont réservés aux dépendances et sorties
générées. Ils portent toujours une raison explicite.

## Choix du moteur

Le catalogue est la baseline sans dépendance web. Pour un produit durable qui a
besoin de navigation, recherche, publication ou sorties destinées aux agents,
Nimbus est le default actuel via `profiles/documentation-nimbus.md`. Il reste un
profil remplaçable, versionné et vérifié dans chaque projet.

Project Foundation n'embarque pas lui-même le runtime Nimbus en `v0.2.0`. Cette
séparation conserve un bootstrap léger en Git, Bash et Python et évite de copier
l'adaptateur spécifique de Surplasse. La décision est détaillée dans l'ADR-0002.
