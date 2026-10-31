# Fonctionnalités

## Authentification

Inscription et connexion par email et mot de passe, session portée par un jeton JWT
conservé sur l'appareil. Les mots de passe sont hachés avec bcrypt. Deux rôles
existent, `user` et `admin`, ce dernier seul autorisé à écrire dans le catalogue.

## Sites touristiques

Catalogue des sites avec image, catégorie, localisation et description. Recherche
textuelle, filtrage par catégorie, mise en avant des sites phares sur l'accueil et
fiche de détail par site. Les catégories couvertes par le jeu de données sont
Monument, Musée, Parc, Site Historique et Lieu Culturel.

## Itinéraires

Parcours thématiques reliant plusieurs sites, avec durée, difficulté, distance et
la liste ordonnée des étapes. La fiche de détail affiche chaque étape avec le site
correspondant.

## Culture locale

Trois sections, Traditions, Gastronomie et Événements, présentant les repères
culturels du pays.

## Profil

Identité du compte connecté et déconnexion.
