import 'package:flutter_test/flutter_test.dart';
import 'package:bang_ziiga/providers/sites_provider.dart';
import 'package:bang_ziiga/models/site.dart';

void main() {
  group('SitesProvider Tests', () {
    late SitesProvider provider;
    late List<Site> testSites;

    setUp(() {
      provider = SitesProvider();
      testSites = [
        Site(
          id: '1',
          name: 'Monument A',
          description: 'A beautiful monument',
          category: 'monument',
          location: 'City A',
          imageUrl: 'image1.jpg',
        ),
        Site(
          id: '2',
          name: 'Museum B',
          description: 'An interesting museum',
          category: 'musée',
          location: 'City B',
          imageUrl: 'image2.jpg',
        ),
        Site(
          id: '3',
          name: 'Park C',
          description: 'A relaxing park',
          category: 'parc',
          location: 'City C',
          imageUrl: 'image3.jpg',
        ),
      ];
      provider.setSitesForTesting(testSites);
    });

    test('filterByCategory should return sites of specific category', () {
      final monuments = provider.filterByCategory('monument');

      expect(monuments.length, 1);
      expect(monuments[0].name, 'Monument A');
    });

    test('filterByCategory should be case insensitive', () {
      final museums = provider.filterByCategory('MUSÉE');

      expect(museums.length, 1);
      expect(museums[0].name, 'Museum B');
    });

    test('filterByCategory should return empty list for non-existent category',
        () {
      final result = provider.filterByCategory('beach');

      expect(result, isEmpty);
    });

    test('searchSites should return all sites for empty query', () {
      final result = provider.searchSites('');

      expect(result.length, 3);
    });

    test('searchSites should filter by name', () {
      final result = provider.searchSites('Monument');

      expect(result.length, 1);
      expect(result[0].name, 'Monument A');
    });

    test('searchSites should filter by description', () {
      final result = provider.searchSites('beautiful');

      expect(result.length, 1);
      expect(result[0].name, 'Monument A');
    });

    test('searchSites should filter by category', () {
      final result = provider.searchSites('parc');

      expect(result.length, 1);
      expect(result[0].name, 'Park C');
    });

    test('searchSites should filter by location', () {
      final result = provider.searchSites('City B');

      expect(result.length, 1);
      expect(result[0].name, 'Museum B');
    });

    test('searchSites should be case insensitive', () {
      final result = provider.searchSites('MONUMENT');

      expect(result.length, 1);
      expect(result[0].name, 'Monument A');
    });

    test('searchSites should return multiple results', () {
      final result = provider.searchSites('City');

      expect(result.length, 3);
    });

    test('selectSite should set selectedSite', () {
      final site = testSites[0];

      provider.selectSite(site);

      expect(provider.selectedSite, site);
    });

    test('clearError should reset error state', () {
      provider.setStateForTesting(SitesState.error, error: 'Test error');

      expect(provider.hasError, true);
      expect(provider.errorMessage, 'Test error');

      provider.clearError();

      expect(provider.hasError, false);
      expect(provider.errorMessage, null);
      expect(provider.state, SitesState.initial);
    });
  });
}
