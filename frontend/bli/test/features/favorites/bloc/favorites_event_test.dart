import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoritesEvent', () {
    final testFavorite = FavoriteAddress(
      id: 'fav-1',
      label: 'Home',
      latitude: 53.0793,
      longitude: 8.8017,
      createdAt: DateTime(2024, 1, 1),
    );

    group('LoadFavoritesRequested', () {
      test('creates event with userId', () {
        const event = FavoritesEvent.loadFavoritesRequested('user-123');
        expect(event, isA<LoadFavoritesRequested>());
        expect((event as LoadFavoritesRequested).userId, 'user-123');
      });

      test('events with same userId are equal', () {
        const event1 = FavoritesEvent.loadFavoritesRequested('user-123');
        const event2 = FavoritesEvent.loadFavoritesRequested('user-123');
        expect(event1, equals(event2));
      });
    });

    group('AddFavoriteRequested', () {
      test('creates event with userId and address', () {
        final event = FavoritesEvent.addFavoriteRequested(
          'user-123',
          testFavorite,
        );
        expect(event, isA<AddFavoriteRequested>());
        expect((event as AddFavoriteRequested).userId, 'user-123');
        expect(event.address, testFavorite);
      });
    });

    group('RemoveFavoriteRequested', () {
      test('creates event with userId and addressId', () {
        const event = FavoritesEvent.removeFavoriteRequested(
          'user-123',
          'fav-1',
        );
        expect(event, isA<RemoveFavoriteRequested>());
        expect((event as RemoveFavoriteRequested).userId, 'user-123');
        expect(event.addressId, 'fav-1');
      });
    });

    group('FavoritesUpdated', () {
      test('creates event with favorites list', () {
        final event = FavoritesEvent.favoritesUpdated([testFavorite]);
        expect(event, isA<FavoritesUpdated>());
        expect((event as FavoritesUpdated).favorites, [testFavorite]);
      });

      test('creates event with empty list', () {
        const event = FavoritesEvent.favoritesUpdated([]);
        expect(event, isA<FavoritesUpdated>());
        expect((event as FavoritesUpdated).favorites, isEmpty);
      });
    });

    group('ClearFavorites', () {
      test('creates event correctly', () {
        const event = FavoritesEvent.clearFavorites();
        expect(event, isA<ClearFavorites>());
      });

      test('equality works', () {
        const event1 = FavoritesEvent.clearFavorites();
        const event2 = FavoritesEvent.clearFavorites();
        expect(event1, equals(event2));
      });
    });
  });
}
