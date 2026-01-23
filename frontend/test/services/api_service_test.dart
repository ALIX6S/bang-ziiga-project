import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:bang_ziiga/services/api_service.dart';

void main() {
  group('ApiService Tests', () {
    test('parseResponse should return data for 200 status', () {
      final response = http.Response('{"success": true}', 200);

      final result = ApiService.parseResponse(response);

      expect(result, {'success': true});
    });

    test('parseResponse should return data for 201 status', () {
      final response = http.Response('{"created": true}', 201);

      final result = ApiService.parseResponse(response);

      expect(result, {'created': true});
    });

    test('parseResponse should throw exception for 401 status', () {
      final response = http.Response('{"message": "Unauthorized"}', 401);

      expect(
          () => ApiService.parseResponse(response),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains('Non autorisé'))));
    });

    test('parseResponse should throw exception for 404 status', () {
      final response = http.Response('{"message": "Not Found"}', 404);

      expect(
          () => ApiService.parseResponse(response),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('Ressource non trouvée'))));
    });

    test('parseResponse should throw exception for 500 status', () {
      final response = http.Response('{"message": "Server Error"}', 500);

      expect(
          () => ApiService.parseResponse(response),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains('Erreur serveur'))));
    });

    test(
        'parseResponse should throw exception with custom message for other status codes',
        () {
      final response = http.Response('{"message": "Custom error"}', 400);

      expect(
          () => ApiService.parseResponse(response),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains('Custom error'))));
    });

    test(
        'parseResponse should throw exception with default message for other status codes without message',
        () {
      final response = http.Response('{}', 400);

      expect(
          () => ApiService.parseResponse(response),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains('Erreur inconnue'))));
    });
  });
}
