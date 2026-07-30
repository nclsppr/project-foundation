# Bootstrap d'un nouveau projet

Objectif : passer d'une idée à un premier incrément exploitable, vérifiable et transmissible sans installer prématurément une architecture complète.

## Phase 0. Classifier le projet

Choisir une seule classe initiale :

| Classe | But | Exigence dominante |
| --- | --- | --- |
| Exploration | Répondre à une question | Temps limité et conclusion écrite |
| Prototype | Tester une expérience ou une faisabilité | Isolation et suppression facile |
| Produit | Servir de vrais utilisateurs | Qualité, exploitation et continuité |
| Critique | Porter argent, identité, données sensibles ou opération vitale | Sécurité, audit, restauration et gates renforcés |

Une exploration ne doit pas hériter de toute l'infrastructure d'un produit critique. Un prototype qui reçoit de vraies données doit être reclassé.

## Phase 1. Établir les faits

- [ ] Décrire le problème en une phrase.
- [ ] Nommer les utilisateurs et leur situation.
- [ ] Décrire le résultat observable attendu.
- [ ] Écrire les non-objectifs.
- [ ] Lister les contraintes connues et leur source.
- [ ] Identifier les données, secrets, paiements ou droits concernés.
- [ ] Séparer les faits des hypothèses.
- [ ] Définir ce qui ferait arrêter le projet.

Ne pas choisir la stack avant d'avoir suffisamment répondu à ces points.

## Phase 2. Poser le contrat du dépôt

Choisir le pack avant de copier :

| Classe | Pack | Fichiers requis |
| --- | --- | --- |
| Exploration | Minimal | `README.md`, `BRIEF.md`, `CHANGELOG.md`, `AGENTS.md`, `FOUNDATION.md` |
| Prototype | Standard | `README.md`, `PROJECT.md`, `STATUS.md`, `ROADMAP.md`, `CHANGELOG.md`, `AGENTS.md`, `FOUNDATION.md` |
| Produit | Full | Standard, ADR pour chaque décision structurante et `DESIGN.md` si interface |
| Critique | Critical | Full, `RUNBOOK.md`, preuve de livraison et profils risque |

Tous les packs ajoutent aussi `DOCUMENTATION.md`, `documentation.json`,
`DOCUMENTATION-CATALOG.md`, le scaffold `docs-nimbus/`, `compose.yaml`, la CI et
leurs contrôles. Nimbus et Docker Compose sont obligatoires, y compris pour une
exploration. Ces fichiers ne rendent pas tout le dépôt public : ils rendent
chaque Markdown classé et découvrable dans la bonne audience.

- [ ] Initialiser Git selon le default retenu ou la politique locale.
- [ ] Copier uniquement le pack choisi.
- [ ] Enregistrer ce pack dans `FOUNDATION.md` et la classe correspondante dans le brief ou `PROJECT.md`.
- [ ] Ajouter le stub `CLAUDE.md` uniquement si nécessaire.
- [ ] Choisir les profils durables que le projet doit savoir appliquer.
- [ ] Pour un projet critique, activer `backend-data` ou `infrastructure-production`.
- [ ] Définir la licence ou indiquer explicitement que le projet reste privé.
- [ ] Ajouter `.gitignore` et un exemple de configuration sans secret.
- [ ] Définir le propriétaire du projet.
- [ ] Copier le noyau et les profils retenus sous `docs/foundation/`.
- [ ] Classer les Markdown existants comme publics, internes, références ou archives.
- [ ] Vérifier que le profil obligatoire `documentation-nimbus` est activé.
- [ ] Vérifier que `compose.yaml`, `scripts/check_compose.py` et le workflow CI sont présents.

Supprimer les sections non applicables plutôt que remplir une longue série de `N/A`. À la fin de cette phase, aucun marqueur de saisie ne doit rester dans les fichiers copiés.

Les gates d'un profil durable ne s'appliquent qu'aux unités qui rencontrent son
déclencheur. Si une unité ultérieure exige un nouveau profil, le vendoriser
depuis le commit du socle épinglé et mettre à jour `FOUNDATION.md` dans la même
unité.

## Phase 3. Dessiner les sources de vérité

Pour un pack Standard ou supérieur, remplir dans `PROJECT.md` :

- [ ] vision et périmètre ;
- [ ] roadmap et ordre de livraison ;
- [ ] architecture ;
- [ ] contrat API ou schéma de données ;
- [ ] design system ;
- [ ] configuration d'environnement ;
- [ ] opérations ;
- [ ] décisions ;
- [ ] historique des changements livrés ;
- [ ] artefacts générés et leur source ;
- [ ] archives et expériences.
- [ ] collections documentaires et audiences.

Une case sans source est une décision à prendre, pas une invitation à dupliquer une information. Une exploration conserve cette carte dans son brief uniquement si elle sert la question testée.

Le contrat stable reste dans `PROJECT.md`. L'état réellement vérifié vit dans `STATUS.md`. L'ordre de livraison et les critères de sortie vivent dans `ROADMAP.md`.

Tous les nouveaux `.md` doivent rejoindre une collection de
`documentation.json`. Les rendus web restent dérivés des sources classées.
Enregistrer la version, la configuration et la commande de build Nimbus comme
sources de vérité locales.

## Phase 4. Prendre les premières décisions

