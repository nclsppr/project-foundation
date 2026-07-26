# RUNBOOK : TODO opération

Ce document décrit une procédure opératoire. Il n'autorise pas son exécution.

## Nature du document

| Couche | Rôle |
| --- | --- |
| Norme | `P05`, `P08`, `P09`, `P10`, `P11`, `P14`, `P15` et les profils activés dans `FOUNDATION.md` |
| Formulaire | Ce runbook traduit ces règles pour une cible et une opération précises |
| Preuve | Les SHA, sorties, sauvegardes, restaurations et observations sont consignés dans une preuve de livraison ou d'incident, pas déduits de ce fichier |

Un runbook rempli n'est ni une preuve d'exécution, ni une permission, ni une description automatique de l'état courant.

## Identité

| Champ | Valeur |
| --- | --- |
| Opération | TODO |
| Propriétaire | TODO |
| Suppléant | TODO |
| Statut documentaire | TODO brouillon, actuel, cible, expérimental ou retiré |
| Dernière vérification | TODO YYYY-MM-DD ou jamais vérifié |
| Environnement concerné | TODO |
| Décisions liées | TODO ADR ou non applicable |
| Preuve de la dernière exécution | TODO lien ou aucune |

## Etat actuel et cible

### Etat actuel vérifié

| Elément | Valeur observée | Preuve | Vérifié le |
| --- | --- | --- | --- |
| Version, SHA ou digest | TODO | TODO commande, artefact ou URL | TODO YYYY-MM-DD |
| Configuration chargée | TODO | TODO | TODO YYYY-MM-DD |
| Santé et dépendances | TODO | TODO | TODO YYYY-MM-DD |

### Cible

TODO Décrire le résultat attendu sans le présenter comme déjà opérationnel.

### Limites et exclusions

- TODO

## Cible exacte

| Dimension | Valeur attendue |
| --- | --- |
| Environnement | TODO |
| Service ou composant | TODO |
| Hôte, cluster, compte ou tenant | TODO |
| Région, namespace ou réseau | TODO ou non applicable |
| Données concernées | TODO ou aucune |
| Cibles explicitement exclues | TODO |

Ne placer aucun secret dans ce tableau. Une cible explicite ne vaut pas autorisation.

## Autorité et checkpoints

| Action sensible | Autorité requise | Checkpoint avant action | Condition d'arrêt |
| --- | --- | --- | --- |
| TODO accès, secret, achat, DNS, suppression ou mutation externe | TODO politique, rôle ou instruction | TODO validation observable | TODO |

Si l'autorité manque ou si la cible résolue diffère de la cible attendue, arrêter la procédure.

## Préconditions

- Source canonique de la configuration : TODO.
- Commande canonique de validation : TODO.
- Accès requis et portée minimale : TODO.
- Référence des secrets sans leur valeur : TODO.
- Fenêtre d'intervention : TODO ou non applicable.
- Etat de santé acceptable avant intervention : TODO.
- Critères qui interdisent de commencer : TODO.

## Sauvegarde et restauration isolée

| Champ | Valeur |
| --- | --- |
| Données ou configuration à protéger | TODO ou non applicable |
| Commande canonique de sauvegarde | TODO ou non applicable |
| Identifiant et emplacement de la sauvegarde | TODO sans secret |
| Intégrité vérifiée par | TODO commande, hash ou contrôle |
| Chiffrement et accès | TODO |
| Cible isolée de restauration | TODO, jamais la production servant des utilisateurs |
| Commande canonique de restauration | TODO ou non applicable |
| Dernier test de restauration | TODO date, résultat et preuve |
| RPO et RTO | TODO ou non applicable |

Une sauvegarde non restaurée dans une cible isolée reste une hypothèse de récupération.

## Contrôles avant exécution

1. TODO Résoudre et afficher la cible sans donnée sensible.
2. TODO Inspecter l'état, les versions et la configuration réellement chargée.
3. TODO Valider la configuration et produire un diff ou dry-run si disponible.
4. TODO Confirmer les checkpoints et le rollback.
5. TODO Créer puis vérifier la sauvegarde requise.

## Procédure

Les commandes détaillées vivent dans leur script canonique. Ce tableau les appelle sans recopier leur implémentation.

| Etape | Action | Commande canonique | Résultat attendu | Arrêt immédiat si |
| --- | --- | --- | --- | --- |
| 1 | TODO | TODO | TODO | TODO |

## Vérification après action

| Contrôle | Environnement | Résultat attendu | Preuve à conserver |
| --- | --- | --- | --- |
| Configuration | TODO | TODO | TODO |
| Santé et dépendances | TODO | TODO | TODO |
| Parcours critique | TODO | TODO | TODO |
| Logs et métriques | TODO | TODO | TODO |
| Surface finale | TODO | TODO | TODO SHA, digest, fichier ou URL |

Définir une fenêtre d'observation : TODO durée, signaux et seuils.

## Rollback

### Déclencheurs

- TODO seuil, échec ou délai qui impose le rollback.

### Point de retour

| Champ | Valeur |
| --- | --- |
| Artefact, SHA ou configuration précédente | TODO référence immuable |
| Données concernées | TODO |
| Perte ou incompatibilité possible | TODO |
| Autorité requise | TODO |

### Procédure de rollback

1. TODO

### Vérification du rollback

- Commande de santé : TODO.
- Parcours critique : TODO.
- Etat des données : TODO.
- Preuve finale : TODO.

## Incident et escalade

| Condition | Action sûre | Contact ou rôle | Preuve à conserver |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

Ne pas poursuivre une procédure partiellement comprise après un échec. Préserver les preuves sans exposer de secret ou de donnée personnelle inutile.

## Clôture

- Preuve de livraison ou d'incident : TODO chemin vers un document issu de `templates/DELIVERY-EVIDENCE.md` ou équivalent.
- Etat courant mis à jour dans `STATUS.md` : TODO oui ou non avec raison.
- Documentation ou ADR à aligner : TODO.
- Risques et actions externes restants : TODO.
- Prochaine date de vérification du runbook : TODO YYYY-MM-DD.
