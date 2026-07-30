# ADR-0004 : publication Git obligatoire des tranches validées

- Statut : accepté
- Statut d'implémentation : livré
- Date : 2026-07-30
- Dernière vérification : 2026-07-30, tests des packs et vérification complète locale
- Propriétaire : Nicolas Pieper
- Remplace : aucune
- Remplacé par : aucune

## Contexte

Le default `D02` recommandait des commits petits et cohérents, puis un push
conditionnel lorsqu'un dépôt publiait ou sauvegardait le travail. La définition
de done demandait seulement que le push requis ait réussi. Un projet ou un
agent pouvait donc considérer une tranche terminée tout en la laissant dans un
worktree ou un historique local.

Cette ambiguïté a été observée pendant la création de Parkventory : le produit,
sa documentation et ses validations étaient terminés localement, mais aucun
commit ni push n'avait été réalisé faute de règle universelle assez explicite.

## Problème à décider

Comment garantir qu'un travail autorisé, cohérent et vérifié devient rapidement
visible, reprenable et contrôlable à distance, sans contourner une protection
de branche ni mélanger des changements sans rapport ?

## Options considérées

### Garder la publication comme default

Avantage : chaque projet choisit librement sa discipline Git.

Limite : un travail déclaré terminé peut rester fragile et invisible en local,
sans CI ni point de reprise partagé.

### Imposer systématiquement un push direct sur `main`

Avantage : chemin simple pour les dépôts personnels.

Limites : incompatible avec les protections de branche, les revues obligatoires
et certains dépôts d'équipe.

### Imposer la publication, laisser la politique choisir la branche

Avantages : aucune tranche terminée ne reste seulement locale ; `main` reste le
chemin court quand il est accessible ; une branche dédiée respecte les
protections et la revue lorsqu'elles existent.

Limite : chaque projet doit encore rendre sa branche canonique et sa politique
de revue explicites.

## Décision

La règle canonique est le principe `P18` dans `PRINCIPLES.md`. Toute tâche qui
autorise la modification d'un dépôt Git doté d'un remote livre chaque tranche
cohérente et vérifiée par un commit puis un push immédiat.

Le push cible directement la branche canonique si sa politique l'autorise. Si
elle est protégée ou soumise à revue, une branche dédiée au périmètre est créée
ou réutilisée. La protection n'est jamais contournée.

Une dérogation locale de convenance ne peut pas désactiver `P18`. Les exceptions
restent limitées par le principe lui-même : travail explicitement en lecture
seule ou local, autorité supérieure, absence de remote ou blocage externe. Un
blocage conserve un SHA local, une cible distante et une condition de reprise
explicites ; il ne transforme pas la livraison en succès.

## Conséquences

### Positives

- les travaux terminés sont visibles et récupérables rapidement ;
- la CI et les revues peuvent commencer sans attendre une livraison massive ;
- les commits restent plus petits et les rollbacks plus précis ;
- la branche protégée demeure respectée ;
- la preuve de livraison peut nommer un SHA distant.

### Négatives

- davantage de pushes et de runs CI peuvent être produits ;
- une tranche doit être correctement découpée avant le commit ;
- un incident réseau ou d'authentification devient un blocage de livraison
  explicite au lieu d'être masqué par un succès local.

## Mise en oeuvre

1. Ajouter `P18` aux invariants.
2. Retirer la cadence de commit et push de `D02`, qui ne conserve que la
   destination et le mode de revue par défaut.
3. Traduire `P18` dans les adaptateurs `AGENTS.md` de tous les packs.
4. Aligner la définition de done, le bootstrap, l'adoption, le versioning et la
   preuve de livraison.
5. Tester la présence du principe et de sa traduction dans les projets générés.

## Vérification

- `./scripts/verify.sh` passe ;
- chaque pack généré contient `P18` dans son snapshot ;
- les adaptateurs Minimal et Standard ou supérieurs exigent commit et push ;
- le commit de release existe sur le remote ;
- le tag annoté pointe vers le commit vérifié ;
- Parkventory adopte ensuite la release et publie son premier commit.

## Réexamen

Réexaminer uniquement si plusieurs projets démontrent que cette cadence produit
un coût de CI disproportionné sans améliorer la reprise ou la revue. Le
réexamen peut ajuster la taille d'une tranche cohérente ou la stratégie de CI,
mais ne rétablit pas la possibilité de déclarer terminé un travail uniquement
local.
