# API REST

Base: `http://localhost:3000/api/v1`

## Authentification

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| POST | `/auth/register` | Public | Créer un compte |
| POST | `/auth/login` | Public | Se connecter, retourne un JWT |
| GET | `/auth/me` | Authentifié | Profil du compte courant |
| POST | `/auth/logout` | Authentifié | Déconnexion |

## Sites

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| GET | `/sites` | Public | Liste, avec recherche et filtres |
| GET | `/sites/featured` | Public | Sites mis en avant |
| GET | `/sites/:id` | Public | Détail d'un site |
| POST | `/sites` | Admin | Créer un site |
| PUT | `/sites/:id` | Admin | Modifier un site |
| DELETE | `/sites/:id` | Admin | Supprimer un site |

## Itinéraires

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| GET | `/itineraires` | Public | Liste des itinéraires |
| GET | `/itineraires/:id` | Public | Détail, avec les sites associés |
| POST | `/itineraires` | Admin | Créer un itinéraire |
| PUT | `/itineraires/:id` | Admin | Modifier un itinéraire |
| DELETE | `/itineraires/:id` | Admin | Supprimer un itinéraire |

## Culture

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| GET | `/culture` | Public | Toutes les informations culturelles |
| GET | `/culture/:type` | Public | Filtrage par type |
| POST | `/culture` | Admin | Créer une information |
| PUT | `/culture/:id` | Admin | Modifier une information |
| DELETE | `/culture/:id` | Admin | Supprimer une information |

## Divers

| Méthode | Chemin | Description |
|---|---|---|
| GET | `/health` | État du service |
| GET | `/uploads/...` | Images des sites et des itinéraires |

Une collection Postman est disponible dans [`postman_collection.json`](postman_collection.json).
