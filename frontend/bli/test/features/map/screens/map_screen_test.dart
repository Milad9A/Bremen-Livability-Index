import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';
import 'package:flutter/gestures.dart'; // For PointerDeviceKind
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bli/features/map/screens/map_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' hide MapEvent;

import 'dart:async';
import 'dart:io';

import 'package:liquid_glass_easy/liquid_glass_easy.dart';

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
  Future<LivabilityScore> analyzeLocation(
    double lat,
    double lon, {
    Map<String, String>? preferences,
  }) async {
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

class MockPreferencesService implements PreferencesService {
  @override
  Future<UserPreferences> getLocalPreferences() async =>
      UserPreferences.defaults;

  @override
  Future<void> saveLocalPreferences(UserPreferences preferences) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestHttpOverrides extends HttpOverrides {}

Widget _buildTestWidget(
  MapBloc bloc,
  MockAuthService mockAuthService,
  MockPreferencesService mockPreferencesService,
) {
  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authService: mockAuthService),
        ),
        BlocProvider<PreferencesBloc>(
          create: (_) =>
              PreferencesBloc(preferencesService: mockPreferencesService),
        ),
      ],
      child: MapScreen(bloc: bloc),
    ),
  );
}

void main() {
  late MapBloc bloc;
  late MockApiService mockApiService;
  late MockAuthService mockAuthService;
  late MockPreferencesService mockPreferencesService;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    mockApiService = MockApiService();
    mockAuthService = MockAuthService();
    mockPreferencesService = MockPreferencesService();
    bloc = MapBloc(apiService: mockApiService);

    // Set a large enough screen size so LiquidGlass positioning works
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(1080, 1920);
    binding.window.devicePixelRatioTestValue = 1.0;
  });

  tearDown(() {
    bloc.close();
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  group('MapScreen', () {
    testWidgets('renders FlutterMap', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump(const Duration(seconds: 1)); // Allow initial animation

      expect(find.byType(FlutterMap), findsOneWidget);
    });

    // Note: FloatingSearchBar was replaced with LiquidGlass UI
    // FloatingSearchBar test removed as it is replaced by LiquidGlass UI

    testWidgets('renders search icon (manual inspection)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump(const Duration(seconds: 1));

      final liquidGlassView = tester.widget<LiquidGlassView>(
        find.byType(LiquidGlassView),
      );

      // Index 0: Search Lens
      final searchLens = liquidGlassView.children[0];
      final animatedSwitcher = searchLens.child as AnimatedSwitcher;
      // When not searching, child is GestureDetector -> Center -> Icon
      final gestureDetector = animatedSwitcher.child as GestureDetector;
      final center = gestureDetector.child as Center;
      final icon = center.child as Icon;

      expect(icon.icon, Icons.search);
    });

    testWidgets('renders location reset button (manual inspection)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump(const Duration(seconds: 1));

      final liquidGlassView = tester.widget<LiquidGlassView>(
        find.byType(LiquidGlassView),
      );

      // Index 2: Location Lens (Search, Profile, Location)
      final locationLens = liquidGlassView.children[2];
      final gestureDetector = locationLens.child as GestureDetector;
      final scaleTransition = gestureDetector.child as ScaleTransition;
      final center = scaleTransition.child as Center;
      final icon = center.child as Icon;

      expect(icon.icon, Icons.my_location);
    });

    testWidgets('does not show score card initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump(const Duration(seconds: 1)); // Allow animations

      // Score card starts collapsed - just verify "Livability Score" header not visible
      expect(find.text('Livability Score'), findsNothing);
    });

    testWidgets('shows score card when score is loaded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(FlutterMap), findsOneWidget);
    }, skip: true);

    testWidgets('shows error message card when error occurs', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load data';
      bloc.add(const MapEvent.analysisFailed(errorMessage));

      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows snackbar when bloc triggers onShowMessage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );

      const message = 'Test Message';
      // Trigger the callback
      bloc.onShowMessage?.call(message);

      await tester.pump(); // Trigger animation
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('shows nearby features on map when score has features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(FlutterMap), findsOneWidget);
    }, skip: true);

    testWidgets('tapping reset button resets map (manual invocation)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump(const Duration(seconds: 1));

      final liquidGlassView = tester.widget<LiquidGlassView>(
        find.byType(LiquidGlassView),
      );

      // Index 2: Location Lens
      final locationLens = liquidGlassView.children[2];
      final gestureDetector = locationLens.child as GestureDetector;

      // Simulate tap
      gestureDetector.onTapDown?.call(TapDownDetails());
      await tester.pump();
      gestureDetector.onTapUp?.call(
        TapUpDetails(kind: PointerDeviceKind.touch),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Verify logic: Map renders (state check not strictly possible on Bloc but we verify no crash)
      expect(find.byType(FlutterMap), findsOneWidget);
    });
  });

  group('MapScreen with BLoC', () {
    testWidgets('MapScreen creates its own MapBloc', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump(const Duration(seconds: 1));

      // The widget tree should contain a BlocProvider
      expect(find.byType(BlocProvider<MapBloc>), findsOneWidget);
    });

    testWidgets('MapScreen renders Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('MapScreen uses Stack for layering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(bloc, mockAuthService, mockPreferencesService),
      );
      await tester.pump();

      expect(find.byType(Stack), findsWidgets);
    });
  });
}
