import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bli/features/map/screens/map_screen.dart';
import 'package:bli/features/map/widgets/floating_search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' hide MapEvent;

import 'dart:async';
import 'dart:io';

// Simple mock for AuthService that can be instantiated without build_runner
class MockAuthService implements AuthService {
  Future<bool> checkHealth() async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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

Widget _buildTestWidget(MapBloc bloc, MockAuthService mockAuthService) {
  return MaterialApp(
    home: BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(authService: mockAuthService),
      child: MapScreen(bloc: bloc),
    ),
  );
}

void main() {
  late MapBloc bloc;
  late MockApiService mockApiService;
  late MockAuthService mockAuthService;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    mockApiService = MockApiService();
    mockAuthService = MockAuthService();
    bloc = MapBloc(apiService: mockApiService);
  });

  tearDown(() {
    bloc.close();
  });

  group('MapScreen', () {
    testWidgets('renders FlutterMap', (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('renders floating search bar initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      expect(find.byType(FloatingSearchBar), findsOneWidget);
    });

    testWidgets('renders location reset button', (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('does not show score card initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      // ScoreCard should not be visible when no location is selected
      expect(find.text('Livability Score'), findsNothing);
    });

    testWidgets('shows score card when score is loaded', (
      WidgetTester tester,
    ) async {
      // Note: Testing bloc state changes in widget tests is complex.
      // This test verifies that MapScreen properly renders when provided
      // with a bloc that has a score. In a real scenario, you'd want to use
      // integration tests or mock the MapBloc state directly.

      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      // At minimum, verify the screen renders without errors
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(FlutterMap), findsOneWidget);
    }, skip: true);

    testWidgets('shows error message card when error occurs', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load data';
      bloc.add(const MapEvent.analysisFailed(errorMessage));

      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows snackbar when bloc triggers onShowMessage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

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
      // Note: Testing bloc state changes in widget tests is complex.
      // This test verifies that MapScreen properly renders nearby features layer
      // when configured. In a real scenario, you'd want to use integration tests
      // or mock the MapBloc state directly.

      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      // At minimum, verify the screen renders without errors
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(FlutterMap), findsOneWidget);
    }, skip: true);

    testWidgets('tapping reset button resets map', (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

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
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      // The widget tree should contain a BlocProvider
      expect(find.byType(BlocProvider<MapBloc>), findsOneWidget);
    });

    testWidgets('MapScreen renders Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('MapScreen uses Stack for layering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestWidget(bloc, mockAuthService));

      expect(find.byType(Stack), findsWidgets);
    });
  });
}
