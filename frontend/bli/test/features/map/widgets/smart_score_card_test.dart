import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/features/map/models/livability_score.dart';
import 'package:bli/features/map/models/location.dart';
import 'package:bli/features/map/models/location_marker.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockFavoritesBloc extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

class FakeFavoritesEvent extends Fake implements FavoritesEvent {}

void main() {
  group('SmartScoreCard', () {
    late MockAuthBloc mockAuthBloc;
    late MockFavoritesBloc mockFavoritesBloc;

    final mockScore = const LivabilityScore(
      score: 85.0,
      baseScore: 50.0,
      summary: 'Great place',
      factors: [],
      nearbyFeatures: {},
      location: Location(latitude: 53.0793, longitude: 8.8017),
    );

    final mockMarker = LocationMarker(
      position: const LatLng(53.0793, 8.8017),
      address: 'Test Address',
    );

    setUpAll(() {
      registerFallbackValue(FakeFavoritesEvent());
    });

    setUp(() {
      mockAuthBloc = MockAuthBloc();
      mockFavoritesBloc = MockFavoritesBloc();
    });

    Widget createWidgetUnderTests(Widget widget) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<FavoritesBloc>.value(value: mockFavoritesBloc),
        ],
        child: MaterialApp(home: Scaffold(body: widget)),
      );
    }

    testWidgets('renders ScoreCard with correct data', (tester) async {
      when(() => mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(
        createWidgetUnderTests(
          ScoreCard(score: mockScore, selectedMarker: mockMarker),
        ),
      );

      expect(find.text('85.0/100'), findsOneWidget);
      expect(find.text('Great place'), findsOneWidget);
    });

    testWidgets('shows filled heart when location is favorite', (tester) async {
      final favorite = FavoriteAddress(
        id: '1',
        label: 'Test Address',
        latitude: 53.0793,
        longitude: 8.8017,
        createdAt: DateTime.now(),
      );

      when(
        () => mockFavoritesBloc.state,
      ).thenReturn(FavoritesState(favorites: [favorite]));

      await tester.pumpWidget(
        createWidgetUnderTests(
          ScoreCard(score: mockScore, selectedMarker: mockMarker),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('shows outline heart when location is not favorite', (
      tester,
    ) async {
      when(() => mockFavoritesBloc.state).thenReturn(const FavoritesState());

      await tester.pumpWidget(
        createWidgetUnderTests(
          ScoreCard(score: mockScore, selectedMarker: mockMarker),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('shows error snackbar when guest tries to favorite', (
      tester,
    ) async {
      when(() => mockFavoritesBloc.state).thenReturn(const FavoritesState());
      when(
        () => mockAuthBloc.state,
      ).thenReturn(AuthState(user: AppUser.guest()));

      await tester.pumpWidget(
        createWidgetUnderTests(
          ScoreCard(score: mockScore, selectedMarker: mockMarker),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(find.text('Please sign in to save favorites'), findsOneWidget);
    });

    testWidgets('adds favorite when authenticated user taps heart', (
      tester,
    ) async {
      when(() => mockFavoritesBloc.state).thenReturn(const FavoritesState());
      when(() => mockAuthBloc.state).thenReturn(
        const AuthState(
          user: AppUser(
            id: 'user-1',
            email: 'test@test.com',
            provider: AppAuthProvider.email,
          ),
        ),
      );

      await tester.pumpWidget(
        createWidgetUnderTests(
          ScoreCard(score: mockScore, selectedMarker: mockMarker),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));

      // Verify bloc event was added
      verify(
        () => mockFavoritesBloc.add(any(that: isA<FavoritesEvent>())),
      ).called(1);
    });
  });
}
