import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  /// Headers avec token d'authentification
  static Future<Map<String, String>> _getHeaders() async {
    final token = StorageService.getToken();
    final headers = Map<String, String>.from(ApiConstants.headers);
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// GET Request
  static Future<http.Response> get(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders();
      
      final response = await http
          .get(url, headers: headers)
          .timeout(ApiConstants.connectTimeout);
      
      return response;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// POST Request
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders();
      
      final response = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectTimeout);
      
      return response;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// PUT Request
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders();
      
      final response = await http
          .put(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectTimeout);
      
      return response;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// DELETE Request
  static Future<http.Response> delete(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders();
      
      final response = await http
          .delete(url, headers: headers)
          .timeout(ApiConstants.connectTimeout);
      
      return response;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Parser la réponse HTTP
  static Map<String, dynamic> parseResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Non autorisé - Veuillez vous reconnecter');
    } else if (response.statusCode == 404) {
      throw Exception('Ressource non trouvée');
    } else if (response.statusCode == 500) {
      throw Exception('Erreur serveur');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur inconnue');
    }
  }
}