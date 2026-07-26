# ROADMAP.md

Source canonique de l'ordre de livraison. Une liste de fonctionnalités ou une priorité MoSCoW décrit l'importance intrinsèque, pas le séquencement.

## Résultat produit

TODO Décrire la destination sans la présenter comme livrée.

## Principes de séquencement

- Chaque phase produit une capacité observable.
- Une dépendance vient avant ce qui en dépend.
- Une phase nomme ses exclusions pour éviter l'expansion silencieuse.
- Un critère de sortie est une preuve, pas une impression d'avancement.
- Une phase terminée reste dans l'historique.
- L'état courant détaillé vit dans `STATUS.md`.

## Vue d'ensemble

| Ordre | ID | Phase | Résultat utilisateur ou opérationnel | État macro | Critère de sortie | Preuve observée | Sortie le |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | F01 | TODO | TODO | planned | TODO | vide tant que non prouvé | |

États autorisés : `planned`, `in_progress`, `blocked`, `done`, `cancelled`.

## Phase F01 : TODO

### Objectif

TODO

### Dépendances

- TODO

### Inclus

- TODO

### Exclu

- TODO

### Risques

- TODO

### Critère de sortie

- TODO preuve observable, environnement et résultat attendu

### Retour arrière ou abandon

- TODO

## Règle de mise à jour

- Mettre à jour l'état d'une phase uniquement avec sa preuve.
- Reporter les détails d'exécution et blocages courants dans `STATUS.md`.
- Créer une ADR si le séquencement change à cause d'une décision structurante.
- Ne pas créer une seconde roadmap dans un outil, un README ou un changelog.
