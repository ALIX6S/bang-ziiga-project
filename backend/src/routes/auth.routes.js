const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const {
  register,
  login,
  getMe,
  logout,
} = require('../controllers/authController');
const { protect } = require('../middlewares/auth.middleware');
const validate = require('../middlewares/validation.middleware');

// Validation pour l'inscription
const registerValidation = [
  body('fullName')
    .trim()
    .notEmpty()
    .withMessage('Le nom complet est requis')
    .isLength({ min: 3 })
    .withMessage('Le nom doit contenir au moins 3 caractères'),
  body('email')
    .trim()
    .notEmpty()
    .withMessage('L\'email est requis')
    .isEmail()
    .withMessage('Email invalide')
    .normalizeEmail(),
  body('password')
    .notEmpty()
    .withMessage('Le mot de passe est requis')
    .isLength({ min: 6 })
    .withMessage('Le mot de passe doit contenir au moins 6 caractères'),
];

// Validation pour la connexion
const loginValidation = [
  body('email')
    .trim()
    .notEmpty()
    .withMessage('L\'email est requis')
    .isEmail()
    .withMessage('Email invalide')
    .normalizeEmail(),
  body('password').notEmpty().withMessage('Le mot de passe est requis'),
];

// Routes publiques
router.post('/register', registerValidation, validate, register);
router.post('/login', loginValidation, validate, login);

// Routes protégées
router.get('/me', protect, getMe);
router.post('/logout', protect, logout);

module.exports = router;