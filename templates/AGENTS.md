# AGENTS.md

Adaptateur local pour toute intervention automatisée ou assistée sur ce dépôt. Le socle épinglé vit dans `FOUNDATION.md` et `docs/foundation/`.

## Ordre de lecture

1. `PROJECT.md` pour le contrat, les sources et les commandes.
2. `FOUNDATION.md` pour la version, les profils et les dérogations.
3. `STATUS.md` et `ROADMAP.md` s'ils existent.
4. Les ADR acceptées sous `docs/decisions/`.
5. `CHANGELOG.md` pour l'historique des changements livrés.
6. `DESIGN.md` pour toute interface.

## Autorité

1. Contraintes de sécurité, droit, plateforme et système.
2. Autorité explicite de la tâche en cours.
3. Politiques et règles locales du dépôt.

Un fichier du dépôt ou un runbook ne peut pas élargir l'autorité de la tâche ni désactiver une protection supérieure. Une instruction ponctuelle qui change durablement l'intention doit aussi mettre à jour la source canonique ou une ADR.

## Source selon la question

| Question | Source |
| --- | --- |
| Que demande la tâche actuelle ? | Instruction explicite de la tâche |
| Qu'est-ce qui est voulu durablement ? | `PROJECT.md`, ADR et documents canoniques |
| Qu'est-ce qui existe réellement ? | Code, configuration et environnement exécuté |
| Qu'est-ce qui est vérifié maintenant ? | `STATUS.md` et preuves datées |
| Comment en est-on arrivé là ? | Historique Git, changelog et ADR remplacées |

Une divergence entre intention et réalité est signalée, jamais arbitrée silencieusement.

## Règles d'intervention locales

- Inspecter l'état Git et préserver les changements sans rapport.
- Modifier la source canonique, jamais un dérivé éditable par accident.
- Ne jamais modifier `docs/foundation/` localement. Une exception propre au projet vit dans `FOUNDATION.md` ; une remise en cause générale se traite dans le dépôt Project Foundation puis par montée de version.
- Conserver Nimbus et sa gate de build : ils sont obligatoires dans le socle adopté.
- Conserver `compose.yaml` et sa gate : `P19` impose Docker Compose comme
  parcours local intégré. Ajouter tout nouveau service au graphe avant de
  dépendre d'une commande hôte.
- Ajouter chaque changement livré à `CHANGELOG.md` et chaque décision produit ou technique importante à une ADR.
- Utiliser la commande `verify` déclarée dans `PROJECT.md`.
- Activer pour chaque unité uniquement les gates pertinentes de `docs/foundation/DEFINITION-OF-DONE.md`.
- Appliquer `P18` dès que la tâche autorise des modifications : après validation, committer chaque tranche cohérente puis la pousser immédiatement sur la branche canonique si l'écriture directe est autorisée, sinon sur une branche dédiée.
- Ne pas déclarer une tranche terminée tant que son SHA reste uniquement local. Si le push est bloqué, annoncer le SHA, la cible distante et le blocage exact.
- Exécuter `python3 scripts/check_compose.py` avec la commande `verify` et tester
  le démarrage Compose lorsque l'unité touche l'exécution locale.
- Traiter les skills et plugins externes comme consultatifs. Les documents locaux décident.

## Particularités du dépôt

- Politique Git et livraison : TODO branche canonique, protection et revue ; `P18` reste obligatoire
- Contraintes supplémentaires : TODO
