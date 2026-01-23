import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/features/favorites/services/favorites_service.dart';
import 'package:bli/features/map/models/livability_score.dart';
import 'package:bli/features/map/models/location.dart';
import 'package:bli/features/map/models/location_marker.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:bli/features/map/widgets/smart_score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

// Simple mock for AuthService
class MockAuthService implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Simple mock for FavoritesService
class MockFavoritesService implements FavoritesService {
  @override
  Stream<List<FavoriteAddress>> getFavorites(String userId) => Stream.value([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Helper to create a LivabilityScore for testing
LivabilityScore createTestScore({
  double score = 75.0,
  double baseScore = 40.0,
  String summary = 'Test summary',
}) {
  return LivabilityScore(
    score: score,
    baseScore: baseScore,
    location: const Location(latitude: 53.0793, longitude: 8.8017),
    factors: [],
    nearbyFeatures: {},
    summary: summary,
  );
}

void main() {
  late MockAuthService mockAuthService;
  late MockFavoritesService mockFavoritesService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockFavoritesService = MockFavoritesService();
  });

  Widget buildTestWidget({
    required LivabilityScore score,
    LocationMarker? selectedMarker,
  }) {
    final authBloc = AuthBloc(authService: mockAuthService);
    final favoritesBloc = FavoritesBloc(favoritesService: mockFavoritesService);

    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<FavoritesBloc>.value(value: favoritesBloc),
          ],
          child: SingleChildScrollView(
            child: SmartScoreCard(score: score, selectedMarker: selectedMarker),
          ),
        ),
      ),
    );
  }

  group('SmartScoreCard', () {
    testWidgets('renders ScoreCard with provided score', (tester) async {
      final score = createTestScore(score: 85.0);

      await tester.pumpWidget(buildTestWidget(score: score));

      expect(find.byType(ScoreCard), findsOneWidget);
      expect(find.text('85.0/100'), findsOneWidget);
    });

    testWidgets('displays Livability Score header', (tester) async {
      final score = createTestScore();

      await tester.pumpWidget(buildTestWidget(score: score));

      expect(find.text('Livability Score'), findsOneWidget);
    });

    testWidgets('displays summary text', (tester) async {
      final score = createTestScore(summary: 'Great neighborhood');

      await tester.pumpWidget(buildTestWidget(score: score));

      expect(find.text('Great neighborhood'), findsOneWidget);
    });

    testWidgets('shows unfilled heart when location is not a favorite', (
      tester,
    ) async {
      final score = createTestScore();
      final marker = LocationMarker(
        position: const LatLng(53.0793, 8.8017),
        score: 75.0,
        address: 'Test Address',
      );

      await tester.pumpWidget(
        buildTestWidget(score: score, selectedMarker: marker),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('uses BlocBuilder for FavoritesBloc', (tester) async {
      final score = createTestScore();

      await tester.pumpWidget(buildTestWidget(score: score));

      expect(
        find.byType(BlocBuilder<FavoritesBloc, FavoritesState>),
        findsOneWidget,
      );
    });

    testWidgets('renders Card with elevation', (tester) async {
      final score = createTestScore();

      await tester.pumpWidget(buildTestWidget(score: score));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays base score chip', (tester) async {
      final score = createTestScore(baseScore: 50.0);

      await tester.pumpWidget(buildTestWidget(score: score));

      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('has expand/collapse arrow button', (tester) async {
      final score = createTestScore();

      await tester.pumpWidget(buildTestWidget(score: score));

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });
  });
}
