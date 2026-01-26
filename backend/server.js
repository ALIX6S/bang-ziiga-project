require('dotenv').config();
const app = require('./src/app');
const connectDB = require('./src/config/database');
const colors = require('colors');
const { getLocalIpAddress } = require('./src/utils/network');

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

// ============================================
// FONCTION DE DÉMARRAGE DU SERVEUR
// ============================================

const startServer = async () => {
  try {
    // 1. Connexion à MongoDB
    await connectDB();

    // 2. Démarrage du serveur Express
    const server = app.listen(PORT, HOST, () => {
      const localIp = getLocalIpAddress();
      
      console.log('\n' + '='.repeat(70).cyan);
      console.log('SERVEUR DÉMARRÉ AVEC SUCCÈS'.green.bold);
      console.log('='.repeat(70).cyan);
      console.log(` Port: ${PORT}`.cyan);
      console.log(` Environnement: ${process.env.NODE_ENV}`.cyan);
      console.log('');
      
      if (process.env.NODE_ENV === 'production') {
        console.log(' MODE PRODUCTION'.green.bold);
        console.log(` API URL: ${process.env.RENDER_EXTERNAL_URL || 'https://bang-ziiga-project.onrender.com'}`.cyan);
      } else {
        console.log(' MODE DÉVELOPPEMENT'.yellow.bold);
        console.log('');
        console.log(' POUR FLUTTER - Utiliser cette URL:'.yellow.bold);
        console.log(`   http://${localIp}:${PORT}/api/${process.env.API_VERSION}`.green.bold);
        console.log('');
        console.log(` URL Local: http://localhost:${PORT}`.cyan);
        console.log(` URL Réseau: http://${localIp}:${PORT}`.cyan);
      }
      
      console.log(` API Documentation: /api/${process.env.API_VERSION}`.cyan);
      console.log(` Health Check: /health`.cyan);
      console.log('='.repeat(70).cyan + '\n');
      
      console.log(' Prêt à recevoir des requêtes !'.green.bold);
      console.log(' Appuyez sur Ctrl+C pour arrêter le serveur\n'.yellow);
    });

    // ============================================
    // GESTION DES ERREURS NON CAPTURÉES
    // ============================================

    // Erreur de rejection de promesse non gérée
    process.on('unhandledRejection', (err) => {
      console.error('\n ERREUR: Unhandled Promise Rejection'.red.bold);
      console.error(err);
      console.log(' Arrêt du serveur...'.yellow);
      server.close(() => {
        process.exit(1);
      });
    });

    // Erreur d'exception non capturée
    process.on('uncaughtException', (err) => {
      console.error('\n ERREUR: Uncaught Exception'.red.bold);
      console.error(err);
      console.log(' Arrêt du serveur...'.yellow);
      process.exit(1);
    });

    // ============================================
    // GESTION DE L'ARRÊT PROPRE DU SERVEUR
    // ============================================

    // SIGINT (Ctrl+C)
    process.on('SIGINT', () => {
      console.log('\n  Signal SIGINT reçu'.yellow);
      gracefulShutdown(server, 'SIGINT');
    });

    // SIGTERM (commande kill)
    process.on('SIGTERM', () => {
      console.log('\n  Signal SIGTERM reçu'.yellow);
      gracefulShutdown(server, 'SIGTERM');
    });

  } catch (error) {
    console.error('\n ERREUR DE DÉMARRAGE DU SERVEUR:'.red.bold);
    console.error(error);
    process.exit(1);
  }
};

// ============================================
// FONCTION D'ARRÊT GRACIEUX
// ============================================

const gracefulShutdown = (server, signal) => {
  console.log(`\n Arrêt gracieux du serveur (${signal})...`.yellow);
  
  server.close(() => {
    console.log(' Serveur HTTP fermé'.green);
    console.log(' Fermeture des connexions à la base de données...'.yellow);
    
    // Fermeture de la connexion MongoDB
    const mongoose = require('mongoose');
    mongoose.connection.close().then(() => {
      console.log(' Connexion MongoDB fermée'.green);
      console.log(' Au revoir !\n'.cyan.bold);
      process.exit(0);
    }).catch((err) => {
      console.error(' Erreur lors de la fermeture MongoDB:'.red, err.message);
      process.exit(1);
    });
  });

  // Forcer l'arrêt après 10 secondes si le serveur ne se ferme pas
  setTimeout(() => {
    console.error('  Impossible de fermer proprement, arrêt forcé'.red);
    process.exit(1);
  }, 10000);
};

// ============================================
// LANCEMENT DU SERVEUR
// ============================================

startServer();