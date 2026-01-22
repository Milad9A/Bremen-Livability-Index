import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkRequested() = AuthCheckRequested;

  const factory AuthEvent.googleSignInRequested() = GoogleSignInRequested;

  const factory AuthEvent.gitHubSignInRequested() = GitHubSignInRequested;

  const factory AuthEvent.emailSignInRequested(String email) =
      EmailSignInRequested;

  const factory AuthEvent.emailLinkVerified(String email, String link) =
      EmailLinkVerified;

  /// When email link is detected but no stored email (cross-device flow)
  const factory AuthEvent.emailLinkPendingEmail(String link) =
      EmailLinkPendingEmail;

  const factory AuthEvent.guestSignInRequested() = GuestSignInRequested;

  const factory AuthEvent.signOutRequested() = SignOutRequested;
}
