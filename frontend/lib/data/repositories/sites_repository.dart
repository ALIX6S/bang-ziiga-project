import '../../core/constants/api_constants.dart';
import '../../models/site.dart';
import '../../models/api_response.dart';
import '../../services/api_service.dart';

class SitesRepository {
  static Future<ApiResponse<List<Site>>> getAllSites() async {
    try {
      final response = await ApiService.get(ApiConstants.sites);
      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final sitesData = data['data'] as List;
        final sites = sitesData.map((json) => Site.fromJson(json)).toList();

        return ApiResponse.success(data: sites);
      } else {
        return ApiResponse.error(
          message: data['message'] ?? 'Erreur lors du chargement des sites',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  static Future<ApiResponse<Site>> getSiteById(String id) async {
    try {
      final response = await ApiService.get(ApiConstants.siteDetail(int.parse(id)));
      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final site = Site.fromJson(data['data']);
        return ApiResponse.success(data: site);
      } else {
        return ApiResponse.error(
          message: data['message'] ?? 'Site introuvable',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  static Future<ApiResponse<List<Site>>> getFeaturedSites() async {
    try {
      final response = await ApiService.get('${ApiConstants.sites}/featured');
      final data = ApiService.parseResponse(response);

      if (data['success'] == true || data['status'] == 'success') {
        final sitesData = data['data'] as List;
        final sites = sitesData.map((json) => Site.fromJson(json)).toList();

        return ApiResponse.success(data: sites);
      } else {
        // Si pas d'endpoint featured, filtrer localement
        final allSitesResponse = await getAllSites();
        if (allSitesResponse.success && allSitesResponse.data != null) {
          final featuredSites = allSitesResponse.data!
              .where((site) => site.isFeatured)
              .toList();
          return ApiResponse.success(data: featuredSites);
        }

        return ApiResponse.error(
          message: 'Impossible de charger les sites phares',
        );
      }
    } catch (e) {
      // Fallback: essayer de récupérer tous les sites et filtrer
      try {
        final allSitesResponse = await getAllSites();
        if (allSitesResponse.success && allSitesResponse.data != null) {
          final featuredSites = allSitesResponse.data!
              .where((site) => site.isFeatured)
              .take(4)
              .toList();
          return ApiResponse.success(data: featuredSites);
        }
      } catch (_) {}

      return ApiResponse.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}