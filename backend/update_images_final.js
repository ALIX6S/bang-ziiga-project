// update_images_final.js
const { MongoClient } = require('mongodb');
require('dotenv').config();

const BASE_URL = 'https://bang-ziiga-project.onrender.com';

async function updateImagesFinal() {
  const client = new MongoClient(process.env.MONGODB_URI);
  
  try {
    await client.connect();
    console.log('✅ Connecté à MongoDB Atlas\n');
    
    const db = client.db(process.env.DB_NAME || 'test');
    
    // ============================================
    // SITES
    // ============================================
    console.log('📍 MISE À JOUR DES SITES:\n');
    
    const sites = await db.collection('sites').find({}).sort({ name: 1 }).toArray();
    
    // Mapping manuel basé sur vos images
    const imageMapping = {
      'Musée National du Burkina Faso': 'national.jpeg',
      'Monument des Héros': 'monument.jpeg',
      'Cathédrale': 'cathedrale.jpeg',
      'Carrières de granit': 'granite.jpeg',
      'Parc Bangr': 'parc_bangre.jpeg',
      'Marché Rood Woko': 'rodo_woko.jpeg',
    };
    
    for (const site of sites) {
      // Chercher une correspondance dans le mapping
      let imageFile = null;
      
      for (const [key, value] of Object.entries(imageMapping)) {
        if (site.name.includes(key) || key.includes(site.name.substring(0, 10))) {
          imageFile = value;
          break;
        }
      }
      
      // Si pas de correspondance, utiliser la première image disponible
      if (!imageFile) {
        const availableImages = ['national.jpeg', 'monument.jpeg', 'cathedrale.jpeg', 'granite.jpeg', 'parc_bangre.jpeg', 'rodo_woko.jpeg'];
        imageFile = availableImages[Math.floor(Math.random() * availableImages.length)];
      }
      
      const imageUrl = `${BASE_URL}/uploads/sites/${imageFile}`;
      
      await db.collection('sites').updateOne(
        { _id: site._id },
        {
          $set: {
            image: imageUrl,
            imageUrl: imageUrl,
            imageFilename: imageFile,
            updatedAt: new Date()
          }
        }
      );
      
      console.log(`✓ ${site.name.padEnd(45)} → ${imageFile}`);
    }
    
    // ============================================
    // ITINÉRAIRES
    // ============================================
    console.log('\n🗺️  MISE À JOUR DES ITINÉRAIRES:\n');
    
    const itineraires = await db.collection('itineraires').find({}).sort({ name: 1 }).toArray();
    const itineraireFiles = ['laongo.jpeg', 'love_ouaga.jpeg', 'parc.jpg'];
    
    for (let i = 0; i < itineraires.length; i++) {
      const itineraire = itineraires[i];
      const imageFile = itineraireFiles[i % itineraireFiles.length];
      const imageUrl = `${BASE_URL}/uploads/itineraires/${imageFile}`;
      
      await db.collection('itineraires').updateOne(
        { _id: itineraire._id },
        {
          $set: {
            image: imageUrl,
            imageUrl: imageUrl,
            imageFilename: imageFile,
            updatedAt: new Date()
          }
        }
      );
      
      console.log(`✓ ${itineraire.name.padEnd(45)} → ${imageFile}`);
    }
    
    console.log('\n✅ MISE À JOUR TERMINÉE !');
    console.log('\n🎯 Testez maintenant votre app Flutter !');
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
  } finally {
    await client.close();
  }
}

updateImagesFinal();