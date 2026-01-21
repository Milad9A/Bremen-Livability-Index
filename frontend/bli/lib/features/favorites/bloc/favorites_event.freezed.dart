// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FavoritesEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId) loadFavoritesRequested,
    required TResult Function(String userId, FavoriteAddress address)
    addFavoriteRequested,
    required TResult Function(String userId, String addressId)
    removeFavoriteRequested,
    required TResult Function(List<FavoriteAddress> favorites) favoritesUpdated,
    required TResult Function() clearFavorites,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId)? loadFavoritesRequested,
    TResult? Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult? Function(String userId, String addressId)? removeFavoriteRequested,
    TResult? Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult? Function()? clearFavorites,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId)? loadFavoritesRequested,
    TResult Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult Function(String userId, String addressId)? removeFavoriteRequested,
    TResult Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult Function()? clearFavorites,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadFavoritesRequested value)
    loadFavoritesRequested,
    required TResult Function(AddFavoriteRequested value) addFavoriteRequested,
    required TResult Function(RemoveFavoriteRequested value)
    removeFavoriteRequested,
    required TResult Function(FavoritesUpdated value) favoritesUpdated,
    required TResult Function(ClearFavorites value) clearFavorites,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult? Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult? Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult? Function(FavoritesUpdated value)? favoritesUpdated,
    TResult? Function(ClearFavorites value)? clearFavorites,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult Function(FavoritesUpdated value)? favoritesUpdated,
    TResult Function(ClearFavorites value)? clearFavorites,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritesEventCopyWith<$Res> {
  factory $FavoritesEventCopyWith(
    FavoritesEvent value,
    $Res Function(FavoritesEvent) then,
  ) = _$FavoritesEventCopyWithImpl<$Res, FavoritesEvent>;
}

/// @nodoc
class _$FavoritesEventCopyWithImpl<$Res, $Val extends FavoritesEvent>
    implements $FavoritesEventCopyWith<$Res> {
  _$FavoritesEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadFavoritesRequestedImplCopyWith<$Res> {
  factory _$$LoadFavoritesRequestedImplCopyWith(
    _$LoadFavoritesRequestedImpl value,
    $Res Function(_$LoadFavoritesRequestedImpl) then,
  ) = __$$LoadFavoritesRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$LoadFavoritesRequestedImplCopyWithImpl<$Res>
    extends _$FavoritesEventCopyWithImpl<$Res, _$LoadFavoritesRequestedImpl>
    implements _$$LoadFavoritesRequestedImplCopyWith<$Res> {
  __$$LoadFavoritesRequestedImplCopyWithImpl(
    _$LoadFavoritesRequestedImpl _value,
    $Res Function(_$LoadFavoritesRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _$LoadFavoritesRequestedImpl(
        null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadFavoritesRequestedImpl implements LoadFavoritesRequested {
  const _$LoadFavoritesRequestedImpl(this.userId);

  @override
  final String userId;

  @override
  String toString() {
    return 'FavoritesEvent.loadFavoritesRequested(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadFavoritesRequestedImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadFavoritesRequestedImplCopyWith<_$LoadFavoritesRequestedImpl>
  get copyWith =>
      __$$LoadFavoritesRequestedImplCopyWithImpl<_$LoadFavoritesRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId) loadFavoritesRequested,
    required TResult Function(String userId, FavoriteAddress address)
    addFavoriteRequested,
    required TResult Function(String userId, String addressId)
    removeFavoriteRequested,
    required TResult Function(List<FavoriteAddress> favorites) favoritesUpdated,
    required TResult Function() clearFavorites,
  }) {
    return loadFavoritesRequested(userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId)? loadFavoritesRequested,
    TResult? Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult? Function(String userId, String addressId)? removeFavoriteRequested,
    TResult? Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult? Function()? clearFavorites,
  }) {
    return loadFavoritesRequested?.call(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId)? loadFavoritesRequested,
    TResult Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult Function(String userId, String addressId)? removeFavoriteRequested,
    TResult Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult Function()? clearFavorites,
    required TResult orElse(),
  }) {
    if (loadFavoritesRequested != null) {
      return loadFavoritesRequested(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadFavoritesRequested value)
    loadFavoritesRequested,
    required TResult Function(AddFavoriteRequested value) addFavoriteRequested,
    required TResult Function(RemoveFavoriteRequested value)
    removeFavoriteRequested,
    required TResult Function(FavoritesUpdated value) favoritesUpdated,
    required TResult Function(ClearFavorites value) clearFavorites,
  }) {
    return loadFavoritesRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult? Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult? Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult? Function(FavoritesUpdated value)? favoritesUpdated,
    TResult? Function(ClearFavorites value)? clearFavorites,
  }) {
    return loadFavoritesRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult Function(FavoritesUpdated value)? favoritesUpdated,
    TResult Function(ClearFavorites value)? clearFavorites,
    required TResult orElse(),
  }) {
    if (loadFavoritesRequested != null) {
      return loadFavoritesRequested(this);
    }
    return orElse();
  }
}

