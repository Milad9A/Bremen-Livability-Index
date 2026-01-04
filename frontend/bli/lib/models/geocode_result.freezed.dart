// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geocode_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GeocodeResult _$GeocodeResultFromJson(Map<String, dynamic> json) {
  return _GeocodeResult.fromJson(json);
}

/// @nodoc
mixin _$GeocodeResult {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  Map<String, dynamic> get address => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get importance => throw _privateConstructorUsedError;

  /// Serializes this GeocodeResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeocodeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeocodeResultCopyWith<GeocodeResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeocodeResultCopyWith<$Res> {
  factory $GeocodeResultCopyWith(
    GeocodeResult value,
    $Res Function(GeocodeResult) then,
  ) = _$GeocodeResultCopyWithImpl<$Res, GeocodeResult>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    @JsonKey(name: 'display_name') String displayName,
    Map<String, dynamic> address,
    String type,
    double importance,
  });
}

/// @nodoc
class _$GeocodeResultCopyWithImpl<$Res, $Val extends GeocodeResult>
    implements $GeocodeResultCopyWith<$Res> {
  _$GeocodeResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeocodeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? displayName = null,
    Object? address = null,
    Object? type = null,
    Object? importance = null,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            importance: null == importance
                ? _value.importance
                : importance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeocodeResultImplCopyWith<$Res>
    implements $GeocodeResultCopyWith<$Res> {
  factory _$$GeocodeResultImplCopyWith(
    _$GeocodeResultImpl value,
    $Res Function(_$GeocodeResultImpl) then,
  ) = __$$GeocodeResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    @JsonKey(name: 'display_name') String displayName,
    Map<String, dynamic> address,
    String type,
    double importance,
  });
}

/// @nodoc
class __$$GeocodeResultImplCopyWithImpl<$Res>
    extends _$GeocodeResultCopyWithImpl<$Res, _$GeocodeResultImpl>
    implements _$$GeocodeResultImplCopyWith<$Res> {
  __$$GeocodeResultImplCopyWithImpl(
    _$GeocodeResultImpl _value,
    $Res Function(_$GeocodeResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeocodeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? displayName = null,
    Object? address = null,
    Object? type = null,
    Object? importance = null,
  }) {
    return _then(
      _$GeocodeResultImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value._address
            : address // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        importance: null == importance
            ? _value.importance
            : importance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeocodeResultImpl implements _GeocodeResult {
  const _$GeocodeResultImpl({
    required this.latitude,
    required this.longitude,
    @JsonKey(name: 'display_name') required this.displayName,
    required final Map<String, dynamic> address,
    required this.type,
    required this.importance,
  }) : _address = address;

  factory _$GeocodeResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeocodeResultImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  final Map<String, dynamic> _address;
  @override
  Map<String, dynamic> get address {
    if (_address is EqualUnmodifiableMapView) return _address;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_address);
  }

  @override
  final String type;
  @override
  final double importance;

  @override
  String toString() {
    return 'GeocodeResult(latitude: $latitude, longitude: $longitude, displayName: $displayName, address: $address, type: $type, importance: $importance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeocodeResultImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            const DeepCollectionEquality().equals(other._address, _address) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.importance, importance) ||
                other.importance == importance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    latitude,
    longitude,
    displayName,
    const DeepCollectionEquality().hash(_address),
    type,
    importance,
  );

  /// Create a copy of GeocodeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeocodeResultImplCopyWith<_$GeocodeResultImpl> get copyWith =>
      __$$GeocodeResultImplCopyWithImpl<_$GeocodeResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeocodeResultImplToJson(this);
  }
}

abstract class _GeocodeResult implements GeocodeResult {
  const factory _GeocodeResult({
    required final double latitude,
    required final double longitude,
    @JsonKey(name: 'display_name') required final String displayName,
    required final Map<String, dynamic> address,
    required final String type,
    required final double importance,
  }) = _$GeocodeResultImpl;

  factory _GeocodeResult.fromJson(Map<String, dynamic> json) =
      _$GeocodeResultImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  Map<String, dynamic> get address;
  @override
  String get type;
  @override
  double get importance;

  /// Create a copy of GeocodeResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeocodeResultImplCopyWith<_$GeocodeResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
