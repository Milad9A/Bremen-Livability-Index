import 'package:bli/services/api_service.dart';
import 'package:bli/widgets/search_results_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchResultsList', () {
    testWidgets('shows loading indicator when searching', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: true,
              errorMessage: null,
              searchResults: const [],
              showNoResults: false,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when error exists', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: 'Network error occurred',
              searchResults: const [],
              showNoResults: false,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Network error occurred'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows no results message when empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: null,
              searchResults: const [],
              showNoResults: true,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('displays search results', (tester) async {
      final results = [
        GeocodeResult(
          latitude: 53.07,
          longitude: 8.80,
          displayName: 'Marktplatz, Bremen, Germany',
          address: {'road': 'Marktplatz'},
          type: 'place',
          importance: 0.9,
        ),
        GeocodeResult(
          latitude: 53.08,
          longitude: 8.81,
          displayName: 'Hauptbahnhof, Bremen, Germany',
          address: {'road': 'Hauptbahnhof'},
          type: 'station',
          importance: 0.8,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: null,
              searchResults: results,
              showNoResults: false,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Marktplatz'), findsOneWidget);
      expect(find.text('Hauptbahnhof'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('calls onResultSelected when tapping result', (tester) async {
      GeocodeResult? selectedResult;
      final result = GeocodeResult(
        latitude: 53.07,
        longitude: 8.80,
        displayName: 'Marktplatz, Bremen, Germany',
        address: {'road': 'Marktplatz'},
        type: 'place',
        importance: 0.9,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: null,
              searchResults: [result],
              showNoResults: false,
              onResultSelected: (r) => selectedResult = r,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult!.latitude, 53.07);
    });

    testWidgets('shows location icon for each result', (tester) async {
      final results = [
        GeocodeResult(
          latitude: 53.07,
          longitude: 8.80,
          displayName: 'Test Location',
          address: {'road': 'Test Road'},
          type: 'place',
          importance: 0.9,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: null,
              searchResults: results,
              showNoResults: false,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('uses road from address as title when available', (
      tester,
    ) async {
      final results = [
        GeocodeResult(
          latitude: 53.07,
          longitude: 8.80,
          displayName: 'Full Address, City, Country',
          address: {'road': 'Custom Road Name'},
          type: 'place',
          importance: 0.9,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: null,
              searchResults: results,
              showNoResults: false,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Custom Road Name'), findsOneWidget);
    });

    testWidgets('shows display name as subtitle', (tester) async {
      final results = [
        GeocodeResult(
          latitude: 53.07,
          longitude: 8.80,
          displayName: 'Full Address, City, Country',
          address: {'road': 'Road'},
          type: 'place',
          importance: 0.9,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: null,
              searchResults: results,
              showNoResults: false,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Full Address, City, Country'), findsOneWidget);
    });

    testWidgets('has dividers between results', (tester) async {
      final results = [
        GeocodeResult(
          latitude: 53.07,
          longitude: 8.80,
          displayName: 'Location 1',
          address: {'road': 'Road 1'},
          type: 'place',
          importance: 0.9,
        ),
        GeocodeResult(
          latitude: 53.08,
          longitude: 8.81,
          displayName: 'Location 2',
          address: {'road': 'Road 2'},
          type: 'place',
          importance: 0.8,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsList(
              isSearching: false,
              errorMessage: null,
              searchResults: results,
              showNoResults: false,
              onResultSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
