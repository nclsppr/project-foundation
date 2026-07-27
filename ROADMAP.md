# ROADMAP.md

Source canonique de l'ordre d'évolution de Project Foundation.

## Résultat produit

Un projet neuf ou existant peut adopter un cadre commun en quelques minutes, sans dépendance cachée et sans importer des décisions propres à un autre dépôt.

## Vue d'ensemble

| Ordre | ID | Phase | Résultat | État | Critère de sortie |
| --- | --- | --- | --- | --- | --- |
| 1 | `F01` | Socle et bootstrap | Noyau, templates, profils et initialiseur versionnés | done | Vérification locale verte et tag `v0.1.0` |
| 2 | `F02` | Test d'adoption | Un dépôt neuf utilise réellement le socle | planned | Bootstrap rejoué, liens autonomes et commande `verify` du projet verte |
| 3 | `F03` | Mise à niveau assistée | Un projet compare puis remplace son snapshot sans perdre ses dérogations | planned | Diff explicite, dry-run, aucun écrasement implicite |
| 4 | `F04` | Audit d'adoption | Un projet détecte sa dérive par rapport au snapshot | planned | Contrôle neutre local et CI avec messages actionnables |

## Phase F01 : socle et bootstrap

### Inclus

- invariants et defaults ;
- profils opt-in ;
- templates stables et snapshots datés ;
- définition de done ;
- provenance et décisions ;
- commande de vérification ;
- initialiseur déterministe, atomique et sans écrasement ;
- tests structurels des quatre packs ;
- historique Git local et tag.

### Exclu

- modification des projets sources ;
- outil de mise à niveau automatique.

### Critère de sortie

- `./scripts/verify.sh` passe ;
- le dépôt est sur `main` avec un commit propre ;
- le tag `v0.1.0` pointe vers le commit vérifié.

### Maintenance compatible livrée en v0.2.0

- dépôt officiel et tags publiés ;
- catalogue exhaustif de tous les Markdown ;
- audiences documentaires explicites ;
- profil Nimbus opt-in ;
- protocole de contribution amont depuis un projet consommateur.

### Migration documentaire livrée en v0.3.0

- Nimbus obligatoire dans les quatre packs ;
- scaffold officiel et lockfile vendorisés ;
- adaptateur générique depuis `documentation.json` ;
- tests, typecheck, build, recherche et lint dans `verify` ;
- migration incompatible depuis `v0.2.0` documentée.

## Phase F02 : test d'adoption

### Objectif

Créer un dépôt jetable ou un vrai petit projet, suivre uniquement le bootstrap, puis corriger ce qui nécessite encore du contexte implicite.

### Critère de sortie

- le projet cloné reste autonome sans chemin vers ce dépôt ;
- les profils et dérogations sont traçables ;
- une autre session peut lancer et vérifier le projet.

## Règle de mise à jour

- Une phase passe à `done` uniquement avec son critère de sortie.
- Les constats courants vivent dans `STATUS.md`.
- Une modification structurelle de ce séquencement passe par ADR.
