import 'package:bli/models/models.dart';
import 'package:bli/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bli/screens/map_screen.dart';
import 'package:bli/viewmodels/map_viewmodel.dart';
import 'package:bli/widgets/floating_search_bar.dart';
import 'package:bli/widgets/address_search.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

// Mock ApiService to avoid real network calls and timers
class MockApiService implements ApiService {
  @override
  Future<bool> checkHealth() async => true;

  @override
  Future<LivabilityScore> analyzeLocation(double lat, double lon) async {
    return const LivabilityScore(
      score: 80.0,
      baseScore: 50.0,
      summary: "Mock Summary",
      factors: [],
      nearbyFeatures: {},
      location: Location(latitude: 53.0793, longitude: 8.8017),
    );
  }

  @override
  Future<List<GeocodeResult>> geocodeAddress(
    String query, {
    int limit = 5,
  }) async {
    return [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MapViewModel viewModel;

  setUp(() {
    viewModel = MapViewModel(apiService: MockApiService());
  });

  group('MapScreen', () {
    testWidgets('renders FlutterMap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('renders floating search bar initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      expect(find.byType(FloatingSearchBar), findsOneWidget);
    });

    testWidgets('renders location reset button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('does not show score card initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      // ScoreCard should not be visible when no location is selected
      expect(find.text('Livability Score'), findsNothing);
    });

    testWidgets('does not show error banner initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      expect(find.byIcon(Icons.error_outline), findsNothing);
    });

    testWidgets('does not show loading overlay initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('tapping search bar area shows address search', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      // Tap on the floating search bar
      await tester.tap(find.byType(FloatingSearchBar));
      await tester.pumpAndSettle();

      // FloatingSearchBar should be replaced with AddressSearchWidget
      expect(find.byType(FloatingSearchBar), findsNothing);
      expect(find.byType(AddressSearchWidget), findsOneWidget);
    });

    testWidgets('tapping reset button resets map', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      // Find and tap the reset button
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pumpAndSettle();

      // Map should still be visible (reset doesn't hide it)
      expect(find.byType(FlutterMap), findsOneWidget);
    });
  });

  group('MapScreen with Provider', () {
    testWidgets('MapScreen creates its own MapViewModel', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      // The widget tree should contain a ChangeNotifierProvider
      expect(find.byType(ChangeNotifierProvider<MapViewModel>), findsOneWidget);
    });

    testWidgets('MapScreen renders Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('MapScreen uses Stack for layering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: MapScreen(viewModel: viewModel)),
      );

      expect(find.byType(Stack), findsWidgets);
    });
  });
}
