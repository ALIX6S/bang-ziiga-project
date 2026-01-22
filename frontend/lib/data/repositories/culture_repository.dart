import '../../core/constants/api_constants.dart';
import '../../models/culture_info.dart';
import '../../models/api_response.dart';
import '../../services/api_service.dart';
class CultureRepository {
  /// Récupérer toutes les informations culturelles
  static Future<ApiResponse<List<CultureInfo>>> getAllCultureInfo() async {
    try {
      final response = await ApiService.get(ApiConstants.culture);
      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final cultureData = data['data'] as List;
        final cultureInfos = cultureData
            .map((json) => CultureInfo.fromJson(json))
            .toList();

        return ApiResponse.success(data: cultureInfos);
      } else {
        return ApiResponse.error(
          message: data['message'] ?? 'Erreur lors du chargement des informations culturelles',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Récupérer les informations culturelles par type
  static Future<ApiResponse<List<CultureInfo>>> getCultureInfoByType(
    String type,
  ) async {
    try {
      final response = await ApiService.get('${ApiConstants.culture}/$type');
      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final cultureData = data['data'] as List;
        final cultureInfos = cultureData
            .map((json) => CultureInfo.fromJson(json))
            .toList();

        return ApiResponse.success(data: cultureInfos);
      } else {
        // Fallback: récupérer toutes les infos et filtrer
        final allInfoResponse = await getAllCultureInfo();
        if (allInfoResponse.success && allInfoResponse.data != null) {
          final filteredInfos = allInfoResponse.data!
              .where((info) => info.type.toLowerCase() == type.toLowerCase())
              .toList();
          return ApiResponse.success(data: filteredInfos);
        }

        return ApiResponse.error(
          message: 'Aucune information trouvée pour ce type',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Grouper les informations culturelles par type
  static Map<String, List<CultureInfo>> groupByType(
    List<CultureInfo> cultureInfos,
  ) {
    final Map<String, List<CultureInfo>> grouped = {
      'tradition': [],
      'gastronomie': [],
      'événement': [],
    };

    for (var info in cultureInfos) {
      final type = info.type.toLowerCase();
      if (grouped.containsKey(type)) {
        grouped[type]!.add(info);
      } else {
        grouped[type] = [info];
      }
    }

    return grouped;
  }
}