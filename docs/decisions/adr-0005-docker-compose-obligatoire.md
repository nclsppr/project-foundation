# ADR-0005 : Docker Compose obligatoire pour l'environnement local

- Statut : accepté
- Statut d'implémentation : livré
- Date : 2026-07-30
- Dernière vérification : 2026-07-30, contrôle Compose, câblage CI et tests des quatre packs
- Propriétaire : Nicolas Pieper
- Remplace : aucune
- Remplacé par : aucune

## Contexte

`P09` exigeait une exécution reproductible, mais Project Foundation ne fixait
aucun contrat commun pour lancer ensemble une application et ses dépendances.
Un projet pouvait documenter plusieurs commandes hôte, lancer seulement sa base
avec Compose, ou laisser sa CI ignorer totalement l'environnement intégré.

Cette faille est apparue dans Parkventory : PostgreSQL était déclaré dans
`compose.yaml`, tandis que Quarkus et Vite restaient des processus hôte. Le
parcours fonctionnait, sans pourtant prouver qu'une autre machine lançait le
même graphe de services.

## Problème à décider

Comment imposer un parcours local intégré, portable et contrôlable par la CI,
sans imposer une stack applicative ni interdire une boucle de développement
plus rapide sur l'hôte ?

## Options considérées

### Laisser chaque projet choisir son orchestrateur

Avantage : liberté maximale selon la stack.

Limite : aucune commande universelle ne prouve le graphe réellement requis et
les dépendances peuvent rester implicites.

### Recommander Docker Compose comme default

Avantage : adoption progressive et peu contraignante.

Limite : un default peut être révoqué. Il ne ferme donc ni le fichier absent,
ni le service lancé hors Compose, ni la CI qui ignore la configuration.

### Imposer Docker Compose comme invariant contrôlé

Avantages : même contrat de configuration pour chaque projet ; chemin intégré
commun ; images, états de santé et arrêt vérifiables ; raccourcis hôte toujours
possibles pour une boucle interne.

Limites : Docker devient un prérequis de vérification et chaque nouveau service
doit être ajouté au graphe Compose.

## Décision

La règle canonique est `P19` dans `PRINCIPLES.md`. Chaque projet versionne un
`compose.yaml` à sa racine. Docker Compose est le parcours canonique pour lancer
ensemble les applications et dépendances nécessaires au développement local.

Le bootstrap copie systématiquement :

- `compose.yaml` ;
- `scripts/check_compose.py` ;
- `.github/workflows/verify.yml` ;
- l'appel au contrôle Compose depuis `scripts/verify.sh`.

Le workflow appelle aussi le checker directement avant `verify`. Le checker
documentaire refuse la disparition de l'un ou l'autre appel afin de détecter un
contournement accidentel du câblage.

Un pack Minimal peut garder `services: {}` tant qu'il ne lance aucun processus
local. Les packs Standard, Full et Critical doivent déclarer au moins un
service. Les images externes sont épinglées par digest. Les services longs ont
un healthcheck ; les commandes finies sans healthcheck portent le label
`foundation.lifecycle=job`.

Une commande hôte reste autorisée comme raccourci, pas comme seul chemin
intégré. Une dérogation locale ne peut retirer ni le fichier, ni le checker, ni
la gate. Une plateforme sans Docker peut bloquer l'exécution, mais le contrat et
le contrôle CI restent versionnés.

## Conséquences

### Positives

- un nouveau clone découvre le graphe local dans un fichier standard ;
- `verify` refuse un projet durable sans service réel ;
- les images mutables et services sans signal de santé sont détectés ;
- la CI générée exécute le même contrôle que le développeur ;
- les commandes d'arrêt et de diagnostic deviennent communes aux stacks.

### Négatives

- Docker Compose `2.20.0` ou plus récent devient obligatoire pour `verify` ;
- un bootstrap Standard ou supérieur reste volontairement rouge tant que son
  premier service réel n'a pas remplacé la table vide ;
- le checker ne peut pas deviner un processus non documenté hors Compose : la
  revue doit toujours comparer l'architecture et le graphe déclaré ;
- une protection réellement indépendante exige aussi un check CI requis et une
  politique de branche dans le dépôt consommateur.

## Mise en oeuvre

1. Ajouter `P19` et ses gates à la définition de done.
2. Ajouter le checker générique et un service fini pour vérifier le socle.
3. Générer Compose et la CI dans les quatre packs.
4. Rendre ces fichiers obligatoires dans le checker Markdown du consommateur.
5. Tester le pack Minimal vide, le refus d'un pack Full vide, les digests, les
   healthchecks, la suppression des garde-fous et le retrait des appels de gate.
6. Faire adopter la nouvelle release par Parkventory et placer son parcours
   Quarkus, Vite et PostgreSQL sous Compose.

## Vérification

- `python3 scripts/check_compose.py` passe sur Project Foundation ;
- `docker compose run --rm documentation-check` passe ;
- `./scripts/verify.sh` passe ;
- les quatre arbres générés contiennent Compose, le checker et la CI ;
- les cas de contournement du bootstrap échouent avec un message actionnable ;
- le commit de release et son tag sont publiés puis contrôlés par la CI.

## Réexamen

Réexaminer si Docker Compose cesse d'être disponible sur une plateforme
réellement supportée ou si plusieurs projets démontrent une incapacité
structurelle à représenter leur parcours local. Le réexamen doit conserver un
contrat exécutable commun et une gate indépendante des outils d'agent.
