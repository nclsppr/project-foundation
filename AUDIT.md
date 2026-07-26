# Audit d'origine du socle

Snapshot réalisé le 2026-07-26 à partir de l'état local des projets `surplasse`, `personal`, `papersempire` et `vps`, avec la configuration `Developer/.claude` comme évidence auxiliaire.

Ce fichier explique la synthèse. Il n'est pas une source normative et ne remplace pas la relecture des dépôts.

## Méthode

L'audit a croisé :

- les `AGENTS.md`, `CLAUDE.md`, README et systèmes de design ;
- les ADR, roadmaps, documents d'architecture, développement et opérations ;
- les scripts, hooks, commandes de package et workflows CI ;
- l'état Git et les fichiers réellement présents ;
- les runbooks et règles de production ;
- les différences entre ce qui est écrit, automatisé et actuellement exécutable.

Les changelogs et audits datés ont été utilisés comme historique, jamais comme norme actuelle.

## Manifeste des snapshots

| Zone locale | Branche ou statut | Révision | État au moment de l'audit | Sources principales |
| --- | --- | --- | --- | --- |
| `surplasse/` | `main` | `fab494ad2940f9ee46bf9a186ec7fb2735185367` | 6 entrées de worktree, principalement non suivies, dont le `AGENTS.md` racine obsolète | `docs/AGENTS.md`, `CLAUDE.md`, README, ADR, produit, architecture, développement, opérations, scripts et workflows |
| `personal/` | `codex/design-review-evolution` | `3a040e8c2a099e4a0647c7f27aeb8e080de09d97` | propre | `AGENTS.md`, `DESIGN.md`, README, infos, scripts, hooks et changelog |
| `papersempire/` | `master` | `0591dea0ad7ec53c27eaa3965ccb8de642b6d16b` | propre | README, `docs/`, package, tree réel et workflow |
| `vps/` | hors Git | SHA-256 `b641843c9ba39b4471dd5a35bcbc9dbc9194142e0149873610c6e405cfda7f97` | `VPS-SETUP.md`, mtime `2026-07-15T11:14:12+0200` | runbook complet |
| `Developer/.claude/` | hors Git, évidence auxiliaire | `settings.json` SHA-256 `da59b3240683c662c57ab59717e0e6910810e7967053babb7c335d193acb9cfb`, `settings.local.json` SHA-256 `502ec9ca623a1bd044a97e842113f3f6da30c06ba693d055a2c61d270ccd5199` | mtimes `2026-07-18T05:28:20+0200` et `2026-07-16T00:19:16+0200` | hooks et permissions propres à Claude |

Les états Git et dates restent historiques. Ils doivent être revérifiés avant toute correction dans les dépôts sources.

## Règles récurrentes retenues

Les quatre zones convergent sur :

1. comprendre le produit et le contexte avant la stack ;
2. ne rien inventer et signaler l'incertitude ;
3. identifier une source de vérité par concept ;
4. documenter les choix structurants ;
5. préserver les changements sans rapport ;
6. vérifier une unité de travail avant de la livrer ;
7. rendre les commandes reproductibles ;
8. garder les secrets hors Git et hors sortie ;
9. prévoir rollback, sauvegarde et restauration ;
10. valider la surface finale, pas seulement le code ;
11. traiter accessibilité, performance et résilience comme des contraintes produit ;
12. isoler les expériences et documenter leur retrait ;
13. committer les sources et dérivés atomiquement ;
14. rester proche de l'environnement de production.

## Choix volontairement non promus en invariants

Les règles suivantes peuvent être des defaults personnels ou des profils, mais ne sont pas des invariants :

- branche `main` ou `master`, direct push ou pull request ;
- langue de la documentation et convention de commit ;
- interdiction des tirets longs ;
- architecture statique, React, Quarkus, PostgreSQL, Docker ou Caddy ;
- Retype, Nimbus, GitHub Pages ou Infomaniak ;
- nombre de langues et stratégie i18n ;
- détails de marque, palettes, polices et iconographie ;
- absence ou présence d'une suite automatisée particulière ;
- chemins, ports, domaines et réseaux du VPS ;
- politique de publication automatique d'un dépôt précis.

Le socle en conserve la forme de décision, pas la valeur contextuelle.

## Dérives observées

### Duplication des règles

Dans `surplasse`, les règles sont répétées entre `AGENTS.md`, `CLAUDE.md` et `docs/AGENTS.md`. Elles ont dérivé sur la phase produit, le moteur documentaire et les commandes.

Dans `personal`, vérité du contenu, parité, génération d'artefacts et publication sont répétées entre README, `AGENTS.md`, `DESIGN.md` et le playbook d'article.

**Enseignement.** Une règle doit avoir une source unique. Les fichiers compatibles avec un outil restent des pointeurs minces.

### Documentation différente de l'exécutable

