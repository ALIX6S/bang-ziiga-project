const jwt = require('jsonwebtoken');
const User = require('../models/User');

/**
 * Middleware pour protéger les routes
 * Vérifie la présence et la validité du token JWT
 */
const protect = async (req, res, next) => {
  try {
    let token;

    // Vérifier si le token est présent dans les headers
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      token = req.headers.authorization.split(' ')[1];
    }

    // Si pas de token
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Accès non autorisé. Token manquant.',
      });
    }

    try {
      // Vérifier et décoder le token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Récupérer l'utilisateur depuis la base de données
      const user = await User.findById(decoded.id).select('-password');

      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'Utilisateur non trouvé.',
        });
      }

      if (!user.isActive) {
        return res.status(401).json({
          success: false,
          message: 'Compte désactivé.',
        });
      }

      // Attacher l'utilisateur à la requête
      req.user = user;
      next();
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Token invalide ou expiré.',
      });
    }
  } catch (error) {
    console.error('Erreur middleware auth:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur serveur lors de l\'authentification.',
    });
  }
};

/**
 * Middleware pour vérifier les rôles
 * @param  {...string} roles - Rôles autorisés
 */
const authorize = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: `Le rôle '${req.user.role}' n'est pas autorisé à accéder à cette ressource.`,
      });
    }
    next();
  };
};

module.exports = { protect, authorize };