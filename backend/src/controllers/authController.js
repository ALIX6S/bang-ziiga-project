const User = require('../models/User');
const jwt = require('jsonwebtoken');

/**
 * Générer un token JWT
 */
const generateToken = (userId) => {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
};

/**
 * @desc    Inscription d'un nouvel utilisateur
 * @route   POST /api/v1/auth/register
 * @access  Public
 */
exports.register = async (req, res, next) => {
  try {
    const { fullName, email, password } = req.body;

    // Vérifier si l'utilisateur existe déjà
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Un compte avec cet email existe déjà.',
      });
    }

    // Créer l'utilisateur
    const user = await User.create({
      fullName,
      email,
      password,
    });

    res.status(201).json({
      success: true,
      message: 'Inscription réussie ! Vous pouvez maintenant vous connecter.',
      data: {
        user: {
          _id: user._id,
          fullName: user.fullName,
          email: user.email,
        },
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Connexion utilisateur
 * @route   POST /api/v1/auth/login
 * @access  Public
 */
exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Validation
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Veuillez fournir un email et un mot de passe.',
      });
    }

    // Vérifier si l'utilisateur existe (inclure le mot de passe)
    const user = await User.findOne({ email }).select('+password');

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Email ou mot de passe incorrect.',
      });
    }

    // Vérifier le mot de passe
    const isPasswordValid = await user.comparePassword(password);

    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Email ou mot de passe incorrect.',
      });
    }

    // Vérifier si le compte est actif
    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Ce compte a été désactivé.',
      });
    }

    // Générer le token
    const token = generateToken(user._id);

    res.status(200).json({
      success: true,
      message: 'Connexion réussie !',
      token,
      data: {
        user: {
          _id: user._id,
          fullName: user.fullName,
          email: user.email,
          role: user.role,
        },
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Obtenir l'utilisateur connecté
 * @route   GET /api/v1/auth/me
 * @access  Private
 */
exports.getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id);

    res.status(200).json({
      success: true,
      data: { user },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * @desc    Déconnexion
 * @route   POST /api/v1/auth/logout
 * @access  Private
 */
exports.logout = async (req, res, next) => {
  try {
    // Avec JWT, la déconnexion se fait côté client en supprimant le token
    // On peut aussi implémenter une blacklist de tokens si nécessaire
    
    res.status(200).json({
      success: true,
      message: 'Déconnexion réussie.',
    });
  } catch (error) {
    next(error);
  }
};