Dans `papersempire`, plusieurs documents affirment à la fois la présence et l'absence de tests. Le tree actuel ne contient pas le dossier de tests décrit et `package.json` n'expose plus les commandes annoncées. Le nom et les numéros de version divergent aussi entre plusieurs fichiers.

Dans `surplasse`, un document racine décrit encore un projet sans code et un ancien moteur documentaire, alors que le dépôt et les ADR montrent un état plus récent.

**Enseignement.** L'intention documentaire et l'état opérationnel sont deux vérités différentes. Un écart doit être audité puis corrigé explicitement.

Le template du socle sépare donc `PROJECT.md`, contrat relativement stable, de `STATUS.md`, snapshot daté, et de `ROADMAP.md`, autorité de séquencement.

### Contrôles propres à un agent présentés comme protections générales

Dans `personal`, les « hooks git » sont en réalité des hooks Claude `PreToolUse`. Ils ne protègent ni un terminal externe, ni Codex, ni une GUI Git, ni la CI. Certains contrôles couvrent aussi un périmètre plus étroit que la règle écrite.

La configuration globale sous `Developer/.claude` lance des contrôles propres à un projet lors d'actions sur d'autres projets.

**Enseignement.** Les règles critiques vivent dans une commande neutre et dans la CI. Les hooks d'agent restent des raccourcis locaux et scope-aware.

### Recettes copiées

Dans `personal`, la recette PDF est décrite manuellement dans le README alors qu'un script canonique existe déjà. Les deux ont divergé.

**Enseignement.** La documentation explique l'intention et appelle une commande. Le script porte les détails exécutables.

### Runbook historique pris pour état courant

Le runbook `vps/VPS-SETUP.md` décrit une cible Papers Empire différente du dépôt et du déploiement actuels. Il contient aussi des tensions entre interdiction d'afficher des secrets et copie d'une clé privée, entre protection des sauvegardes et politique de rétention, et entre prudence destructive et `rsync --delete`.

**Enseignement.** Un runbook doit porter un statut, une date de dernière vérification et des checkpoints. Une cible future ne doit pas être présentée comme le système courant.

### Plugins de design en conflit avec le projet

Des skills UI installées sous un dépôt peuvent imposer un vocabulaire visuel, une bibliothèque d'icônes ou une motion incompatible avec son design system.

**Enseignement.** Les skills et plugins conseillent. Le design system et les contraintes locales du projet décident.

## Index d'évidence ciblé

Les lignes ci-dessous se lisent dans les snapshots indiqués par le manifeste :

| Constat | Évidence |
| --- | --- |
| Surplasse racine obsolète | `surplasse/AGENTS.md:3,7,17-21`, fichier non suivi ; état plus récent dans `surplasse/CLAUDE.md:3` et remplacement documentaire dans `surplasse/docs/decisions/adr-0038-nimbus-documentation-canonique.md:31-50` |
| Surplasse, source et dérivés | `surplasse/docs/AGENTS.md:301-311` |
| Papers Empire, tests contradictoires | `papersempire/docs/AGENTS.md:32-33`, `papersempire/docs/DOCUMENTATION.md:29-39,75-78`, `papersempire/docs/accessibility.md:23-26`, `papersempire/package.json:5-10` |
| Papers Empire, versions divergentes | `papersempire/package.json:2-3`, `papersempire/retype.yml:10-12`, `papersempire/docs/RELEASE_NOTES.md:3-23`, `papersempire/docs/README.md:24-35` |
| Site personnel, hooks propres à Claude | `personal/.claude/settings.json:2`, `personal/.claude/hooks/check-i18n-parity.py:12,49-56` |
| Site personnel, règle PDF et contrôle différents | `personal/AGENTS.md:47`, `personal/scripts/generate-cv-pdf.sh:51`, `personal/.claude/hooks/check-cv-pdf.py:64` |
| VPS, secret affiché puis interdit | `vps/VPS-SETUP.md:370-377,513-516` |
| VPS, rétention et règle de sauvegarde en tension | `vps/VPS-SETUP.md:462-474,507-509` |
| VPS, synchronisation destructive sans release atomique | `vps/VPS-SETUP.md:395-404,506-516` |
| Configuration d'agent globale trop couplée | `Developer/.claude/settings.json:2-13`, `Developer/.claude/settings.local.json:14-33` |

## Décision d'emplacement

`vps/ai` n'a pas été retenu :

- `vps` n'est pas un dépôt Git ;
- il contient un runbook d'infrastructure spécifique ;
- le runbook désigne déjà un autre dépôt comme source canonique du serveur ;
- les règles multi-projets doivent rester utilisables hors du VPS.

Le socle vit donc dans `project-foundation`, dépôt autonome et agent-neutral. Les règles VPS sont regroupées dans `profiles/infrastructure-production.md`.

## Limites

Cet audit ne corrige pas les dérives trouvées dans les projets sources. Elles doivent être traitées dépôt par dépôt, avec leur propre validation et sans mélanger leurs worktrees.
