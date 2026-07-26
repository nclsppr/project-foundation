# Versioning et mise à niveau

Le socle utilise des tags `vMAJOR.MINOR.PATCH`.

Avant `v1.0.0`, une version mineure peut encore réorganiser le pack d'adoption. Toute incompatibilité reste explicitement signalée dans `CHANGELOG.md`.

Le fichier `VERSION` est la source canonique de la version courante. `PROJECT.md`, `STATUS.md`, la première entrée de `CHANGELOG.md` et le tag de release doivent lui correspondre. `./scripts/verify.sh` contrôle cette cohérence.

## Nature des versions

| Version | Changement |
| --- | --- |
| Major | Invariant supprimé ou changé, format d'adoption incompatible, migration obligatoire |
| Minor | Nouveau profil, default, template ou capacité compatible avec les snapshots existants |
| Patch | Clarification, correction de lien, contrôle plus précis sans changement d'intention |

## Créer une release

1. Mettre à jour `VERSION`.
2. Mettre à jour `CHANGELOG.md`.
3. Mettre à jour `PROJECT.md`, `STATUS.md` et `ROADMAP.md` si leur état change.
4. Exécuter `./scripts/verify.sh`.
5. Relire le diff complet.
6. Créer un commit cohérent.
7. Créer un tag annoté `vMAJOR.MINOR.PATCH`.
8. Rejouer `./scripts/verify.sh --release` sur le worktree propre.
9. Publier commit et tag uniquement si un remote a été explicitement configuré.

Le tag lisible facilite la discussion. Le commit complet reste la référence immuable.

## Adopter une version

Le projet consommateur enregistre dans `FOUNDATION.md` :

- la source ;
- le tag ;
- le commit complet ;
- les profils activés ;
- les dérogations et contrôles compensatoires.

Le snapshot est copié sous `docs/foundation/` et commité avec le projet.

## Mettre à niveau un projet

1. Lire les entrées du changelog entre les deux versions.
2. Vérifier les changements incompatibles et notes de migration.
3. Remplacer le snapshot, sans fusion silencieuse ligne par ligne.
4. Examiner le diff des invariants, defaults, profils et gates.
5. Réconcilier les dérogations locales.
6. Comparer les nouvelles baselines de `scripts/check_markdown.py` et `scripts/verify.sh`, puis fusionner explicitement les corrections utiles sans écraser les gates locales.
7. Exécuter la vérification du projet.
8. Livrer snapshot, version et adaptations dans une seule unité.

Une mise à jour automatique peut proposer un diff. Elle ne doit jamais modifier silencieusement les règles locales ou les protections d'un projet.

## Dépréciation

Une règle ou un profil remplacé reste documenté au moins jusqu'à la prochaine version majeure, avec :

- sa remplaçante ;
- la raison ;
- la migration ;
- la date ou version de retrait prévue.
