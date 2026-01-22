const mongoose = require('mongoose');

const siteSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Le nom du site est requis'],
      trim: true,
      maxlength: [200, 'Le nom ne peut pas dépasser 200 caractères'],
    },
    description: {
      type: String,
      required: [true, 'La description est requise'],
      maxlength: [2000, 'La description ne peut pas dépasser 2000 caractères'],
    },
    category: {
      type: String,
      required: [true, 'La catégorie est requise'],
      enum: {
        values: ['Monument', 'Musée', 'Parc', 'Plage', 'Site Historique', 'Lieu Culturel', 'Autre'],
        message: 'Catégorie invalide',
      },
    },
    location: {
      type: String,
      required: [true, 'La localisation est requise'],
      maxlength: [300, 'La localisation ne peut pas dépasser 300 caractères'],
    },
    imageUrl: {
      type: String,
      required: [true, 'L\'URL de l\'image est requise'],
      default: 'https://picsum.photos/400/300',
    },
    isFeatured: {
      type: Boolean,
      default: false,
    },
    coordinates: {
      latitude: {
        type: Number,
        min: -90,
        max: 90,
      },
      longitude: {
        type: Number,
        min: -180,
        max: 180,
      },
    },
    openingHours: {
      type: String,
      maxlength: [200, 'Les horaires ne peuvent pas dépasser 200 caractères'],
    },
    entryFee: {
      type: String,
      maxlength: [100, 'Le tarif ne peut pas dépasser 100 caractères'],
    },
  },
  {
    timestamps: true,
  }
);

// Index pour améliorer les performances de recherche
siteSchema.index({ name: 'text', description: 'text', location: 'text' });
siteSchema.index({ category: 1 });
siteSchema.index({ isFeatured: 1 });

const Site = mongoose.model('Site', siteSchema);

module.exports = Site;