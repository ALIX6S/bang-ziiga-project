const mongoose = require('mongoose');
const colors = require('colors');

const connectDB = async () => {
  try {
    const options = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    };

    const conn = await mongoose.connect(process.env.MONGODB_URI, options);

    console.log(` MongoDB Connecté: ${conn.connection.host}`.cyan.bold);
    console.log(` Base de données: ${conn.connection.name}`.cyan);

    // Gestion des événements de connexion
    mongoose.connection.on('connected', () => {
      console.log(' Mongoose connecté à MongoDB'.green);
    });

    mongoose.connection.on('error', (err) => {
      console.error(' Erreur de connexion Mongoose:'.red, err);
    });

    mongoose.connection.on('disconnected', () => {
      console.log('  Mongoose déconnecté de MongoDB'.yellow);
    });

    // Fermeture propre de la connexion
    process.on('SIGINT', async () => {
      await mongoose.connection.close();
      console.log(' Connexion MongoDB fermée suite à l\'arrêt de l\'application'.yellow);
      process.exit(0);
    });

  } catch (error) {
    console.error(` Erreur de connexion à MongoDB:`.red.bold, error.message);
    process.exit(1);
  }
};

module.exports = connectDB;