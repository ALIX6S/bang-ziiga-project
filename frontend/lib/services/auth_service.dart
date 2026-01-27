import 'dart:convert';
import '../core/constants/api_constants.dart';
import '../models/user.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static Future<ApiResponse<User>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.register,
        {
          'fullName': fullName,
          'email': email,
          'password': password,
        },
      );

      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        return ApiResponse.success(
          message: data['message'] ?? 'Inscription réussie',
        );
      } else {
        return ApiResponse.error(
          message: data['message'] ?? 'Erreur lors de l\'inscription',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  static Future<ApiResponse<User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.login,
        {
          'email': email,
          'password': password,
        },
      );

      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final token = data['token'] ?? data['data']?['token'];
        if (token != null) {
          await StorageService.saveToken(token);
        }

        final userData = data['data']?['user'] ?? data['user'];
        if (userData != null) {
          await StorageService.saveUserData(jsonEncode(userData));
        }

        await StorageService.setRememberMe(rememberMe);

        final user = User.fromJson(userData ?? {});

        return ApiResponse.success(
          data: user,
          message: 'Connexion réussie',
        );
      } else {
        return ApiResponse.error(
          message: data['message'] ?? 'Identifiants incorrects',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  static Future<ApiResponse<void>> logout() async {
    try {
      try {
        await ApiService.post(ApiConstants.logout, {});
      } catch (_) {
        // Continuer même si l'API échoue
      }

      await StorageService.clearAll();

      return ApiResponse.success(
        message: 'Déconnexion réussie',
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Erreur lors de la déconnexion',
      );
    }
  }

  static User? getCurrentUser() {
    final userData = StorageService.getUserData();
    if (userData != null) {
      try {
        return User.fromJson(jsonDecode(userData));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static bool isLoggedIn() {
    return StorageService.isLoggedIn();
  }
}