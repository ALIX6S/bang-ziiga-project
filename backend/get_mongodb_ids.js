// get_mongodb_ids.js
const { MongoClient } = require('mongodb');
require('dotenv').config();

async function getAllIds() {
  const client = new MongoClient(process.env.MONGODB_URI);
  
  try {
    await client.connect();
    console.log('✓ Connecté à MongoDB Atlas\n');
    
    const db = client.db('test');
    
    // ============================================
    // SITES
    // ============================================
    console.log('📍 SITES:');
    console.log('const siteImageMapping = {');
    
    const sites = await db.collection('sites').find({}).sort({ name: 1 }).toArray();
    
    sites.forEach((site, index) => {
      const comma = index < sites.length - 1 ? ',' : '';
      // Générer le nom de fichier basé sur l'index
      console.log(`  '${site._id}': 'site_${index + 1}.jpg'${comma}  // ${site.name}`);
    });
    
    console.log('};\n');
    
    // ============================================
    // ITINÉRAIRES
    // ============================================
    console.log('🗺️  ITINÉRAIRES:');
    console.log('const itineraireImageMapping = {');
    
    const itineraires = await db.collection('itineraires').find({}).sort({ name: 1 }).toArray();
    
    itineraires.forEach((it, index) => {
      const comma = index < itineraires.length - 1 ? ',' : '';
      // Générer le nom de fichier basé sur l'index
      console.log(`  '${it._id}': 'itineraire_${index + 1}.jpg'${comma}  // ${it.name}`);
    });
    
    console.log('};\n');
    
    console.log(`\n📊 Total: ${sites.length} sites, ${itineraires.length} itinéraires`);
    console.log('\n💡 Copiez-collez ces mappings dans update_image_urls.js');
    
  } catch (error) {
    console.error('❌ Erreur:', error);
  } finally {
    await client.close();
  }
}

getAllIds();