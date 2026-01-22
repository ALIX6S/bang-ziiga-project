/**
 * Middleware de gestion centralisée des erreurs
 */
const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  // Log de l'erreur en développement
  if (process.env.NODE_ENV === 'development') {
    console.error(' Erreur:'.red, err);
  }

  // Erreur de validation Mongoose
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors)
      .map((val) => val.message)
      .join(', ');
    error.message = message;
    error.statusCode = 400;
  }

  // Erreur de duplication MongoDB (E11000)
  if (err.code === 11000) {
    const field = Object.keys(err.keyValue)[0];
    error.message = `Cette valeur pour le champ '${field}' existe déjà.`;
    error.statusCode = 400;
  }

  // Erreur CastError Mongoose (ID invalide)
  if (err.name === 'CastError') {
    error.message = 'Ressource non trouvée.';
    error.statusCode = 404;
  }

  // Erreur JWT invalide
  if (err.name === 'JsonWebTokenError') {
    error.message = 'Token invalide.';
    error.statusCode = 401;
  }

  // Erreur JWT expiré
  if (err.name === 'TokenExpiredError') {
    error.message = 'Token expiré.';
    error.statusCode = 401;
  }

  res.status(error.statusCode || 500).json({
    success: false,
    message: error.message || 'Erreur serveur',
    ...(process.env.NODE_ENV === 'development' && {
      error: err,
      stack: err.stack,
    }),
  });
};

module.exports = errorHandler;