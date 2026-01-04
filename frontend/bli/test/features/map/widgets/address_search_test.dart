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
              onLocationSelected: (_, __) {},
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

    testWidgets('shows results list when API returns results', (tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSearchWidget(
              onLocationSelected: (_, __) {},
              onClose: () {},
              apiService: mockApi,
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

      expect(find.text('Test Location 1'), findsOneWidget);
      expect(find.text('Test Location 2'), findsOneWidget);
    });

    testWidgets('calls onLocationSelected when a result is tapped', (
      tester,
    ) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSearchWidget(
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

      await tester.enterText(find.byType(TextField), 'Select');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      await tester.tap(find.text('Selected Road'));
      await tester.pump();

      expect(selectedLocation, const LatLng(50.0, 60.0));
      expect(selectedName, 'Selected Location');
    });

    testWidgets('shows error message on API failure', (tester) async {
      final mockApi = MockApiService(shouldThrow: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressSearchWidget(
              onLocationSelected: (_, __) {},
              onClose: () {},
              apiService: mockApi,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Error');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      expect(find.textContaining('Search failed'), findsOneWidget);
    });
  });
}
