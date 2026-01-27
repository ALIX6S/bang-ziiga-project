class ApiConstants {
  // Source unique de l'URL de l'API. Le script de build remplace ce littéral
  // par l'URL locale au moment de compiler l'APK : il doit rester écrit en
  // clair ici, sans interpolation ni concaténation.
  static const String baseUrl = 'https://bang-ziiga-project.onrender.com/api/v1';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  static const String sites = '/sites';
  static String siteDetail(int id) => '/sites/$id';

  static const String culture = '/culture';

  static const String itineraires = '/itineraires';
  static String itineraireDetail(int id) => '/itineraires/$id';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
}