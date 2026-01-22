const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const colors = require('colors');
const path = require('path');
const routes = require('./routes');
const errorMiddleware = require('./middlewares/error.middleware');

const app = express();

// ============================================
// MIDDLEWARES DE SÉCURITÉ
// ============================================

// Helmet - Protection des headers HTTP
//  Configuration adaptée pour permettre le chargement des images
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" },
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:", "http:"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
    },
  },
}));

// CORS - Configuration
app.use(cors({
  origin: process.env.CORS_ORIGIN?.split(',') || '*',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Rate Limiting - Protection contre les abus
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000,
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
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
// FICHIERS STATIQUES
// ============================================

//  ADAPTATION : Servir depuis le dossier 'uploads' à la racine du backend
// Le chemin part de app.js qui est dans src/, donc on remonte d'un niveau avec '../uploads'
app.use('/uploads', express.static(path.join(__dirname, '..', 'uploads'), {
  maxAge: '7d',
  etag: true,
  lastModified: true,
  setHeaders: (res, filePath) => {
    // Headers pour les images
    if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
      res.setHeader('Content-Type', 'image/jpeg');
    } else if (filePath.endsWith('.png')) {
      res.setHeader('Content-Type', 'image/png');
    } else if (filePath.endsWith('.webp')) {
      res.setHeader('Content-Type', 'image/webp');
    } else if (filePath.endsWith('.svg')) {
      res.setHeader('Content-Type', 'image/svg+xml');
    }
    
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
  }
}));

//  Route de test pour vérifier les images
app.get('/test-images', (req, res) => {
  const fs = require('fs');
  const uploadsPath = path.join(__dirname, '..', 'uploads');
  
  let html = `
    <!DOCTYPE html>
    <html>
    <head>
      <title>Test Images - Bãng Zĩiga</title>
      <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
        h1 { color: #344C3D; }
        h2 { color: #738A6E; border-bottom: 2px solid #8EA58C; padding-bottom: 10px; }
        .image-container { 
          background: white; 
          margin: 20px 0; 
          padding: 20px; 
          border-radius: 8px; 
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        img { 
          max-width: 100%; 
          height: auto; 
          border-radius: 4px; 
          box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        code { 
          background: #f0f0f0; 
          padding: 4px 8px; 
          border-radius: 4px; 
          font-family: monospace;
          color: #344C3D;
        }
        .info { 
          background: #e8f5e9; 
          padding: 15px; 
          border-radius: 4px; 
          margin: 20px 0;
          border-left: 4px solid #8EA58C;
        }
        .error { 
          background: #ffebee; 
          padding: 15px; 
          border-radius: 4px; 
          margin: 20px 0;
          border-left: 4px solid #f44336;
        }
        .success { 
          background: #e8f5e9; 
          padding: 15px; 
          border-radius: 4px; 
          margin: 20px 0;
          border-left: 4px solid #4caf50;
        }
      </style>
    </head>
    <body>
      <h1> Test des Images - Bãng Zĩiga</h1>
  `;
  
  // Vérifier si le dossier uploads existe
  if (!fs.existsSync(uploadsPath)) {
    html += `
      <div class="error">
        <h3> Dossier 'uploads' introuvable</h3>
        <p><strong>Chemin attendu :</strong> <code>${uploadsPath}</code></p>
        <p><strong>Chemin actuel :</strong> <code>${__dirname}</code></p>
        <p><strong>Créez le dossier avec :</strong></p>
        <code>mkdir -p uploads/sites uploads/itineraires</code>
      </div>
    `;
    return res.send(html + '</body></html>');
  }
  
  html += `
    <div class="success">
      <p> Dossier uploads trouvé : <code>${uploadsPath}</code></p>
      <p> URL de base : <code>${req.protocol}://${req.get('host')}/uploads/</code></p>
    </div>
  `;
  
  // Lister les images des sites
  const sitesPath = path.join(uploadsPath, 'sites');
  if (fs.existsSync(sitesPath)) {
    html += '<h2>📍 Images des Sites</h2>';
    const siteImages = fs.readdirSync(sitesPath).filter(f => f.match(/\.(jpg|jpeg|png|webp|svg)$/i));
    
    if (siteImages.length > 0) {
      html += `<div class="info"> ${siteImages.length} image(s) trouvée(s)</div>`;
      siteImages.forEach(img => {
        const imageUrl = `/uploads/sites/${img}`;
        const fullUrl = `${req.protocol}://${req.get('host')}${imageUrl}`;
        html += `
          <div class="image-container">
            <h3> ${img}</h3>
            <img src="${imageUrl}" alt="${img}" style="max-width: 600px;" />
            <p><strong>URL relative :</strong> <code>${imageUrl}</code></p>
            <p><strong>URL complète :</strong> <code>${fullUrl}</code></p>
          </div>
        `;
      });
    } else {
      html += '<div class="error"> Aucune image trouvée dans /uploads/sites/</div>';
    }
  } else {
    html += '<div class="error"> Dossier /uploads/sites/ introuvable</div>';
  }
  
  // Lister les images des itinéraires
  const itinerairesPath = path.join(uploadsPath, 'itineraires');
  if (fs.existsSync(itinerairesPath)) {
    html += '<h2> Images des Itinéraires</h2>';
    const itineraireImages = fs.readdirSync(itinerairesPath).filter(f => f.match(/\.(jpg|jpeg|png|webp|svg)$/i));
    
    if (itineraireImages.length > 0) {
      html += `<div class="info"> ${itineraireImages.length} image(s) trouvée(s)</div>`;
      itineraireImages.forEach(img => {
        const imageUrl = `/uploads/itineraires/${img}`;
        const fullUrl = `${req.protocol}://${req.get('host')}${imageUrl}`;
        html += `
          <div class="image-container">
            <h3> ${img}</h3>
            <img src="${imageUrl}" alt="${img}" style="max-width: 600px;" />
            <p><strong>URL relative :</strong> <code>${imageUrl}</code></p>
            <p><strong>URL complète :</strong> <code>${fullUrl}</code></p>
          </div>
        `;
      });
    } else {
      html += '<div class="error"> Aucune image trouvée dans /uploads/itineraires/</div>';
    }
  } else {
    html += '<div class="error"> Dossier /uploads/itineraires/ introuvable</div>';
  }
  
  html += '</body></html>';
  res.send(html);
});

// ============================================
// ROUTES
// ============================================

app.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: ' Bienvenue sur l\'API Bãng Zĩiga',
    description: 'API REST pour l\'application de tourisme local',
    documentation: `${req.protocol}://${req.get('host')}/api/${process.env.API_VERSION}`,
    version: process.env.API_VERSION,
    status: 'Opérationnelle',
    endpoints: {
      health: '/health',
      testImages: '/test-images',
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