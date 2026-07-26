# AGENTS.md

Règles de maintenance de ce socle. Lire d'abord `README.md`, puis `PRINCIPLES.md`.

## Source canonique

- Une règle universelle vit dans `PRINCIPLES.md`.
- Un choix révocable vit dans `DEFAULTS.md`.
- Une exigence liée à un contexte vit dans `profiles/`.
- Les fichiers sous `templates/` montrent comment référencer ces règles depuis un projet.
- `DOCUMENTATION.md` et `documentation.json` définissent le classement et l'audience de tous les Markdown.
- `AUDIT.md` explique l'origine des choix, mais reste un snapshot historique non normatif.
- `CLAUDE.md` est un adaptateur. Il ne duplique aucune règle.

## Règles d'intervention

- Ne jamais inventer une source, un état de dépôt ou une validation.
- Préserver la séparation entre invariants, defaults et profils.
- Ne pas introduire dans le noyau une stack, une marque, un hébergeur, une langue produit ou un workflow Git propre à un seul projet.
- Une règle doit indiquer sa raison, sa preuve minimale et son mécanisme d'exception.
- Une idée normative ne doit être définie qu'à un seul endroit. Les autres fichiers la référencent ou la traduisent en contrôle sans créer une seconde règle.
- Les commandes détaillées vivent dans un script canonique quand elles sont exécutables. La documentation indique comment appeler ce script.
- Les skills et plugins externes sont consultatifs. Les règles, ADR et profils de ce dépôt décident.
- Les marqueurs de saisie vivent sous `templates/`. Le noyau ne contient aucune valeur à compléter.
- Tout nouveau Markdown doit être classé exactement une fois dans `documentation.json`. Régénérer ensuite `DOCUMENTATION-CATALOG.md`.
- La prose technique est en français, sobre et précise. Toute date mentionnée est absolue. Le code, les identifiants et les chemins restent en anglais. Ne pas utiliser de tiret cadratin ou demi-cadratin.

## Avant de committer

- Vérifier les liens Markdown locaux.
- Exécuter `python3 scripts/documentation_catalog.py --write`, puis contrôler le diff du catalogue.
- Vérifier que les fichiers du noyau ne contiennent aucune valeur à compléter.
- Vérifier que les règles ajoutées ne sont pas déjà présentes ailleurs.
- Exécuter `git diff --check`.
- Inspecter le diff complet et ne committer que le périmètre du socle.
