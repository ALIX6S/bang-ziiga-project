require('dotenv').config();
const mongoose = require('mongoose');
const colors = require('colors');

// Modèles
const User = require('../models/User');
const Site = require('../models/Site');
const Itineraire = require('../models/Itineraire');
const CultureInfo = require('../models/CultureInfo');

// Connexion à MongoDB
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log(' MongoDB connecté'.green.bold);
  } catch (error) {
    console.error(' Erreur de connexion:', error);
    process.exit(1);
  }
};

// Données de test
const users = [
  {
    fullName: 'Admin User',
    email: 'admin@bangziiga.com',
    password: 'admin123',
    role: 'admin',
  },
  {
    fullName: 'Jean Kaboré',
    email: 'jean@example.com',
    password: 'test123',
    role: 'user',
  },
];

const sites = [
  {
    name: 'Monument des Héros Nationaux',
    description: 'Monument emblématique de Ouagadougou dédié aux héros de la nation. Ce lieu symbolique représente la mémoire collective et le courage du peuple burkinabè.',
    category: 'Monument',
    location: 'Place de la Nation, Ouagadougou',
    imageUrl: 'https://picsum.photos/seed/monument1/400/300',
    isFeatured: true,
  },
  {
    name: 'Musée National du Burkina Faso',
    description: 'Le Musée National présente une riche collection d\'objets traditionnels, d\'œuvres d\'art et d\'artefacts historiques retraçant l\'histoire et la culture du pays.',
    category: 'Musée',
    location: 'Avenue de l\'Indépendance, Ouagadougou',
    imageUrl: 'https://picsum.photos/seed/musee1/400/300',
    isFeatured: true,
  },
  {
    name: 'Parc Urbain Bangr-Weoogo',
    description: 'Espace vert de 260 hectares au cœur de Ouagadougou, le parc Bangr-Weoogo offre un havre de paix avec sa faune et sa flore diversifiées.',
    category: 'Parc',
    location: 'Centre-ville, Ouagadougou',
    imageUrl: 'https://picsum.photos/seed/parc1/400/300',
    isFeatured: true,
  },
  {
    name: 'Cathédrale de Ouagadougou',
    description: 'Édifice religieux majestueux au style architectural unique, la cathédrale est un lieu de culte important et un point de repère de la ville.',
    category: 'Monument',
    location: 'Avenue Kwamé N\'Krumah, Ouagadougou',
    imageUrl: 'https://picsum.photos/seed/cathedrale/400/300',
    isFeatured: false,
  },
  {
    name: 'Laongo - Sculptures sur Granit',
    description: 'Site unique de sculptures monumentales taillées dans la roche granitique, créées par des artistes du monde entier lors de symposiums internationaux.',
    category: 'Site Historique',
    location: 'Laongo, à 30 km de Ouagadougou',
    imageUrl: 'https://picsum.photos/seed/laongo/400/300',
    isFeatured: true,
  },
  {
    name: 'Marché Central de Ouagadougou',
    description: 'Marché animé où se côtoient artisans, commerçants et visiteurs. Un lieu idéal pour découvrir l\'artisanat local et l\'ambiance typique de la ville.',
    category: 'Lieu Culturel',
    location: 'Centre-ville, Ouagadougou',
    imageUrl: 'https://picsum.photos/seed/marche/400/300',
    isFeatured: false,
  },
];

