const Site = require('../models/Site');
const createCrudHandlers = require('./crudFactory');

const crud = createCrudHandlers(Site, {
  notFound: 'Site non trouvé.',
  created: 'Site créé avec succès.',
  updated: 'Site mis à jour avec succès.',
  deleted: 'Site supprimé avec succès.',
});

exports.getAllSites = async (req, res, next) => {
  try {
    const { category, search, isFeatured } = req.query;

    const query = {};

    if (category) {
      query.category = category;
    }

    if (isFeatured) {
      query.isFeatured = isFeatured === 'true';
    }

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

exports.getSiteById = crud.getById;
exports.createSite = crud.create;
exports.updateSite = crud.update;
exports.deleteSite = crud.remove;
