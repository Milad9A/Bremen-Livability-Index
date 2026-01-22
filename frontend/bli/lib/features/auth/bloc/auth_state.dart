import 'package:bli/features/auth/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    AppUser? user,

    @Default(false) bool isLoading,

    AppAuthProvider? loadingProvider,

    @Default(false) bool isInitialized,

    String? error,

    @Default(false) bool emailLinkSent,

    String? pendingEmail,

    /// Set when an email link is detected but no email is stored (cross-device flow)
    String? pendingEmailLink,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => user != null;

  bool get isLoggedIn => user != null && !user!.isAnonymous;

  bool get isGuest => user?.isAnonymous ?? false;

  /// True when we need to prompt user for email to complete sign-in
  bool get needsEmailForLink => pendingEmailLink != null;
}
