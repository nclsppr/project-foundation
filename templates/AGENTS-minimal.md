# AGENTS.md

Adaptateur local d'une exploration. Il ne redéfinit pas le noyau déclaré dans [`FOUNDATION.md`](FOUNDATION.md).

Lire [`BRIEF.md`](BRIEF.md), puis [`README.md`](README.md) et les profils vendorisés sous `docs/foundation/`.

## Sources selon la question

| Question | Source |
| --- | --- |
| Quelle intervention est autorisée maintenant ? | Demande explicite du propriétaire, dans les limites de sécurité et de confidentialité du socle |
| Quel résultat cherche l'exploration ? | `BRIEF.md` |
| Qu'est-ce qui existe et fonctionne réellement ? | Dépôt, configuration, commandes et processus observés maintenant |
| Pourquoi un choix passé a-t-il été fait ? | Historique Git ou décision datée, non normatifs pour l'état courant |

Une intention n'est pas une preuve d'état. Signaler tout écart sans choisir silencieusement une couche.

## Intervention

- Rester dans la question, le périmètre et la limite du brief.
- Inspecter l'état du dépôt avant d'agir et préserver le travail sans rapport.
- Utiliser les commandes canoniques du README et rapporter uniquement les preuves réellement observées.
- Ne pas modifier `docs/foundation/`. Une exception reste dans `FOUNDATION.md` ; une règle générale se change dans le dépôt Project Foundation puis se réadopte par version.
- Conserver Nimbus et sa gate de build, même pour cette exploration.
- Ajouter chaque changement livré à `CHANGELOG.md` ; consigner une décision importante dans le brief ou une ADR si l'exploration devient durable.
- Mettre à jour la conclusion et ses limites dans `BRIEF.md`.
- Si l'exploration devient un produit, arrêter ce parcours léger et effectuer un bootstrap standard.
