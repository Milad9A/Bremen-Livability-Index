import 'package:bli/features/auth/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUser', () {
    test('creates user with all fields', () {
      final user = AppUser(
        id: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        provider: AppAuthProvider.google,
        isAnonymous: false,
      );

      expect(user.id, 'test-uid');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.provider, AppAuthProvider.google);
      expect(user.isAnonymous, false);
    });

    test('creates user with minimal fields', () {
      const user = AppUser(id: 'test-uid', provider: AppAuthProvider.guest);

      expect(user.id, 'test-uid');
      expect(user.email, isNull);
      expect(user.displayName, isNull);
      expect(user.photoUrl, isNull);
      expect(user.provider, AppAuthProvider.guest);
      expect(user.isAnonymous, false);
    });

    test('isAnonymous defaults to false', () {
      const user = AppUser(id: 'test-uid', provider: AppAuthProvider.google);

      expect(user.isAnonymous, false);
    });

    group('AppUser.guest', () {
      test('creates guest user with correct defaults', () {
        final guestUser = AppUser.guest();

        expect(guestUser.id, 'guest');
        expect(guestUser.provider, AppAuthProvider.guest);
        expect(guestUser.isAnonymous, true);
        expect(guestUser.email, isNull);
        expect(guestUser.displayName, isNull);
        expect(guestUser.photoUrl, isNull);
      });
    });

    group('copyWith', () {
      test('copies user with new values', () {
        final original = AppUser(
          id: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          provider: AppAuthProvider.google,
        );

        final updated = original.copyWith(
          displayName: 'Updated User',
          email: 'updated@example.com',
        );

        expect(updated.id, 'test-uid');
        expect(updated.email, 'updated@example.com');
        expect(updated.displayName, 'Updated User');
        expect(updated.provider, AppAuthProvider.google);
      });

      test('preserves original values when not specified', () {
        final original = AppUser(
          id: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          provider: AppAuthProvider.github,
        );

        final updated = original.copyWith(displayName: 'New Name');

        expect(updated.id, original.id);
        expect(updated.email, original.email);
        expect(updated.photoUrl, original.photoUrl);
        expect(updated.provider, original.provider);
        expect(updated.displayName, 'New Name');
      });
    });

    group('equality', () {
      test('users with same values are equal', () {
        final user1 = AppUser(
          id: 'test-uid',
          email: 'test@example.com',
          provider: AppAuthProvider.google,
        );

        final user2 = AppUser(
          id: 'test-uid',
          email: 'test@example.com',
          provider: AppAuthProvider.google,
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, user2.hashCode);
      });

      test('users with different values are not equal', () {
        final user1 = AppUser(
          id: 'test-uid-1',
          email: 'test@example.com',
          provider: AppAuthProvider.google,
        );

        final user2 = AppUser(
          id: 'test-uid-2',
          email: 'test@example.com',
          provider: AppAuthProvider.google,
        );

        expect(user1, isNot(equals(user2)));
      });
    });

    group('JSON serialization', () {
      test('fromJson creates correct user', () {
        final json = {
          'id': 'test-uid',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'photoUrl': 'https://example.com/photo.jpg',
          'provider': 'google',
          'isAnonymous': false,
        };

        final user = AppUser.fromJson(json);

        expect(user.id, 'test-uid');
        expect(user.email, 'test@example.com');
        expect(user.displayName, 'Test User');
        expect(user.photoUrl, 'https://example.com/photo.jpg');
        expect(user.provider, AppAuthProvider.google);
        expect(user.isAnonymous, false);
      });

      test('fromJson handles null optional fields', () {
        final json = {
          'id': 'test-uid',
          'provider': 'guest',
          'isAnonymous': true,
        };

        final user = AppUser.fromJson(json);

        expect(user.id, 'test-uid');
        expect(user.email, isNull);
        expect(user.displayName, isNull);
        expect(user.photoUrl, isNull);
        expect(user.provider, AppAuthProvider.guest);
        expect(user.isAnonymous, true);
      });

      test('toJson creates correct map', () {
        final user = AppUser(
          id: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          provider: AppAuthProvider.github,
          isAnonymous: false,
        );

        final json = user.toJson();

        expect(json['id'], 'test-uid');
        expect(json['email'], 'test@example.com');
        expect(json['displayName'], 'Test User');
        expect(json['photoUrl'], 'https://example.com/photo.jpg');
        expect(json['provider'], 'github');
        expect(json['isAnonymous'], false);
      });
    });
  });

  group('AppAuthProvider', () {
    test('all providers have correct JSON values', () {
      expect(AppAuthProvider.google.name, 'google');
      expect(AppAuthProvider.github.name, 'github');
      expect(AppAuthProvider.email.name, 'email');
      expect(AppAuthProvider.phone.name, 'phone');
      expect(AppAuthProvider.guest.name, 'guest');
    });

    test('values contains all providers', () {
      expect(AppAuthProvider.values.length, 5);
      expect(AppAuthProvider.values, contains(AppAuthProvider.google));
      expect(AppAuthProvider.values, contains(AppAuthProvider.github));
      expect(AppAuthProvider.values, contains(AppAuthProvider.email));
      expect(AppAuthProvider.values, contains(AppAuthProvider.phone));
      expect(AppAuthProvider.values, contains(AppAuthProvider.guest));
    });
  });
}
