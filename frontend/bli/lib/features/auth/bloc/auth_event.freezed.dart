// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthCheckRequestedImplCopyWith<$Res> {
  factory _$$AuthCheckRequestedImplCopyWith(
    _$AuthCheckRequestedImpl value,
    $Res Function(_$AuthCheckRequestedImpl) then,
  ) = __$$AuthCheckRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthCheckRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthCheckRequestedImpl>
    implements _$$AuthCheckRequestedImplCopyWith<$Res> {
  __$$AuthCheckRequestedImplCopyWithImpl(
    _$AuthCheckRequestedImpl _value,
    $Res Function(_$AuthCheckRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthCheckRequestedImpl implements AuthCheckRequested {
  const _$AuthCheckRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.checkRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthCheckRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return checkRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return checkRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (checkRequested != null) {
      return checkRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return checkRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return checkRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (checkRequested != null) {
      return checkRequested(this);
    }
    return orElse();
  }
}

abstract class AuthCheckRequested implements AuthEvent {
  const factory AuthCheckRequested() = _$AuthCheckRequestedImpl;
}

/// @nodoc
abstract class _$$GoogleSignInRequestedImplCopyWith<$Res> {
  factory _$$GoogleSignInRequestedImplCopyWith(
    _$GoogleSignInRequestedImpl value,
    $Res Function(_$GoogleSignInRequestedImpl) then,
  ) = __$$GoogleSignInRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GoogleSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$GoogleSignInRequestedImpl>
    implements _$$GoogleSignInRequestedImplCopyWith<$Res> {
  __$$GoogleSignInRequestedImplCopyWithImpl(
    _$GoogleSignInRequestedImpl _value,
    $Res Function(_$GoogleSignInRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GoogleSignInRequestedImpl implements GoogleSignInRequested {
  const _$GoogleSignInRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.googleSignInRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleSignInRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return googleSignInRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return googleSignInRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return googleSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return googleSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested(this);
    }
    return orElse();
  }
}

abstract class GoogleSignInRequested implements AuthEvent {
  const factory GoogleSignInRequested() = _$GoogleSignInRequestedImpl;
}

/// @nodoc
abstract class _$$GitHubSignInRequestedImplCopyWith<$Res> {
  factory _$$GitHubSignInRequestedImplCopyWith(
    _$GitHubSignInRequestedImpl value,
    $Res Function(_$GitHubSignInRequestedImpl) then,
  ) = __$$GitHubSignInRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GitHubSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$GitHubSignInRequestedImpl>
    implements _$$GitHubSignInRequestedImplCopyWith<$Res> {
  __$$GitHubSignInRequestedImplCopyWithImpl(
    _$GitHubSignInRequestedImpl _value,
    $Res Function(_$GitHubSignInRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GitHubSignInRequestedImpl implements GitHubSignInRequested {
  const _$GitHubSignInRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.gitHubSignInRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GitHubSignInRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return gitHubSignInRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return gitHubSignInRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (gitHubSignInRequested != null) {
      return gitHubSignInRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return gitHubSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return gitHubSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (gitHubSignInRequested != null) {
      return gitHubSignInRequested(this);
    }
    return orElse();
  }
}

abstract class GitHubSignInRequested implements AuthEvent {
  const factory GitHubSignInRequested() = _$GitHubSignInRequestedImpl;
}

/// @nodoc
abstract class _$$EmailSignInRequestedImplCopyWith<$Res> {
  factory _$$EmailSignInRequestedImplCopyWith(
    _$EmailSignInRequestedImpl value,
    $Res Function(_$EmailSignInRequestedImpl) then,
  ) = __$$EmailSignInRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$EmailSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$EmailSignInRequestedImpl>
    implements _$$EmailSignInRequestedImplCopyWith<$Res> {
  __$$EmailSignInRequestedImplCopyWithImpl(
    _$EmailSignInRequestedImpl _value,
    $Res Function(_$EmailSignInRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$EmailSignInRequestedImpl(
        null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$EmailSignInRequestedImpl implements EmailSignInRequested {
  const _$EmailSignInRequestedImpl(this.email);

  @override
  final String email;

  @override
  String toString() {
    return 'AuthEvent.emailSignInRequested(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailSignInRequestedImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailSignInRequestedImplCopyWith<_$EmailSignInRequestedImpl>
  get copyWith =>
      __$$EmailSignInRequestedImplCopyWithImpl<_$EmailSignInRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return emailSignInRequested(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return emailSignInRequested?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (emailSignInRequested != null) {
      return emailSignInRequested(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return emailSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return emailSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (emailSignInRequested != null) {
      return emailSignInRequested(this);
    }
    return orElse();
  }
}

abstract class EmailSignInRequested implements AuthEvent {
  const factory EmailSignInRequested(final String email) =
      _$EmailSignInRequestedImpl;

  String get email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailSignInRequestedImplCopyWith<_$EmailSignInRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmailLinkVerifiedImplCopyWith<$Res> {
  factory _$$EmailLinkVerifiedImplCopyWith(
    _$EmailLinkVerifiedImpl value,
    $Res Function(_$EmailLinkVerifiedImpl) then,
  ) = __$$EmailLinkVerifiedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String link});
}

/// @nodoc
class __$$EmailLinkVerifiedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$EmailLinkVerifiedImpl>
    implements _$$EmailLinkVerifiedImplCopyWith<$Res> {
  __$$EmailLinkVerifiedImplCopyWithImpl(
    _$EmailLinkVerifiedImpl _value,
    $Res Function(_$EmailLinkVerifiedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? link = null}) {
    return _then(
      _$EmailLinkVerifiedImpl(
        null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        null == link
            ? _value.link
            : link // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$EmailLinkVerifiedImpl implements EmailLinkVerified {
  const _$EmailLinkVerifiedImpl(this.email, this.link);

  @override
  final String email;
  @override
  final String link;

  @override
  String toString() {
    return 'AuthEvent.emailLinkVerified(email: $email, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailLinkVerifiedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.link, link) || other.link == link));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, link);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailLinkVerifiedImplCopyWith<_$EmailLinkVerifiedImpl> get copyWith =>
      __$$EmailLinkVerifiedImplCopyWithImpl<_$EmailLinkVerifiedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return emailLinkVerified(email, link);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return emailLinkVerified?.call(email, link);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (emailLinkVerified != null) {
      return emailLinkVerified(email, link);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return emailLinkVerified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return emailLinkVerified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (emailLinkVerified != null) {
      return emailLinkVerified(this);
    }
    return orElse();
  }
}

abstract class EmailLinkVerified implements AuthEvent {
  const factory EmailLinkVerified(final String email, final String link) =
      _$EmailLinkVerifiedImpl;

  String get email;
  String get link;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailLinkVerifiedImplCopyWith<_$EmailLinkVerifiedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PhoneSignInRequestedImplCopyWith<$Res> {
  factory _$$PhoneSignInRequestedImplCopyWith(
    _$PhoneSignInRequestedImpl value,
    $Res Function(_$PhoneSignInRequestedImpl) then,
  ) = __$$PhoneSignInRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class __$$PhoneSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$PhoneSignInRequestedImpl>
    implements _$$PhoneSignInRequestedImplCopyWith<$Res> {
  __$$PhoneSignInRequestedImplCopyWithImpl(
    _$PhoneSignInRequestedImpl _value,
    $Res Function(_$PhoneSignInRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phoneNumber = null}) {
    return _then(
      _$PhoneSignInRequestedImpl(
        null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PhoneSignInRequestedImpl implements PhoneSignInRequested {
  const _$PhoneSignInRequestedImpl(this.phoneNumber);

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'AuthEvent.phoneSignInRequested(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneSignInRequestedImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneSignInRequestedImplCopyWith<_$PhoneSignInRequestedImpl>
  get copyWith =>
      __$$PhoneSignInRequestedImplCopyWithImpl<_$PhoneSignInRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return phoneSignInRequested(phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return phoneSignInRequested?.call(phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (phoneSignInRequested != null) {
      return phoneSignInRequested(phoneNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return phoneSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return phoneSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (phoneSignInRequested != null) {
      return phoneSignInRequested(this);
    }
    return orElse();
  }
}

abstract class PhoneSignInRequested implements AuthEvent {
  const factory PhoneSignInRequested(final String phoneNumber) =
      _$PhoneSignInRequestedImpl;

  String get phoneNumber;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneSignInRequestedImplCopyWith<_$PhoneSignInRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PhoneCodeVerifiedImplCopyWith<$Res> {
  factory _$$PhoneCodeVerifiedImplCopyWith(
    _$PhoneCodeVerifiedImpl value,
    $Res Function(_$PhoneCodeVerifiedImpl) then,
  ) = __$$PhoneCodeVerifiedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String verificationId, String code});
}

/// @nodoc
class __$$PhoneCodeVerifiedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$PhoneCodeVerifiedImpl>
    implements _$$PhoneCodeVerifiedImplCopyWith<$Res> {
  __$$PhoneCodeVerifiedImplCopyWithImpl(
    _$PhoneCodeVerifiedImpl _value,
    $Res Function(_$PhoneCodeVerifiedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? verificationId = null, Object? code = null}) {
    return _then(
      _$PhoneCodeVerifiedImpl(
        null == verificationId
            ? _value.verificationId
            : verificationId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PhoneCodeVerifiedImpl implements PhoneCodeVerified {
  const _$PhoneCodeVerifiedImpl(this.verificationId, this.code);

  @override
  final String verificationId;
  @override
  final String code;

  @override
  String toString() {
    return 'AuthEvent.phoneCodeVerified(verificationId: $verificationId, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneCodeVerifiedImpl &&
            (identical(other.verificationId, verificationId) ||
                other.verificationId == verificationId) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, verificationId, code);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneCodeVerifiedImplCopyWith<_$PhoneCodeVerifiedImpl> get copyWith =>
      __$$PhoneCodeVerifiedImplCopyWithImpl<_$PhoneCodeVerifiedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return phoneCodeVerified(verificationId, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return phoneCodeVerified?.call(verificationId, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (phoneCodeVerified != null) {
      return phoneCodeVerified(verificationId, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return phoneCodeVerified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return phoneCodeVerified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (phoneCodeVerified != null) {
      return phoneCodeVerified(this);
    }
    return orElse();
  }
}

abstract class PhoneCodeVerified implements AuthEvent {
  const factory PhoneCodeVerified(
    final String verificationId,
    final String code,
  ) = _$PhoneCodeVerifiedImpl;

  String get verificationId;
  String get code;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneCodeVerifiedImplCopyWith<_$PhoneCodeVerifiedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GuestSignInRequestedImplCopyWith<$Res> {
  factory _$$GuestSignInRequestedImplCopyWith(
    _$GuestSignInRequestedImpl value,
    $Res Function(_$GuestSignInRequestedImpl) then,
  ) = __$$GuestSignInRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GuestSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$GuestSignInRequestedImpl>
    implements _$$GuestSignInRequestedImplCopyWith<$Res> {
  __$$GuestSignInRequestedImplCopyWithImpl(
    _$GuestSignInRequestedImpl _value,
    $Res Function(_$GuestSignInRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GuestSignInRequestedImpl implements GuestSignInRequested {
  const _$GuestSignInRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.guestSignInRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestSignInRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return guestSignInRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return guestSignInRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (guestSignInRequested != null) {
      return guestSignInRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return guestSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return guestSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (guestSignInRequested != null) {
      return guestSignInRequested(this);
    }
    return orElse();
  }
}

abstract class GuestSignInRequested implements AuthEvent {
  const factory GuestSignInRequested() = _$GuestSignInRequestedImpl;
}

/// @nodoc
abstract class _$$SignOutRequestedImplCopyWith<$Res> {
  factory _$$SignOutRequestedImplCopyWith(
    _$SignOutRequestedImpl value,
    $Res Function(_$SignOutRequestedImpl) then,
  ) = __$$SignOutRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignOutRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SignOutRequestedImpl>
    implements _$$SignOutRequestedImplCopyWith<$Res> {
  __$$SignOutRequestedImplCopyWithImpl(
    _$SignOutRequestedImpl _value,
    $Res Function(_$SignOutRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignOutRequestedImpl implements SignOutRequested {
  const _$SignOutRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.signOutRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignOutRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() gitHubSignInRequested,
    required TResult Function(String email) emailSignInRequested,
    required TResult Function(String email, String link) emailLinkVerified,
    required TResult Function(String phoneNumber) phoneSignInRequested,
    required TResult Function(String verificationId, String code)
    phoneCodeVerified,
    required TResult Function() guestSignInRequested,
    required TResult Function() signOutRequested,
  }) {
    return signOutRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? gitHubSignInRequested,
    TResult? Function(String email)? emailSignInRequested,
    TResult? Function(String email, String link)? emailLinkVerified,
    TResult? Function(String phoneNumber)? phoneSignInRequested,
    TResult? Function(String verificationId, String code)? phoneCodeVerified,
    TResult? Function()? guestSignInRequested,
    TResult? Function()? signOutRequested,
  }) {
    return signOutRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? gitHubSignInRequested,
    TResult Function(String email)? emailSignInRequested,
    TResult Function(String email, String link)? emailLinkVerified,
    TResult Function(String phoneNumber)? phoneSignInRequested,
    TResult Function(String verificationId, String code)? phoneCodeVerified,
    TResult Function()? guestSignInRequested,
    TResult Function()? signOutRequested,
    required TResult orElse(),
  }) {
    if (signOutRequested != null) {
      return signOutRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(GoogleSignInRequested value)
    googleSignInRequested,
    required TResult Function(GitHubSignInRequested value)
    gitHubSignInRequested,
    required TResult Function(EmailSignInRequested value) emailSignInRequested,
    required TResult Function(EmailLinkVerified value) emailLinkVerified,
    required TResult Function(PhoneSignInRequested value) phoneSignInRequested,
    required TResult Function(PhoneCodeVerified value) phoneCodeVerified,
    required TResult Function(GuestSignInRequested value) guestSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
  }) {
    return signOutRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult? Function(EmailSignInRequested value)? emailSignInRequested,
    TResult? Function(EmailLinkVerified value)? emailLinkVerified,
    TResult? Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult? Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult? Function(GuestSignInRequested value)? guestSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
  }) {
    return signOutRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(GitHubSignInRequested value)? gitHubSignInRequested,
    TResult Function(EmailSignInRequested value)? emailSignInRequested,
    TResult Function(EmailLinkVerified value)? emailLinkVerified,
    TResult Function(PhoneSignInRequested value)? phoneSignInRequested,
    TResult Function(PhoneCodeVerified value)? phoneCodeVerified,
    TResult Function(GuestSignInRequested value)? guestSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    required TResult orElse(),
  }) {
    if (signOutRequested != null) {
      return signOutRequested(this);
    }
    return orElse();
  }
}

abstract class SignOutRequested implements AuthEvent {
  const factory SignOutRequested() = _$SignOutRequestedImpl;
}
