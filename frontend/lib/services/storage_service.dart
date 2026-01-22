import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  // Initialisation du service (à appeler au démarrage de l'app)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Sauvegarder le token d'authentification
  static Future<bool> saveToken(String token) async {
    return await _prefs!.setString(ApiConstants.tokenKey, token);
  }
  
  // Récupérer le token
  static String? getToken() {
    return _prefs!.getString(ApiConstants.tokenKey);
  }
  
  // Supprimer le token (déconnexion)
  static Future<bool> deleteToken() async {
    return await _prefs!.remove(ApiConstants.tokenKey);
  }
  
  // Vérifier si l'utilisateur est connecté
  static bool isLoggedIn() {
    return getToken() != null;
  }
  
  // Sauvegarder les données utilisateur
  static Future<bool> saveUserData(String userData) async {
    return await _prefs!.setString(ApiConstants.userKey, userData);
  }
  
  // Récupérer les données utilisateur
  static String? getUserData() {
    return _prefs!.getString(ApiConstants.userKey);
  }
  
  // Gérer "Se souvenir de moi"
  static Future<bool> setRememberMe(bool value) async {
    return await _prefs!.setBool(ApiConstants.rememberMeKey, value);
  }
  
  static bool getRememberMe() {
    return _prefs!.getBool(ApiConstants.rememberMeKey) ?? false;
  }
  
  // Nettoyer toutes les données (déconnexion complète)
  static Future<bool> clearAll() async {
    return await _prefs!.clear();
  }
}