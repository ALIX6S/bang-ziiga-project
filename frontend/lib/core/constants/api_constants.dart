class ApiConstants {
  // Base URL - À MODIFIER avec ton API réelle
  static const String baseUrl = 'https://bang-ziiga-backend.onrender.com/api/v1';
  
  // Endpoints d'authentification
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  
  // Endpoints de données
  static const String sites = '/sites';
  static String siteDetail(int id) => '/sites/$id';
  
  static const String culture = '/culture';
  
  static const String itineraires = '/itineraires';
  static String itineraireDetail(int id) => '/itineraires/$id';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // Clés de stockage local
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
}