const cultureInfos = [
  {
    type: 'tradition',
    title: 'Les Masques Traditionnels',
    content: 'Les masques occupent une place centrale dans la culture burkinabè. Chaque ethnie possède ses propres types de masques utilisés lors de cérémonies rituelles, de funérailles ou de fêtes. Les masques Bwa, Mossi et Bobo sont particulièrement réputés pour leur beauté et leur signification spirituelle profonde.',
    imageUrl: 'https://picsum.photos/seed/masques/400/300',
    tags: ['masques', 'tradition', 'culture'],
  },
  {
    type: 'gastronomie',
    title: 'Le Tô, Plat National',
    content: 'Le Tô est le plat de base de la cuisine burkinabè. Préparé à partir de mil, de sorgho ou de maïs, il est généralement accompagné de sauces variées : sauce d\'arachide, sauce gombo, ou sauce aux feuilles de baobab. Ce plat nutritif fait partie intégrante de l\'identité culinaire du pays.',
    imageUrl: 'https://picsum.photos/seed/to/400/300',
    tags: ['cuisine', 'tradition', 'to'],
  },
  {
    type: 'événement',
    title: 'FESPACO - Festival du Cinéma',
    content: 'Le Festival Panafricain du Cinéma et de la Télévision de Ouagadougou (FESPACO) est le plus grand événement cinématographique d\'Afrique. Organisé tous les deux ans depuis 1969, il attire des réalisateurs, acteurs et cinéphiles du monde entier, célébrant le cinéma africain et sa diaspora.',
    imageUrl: 'https://picsum.photos/seed/fespaco/400/300',
    tags: ['cinema', 'festival', 'culture'],
  },
  {
    type: 'gastronomie',
    title: 'Le Dolo, Bière Traditionnelle',
    content: 'Le Dolo est une bière traditionnelle à base de mil ou de sorgho fermenté. Boisson ancestrale, elle est consommée lors de cérémonies et de rassemblements sociaux. Sa préparation suit un processus artisanal transmis de génération en génération.',
    imageUrl: 'https://picsum.photos/seed/dolo/400/300',
    tags: ['boisson', 'tradition', 'dolo'],
  },
  {
    type: 'événement',
    title: 'SIAO - Salon de l\'Artisanat',
    content: 'Le Salon International de l\'Artisanat de Ouagadougou (SIAO) est une vitrine exceptionnelle du savoir-faire artisanal africain. Organisé tous les deux ans, il réunit des artisans de tout le continent et met en valeur la richesse et la diversité de l\'artisanat traditionnel et contemporain.',
    imageUrl: 'https://picsum.photos/seed/siao/400/300',
    tags: ['artisanat', 'salon', 'culture'],
  },
];

// Fonction de seeding
const seedDatabase = async () => {
  try {
    await connectDB();

    console.log('  Suppression des données existantes...'.yellow);
    await User.deleteMany();
    await Site.deleteMany();
    await Itineraire.deleteMany();
    await CultureInfo.deleteMany();
    console.log(' Données supprimées'.green);

    console.log(' Création des utilisateurs...'.yellow);
    const createdUsers = await User.create(users);
    console.log(` ${createdUsers.length} utilisateurs créés`.green);

    console.log('  Création des sites...'.yellow);
    const createdSites = await Site.create(sites);
    console.log(` ${createdSites.length} sites créés`.green);

    console.log('  Création des itinéraires...'.yellow);
    const itineraires = [
      {
        name: 'Découverte de Ouagadougou',
        description: 'Un parcours complet à travers les sites emblématiques de la capitale burkinabè. Idéal pour une première visite de la ville.',
        duration: '4 heures',
        difficulty: 'facile',
        distance: '8 km',
        sites: [createdSites[0]._id, createdSites[1]._id, createdSites[2]._id],
        imageUrl: 'https://picsum.photos/seed/itineraire1/400/300',
      },
      {
        name: 'Circuit Culturel et Spirituel',
        description: 'Immersion dans le patrimoine religieux et culturel de Ouagadougou avec la visite de lieux emblématiques.',
        duration: '3 heures',
        difficulty: 'facile',
        distance: '5 km',
        sites: [createdSites[3]._id, createdSites[1]._id, createdSites[5]._id],
        imageUrl: 'https://picsum.photos/seed/itineraire2/400/300',
      },
      {
        name: 'Art et Nature',
        description: 'Combinaison parfaite entre art contemporain et nature avec la visite du parc et des sculptures de Laongo.',
        duration: '6 heures',
        difficulty: 'moyen',
        distance: '65 km',
        sites: [createdSites[2]._id, createdSites[4]._id],
        imageUrl: 'https://picsum.photos/seed/itineraire3/400/300',
      },
    ];
    const createdItineraires = await Itineraire.create(itineraires);
    console.log(` ${createdItineraires.length} itinéraires créés`.green);

    console.log(' Création des infos culturelles...'.yellow);
    const createdCulture = await CultureInfo.create(cultureInfos);
    console.log(` ${createdCulture.length} infos culturelles créées`.green);

    console.log('\n Seeding terminé avec succès !'.green.bold);
    console.log('\n Résumé:'.cyan.bold);
    console.log(`   - Utilisateurs: ${createdUsers.length}`.cyan);
    console.log(`   - Sites: ${createdSites.length}`.cyan);
    console.log(`   - Itinéraires: ${createdItineraires.length}`.cyan);
    console.log(`   - Infos culturelles: ${createdCulture.length}`.cyan);
    
    console.log('\n Compte Admin:'.yellow.bold);
    console.log('   Email: admin@bangziiga.com'.yellow);
    console.log('   Password: admin123'.yellow);

    process.exit(0);
  } catch (error) {
    console.error(' Erreur lors du seeding:'.red.bold, error);
    process.exit(1);
  }
};

// Lancer le seeding
seedDatabase();