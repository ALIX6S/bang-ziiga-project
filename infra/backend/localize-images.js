// Fait pointer les images de la base vers les fichiers servis par l'API sur
// /uploads, pour que l'app fonctionne sans internet. Lancé par le service `seed`.
require('dotenv').config();
const mongoose = require('mongoose');
const Site = require('./src/models/Site');
const Itineraire = require('./src/models/Itineraire');

const base = process.env.PUBLIC_API_URL || 'http://localhost:3000';
const sites = {
  'Monument des Héros Nationaux': 'sites/monument.jpeg',
  'Musée National du Burkina Faso': 'sites/national.jpeg',
  'Parc Urbain Bangr-Weoogo': 'sites/parc_bangre.jpeg',
  'Cathédrale de Ouagadougou': 'sites/cathedrale.jpeg',
  'Laongo - Sculptures sur Granit': 'sites/granite.jpeg',
  'Marché Central de Ouagadougou': 'sites/rodo_woko.jpeg',
};
const itineraires = {
  'Découverte de Ouagadougou': 'itineraires/love_ouaga.jpeg',
  'Circuit Culturel et Spirituel': 'itineraires/laongo.jpeg',
  'Art et Nature': 'itineraires/parc.jpg',
};

(async () => {
  await mongoose.connect(process.env.MONGODB_URI);
  let n = 0;
  for (const [name, f] of Object.entries(sites))
    n += (await Site.updateOne({ name }, { imageUrl: `${base}/uploads/${f}` })).modifiedCount;
  for (const [name, f] of Object.entries(itineraires))
    n += (await Itineraire.updateOne({ name }, { imageUrl: `${base}/uploads/${f}` })).modifiedCount;
  console.log(`${n} image(s) pointée(s) vers ${base}/uploads`);
  await mongoose.disconnect();
})().catch((e) => { console.error(e); process.exit(1); });
