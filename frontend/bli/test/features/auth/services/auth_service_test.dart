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
    });

    // Add more tests for other methods as needed: sendEmailLink, verifyPhoneCode, etc.
  });
}
