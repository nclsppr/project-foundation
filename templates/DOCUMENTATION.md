# Contrat documentaire

Tous les Markdown maintenus par ce projet appartiennent à une collection de
`documentation.json` et apparaissent dans `DOCUMENTATION-CATALOG.md`.

## Règles

- classer chaque fichier comme `public`, `internal`, `reference` ou `archive` ;
- ne jamais publier une collection interne par commodité ;
- conserver une seule source éditoriale ;
- traiter le catalogue et tout rendu web comme des artefacts dérivés ;
- vérifier navigation, liens, recherche et audience sur la surface finale.

Les visibilités pilotent le rendu, pas les permissions Git. Dans un dépôt
public, un fichier `internal` reste accessible depuis Git ; aucun secret ou
contenu réellement confidentiel ne doit être commité.

## Commandes

```bash
python3 scripts/documentation_catalog.py --write
./scripts/verify.sh
```

Si Nimbus est activé, sa collection générée reste ignorée par Git et sa commande
de build complète rejoint `scripts/verify.sh`. Le choix et la version du moteur
vivent dans `PROJECT.md`, une ADR et `documentation.json`.

## Ajouter un Markdown

1. Créer le fichier dans sa source canonique.
2. Vérifier qu'un seul glob du manifeste le classe.
3. Régénérer le catalogue.
4. Relire sa visibilité et sa place dans la navigation.
5. Vérifier le rendu public ou interne applicable.
