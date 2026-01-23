import 'package:flutter_test/flutter_test.dart';
import 'package:bang_ziiga/models/site.dart';

void main() {
  group('Site Model Tests', () {
    test('Site.fromJson should create a Site from valid JSON', () {
      final json = {
        '_id': '1',
        'name': 'Test Site',
        'description': 'A test site',
        'category': 'monument',
        'location': 'Test Location',
        'imageUrl': 'http://example.com/image.jpg',
        'isFeatured': true,
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      final site = Site.fromJson(json);

      expect(site.id, '1');
      expect(site.name, 'Test Site');
      expect(site.description, 'A test site');
      expect(site.category, 'monument');
      expect(site.location, 'Test Location');
      expect(site.imageUrl, 'http://example.com/image.jpg');
      expect(site.isFeatured, true);
      expect(site.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('Site.fromJson should handle missing fields', () {
      final json = {
        'name': 'Test Site',
        'category': 'parc',
        'location': 'Test Location',
      };

      final site = Site.fromJson(json);

      expect(site.id, '');
      expect(site.name, 'Test Site');
      expect(site.description, '');
      expect(site.category, 'parc');
      expect(site.location, 'Test Location');
      expect(site.imageUrl, '');
      expect(site.isFeatured, false);
      expect(site.createdAt, null);
    });

    test('Site.toJson should convert Site to JSON', () {
      final site = Site(
        id: '1',
        name: 'Test Site',
        description: 'A test site',
        category: 'monument',
        location: 'Test Location',
        imageUrl: 'http://example.com/image.jpg',
        isFeatured: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = site.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Test Site');
      expect(json['description'], 'A test site');
      expect(json['category'], 'monument');
      expect(json['location'], 'Test Location');
      expect(json['imageUrl'], 'http://example.com/image.jpg');
      expect(json['isFeatured'], true);
      expect(json['createdAt'], '2023-01-01T00:00:00.000Z');
    });

    test('Site.copyWith should create a copy with modified fields', () {
      final original = Site(
        id: '1',
        name: 'Original',
        description: 'Original desc',
        category: 'monument',
        location: 'Original loc',
        imageUrl: 'original.jpg',
        isFeatured: false,
        createdAt: DateTime.now(),
      );

      final copy = original.copyWith(
        name: 'Modified',
        isFeatured: true,
      );

      expect(copy.id, '1');
      expect(copy.name, 'Modified');
      expect(copy.description, 'Original desc');
      expect(copy.category, 'monument');
      expect(copy.location, 'Original loc');
      expect(copy.imageUrl, 'original.jpg');
      expect(copy.isFeatured, true);
      expect(copy.createdAt, original.createdAt);
    });

    test('getCategoryColor should return correct color for monument', () {
      final site = Site(
        id: '1',
        name: 'Test',
        description: 'Test',
        category: 'monument',
        location: 'Test',
        imageUrl: 'test.jpg',
      );

      expect(site.getCategoryColor(), '#8EA58C');
    });

    test('getCategoryColor should return correct color for musée', () {
      final site = Site(
        id: '1',
        name: 'Test',
        description: 'Test',
        category: 'musée',
        location: 'Test',
        imageUrl: 'test.jpg',
      );

      expect(site.getCategoryColor(), '#738A6E');
    });

    test('getCategoryColor should return correct color for parc', () {
      final site = Site(
        id: '1',
        name: 'Test',
        description: 'Test',
        category: 'parc',
        location: 'Test',
        imageUrl: 'test.jpg',
      );

      expect(site.getCategoryColor(), '#344C3D');
    });

    test('getCategoryColor should return correct color for plage', () {
      final site = Site(
        id: '1',
        name: 'Test',
        description: 'Test',
        category: 'plage',
        location: 'Test',
        imageUrl: 'test.jpg',
      );

      expect(site.getCategoryColor(), '#BFCFBB');
    });

    test('getCategoryColor should return default color for unknown category',
        () {
      final site = Site(
        id: '1',
        name: 'Test',
        description: 'Test',
        category: 'unknown',
        location: 'Test',
        imageUrl: 'test.jpg',
      );

      expect(site.getCategoryColor(), '#8EA58C');
    });
  });
}
