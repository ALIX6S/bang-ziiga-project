import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  // Initialisation du service (à appeler au démarrage de l'app)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveToken(String token) async {
    return await _prefs!.setString(ApiConstants.tokenKey, token);
  }

  static String? getToken() {
    return _prefs!.getString(ApiConstants.tokenKey);
  }

  static Future<bool> deleteToken() async {
    return await _prefs!.remove(ApiConstants.tokenKey);
  }

  static bool isLoggedIn() {
    return getToken() != null;
  }

  static Future<bool> saveUserData(String userData) async {
    return await _prefs!.setString(ApiConstants.userKey, userData);
  }

  static String? getUserData() {
    return _prefs!.getString(ApiConstants.userKey);
  }

  static Future<bool> setRememberMe(bool value) async {
    return await _prefs!.setBool(ApiConstants.rememberMeKey, value);
  }

  static bool getRememberMe() {
    return _prefs!.getBool(ApiConstants.rememberMeKey) ?? false;
  }

  static Future<bool> clearAll() async {
    return await _prefs!.clear();
  }
}