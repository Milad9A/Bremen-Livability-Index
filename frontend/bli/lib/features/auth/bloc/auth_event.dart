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

  const factory AuthEvent.phoneSignInRequested(String phoneNumber) =
      PhoneSignInRequested;

  const factory AuthEvent.phoneCodeVerified(
    String verificationId,
    String code,
  ) = PhoneCodeVerified;

  const factory AuthEvent.guestSignInRequested() = GuestSignInRequested;

  const factory AuthEvent.signOutRequested() = SignOutRequested;
}
