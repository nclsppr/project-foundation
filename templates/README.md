# TODO nom du projet

TODO Décrire en une phrase la question explorée et le résultat observable recherché.

> Exploration limitée. Le périmètre, les hypothèses, l'état vérifié et la conclusion vivent dans [`BRIEF.md`](BRIEF.md).

## Démarrage

Prérequis du socle : Git, Python `3.9` ou plus récent, Node `22.12.0` ou plus
récent, npm, Docker et Docker Compose `2.20.0` ou plus récent. Prérequis propres
à l'exploration : TODO ou aucun.

| Action | Commande | Résultat attendu |
| --- | --- | --- |
| Installer | TODO ou non applicable | TODO |
| Lancer | TODO | TODO URL, sortie ou fichier |
| Vérifier | `./scripts/verify.sh` | Catalogue, Markdown et build Nimbus valides |
| Vérifier Compose | `python3 scripts/check_compose.py` | Contrat Compose conforme à `P19` |
| Arrêter ou nettoyer | TODO ou non applicable | TODO |

Une commande absente est indiquée comme non applicable. Une commande future n'est pas présentée comme disponible.

## Carte documentaire

- [`BRIEF.md`](BRIEF.md) : question, périmètre, faits, hypothèses et conclusion datée.
- [`CHANGELOG.md`](CHANGELOG.md) : changements livrés et impact observable.
- [`FOUNDATION.md`](FOUNDATION.md) : version du socle, profils activés et dérogations locales.
- [`DOCUMENTATION-CATALOG.md`](DOCUMENTATION-CATALOG.md) : navigation exhaustive des Markdown et de leurs audiences.
- `docs-nimbus/` : moteur documentaire obligatoire, adaptateur, configuration et lockfile.
- [`AGENTS.md`](AGENTS.md) : routage minimal pour les interventions assistées.
- `docs/foundation/` : snapshot vendorisé du noyau et des profils. Ne pas le modifier localement.

Ce README oriente uniquement. Il ne duplique ni le brief, ni les règles du socle, ni les preuves.
