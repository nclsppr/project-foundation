# Profil documentation Nimbus

Activer ce profil lorsqu'un projet durable veut transformer ses Markdown
classés en documentation navigable, recherchable, publiable ou consommable par
des agents.

## Nature du profil

- **Norme opt-in.** Ce profil opérationnalise `P03`, `P04`, `P09`, `P10`, `P13`, `P14` et `P16`.
- **Default d'implémentation.** Nimbus est le moteur recommandé actuellement, pas un invariant du socle.
- **Source unique.** Les Markdown classés par `documentation.json` restent éditoriaux. La collection Nimbus est générée et ignorée par Git.

## Installation

- Installer Nimbus dans un dossier ou package dédié au rendu documentaire.
- Épingler `@cloudflare/nimbus-docs` et ses dépendances avec un lockfile.
- Enregistrer la version, le dossier de configuration et la commande canonique dans `PROJECT.md`.
- Créer une ADR si Nimbus devient une surface publiée ou une dépendance durable de CI.
- Ne pas copier sans examen l'adaptateur d'un autre projet : front matter, callouts, liens et index sont des contrats locaux.

## Collections et audiences

- Consommer `documentation.json` ou un adaptateur déterministe issu de ce manifeste.
- Publier uniquement les collections marquées `public`.
- Garder les collections `internal`, secrets, runbooks sensibles et preuves privées hors du build public.
- Intégrer les collections `reference` seulement si leur audience et leur stabilité le permettent.
- Conserver les archives identifiables comme historiques et non courantes.

## Source et dérivés

- Ne jamais modifier la collection générée par Nimbus.
- Tester toute conversion de front matter, lien, ancre, callout ou index.
- Régénérer depuis les sources avant typecheck, build et lint.
- Ignorer dans Git la collection et le site générés, sauf décision contraire motivée.
- Livrer ensemble source, adaptateur, configuration et changement de navigation.

## Vérification

La commande documentaire canonique doit au minimum exécuter :

1. la vérification du catalogue exhaustif ;
2. les tests de l'adaptateur ;
3. le typecheck du site ;
4. le build statique ;
5. l'indexation ou la recherche ;
6. le lint Nimbus ;
7. une revue navigateur des audiences et routes concernées.

Une sortie locale ne prouve pas la publication. Vérifier séparément l'URL, le
chemin de base, l'indexation et les variantes Markdown ou `llms.txt` réellement
livrées.

## Mise à jour ou retrait

- Lire les changements amont et vérifier `nimbus-docs outdated` depuis le package Nimbus.
- Mettre à jour version et lockfile dans une unité isolée.
- Rejouer l'adaptateur, le build complet et la revue des routes.
- Conserver un rollback vers le dernier artefact ou commit vérifié.
- Pour retirer Nimbus, supprimer runtime, workflows, images et routes actives sans laisser de fallback caché ; les Markdown et `documentation.json` restent canoniques.

## Gate minimale

- chaque Markdown maintenu est classé exactement une fois ;
- aucune collection interne n'entre dans la sortie publique ;
- version et lockfile Nimbus sont épinglés ;
- collection générée absente de Git ;
- adaptateur testé ;
- build, recherche et lint verts ;
- navigation et routes finales vérifiées ;
- limites de publication explicitement consignées.
