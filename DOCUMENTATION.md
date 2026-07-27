# Contrat documentaire

Tous les fichiers Markdown maintenus dans ce dépôt appartiennent au système de
documentation du projet. Aucun `.md` ne reste orphelin dans le tree.

## Sources de vérité

- `documentation.json` classe les fichiers par collection et visibilité.
- `DOCUMENTATION-CATALOG.md` est la navigation exhaustive générée.
- les fichiers Markdown classés restent les sources éditoriales ;
- Nimbus est le moteur obligatoire et consomme une collection dérivée, jamais une seconde source.

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
5. vérifier le rendu Nimbus final et l'audience de la surface destinée à être publiée.

Les chemins ignorés du manifeste sont réservés aux dépendances et sorties
générées. Ils portent toujours une raison explicite.

## Moteur obligatoire

Nimbus est obligatoire dans Project Foundation et dans chaque projet adopté.
Le scaffold officiel, `nimbus.json`, la version épinglée et le lockfile sont
vendorisés avec le projet. Node `22.12.0` ou plus récent et npm sont donc des
prérequis de `verify`.

Le catalogue reste la preuve exhaustive indépendante du rendu. L'adaptateur
génère `docs-nimbus/src/content/docs/` depuis les sources classées, puis Nimbus
exécute ses tests, son typecheck, son build et son lint. Cette collection est
ignorée par Git et n'est jamais éditée.

Le build local regroupe toutes les audiences pour rendre le corpus navigable.
Il n'est pas publiable tel quel par défaut. Une publication définit un filtre
explicite et vérifié pour ne jamais exposer une collection interne. La décision
est détaillée dans l'ADR-0003.
