// update_existing_images.js
const { MongoClient, ObjectId } = require('mongodb');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const BASE_URL = process.env.BASE_URL || 'https://bang-ziiga-project.onrender.com';
const UPLOADS_DIR = path.join(__dirname, 'uploads');

async function updateExistingImages() {
  const client = new MongoClient(process.env.MONGODB_URI);
  
  try {
    await client.connect();
    console.log('✅ Connecté à MongoDB Atlas\n');
    
    const db = client.db(process.env.DB_NAME || 'test');
    
    // ============================================
    // ÉTAPE 1 : LISTER VOS IMAGES LOCALES
    // ============================================
    console.log('📸 IMAGES LOCALES DISPONIBLES:\n');
    
    const sitesPath = path.join(UPLOADS_DIR, 'sites');
    const itinerairesPath = path.join(UPLOADS_DIR, 'itineraires');
    
    let siteImages = [];
    let itineraireImages = [];
    
    if (fs.existsSync(sitesPath)) {
      siteImages = fs.readdirSync(sitesPath)
        .filter(f => f.match(/\.(jpg|jpeg|png|webp)$/i))
        .sort();
      console.log('Sites:', siteImages.join(', '));
    } else {
      console.log('⚠️  Dossier uploads/sites/ introuvable');
    }
    
    if (fs.existsSync(itinerairesPath)) {
      itineraireImages = fs.readdirSync(itinerairesPath)
        .filter(f => f.match(/\.(jpg|jpeg|png|webp)$/i))
        .sort();
      console.log('Itinéraires:', itineraireImages.join(', '));
    } else {
      console.log('⚠️  Dossier uploads/itineraires/ introuvable');
    }
    
    console.log('\n' + '='.repeat(60) + '\n');
    
    // ============================================
    // ÉTAPE 2 : RÉCUPÉRER LES SITES EXISTANTS
    // ============================================
    console.log('📍 MISE À JOUR DES SITES:\n');
    
    const sites = await db.collection('sites')
      .find({})
      .sort({ name: 1 })
      .toArray();
    
    console.log(`Trouvé ${sites.length} site(s) dans MongoDB\n`);
    
    // Créer un mapping basé sur les noms de fichiers
    for (let i = 0; i < sites.length; i++) {
      const site = sites[i];
      
      // Chercher une image correspondante
      let imageFilename = null;
      
      // 1. Essayer avec imageFilename existant
      if (site.imageFilename && siteImages.includes(site.imageFilename)) {
        imageFilename = site.imageFilename;
      }
      // 2. Essayer de trouver par le nom du site
      else {
        const siteName = site.name.toLowerCase()
          .normalize('NFD')
          .replace(/[\u0300-\u036f]/g, '') // Enlever les accents
          .replace(/[^a-z0-9]/g, '-');
        
        imageFilename = siteImages.find(img => 
          img.toLowerCase().includes(siteName.substring(0, 10))
        );
      }
      // 3. Utiliser l'index
      if (!imageFilename && siteImages[i]) {
        imageFilename = siteImages[i];
      }
      
      if (imageFilename) {
        const newImageUrl = `${BASE_URL}/uploads/sites/${imageFilename}`;
        
        // Mettre à jour MongoDB
        await db.collection('sites').updateOne(
          { _id: site._id },
          {
            $set: {
              image: newImageUrl,
              imageUrl: newImageUrl, // Garder les deux champs pour compatibilité
              imageFilename: imageFilename,
              updatedAt: new Date()
            }
          }
        );
        
        console.log(`✓ ${site.name.padEnd(40)} → ${imageFilename}`);
      } else {
        console.log(`⚠️  ${site.name.padEnd(40)} → AUCUNE IMAGE TROUVÉE`);
      }
    }
    
    console.log('\n' + '='.repeat(60) + '\n');
    
    // ============================================
    // ÉTAPE 3 : RÉCUPÉRER LES ITINÉRAIRES EXISTANTS
    // ============================================
    console.log('🗺️  MISE À JOUR DES ITINÉRAIRES:\n');
    
    const itineraires = await db.collection('itineraires')
      .find({})
      .sort({ name: 1 })
      .toArray();
    
    console.log(`Trouvé ${itineraires.length} itinéraire(s) dans MongoDB\n`);
    
    for (let i = 0; i < itineraires.length; i++) {
      const itineraire = itineraires[i];
      
      let imageFilename = null;
      
      // 1. Essayer avec imageFilename existant
      if (itineraire.imageFilename && itineraireImages.includes(itineraire.imageFilename)) {
        imageFilename = itineraire.imageFilename;
      }
      // 2. Essayer de trouver par le nom
      else {
        const itineraireName = itineraire.name.toLowerCase()
          .normalize('NFD')
          .replace(/[\u0300-\u036f]/g, '')
          .replace(/[^a-z0-9]/g, '-');
        
        imageFilename = itineraireImages.find(img => 
          img.toLowerCase().includes(itineraireName.substring(0, 10))
        );
      }
      // 3. Utiliser l'index
      if (!imageFilename && itineraireImages[i]) {
        imageFilename = itineraireImages[i];
      }
      
      if (imageFilename) {
        const newImageUrl = `${BASE_URL}/uploads/itineraires/${imageFilename}`;
        
        await db.collection('itineraires').updateOne(
          { _id: itineraire._id },
          {
            $set: {
              image: newImageUrl,
              imageUrl: newImageUrl,
              imageFilename: imageFilename,
              updatedAt: new Date()
            }
          }
        );
        
        console.log(`✓ ${itineraire.name.padEnd(40)} → ${imageFilename}`);
      } else {
        console.log(`⚠️  ${itineraire.name.padEnd(40)} → AUCUNE IMAGE TROUVÉE`);
      }
    }
    
    console.log('\n' + '='.repeat(60) + '\n');
    console.log('✅ MISE À JOUR TERMINÉE !\n');
    
    // Résumé
    console.log('📊 RÉSUMÉ:');
    console.log(`   Sites mis à jour: ${sites.length}`);
    console.log(`   Itinéraires mis à jour: ${itineraires.length}`);
    console.log(`\n💡 Vérifiez sur: ${BASE_URL}/test-images`);
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
    console.error(error);
  } finally {
    await client.close();
  }
}

updateExistingImages();