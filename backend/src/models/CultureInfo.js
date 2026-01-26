const mongoose = require('mongoose');

const cultureInfoSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      required: [true, 'Le type est requis'],
      enum: {
        values: ['tradition', 'gastronomie', 'événement'],
        message: 'Type invalide',
      },
      lowercase: true,
    },
    title: {
      type: String,
      required: [true, 'Le titre est requis'],
      trim: true,
      maxlength: [200, 'Le titre ne peut pas dépasser 200 caractères'],
    },
    content: {
      type: String,
      required: [true, 'Le contenu est requis'],
      maxlength: [5000, 'Le contenu ne peut pas dépasser 5000 caractères'],
    },
    imageUrl: {
      type: String,
      default: 'https://picsum.photos/400/300',
    },
    tags: [
      {
        type: String,
        maxlength: [50, 'Un tag ne peut pas dépasser 50 caractères'],
      },
    ],
    isPublished: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

cultureInfoSchema.index({ type: 1, isPublished: 1 });
cultureInfoSchema.index({ title: 'text', content: 'text' });

const CultureInfo = mongoose.model('CultureInfo', cultureInfoSchema);

module.exports = CultureInfo;