# ADR-0003 : Nimbus obligatoire

- Statut : accepté
- Statut d'implémentation : livré
- Date : 2026-07-27
- Dernière vérification : 2026-07-27, quatre packs, 44 Markdown, 49 pages Nimbus, routes et recherche vérifiés localement
- Propriétaire : Nicolas Pieper
- Remplace : ADR-0002
- Remplacé par : aucune

## Contexte

L'ADR-0002 rendait obligatoire le catalogue exhaustif mais gardait Nimbus
optionnel. Cette séparation conservait un bootstrap léger, au prix de plusieurs
moteurs documentaires possibles et d'une intégration Nimbus à refaire dans
chaque projet.

Le propriétaire du socle demande désormais que Nimbus soit la surface
documentaire commune de tous les projets. L'inventaire des Markdown, leurs
audiences et leur source éditoriale unique restent nécessaires.

## Problème à décider

Comment imposer Nimbus sans publier accidentellement des documents internes et
sans rendre le bootstrap dépendant du réseau ?

## Options considérées

### Garder Nimbus optionnel

Avantage : aucune dépendance Node pour les petits projets.

Limite : expérience documentaire variable et intégration reportée à chaque
projet.

### Télécharger Nimbus pendant chaque bootstrap

Avantage : scaffold toujours récupéré depuis l'amont.

Limites : bootstrap dépendant du réseau et résultat susceptible de dériver si
le générateur ou son template change.

### Vendoriser le scaffold officiel dans le socle

Avantages : bootstrap hors ligne, version et lockfile identiques, diff de mise à
niveau relisible et build réellement vérifiable dans le socle comme dans chaque
projet.

Limites : Node devient obligatoire et le snapshot Nimbus augmente la taille du
socle.

## Décision

Nimbus est un invariant de Project Foundation. Tous les packs activent
automatiquement `documentation-nimbus` et embarquent le scaffold officiel
Nimbus suivi par `nimbus.json`.

La version minimale de Node est `22.12.0`. `@cloudflare/nimbus-docs` est épinglé
à `0.8.2` et le lockfile est versionné. La commande `verify` exécute les tests de
l'adaptateur, le typecheck, le build et le lint Nimbus.

Les Markdown classés par `documentation.json` restent les seules sources
éditoriales. La collection `docs-nimbus/src/content/docs/` est régénérée et
ignorée par Git.

Le build local contient toutes les audiences pour rendre le corpus navigable.
Il ne constitue pas une autorisation de publication. Toute publication doit
définir explicitement les collections autorisées et prouver qu'aucun contenu
interne n'est exposé.

Un autre moteur peut compléter Nimbus pour un besoin local, mais ne peut pas le
remplacer sans une nouvelle version du socle qui remplace cette ADR.

## Conséquences

### Positives

- tous les projets partagent le même moteur documentaire ;
- un nouveau projet reçoit un scaffold et un lockfile vérifiables hors ligne ;
- les dérives de build Nimbus bloquent `verify` ;
- les sources restent indépendantes de la collection générée.

### Négatives

- Node et npm deviennent des prérequis universels ;
- même une exploration porte un site documentaire ;
- les mises à jour du starter Nimbus doivent être relues et redistribuées ;
- une publication exige un filtre d'audience distinct du build local complet.

## Mise en oeuvre

1. Embarquer le scaffold officiel `@cloudflare/create-nimbus-docs` `0.6.3`.
2. Épingler Nimbus et committer le lockfile.
3. Générer la collection depuis `documentation.json`.
4. Activer automatiquement le profil dans tous les packs.
5. Ajouter le build Nimbus aux vérifications locales et CI.
6. Documenter la migration depuis `v0.2.0`.

## Vérification

- catalogue sans Markdown orphelin ou dupliqué ;
- profil Nimbus présent dans les quatre packs ;
- tests de conversion verts ;
- typecheck, build et lint Nimbus verts ;
- collection générée absente de Git ;
- CI de la branche et du tag verte.

## Réexamen

Remplacer cette décision uniquement si Nimbus n'est plus maintenu, ne supporte
plus les exigences d'audience ou si son coût est démontré comme
disproportionné dans plusieurs projets.
