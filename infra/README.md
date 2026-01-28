# Infra Docker : Bãng Zĩiga

Tout tourne dans des conteneurs : aucun Node, MongoDB, Flutter ni SDK Android à installer.

**Prérequis** : Docker (avec Compose v2) et `make`. Pour le téléphone : `adb` + Débogage USB activé.

## Démarrage rapide

```bash
cd infra
make up      # MongoDB + API  -> http://localhost:3000   (health : /health)
make seed    # données de démo (6 sites, 3 itinéraires, culture, comptes)
make apk     # APK -> infra/out/bang-ziiga.apk (1er build : ~15 min, téléchargements)
make phone   # installe + lance sur le téléphone branché en USB
make test    # flutter analyze + tests
```

Comptes de démo : `admin@bangziiga.com` / `admin123`, `alix.vebamba@bangziiga.com` / `Alix2026!`.

## Contenu

| Fichier | Rôle |
|---|---|
| `docker-compose.yml` | mongo, api, `seed` (profil `tools`), `mobile-build` (profil `mobile`) |
| `backend/Dockerfile` | image de l'API (Node 20 alpine) |
| `backend/localize-images.js` | pointe les images de la base vers `/uploads` (mode hors ligne) |
| `mobile/Dockerfile` | Flutter + Android SDK + NDK |
| `mobile/build-apk.sh` | compile l'APK sur une copie, URL de l'API remplacée par `APP_API_URL` |
| `scripts/install-on-phone.sh` | `adb reverse tcp:3000` + install + lancement |

## Comment le téléphone joint l'API

`adb reverse tcp:3000 tcp:3000` : `localhost:3000` sur le téléphone pointe vers l'API du PC.
Pas d'IP à configurer, Wi-Fi inutile. Pour un autre backend :
`APP_API_URL=https://mon-serveur/api/v1 make apk`.

## Autres commandes

```bash
make logs    # logs de l'API
make down    # arrêt (données conservées)
make clean   # tout supprimer : conteneurs, données, caches de build, images
```

Variables optionnelles : `API_PORT`, `JWT_SECRET`, `APP_API_URL`.
