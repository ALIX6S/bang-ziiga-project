/// Configuration des environnements de l'application
class Environment {
  // Environnement actuel
  static const String current = _Environment.development;
  
  // URLs selon l'environnement
  static String get baseUrl {
    switch (current) {
      case _Environment.development:
        return _developmentUrl;
      case _Environment.staging:
        return _stagingUrl;
      case _Environment.production:
        return _productionUrl;
      default:
        return _developmentUrl;
    }
  }
  
  // === CONFIGURATION ICI ===
  
  // Pour appareil physique (remplace par TON IP locale)
   static const String _developmentUrl = 'https://bang-ziiga-project.onrender.com/api/v1';
  
  
  //  STAGING (serveur de test en ligne)
  static const String _stagingUrl = 'https://bang-ziiga-project.onrender.com/api/v1';
  
  
  //  PRODUCTION (serveur final)
  static const String _productionUrl = 'https://bang-ziiga-project.onrender.com/api/v1';
  
  
  // Informations de debug
  static bool get isDevelopment => current == _Environment.development;
  static bool get isProduction => current == _Environment.production;
  
  static void printConfig() {
    print(' Environment: $current');
    print(' API URL: $baseUrl');
  }
}

class _Environment {
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';
}