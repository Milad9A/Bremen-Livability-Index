import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebase_auth; // Alias to avoid conflicts
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<firebase_auth.FirebaseAuth>(),
  MockSpec<GoogleSignIn>(),
  MockSpec<GoogleSignInAccount>(),
  MockSpec<GoogleSignInAuthentication>(),
  MockSpec<firebase_auth.UserCredential>(),
  MockSpec<firebase_auth.User>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<firebase_auth.UserMetadata>(),
  MockSpec<firebase_auth.IdTokenResult>(),
  MockSpec<firebase_auth.UserInfo>(),
])
import 'auth_service_test.mocks.dart';

void main() {
  group('AuthService', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late MockGoogleSignIn mockGoogleSignIn;
    late MockFlutterSecureStorage mockSecureStorage;
    late AuthService authService;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      mockSecureStorage = MockFlutterSecureStorage();
      authService = AuthService(
        auth: mockFirebaseAuth,
        googleSignIn: mockGoogleSignIn,
        secureStorage: mockSecureStorage,
      );
    });

    final testUser = AppUser(
      id: 'test-uid',
      email: 'test@example.com',
      displayName: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
      provider: AppAuthProvider.google,
    );

    group('signInWithGoogle', () {
      test('returns AppUser when sign in successful (Mobile)', () async {
        // Arrange
        final mockGoogleUser = MockGoogleSignInAccount();
        final mockGoogleAuth = MockGoogleSignInAuthentication();
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleUser);
        when(
          mockGoogleUser.authentication,
        ).thenAnswer((_) async => mockGoogleAuth);
        when(mockGoogleAuth.accessToken).thenReturn('access-token');
        when(mockGoogleAuth.idToken).thenReturn('id-token');
        when(
          mockFirebaseAuth.signInWithCredential(any),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.uid).thenReturn(testUser.id);
        when(mockFirebaseUser.email).thenReturn(testUser.email);
        when(mockFirebaseUser.displayName).thenReturn(testUser.displayName);
        when(mockFirebaseUser.photoURL).thenReturn(testUser.photoUrl);
        when(mockFirebaseUser.isAnonymous).thenReturn(false);
        // Mock providerData for getting the provider ID
        final mockUserInfo = MockUserInfo();
        when(mockUserInfo.providerId).thenReturn('google.com');
        when(mockFirebaseUser.providerData).thenReturn([mockUserInfo]);

        // Act
        // Note: kIsWeb is false in unit tests by default
        final result = await authService.signInWithGoogle();

        // Assert
        expect(result, isNotNull);
        expect(result!.id, testUser.id);
        expect(result.email, testUser.email);
        verify(mockGoogleSignIn.signIn()).called(1);
        verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
      });

      test('returns null when Google sign in cancelled', () async {
        // Arrange
        when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

        // Act
        final result = await authService.signInWithGoogle();

        // Assert
        expect(result, isNull);
        verify(mockGoogleSignIn.signIn()).called(1);
        verifyNever(mockFirebaseAuth.signInWithCredential(any));
      });

      test('rethrows exception when Google sign in fails', () async {
        // Arrange
        when(mockGoogleSignIn.signIn()).thenThrow(Exception('Sign in failed'));

        // Act & Assert
        expect(() => authService.signInWithGoogle(), throwsException);
      });
    });

    group('signInWithGitHub', () {
      // Since kIsWeb checks are static/const in flutter, we can mainly test the non-web path which defaults in tests usually.
      // But checking `signInWithGitHub` implementation:
      // Mobile uses `signInWithProvider`.

      test('returns AppUser when sign in successful (Mobile)', () async {
        // Arrange
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(
          mockFirebaseAuth.signInWithProvider(any),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.uid).thenReturn('github-uid');
        when(mockFirebaseUser.email).thenReturn('github@example.com');
        when(mockFirebaseUser.displayName).thenReturn('Github User');

        final mockUserInfo = MockUserInfo();
        when(mockUserInfo.providerId).thenReturn('github.com');
        when(mockFirebaseUser.providerData).thenReturn([mockUserInfo]);

        // Act
        final result = await authService.signInWithGitHub();

        // Assert
        expect(result, isNotNull);
        expect(result?.provider, AppAuthProvider.github);
        verify(mockFirebaseAuth.signInWithProvider(any)).called(1);
      });
    });

    group('signOut', () {
      test('callssignOut on both GoogleSignIn and FirebaseAuth', () async {
        // Act
        await authService.signOut();

        // Assert
        verify(mockGoogleSignIn.signOut()).called(1);
        verify(mockFirebaseAuth.signOut()).called(1);
      });
    });

    group('getCurrentUser', () {
      test('returns null when no user logged in', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = await authService.getCurrentUser();
        expect(result, isNull);
      });

      test('returns guest user', () async {
        final mockFirebaseUser = MockUser();
        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.isAnonymous).thenReturn(true);
        when(mockFirebaseUser.uid).thenReturn('guest-uid');

        final result = await authService.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.isAnonymous, true);
        expect(result.provider, AppAuthProvider.guest);
      });

      test('returns Google user based on providerData', () async {
        final mockFirebaseUser = MockUser();
        final mockUserInfo = MockUserInfo();

        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.isAnonymous).thenReturn(false);
        when(mockFirebaseUser.uid).thenReturn('google-uid');
        when(mockFirebaseUser.email).thenReturn('google@example.com');
        when(mockFirebaseUser.displayName).thenReturn('Google User');
        when(mockFirebaseUser.photoURL).thenReturn('https://photo.url');
        when(mockUserInfo.providerId).thenReturn('google.com');
        when(mockFirebaseUser.providerData).thenReturn([mockUserInfo]);

        final result = await authService.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.provider, AppAuthProvider.google);
        expect(result.email, 'google@example.com');
      });

      test('returns GitHub user based on providerData', () async {
        final mockFirebaseUser = MockUser();
        final mockUserInfo = MockUserInfo();

        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.isAnonymous).thenReturn(false);
        when(mockFirebaseUser.uid).thenReturn('github-uid');
        when(mockFirebaseUser.email).thenReturn('github@example.com');
        when(mockFirebaseUser.displayName).thenReturn('GitHub User');
        when(mockFirebaseUser.photoURL).thenReturn(null);
        when(mockUserInfo.providerId).thenReturn('github.com');
        when(mockFirebaseUser.providerData).thenReturn([mockUserInfo]);

        final result = await authService.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.provider, AppAuthProvider.github);
      });

      test('returns email user for password provider', () async {
        final mockFirebaseUser = MockUser();
        final mockUserInfo = MockUserInfo();

        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.isAnonymous).thenReturn(false);
        when(mockFirebaseUser.uid).thenReturn('email-uid');
        when(mockFirebaseUser.email).thenReturn('email@example.com');
        when(mockFirebaseUser.displayName).thenReturn(null);
        when(mockFirebaseUser.photoURL).thenReturn(null);
        when(mockUserInfo.providerId).thenReturn('password');
        when(mockFirebaseUser.providerData).thenReturn([mockUserInfo]);

        final result = await authService.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.provider, AppAuthProvider.email);
      });

      test('returns email user for emailLink provider', () async {
        final mockFirebaseUser = MockUser();
        final mockUserInfo = MockUserInfo();

        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.isAnonymous).thenReturn(false);
        when(mockFirebaseUser.uid).thenReturn('emaillink-uid');
        when(mockFirebaseUser.email).thenReturn('emaillink@example.com');
        when(mockFirebaseUser.displayName).thenReturn(null);
        when(mockFirebaseUser.photoURL).thenReturn(null);
        when(mockUserInfo.providerId).thenReturn('emailLink');
        when(mockFirebaseUser.providerData).thenReturn([mockUserInfo]);

        final result = await authService.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.provider, AppAuthProvider.email);
      });

      test('returns guest provider for user with no providerData', () async {
        final mockFirebaseUser = MockUser();

        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.isAnonymous).thenReturn(false);
        when(mockFirebaseUser.uid).thenReturn('no-provider-uid');
        when(mockFirebaseUser.email).thenReturn(null);
        when(mockFirebaseUser.displayName).thenReturn(null);
        when(mockFirebaseUser.photoURL).thenReturn(null);
        when(mockFirebaseUser.providerData).thenReturn([]);

        final result = await authService.getCurrentUser();

        expect(result, isNotNull);
        expect(result!.provider, AppAuthProvider.guest);
      });
    });

    group('signInAsGuest', () {
      test('returns AppUser when anonymous sign in successful', () async {
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(
          mockFirebaseAuth.signInAnonymously(),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.uid).thenReturn('guest-uid');
        when(mockFirebaseUser.email).thenReturn(null);
        when(mockFirebaseUser.displayName).thenReturn(null);
        when(mockFirebaseUser.photoURL).thenReturn(null);
        when(mockFirebaseUser.isAnonymous).thenReturn(true);

        final result = await authService.signInAsGuest();

        expect(result, isNotNull);
        expect(result!.id, 'guest-uid');
        expect(result.isAnonymous, true);
        expect(result.provider, AppAuthProvider.guest);
        verify(mockFirebaseAuth.signInAnonymously()).called(1);
      });

      test('rethrows exception when anonymous sign in fails', () async {
        when(
          mockFirebaseAuth.signInAnonymously(),
        ).thenThrow(Exception('Anonymous sign in failed'));

        expect(() => authService.signInAsGuest(), throwsException);
      });
    });

    group('sendEmailLink', () {
      test('sends email link and saves pending email', () async {
        when(
          mockFirebaseAuth.sendSignInLinkToEmail(
            email: anyNamed('email'),
            actionCodeSettings: anyNamed('actionCodeSettings'),
          ),
        ).thenAnswer((_) async {});
        when(
          mockSecureStorage.write(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});

        await authService.sendEmailLink('test@example.com');

        verify(
          mockFirebaseAuth.sendSignInLinkToEmail(
            email: 'test@example.com',
            actionCodeSettings: anyNamed('actionCodeSettings'),
          ),
        ).called(1);
        verify(
          mockSecureStorage.write(
            key: 'pending_email_link',
            value: 'test@example.com',
          ),
        ).called(1);
      });
    });

    group('signInWithEmailLink', () {
      test('returns AppUser when sign in successful', () async {
        final mockUserCredential = MockUserCredential();
        final mockFirebaseUser = MockUser();

        when(mockFirebaseAuth.isSignInWithEmailLink(any)).thenReturn(true);
        when(
          mockFirebaseAuth.signInWithEmailLink(
            email: anyNamed('email'),
            emailLink: anyNamed('emailLink'),
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.uid).thenReturn('email-uid');
        when(mockFirebaseUser.email).thenReturn('test@example.com');
        when(mockFirebaseUser.displayName).thenReturn(null);
        when(mockFirebaseUser.photoURL).thenReturn(null);
        when(mockFirebaseUser.isAnonymous).thenReturn(false);
        when(
          mockSecureStorage.delete(key: anyNamed('key')),
        ).thenAnswer((_) async {});

        final result = await authService.signInWithEmailLink(
          'test@example.com',
          'https://example.com/link',
        );

        expect(result, isNotNull);
        expect(result!.email, 'test@example.com');
        expect(result.provider, AppAuthProvider.email);
        verify(mockSecureStorage.delete(key: 'pending_email_link')).called(1);
      });

      test('throws exception for invalid email link', () async {
        when(mockFirebaseAuth.isSignInWithEmailLink(any)).thenReturn(false);

        expect(
          () => authService.signInWithEmailLink(
            'test@example.com',
            'invalid-link',
          ),
          throwsException,
        );
      });

      test('rethrows exception when email link sign in fails', () async {
        when(mockFirebaseAuth.isSignInWithEmailLink(any)).thenReturn(true);
        when(
          mockFirebaseAuth.signInWithEmailLink(
            email: anyNamed('email'),
            emailLink: anyNamed('emailLink'),
          ),
        ).thenThrow(Exception('Email link sign in failed'));

        expect(
          () => authService.signInWithEmailLink(
            'test@example.com',
            'https://example.com/link',
          ),
          throwsException,
        );
      });
    });

    group('pending email storage', () {
      test('savePendingEmail writes to secure storage', () async {
        when(
          mockSecureStorage.write(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});

        await authService.savePendingEmail('pending@example.com');

        verify(
          mockSecureStorage.write(
            key: 'pending_email_link',
            value: 'pending@example.com',
          ),
        ).called(1);
      });

      test('getPendingEmail reads from secure storage', () async {
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => 'pending@example.com');

        final result = await authService.getPendingEmail();

        expect(result, 'pending@example.com');
        verify(mockSecureStorage.read(key: 'pending_email_link')).called(1);
      });

      test('getPendingEmail returns null when no email stored', () async {
        when(
          mockSecureStorage.read(key: anyNamed('key')),
        ).thenAnswer((_) async => null);

        final result = await authService.getPendingEmail();

        expect(result, isNull);
      });

      test('clearPendingEmail deletes from secure storage', () async {
        when(
          mockSecureStorage.delete(key: anyNamed('key')),
        ).thenAnswer((_) async {});

        await authService.clearPendingEmail();

        verify(mockSecureStorage.delete(key: 'pending_email_link')).called(1);
      });
    });

    group('signInWithGitHub error handling', () {
      test('rethrows exception when GitHub sign in fails', () async {
        when(
          mockFirebaseAuth.signInWithProvider(any),
        ).thenThrow(Exception('GitHub sign in failed'));

        expect(() => authService.signInWithGitHub(), throwsException);
      });
    });

    group('authStateChanges', () {
      test('returns auth state stream', () {
        final mockStream = Stream<firebase_auth.User?>.value(null);
        when(mockFirebaseAuth.authStateChanges()).thenAnswer((_) => mockStream);

        final result = authService.authStateChanges;

        expect(result, isA<Stream<firebase_auth.User?>>());
        verify(mockFirebaseAuth.authStateChanges()).called(1);
      });
    });

    group('currentUser', () {
      test('returns current user from auth', () {
        final mockFirebaseUser = MockUser();
        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);

        final result = authService.currentUser;

        expect(result, mockFirebaseUser);
      });

      test('returns null when no user', () {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = authService.currentUser;

        expect(result, isNull);
      });
    });
  });
}
