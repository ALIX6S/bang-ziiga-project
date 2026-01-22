const CultureInfo = require('../models/CultureInfo');

/**
 * @desc    Récupérer toutes les informations culturelles
 * @route   GET /api/v1/culture
 * @access  Public
 */
exports.getAllCultureInfo = async (req, res, next) => {
  try {
    const { type } = req.query;
    
    let query = { isPublished: true };

    // Filtrer par type
    if (type) {
      query.type = type.toLowerCase();
    }

    const cultureInfos = await CultureInfo.find(query).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: cultureInfos.length,
      data: cultureInfos,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Récupérer les informations culturelles par type
 * @route   GET /api/v1/culture/:type
 * @access  Public
 */
exports.getCultureByType = async (req, res, next) => {
  try {
    const type = req.params.type.toLowerCase();

    // Valider le type
    const validTypes = ['tradition', 'gastronomie', 'événement'];
    if (!validTypes.includes(type)) {
      return res.status(400).json({
        success: false,
        message: 'Type invalide. Types valides: tradition, gastronomie, événement',
      });
    }

    const cultureInfos = await CultureInfo.find({
      type,
      isPublished: true,
    }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: cultureInfos.length,
      data: cultureInfos,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Créer une information culturelle
 * @route   POST /api/v1/culture
 * @access  Private (Admin)
 */
exports.createCultureInfo = async (req, res, next) => {
  try {
    const cultureInfo = await CultureInfo.create(req.body);

    res.status(201).json({
      success: true,
      message: 'Information culturelle créée avec succès.',
      data: cultureInfo,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Mettre à jour une information culturelle
 * @route   PUT /api/v1/culture/:id
 * @access  Private (Admin)
 */
exports.updateCultureInfo = async (req, res, next) => {
  try {
    const cultureInfo = await CultureInfo.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true,
      }
    );

    if (!cultureInfo) {
      return res.status(404).json({
        success: false,
        message: 'Information culturelle non trouvée.',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Information culturelle mise à jour avec succès.',
      data: cultureInfo,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Supprimer une information culturelle
 * @route   DELETE /api/v1/culture/:id
 * @access  Private (Admin)
 */
exports.deleteCultureInfo = async (req, res, next) => {
  try {
    const cultureInfo = await CultureInfo.findByIdAndDelete(req.params.id);

    if (!cultureInfo) {
      return res.status(404).json({
        success: false,
        message: 'Information culturelle non trouvée.',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Information culturelle supprimée avec succès.',
    });
  } catch (error) {
    next(error);
  }
};