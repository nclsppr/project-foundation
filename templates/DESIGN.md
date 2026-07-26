# DESIGN.md

Contrat visuel et UX du projet. `AGENTS.md` garde la priorité sur le mode d'intervention.

## Intention

### Impression recherchée

TODO

### Différenciation liée au produit

TODO Expliquer comment le langage visuel sert attention, compréhension, confiance ou conversion.

### Anti-objectifs

- TODO

## Principes

1. TODO

## Tokens

La source exécutable des tokens est : TODO.

### Couleurs

| Rôle | Token | Clair | Sombre | Contraste requis |
| --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO |

### Typographie

| Rôle | Police | Mesure | Usage |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

### Espacement, rayons et ombres

TODO

## Mise en page

- Largeur de lecture : TODO
- Grille desktop : TODO
- Composition mobile : TODO
- Breakpoints motivés par le contenu : TODO
- Débordements autorisés : TODO

## Composants

| Composant | Usage | Variantes | États obligatoires |
| --- | --- | --- | --- |
| TODO | TODO | TODO | default, hover, focus, active, disabled, loading, error |

## Interaction et mouvement

- Feedback utile : TODO
- Surfaces rares pouvant porter du delight : TODO
- Durée maximale UI : TODO
- Propriétés animées : TODO
- Comportement avec `prefers-reduced-motion` : TODO
- Hovers limités aux pointeurs compatibles : TODO

## Accessibilité

- Niveau visé : WCAG AA
- Contrastes : TODO
- Focus : TODO
- Navigation clavier : TODO
- Cibles tactiles : TODO
- ARIA dynamique : TODO
- Alternatives textuelles : TODO
- États non portés uniquement par la couleur : TODO

## Images et médias

| Famille | Fonction | Style | Format | Provenance |
| --- | --- | --- | --- | --- |
| TODO | information ou narration | TODO | TODO | TODO |

Règles :

- Le texte fonctionnel reste dans le document, pas dans une image générée.
- Les dimensions, poids, transparence et variantes sont définis.
- Une source ou un prompt canonique évite la dérive visuelle.
- Une image générée est liée à son usage et à sa provenance.

## Performance

- Budget image : TODO
- Budget JavaScript : TODO
- Budget rendu ou animation : TODO
- Appareil et réseau de référence : TODO
- Fallback sans enrichissement : TODO

## Zones gelées

Éléments qui ne changent pas sans décision explicite :

- TODO

## Matrice de validation

| Dimension | Valeurs |
| --- | --- |
| Viewports | TODO mobile, desktop |
| Thèmes | TODO |
| Entrées | clavier, tactile, souris |
| Mouvement | normal, réduit |
| Contenu | court, long, vide, erreur |
| Navigateurs | TODO |
| Appareils réels requis | TODO |
