// diagnose_mongodb.js
const { MongoClient } = require('mongodb');
require('dotenv').config();

async function diagnose() {
  console.log('🔍 DIAGNOSTIC MONGODB ATLAS\n');
  
  // Vérifier les variables d'environnement
  console.log('1️⃣ VARIABLES D\'ENVIRONNEMENT:');
  console.log('   MONGODB_URI:', process.env.MONGODB_URI ? '✓ Défini' : '❌ Manquant');
  console.log('   DB_NAME:', process.env.DB_NAME || 'Non défini (utilisera "bangziiga" par défaut)');
  
  if (!process.env.MONGODB_URI) {
    console.error('\n❌ MONGODB_URI non trouvé dans .env');
    return;
  }
  
  // Extraire le nom de la DB depuis l'URI
  const uriMatch = process.env.MONGODB_URI.match(/mongodb\.net\/([^?]+)/);
  const dbNameFromUri = uriMatch ? uriMatch[1] : null;
  
  console.log('   DB dans l\'URI:', dbNameFromUri || 'Non spécifié');
  console.log('');
  
  const client = new MongoClient(process.env.MONGODB_URI);
  
  try {
    console.log('2️⃣ CONNEXION À ATLAS...');
    await client.connect();
    console.log('   ✅ Connexion réussie\n');
    
    // Lister toutes les bases de données
    console.log('3️⃣ BASES DE DONNÉES DISPONIBLES:');
    const adminDb = client.db().admin();
    const dbList = await adminDb.listDatabases();
    
    dbList.databases.forEach(db => {
      const size = (db.sizeOnDisk / 1024 / 1024).toFixed(2);
      console.log(`   - ${db.name} (${size} MB)`);
    });
    console.log('');
    
    // Tester différents noms de base de données
    const dbNamesToTest = [
      process.env.DB_NAME,
      dbNameFromUri,
      'bangziiga',
      'bang-ziiga',
      'test',
      'admin'
    ].filter(Boolean); // Enlever les valeurs nulles
    
    console.log('4️⃣ RECHERCHE DES COLLECTIONS:');
    
    for (const dbName of [...new Set(dbNamesToTest)]) { // Éviter les doublons
      console.log(`\n   📂 Base de données: "${dbName}"`);
      
      try {
        const db = client.db(dbName);
        const collections = await db.listCollections().toArray();
        
        if (collections.length === 0) {
          console.log('      ⚠️  Aucune collection trouvée');
          continue;
        }
        
        console.log(`      ✓ ${collections.length} collection(s) trouvée(s):`);
        
        for (const col of collections) {
          const count = await db.collection(col.name).countDocuments();
          console.log(`         - ${col.name}: ${count} document(s)`);
          
          // Si c'est la collection sites ou itineraires, afficher un échantillon
          if ((col.name === 'sites' || col.name === 'itineraires') && count > 0) {
            const sample = await db.collection(col.name).findOne();
            console.log(`           Exemple: ${JSON.stringify(sample, null, 2).substring(0, 200)}...`);
          }
        }
      } catch (err) {
        console.log(`      ❌ Erreur d'accès: ${err.message}`);
      }
    }
    
    console.log('\n5️⃣ RECOMMANDATIONS:');
    
    // Trouver la bonne base
    let foundDb = null;
    for (const dbName of [...new Set(dbNamesToTest)]) {
      try {
        const db = client.db(dbName);
        const collections = await db.listCollections().toArray();
        const hasSites = collections.some(c => c.name === 'sites');
        const hasItineraires = collections.some(c => c.name === 'itineraires');
        
        if (hasSites || hasItineraires) {
          foundDb = dbName;
          break;
        }
      } catch (err) {
        // Ignorer
      }
    }
    
    if (foundDb) {
      console.log(`   ✅ Données trouvées dans la base "${foundDb}"`);
      console.log(`\n   💡 Mettez à jour votre .env avec:`);
      console.log(`      DB_NAME=${foundDb}`);
    } else {
      console.log('   ⚠️  Aucune collection "sites" ou "itineraires" trouvée');
      console.log('   💡 Vérifiez que vous avez bien inséré des données');
      console.log('   💡 Ou exécutez: node seed_database.js');
    }
    
  } catch (error) {
    console.error('\n❌ ERREUR:', error.message);
    
    if (error.message.includes('authentication')) {
      console.log('\n💡 Problème d\'authentification:');
      console.log('   - Vérifiez votre username et password dans MONGODB_URI');
      console.log('   - Vérifiez que l\'utilisateur existe dans Atlas');
    } else if (error.message.includes('network')) {
      console.log('\n💡 Problème de réseau:');
      console.log('   - Vérifiez votre connexion internet');
      console.log('   - Vérifiez les IP Whitelist dans Atlas (0.0.0.0/0 pour tout autoriser)');
    }
  } finally {
    await client.close();
    console.log('\n🔌 Déconnexion\n');
  }
}

diagnose();