abstract class LoadFavoritesRequested implements FavoritesEvent {
  const factory LoadFavoritesRequested(final String userId) =
      _$LoadFavoritesRequestedImpl;

  String get userId;

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadFavoritesRequestedImplCopyWith<_$LoadFavoritesRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddFavoriteRequestedImplCopyWith<$Res> {
  factory _$$AddFavoriteRequestedImplCopyWith(
    _$AddFavoriteRequestedImpl value,
    $Res Function(_$AddFavoriteRequestedImpl) then,
  ) = __$$AddFavoriteRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, FavoriteAddress address});

  $FavoriteAddressCopyWith<$Res> get address;
}

/// @nodoc
class __$$AddFavoriteRequestedImplCopyWithImpl<$Res>
    extends _$FavoritesEventCopyWithImpl<$Res, _$AddFavoriteRequestedImpl>
    implements _$$AddFavoriteRequestedImplCopyWith<$Res> {
  __$$AddFavoriteRequestedImplCopyWithImpl(
    _$AddFavoriteRequestedImpl _value,
    $Res Function(_$AddFavoriteRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? address = null}) {
    return _then(
      _$AddFavoriteRequestedImpl(
        null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as FavoriteAddress,
      ),
    );
  }

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FavoriteAddressCopyWith<$Res> get address {
    return $FavoriteAddressCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value));
    });
  }
}

/// @nodoc

class _$AddFavoriteRequestedImpl implements AddFavoriteRequested {
  const _$AddFavoriteRequestedImpl(this.userId, this.address);

  @override
  final String userId;
  @override
  final FavoriteAddress address;

  @override
  String toString() {
    return 'FavoritesEvent.addFavoriteRequested(userId: $userId, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddFavoriteRequestedImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, address);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddFavoriteRequestedImplCopyWith<_$AddFavoriteRequestedImpl>
  get copyWith =>
      __$$AddFavoriteRequestedImplCopyWithImpl<_$AddFavoriteRequestedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId) loadFavoritesRequested,
    required TResult Function(String userId, FavoriteAddress address)
    addFavoriteRequested,
    required TResult Function(String userId, String addressId)
    removeFavoriteRequested,
    required TResult Function(List<FavoriteAddress> favorites) favoritesUpdated,
    required TResult Function() clearFavorites,
  }) {
    return addFavoriteRequested(userId, address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId)? loadFavoritesRequested,
    TResult? Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult? Function(String userId, String addressId)? removeFavoriteRequested,
    TResult? Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult? Function()? clearFavorites,
  }) {
    return addFavoriteRequested?.call(userId, address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId)? loadFavoritesRequested,
    TResult Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult Function(String userId, String addressId)? removeFavoriteRequested,
    TResult Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult Function()? clearFavorites,
    required TResult orElse(),
  }) {
    if (addFavoriteRequested != null) {
      return addFavoriteRequested(userId, address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadFavoritesRequested value)
    loadFavoritesRequested,
    required TResult Function(AddFavoriteRequested value) addFavoriteRequested,
    required TResult Function(RemoveFavoriteRequested value)
    removeFavoriteRequested,
    required TResult Function(FavoritesUpdated value) favoritesUpdated,
    required TResult Function(ClearFavorites value) clearFavorites,
  }) {
    return addFavoriteRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult? Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult? Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult? Function(FavoritesUpdated value)? favoritesUpdated,
    TResult? Function(ClearFavorites value)? clearFavorites,
  }) {
    return addFavoriteRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult Function(FavoritesUpdated value)? favoritesUpdated,
    TResult Function(ClearFavorites value)? clearFavorites,
    required TResult orElse(),
  }) {
    if (addFavoriteRequested != null) {
      return addFavoriteRequested(this);
    }
    return orElse();
  }
}

