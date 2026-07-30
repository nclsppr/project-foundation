# Adopter et faire évoluer Project Foundation

Ce document décrit comment un projet consomme une release sans créer une
dépendance runtime ni une copie locale divergente.

Le mode d'inclusion recommandé est un snapshot vendorisé et commité avec le
projet consommateur. Ce n'est ni un submodule, ni un symlink, ni une dépendance
runtime : le projet reste complet après un clone et chaque montée de version
produit un diff explicite.

## Source officielle

- Dépôt : `https://github.com/nclsppr/project-foundation.git`
- Release courante : `v0.5.2`
- Référence immuable : le SHA complet enregistré dans `FOUNDATION.md`

Toujours adopter un tag et son commit, jamais l'état flottant de `main`.

## Nouveau projet

```bash
git clone --branch v0.5.2 --depth 1 \
  https://github.com/nclsppr/project-foundation.git \
  /tmp/project-foundation-v0.5.2

/tmp/project-foundation-v0.5.2/scripts/bootstrap.sh \
  --target /chemin/absolu/vers/le-nouveau-projet \
  --class product \
  --profiles web
```

Le bootstrap ne crée pas le dépôt Git du projet, n'écrase rien et enregistre la
source, le tag et le commit du socle dans `FOUNDATION.md`.

Nimbus, `documentation-nimbus`, `compose.yaml`, le checker Compose et la CI sont
toujours inclus. `--profiles` ne choisit que les profils supplémentaires.

## Projet existant

Le bootstrap exige une cible inexistante. Pour un dépôt existant :

1. générer le pack dans un dossier temporaire voisin ;
2. inspecter les collisions avec les sources canoniques existantes ;
3. copier le snapshot `docs/foundation/` sans le modifier ;
4. fusionner les adaptateurs locaux et contrats documentaires, sans remplacer aveuglément les règles du projet ;
5. remplir `FOUNDATION.md`, les dérogations et les sources locales ;
6. régénérer le catalogue documentaire ;
7. lancer la vérification du projet ;
8. committer l'adoption comme une unité réversible ;
9. pousser immédiatement sur la branche canonique si l'écriture directe est autorisée, sinon sur une branche dédiée.

## Exception locale ou challenge du socle

Une règle inadaptée peut suivre deux chemins.

### Le besoin est propre au projet

Documenter une dérogation limitée dans `FOUNDATION.md`, avec raison, contrôle
compensatoire, propriétaire et date de réexamen. Ne pas modifier le snapshot.

### Le problème est général

Modifier le dépôt Project Foundation lui-même :

1. créer une branche ou un worktree depuis le dépôt officiel ;
2. modifier la source canonique, ses templates, contrôles et tests ;
3. exécuter `./scripts/verify.sh` ;
4. relire, vérifier et committer une unité cohérente ;
5. pousser le commit selon `P18` ;
6. publier une nouvelle version selon `VERSIONING.md` ;
7. mettre ensuite à niveau le projet consommateur vers ce tag et ce SHA.

Une modification directe de `docs/foundation/` est interdite : elle serait
écrasée à la prochaine mise à niveau et masquerait le débat aux autres projets.

## Mettre à niveau

1. Lire `CHANGELOG.md` entre les deux tags.
2. Remplacer le snapshot depuis le nouveau commit.
3. Examiner le diff des invariants, defaults, profils et gates.
4. Réconcilier les dérogations locales.
5. Comparer les nouvelles baselines des scripts avec les adaptations locales.
6. Régénérer le catalogue documentaire.
7. Vérifier et committer snapshot, provenance et adaptations ensemble.
8. Pousser immédiatement sur la branche canonique si l'écriture directe est autorisée, sinon sur une branche dédiée.

Une future commande de mise à niveau pourra préparer ce diff. Elle ne devra
jamais écraser silencieusement une dérogation ou une gate locale.

### Migration de v0.2.0 vers v0.3.1

Cette montée de version est incompatible sans adaptation :

