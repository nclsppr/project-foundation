# ADR-0001 : socle autonome et versionné

- Statut : accepté
- Statut d'implémentation : livré
- Date : 2026-07-26
- Dernière vérification : 2026-07-26, vérification locale verte et release `v0.1.0`
- Propriétaire : Nicolas Pieper
- Remplace : aucune

## Contexte

Les règles utiles sont dispersées entre Surplasse, le site personnel, Papers Empire et un runbook VPS. Le dossier `vps` n'est pas versionné au moment de la décision et porte un périmètre d'exploitation spécifique.

Le socle doit servir aux projets locaux, aux agents, à la CI et éventuellement au VPS sans devenir une dépendance cachée.

## Problème à décider

Où conserver le socle et comment le rendre autonome pour chaque projet ?

## Options considérées

### Placer le socle sous `vps/ai`

Avantage : proximité avec le futur agent résident du serveur.

Limites : mélange des règles multi-projets avec l'infrastructure, absence d'historique Git actuel et sémantique liée au VPS.

### Utiliser un fichier global hors des dépôts

Avantage : une seule copie locale.

Limites : non découvrable depuis un clone, non portable en CI et dépendant d'un chemin machine.

### Créer un dépôt autonome et vendoriser un snapshot

Avantages : historique propre, version explicite, projet consommateur autonome, adoption sélective des profils.

Limite : une mise à jour du socle doit remplacer le snapshot dans chaque projet et faire l'objet d'un diff.

## Décision

Créer `project-foundation` comme dépôt autonome, agent-neutral et versionné.

Chaque projet copie un snapshot de `PRINCIPLES.md`, `DEFAULTS.md`, `DEFINITION-OF-DONE.md` et des profils retenus sous `docs/foundation/`. Il enregistre la version et les dérogations dans `FOUNDATION.md`.

Les fichiers d'agent locaux restent courts. Aucun projet ne dépend d'un chemin relatif vers ce dépôt ou d'un symlink inter-dépôts.

## Conséquences

### Positives

- le socle peut évoluer indépendamment du VPS ;
- un clone de projet reste complet ;
- les dérogations sont visibles ;
- une mise à jour est relisible comme un diff.

### Négatives

- les snapshots ne se mettent pas à jour automatiquement ;
- un outil de comparaison et de mise à niveau sera utile si l'adoption devient fréquente.

## Vérification

- dépôt Git initialisé sur `main` ;
- première version taguée ;
- bootstrap et template `FOUNDATION.md` cohérents ;
- liens locaux et structure vérifiés.

## Réexamen

Réexaminer la méthode de snapshot si plusieurs projets rencontrent une dérive récurrente ou si une distribution par package apporte un bénéfice concret sans dépendance runtime.