À partir du pack Standard, une décision produit importante rejoint une ADR si
elle change durablement les utilisateurs servis, la promesse, le périmètre, une
règle métier ou une priorité structurante. Pour un pack Full ou Critical, créer
aussi une ADR pour chaque choix technique qui serait coûteux à changer :

- [ ] utilisateurs, promesse et contraintes produit structurantes ;
- [ ] règles métier, tarification ou droits importants ;
- [ ] forme du dépôt et découpage des modules ;
- [ ] stack et versions ;
- [ ] stockage et migrations ;
- [ ] authentification et frontières de données ;
- [ ] contrat public ;
- [ ] stratégie de déploiement ;
- [ ] dépendances externes ;
- [ ] approche de génération ou d'IA.

Chaque ADR contient une alternative plus simple et explique pourquoi elle ne suffit pas.
Le bootstrap crée le dossier `docs/decisions/`, pas une décision vide. Copier
`templates/ADR.md` uniquement lorsqu'une décision réelle peut être documentée.

## Phase 5. Rendre le projet reproductible

- [ ] Épingler les versions et committer les lockfiles.
- [ ] Documenter les prérequis.
- [ ] Déclarer dans `compose.yaml` chaque application et dépendance du parcours local intégré.
- [ ] Épingler chaque image externe par digest et construire localement uniquement depuis une source explicite.
- [ ] Ajouter un healthcheck à chaque service long ; étiqueter une commande finie avec `foundation.lifecycle=job`.
- [ ] Pour un pack Standard, Full ou Critical, remplacer la table `services` vide par au moins un service réel.
- [ ] Fournir une installation propre depuis un nouveau clone lorsqu'une installation est nécessaire.
- [ ] Fournir `verify` dans tous les cas, puis `dev`, `build`, `stop` et `reset` lorsqu'ils s'appliquent.
- [ ] Décrire les variables sans fournir leur valeur secrète.
- [ ] Vérifier l'environnement réellement vu par les processus lancés.
- [ ] Faire exécuter `verify` par la CI.
- [ ] Exécuter `python3 scripts/check_compose.py`, puis `docker compose up --build --wait` et les sondes applicables.
- [ ] Vérifier que `docker compose down` préserve les volumes et documenter séparément toute réinitialisation destructive.
- [ ] Installer Node `22.12.0` ou plus récent et npm pour le build Nimbus.
- [ ] Déclarer les plateformes réellement supportées.

Un guide qui ne peut pas être rejoué n'est pas terminé. Les actions sans objet sont supprimées du document au lieu de recevoir une fausse commande.

## Phase 6. Poser les garde-fous

- [ ] Activer les contrôles de format, lint et tests pertinents.
- [ ] Définir la matrice de validation manuelle.
- [ ] Ajouter une détection de secrets.
- [ ] Définir la politique de dépendances.
- [ ] Documenter les changements destructifs.
- [ ] Prévoir sauvegarde et restauration si des données persistent.
- [ ] Définir santé, logs et métriques si un service tourne.
- [ ] Définir les budgets d'accessibilité et de performance si une interface existe.

Les intégrations Codex ou Claude peuvent appeler ces garde-fous. Elles ne doivent pas en être l'unique implémentation.

## Phase 7. Livrer une tranche verticale

La première tranche doit traverser le système avec le moins de faux-semblants possible :

- [ ] une action utilisateur ou opérationnelle réelle ;
- [ ] le chemin de données minimal ;
- [ ] un état de succès et un état d'échec ;
- [ ] une preuve automatisée ;
- [ ] une vérification sur la surface finale ;
- [ ] la documentation mise à jour ;
- [ ] le changement ajouté à `CHANGELOG.md` ;
- [ ] aucun élément futur présenté comme livré.

Éviter de construire tous les socles techniques avant d'avoir prouvé un flux utile.

## Phase 8. Préparer la livraison

- [ ] Définir l'artefact immuable ou le SHA livré si une livraison existe.
- [ ] Séparer build, vérification et déploiement.
- [ ] Décrire le rollback.
- [ ] Déployer dans l'environnement cible si le projet possède une surface déployée.
- [ ] Vérifier santé, route, logs et parcours critique lorsqu'ils existent.
- [ ] Vérifier la publication ou l'URL finale si elle existe.
- [ ] Noter les validations impossibles ou externes.

## Phase 9. Fermer le bootstrap

- [ ] Exécuter les gates applicables de `docs/foundation/DEFINITION-OF-DONE.md`.
- [ ] Rechercher les marqueurs de saisie, exemples factices et chemins obsolètes.
- [ ] Vérifier les liens documentaires.
- [ ] Régénérer puis vérifier `DOCUMENTATION-CATALOG.md`.
- [ ] Inspecter le diff.
- [ ] Committer une unité cohérente.
- [ ] Pousser immédiatement sur la branche canonique si l'écriture directe est autorisée, sinon sur une branche dédiée, conformément à `P18`.
- [ ] Vérifier que le SHA existe sur le remote et observer les contrôles distants disponibles.
- [ ] Créer la prochaine tranche dans la roadmap, pas dans une liste concurrente.

Le bootstrap est fini lorsque quelqu'un d'autre peut comprendre, lancer, vérifier et reprendre le projet sans commande cachée.

Le snapshot du socle n'est jamais édité dans le projet consommateur. Une
exception locale vit dans `FOUNDATION.md`. Un challenge général se traite dans
le dépôt Project Foundation, puis revient dans le projet par une nouvelle
release selon [`ADOPTION.md`](ADOPTION.md).
