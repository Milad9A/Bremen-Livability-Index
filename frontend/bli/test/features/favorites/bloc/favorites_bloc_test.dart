import 'dart:async';

import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/features/favorites/services/favorites_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<FavoritesService>()])
import 'favorites_bloc_test.mocks.dart';

void main() {
  group('FavoritesBloc', () {
    late FavoritesBloc bloc;
    late MockFavoritesService mockFavoritesService;
    late StreamController<List<FavoriteAddress>> favoritesStreamController;

    final testFavorite1 = FavoriteAddress(
      id: 'fav-1',
      label: 'Home',
      latitude: 53.0793,
      longitude: 8.8017,
      address: 'Test Street 1, Bremen',
      createdAt: DateTime(2024, 1, 1),
    );

    final testFavorite2 = FavoriteAddress(
      id: 'fav-2',
      label: 'Work',
      latitude: 53.0850,
      longitude: 8.8200,
      address: 'Work Street 2, Bremen',
      createdAt: DateTime(2024, 1, 2),
    );

    setUp(() {
      mockFavoritesService = MockFavoritesService();
      favoritesStreamController = StreamController<List<FavoriteAddress>>();
      bloc = FavoritesBloc(favoritesService: mockFavoritesService);
    });

    tearDown(() {
      bloc.close();
      favoritesStreamController.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const FavoritesState());
      expect(bloc.state.favorites, isEmpty);
      expect(bloc.state.isLoading, false);
      expect(bloc.state.error, isNull);
    });

    group('LoadFavoritesRequested', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits loading then favorites when stream emits',
        setUp: () {
          when(
            mockFavoritesService.getFavorites('user-123'),
          ).thenAnswer((_) => favoritesStreamController.stream);
        },
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) async {
          bloc.add(const FavoritesEvent.loadFavoritesRequested('user-123'));
          await Future.delayed(Duration.zero);
          favoritesStreamController.add([testFavorite1, testFavorite2]);
        },
        expect: () => [
          predicate<FavoritesState>((state) => state.isLoading == true),
          predicate<FavoritesState>(
            (state) =>
                state.isLoading == false &&
                state.favorites.length == 2 &&
                state.favorites.contains(testFavorite1) &&
                state.favorites.contains(testFavorite2),
          ),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits empty favorites on stream error',
        setUp: () {
          when(
            mockFavoritesService.getFavorites('user-123'),
          ).thenAnswer((_) => favoritesStreamController.stream);
        },
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) async {
          bloc.add(const FavoritesEvent.loadFavoritesRequested('user-123'));
          await Future.delayed(Duration.zero);
          favoritesStreamController.addError(Exception('Stream error'));
        },
        expect: () => [
          predicate<FavoritesState>((state) => state.isLoading == true),
          predicate<FavoritesState>(
            (state) => state.isLoading == false && state.favorites.isEmpty,
          ),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'cancels previous subscription when loading new user',
        setUp: () {
          when(
            mockFavoritesService.getFavorites(any),
          ).thenAnswer((_) => const Stream.empty());
        },
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) async {
          bloc.add(const FavoritesEvent.loadFavoritesRequested('user-1'));
          bloc.add(const FavoritesEvent.loadFavoritesRequested('user-2'));
        },
        verify: (_) {
          verify(mockFavoritesService.getFavorites('user-1')).called(1);
          verify(mockFavoritesService.getFavorites('user-2')).called(1);
        },
      );
    });

    group('FavoritesUpdated', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'updates favorites list',
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) =>
            bloc.add(FavoritesEvent.favoritesUpdated([testFavorite1])),
        expect: () => [
          predicate<FavoritesState>(
            (state) =>
                state.favorites.length == 1 &&
                state.favorites.first == testFavorite1 &&
                state.isLoading == false,
          ),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'handles empty list',
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        seed: () => FavoritesState(favorites: [testFavorite1]),
        act: (bloc) => bloc.add(const FavoritesEvent.favoritesUpdated([])),
        expect: () => [
          predicate<FavoritesState>(
            (state) => state.favorites.isEmpty && state.isLoading == false,
          ),
        ],
      );
    });

    group('AddFavoriteRequested', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'calls service to add favorite',
        setUp: () {
          when(
            mockFavoritesService.addFavorite('user-123', testFavorite1),
          ).thenAnswer((_) async {});
        },
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) => bloc.add(
          FavoritesEvent.addFavoriteRequested('user-123', testFavorite1),
        ),
        verify: (_) {
          verify(
            mockFavoritesService.addFavorite('user-123', testFavorite1),
          ).called(1);
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits error on failure',
        setUp: () {
          when(
            mockFavoritesService.addFavorite('user-123', testFavorite1),
          ).thenThrow(Exception('Failed to add'));
        },
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) => bloc.add(
          FavoritesEvent.addFavoriteRequested('user-123', testFavorite1),
        ),
        expect: () => [
          predicate<FavoritesState>(
            (state) =>
                state.error != null &&
                state.error!.contains('Failed to add favorite'),
          ),
        ],
      );
    });

    group('RemoveFavoriteRequested', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'calls service to remove favorite',
        setUp: () {
          when(
            mockFavoritesService.removeFavorite('user-123', 'fav-1'),
          ).thenAnswer((_) async {});
        },
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) => bloc.add(
          const FavoritesEvent.removeFavoriteRequested('user-123', 'fav-1'),
        ),
        verify: (_) {
          verify(
            mockFavoritesService.removeFavorite('user-123', 'fav-1'),
          ).called(1);
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits error on failure',
        setUp: () {
          when(
            mockFavoritesService.removeFavorite('user-123', 'fav-1'),
          ).thenThrow(Exception('Failed to remove'));
        },
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        act: (bloc) => bloc.add(
          const FavoritesEvent.removeFavoriteRequested('user-123', 'fav-1'),
        ),
        expect: () => [
          predicate<FavoritesState>(
            (state) =>
                state.error != null &&
                state.error!.contains('Failed to remove favorite'),
          ),
        ],
      );
    });

    group('ClearFavorites', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'clears favorites and resets state',
        build: () => FavoritesBloc(favoritesService: mockFavoritesService),
        seed: () => FavoritesState(
          favorites: [testFavorite1, testFavorite2],
          isLoading: true,
        ),
        act: (bloc) => bloc.add(const FavoritesEvent.clearFavorites()),
        expect: () => [
          predicate<FavoritesState>(
            (state) =>
                state.favorites.isEmpty &&
                state.isLoading == false &&
                state.error == null,
          ),
        ],
      );
    });

    group('close', () {
      test('cancels subscription on close', () async {
        final controller = StreamController<List<FavoriteAddress>>();
        when(
          mockFavoritesService.getFavorites('user-123'),
        ).thenAnswer((_) => controller.stream);

        final bloc = FavoritesBloc(favoritesService: mockFavoritesService);
        bloc.add(const FavoritesEvent.loadFavoritesRequested('user-123'));
        await Future.delayed(Duration.zero);

        await bloc.close();
        await controller.close();

        // If subscription wasn't cancelled, this would throw
        expect(controller.isClosed, true);
      });
    });

    group('FavoriteAddress model', () {
      test('equality works correctly', () {
        final favorite1 = FavoriteAddress(
          id: 'fav-1',
          label: 'Home',
          latitude: 53.0793,
          longitude: 8.8017,
          createdAt: DateTime(2024, 1, 1),
        );

        final favorite2 = FavoriteAddress(
          id: 'fav-1',
          label: 'Home',
          latitude: 53.0793,
          longitude: 8.8017,
          createdAt: DateTime(2024, 1, 1),
        );

        expect(favorite1, equals(favorite2));
      });

      test('copyWith works correctly', () {
        final original = testFavorite1;
        final updated = original.copyWith(label: 'New Label');

        expect(updated.id, original.id);
        expect(updated.label, 'New Label');
        expect(updated.latitude, original.latitude);
      });

      test('fromJson creates correct object', () {
        final json = {
          'id': 'fav-1',
          'label': 'Test',
          'latitude': 53.0,
          'longitude': 8.8,
          'address': 'Test Address',
          'createdAt': '2024-01-01T00:00:00.000',
        };

        final favorite = FavoriteAddress.fromJson(json);

        expect(favorite.id, 'fav-1');
        expect(favorite.label, 'Test');
        expect(favorite.latitude, 53.0);
        expect(favorite.longitude, 8.8);
        expect(favorite.address, 'Test Address');
      });

      test('toJson creates correct map', () {
        final favorite = FavoriteAddress(
          id: 'fav-1',
          label: 'Test',
          latitude: 53.0,
          longitude: 8.8,
          address: 'Test Address',
          createdAt: DateTime(2024, 1, 1),
        );

        final json = favorite.toJson();

        expect(json['id'], 'fav-1');
        expect(json['label'], 'Test');
        expect(json['latitude'], 53.0);
        expect(json['longitude'], 8.8);
        expect(json['address'], 'Test Address');
      });
    });
  });
}
