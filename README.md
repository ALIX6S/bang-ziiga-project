# Bãng Zĩiga

Application mobile de tourisme local pour le Burkina Faso. Elle réunit les sites
touristiques et culturels du pays, des itinéraires de visite prêts à suivre et des
repères sur la culture locale, dans une application Flutter adossée à une API REST.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![MongoDB](https://img.shields.io/badge/MongoDB-7+-green.svg)](https://www.mongodb.com/)

## Sommaire

| Section | Contenu |
|---|---|
| [Aperçu](#aperçu) | Captures des écrans de l'application |
| [Fonctionnalités](#fonctionnalités) | Ce que fait l'application aujourd'hui |
| [Architecture](#architecture) | Comment les parties s'assemblent |
| [Stack technique](#stack-technique) | Technologies et dépendances |
| [Démarrage](#démarrage) | Lancer la stack en local |
| [Lancer sur un téléphone Android](#lancer-sur-un-téléphone-android) | Build et installation |
| [API REST](#api-rest) | Points d'entrée exposés |
| [Comptes de test](#comptes-de-test) | Identifiants du jeu de données |
| [Structure du projet](#structure-du-projet) | Organisation des dossiers |
| [Qualité](#qualité) | Tests et analyse statique |
| [Limites connues](#limites-connues) | Ce qui n'est pas encore fait |

## Aperçu

Captures prises sur un appareil Android connecté à la stack locale.

<table>
  <tr>
    <th>Connexion</th>
    <th>Accueil</th>
    <th>Sites touristiques</th>
    <th>Détail d'un site</th>
  </tr>
  <tr>
    <td><img src="docs/screenshots/01-connexion.png" alt="Connexion" width="200"></td>
    <td><img src="docs/screenshots/02-accueil.png" alt="Accueil" width="200"></td>
    <td><img src="docs/screenshots/03-sites.png" alt="Sites touristiques" width="200"></td>
    <td><img src="docs/screenshots/04-site-detail.png" alt="Détail d'un site" width="200"></td>
  </tr>
  <tr>
    <th>Itinéraires</th>
    <th>Culture locale</th>
    <th>Profil</th>
  </tr>
  <tr>
    <td><img src="docs/screenshots/05-itineraires.png" alt="Itinéraires" width="200"></td>
    <td><img src="docs/screenshots/06-culture.png" alt="Culture locale" width="200"></td>
    <td><img src="docs/screenshots/07-profil.png" alt="Profil" width="200"></td>
  </tr>
</table>

## Fonctionnalités

### Authentification

Inscription et connexion par email et mot de passe, session portée par un jeton JWT
conservé sur l'appareil. Les mots de passe sont hachés avec bcrypt. Deux rôles
existent, `user` et `admin`, ce dernier seul autorisé à écrire dans le catalogue.

### Sites touristiques

Catalogue des sites avec image, catégorie, localisation et description. Recherche
textuelle, filtrage par catégorie, mise en avant des sites phares sur l'accueil et
fiche de détail par site. Les catégories couvertes par le jeu de données sont
Monument, Musée, Parc, Site Historique et Lieu Culturel.

### Itinéraires

Parcours thématiques reliant plusieurs sites, avec durée, difficulté, distance et
la liste ordonnée des étapes. La fiche de détail affiche chaque étape avec le site
correspondant.

### Culture locale

Trois sections, Traditions, Gastronomie et Événements, présentant les repères
culturels du pays.

### Profil

Identité du compte connecté et déconnexion.

## Architecture

<p align="center">
  <img src="docs/architecture.svg" alt="Architecture : application Flutter, API Node.js et MongoDB orchestrées par Docker Compose" width="100%">
</p>

L'application mobile ne connaît que l'API. Elle est organisée en quatre couches:
les écrans affichent, les providers portent l'état, les repositories traduisent les
réponses de l'API en modèles, et les services parlent le HTTP.

Côté serveur, chaque ressource suit le même chemin: une route déclare le verbe et
les protections, un contrôleur applique la logique, un modèle Mongoose valide et
persiste. Les opérations CRUD communes aux sites, aux itinéraires et aux
informations culturelles sont produites par une fabrique partagée,
`src/controllers/crudFactory.js`.

Les images des sites sont servies en statique depuis `backend/uploads`, sous le
préfixe `/uploads`.

## Stack technique

### Backend

| Rôle | Technologie |
|---|---|
| Runtime | Node.js 18 ou plus |
| Framework web | Express 4 |
| Base de données | MongoDB 7, via Mongoose 8 |
| Authentification | JSON Web Token, bcryptjs |
| Sécurité | Helmet, CORS, express-rate-limit |
| Validation | express-validator |
| Journalisation | Morgan |
| Compression | compression |

### Frontend

| Rôle | Technologie |
|---|---|
| Framework | Flutter 3 |
| Gestion d'état | provider |
| Réseau | http |
| Stockage local | shared_preferences |
| Cache d'images | cached_network_image |
| Typographie | google_fonts |
| Validation d'email | email_validator |

## Démarrage

Tout tourne dans des conteneurs Docker. Aucun outil n'est installé sur la machine:
ni Node, ni MongoDB, ni Flutter, ni le SDK Android. Prérequis: Docker et `make`.

```bash
cd infra
make up      # MongoDB et l'API sur http://localhost:3000
make seed    # jeu de données: 6 sites, 3 itinéraires, 5 fiches culture, 2 comptes
make apk     # APK -> infra/out/bang-ziiga.apk (premier build long: téléchargements)
make phone   # installe et lance sur le téléphone branché en USB (adb + débogage USB)
make clean   # supprime tout: conteneurs, données, caches
```

Le détail (fichiers, tunnel `adb reverse`, variables) est dans [infra/README.md](infra/README.md).

## API REST

Base: `http://localhost:3000/api/v1`

### Authentification

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| POST | `/auth/register` | Public | Créer un compte |
| POST | `/auth/login` | Public | Se connecter, retourne un JWT |
| GET | `/auth/me` | Authentifié | Profil du compte courant |
| POST | `/auth/logout` | Authentifié | Déconnexion |

### Sites

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| GET | `/sites` | Public | Liste, avec recherche et filtres |
| GET | `/sites/featured` | Public | Sites mis en avant |
| GET | `/sites/:id` | Public | Détail d'un site |
| POST | `/sites` | Admin | Créer un site |
| PUT | `/sites/:id` | Admin | Modifier un site |
| DELETE | `/sites/:id` | Admin | Supprimer un site |

### Itinéraires

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| GET | `/itineraires` | Public | Liste des itinéraires |
| GET | `/itineraires/:id` | Public | Détail, avec les sites associés |
| POST | `/itineraires` | Admin | Créer un itinéraire |
| PUT | `/itineraires/:id` | Admin | Modifier un itinéraire |
| DELETE | `/itineraires/:id` | Admin | Supprimer un itinéraire |

### Culture

| Méthode | Chemin | Accès | Description |
|---|---|---|---|
| GET | `/culture` | Public | Toutes les informations culturelles |
| GET | `/culture/:type` | Public | Filtrage par type |
| POST | `/culture` | Admin | Créer une information |
| PUT | `/culture/:id` | Admin | Modifier une information |
| DELETE | `/culture/:id` | Admin | Supprimer une information |

### Divers

| Méthode | Chemin | Description |
|---|---|---|
| GET | `/health` | État du service |
| GET | `/uploads/...` | Images des sites et des itinéraires |

Une collection Postman est disponible dans `docs/postman_collection.json`.

## Comptes de test

Créés par le seeder, pour le développement local uniquement.

| Rôle | Email | Mot de passe |
|---|---|---|
| Administrateur | `admin@bangziiga.com` | `admin123` |
| Utilisateur | `alix.vebamba@bangziiga.com` | `Alix2026!` |

## Structure du projet

```
bang-ziiga-project/
├── backend/
│   ├── server.js                 point d entree
│   ├── src/
│   │   ├── app.js                configuration Express
│   │   ├── config/               connexion MongoDB
│   │   ├── controllers/          logique metier, dont crudFactory.js
│   │   ├── middlewares/          authentification, validation, erreurs
│   │   ├── models/               schemas Mongoose
│   │   ├── routes/               declaration des endpoints
│   │   ├── seeders/              jeu de donnees de developpement
│   │   └── utils/
│   └── uploads/                  images servies en statique
├── frontend/
│   ├── lib/
│   │   ├── core/                 theme, couleurs, constantes, widgets partages
│   │   ├── data/repositories/    acces aux donnees de l API
│   │   ├── models/               modeles metier
│   │   ├── providers/            gestion d etat
│   │   ├── screens/              ecrans et widgets propres a un ecran
│   │   ├── services/             client HTTP, authentification, stockage
│   │   └── utils/
│   └── test/                     tests unitaires et de widgets
├── infra/                        Dockerfiles, docker-compose, Makefile, scripts
└── docs/                         documentation, captures, collection Postman
```

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

## Licence

MIT. Voir le fichier de licence du dépôt.
