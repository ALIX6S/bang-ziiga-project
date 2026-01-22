const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const colors = require('colors');

const routes = require('./routes');
const errorMiddleware = require('./middlewares/error.middleware');

const app = express();

// ============================================
// MIDDLEWARES DE SÉCURITÉ
// ============================================

// Helmet - Protection des headers HTTP
app.use(helmet());

// CORS - Configuration
app.use(cors({
  origin: process.env.CORS_ORIGIN?.split(',') || '*',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Rate Limiting - Protection contre les abus
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // 100 requêtes max
  message: {
    success: false,
    message: 'Trop de requêtes depuis cette IP, veuillez réessayer plus tard.',
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Appliquer le rate limiting à toutes les routes API
app.use('/api/', limiter);

// ============================================
// MIDDLEWARES DE PARSING
// ============================================

// Parser JSON avec limite de taille
app.use(express.json({ limit: '10mb' }));

// Parser les données URL encodées
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Compression des réponses
app.use(compression());

// ============================================
// LOGS
// ============================================

// Morgan - Logs des requêtes HTTP en mode développement
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  // En production, utiliser un format plus compact
  app.use(morgan('combined'));
}

// ============================================
// FICHIERS STATIQUES
// ============================================

// Servir les fichiers uploadés
app.use('/uploads', express.static('uploads'));

// ============================================
// ROUTES
// ============================================

// Route racine - Redirection vers l'API
app.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: ' Bienvenue sur l\'API Bãng Zĩiga',
    description: 'API REST pour l\'application de tourisme local',
    documentation: `${req.protocol}://${req.get('host')}/api/${process.env.API_VERSION}`,
    version: process.env.API_VERSION,
    status: 'Opérationnelle ',
  });
});

// Route de santé - Health check
app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    status: 'healthy',
    message: 'API Bãng Zĩiga opérationnelle',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV,
    uptime: process.uptime(),
  });
});

// Routes API principales
app.use(`/api/${process.env.API_VERSION}`, routes);

// ============================================
// GESTION DES ERREURS 404
// ============================================

app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} non trouvée`,
    suggestion: `Consultez la documentation à ${req.protocol}://${req.get('host')}/api/${process.env.API_VERSION}`,
  });
});

// ============================================
// MIDDLEWARE DE GESTION DES ERREURS
// ============================================

app.use(errorMiddleware);

// ============================================
// EXPORT
// ============================================

module.exports = app;