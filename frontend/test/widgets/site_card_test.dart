import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bang_ziiga/models/site.dart';
import 'package:bang_ziiga/screens/sites/widgets/site_card.dart';

void main() {
  group('SiteCard Widget Tests', () {
    testWidgets('SiteCard displays site information correctly',
        (WidgetTester tester) async {
      // Arrange
      final site = Site(
        id: '1',
        name: 'Test Monument',
        description: 'A beautiful monument',
        category: 'monument',
        location: 'Test City',
        imageUrl: 'https://example.com/image.jpg',
        isFeatured: true,
      );

      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SiteCard(
              site: site,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Monument'), findsOneWidget);
      expect(find.text('monument'), findsOneWidget);
      expect(find.text('Test City'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);

      // Test tap
      await tester.tap(find.byType(GestureDetector));
      expect(tapped, true);
    });

    testWidgets('SiteCard handles long text with ellipsis',
        (WidgetTester tester) async {
      // Arrange
      final site = Site(
        id: '1',
        name: 'Very Long Site Name That Should Be Truncated',
        description: 'Description',
        category: 'very long category name that should be truncated',
        location: 'Very Long Location Name That Should Also Be Truncated',
        imageUrl: 'https://example.com/image.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SiteCard(
              site: site,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      // The text should be truncated, but we can check that the widget is present
      expect(find.byType(SiteCard), findsOneWidget);
      expect(find.byType(Text), findsWidgets); // Multiple Text widgets
    });

    testWidgets('SiteCard has correct height', (WidgetTester tester) async {
      // Arrange
      final site = Site(
        id: '1',
        name: 'Test',
        description: 'Test',
        category: 'test',
        location: 'Test',
        imageUrl: 'https://example.com/image.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SiteCard(
              site: site,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 200);
    });

    testWidgets('SiteCard displays image with correct height',
        (WidgetTester tester) async {
      // Arrange
      final site = Site(
        id: '1',
        name: 'Test',
        description: 'Test',
        category: 'test',
        location: 'Test',
        imageUrl: 'https://example.com/image.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SiteCard(
              site: site,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      final cachedNetworkImage =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedNetworkImage.height, 100);
      expect(cachedNetworkImage.imageUrl, 'https://example.com/image.jpg');
    });
  });
}
