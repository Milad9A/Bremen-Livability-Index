// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'factor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Factor _$FactorFromJson(Map<String, dynamic> json) {
  return _Factor.fromJson(json);
}

/// @nodoc
mixin _$Factor {
  String get factor => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get impact => throw _privateConstructorUsedError;

  /// Serializes this Factor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Factor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactorCopyWith<Factor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactorCopyWith<$Res> {
  factory $FactorCopyWith(Factor value, $Res Function(Factor) then) =
      _$FactorCopyWithImpl<$Res, Factor>;
  @useResult
  $Res call({String factor, double value, String description, String impact});
}

/// @nodoc
class _$FactorCopyWithImpl<$Res, $Val extends Factor>
    implements $FactorCopyWith<$Res> {
  _$FactorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Factor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? factor = null,
    Object? value = null,
    Object? description = null,
    Object? impact = null,
  }) {
    return _then(
      _value.copyWith(
            factor: null == factor
                ? _value.factor
                : factor // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            impact: null == impact
                ? _value.impact
                : impact // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FactorImplCopyWith<$Res> implements $FactorCopyWith<$Res> {
  factory _$$FactorImplCopyWith(
    _$FactorImpl value,
    $Res Function(_$FactorImpl) then,
  ) = __$$FactorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String factor, double value, String description, String impact});
}

/// @nodoc
class __$$FactorImplCopyWithImpl<$Res>
    extends _$FactorCopyWithImpl<$Res, _$FactorImpl>
    implements _$$FactorImplCopyWith<$Res> {
  __$$FactorImplCopyWithImpl(
    _$FactorImpl _value,
    $Res Function(_$FactorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Factor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? factor = null,
    Object? value = null,
    Object? description = null,
    Object? impact = null,
  }) {
    return _then(
      _$FactorImpl(
        factor: null == factor
            ? _value.factor
            : factor // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        impact: null == impact
            ? _value.impact
            : impact // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FactorImpl implements _Factor {
  const _$FactorImpl({
    required this.factor,
    required this.value,
    required this.description,
    required this.impact,
  });

  factory _$FactorImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactorImplFromJson(json);

  @override
  final String factor;
  @override
  final double value;
  @override
  final String description;
  @override
  final String impact;

  @override
  String toString() {
    return 'Factor(factor: $factor, value: $value, description: $description, impact: $impact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactorImpl &&
            (identical(other.factor, factor) || other.factor == factor) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.impact, impact) || other.impact == impact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, factor, value, description, impact);

  /// Create a copy of Factor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactorImplCopyWith<_$FactorImpl> get copyWith =>
      __$$FactorImplCopyWithImpl<_$FactorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FactorImplToJson(this);
  }
}

abstract class _Factor implements Factor {
  const factory _Factor({
    required final String factor,
    required final double value,
    required final String description,
    required final String impact,
  }) = _$FactorImpl;

  factory _Factor.fromJson(Map<String, dynamic> json) = _$FactorImpl.fromJson;

  @override
  String get factor;
  @override
  double get value;
  @override
  String get description;
  @override
  String get impact;

  /// Create a copy of Factor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactorImplCopyWith<_$FactorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