abstract class AddFavoriteRequested implements FavoritesEvent {
  const factory AddFavoriteRequested(
    final String userId,
    final FavoriteAddress address,
  ) = _$AddFavoriteRequestedImpl;

  String get userId;
  FavoriteAddress get address;

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddFavoriteRequestedImplCopyWith<_$AddFavoriteRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RemoveFavoriteRequestedImplCopyWith<$Res> {
  factory _$$RemoveFavoriteRequestedImplCopyWith(
    _$RemoveFavoriteRequestedImpl value,
    $Res Function(_$RemoveFavoriteRequestedImpl) then,
  ) = __$$RemoveFavoriteRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, String addressId});
}

/// @nodoc
class __$$RemoveFavoriteRequestedImplCopyWithImpl<$Res>
    extends _$FavoritesEventCopyWithImpl<$Res, _$RemoveFavoriteRequestedImpl>
    implements _$$RemoveFavoriteRequestedImplCopyWith<$Res> {
  __$$RemoveFavoriteRequestedImplCopyWithImpl(
    _$RemoveFavoriteRequestedImpl _value,
    $Res Function(_$RemoveFavoriteRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? addressId = null}) {
    return _then(
      _$RemoveFavoriteRequestedImpl(
        null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == addressId
            ? _value.addressId
            : addressId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RemoveFavoriteRequestedImpl implements RemoveFavoriteRequested {
  const _$RemoveFavoriteRequestedImpl(this.userId, this.addressId);

  @override
  final String userId;
  @override
  final String addressId;

  @override
  String toString() {
    return 'FavoritesEvent.removeFavoriteRequested(userId: $userId, addressId: $addressId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveFavoriteRequestedImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, addressId);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveFavoriteRequestedImplCopyWith<_$RemoveFavoriteRequestedImpl>
  get copyWith =>
      __$$RemoveFavoriteRequestedImplCopyWithImpl<
        _$RemoveFavoriteRequestedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId) loadFavoritesRequested,
    required TResult Function(String userId, FavoriteAddress address)
    addFavoriteRequested,
    required TResult Function(String userId, String addressId)
    removeFavoriteRequested,
    required TResult Function(List<FavoriteAddress> favorites) favoritesUpdated,
    required TResult Function() clearFavorites,
  }) {
    return removeFavoriteRequested(userId, addressId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId)? loadFavoritesRequested,
    TResult? Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult? Function(String userId, String addressId)? removeFavoriteRequested,
    TResult? Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult? Function()? clearFavorites,
  }) {
    return removeFavoriteRequested?.call(userId, addressId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId)? loadFavoritesRequested,
    TResult Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult Function(String userId, String addressId)? removeFavoriteRequested,
    TResult Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult Function()? clearFavorites,
    required TResult orElse(),
  }) {
    if (removeFavoriteRequested != null) {
      return removeFavoriteRequested(userId, addressId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadFavoritesRequested value)
    loadFavoritesRequested,
    required TResult Function(AddFavoriteRequested value) addFavoriteRequested,
    required TResult Function(RemoveFavoriteRequested value)
    removeFavoriteRequested,
    required TResult Function(FavoritesUpdated value) favoritesUpdated,
    required TResult Function(ClearFavorites value) clearFavorites,
  }) {
    return removeFavoriteRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult? Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult? Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult? Function(FavoritesUpdated value)? favoritesUpdated,
    TResult? Function(ClearFavorites value)? clearFavorites,
  }) {
    return removeFavoriteRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult Function(FavoritesUpdated value)? favoritesUpdated,
    TResult Function(ClearFavorites value)? clearFavorites,
    required TResult orElse(),
  }) {
    if (removeFavoriteRequested != null) {
      return removeFavoriteRequested(this);
    }
    return orElse();
  }
}

