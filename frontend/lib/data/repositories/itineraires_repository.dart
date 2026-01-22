import '../../core/constants/api_constants.dart';
import '../../models/itineraire.dart';
import '../../models/api_response.dart';
import '../../services/api_service.dart';

class ItinerairesRepository {
  /// Récupérer tous les itinéraires
  static Future<ApiResponse<List<Itineraire>>> getAllItineraires() async {
    try {
      final response = await ApiService.get(ApiConstants.itineraires);
      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final itinerairesData = data['data'] as List;
        final itineraires = itinerairesData
            .map((json) => Itineraire.fromJson(json))
            .toList();

        return ApiResponse.success(data: itineraires);
      } else {
        return ApiResponse.error(
          message: data['message'] ?? 'Erreur lors du chargement des itinéraires',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Récupérer un itinéraire par ID
  static Future<ApiResponse<Itineraire>> getItineraireById(String id) async {
    try {
      final response = await ApiService.get(
        ApiConstants.itineraireDetail(int.parse(id))
      );
      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final itineraire = Itineraire.fromJson(data['data']);
        return ApiResponse.success(data: itineraire);
      } else {
        return ApiResponse.error(
          message: data['message'] ?? 'Itinéraire introuvable',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}