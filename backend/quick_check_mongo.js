// quick_check_mongo.js
const { MongoClient } = require('mongodb');
require('dotenv').config();

async function quickCheck() {
  if (!process.env.MONGODB_URI) {
    console.error('❌ MONGODB_URI non trouvé dans .env');
    return;
  }

  const client = new MongoClient(process.env.MONGODB_URI);

  try {
    await client.connect();
    console.log('✅ Connexion MongoDB réussie');
    await client.close();
  } catch (error) {
    console.error('❌ Erreur de connexion MongoDB:', error.message);
  }
}

quickCheck();