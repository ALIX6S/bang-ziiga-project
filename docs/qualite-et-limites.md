# Qualité et limites connues

## Qualité

| Vérification | Commande | État |
|---|---|---|
| Analyse statique Flutter | `make -C infra test` | Aucun problème |
| Tests Flutter | `make -C infra test` | 32 tests au vert |
| Tests backend | Aucun | À écrire |

Les tests du frontend couvrent les modèles, le provider des sites, le service HTTP
et le widget de carte de site.

## Limites connues

Points identifiés et non traités à ce jour, listés pour éviter les mauvaises
surprises.

| Sujet | Détail |
|---|---|
| Écran Culture | Le contenu affiché est codé en dur dans l'application. L'API `/culture` existe et renvoie des données, mais l'écran ne les consomme pas. |
| Tests backend | Aucun test automatisé côté API. |
| Identifiant d'application | `applicationId` vaut encore `com.example.frontend`, valeur par défaut du modèle Flutter. À changer avant toute publication. |
| Validation des écritures | Les POST et PUT sur les sites, itinéraires et informations culturelles ne passent pas par express-validator, seul le schéma Mongoose les protège. |
| Champ `imageUrl` | Déclaré à la fois obligatoire et avec une valeur par défaut, donc l'obligation ne se déclenche jamais. |
| Récupération par identifiant | `sites_repository.dart` et `itineraires_repository.dart` convertissent l'identifiant en entier, alors que MongoDB produit des ObjectId. Ce chemin n'est pas emprunté par l'interface actuelle, qui navigue avec l'objet déjà chargé. |
| CORS | Ouvert à toutes les origines. À restreindre avant une mise en production. |
