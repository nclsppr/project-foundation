# FOUNDATION.md

Contrat d'adoption du socle commun par ce projet.

## Version

| Champ | Valeur |
| --- | --- |
| Source | TODO URL ou chemin d'origine |
| Version lisible | TODO tag |
| Commit immuable | TODO SHA complet |
| Pack adopté | TODO minimal, standard, full ou critical |
| Adoptée le | TODO YYYY-MM-DD |
| Adoptée par | TODO |

## Snapshot vendorisé

Les fichiers suivants sont copiés sous `docs/foundation/` et ne sont pas édités localement :

- `PRINCIPLES.md`
- `DEFAULTS.md`
- `DEFINITION-OF-DONE.md`

Les profils vendorisés sont exactement ceux de la section « Profils activés ».

Une mise à jour remplace ces fichiers depuis une nouvelle version du socle. Relire le diff avant de changer la version enregistrée ici.

## Profils activés

- TODO

Les profils sont des politiques durables du projet. Leurs gates ne s'appliquent
qu'aux unités de travail qui rencontrent leur déclencheur.

## Dérogations et contrôles compensatoires

| Règle ou default | Portée | Choix local | Raison | Contrôle compensatoire | Propriétaire | Réexamen | ADR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |

Une dérogation à un invariant exige une portée limitée, un contrôle compensatoire et une date de réexamen.

## Sources locales supplémentaires

Les règles locales vivent dans leur document naturel. Cette table les référence sans les recopier.

| Sujet | Source locale |
| --- | --- |
| TODO | TODO |

## Adaptateurs locaux initialisés

Les fichiers suivants partent de la baseline du socle puis deviennent locaux et
éditables :

- `scripts/check_markdown.py`
- `scripts/verify.sh`

Ils peuvent recevoir les gates propres au projet. Une mise à niveau compare leur
baseline avec la nouvelle version, puis fusionne explicitement les corrections
utiles sans écraser les contrôles locaux.

## Reclassification et activation ultérieure

Lorsqu'un projet change de classe :

1. choisir le nouveau pack ;
2. ajouter les documents requis ;
3. aligner `Pack adopté` ici et `Classe` dans `PROJECT.md` ou `BRIEF.md` ;
4. activer les profils durables nécessaires ;
5. exécuter la vérification et livrer le tout atomiquement.

Lors d'un downgrade, retirer uniquement les stubs jamais utilisés. Un runbook,
une preuve ou une décision historique est marqué comme inactif ou archivé, pas
supprimé silencieusement.

Lorsqu'une unité exige un profil non encore activé, copier ce profil depuis le
même commit du socle, l'ajouter à la liste ci-dessus, puis consigner dans la
preuve de livraison les gates de ce profil applicables à l'unité.

## Mise à jour

1. Lire le changelog du socle entre la version actuelle et la cible.
2. Remplacer le snapshot vendorisé.
3. Examiner les changements d'invariants, defaults et profils.
4. Mettre à jour les dérogations locales si nécessaire.
5. Comparer la nouvelle baseline des scripts et fusionner les corrections utiles.
6. Exécuter la commande de vérification du projet.
7. Committer le snapshot, ce fichier et les adaptations dans une seule unité.
