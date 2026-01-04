// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeatureDetail _$FeatureDetailFromJson(Map<String, dynamic> json) {
  return _FeatureDetail.fromJson(json);
}

/// @nodoc
mixin _$FeatureDetail {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  FeatureType get type => throw _privateConstructorUsedError;
  String? get subtype => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  Map<String, dynamic> get geometry => throw _privateConstructorUsedError;

  /// Serializes this FeatureDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeatureDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureDetailCopyWith<FeatureDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureDetailCopyWith<$Res> {
  factory $FeatureDetailCopyWith(
    FeatureDetail value,
    $Res Function(FeatureDetail) then,
  ) = _$FeatureDetailCopyWithImpl<$Res, FeatureDetail>;
  @useResult
  $Res call({
    int? id,
    String? name,
    FeatureType type,
    String? subtype,
    double distance,
    Map<String, dynamic> geometry,
  });
}

/// @nodoc
class _$FeatureDetailCopyWithImpl<$Res, $Val extends FeatureDetail>
    implements $FeatureDetailCopyWith<$Res> {
  _$FeatureDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeatureDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? type = null,
    Object? subtype = freezed,
    Object? distance = null,
    Object? geometry = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as FeatureType,
            subtype: freezed == subtype
                ? _value.subtype
                : subtype // ignore: cast_nullable_to_non_nullable
                      as String?,
            distance: null == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double,
            geometry: null == geometry
                ? _value.geometry
                : geometry // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeatureDetailImplCopyWith<$Res>
    implements $FeatureDetailCopyWith<$Res> {
  factory _$$FeatureDetailImplCopyWith(
    _$FeatureDetailImpl value,
    $Res Function(_$FeatureDetailImpl) then,
  ) = __$$FeatureDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? name,
    FeatureType type,
    String? subtype,
    double distance,
    Map<String, dynamic> geometry,
  });
}

/// @nodoc
class __$$FeatureDetailImplCopyWithImpl<$Res>
    extends _$FeatureDetailCopyWithImpl<$Res, _$FeatureDetailImpl>
    implements _$$FeatureDetailImplCopyWith<$Res> {
  __$$FeatureDetailImplCopyWithImpl(
    _$FeatureDetailImpl _value,
    $Res Function(_$FeatureDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeatureDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? type = null,
    Object? subtype = freezed,
    Object? distance = null,
    Object? geometry = null,
  }) {
    return _then(
      _$FeatureDetailImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as FeatureType,
        subtype: freezed == subtype
            ? _value.subtype
            : subtype // ignore: cast_nullable_to_non_nullable
                  as String?,
        distance: null == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double,
        geometry: null == geometry
            ? _value._geometry
            : geometry // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeatureDetailImpl implements _FeatureDetail {
  const _$FeatureDetailImpl({
    this.id,
    this.name,
    required this.type,
    this.subtype,
    required this.distance,
    required final Map<String, dynamic> geometry,
  }) : _geometry = geometry;

  factory _$FeatureDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeatureDetailImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final FeatureType type;
  @override
  final String? subtype;
  @override
  final double distance;
  final Map<String, dynamic> _geometry;
  @override
  Map<String, dynamic> get geometry {
    if (_geometry is EqualUnmodifiableMapView) return _geometry;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_geometry);
  }

  @override
  String toString() {
    return 'FeatureDetail(id: $id, name: $name, type: $type, subtype: $subtype, distance: $distance, geometry: $geometry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.subtype, subtype) || other.subtype == subtype) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            const DeepCollectionEquality().equals(other._geometry, _geometry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    subtype,
    distance,
    const DeepCollectionEquality().hash(_geometry),
  );

  /// Create a copy of FeatureDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureDetailImplCopyWith<_$FeatureDetailImpl> get copyWith =>
      __$$FeatureDetailImplCopyWithImpl<_$FeatureDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeatureDetailImplToJson(this);
  }
}

abstract class _FeatureDetail implements FeatureDetail {
  const factory _FeatureDetail({
    final int? id,
    final String? name,
    required final FeatureType type,
    final String? subtype,
    required final double distance,
    required final Map<String, dynamic> geometry,
  }) = _$FeatureDetailImpl;

  factory _FeatureDetail.fromJson(Map<String, dynamic> json) =
      _$FeatureDetailImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  FeatureType get type;
  @override
  String? get subtype;
  @override
  double get distance;
  @override
  Map<String, dynamic> get geometry;

  /// Create a copy of FeatureDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureDetailImplCopyWith<_$FeatureDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
