# Bãng Zĩiga - Application de Tourisme Local

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![MongoDB](https://img.shields.io/badge/MongoDB-8.0+-green.svg)](https://www.mongodb.com/)

## 🌍 Description

**Bãng Zĩiga** est une application mobile complète de tourisme local développée pour promouvoir les sites touristiques et culturels du Burkina Faso. L'application permet aux utilisateurs de découvrir, explorer et planifier des visites de sites historiques, monuments, musées et lieux culturels à travers une interface intuitive et moderne.

L'application est composée de deux parties principales :
- **Backend API REST** : API robuste développée avec Node.js, Express et MongoDB
- **Application Mobile** : Application Flutter cross-platform (Android, iOS, Web)

## ✨ Fonctionnalités

### 🔐 Authentification
- Inscription et connexion des utilisateurs
- Gestion des sessions avec JWT
- Profils utilisateurs personnalisés

### 🏛️ Gestion des Sites Touristiques
- Catalogue complet des sites touristiques
- Catégorisation (Monuments, Musées, Parcs, Plages, Sites Historiques, Lieux Culturels)
- Recherche et filtrage avancés
- Géolocalisation avec coordonnées GPS
- Images haute qualité pour chaque site
- Horaires d'ouverture et informations pratiques

### 🗺️ Itinéraires Touristiques
- Création et gestion d'itinéraires personnalisés
- Organisation de visites par thèmes
- Suggestions d'itinéraires optimisés
- Partage d'itinéraires entre utilisateurs

### 🎭 Informations Culturelles
- Base de données culturelle riche
- Informations sur les traditions locales
- Histoire et patrimoine culturel
- Contenus éducatifs et informatifs

### 📱 Interface Utilisateur
- Design moderne et intuitif
- Mode sombre/clair
- Navigation fluide
- Cache d'images pour une expérience optimale
- Support multiplateforme

## 🛠️ Technologies Utilisées

### Backend
- **Node.js** (v18+) - Runtime JavaScript
- **Express.js** - Framework web
- **MongoDB** - Base de données NoSQL
- **Mongoose** - ODM pour MongoDB
- **JWT** - Authentification
- **bcryptjs** - Hashage des mots de passe
- **Helmet** - Sécurité HTTP
- **CORS** - Gestion des requêtes cross-origin
- **Rate Limiting** - Protection contre les attaques DDoS

### Frontend
- **Flutter** (v3.0+) - Framework UI cross-platform
- **Provider** - Gestion d'état
- **HTTP** - Client réseau
- **Shared Preferences** - Stockage local
- **Cached Network Image** - Cache d'images
- **Google Fonts** - Typographie

### Outils de Développement
- **Jest** - Tests unitaires
- **Nodemon** - Rechargement automatique
- **Flutter Lints** - Linting du code
- **Postman** - Test des API

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

### Pour le Backend
- Node.js (version 18 ou supérieure)
- npm (version 9 ou supérieure)
- MongoDB (local ou Atlas)

### Pour le Frontend
- Flutter SDK (version 3.0 ou supérieure)
- Android Studio (pour Android)
- Xcode (pour iOS, macOS uniquement)

## 🚀 Installation

### 1. Clonage du Repository

```bash
git clone https://github.com/votre-username/bang-ziiga-project.git
cd bang-ziiga-project
```

### 2. Configuration du Backend

```bash
cd backend

# Installation des dépendances
npm install

# Configuration des variables d'environnement
cp .env.example .env
```

Éditez le fichier `.env` avec vos configurations :

```env
NODE_ENV=development
PORT=3000
HOST=0.0.0.0
API_VERSION=v1

# Base de données MongoDB
MONGODB_URI=mongodb://localhost:27017/bang_ziiga
# ou pour MongoDB Atlas :
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/bang_ziiga

# JWT
JWT_SECRET=votre-secret-jwt-très-long-et-complexe
JWT_EXPIRE=7d

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Uploads
MAX_FILE_SIZE=5000000
UPLOAD_PATH=./uploads
```

### 3. Configuration du Frontend

```bash
cd ../frontend

# Installation des dépendances
flutter pub get

# Configuration des icônes de l'application (optionnel)
flutter pub run flutter_launcher_icons:main
```

## ⚙️ Configuration

### Base de Données

Le projet utilise MongoDB. Vous pouvez :

1. **Installation locale** :
   ```bash
   # Ubuntu/Debian
   sudo apt-get install mongodb

   # macOS avec Homebrew
   brew install mongodb-community

   # Démarrage
   mongod
   ```

2. **MongoDB Atlas** (recommandé pour la production) :
   - Créez un compte sur [MongoDB Atlas](https://www.mongodb.com/atlas)
   - Créez un cluster gratuit
   - Obtenez l'URI de connexion

### Seeders

Pour initialiser la base de données avec des données de test :

```bash
cd backend
npm run seed
```

## 🏃‍♂️ Utilisation

### Démarrage du Backend

```bash
cd backend

# Mode développement (avec nodemon)
npm run dev

# Mode production
npm start
```

Le serveur démarrera sur `http://localhost:3000` (ou l'IP réseau pour les tests mobiles).

### Démarrage du Frontend

```bash
cd frontend

# Lancement sur émulateur/device
flutter run

# Lancement sur Android
flutter run -d android

# Lancement sur iOS (macOS uniquement)
flutter run -d ios

# Lancement sur Web
flutter run -d chrome
```

## 📚 API Documentation

L'API REST est documentée automatiquement. Une fois le serveur démarré, accédez à :

- **Documentation principale** : `http://localhost:3000/api/v1`
- **Health Check** : `http://localhost:3000/health`

### Endpoints Principaux

#### Authentification
- `POST /api/v1/auth/register` - Inscription
- `POST /api/v1/auth/login` - Connexion
- `GET /api/v1/auth/me` - Profil utilisateur
- `POST /api/v1/auth/logout` - Déconnexion

#### Sites Touristiques
- `GET /api/v1/sites` - Liste des sites (avec filtres)
- `GET /api/v1/sites/:id` - Détails d'un site
- `POST /api/v1/sites` - Créer un site (admin)
- `PUT /api/v1/sites/:id` - Modifier un site (admin)
- `DELETE /api/v1/sites/:id` - Supprimer un site (admin)

#### Itinéraires
- `GET /api/v1/itineraires` - Liste des itinéraires
- `GET /api/v1/itineraires/:id` - Détails d'un itinéraire
- `POST /api/v1/itineraires` - Créer un itinéraire
- `PUT /api/v1/itineraires/:id` - Modifier un itinéraire
- `DELETE /api/v1/itineraires/:id` - Supprimer un itinéraire

#### Culture
- `GET /api/v1/culture` - Informations culturelles
- `POST /api/v1/culture` - Ajouter une information culturelle (admin)

## 🧪 Tests

### Tests Backend

```bash
cd backend

# Exécution des tests
npm test

# Tests avec couverture
npm run test:coverage
```

### Tests Frontend

```bash
cd frontend

# Exécution des tests
flutter test

# Tests avec couverture (nécessite flutter_test_coverage)
flutter test --coverage
```

## 🚀 Déploiement

### Backend

#### Render (recommandé)
1. Créez un compte sur [Render](https://render.com)
2. Connectez votre repository GitHub
3. Créez un service Web
4. Configurez les variables d'environnement
5. Déployez

#### Autres options
- Heroku
- Railway
- DigitalOcean App Platform

### Frontend

#### Google Play Store / App Store
```bash
cd frontend

# Build Android APK
flutter build apk --release

# Build iOS (macOS uniquement)
flutter build ios --release
```

#### Web
```bash
# Build pour le web
flutter build web --release

# Déploiement sur Firebase Hosting
firebase deploy
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Pushez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

### Guidelines
- Respectez les conventions de code
- Ajoutez des tests pour les nouvelles fonctionnalités
- Mettez à jour la documentation
- Utilisez des commits descriptifs

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👤 Auteur

**Alix Carine VEBAMBA**
- Email : [alixcarinestudies@gmail.com]
- LinkedIn : [https://www.linkedin.com/in/alix-carine-vebamba-83a0a42a0?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app]
- GitHub : [https://github.com/alixHub-ux]

## 🙏 Remerciements

- Équipe Flutter pour le framework incroyable
- Communauté Node.js pour les outils robustes
- MongoDB pour la base de données flexible
- Organisation Internationale de la Francophonie (OIF)
- Formateurs DCLIC

---

⭐ Si ce projet vous plaît, n'hésitez pas à lui donner une étoile sur GitHub !