const CultureInfo = require('../models/CultureInfo');
const createCrudHandlers = require('./crudFactory');

const VALID_TYPES = ['tradition', 'gastronomie', 'événement'];

const crud = createCrudHandlers(CultureInfo, {
  notFound: 'Information culturelle non trouvée.',
  created: 'Information culturelle créée avec succès.',
  updated: 'Information culturelle mise à jour avec succès.',
  deleted: 'Information culturelle supprimée avec succès.',
});

exports.getAllCultureInfo = async (req, res, next) => {
  try {
    const { type } = req.query;

    const query = { isPublished: true };

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

exports.getCultureByType = async (req, res, next) => {
  try {
    const type = req.params.type.toLowerCase();

    if (!VALID_TYPES.includes(type)) {
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

exports.createCultureInfo = crud.create;
exports.updateCultureInfo = crud.update;
exports.deleteCultureInfo = crud.remove;
