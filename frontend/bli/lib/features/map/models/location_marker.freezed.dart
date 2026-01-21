// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LocationMarker {
  LatLng get position => throw _privateConstructorUsedError;
  double? get score => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Create a copy of LocationMarker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationMarkerCopyWith<LocationMarker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationMarkerCopyWith<$Res> {
  factory $LocationMarkerCopyWith(
    LocationMarker value,
    $Res Function(LocationMarker) then,
  ) = _$LocationMarkerCopyWithImpl<$Res, LocationMarker>;
  @useResult
  $Res call({
    LatLng position,
    double? score,
    String? address,
    DateTime? timestamp,
  });
}

/// @nodoc
class _$LocationMarkerCopyWithImpl<$Res, $Val extends LocationMarker>
    implements $LocationMarkerCopyWith<$Res> {
  _$LocationMarkerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationMarker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? score = freezed,
    Object? address = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as LatLng,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationMarkerImplCopyWith<$Res>
    implements $LocationMarkerCopyWith<$Res> {
  factory _$$LocationMarkerImplCopyWith(
    _$LocationMarkerImpl value,
    $Res Function(_$LocationMarkerImpl) then,
  ) = __$$LocationMarkerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LatLng position,
    double? score,
    String? address,
    DateTime? timestamp,
  });
}

/// @nodoc
class __$$LocationMarkerImplCopyWithImpl<$Res>
    extends _$LocationMarkerCopyWithImpl<$Res, _$LocationMarkerImpl>
    implements _$$LocationMarkerImplCopyWith<$Res> {
  __$$LocationMarkerImplCopyWithImpl(
    _$LocationMarkerImpl _value,
    $Res Function(_$LocationMarkerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationMarker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? score = freezed,
    Object? address = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(
      _$LocationMarkerImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as LatLng,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$LocationMarkerImpl implements _LocationMarker {
  const _$LocationMarkerImpl({
    required this.position,
    this.score,
    this.address,
    this.timestamp,
  });

  @override
  final LatLng position;
  @override
  final double? score;
  @override
  final String? address;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'LocationMarker(position: $position, score: $score, address: $address, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationMarkerImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, position, score, address, timestamp);

  /// Create a copy of LocationMarker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationMarkerImplCopyWith<_$LocationMarkerImpl> get copyWith =>
      __$$LocationMarkerImplCopyWithImpl<_$LocationMarkerImpl>(
        this,
        _$identity,
      );
}

abstract class _LocationMarker implements LocationMarker {
  const factory _LocationMarker({
    required final LatLng position,
    final double? score,
    final String? address,
    final DateTime? timestamp,
  }) = _$LocationMarkerImpl;

  @override
  LatLng get position;
  @override
  double? get score;
  @override
  String? get address;
  @override
  DateTime? get timestamp;

  /// Create a copy of LocationMarker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationMarkerImplCopyWith<_$LocationMarkerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
