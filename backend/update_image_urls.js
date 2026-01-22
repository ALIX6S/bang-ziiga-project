// update_image_urls.js
const { MongoClient, ObjectId } = require('mongodb');
require('dotenv').config();

//  À MODIFIER : Remplacez par votre vraie URL Render
const BASE_URL = 'https://bang-ziiga-project.onrender.com/uploads';

// Mapping des IDs vers les noms de fichiers
const siteImageMapping = {
  '696f9e85dc17b3d6fbef8889': 'granite.jpeg',
  '696f9e85dc17b3d6fbef8888': 'cathedrale.jpeg',
  '696f9e85dc17b3d6fbef8885': 'monument.jpeg',
  '696f9e85dc17b3d6fbef8886': 'national.jpeg',
  '696f9e85dc17b3d6fbef8887': 'parc_bangre.jpeg',
  '696f9e85dc17b3d6fbef888a': 'rodo_woko.jpeg'
  // Ajoutez tous vos sites...
};

const itineraireImageMapping = {
  '696f9e88dc17b3d6fbef8893': 'parc.jpg',
  '696f9e88dc17b3d6fbef8891': 'love_ouaga.jpeg',
  '696f9e88dc17b3d6fbef8892': 'laongo.jpeg'
  // Ajoutez tous vos itinéraires...
};

async function updateImageUrls() {
  const client = new MongoClient(process.env.MONGODB_URI);
  
  try {
    await client.connect();
    console.log('✓ Connecté à MongoDB Atlas');
    
    const db = client.db('test');
    
    // Mettre à jour les sites
    console.log('\n Mise à jour des sites...');
    for (const [id, filename] of Object.entries(siteImageMapping)) {
      const imageUrl = `${BASE_URL}/uploads/sites/${filename}`;
      
      const result = await db.collection('sites').updateOne(
        { _id: new ObjectId(id) },
        { 
          $set: { 
            image: imageUrl,
            imageFilename: filename,
            updatedAt: new Date() 
          } 
        }
      );
      
      if (result.modifiedCount > 0) {
        console.log(`  ✓ Site ${id} → ${filename}`); // ⚠️ Parenthèses, pas backticks
      } else {
        console.log(`  ✗ Site ${id} non trouvé`);    // ⚠️ Parenthèses, pas backticks
      }
    }
    
    // Mettre à jour les itinéraires
    console.log('\n  Mise à jour des itinéraires...');
    for (const [id, filename] of Object.entries(itineraireImageMapping)) {
      const imageUrl = `${BASE_URL}/uploads/itineraires/${filename}`;
      
      const result = await db.collection('itineraires').updateOne(
        { _id: new ObjectId(id) },
        { 
          $set: { 
            image: imageUrl,
            imageFilename: filename,
            updatedAt: new Date() 
          } 
        }
      );
      
      if (result.modifiedCount > 0) {
        console.log(`  ✓ Itinéraire ${id} → ${filename}`); // ⚠️ Parenthèses, pas backticks
      } else {
        console.log(`  ✗ Itinéraire ${id} non trouvé`);    // ⚠️ Parenthèses, pas backticks
      }
    }
    
    console.log('\n Mise à jour terminée !');
    
  } catch (error) {
    console.error(' Erreur:', error);
  } finally {
    await client.close();
  }
}

updateImageUrls();