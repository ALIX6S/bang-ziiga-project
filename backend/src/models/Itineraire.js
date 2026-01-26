const mongoose = require('mongoose');

const itineraireSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Le nom de l\'itinéraire est requis'],
      trim: true,
      maxlength: [200, 'Le nom ne peut pas dépasser 200 caractères'],
    },
    description: {
      type: String,
      required: [true, 'La description est requise'],
      maxlength: [2000, 'La description ne peut pas dépasser 2000 caractères'],
    },
    duration: {
      type: String,
      required: [true, 'La durée est requise'],
      maxlength: [50, 'La durée ne peut pas dépasser 50 caractères'],
    },
    difficulty: {
      type: String,
      required: [true, 'Le niveau de difficulté est requis'],
      enum: {
        values: ['facile', 'moyen', 'intense'],
        message: 'Niveau de difficulté invalide',
      },
      lowercase: true,
    },
    distance: {
      type: String,
      maxlength: [50, 'La distance ne peut pas dépasser 50 caractères'],
    },
    sites: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Site',
      },
    ],
    imageUrl: {
      type: String,
      required: [true, 'L\'URL de l\'image est requise'],
      default: 'https://picsum.photos/400/300',
    },
    recommendations: {
      type: String,
      maxlength: [500, 'Les recommandations ne peuvent pas dépasser 500 caractères'],
    },
  },
  {
    timestamps: true,
  }
);

itineraireSchema.pre(/^find/, function (next) {
  this.populate({
    path: 'sites',
    select: 'name category location imageUrl',
  });
  next();
});

itineraireSchema.virtual('sitesCount').get(function () {
  return this.sites ? this.sites.length : 0;
});

itineraireSchema.set('toJSON', { virtuals: true });
itineraireSchema.set('toObject', { virtuals: true });

const Itineraire = mongoose.model('Itineraire', itineraireSchema);

module.exports = Itineraire;