import 'dart:async';

import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<GitHubSignInRequested>(_onGitHubSignInRequested);
    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<EmailLinkVerified>(_onEmailLinkVerified);
    on<PhoneSignInRequested>(_onPhoneSignInRequested);
    on<PhoneCodeVerified>(_onPhoneCodeVerified);
    on<GuestSignInRequested>(_onGuestSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  String _getAuthErrorMessage(dynamic error, String providerName) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'account-exists-with-different-credential':
          return 'This email is already registered with a different sign-in method. Please use that method instead.';
        case 'invalid-credential':
          return 'Invalid credentials. Please try again.';
        case 'user-disabled':
          return 'This account has been disabled. Contact support for help.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'operation-not-allowed':
          return '$providerName sign-in is not enabled. Contact support.';
        case 'popup-closed-by-user':
        case 'cancelled-by-user':
          return 'Sign-in was cancelled.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'keychain-error':
          return 'Authentication storage error. Please restart the app.';
        case 'unauthorized-domain':
          return 'App domain is not authorized in Firebase. Please allowlist it in the console.';
        default:
          return '$providerName sign-in failed. Please try again.';
      }
    }

    final errorString = error.toString();
    if (errorString.contains('account-exists-with-different-credential')) {
      return 'This email is already registered with a different sign-in method. Please use that method instead.';
    }

    return '$providerName sign-in failed. Please try again.';
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await _authService.getCurrentUser();

      emit(state.copyWith(user: user, isLoading: false, isInitialized: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isInitialized: true,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        loadingProvider: AppAuthProvider.google,
        error: null,
      ),
    );

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        emit(
          state.copyWith(user: user, isLoading: false, loadingProvider: null),
        );
      } else {
        emit(state.copyWith(isLoading: false, loadingProvider: null));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          loadingProvider: null,
          error: _getAuthErrorMessage(e, 'Google'),
        ),
      );
    }
  }

  Future<void> _onGitHubSignInRequested(
    GitHubSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        loadingProvider: AppAuthProvider.github,
        error: null,
      ),
    );

    try {
      final user = await _authService.signInWithGitHub();
      if (user != null) {
        emit(
          state.copyWith(user: user, isLoading: false, loadingProvider: null),
        );
      } else {
        emit(state.copyWith(isLoading: false, loadingProvider: null));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          loadingProvider: null,
          error: _getAuthErrorMessage(e, 'GitHub'),
        ),
      );
    }
  }

  Future<void> _onEmailSignInRequested(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        loadingProvider: AppAuthProvider.email,
        error: null,
      ),
    );

    try {
      await _authService.sendEmailLink(event.email);
      emit(
        state.copyWith(
          isLoading: false,
          emailLinkSent: true,
          pendingEmail: event.email,
          loadingProvider: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          loadingProvider: null,
          error: 'Failed to send email link: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onEmailLinkVerified(
    EmailLinkVerified event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await _authService.signInWithEmailLink(
        event.email,
        event.link,
      );
      if (user != null) {
        emit(
          state.copyWith(
            user: user,
            isLoading: false,
            emailLinkSent: false,
            pendingEmail: null,
            loadingProvider: null,
          ),
        );
      } else {
        emit(
          state.copyWith(isLoading: false, error: 'Email verification failed'),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Email verification failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onPhoneSignInRequested(
    PhoneSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final completer = Completer<String>();

      await _authService.sendPhoneVerification(
        event.phoneNumber,
        onCodeSent: (id) {
          if (!completer.isCompleted) {
            completer.complete(id);
          }
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );

      final verificationId = await completer.future;
      emit(
        state.copyWith(isLoading: false, phoneVerificationId: verificationId),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Phone verification failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onPhoneCodeVerified(
    PhoneCodeVerified event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await _authService.verifyPhoneCode(
        event.verificationId,
        event.code,
      );
      if (user != null) {
        emit(
          state.copyWith(
            user: user,
            isLoading: false,
            phoneVerificationId: null,
            loadingProvider: null,
          ),
        );
      } else {
        emit(
          state.copyWith(isLoading: false, error: 'Phone verification failed'),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Phone verification failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGuestSignInRequested(
    GuestSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        loadingProvider: AppAuthProvider.guest,
        error: null,
      ),
    );

    try {
      final user = await _authService.signInAsGuest();
      emit(state.copyWith(user: user, isLoading: false, loadingProvider: null));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          loadingProvider: null,
          error: _getAuthErrorMessage(e, 'Guest'),
        ),
      );
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _authService.signOut();
      emit(state.copyWith(user: null, isLoading: false, loadingProvider: null));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Sign out failed: ${e.toString()}',
        ),
      );
    }
  }
}
