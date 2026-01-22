import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoritesState', () {
    final testFavorite1 = FavoriteAddress(
      id: 'fav-1',
      label: 'Home',
      latitude: 53.0793,
      longitude: 8.8017,
      createdAt: DateTime(2024, 1, 1),
    );

    final testFavorite2 = FavoriteAddress(
      id: 'fav-2',
      label: 'Work',
      latitude: 53.0850,
      longitude: 8.8200,
      createdAt: DateTime(2024, 1, 2),
    );

    test('default state has correct values', () {
      const state = FavoritesState();

      expect(state.favorites, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    group('copyWith', () {
      test('copies state with new values', () {
        const original = FavoritesState();
        final updated = original.copyWith(
          favorites: [testFavorite1],
          isLoading: true,
          error: 'Some error',
        );

        expect(updated.favorites, [testFavorite1]);
        expect(updated.isLoading, true);
        expect(updated.error, 'Some error');
      });

      test('preserves original values when not specified', () {
        final original = FavoritesState(
          favorites: [testFavorite1, testFavorite2],
          isLoading: true,
        );

        final updated = original.copyWith(error: 'New error');

        expect(updated.favorites, original.favorites);
        expect(updated.isLoading, original.isLoading);
        expect(updated.error, 'New error');
      });

      test('can clear error by setting to null', () {
        const original = FavoritesState(error: 'Some error');
        final updated = original.copyWith(error: null);

        expect(updated.error, isNull);
      });
    });

    group('equality', () {
      test('states with same values are equal', () {
        final state1 = FavoritesState(favorites: [testFavorite1]);
        final state2 = FavoritesState(favorites: [testFavorite1]);

        expect(state1, equals(state2));
      });

      test('states with different values are not equal', () {
        final state1 = FavoritesState(favorites: [testFavorite1]);
        final state2 = FavoritesState(favorites: [testFavorite2]);

        expect(state1, isNot(equals(state2)));
      });

      test('empty states are equal', () {
        const state1 = FavoritesState();
        const state2 = FavoritesState();

        expect(state1, equals(state2));
      });
    });

    group('favorites list', () {
      test('favorites list is immutable', () {
        final state = FavoritesState(favorites: [testFavorite1]);

        // The list should be immutable due to freezed
        expect(
          () => state.favorites.add(testFavorite2),
          throwsUnsupportedError,
        );
      });

      test('can have multiple favorites', () {
        final state = FavoritesState(favorites: [testFavorite1, testFavorite2]);

        expect(state.favorites.length, 2);
        expect(state.favorites, contains(testFavorite1));
        expect(state.favorites, contains(testFavorite2));
      });
    });
  });
}
