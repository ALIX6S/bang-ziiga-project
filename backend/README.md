#  Bãng Zĩiga - Backend API

API REST pour l'application mobile de tourisme local Bãng Zĩiga.

---

##  Démarrage Rapide

### Prérequis

- Node.js >= 18.0.0
- MongoDB >= 6.0
- npm >= 9.0.0

### Installation

```bash
# 1. Cloner le projet
git clone <url-du-repo>
cd backend

# 2. Installer les dépendances
npm install

# 3. Configurer les variables d'environnement
cp .env.example .env
# Éditer le fichier .env avec vos configurations

# 4. Démarrer MongoDB (si en local)
mongod

# 5. Peupler la base de données
npm run seed

# 6. Lancer le serveur en développement
npm run dev
```

Le serveur démarre sur `http://localhost:3000`

---

##  Structure du Projet

```
backend/
├── src/
│   ├── config/          # Configurations (DB, etc.)
│   ├── models/          # Modèles Mongoose
│   ├── controllers/     # Logique métier
│   ├── routes/          # Routes Express
│   ├── middlewares/     # Middlewares
│   ├── services/        # Services métier
│   ├── utils/           # Utilitaires
│   └── seeders/         # Données de test
├── uploads/             # Fichiers uploadés
├── .env                 # Variables d'environnement
├── server.js            # Point d'entrée
└── package.json         # Dépendances
```

---

##  Endpoints API

### Base URL
```
http://localhost:3000/api/v1
```

### Authentification

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| POST | `/auth/register` | Inscription | Public |
| POST | `/auth/login` | Connexion | Public |
| GET | `/auth/me` | Utilisateur connecté | Privé |
| POST | `/auth/logout` | Déconnexion | Privé |

### Sites Touristiques

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| GET | `/sites` | Liste des sites | Public |
| GET | `/sites/featured` | Sites phares | Public |
| GET | `/sites/:id` | Détail d'un site | Public |
| POST | `/sites` | Créer un site | Admin |
| PUT | `/sites/:id` | Modifier un site | Admin |
| DELETE | `/sites/:id` | Supprimer un site | Admin |

**Query Params:**
- `?category=Monument` - Filtrer par catégorie
- `?search=keyword` - Recherche textuelle
- `?isFeatured=true` - Sites phares uniquement

### Itinéraires

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| GET | `/itineraires` | Liste des itinéraires | Public |
| GET | `/itineraires/:id` | Détail d'un itinéraire | Public |
| POST | `/itineraires` | Créer un itinéraire | Admin |
| PUT | `/itineraires/:id` | Modifier un itinéraire | Admin |
| DELETE | `/itineraires/:id` | Supprimer un itinéraire | Admin |

**Query Params:**
- `?difficulty=facile` - Filtrer par difficulté (facile, moyen, intense)

### Culture

| Méthode | Endpoint | Description | Accès |
|---------|----------|-------------|-------|
| GET | `/culture` | Liste des infos culturelles | Public |
| GET | `/culture/:type` | Par type (tradition, gastronomie, événement) | Public |
| POST | `/culture` | Créer une info culturelle | Admin |
| PUT | `/culture/:id` | Modifier une info culturelle | Admin |
| DELETE | `/culture/:id` | Supprimer une info culturelle | Admin |

---

##  Authentification

L'API utilise JWT (JSON Web Tokens) pour l'authentification.

### Obtenir un token

```bash
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "admin@bangziiga.com",
  "password": "admin123"
}
```

### Utiliser le token

```bash
GET /api/v1/auth/me
Authorization: Bearer <votre_token_ici>
```

---

##  Tests

### Tester avec cURL

```bash
# Health check
curl http://localhost:3000/health

# Liste des sites
curl http://localhost:3000/api/v1/sites

# Connexion
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@bangziiga.com","password":"admin123"}'
```

### Tester avec Postman

1. Importer la collection Postman (si disponible)
2. Configurer la variable d'environnement `baseUrl` = `http://localhost:3000/api/v1`
3. Tester les endpoints

---

##  Base de Données

### MongoDB Local

```bash
# Démarrer MongoDB
mongod

# Se connecter avec Mongo Shell
mongosh

# Utiliser la base de données
use bang_ziiga

# Voir les collections
show collections
```

### MongoDB Atlas (Cloud)

1. Créer un compte sur [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Créer un cluster gratuit
3. Obtenir l'URI de connexion
4. Mettre à jour `.env` avec l'URI

---

##  Scripts NPM

| Script | Commande | Description |
|--------|----------|-------------|
| Développement | `npm run dev` | Lance le serveur avec nodemon |
| Production | `npm start` | Lance le serveur en production |
| Seed | `npm run seed` | Peuple la BDD avec des données de test |
| Clear | `npm run seed:clear` | Vide la base de données |
| Tests | `npm test` | Lance les tests |

---

##  Variables d'Environnement

Fichier `.env` requis :

```env
NODE_ENV=development
PORT=3000
API_VERSION=v1
MONGODB_URI=mongodb://localhost:27017/bang_ziiga
JWT_SECRET=votre_cle_secrete_super_longue
JWT_EXPIRES_IN=7d
CORS_ORIGIN=http://localhost:3000
```

---

##  Compte Admin par Défaut

Après avoir exécuté `npm run seed` :

- **Email:** admin@bangziiga.com
- **Password:** admin123

 **IMPORTANT:** Changez ce mot de passe en production !

---

##  Gestion des Erreurs

L'API retourne des réponses JSON standardisées :

### Succès
```json
{
  "success": true,
  "data": { ... }
}
```

### Erreur
```json
{
  "success": false,
  "message": "Description de l'erreur"
}
```

### Codes HTTP

- `200` - OK
- `201` - Créé
- `400` - Mauvaise requête
- `401` - Non autorisé
- `403` - Interdit
- `404` - Non trouvé
- `500` - Erreur serveur

---

##  Licence

Ce projet est développé dans un cadre pédagogique.

---

##  Support

Pour toute question : [votre-email]