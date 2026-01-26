/**
 * Les contrôleurs sites, itineraires et culture exposaient le même CRUD
 * dupliqué à l'identique: seuls le modèle Mongoose et les messages changent.
 * Cette fabrique produit ces handlers à partir de ces deux paramètres.
 */
const createCrudHandlers = (model, messages) => ({
  getById: async (req, res, next) => {
    try {
      const document = await model.findById(req.params.id);

      if (!document) {
        return res.status(404).json({
          success: false,
          message: messages.notFound,
        });
      }

      res.status(200).json({
        success: true,
        data: document,
      });
    } catch (error) {
      next(error);
    }
  },

  create: async (req, res, next) => {
    try {
      const document = await model.create(req.body);

      res.status(201).json({
        success: true,
        message: messages.created,
        data: document,
      });
    } catch (error) {
      next(error);
    }
  },

  update: async (req, res, next) => {
    try {
      const document = await model.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true,
      });

      if (!document) {
        return res.status(404).json({
          success: false,
          message: messages.notFound,
        });
      }

      res.status(200).json({
        success: true,
        message: messages.updated,
        data: document,
      });
    } catch (error) {
      next(error);
    }
  },

  remove: async (req, res, next) => {
    try {
      const document = await model.findByIdAndDelete(req.params.id);

      if (!document) {
        return res.status(404).json({
          success: false,
          message: messages.notFound,
        });
      }

      res.status(200).json({
        success: true,
        message: messages.deleted,
      });
    } catch (error) {
      next(error);
    }
  },
});

module.exports = createCrudHandlers;
