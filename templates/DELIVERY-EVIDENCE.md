# Preuve de livraison : TODO résultat

Ce document consigne ce qui a été observé pour une unité de travail. Il ne crée aucune norme et n'étend aucune autorité.

## Nature du document

| Couche | Rôle |
| --- | --- |
| Norme | `P02`, `P03`, `P05`, `P08`, `P09`, `P10`, `P11`, `P14`, `P18`, `P19` et les profils durables activés dans `FOUNDATION.md` |
| Formulaire | Ce fichier structure le compte rendu et les limites de validation |
| Preuve | Une commande, une sortie, un SHA, un digest, un fichier, une capture ou une observation datée dans l'environnement nommé |

Le texte de ce formulaire n'est pas une preuve sans résultat observable associé. Ne jamais y coller de secret ni de donnée personnelle inutile.

## Référence

| Champ | Valeur |
| --- | --- |
| Unité de travail | TODO |
| Demande ou autorité source | TODO issue, tâche, instruction ou décision |
| Auteur | TODO |
| Vérificateur | TODO |
| Date | TODO YYYY-MM-DD |
| Branche | TODO |
| Commit final | TODO SHA complet ou non applicable |
| Artefact final | TODO digest, version, chemin ou non applicable |
| Profils applicables à cette unité | TODO sous-ensemble des profils activés dans FOUNDATION.md, ou aucun |

## Périmètre

### Cible demandée

TODO Décrire le résultat attendu.

### Résultat actuel observé

TODO Décrire uniquement ce qui a été vérifié.

### Exclusions

- TODO

### Limites de preuve

- TODO environnement, accès, service externe ou contrôle non disponible.

## Etat initial

| Elément | Observation | Preuve |
| --- | --- | --- |
| Worktree et changements sans rapport | TODO | TODO commande ou diff |
| Version ou SHA initial | TODO | TODO |
| Environnement et versions d'outils | TODO | TODO |
| Etat de la surface cible | TODO | TODO |

## Sources et dérivés

| Concept ou artefact | Source canonique | Dérivé ou consommateur | Alignement vérifié par |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

## Gates appliquées

Utiliser les identifiants `Pxx`, les profils applicables à cette unité et les sections pertinentes de `DEFINITION-OF-DONE.md`. Ne pas modifier le snapshot vendorisé pour cocher une livraison.

| Gate ou source | Applicable | Motif si non applicable | Contrôle réalisé | Environnement | Résultat | Preuve |
| --- | --- | --- | --- | --- | --- | --- |
| TODO Pxx, profil ou section | TODO oui ou non | TODO | TODO | TODO | TODO succès ou échec | TODO |

## Contrôles automatisés

| Commande exacte | Répertoire | Environnement et versions | Résultat | Portée | Preuve |
| --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO code de sortie et résumé | TODO ce que le contrôle prouve et ne prouve pas | TODO |

## Contrôles manuels ou perceptifs

| Surface | Scénario | Environnement | Observation | Résultat | Preuve |
| --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO navigateur, appareil, service ou fichier | TODO | TODO | TODO |

## Actions externes et checkpoints

| Action | Cible exacte | Autorité ou checkpoint | Exécutée | Résultat | Rollback disponible | Preuve |
| --- | --- | --- | --- | --- | --- | --- |
| TODO ou aucune | TODO | TODO | TODO oui ou non | TODO | TODO | TODO |

Une action décrite mais non autorisée reste non exécutée et figure dans les actions restantes.

## Rollback, sauvegarde et restauration

| Contrôle | Cible isolée | Commande ou procédure | Résultat | Date | Preuve | Limite |
| --- | --- | --- | --- | --- | --- | --- |
| Sauvegarde | TODO ou non applicable | TODO | TODO | TODO | TODO | TODO |
| Restauration | TODO cible isolée, jamais la production servant des utilisateurs | TODO | TODO | TODO | TODO | TODO |
| Rollback | TODO | TODO | TODO testé, simulé ou non testé | TODO | TODO | TODO |

## Artefact et surface finale

| Surface | Environnement | SHA, digest, version ou fichier | Contrôle final | Observé le | Preuve |
| --- | --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO YYYY-MM-DD | TODO |

Ne pas généraliser une preuve locale à la CI, au conteneur, à la production ou à une URL publique sans contrôle dans cette surface.

## Diff et livraison

- Fichiers du résultat : TODO.
- Changements sans rapport préservés : TODO.
- Source, dérivés et consommateurs livrés ensemble : TODO ou non applicable.
- Commit et push requis par `P18` : TODO SHA, remote et branche.
- Parcours Compose requis par `P19` : TODO services, santé et sondes, ou pack Minimal sans processus local.
- Déploiement requis par le périmètre : TODO ou non applicable.
- Etat final du worktree : TODO.

## Conclusion

| Champ | Valeur |
| --- | --- |
| Statut observé | TODO livré, partiel, bloqué ou non vérifié |
| Résultat prouvé | TODO |
| Risques restants | TODO |
| Validations non réalisées | TODO |
| Actions externes restantes et propriétaire | TODO |
| Mise à jour de `STATUS.md` ou `ROADMAP.md` | TODO |
