const express = require('express');
const router = express.Router();

const authRoutes = require('./auth.routes');
const sitesRoutes = require('./sites.routes');
const itinerairesRoutes = require('./itineraires.routes');
const cultureRoutes = require('./culture.routes');

router.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Bienvenue sur l\'API Bãng Zĩiga - Tourisme Local',
    version: process.env.API_VERSION || 'v1',
    documentation: {
      auth: {
        register: {
          method: 'POST',
          endpoint: '/auth/register',
          description: 'Inscription d\'un nouvel utilisateur',
          access: 'Public',
        },
        login: {
          method: 'POST',
          endpoint: '/auth/login',
          description: 'Connexion utilisateur',
          access: 'Public',
        },
        me: {
          method: 'GET',
          endpoint: '/auth/me',
          description: 'Obtenir l\'utilisateur connecté',
          access: 'Private',
        },
        logout: {
          method: 'POST',
          endpoint: '/auth/logout',
          description: 'Déconnexion',
          access: 'Private',
        },
      },
      sites: {
        getAll: {
          method: 'GET',
          endpoint: '/sites',
          description: 'Récupérer tous les sites',
          access: 'Public',
          queryParams: '?category=Monument&search=keyword&isFeatured=true',
        },
        getFeatured: {
          method: 'GET',
          endpoint: '/sites/featured',
          description: 'Récupérer les sites phares',
          access: 'Public',
        },
        getById: {
          method: 'GET',
          endpoint: '/sites/:id',
          description: 'Récupérer un site par ID',
          access: 'Public',
        },
        create: {
          method: 'POST',
          endpoint: '/sites',
          description: 'Créer un nouveau site',
          access: 'Private (Admin)',
        },
      },
      itineraires: {
        getAll: {
          method: 'GET',
          endpoint: '/itineraires',
          description: 'Récupérer tous les itinéraires',
          access: 'Public',
          queryParams: '?difficulty=facile',
        },
        getById: {
          method: 'GET',
          endpoint: '/itineraires/:id',
          description: 'Récupérer un itinéraire par ID',
          access: 'Public',
        },
      },
      culture: {
        getAll: {
          method: 'GET',
          endpoint: '/culture',
          description: 'Récupérer toutes les infos culturelles',
          access: 'Public',
          queryParams: '?type=tradition',
        },
        getByType: {
          method: 'GET',
          endpoint: '/culture/:type',
          description: 'Récupérer par type (tradition, gastronomie, événement)',
          access: 'Public',
        },
      },
    },
    status: 'API opérationnelle',
  });
});

router.use('/auth', authRoutes);
router.use('/sites', sitesRoutes);
router.use('/itineraires', itinerairesRoutes);
router.use('/culture', cultureRoutes);

module.exports = router;