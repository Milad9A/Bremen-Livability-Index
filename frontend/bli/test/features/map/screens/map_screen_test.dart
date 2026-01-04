import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:bli/features/map/widgets/nearby_feature_layers.dart';
import 'package:bli/features/map/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bli/features/map/screens/map_screen.dart';
import 'package:bli/features/map/widgets/floating_search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' hide MapEvent;
import 'package:latlong2/latlong.dart';

import 'dart:async';
import 'dart:io';

// Mock ApiService to avoid real network calls and timers
class MockApiService implements ApiService {
  Completer<void>? analyzeCompleter;

  @override
  Future<bool> checkHealth() async => true;

  @override
  Future<LivabilityScore> analyzeLocation(double lat, double lon) async {
    // Wait for manual completion if completer is set
    if (analyzeCompleter != null) {
      await analyzeCompleter!.future;
    }
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

class TestHttpOverrides extends HttpOverrides {}

void main() {
  late MapBloc bloc;
  late MockApiService mockApiService;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    mockApiService = MockApiService();
    bloc = MapBloc(apiService: mockApiService);
  });

  tearDown(() {
    bloc.close();
  });

  group('MapScreen', () {
    testWidgets('renders FlutterMap', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('renders floating search bar initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      expect(find.byType(FloatingSearchBar), findsOneWidget);
    });

    testWidgets('renders location reset button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('does not show score card initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      // ScoreCard should not be visible when no location is selected
      expect(find.text('Livability Score'), findsNothing);
    });

    testWidgets('shows score card when score is loaded', (
      WidgetTester tester,
    ) async {
      final score = LivabilityScore(
        score: 85.0,
        baseScore: 50.0,
        summary: "Excellent Livability",
        factors: [],
        nearbyFeatures: {
          'park': [
            FeatureDetail(
              name: 'Central Park',
              distance: 100,
              type: FeatureType.park,
              geometry: {
                'type': 'Point',
                'coordinates': [8.8017, 53.0793],
              },
            ),
          ],
        },
        location: const Location(latitude: 53.0793, longitude: 8.8017),
      );

      // Trigger/Simulate analysis success
      bloc.add(
        MapEvent.analysisSucceeded(
          score,
          LatLng(score.location.latitude, score.location.longitude),
        ),
      );

      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));
      await tester.pump(); // Rebuild with new state

      expect(find.byType(ScoreCard), findsOneWidget);
      expect(find.text('85.0/100'), findsOneWidget);
    });

    testWidgets('shows error message card when error occurs', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load data';
      bloc.add(const MapEvent.analysisFailed(errorMessage));

      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows snackbar when bloc triggers onShowMessage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      const message = 'Test Message';
      // Trigger the callback
      bloc.onShowMessage?.call(message);

      await tester.pump(); // Trigger animation
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // Wait for animation

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('shows nearby features on map when score has features', (
      WidgetTester tester,
    ) async {
      final score = LivabilityScore(
        score: 85.0,
        baseScore: 50.0,
        summary: "Test",
        factors: [],
        nearbyFeatures: {
          'park': [
            FeatureDetail(
              name: 'Park',
              distance: 100,
              type: FeatureType.park,
              geometry: {
                'type': 'Point',
                'coordinates': [8.8, 53.0],
              },
            ),
          ],
        },
        location: const Location(latitude: 53.0, longitude: 8.8),
      );

      bloc.add(
        MapEvent.analysisSucceeded(
          score,
          LatLng(score.location.latitude, score.location.longitude),
        ),
      );

      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));
      await tester.pump();

      // NearbyFeatureLayers uses Markers, check if we can find something specific internal to it
      // or just check for the widget itself
      expect(find.byType(NearbyFeatureLayers), findsOneWidget);
    });

    testWidgets('tapping reset button resets map', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      // Find and tap the reset button
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pumpAndSettle();

      // Map should still be visible (reset doesn't hide it)
      expect(find.byType(FlutterMap), findsOneWidget);
    });
  });

  group('MapScreen with BLoC', () {
    testWidgets('MapScreen creates its own MapBloc', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      // The widget tree should contain a BlocProvider
      expect(find.byType(BlocProvider<MapBloc>), findsOneWidget);
    });

    testWidgets('MapScreen renders Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('MapScreen uses Stack for layering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: MapScreen(bloc: bloc)));

      expect(find.byType(Stack), findsWidgets);
    });
  });
}
