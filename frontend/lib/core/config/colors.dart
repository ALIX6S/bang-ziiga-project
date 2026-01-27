import 'package:flutter/material.dart';

/// Palette de couleurs Sage Green pour l'application Bãng Zĩiga
class AppColors {
  static const Color sageHint = Color(0xFFBFCFBB); // Arrière-plans légers
  static const Color mint = Color(0xFFBFCFBB); // Cartes, conteneurs
  static const Color sage = Color(0xFF8EA58C); // Éléments interactifs
  static const Color moss = Color(0xFF738A6E); // Titres importants
  static const Color evergreen = Color(0xFF344C3D); // Boutons principaux

  static const Color primary = evergreen;
  static const Color secondary = sage;
  static const Color background = sageHint;
  static const Color surface = mint;

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = moss;
  static const Color textHint = Color(0xFF9E9E9E);

  static const Color error = Color(0xFFD32F2F);
  static const Color success = sage;
  static const Color warning = Color(0xFFFFA726);

  static Color overlay = evergreen.withValues(alpha: 0.8);
  static Color shadow = Colors.black.withValues(alpha: 0.1);

  static Color difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return sage;
      case 'moyen':
        return moss;
      case 'intense':
        return evergreen;
      default:
        return moss;
    }
  }
}
