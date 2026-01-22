// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  AppUser? get user => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  AppAuthProvider? get loadingProvider => throw _privateConstructorUsedError;
  bool get isInitialized => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get emailLinkSent => throw _privateConstructorUsedError;
  String? get pendingEmail => throw _privateConstructorUsedError;

  /// Set when an email link is detected but no email is stored (cross-device flow)
  String? get pendingEmailLink => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({
    AppUser? user,
    bool isLoading,
    AppAuthProvider? loadingProvider,
    bool isInitialized,
    String? error,
    bool emailLinkSent,
    String? pendingEmail,
    String? pendingEmailLink,
  });

  $AppUserCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? loadingProvider = freezed,
    Object? isInitialized = null,
    Object? error = freezed,
    Object? emailLinkSent = null,
    Object? pendingEmail = freezed,
    Object? pendingEmailLink = freezed,
  }) {
    return _then(
      _value.copyWith(
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as AppUser?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            loadingProvider: freezed == loadingProvider
                ? _value.loadingProvider
                : loadingProvider // ignore: cast_nullable_to_non_nullable
                      as AppAuthProvider?,
            isInitialized: null == isInitialized
                ? _value.isInitialized
                : isInitialized // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            emailLinkSent: null == emailLinkSent
                ? _value.emailLinkSent
                : emailLinkSent // ignore: cast_nullable_to_non_nullable
                      as bool,
            pendingEmail: freezed == pendingEmail
                ? _value.pendingEmail
                : pendingEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            pendingEmailLink: freezed == pendingEmailLink
                ? _value.pendingEmailLink
                : pendingEmailLink // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $AppUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
    _$AuthStateImpl value,
    $Res Function(_$AuthStateImpl) then,
  ) = __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AppUser? user,
    bool isLoading,
    AppAuthProvider? loadingProvider,
    bool isInitialized,
    String? error,
    bool emailLinkSent,
    String? pendingEmail,
    String? pendingEmailLink,
  });

  @override
  $AppUserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
    _$AuthStateImpl _value,
    $Res Function(_$AuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? loadingProvider = freezed,
    Object? isInitialized = null,
    Object? error = freezed,
    Object? emailLinkSent = null,
    Object? pendingEmail = freezed,
    Object? pendingEmailLink = freezed,
  }) {
    return _then(
      _$AuthStateImpl(
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as AppUser?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        loadingProvider: freezed == loadingProvider
            ? _value.loadingProvider
            : loadingProvider // ignore: cast_nullable_to_non_nullable
                  as AppAuthProvider?,
        isInitialized: null == isInitialized
            ? _value.isInitialized
            : isInitialized // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        emailLinkSent: null == emailLinkSent
            ? _value.emailLinkSent
            : emailLinkSent // ignore: cast_nullable_to_non_nullable
                  as bool,
        pendingEmail: freezed == pendingEmail
            ? _value.pendingEmail
            : pendingEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        pendingEmailLink: freezed == pendingEmailLink
            ? _value.pendingEmailLink
            : pendingEmailLink // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthStateImpl extends _AuthState {
  const _$AuthStateImpl({
    this.user,
    this.isLoading = false,
    this.loadingProvider,
    this.isInitialized = false,
    this.error,
    this.emailLinkSent = false,
    this.pendingEmail,
    this.pendingEmailLink,
  }) : super._();

  @override
  final AppUser? user;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final AppAuthProvider? loadingProvider;
  @override
  @JsonKey()
  final bool isInitialized;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool emailLinkSent;
  @override
  final String? pendingEmail;

  /// Set when an email link is detected but no email is stored (cross-device flow)
  @override
  final String? pendingEmailLink;

  @override
  String toString() {
    return 'AuthState(user: $user, isLoading: $isLoading, loadingProvider: $loadingProvider, isInitialized: $isInitialized, error: $error, emailLinkSent: $emailLinkSent, pendingEmail: $pendingEmail, pendingEmailLink: $pendingEmailLink)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.loadingProvider, loadingProvider) ||
                other.loadingProvider == loadingProvider) &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.emailLinkSent, emailLinkSent) ||
                other.emailLinkSent == emailLinkSent) &&
            (identical(other.pendingEmail, pendingEmail) ||
                other.pendingEmail == pendingEmail) &&
            (identical(other.pendingEmailLink, pendingEmailLink) ||
                other.pendingEmailLink == pendingEmailLink));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    isLoading,
    loadingProvider,
    isInitialized,
    error,
    emailLinkSent,
    pendingEmail,
    pendingEmailLink,
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState extends AuthState {
  const factory _AuthState({
    final AppUser? user,
    final bool isLoading,
    final AppAuthProvider? loadingProvider,
    final bool isInitialized,
    final String? error,
    final bool emailLinkSent,
    final String? pendingEmail,
    final String? pendingEmailLink,
  }) = _$AuthStateImpl;
  const _AuthState._() : super._();

  @override
  AppUser? get user;
  @override
  bool get isLoading;
  @override
  AppAuthProvider? get loadingProvider;
  @override
  bool get isInitialized;
  @override
  String? get error;
  @override
  bool get emailLinkSent;
  @override
  String? get pendingEmail;

  /// Set when an email link is detected but no email is stored (cross-device flow)
  @override
  String? get pendingEmailLink;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
