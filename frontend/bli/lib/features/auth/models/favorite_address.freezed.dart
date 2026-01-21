// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FavoriteAddress _$FavoriteAddressFromJson(Map<String, dynamic> json) {
  return _FavoriteAddress.fromJson(json);
}

/// @nodoc
mixin _$FavoriteAddress {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FavoriteAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoriteAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteAddressCopyWith<FavoriteAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteAddressCopyWith<$Res> {
  factory $FavoriteAddressCopyWith(
    FavoriteAddress value,
    $Res Function(FavoriteAddress) then,
  ) = _$FavoriteAddressCopyWithImpl<$Res, FavoriteAddress>;
  @useResult
  $Res call({
    String id,
    String label,
    double latitude,
    double longitude,
    String? address,
    DateTime createdAt,
  });
}

/// @nodoc
class _$FavoriteAddressCopyWithImpl<$Res, $Val extends FavoriteAddress>
    implements $FavoriteAddressCopyWith<$Res> {
  _$FavoriteAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoriteAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FavoriteAddressImplCopyWith<$Res>
    implements $FavoriteAddressCopyWith<$Res> {
  factory _$$FavoriteAddressImplCopyWith(
    _$FavoriteAddressImpl value,
    $Res Function(_$FavoriteAddressImpl) then,
  ) = __$$FavoriteAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    double latitude,
    double longitude,
    String? address,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$FavoriteAddressImplCopyWithImpl<$Res>
    extends _$FavoriteAddressCopyWithImpl<$Res, _$FavoriteAddressImpl>
    implements _$$FavoriteAddressImplCopyWith<$Res> {
  __$$FavoriteAddressImplCopyWithImpl(
    _$FavoriteAddressImpl _value,
    $Res Function(_$FavoriteAddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoriteAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$FavoriteAddressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteAddressImpl implements _FavoriteAddress {
  const _$FavoriteAddressImpl({
    required this.id,
    required this.label,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.createdAt,
  });

  factory _$FavoriteAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteAddressImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? address;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FavoriteAddress(id: $id, label: $label, latitude: $latitude, longitude: $longitude, address: $address, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    latitude,
    longitude,
    address,
    createdAt,
  );

  /// Create a copy of FavoriteAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteAddressImplCopyWith<_$FavoriteAddressImpl> get copyWith =>
      __$$FavoriteAddressImplCopyWithImpl<_$FavoriteAddressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteAddressImplToJson(this);
  }
}

abstract class _FavoriteAddress implements FavoriteAddress {
  const factory _FavoriteAddress({
    required final String id,
    required final String label,
    required final double latitude,
    required final double longitude,
    final String? address,
    required final DateTime createdAt,
  }) = _$FavoriteAddressImpl;

  factory _FavoriteAddress.fromJson(Map<String, dynamic> json) =
      _$FavoriteAddressImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get address;
  @override
  DateTime get createdAt;

  /// Create a copy of FavoriteAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteAddressImplCopyWith<_$FavoriteAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
