# Bãng Zĩiga - Application Mobile de Tourisme Local

**« Découvre le pays »**

Application mobile Flutter de découverte touristique et culturelle développée dans le cadre de la formation DCLIC - Développement Mobile Niveau Approfondi.

---

## À propos

Bãng Zĩiga est une application mobile permettant de découvrir les sites touristiques, la culture locale et des itinéraires de visite. Elle s'adresse aux touristes et aux habitants souhaitant mieux connaître leur territoire.

### Fonctionnalités principales

- **Authentification utilisateur** (inscription, connexion, déconnexion)
- **Guide des sites touristiques** (liste, détails, recherche)
- **Itinéraires touristiques** (parcours prédéfinis avec sites inclus)
- **Informations culturelles** (traditions, gastronomie, événements)
- **Profil utilisateur** (gestion du compte)

---

## Technologies Utilisées

- **Framework**: Flutter 3.x
- **Langage**: Dart
- **Gestion d'état**: Provider
- **Communication API**: HTTP
- **Stockage local**: SharedPreferences
- **Images**: CachedNetworkImage
- **Typographie**: Google Fonts

---

## Installation et Démarrage

### Prérequis

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Émulateur Android/iOS ou appareil physique

### Installation

```bash
# Cloner le projet
git clone https://github.com/alixHub-ux/bang-ziiga-project.git
cd bang_ziigaa-project
cd frontend

# Installer les dépendances
flutter pub get

# Vérifier l'installation
flutter doctor

# Lancer l'application
flutter run
```

### Configuration de l'API

Modifier l'URL de l'API dans `lib/core/constants/api_constants.dart` :

```dart
static const String baseUrl = 'https://bang-ziiga-project.onrender.com/api/v1';
```

---

## Structure du Projet

```
lib/
├── core/                    # Configuration globale
│   ├── config/             # Thème, couleurs
│   ├── constants/          # Constantes API
│   └── widgets/            # Widgets réutilisables
├── data/
│   └── repositories/       # Repositories (accès données)
├── models/                 # Modèles de données
├── providers/              # Gestion d'état
├── screens/                # Écrans de l'application
├── services/               # Services (API, Storage)
├── utils/                  # Utilitaires
└── main.dart              # Point d'entrée
```

---

## Palette de Couleurs - Sage Green

- **Sage Hint** `#BFCFBB` - Arrière-plans
- **Mint** `#BFCFBB` - Conteneurs
- **Sage** `#8EA58C` - Éléments interactifs
- **Moss** `#738A6E` - Titres
- **Evergreen** `#344C3D` - Boutons principaux

---

## Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter drive --target=test_driver/app.dart
```

---

## Build et Déploiement

### Android (APK)

```bash
# Build APK de debug
flutter build apk --debug

# Build APK de release
flutter build apk --release

# Build App Bundle (pour Play Store)
flutter build appbundle --release
```

### iOS (IPA)

```bash
# Build iOS
flutter build ios --release
```

---

## ‍ Développeur

**Nom**: Alix Carine VEBAMBA
**Formation**: DCLIC - Développement Mobile Niveau Approfondi
**Date**: Janvier 2026

---

## Licence

Ce projet est développé dans un cadre pédagogique.

---

## Remerciements

- Organisation Internationale de la Francophonie (OIF)
- Formateurs DCLIC
- Communauté Flutter

---

## Support

Pour toute question ou problème :
- Email: alixcarinestudies@gmail.com
- Issues GitHub: https://github.com/alixHub-ux/bang-ziiga-project.git
