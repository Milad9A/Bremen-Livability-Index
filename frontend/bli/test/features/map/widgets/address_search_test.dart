import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/features/map/widgets/address_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

class MockApiService extends ApiService {
  final List<GeocodeResult> mockResults;
  final bool shouldThrow;

  MockApiService({this.mockResults = const [], this.shouldThrow = false});

  @override
  Future<List<GeocodeResult>> geocodeAddress(
    String query, {
    int limit = 5,
  }) async {
    if (shouldThrow) {
      throw Exception('Mock Error');
    }
    return mockResults;
  }
}

void main() {
  group('AddressSearchWidget', () {
    testWidgets('renders initial layout correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSearchWidget(
              onLocationSelected: (_, _) {},
              onClose: () {},
            ),
          ),
        ),
      );

      expect(find.text('Search for an address...'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onSearchStateChanged with results from API', (
      tester,
    ) async {
      final List<GeocodeResult> mockResults = [
        GeocodeResult(
          displayName: 'Test Location 1',
          latitude: 10.0,
          longitude: 20.0,
          address: {'road': 'Road 1'},
          type: 'city',
          importance: 0.5,
        ),
        GeocodeResult(
          displayName: 'Test Location 2',
          latitude: 30.0,
          longitude: 40.0,
          address: {'road': 'Road 2'},
          type: 'city',
          importance: 0.4,
        ),
      ];

      final mockApi = MockApiService(mockResults: mockResults);
      List<GeocodeResult>? receivedResults;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSearchWidget(
              onLocationSelected: (_, _) {},
              onClose: () {},
              apiService: mockApi,
              onSearchStateChanged: (results, isSearching, error, hasQuery) {
                receivedResults = results;
              },
            ),
          ),
        ),
      );

      // Enter text to trigger search
      await tester.enterText(find.byType(TextField), 'Test');

      // Wait for debounce (500ms)
      await tester.pump(const Duration(milliseconds: 500));

      // Wait for future to complete and rebuild
      await tester.pump();

      // Note: Widget only renders input - results are provided via callback
      expect(receivedResults, isNotNull);
      expect(receivedResults!.length, 2);
      expect(receivedResults![0].displayName, 'Test Location 1');
    });

    testWidgets('selectResult method calls onLocationSelected', (tester) async {
      final mockResult = GeocodeResult(
        displayName: 'Selected Location',
        latitude: 50.0,
        longitude: 60.0,
        address: {'road': 'Selected Road'},
        type: 'city',
        importance: 0.5,
      );

      final mockApi = MockApiService(mockResults: [mockResult]);

      LatLng? selectedLocation;
      String? selectedName;

      final GlobalKey<State<AddressSearchWidget>> widgetKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSearchWidget(
              key: widgetKey,
              onLocationSelected: (loc, name) {
                selectedLocation = loc;
                selectedName = name;
              },
              onClose: () {},
              apiService: mockApi,
            ),
          ),
        ),
      );

      // Access the state and call selectResult directly
      final state = widgetKey.currentState as dynamic;
      state.selectResult(mockResult);
      await tester.pump();

      expect(selectedLocation, const LatLng(50.0, 60.0));
      expect(selectedName, 'Selected Location');
    });

    testWidgets('calls onSearchStateChanged with error on API failure', (
      tester,
    ) async {
      final mockApi = MockApiService(shouldThrow: true);
      String? receivedError;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSearchWidget(
              onLocationSelected: (_, _) {},
              onClose: () {},
              apiService: mockApi,
              onSearchStateChanged: (results, isSearching, error, hasQuery) {
                receivedError = error;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Error');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Error is provided via callback, not displayed in widget
      expect(receivedError, isNotNull);
      expect(receivedError, contains('Unable to search'));
    });
  });
}
