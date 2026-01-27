const mongoose = require('mongoose');
const colors = require('colors');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI);

    console.log(`MongoDB connecté: ${conn.connection.host}`.cyan.bold);
    console.log(`Base de données: ${conn.connection.name}`.cyan);

    mongoose.connection.on('connected', () => {
      console.log('Mongoose connecté à MongoDB'.green);
    });

    mongoose.connection.on('error', (err) => {
      console.error('Erreur de connexion Mongoose:'.red, err);
    });

    mongoose.connection.on('disconnected', () => {
      console.log('Mongoose déconnecté de MongoDB'.yellow);
    });

    process.on('SIGINT', async () => {
      await mongoose.connection.close();
      console.log('Connexion MongoDB fermée suite à l\'arrêt de l\'application'.yellow);
      process.exit(0);
    });

  } catch (error) {
    console.error('Erreur de connexion à MongoDB:'.red.bold, error.message);
    process.exit(1);
  }
};

module.exports = connectDB;
