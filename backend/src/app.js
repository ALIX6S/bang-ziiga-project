const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const path = require('path');
const routes = require('./routes');
const errorMiddleware = require('./middlewares/error.middleware');

const app = express();

// ============================================
// MIDDLEWARES DE SÉCURITÉ
// ============================================

// ⚠️ IMPORTANT : Helmet AVANT les routes statiques
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" },
  contentSecurityPolicy: false, // Désactiver temporairement pour debug
}));

// CORS
app.use(cors({
  origin: '*', // Autoriser tout pour le moment
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Rate Limiting (SAUF pour /uploads)
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000,
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  skip: (req) => req.path.startsWith('/uploads'), // ← NE PAS limiter les uploads
  message: {
    success: false,
    message: 'Trop de requêtes depuis cette IP, veuillez réessayer plus tard.',
  },
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', limiter);

// ============================================
// MIDDLEWARES DE PARSING
// ============================================

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(compression());

// ============================================
// LOGS
// ============================================

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined'));
}

// ============================================
// ⚠️ IMPORTANT : FICHIERS STATIQUES EN PREMIER
// ============================================

// Middleware de logging pour debug
app.use('/uploads', (req, res, next) => {
  console.log(`📸 Image demandée: ${req.path}`);
  next();
});

// Servir les fichiers statiques
// Le chemin depuis src/app.js vers uploads/ est '../uploads'
app.use('/uploads', express.static(path.join(__dirname, '..', 'uploads'), {
  maxAge: '7d',
  etag: true,
  lastModified: true,
  setHeaders: (res, filePath) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
    res.setHeader('Cache-Control', 'public, max-age=604800');
    
    // Type MIME selon l'extension
    if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
      res.setHeader('Content-Type', 'image/jpeg');
    } else if (filePath.endsWith('.png')) {
      res.setHeader('Content-Type', 'image/png');
    } else if (filePath.endsWith('.webp')) {
      res.setHeader('Content-Type', 'image/webp');
    }
  }
}));

// Route de test des images
app.get('/test-uploads', (req, res) => {
  const fs = require('fs');
  const uploadsPath = path.join(__dirname, '..', 'uploads');
  
  let result = {
    uploadsPath: uploadsPath,
    exists: fs.existsSync(uploadsPath),
    contents: {}
  };
  
  if (result.exists) {
    try {
      // Lister sites
      const sitesPath = path.join(uploadsPath, 'sites');
      if (fs.existsSync(sitesPath)) {
        result.contents.sites = fs.readdirSync(sitesPath);
      }
      
      // Lister itineraires
      const itinerairesPath = path.join(uploadsPath, 'itineraires');
      if (fs.existsSync(itinerairesPath)) {
        result.contents.itineraires = fs.readdirSync(itinerairesPath);
      }
    } catch (error) {
      result.error = error.message;
    }
  }
  
  res.json(result);
});

// ============================================
// ROUTES
// ============================================

app.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: '🏛️ Bienvenue sur l\'API Bãng Zĩiga',
    description: 'API REST pour l\'application de tourisme local',
    version: process.env.API_VERSION,
    status: 'Opérationnelle ✅',
    endpoints: {
      health: '/health',
      testImages: '/test-images',
      testUploads: '/test-uploads', // ← Nouveau
      api: `/api/${process.env.API_VERSION}`,
      uploads: '/uploads'
    }
  });
});

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

// Routes API principales - ⚠️ APRÈS les routes statiques
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

module.exports = app;