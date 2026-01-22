const Site = require('../models/Site');

/**
 * @desc    Récupérer tous les sites
 * @route   GET /api/v1/sites
 * @access  Public
 */
exports.getAllSites = async (req, res, next) => {
  try {
    const { category, search, isFeatured } = req.query;
    
    // Construction de la requête de filtrage
    let query = {};

    // Filtrer par catégorie
    if (category) {
      query.category = category;
    }

    // Filtrer par sites phares
    if (isFeatured) {
      query.isFeatured = isFeatured === 'true';
    }

    // Recherche textuelle
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { description: { $regex: search, $options: 'i' } },
        { location: { $regex: search, $options: 'i' } },
      ];
    }

    const sites = await Site.find(query).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: sites.length,
      data: sites,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Récupérer les sites phares
 * @route   GET /api/v1/sites/featured
 * @access  Public
 */
exports.getFeaturedSites = async (req, res, next) => {
  try {
    const sites = await Site.find({ isFeatured: true })
      .limit(4)
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: sites.length,
      data: sites,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Récupérer un site par ID
 * @route   GET /api/v1/sites/:id
 * @access  Public
 */
exports.getSiteById = async (req, res, next) => {
  try {
    const site = await Site.findById(req.params.id);

    if (!site) {
      return res.status(404).json({
        success: false,
        message: 'Site non trouvé.',
      });
    }

    res.status(200).json({
      success: true,
      data: site,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Créer un nouveau site
 * @route   POST /api/v1/sites
 * @access  Private (Admin)
 */
exports.createSite = async (req, res, next) => {
  try {
    const site = await Site.create(req.body);

    res.status(201).json({
      success: true,
      message: 'Site créé avec succès.',
      data: site,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Mettre à jour un site
 * @route   PUT /api/v1/sites/:id
 * @access  Private (Admin)
 */
exports.updateSite = async (req, res, next) => {
  try {
    const site = await Site.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!site) {
      return res.status(404).json({
        success: false,
        message: 'Site non trouvé.',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Site mis à jour avec succès.',
      data: site,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Supprimer un site
 * @route   DELETE /api/v1/sites/:id
 * @access  Private (Admin)
 */
exports.deleteSite = async (req, res, next) => {
  try {
    const site = await Site.findByIdAndDelete(req.params.id);

    if (!site) {
      return res.status(404).json({
        success: false,
        message: 'Site non trouvé.',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Site supprimé avec succès.',
    });
  } catch (error) {
    next(error);
  }
};