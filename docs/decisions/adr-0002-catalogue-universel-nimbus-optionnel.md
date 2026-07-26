# ADR-0002 : catalogue universel et Nimbus optionnel

- Statut : accepté
- Statut d'implémentation : livré
- Date : 2026-07-27
- Dernière vérification : 2026-07-27, catalogue et bootstrap vérifiés localement
- Propriétaire : Nicolas Pieper
- Remplace : aucune

## Contexte

Les projets doivent rendre tous leurs fichiers Markdown découvrables sans
confondre documentation publique, documentation interne, références et
archives. Surplasse utilise Nimbus avec succès, mais son adaptateur, son thème,
ses chemins de base et sa topologie de publication sont propres à ce produit.

Project Foundation doit rester utilisable depuis un nouveau clone avec Git,
Bash et Python. Ajouter Astro, Node et Nimbus au noyau transformerait un contrat
portable en toolchain web obligatoire.

## Problème à décider

Comment garantir qu'aucun Markdown n'est orphelin, tout en proposant Nimbus sans
l'imposer à chaque exploration ou service ?

## Options considérées

### Imposer Nimbus dans tous les projets

Avantage : navigation et rendu homogènes immédiatement.

Limites : dépendances lourdes pour les petits projets, publication interne mal
définie et couplage du socle à un moteur encore jeune.

### Ne fournir qu'une recommandation éditoriale

Avantage : aucun outil supplémentaire.

Limite : aucun contrôle ne détecte un nouveau Markdown orphelin ou publié dans
la mauvaise audience.

### Catalogue universel et profil Nimbus

Avantages : règle vérifiable sans runtime web, audiences explicites, Nimbus
disponible lorsque sa valeur est démontrée et sources indépendantes du moteur.

Limite : un projet qui publie doit encore configurer et maintenir son adaptateur
de rendu.

## Décision

Tous les projets adoptant le socle possèdent `documentation.json`,
`DOCUMENTATION.md` et un catalogue Markdown généré. La vérification refuse tout
Markdown maintenu qui n'appartient pas exactement à une collection.

Nimbus devient le default pour une documentation durable publiée, via
`profiles/documentation-nimbus.md`. Il n'est pas installé dans le runtime de
Project Foundation en `v0.2.0`.

Les Markdown restent la source éditoriale. Toute collection, navigation ou site
Nimbus est dérivé. Les audiences internes ne doivent jamais rejoindre une
sortie publique par défaut.

## Conséquences

### Positives

- chaque Markdown possède une place et une audience ;
- le contrôle fonctionne sans Node ni accès réseau ;
- Nimbus peut être adopté sans devenir une dépendance du noyau ;
- un changement de moteur ne déplace pas les sources éditoriales.

### Négatives

- le manifeste doit évoluer avec l'architecture documentaire ;
- le catalogue généré est un artefact supplémentaire à committer ;
- chaque intégration Nimbus garde un adaptateur local à tester.

## Vérification

- `python3 scripts/documentation_catalog.py --check` ;
- `./scripts/verify.sh` ;
- tests du bootstrap pour tous les packs ;
- build et revue de la surface finale dans les projets qui activent Nimbus.

## Réexamen

Réexaminer l'installation de Nimbus dans ce dépôt si Project Foundation publie
sa propre documentation, si plusieurs projets partagent réellement le même
adaptateur ou si le catalogue renderer-neutral ne suffit plus.
