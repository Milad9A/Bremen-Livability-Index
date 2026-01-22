import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import 'auth_bloc_test.mocks.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc bloc;
    late MockAuthService mockAuthService;

    final testUser = AppUser(
      id: 'test-uid',
      email: 'test@example.com',
      displayName: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
      provider: AppAuthProvider.google,
    );

    setUp(() {
      mockAuthService = MockAuthService();
      bloc = AuthBloc(authService: mockAuthService);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const AuthState());
      expect(bloc.state.isAuthenticated, false);
      expect(bloc.state.isLoading, false);
      expect(bloc.state.isInitialized, false);
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits authenticated state when user exists',
        setUp: () {
          when(
            mockAuthService.getCurrentUser(),
          ).thenAnswer((_) async => testUser);
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.checkRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.isInitialized == true &&
                state.user == testUser,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits unauthenticated state when no user',
        setUp: () {
          when(mockAuthService.getCurrentUser()).thenAnswer((_) async => null);
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.checkRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.isInitialized == true &&
                state.user == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits error state on exception',
        setUp: () {
          when(
            mockAuthService.getCurrentUser(),
          ).thenThrow(Exception('Auth check failed'));
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.checkRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.isInitialized == true &&
                state.error != null,
          ),
        ],
      );
    });

    group('GoogleSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits authenticated state on success',
        setUp: () {
          when(
            mockAuthService.signInWithGoogle(),
          ).thenAnswer((_) async => testUser);
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>(
            (state) =>
                state.isLoading == true &&
                state.loadingProvider == AppAuthProvider.google,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.user == testUser &&
                state.loadingProvider == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits nothing extra when user cancels',
        setUp: () {
          when(
            mockAuthService.signInWithGoogle(),
          ).thenAnswer((_) async => null);
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>(
            (state) =>
                state.isLoading == true &&
                state.loadingProvider == AppAuthProvider.google,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false && state.loadingProvider == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits error on failure',
        setUp: () {
          when(
            mockAuthService.signInWithGoogle(),
          ).thenThrow(Exception('Google sign in failed'));
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.error != null &&
                state.loadingProvider == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'maps account-exists-with-different-credential correctly',
        setUp: () {
          when(mockAuthService.signInWithGoogle()).thenThrow(
            FirebaseAuthException(
              code: 'account-exists-with-different-credential',
              message: 'Account exists',
            ),
          );
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.error != null &&
                state.error!.contains('different sign-in method'),
          ),
        ],
      );
    });

    group('GitHubSignInRequested', () {
      final githubUser = testUser.copyWith(provider: AppAuthProvider.github);

      blocTest<AuthBloc, AuthState>(
        'emits authenticated state on success',
        setUp: () {
          when(
            mockAuthService.signInWithGitHub(),
          ).thenAnswer((_) async => githubUser);
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.gitHubSignInRequested()),
        expect: () => [
          predicate<AuthState>(
            (state) =>
                state.isLoading == true &&
                state.loadingProvider == AppAuthProvider.github,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.user == githubUser &&
                state.loadingProvider == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits error on failure',
        setUp: () {
          when(
            mockAuthService.signInWithGitHub(),
          ).thenThrow(Exception('GitHub sign in failed'));
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.gitHubSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.isLoading == false && state.error != null,
          ),
        ],
      );
    });

    group('EmailSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits emailLinkSent on success',
        setUp: () {
          when(
            mockAuthService.sendEmailLink('test@example.com'),
          ).thenAnswer((_) async {});
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) =>
            bloc.add(const AuthEvent.emailSignInRequested('test@example.com')),
        expect: () => [
          predicate<AuthState>(
            (state) =>
                state.isLoading == true &&
                state.loadingProvider == AppAuthProvider.email,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.emailLinkSent == true &&
                state.pendingEmail == 'test@example.com' &&
                state.loadingProvider == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits error on failure',
        setUp: () {
          when(
            mockAuthService.sendEmailLink('test@example.com'),
          ).thenThrow(Exception('Failed to send email'));
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) =>
            bloc.add(const AuthEvent.emailSignInRequested('test@example.com')),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.error != null &&
                state.error!.contains('Failed to send email'),
          ),
        ],
      );
    });

    group('EmailLinkVerified', () {
      final emailUser = testUser.copyWith(provider: AppAuthProvider.email);

      blocTest<AuthBloc, AuthState>(
        'emits authenticated state on success',
        setUp: () {
          when(
            mockAuthService.signInWithEmailLink(
              'test@example.com',
              'https://example.com/link',
            ),
          ).thenAnswer((_) async => emailUser);
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(
          const AuthEvent.emailLinkVerified(
            'test@example.com',
            'https://example.com/link',
          ),
        ),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.user == emailUser &&
                state.emailLinkSent == false &&
                state.pendingEmail == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits error on invalid link',
        setUp: () {
          when(
            mockAuthService.signInWithEmailLink(
              'test@example.com',
              'invalid-link',
            ),
          ).thenThrow(Exception('Invalid email link'));
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(
          const AuthEvent.emailLinkVerified('test@example.com', 'invalid-link'),
        ),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.isLoading == false && state.error != null,
          ),
        ],
      );
    });

    group('EmailLinkPendingEmail', () {
      blocTest<AuthBloc, AuthState>(
        'stores pending email link',
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(
          const AuthEvent.emailLinkPendingEmail('https://example.com/link'),
        ),
        expect: () => [
          predicate<AuthState>(
            (state) =>
                state.pendingEmailLink == 'https://example.com/link' &&
                state.needsEmailForLink == true,
          ),
        ],
      );
    });

    group('GuestSignInRequested', () {
      final guestUser = AppUser(
        id: 'guest-uid',
        provider: AppAuthProvider.guest,
        isAnonymous: true,
      );

      blocTest<AuthBloc, AuthState>(
        'emits authenticated state on success',
        setUp: () {
          when(
            mockAuthService.signInAsGuest(),
          ).thenAnswer((_) async => guestUser);
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.guestSignInRequested()),
        expect: () => [
          predicate<AuthState>(
            (state) =>
                state.isLoading == true &&
                state.loadingProvider == AppAuthProvider.guest,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.user == guestUser &&
                state.user!.isAnonymous == true,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits error on failure',
        setUp: () {
          when(
            mockAuthService.signInAsGuest(),
          ).thenThrow(Exception('Guest sign in failed'));
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.guestSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.isLoading == false && state.error != null,
          ),
        ],
      );
    });

    group('SignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits unauthenticated state on success',
        setUp: () {
          when(mockAuthService.signOut()).thenAnswer((_) async {});
        },
        build: () => AuthBloc(authService: mockAuthService),
        seed: () => AuthState(user: testUser),
        act: (bloc) => bloc.add(const AuthEvent.signOutRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.isLoading == false && state.user == null,
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits error on failure',
        setUp: () {
          when(
            mockAuthService.signOut(),
          ).thenThrow(Exception('Sign out failed'));
        },
        build: () => AuthBloc(authService: mockAuthService),
        seed: () => AuthState(user: testUser),
        act: (bloc) => bloc.add(const AuthEvent.signOutRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.isLoading == false && state.error != null,
          ),
        ],
      );
    });

    group('AuthState getters', () {
      test('isAuthenticated returns true when user exists', () {
        final state = AuthState(user: testUser);
        expect(state.isAuthenticated, true);
      });

      test('isAuthenticated returns false when no user', () {
        const state = AuthState();
        expect(state.isAuthenticated, false);
      });

      test('isLoggedIn returns true for non-anonymous user', () {
        final state = AuthState(user: testUser);
        expect(state.isLoggedIn, true);
      });

      test('isLoggedIn returns false for anonymous user', () {
        final state = AuthState(
          user: AppUser(
            id: 'guest',
            provider: AppAuthProvider.guest,
            isAnonymous: true,
          ),
        );
        expect(state.isLoggedIn, false);
      });

      test('isGuest returns true for anonymous user', () {
        final state = AuthState(
          user: AppUser(
            id: 'guest',
            provider: AppAuthProvider.guest,
            isAnonymous: true,
          ),
        );
        expect(state.isGuest, true);
      });

      test('needsEmailForLink returns true when pendingEmailLink exists', () {
        const state = AuthState(pendingEmailLink: 'https://example.com/link');
        expect(state.needsEmailForLink, true);
      });
    });

    group('Error message mapping', () {
      blocTest<AuthBloc, AuthState>(
        'maps popup-closed-by-user correctly',
        setUp: () {
          when(mockAuthService.signInWithGoogle()).thenThrow(
            FirebaseAuthException(code: 'popup-closed-by-user', message: ''),
          );
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) =>
                state.error != null && state.error!.contains('cancelled'),
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'maps network-request-failed correctly',
        setUp: () {
          when(mockAuthService.signInWithGoogle()).thenThrow(
            FirebaseAuthException(code: 'network-request-failed', message: ''),
          );
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.error != null && state.error!.contains('Network'),
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'maps too-many-requests correctly',
        setUp: () {
          when(mockAuthService.signInWithGoogle()).thenThrow(
            FirebaseAuthException(code: 'too-many-requests', message: ''),
          );
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.error != null && state.error!.contains('Too many'),
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'maps keychain-error correctly',
        setUp: () {
          when(mockAuthService.signInWithGoogle()).thenThrow(
            FirebaseAuthException(code: 'keychain-error', message: ''),
          );
        },
        build: () => AuthBloc(authService: mockAuthService),
        act: (bloc) => bloc.add(const AuthEvent.googleSignInRequested()),
        expect: () => [
          predicate<AuthState>((state) => state.isLoading == true),
          predicate<AuthState>(
            (state) => state.error != null && state.error!.contains('storage'),
          ),
        ],
      );
    });
  });
}