abstract class RemoveFavoriteRequested implements FavoritesEvent {
  const factory RemoveFavoriteRequested(
    final String userId,
    final String addressId,
  ) = _$RemoveFavoriteRequestedImpl;

  String get userId;
  String get addressId;

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoveFavoriteRequestedImplCopyWith<_$RemoveFavoriteRequestedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FavoritesUpdatedImplCopyWith<$Res> {
  factory _$$FavoritesUpdatedImplCopyWith(
    _$FavoritesUpdatedImpl value,
    $Res Function(_$FavoritesUpdatedImpl) then,
  ) = __$$FavoritesUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<FavoriteAddress> favorites});
}

/// @nodoc
class __$$FavoritesUpdatedImplCopyWithImpl<$Res>
    extends _$FavoritesEventCopyWithImpl<$Res, _$FavoritesUpdatedImpl>
    implements _$$FavoritesUpdatedImplCopyWith<$Res> {
  __$$FavoritesUpdatedImplCopyWithImpl(
    _$FavoritesUpdatedImpl _value,
    $Res Function(_$FavoritesUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? favorites = null}) {
    return _then(
      _$FavoritesUpdatedImpl(
        null == favorites
            ? _value._favorites
            : favorites // ignore: cast_nullable_to_non_nullable
                  as List<FavoriteAddress>,
      ),
    );
  }
}

/// @nodoc

class _$FavoritesUpdatedImpl implements FavoritesUpdated {
  const _$FavoritesUpdatedImpl(final List<FavoriteAddress> favorites)
    : _favorites = favorites;

  final List<FavoriteAddress> _favorites;
  @override
  List<FavoriteAddress> get favorites {
    if (_favorites is EqualUnmodifiableListView) return _favorites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favorites);
  }

  @override
  String toString() {
    return 'FavoritesEvent.favoritesUpdated(favorites: $favorites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritesUpdatedImpl &&
            const DeepCollectionEquality().equals(
              other._favorites,
              _favorites,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_favorites));

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritesUpdatedImplCopyWith<_$FavoritesUpdatedImpl> get copyWith =>
      __$$FavoritesUpdatedImplCopyWithImpl<_$FavoritesUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId) loadFavoritesRequested,
    required TResult Function(String userId, FavoriteAddress address)
    addFavoriteRequested,
    required TResult Function(String userId, String addressId)
    removeFavoriteRequested,
    required TResult Function(List<FavoriteAddress> favorites) favoritesUpdated,
    required TResult Function() clearFavorites,
  }) {
    return favoritesUpdated(favorites);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId)? loadFavoritesRequested,
    TResult? Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult? Function(String userId, String addressId)? removeFavoriteRequested,
    TResult? Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult? Function()? clearFavorites,
  }) {
    return favoritesUpdated?.call(favorites);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId)? loadFavoritesRequested,
    TResult Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult Function(String userId, String addressId)? removeFavoriteRequested,
    TResult Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult Function()? clearFavorites,
    required TResult orElse(),
  }) {
    if (favoritesUpdated != null) {
      return favoritesUpdated(favorites);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadFavoritesRequested value)
    loadFavoritesRequested,
    required TResult Function(AddFavoriteRequested value) addFavoriteRequested,
    required TResult Function(RemoveFavoriteRequested value)
    removeFavoriteRequested,
    required TResult Function(FavoritesUpdated value) favoritesUpdated,
    required TResult Function(ClearFavorites value) clearFavorites,
  }) {
    return favoritesUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult? Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult? Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult? Function(FavoritesUpdated value)? favoritesUpdated,
    TResult? Function(ClearFavorites value)? clearFavorites,
  }) {
    return favoritesUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult Function(FavoritesUpdated value)? favoritesUpdated,
    TResult Function(ClearFavorites value)? clearFavorites,
    required TResult orElse(),
  }) {
    if (favoritesUpdated != null) {
      return favoritesUpdated(this);
    }
    return orElse();
  }
}

