# Bãng Zĩiga

Application mobile de tourisme local pour le Burkina Faso : sites touristiques et
culturels, itinéraires de visite et repères sur la culture locale. Application
Flutter adossée à une API REST Node.js et MongoDB.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![MongoDB](https://img.shields.io/badge/MongoDB-7+-green.svg)](https://www.mongodb.com/)

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

## Démarrage

Tout tourne dans Docker : rien à installer d'autre que Docker et `make`.

```bash
cd infra
make up      # MongoDB et l'API sur http://localhost:3000
make seed    # jeu de données de démonstration
make apk     # APK -> infra/out/bang-ziiga.apk (premier build long)
make phone   # installe et lance sur le téléphone branché en USB
make clean   # supprime tout : conteneurs, données, caches
```

Détails (fichiers, tunnel `adb reverse`, variables) : [infra/README.md](infra/README.md).

## Architecture

<p align="center">
  <img src="docs/architecture.svg" alt="Architecture : application Flutter, API Node.js et MongoDB orchestrées par Docker Compose" width="100%">
</p>

## Documentation

| Document | Contenu |
|---|---|
| [Fonctionnalités](docs/fonctionnalites.md) | Ce que fait l'application |
| [Architecture](docs/architecture.md) | Couches, stack technique, structure des dossiers |
| [API REST](docs/api.md) | Points d'entrée exposés (collection Postman : `docs/postman_collection.json`) |
| [Qualité et limites](docs/qualite-et-limites.md) | Tests, analyse statique, points non traités |
| [Infra Docker](infra/README.md) | Compose, Makefile, build de l'APK, téléphone |

## Licence

MIT. Voir le fichier de licence du dépôt.
