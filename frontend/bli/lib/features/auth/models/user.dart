import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum AppAuthProvider {
  @JsonValue('google')
  google,
  @JsonValue('github')
  github,
  @JsonValue('email')
  email,
  @JsonValue('phone')
  phone,
  @JsonValue('guest')
  guest,
}

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    String? email,
    String? displayName,
    String? photoUrl,
    required AppAuthProvider provider,
    @Default(false) bool isAnonymous,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.guest() => const AppUser(
    id: 'guest',
    provider: AppAuthProvider.guest,
    isAnonymous: true,
  );
}
