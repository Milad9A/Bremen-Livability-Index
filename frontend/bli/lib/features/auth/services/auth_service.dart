import 'package:bli/features/auth/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  final FlutterSecureStorage _secureStorage;

  static const String _pendingEmailKey = 'pending_email_link';

  AuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,

    FlutterSecureStorage? secureStorage,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _googleSignIn =
           googleSignIn ??
           GoogleSignIn(
             serverClientId:
                 '402145256946-4siurt3n0396di09m6622ttcj4u35s5o.apps.googleusercontent.com',
           ),

       _secureStorage =
           secureStorage ??
           const FlutterSecureStorage(
             iOptions: IOSOptions(
               accessibility: KeychainAccessibility.first_unlock,
             ),
             aOptions: AndroidOptions(encryptedSharedPreferences: true),
           );

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<AppUser?> signInWithGoogle() async {
    try {
      final UserCredential userCredential;

      if (kIsWeb) {
        // Web: Use popup-based sign-in
        userCredential = await _auth.signInWithPopup(GoogleAuthProvider());
      } else if (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux) {
        // Desktop (non-macOS): Use provider-based sign-in (browser flow)
        userCredential = await _auth.signInWithProvider(GoogleAuthProvider());
      } else {
        // Mobile (Android/iOS) & macOS: Use Google Sign-In package
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return null; // User cancelled
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      return _mapFirebaseUser(userCredential.user, AppAuthProvider.google);
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  Future<AppUser?> signInWithGitHub() async {
    try {
      final UserCredential userCredential;

      if (kIsWeb) {
        // Web: Use popup-based sign-in
        userCredential = await _auth.signInWithPopup(GithubAuthProvider());
      } else {
        // Mobile/Desktop: Use provider-based sign-in with redirect
        userCredential = await _auth.signInWithProvider(GithubAuthProvider());
      }

      return _mapFirebaseUser(userCredential.user, AppAuthProvider.github);
    } catch (e) {
      debugPrint('GitHub sign in error: $e');
      rethrow;
    }
  }

  Future<void> sendEmailLink(String email) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://bremen-livability-frontend.onrender.com/login',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.bli',
      androidPackageName: 'com.example.bli',
      androidInstallApp: true,
      androidMinimumVersion: '21',
    );

    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );
    await savePendingEmail(email);
  }

  Future<AppUser?> signInWithEmailLink(String email, String link) async {
    try {
      if (!_auth.isSignInWithEmailLink(link)) {
        throw Exception('Invalid email link');
      }

      final userCredential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: link,
      );
      await clearPendingEmail();
      return _mapFirebaseUser(userCredential.user, AppAuthProvider.email);
    } catch (e) {
      debugPrint('Email link sign in error: $e');
      rethrow;
    }
  }

  Future<AppUser?> signInAsGuest() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return _mapFirebaseUser(userCredential.user, AppAuthProvider.guest);
    } catch (e) {
      debugPrint('Guest sign in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  AppUser? _mapFirebaseUser(User? user, AppAuthProvider provider) {
    if (user == null) return null;

    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      provider: provider,
      isAnonymous: user.isAnonymous,
    );
  }

  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    AppAuthProvider provider = AppAuthProvider.guest;
    if (user.isAnonymous) {
      provider = AppAuthProvider.guest;
    } else if (user.providerData.isNotEmpty) {
      final providerId = user.providerData.first.providerId;
      switch (providerId) {
        case 'google.com':
          provider = AppAuthProvider.google;
          break;
        case 'github.com':
          provider = AppAuthProvider.github;
          break;

        case 'password':
        case 'emailLink':
          provider = AppAuthProvider.email;
          break;
      }
    }

    return _mapFirebaseUser(user, provider);
  }

  Future<void> savePendingEmail(String email) async {
    await _secureStorage.write(key: _pendingEmailKey, value: email);
  }

  Future<String?> getPendingEmail() async {
    return await _secureStorage.read(key: _pendingEmailKey);
  }

  Future<void> clearPendingEmail() async {
    await _secureStorage.delete(key: _pendingEmailKey);
  }
}
