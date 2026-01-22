import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthState', () {
    test('default state has correct values', () {
      const state = AuthState();

      expect(state.user, isNull);
      expect(state.isLoading, false);
      expect(state.loadingProvider, isNull);
      expect(state.isInitialized, false);
      expect(state.error, isNull);
      expect(state.phoneVerificationId, isNull);
      expect(state.emailLinkSent, false);
      expect(state.pendingEmail, isNull);
      expect(state.pendingEmailLink, isNull);
    });

    group('isAuthenticated', () {
      test('returns true when user exists', () {
        final state = AuthState(
          user: AppUser(id: 'test', provider: AppAuthProvider.google),
        );
        expect(state.isAuthenticated, true);
      });

      test('returns false when user is null', () {
        const state = AuthState();
        expect(state.isAuthenticated, false);
      });
    });

    group('isLoggedIn', () {
      test('returns true for non-anonymous user', () {
        final state = AuthState(
          user: AppUser(
            id: 'test',
            provider: AppAuthProvider.google,
            isAnonymous: false,
          ),
        );
        expect(state.isLoggedIn, true);
      });

      test('returns false for anonymous user', () {
        final state = AuthState(
          user: AppUser(
            id: 'test',
            provider: AppAuthProvider.guest,
            isAnonymous: true,
          ),
        );
        expect(state.isLoggedIn, false);
      });

      test('returns false when no user', () {
        const state = AuthState();
        expect(state.isLoggedIn, false);
      });
    });

    group('isGuest', () {
      test('returns true for anonymous user', () {
        final state = AuthState(
          user: AppUser(
            id: 'test',
            provider: AppAuthProvider.guest,
            isAnonymous: true,
          ),
        );
        expect(state.isGuest, true);
      });

      test('returns false for non-anonymous user', () {
        final state = AuthState(
          user: AppUser(
            id: 'test',
            provider: AppAuthProvider.google,
            isAnonymous: false,
          ),
        );
        expect(state.isGuest, false);
      });

      test('returns false when no user', () {
        const state = AuthState();
        expect(state.isGuest, false);
      });
    });

    group('needsEmailForLink', () {
      test('returns true when pendingEmailLink exists', () {
        const state = AuthState(pendingEmailLink: 'https://example.com/link');
        expect(state.needsEmailForLink, true);
      });

      test('returns false when pendingEmailLink is null', () {
        const state = AuthState();
        expect(state.needsEmailForLink, false);
      });
    });

    group('copyWith', () {
      test('copies state with new values', () {
        const original = AuthState();
        final updated = original.copyWith(
          isLoading: true,
          isInitialized: true,
          error: 'Some error',
        );

        expect(updated.isLoading, true);
        expect(updated.isInitialized, true);
        expect(updated.error, 'Some error');
        expect(updated.user, isNull);
      });

      test('preserves original values when not specified', () {
        final original = AuthState(
          user: AppUser(id: 'test', provider: AppAuthProvider.google),
          isLoading: true,
          isInitialized: true,
        );

        final updated = original.copyWith(error: 'New error');

        expect(updated.user, original.user);
        expect(updated.isLoading, original.isLoading);
        expect(updated.isInitialized, original.isInitialized);
        expect(updated.error, 'New error');
      });
    });

    group('equality', () {
      test('states with same values are equal', () {
        const state1 = AuthState(isLoading: true, isInitialized: true);
        const state2 = AuthState(isLoading: true, isInitialized: true);

        expect(state1, equals(state2));
      });

      test('states with different values are not equal', () {
        const state1 = AuthState(isLoading: true);
        const state2 = AuthState(isLoading: false);

        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
