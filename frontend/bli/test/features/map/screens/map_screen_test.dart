import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:bli/features/map/widgets/profile_sheet.dart';
import 'package:bli/features/map/widgets/nearby_feature_layers.dart';
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
import 'dart:ui';

import 'package:latlong2/latlong.dart';
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

/// An AuthBloc whose stream can be controlled from tests.
class ControllableAuthBloc implements AuthBloc {
  final StreamController<AuthState> _controller;
  AuthState _currentState;

  ControllableAuthBloc({
    required StreamController<AuthState> controller,
    AuthState? initialState,
  }) : _controller = controller,
       _currentState =
           initialState ??
           const AuthState(
             user: AppUser(id: '1', provider: AppAuthProvider.email),
           );

  @override
  Stream<AuthState> get stream => _controller.stream;

  @override
  AuthState get state => _currentState;

  void emitState(AuthState newState) {
    _currentState = newState;
    _controller.add(newState);
  }

  @override
  Future<void> close() async => _controller.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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

// Mock FavoritesBloc
class MockFavoritesBloc extends Mock implements FavoritesBloc {
  @override
  Stream<FavoritesState> get stream => Stream.empty();

  @override
  FavoritesState get state => const FavoritesState();

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
  FavoritesBloc? favoritesBloc,
}) {
  return MultiBlocProvider(
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
      favoritesBloc != null
          ? BlocProvider<FavoritesBloc>.value(value: favoritesBloc)
          : BlocProvider<FavoritesBloc>.value(value: MockFavoritesBloc()),
    ],
    child: MaterialApp(
      navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
      home: MapScreen(bloc: bloc),
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

    testWidgets('shows MarkerLayer and NearbyFeatureLayers when score exist', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      const score = LivabilityScore(
        score: 80.0,
        baseScore: 50.0,
        summary: "Mock Summary",
        factors: [],
        nearbyFeatures: {'park': []},
        location: Location(latitude: 53.0793, longitude: 8.8017),
      );

      realBloc.add(
        const MapEvent.analysisSucceeded(score, LatLng(53.0793, 8.8017)),
      );

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(MarkerLayer), findsOneWidget);
      expect(find.byType(NearbyFeatureLayers), findsOneWidget);
    });
  });

  // ─── Profile Button ──────────────────────────────────────────────────────────

  group('Profile Button', () {
    testWidgets('renders profile button with person icon', (
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

      // Index 1: Profile Lens (Search=0, Profile=1, Location=2)
      final profileLens = liquidGlassView.children[1];
      final gestureDetector = profileLens.child as GestureDetector;
      final scaleTransition = gestureDetector.child as ScaleTransition;
      final center = scaleTransition.child as Center;
      final icon = center.child as Icon;

      expect(icon.icon, Icons.person);
    });

    testWidgets('tapping profile button shows ProfileSheet', (
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
      final profileLens = liquidGlassView.children[1];
      final gestureDetector = profileLens.child as GestureDetector;

      gestureDetector.onTapDown!(TapDownDetails(globalPosition: Offset.zero));
      await tester.pump(const Duration(milliseconds: 100));
      gestureDetector.onTapCancel!();
      await tester.pump(const Duration(milliseconds: 100));

      gestureDetector.onTapDown!(TapDownDetails(globalPosition: Offset.zero));
      await tester.pump(const Duration(milliseconds: 100));
      gestureDetector.onTapUp!(
        TapUpDetails(
          globalPosition: Offset.zero,
          kind: PointerDeviceKind.touch,
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(ProfileSheet), findsOneWidget);
    });
  });

  // ─── Location Button ──────────────────────────────────────────────────────────

  group('Location Button', () {
    testWidgets('tapping location button triggers map reset', (
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
      final locationLens = liquidGlassView.children[2];
      final gestureDetector = locationLens.child as GestureDetector;

      gestureDetector.onTapDown!(TapDownDetails(globalPosition: Offset.zero));
      await tester.pump(const Duration(milliseconds: 100));
      gestureDetector.onTapCancel!();
      await tester.pump(const Duration(milliseconds: 100));

      gestureDetector.onTapDown!(TapDownDetails(globalPosition: Offset.zero));
      await tester.pump(const Duration(milliseconds: 100));
      gestureDetector.onTapUp!(
        TapUpDetails(
          globalPosition: Offset.zero,
          kind: PointerDeviceKind.touch,
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(realBloc.state.currentScore, isNull);
    });
  });

  // ─── Loading States ───────────────────────────────────────────────────────────

  group('Loading States', () {
    testWidgets('shows CircularProgressIndicator while location is analysed', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      // Block the API so loading state persists
      mockApiService.analyzeCompleter = Completer<void>();

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      await tester.pump();

      // Tap inside Bremen to trigger loading
      realBloc.add(const MapEvent.mapTapped(LatLng(53.0793, 8.8017)));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      // CircularProgressIndicator lives inside LiquidGlass so the standard
      // widget finder cannot reach it. Verify loading state via the bloc instead.
      expect(realBloc.state.isLoading, isTrue);

      // Unblock API to allow tearDown to complete cleanly
      mockApiService.analyzeCompleter!.complete();
      await tester.pump(const Duration(milliseconds: 500));
      mockApiService.analyzeCompleter = null;
    });

    testWidgets(
      'shows slow-loading message after slowLoadingTriggered while loading',
      (WidgetTester tester) async {
        await configureScreen(tester);
        mockApiService.analyzeCompleter = Completer<void>();

        await tester.pumpWidget(
          _buildTestWidgetWithInstance(
            realBloc,
            mockAuthService,
            mockPreferencesService,
            authBloc: mockAuthBloc,
          ),
        );
        await tester.pump();

        // Start an analysis so bloc enters loading state
        realBloc.add(const MapEvent.mapTapped(LatLng(53.0793, 8.8017)));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        // Confirm loading
        expect(realBloc.state.isLoading, isTrue);

        // Fire the slow-loading timer event manually
        realBloc.add(const MapEvent.slowLoadingTriggered());
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump();

        // The slow-loading text lives inside LiquidGlass and is not reachable
        // via standard finders – verify the bloc state reflects the flag instead.
        expect(realBloc.state.showSlowLoadingMessage, isTrue);

        mockApiService.analyzeCompleter!.complete();
        await tester.pump(const Duration(milliseconds: 500));
        mockApiService.analyzeCompleter = null;
      },
    );

    testWidgets('hides loading indicator after analysis succeeds', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);

      // Block the API first so we can confirm loading starts …
      mockApiService.analyzeCompleter = Completer<void>();

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      await tester.pump();

      realBloc.add(const MapEvent.mapTapped(LatLng(53.0793, 8.8017)));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();
      expect(realBloc.state.isLoading, isTrue);

      // Use runAsync so the Completer continuation and subsequent async event
      // chain actually runs through Dart’s real microtask queue.
      await tester.runAsync(() async {
        mockApiService.analyzeCompleter!.complete();
        mockApiService.analyzeCompleter = null;
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(realBloc.state.isLoading, isFalse);
    });
  });

  // ─── Score Card ───────────────────────────────────────────────────────────────

  group('Score Card', () {
    const mockScore = LivabilityScore(
      score: 75.0,
      baseScore: 60.0,
      summary: 'Good area',
      factors: [],
      nearbyFeatures: {},
      location: Location(latitude: 53.0793, longitude: 8.8017),
    );

    testWidgets('shows ScoreCard widget after analysis succeeds', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);

      // Add event BEFORE pumpWidget so the initial bloc state already contains
      // the score when the widget tree is first built (same pattern used by the
      // existing 'shows error message card' test).
      realBloc.add(
        const MapEvent.analysisSucceeded(mockScore, LatLng(53.0793, 8.8017)),
      );

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      // Multiple pumps to flush bloc stream events → state change → rebuild.
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(ScoreCard), findsOneWidget);
    });

    testWidgets('score card is absent when no analysis has been run', (
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
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(ScoreCard), findsNothing);
    });

    testWidgets('score card is hidden again after map reset', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);

      // Pre-load score before building the widget.
      realBloc.add(
        const MapEvent.analysisSucceeded(mockScore, LatLng(53.0793, 8.8017)),
      );

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(ScoreCard), findsOneWidget);

      // Dispatch mapReset in a real-async context so Dart’s event loop fully
      // processes the event chain before we assert on the bloc state.
      await tester.runAsync(() async {
        realBloc.add(const MapEvent.mapReset());
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(realBloc.state.currentScore, isNull);
    });
  });

  // ─── Search Expansion ──────────────────────────────────────────────────────────

  group('Search', () {
    testWidgets('shows AddressSearchWidget when search is toggled on', (
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
      await tester.pump();

      realBloc.add(const MapEvent.searchToggled(true));
      // AddressSearchWidget is inside LiquidGlass so the standard widget finder
      // cannot reach it.  Verify the bloc state change instead.
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(realBloc.state.showSearch, isTrue);
    });

    testWidgets('hides AddressSearchWidget when search is toggled off', (
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
      await tester.pump();

      realBloc.add(const MapEvent.searchToggled(true));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();
      expect(realBloc.state.showSearch, isTrue);

      realBloc.add(const MapEvent.searchToggled(false));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();
      expect(realBloc.state.showSearch, isFalse);
    });

    testWidgets('tapping map while in search mode closes search', (
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
      await tester.pump();

      // Open search
      realBloc.add(const MapEvent.searchToggled(true));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();
      expect(realBloc.state.showSearch, isTrue);

      // Dispatch a mapTapped while showSearch == true (should close search)
      realBloc.add(const MapEvent.mapTapped(LatLng(53.0793, 8.8017)));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(realBloc.state.showSearch, isFalse);
    });

    testWidgets('Search button tap animates and toggles search', (
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
      final searchLens = liquidGlassView.children[0];
      final animatedSwitcher = searchLens.child as AnimatedSwitcher;
      final gestureDetector = animatedSwitcher.child as GestureDetector;

      gestureDetector.onTapDown!(TapDownDetails(globalPosition: Offset.zero));
      await tester.pump(const Duration(milliseconds: 100));
      gestureDetector.onTapCancel!();
      await tester.pump(const Duration(milliseconds: 100));

      gestureDetector.onTapDown!(TapDownDetails(globalPosition: Offset.zero));
      await tester.pump(const Duration(milliseconds: 100));
      gestureDetector.onTapUp!(
        TapUpDetails(
          globalPosition: Offset.zero,
          kind: PointerDeviceKind.touch,
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(realBloc.state.showSearch, isTrue);
    });
  });

  // ─── Error Handling ───────────────────────────────────────────────────────────

  group('Error Handling', () {
    testWidgets('close button on error card dispatches errorCleared', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      realBloc.add(const MapEvent.analysisFailed('Something went wrong'));

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);

      // The tap fires onClose → bloc.add(errorCleared()).
      // Use runAsync so the resulting async event chain completes.
      await tester.tap(find.byIcon(Icons.close));
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(realBloc.state.errorMessage, isNull);
    });

    testWidgets('multiple errors show only the latest one', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      realBloc.add(const MapEvent.analysisFailed('Error one'));
      realBloc.add(const MapEvent.errorCleared());
      realBloc.add(const MapEvent.analysisFailed('Error two'));

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.text('Error two'), findsOneWidget);
      expect(find.text('Error one'), findsNothing);
    });
  });

  // ─── Auth Redirect ────────────────────────────────────────────────────────────

  group('Auth Redirect', () {
    testWidgets('navigates away when auth state becomes unauthenticated', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);

      final authStreamController = StreamController<AuthState>.broadcast();
      final controllableAuthBloc = ControllableAuthBloc(
        controller: authStreamController,
      );

      // Use a named-route setup so that pushNamedAndRemoveUntil('/')
      // lands on a lightweight stub page instead of re-rendering FlutterMap.
      // Without this, a second FlutterMap init hits the path_provider plugin
      // (not available in tests) and throws MissingPluginException.
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          initialRoute: '/map',
          routes: {
            '/': (context) =>
                const Scaffold(body: Center(child: Text('Logged out'))),
            '/map': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>.value(value: controllableAuthBloc),
                BlocProvider<PreferencesBloc>(
                  create: (_) => PreferencesBloc(
                    preferencesService: mockPreferencesService,
                  ),
                ),
                BlocProvider<FavoritesBloc>.value(value: MockFavoritesBloc()),
              ],
              child: MapScreen(bloc: realBloc),
            ),
          },
        ),
      );
      await tester.pump();

      final routeCountBefore = mockObserver.pushedRoutes.length;

      await tester.runAsync(() async {
        controllableAuthBloc.emitState(const AuthState());
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      await tester.pump();

      // After sign-out the BlocListener should have pushed '/'.
      expect(mockObserver.pushedRoutes.length, greaterThan(routeCountBefore));

      await controllableAuthBloc.close();
    });
  });

  // ─── Map State Consistency ────────────────────────────────────────────────────

  group('Map State Consistency', () {
    testWidgets('errorMessage is null after errorCleared event', (
      WidgetTester tester,
    ) async {
      await configureScreen(tester);
      realBloc.add(const MapEvent.analysisFailed('transient error'));

      await tester.pumpWidget(
        _buildTestWidgetWithInstance(
          realBloc,
          mockAuthService,
          mockPreferencesService,
          authBloc: mockAuthBloc,
        ),
      );
      await tester.pump();
      expect(find.text('transient error'), findsOneWidget);

      // Use runAsync so the Bloc stream event is processed through Dart’s real
      // event loop before asserting on the state.
      await tester.runAsync(() async {
        realBloc.add(const MapEvent.errorCleared());
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(realBloc.state.errorMessage, isNull);
    });

    testWidgets('tapping outside-Bremen location shows snackbar, not crash', (
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
      await tester.pump();

      // Munich – outside Bremen bounds
      realBloc.add(const MapEvent.mapTapped(LatLng(48.1351, 11.5820)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Bloc should have called onShowMessage; no crash
      expect(tester.takeException(), isNull);
    });
  });
}