abstract class FavoritesUpdated implements FavoritesEvent {
  const factory FavoritesUpdated(final List<FavoriteAddress> favorites) =
      _$FavoritesUpdatedImpl;

  List<FavoriteAddress> get favorites;

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoritesUpdatedImplCopyWith<_$FavoritesUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearFavoritesImplCopyWith<$Res> {
  factory _$$ClearFavoritesImplCopyWith(
    _$ClearFavoritesImpl value,
    $Res Function(_$ClearFavoritesImpl) then,
  ) = __$$ClearFavoritesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearFavoritesImplCopyWithImpl<$Res>
    extends _$FavoritesEventCopyWithImpl<$Res, _$ClearFavoritesImpl>
    implements _$$ClearFavoritesImplCopyWith<$Res> {
  __$$ClearFavoritesImplCopyWithImpl(
    _$ClearFavoritesImpl _value,
    $Res Function(_$ClearFavoritesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoritesEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearFavoritesImpl implements ClearFavorites {
  const _$ClearFavoritesImpl();

  @override
  String toString() {
    return 'FavoritesEvent.clearFavorites()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearFavoritesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userId) loadFavoritesRequested,
    required TResult Function(String userId, FavoriteAddress address)
    addFavoriteRequested,
    required TResult Function(String userId, String addressId)
    removeFavoriteRequested,
    required TResult Function(List<FavoriteAddress> favorites) favoritesUpdated,
    required TResult Function() clearFavorites,
  }) {
    return clearFavorites();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userId)? loadFavoritesRequested,
    TResult? Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult? Function(String userId, String addressId)? removeFavoriteRequested,
    TResult? Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult? Function()? clearFavorites,
  }) {
    return clearFavorites?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userId)? loadFavoritesRequested,
    TResult Function(String userId, FavoriteAddress address)?
    addFavoriteRequested,
    TResult Function(String userId, String addressId)? removeFavoriteRequested,
    TResult Function(List<FavoriteAddress> favorites)? favoritesUpdated,
    TResult Function()? clearFavorites,
    required TResult orElse(),
  }) {
    if (clearFavorites != null) {
      return clearFavorites();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadFavoritesRequested value)
    loadFavoritesRequested,
    required TResult Function(AddFavoriteRequested value) addFavoriteRequested,
    required TResult Function(RemoveFavoriteRequested value)
    removeFavoriteRequested,
    required TResult Function(FavoritesUpdated value) favoritesUpdated,
    required TResult Function(ClearFavorites value) clearFavorites,
  }) {
    return clearFavorites(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult? Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult? Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult? Function(FavoritesUpdated value)? favoritesUpdated,
    TResult? Function(ClearFavorites value)? clearFavorites,
  }) {
    return clearFavorites?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadFavoritesRequested value)? loadFavoritesRequested,
    TResult Function(AddFavoriteRequested value)? addFavoriteRequested,
    TResult Function(RemoveFavoriteRequested value)? removeFavoriteRequested,
    TResult Function(FavoritesUpdated value)? favoritesUpdated,
    TResult Function(ClearFavorites value)? clearFavorites,
    required TResult orElse(),
  }) {
    if (clearFavorites != null) {
      return clearFavorites(this);
    }
    return orElse();
  }
}

abstract class ClearFavorites implements FavoritesEvent {
  const factory ClearFavorites() = _$ClearFavoritesImpl;
}
