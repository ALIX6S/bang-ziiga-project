const Itineraire = require('../models/Itineraire');
const createCrudHandlers = require('./crudFactory');

const crud = createCrudHandlers(Itineraire, {
  notFound: 'Itinéraire non trouvé.',
  created: 'Itinéraire créé avec succès.',
  updated: 'Itinéraire mis à jour avec succès.',
  deleted: 'Itinéraire supprimé avec succès.',
});

exports.getAllItineraires = async (req, res, next) => {
  try {
    const { difficulty } = req.query;

    const query = {};

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

exports.getItineraireById = crud.getById;
exports.createItineraire = crud.create;
exports.updateItineraire = crud.update;
exports.deleteItineraire = crud.remove;
