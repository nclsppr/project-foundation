# Adopter et faire évoluer Project Foundation

Ce document décrit comment un projet consomme une release sans créer une
dépendance runtime ni une copie locale divergente.

Le mode d'inclusion recommandé est un snapshot vendorisé et commité avec le
projet consommateur. Ce n'est ni un submodule, ni un symlink, ni une dépendance
runtime : le projet reste complet après un clone et chaque montée de version
produit un diff explicite.

## Source officielle

- Dépôt : `https://github.com/nclsppr/project-foundation.git`
- Release courante : `v0.3.1`
- Référence immuable : le SHA complet enregistré dans `FOUNDATION.md`

Toujours adopter un tag et son commit, jamais l'état flottant de `main`.

## Nouveau projet

```bash
git clone --branch v0.3.1 --depth 1 \
  https://github.com/nclsppr/project-foundation.git \
  /tmp/project-foundation-v0.3.1

/tmp/project-foundation-v0.3.1/scripts/bootstrap.sh \
  --target /chemin/absolu/vers/le-nouveau-projet \
  --class product \
  --profiles web
```

Le bootstrap ne crée pas le dépôt Git du projet, n'écrase rien et enregistre la
source, le tag et le commit du socle dans `FOUNDATION.md`.

Nimbus et `documentation-nimbus` sont toujours inclus. `--profiles` ne choisit
que les profils supplémentaires.

## Projet existant

Le bootstrap exige une cible inexistante. Pour un dépôt existant :

1. générer le pack dans un dossier temporaire voisin ;
2. inspecter les collisions avec les sources canoniques existantes ;
3. copier le snapshot `docs/foundation/` sans le modifier ;
4. fusionner les adaptateurs locaux et contrats documentaires, sans remplacer aveuglément les règles du projet ;
5. remplir `FOUNDATION.md`, les dérogations et les sources locales ;
6. régénérer le catalogue documentaire ;
7. lancer la vérification du projet ;
8. committer l'adoption comme une unité réversible.

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
4. relire et committer une unité cohérente ;
5. publier une nouvelle version selon `VERSIONING.md` ;
6. mettre ensuite à niveau le projet consommateur vers ce tag et ce SHA.

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
