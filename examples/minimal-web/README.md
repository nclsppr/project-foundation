# Exemple narratif : Trail Card Lab

Cet exemple est entièrement fictif. Les personnes, le produit et les données sont inventés pour montrer comment remplir le parcours léger. Ce dossier ne contient aucune application, aucun déploiement et aucune validation produit.

Ce README composite n'est ni le tree produit par le bootstrap, ni une preuve d'adoption réelle. Il montre le contenu attendu sans dupliquer tous les fichiers générés.

Les principaux documents propres au projet qu'un vrai dépôt créerait sont issus des templates suivants :

- [README minimal](../../templates/README.md)
- [Brief d'exploration](../../templates/BRIEF.md)
- [Adaptateur agent minimal](../../templates/AGENTS-minimal.md)
- [Contrat d'adoption du socle](../../templates/FOUNDATION.md)

Le bootstrap ajoute aussi le snapshot du noyau, les deux profils et les scripts de vérification.

## README du projet fictif

**Trail Card Lab** explore si une carte d'itinéraire statique peut présenter cinq étapes fictives sur un écran de 320 px, rester utilisable au clavier et s'imprimer sans débordement.

> Statut : exploration documentée, implémentation non commencée. Aucun résultat n'est encore acquis.

### Démarrage

| Action | Commande | Résultat attendu |
| --- | --- | --- |
| Installer | Non applicable à ce stade | Aucun package |
| Lancer | Non disponible avant l'incrément d'exploration | Aucune URL annoncée |
| Vérifier | Non disponible avant l'incrément d'exploration | Aucune validation annoncée |
| Arrêter ou nettoyer | Non applicable à ce stade | Aucun processus ou état à supprimer |

Le futur incrément pourra adopter un serveur statique et un script de vérification. Ces commandes ne sont pas documentées comme existantes avant leur ajout réel.

### Carte documentaire prévue

```text
README.md
BRIEF.md
FOUNDATION.md
AGENTS.md
docs/foundation/
  PRINCIPLES.md
  DEFAULTS.md
  DEFINITION-OF-DONE.md
  profiles/
    experiment.md
    web.md
scripts/
  check_markdown.py
  verify.sh
```

## BRIEF rempli

### Identité

| Champ | Valeur |
| --- | --- |
| Nom | Trail Card Lab |
| Propriétaire | Camille Martin, personne fictive |
| Classe | Exploration |
| Statut | Non commencée |
| Début | 2026-07-27 |
| Limite | Une journée de travail, sans service payant |

### Question

Une page HTML et CSS sans JavaScript peut-elle rendre cinq étapes fictives lisibles à 320 px, navigables au clavier et propres à l'impression sans créer de débordement horizontal ?

### Contexte et utilisateur

Le scénario fictif concerne une designer qui souhaite tester une composition avant de proposer un produit. Aucun entretien utilisateur n'a eu lieu. Le besoin utilisateur reste donc une hypothèse, pas un fait validé.

### Preuve attendue

Un prototype local unique avec cinq étapes synthétiques, accompagné de contrôles documentés à 320 px et 1280 px, au clavier, avec mouvement réduit et en aperçu d'impression.

### Périmètre

Inclus :

- une page statique ;
- cinq étapes et durées entièrement synthétiques ;
- une composition mobile et une composition bureau ;
- états de focus visibles ;
- aperçu d'impression.

Exclu :

- carte géographique réelle ;
- compte utilisateur, backend ou stockage ;
- géolocalisation ;
- publication publique ;
- mesure de conversion ou test avec de vraies personnes.

### Faits et hypothèses

| Type | Affirmation | Source ou prochaine vérification |
| --- | --- | --- |
| Fait | Ce dossier ne contient aucun code applicatif | Inspection du tree de l'exemple |
| Fait | Toutes les étapes et durées seront synthétiques | Contrat de l'exploration |
| Hypothèse | HTML et CSS suffiront pour le parcours principal | À tester avec le prototype local |
| Hypothèse | Cinq étapes resteront lisibles à 320 px sans masquer d'information | À vérifier visuellement et au clavier |

### Contraintes

- Données et confidentialité : données synthétiques uniquement, aucune donnée personnelle.
- Accès et secrets : aucun.
- Temps et coût maximum : une journée, coût externe nul.
- Profils activés : voir le contrat `FOUNDATION` rempli ci-dessous.

### Conditions de conclusion

- Succès : les cinq étapes restent lisibles sans débordement à 320 px et 1280 px, l'ordre clavier est logique et l'impression ne coupe aucune étape.
- Échec : une information essentielle doit être masquée, le clavier ne permet pas de parcourir les actions prévues, ou la mise en page exige du JavaScript uniquement pour tenir.
- Arrêt : fin de la journée, apparition d'un besoin de données réelles ou demande de publication publique.

### État vérifié et conclusion

- Vérifié le : 2026-07-26.
- Environnement ou artefact : documentation de l'exemple uniquement.
- Observations : aucun fichier HTML, CSS, script ou déploiement n'existe.
- Conclusion : non conclue, faute de prototype et de mesure.
- Limites de la preuve : la documentation montre la méthode, pas la faisabilité de l'interface.

### Décision suivante

Créer au maximum un incrément local d'une journée, puis consigner les observations. Arrêter si les critères d'arrêt sont atteints. En cas de preuve positive et de décision de servir de vraies personnes, passer au bootstrap standard au lieu d'étendre ce brief.

## FOUNDATION rempli

| Champ | Valeur d'exemple |
| --- | --- |
| Source | Dépôt fictif `project-foundation` |
| Version lisible | `v0.1.0`, tag fictif conforme |
| Commit immuable | `1111111111111111111111111111111111111111`, SHA fictif |
| Pack adopté | `minimal` |
| Adoptée le | 2026-07-26 |
| Adoptée par | Camille Martin, personne fictive |
| Snapshot | `PRINCIPLES.md`, `DEFAULTS.md`, `DEFINITION-OF-DONE.md` |
| Profils activés | `experiment` et `web` |
| Dérogations | Aucune |
| Source locale supplémentaire | `BRIEF.md` pour les limites données et coût |

## AGENTS minimal rempli

L'adaptateur local ne recopie aucune règle du noyau. Il route chaque question :

| Question | Source dans l'exemple |
| --- | --- |
| Autorité de l'intervention | Demande actuelle de Camille, dans les limites du socle |
| Intention | Question, périmètre et critères du `BRIEF.md` |
| État réel | Fichiers et commandes observés dans le dépôt au moment de l'intervention |
| Historique | Git et décisions datées, sans les présenter comme état courant |

L'agent reste dans la limite d'une journée, utilise les commandes réellement présentes, puis met à jour la conclusion du brief. Une demande de publication ou de données réelles déclenche l'arrêt et la reclassification de l'exploration.
