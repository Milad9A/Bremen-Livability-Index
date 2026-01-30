import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';

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

// Mock AuthBloc
class MockAuthBloc extends Mock implements AuthBloc {
  @override
  Stream<AuthState> get stream =>
      super.noSuchMethod(
            Invocation.getter(#stream),
            returnValue: Stream<AuthState>.empty(),
          )
          as Stream<AuthState>;

  @override
  AuthState get state =>
      super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: const AuthState(),
          )
          as AuthState;

  @override
  Future<void> close() => Future.value();
}

// Mock MapBloc
class MockMapBloc extends Mock implements MapBloc {
  final MapController _mapController = MapController();

  @override
  MapController get mapController => _mapController;

  @override
  Stream<MapState> get stream =>
      super.noSuchMethod(
            Invocation.getter(#stream),
            returnValue: Stream<MapState>.empty(),
          )
          as Stream<MapState>;

  @override
  MapState get state =>
      super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: MapState.initial(),
          )
          as MapState;

  @override
  Future<void> close() => Future.value();
}

class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
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

// Helper to wrap MapScreen when we want to inject a specific instance
Widget _buildTestWidgetWithInstance(
  MapBloc bloc,
  MockAuthService mockAuthService,
  MockPreferencesService mockPreferencesService, {
  NavigatorObserver? navigatorObserver,
  AuthBloc? authBloc,
}) {
  return MaterialApp(
    navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
    home: MultiBlocProvider(
      providers: [
        authBloc != null
            ? BlocProvider<AuthBloc>.value(value: authBloc)
            : BlocProvider<AuthBloc>(
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
  Future<void> configureScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  late MapBloc realBloc;
  late MockMapBloc mockBloc;
  late MockApiService mockApiService;
  late MockAuthService mockAuthService;
  late MockPreferencesService mockPreferencesService;
  late TestNavigatorObserver mockObserver;
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    mockApiService = MockApiService();
    mockAuthService = MockAuthService();
    mockPreferencesService = MockPreferencesService();
    mockObserver = TestNavigatorObserver();
    mockAuthBloc = MockAuthBloc();
    realBloc = MapBloc(apiService: mockApiService);
    mockBloc = MockMapBloc();

    // Default to authenticated
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());
    when(mockAuthBloc.state).thenReturn(
      const AuthState(
        user: AppUser(id: '1', provider: AppAuthProvider.email),
      ),
    );
  });

  tearDown(() {
    realBloc.close();
    mockBloc.close();
  });

  group('MapScreen Integration', () {
    testWidgets('renders FlutterMap', (WidgetTester tester) async {
      await configureScreen(tester);
      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
          navigatorObserver: mockObserver,
        ),
      );

      await tester.pump(const Duration(seconds: 1)); // Allow initial animation
      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('renders search icon (manual inspection)', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
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
      await configureScreen(tester);
      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
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
      await configureScreen(tester);
      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      await tester.pump(const Duration(seconds: 1)); // Allow animations

      // Score card starts collapsed - just verify "Livability Score" header not visible
      expect(find.text('Livability Score'), findsNothing);
    });

    testWidgets('shows error message card when error occurs', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      const errorMessage = 'Failed to load data';
      realBloc.add(const MapEvent.analysisFailed(errorMessage));

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows snackbar when bloc triggers onShowMessage', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );

      const message = 'Test Message';
      // Trigger the callback
      realBloc.onShowMessage?.call(message);

      await tester.pump(); // Trigger animation
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text(message), findsOneWidget);
    });
  });
}