1. installer Node `22.12.0` ou plus récent et npm dans les environnements local et CI ;
2. copier `docs-nimbus/`, son lockfile et le profil obligatoire depuis `v0.3.1` ;
3. ajouter `CHANGELOG.md` depuis le template si le projet n'en possède pas ;
4. fusionner les nouvelles baselines de `scripts/check_markdown.py` et `scripts/verify.sh` ;
5. déclarer `documentation-nimbus` dans `FOUNDATION.md` ;
6. définir les variables Nimbus uniquement si les valeurs locales par défaut ne conviennent pas ;
7. exécuter `./scripts/verify.sh` avant de publier la montée de version.

### Migration de v0.3.0 vers v0.3.1

`v0.3.0` construit correctement le dépôt du socle mais son guide Nimbus contient
deux liens non portables qui font échouer le lint d'un pack généré. Remplacer le
scaffold et les scripts de vérification depuis `v0.3.1`, puis rejouer
`./scripts/verify.sh`.

### Migration de v0.3.1 vers v0.4.0

Cette version ajoute l'invariant `P18` :

1. remplacer `PRINCIPLES.md`, `DEFAULTS.md` et `DEFINITION-OF-DONE.md` depuis `v0.4.0` ;
2. fusionner la nouvelle baseline de l'adaptateur `AGENTS.md` ;
3. expliciter dans `PROJECT.md` la branche canonique et le choix entre push direct et branche avec revue ;
4. conserver les gates applicatives locales puis exécuter `./scripts/verify.sh` ;
5. committer snapshot, provenance et adaptations dans une unité ;
6. pousser cette unité conformément à `P18` et vérifier son SHA distant.

Une dérogation locale ne peut pas annuler `P18`. Une tâche explicitement en
lecture seule ou limitée au local, une interdiction supérieure, l'absence de
remote ou un blocage externe documenté restent les seules exceptions.

### Migration de v0.4.0 vers v0.5.0

Cette version ajoute l'invariant `P19` et un prérequis Docker Compose :

1. installer Docker et Docker Compose `2.20.0` ou plus récent en local et en CI ;
2. remplacer `PRINCIPLES.md`, `DEFAULTS.md` et `DEFINITION-OF-DONE.md` depuis `v0.5.0` ;
3. ajouter ou fusionner `compose.yaml` à la racine ;
4. copier `scripts/check_compose.py` et appeler ce checker depuis `scripts/verify.sh` ;
5. fusionner la baseline `.github/workflows/verify.yml` sans perdre les gates applicatives locales ;
6. placer dans Compose chaque application et dépendance requise par le parcours local intégré ;
7. épingler les images externes par digest, ajouter les healthchecks et étiqueter les commandes finies ;
8. exécuter `python3 scripts/check_compose.py`, le parcours `docker compose up --build --wait`, puis `./scripts/verify.sh` ;
9. committer et pousser snapshot, provenance, Compose, CI et adaptations dans une seule unité.

Une dérogation locale ne peut retirer `compose.yaml`, son checker ou sa gate.
Un check réellement indépendant du contenu du dépôt exige en complément que la
plateforme rende le workflow de vérification obligatoire sur la branche.

### Migration de v0.5.0 vers v0.5.1

Cette correction concerne le `compose.yaml` du dépôt Project Foundation : les
sources sont montées en lecture seule et les contrôles s'exécutent dans un
workspace anonyme. Les projets générés ne possèdent pas ce service documentaire et
ne nécessitent aucune adaptation supplémentaire. Toute nouvelle adoption doit
néanmoins viser `v0.5.1` afin de partir de la release dont les runs main et tag
peuvent être vérifiés sans conflit de permissions.

### Migration de v0.5.1 vers v0.5.2

Cette correction durcit le câblage de la gate Compose. Fusionner les nouvelles
baselines de `scripts/check_markdown.py` et `.github/workflows/verify.yml` : le
workflow appelle désormais `scripts/check_compose.py` directement avant la gate
projet, et le checker documentaire refuse le retrait de cet appel ou de celui
présent dans `scripts/verify.sh`. Le contrôle reste versionné avec le dépôt ; une
racine de confiance indépendante exige toujours de rendre ce workflow requis
dans les règles GitHub du projet consommateur.
