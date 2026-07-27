# Changelog

Ce fichier décrit les versions du socle. Il reste historique et non normatif.

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
