# Changelog

Ce fichier décrit les versions du socle. Il reste historique et non normatif.

## Non publié

- Consigne la première adoption réelle : Parkventory utilise le snapshot
  `v0.4.0`, reste autonome depuis un clone public propre et passe sa gate CI au
  SHA `d9a50adb04ad1c7e038d7c672723c6dd4bba07d4`.
- Marque la phase F02 de test d'adoption `done` sans modifier les artefacts de
  la release `v0.4.0`.

## 0.4.0 - 2026-07-30

- Ajoute `P18`, invariant qui impose de committer puis pousser chaque tranche cohérente et vérifiée dès que la tâche autorise la modification du dépôt.
- Impose `main` comme cible directe lorsqu'elle est accessible, ou une branche dédiée lorsque la branche canonique est protégée ou soumise à revue.
- Empêche une dérogation locale de conserver silencieusement un travail terminé uniquement dans le worktree ou l'historique local.
- Aligne les adaptateurs `AGENTS.md`, la définition de done, le bootstrap, la preuve de livraison, l'adoption et le processus de release sur cette discipline.
- Ajoute un test de bootstrap qui vérifie la propagation de `P18` et de sa traduction opérationnelle dans tous les packs.
- Documente la décision dans l'ADR-0004 et la migration depuis `v0.3.1`.

## 0.3.1 - 2026-07-27

- Corrige les liens du guide Nimbus pour qu'ils restent valides dans un projet généré, sans dépendre de fichiers propres au dépôt Project Foundation.
- Ajoute le build, la recherche et le lint Nimbus d'un pack Product généré aux tests du bootstrap.
- Vérifie que le lockfile Nimbus copié reste strictement identique à celui de la release.
- Remplace `v0.3.0` comme version recommandée pour toute nouvelle adoption.

## 0.3.0 - 2026-07-27

- Rend Nimbus obligatoire dans tous les packs, y compris Minimal.
- Ajoute le scaffold officiel Nimbus `0.6.3`, `@cloudflare/nimbus-docs` `0.8.2` épinglé et son lockfile npm.
- Épingle `yaml` `2.9.0` pour fermer l'avis de sécurité présent dans la version du scaffold.
- Ajoute un adaptateur générique qui génère la collection Nimbus depuis les Markdown classés.
- Ajoute les tests de conversion, le typecheck, le build, Pagefind et le lint Nimbus à `verify` et à la CI.
- Active automatiquement `documentation-nimbus` pendant le bootstrap et interdit son retrait local.
- Remplace l'ADR-0002 par l'ADR-0003 et documente la migration incompatible depuis `v0.2.0`.
- Exige Node `22.12.0` ou plus récent et npm pour vérifier un projet adopté.
- Rend `CHANGELOG.md` obligatoire dans tous les packs et explicite la traçabilité des décisions produit importantes par ADR.

## 0.2.0 - 2026-07-27

- Ajout d'un contrat qui classe chaque Markdown maintenu comme public, interne, référence ou archive.
- Ajout d'un manifeste, d'un catalogue exhaustif et d'un contrôle des Markdown orphelins dans tous les packs.
- Ajout du profil Nimbus comme default opt-in pour une documentation durable publiée, sans dépendance web dans le noyau.
- Ajout d'une procédure d'adoption depuis le dépôt officiel et de mise à niveau par tag et SHA.
- Interdiction de modifier silencieusement le snapshot vendorisé : un challenge général passe par le Git Project Foundation et une nouvelle release.
- Publication publique du dépôt et de ses tags sur `nclsppr/project-foundation`, sans licence ajoutée par défaut.

## 0.1.0 - 2026-07-26

- Création des invariants, defaults et règles de bootstrap.
- Ajout de la définition de done par type de changement.
- Ajout des profils web, backend et données, infrastructure de production et expérience.
- Ajout des profils d'artefacts générés et de changement de dépendance.
- Ajout des templates projet, brief, statut, roadmap, agents, ADR, design, runbook et preuve de livraison.
- Ajout des packs Minimal, Standard, Full et Critical, avec initialiseur sûr.
- Ajout d'une vérification locale et CI du socle.
- Refus du bootstrap depuis un worktree sale et nettoyage des credentials de provenance.
- Vérification de la structure, des profils et des placeholders dans les projets générés.
- Ajout d'une version canonique contrôlée entre le dépôt, le changelog et le tag.
- Documentation de l'audit croisé de Surplasse, du site personnel, de Papers Empire et du runbook VPS.
