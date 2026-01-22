const Itineraire = require('../models/Itineraire');

/**
 * @desc    Récupérer tous les itinéraires
 * @route   GET /api/v1/itineraires
 * @access  Public
 */
exports.getAllItineraires = async (req, res, next) => {
  try {
    const { difficulty } = req.query;
    
    let query = {};

    // Filtrer par difficulté
    if (difficulty) {
      query.difficulty = difficulty.toLowerCase();
    }

    const itineraires = await Itineraire.find(query).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: itineraires.length,
      data: itineraires,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Récupérer un itinéraire par ID
 * @route   GET /api/v1/itineraires/:id
 * @access  Public
 */
exports.getItineraireById = async (req, res, next) => {
  try {
    const itineraire = await Itineraire.findById(req.params.id);

    if (!itineraire) {
      return res.status(404).json({
        success: false,
        message: 'Itinéraire non trouvé.',
      });
    }

    res.status(200).json({
      success: true,
      data: itineraire,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Créer un nouvel itinéraire
 * @route   POST /api/v1/itineraires
 * @access  Private (Admin)
 */
exports.createItineraire = async (req, res, next) => {
  try {
    const itineraire = await Itineraire.create(req.body);

    res.status(201).json({
      success: true,
      message: 'Itinéraire créé avec succès.',
      data: itineraire,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Mettre à jour un itinéraire
 * @route   PUT /api/v1/itineraires/:id
 * @access  Private (Admin)
 */
exports.updateItineraire = async (req, res, next) => {
  try {
    const itineraire = await Itineraire.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true,
      }
    );

    if (!itineraire) {
      return res.status(404).json({
        success: false,
        message: 'Itinéraire non trouvé.',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Itinéraire mis à jour avec succès.',
      data: itineraire,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Supprimer un itinéraire
 * @route   DELETE /api/v1/itineraires/:id
 * @access  Private (Admin)
 */
exports.deleteItineraire = async (req, res, next) => {
  try {
    const itineraire = await Itineraire.findByIdAndDelete(req.params.id);

    if (!itineraire) {
      return res.status(404).json({
        success: false,
        message: 'Itinéraire non trouvé.',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Itinéraire supprimé avec succès.',
    });
  } catch (error) {
    next(error);
  }
};