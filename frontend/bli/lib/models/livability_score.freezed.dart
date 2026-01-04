// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'livability_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LivabilityScore _$LivabilityScoreFromJson(Map<String, dynamic> json) {
  return _LivabilityScore.fromJson(json);
}

/// @nodoc
mixin _$LivabilityScore {
  double get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_score')
  double get baseScore => throw _privateConstructorUsedError;
  Location get location => throw _privateConstructorUsedError;
  List<Factor> get factors => throw _privateConstructorUsedError;
  @JsonKey(name: 'nearby_features')
  Map<FeatureType, List<FeatureDetail>> get nearbyFeatures =>
      throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;

  /// Serializes this LivabilityScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LivabilityScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LivabilityScoreCopyWith<LivabilityScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LivabilityScoreCopyWith<$Res> {
  factory $LivabilityScoreCopyWith(
    LivabilityScore value,
    $Res Function(LivabilityScore) then,
  ) = _$LivabilityScoreCopyWithImpl<$Res, LivabilityScore>;
  @useResult
  $Res call({
    double score,
    @JsonKey(name: 'base_score') double baseScore,
    Location location,
    List<Factor> factors,
    @JsonKey(name: 'nearby_features')
    Map<FeatureType, List<FeatureDetail>> nearbyFeatures,
    String summary,
  });

  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LivabilityScoreCopyWithImpl<$Res, $Val extends LivabilityScore>
    implements $LivabilityScoreCopyWith<$Res> {
  _$LivabilityScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LivabilityScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? baseScore = null,
    Object? location = null,
    Object? factors = null,
    Object? nearbyFeatures = null,
    Object? summary = null,
  }) {
    return _then(
      _value.copyWith(
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double,
            baseScore: null == baseScore
                ? _value.baseScore
                : baseScore // ignore: cast_nullable_to_non_nullable
                      as double,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as Location,
            factors: null == factors
                ? _value.factors
                : factors // ignore: cast_nullable_to_non_nullable
                      as List<Factor>,
            nearbyFeatures: null == nearbyFeatures
                ? _value.nearbyFeatures
                : nearbyFeatures // ignore: cast_nullable_to_non_nullable
                      as Map<FeatureType, List<FeatureDetail>>,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of LivabilityScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res> get location {
    return $LocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LivabilityScoreImplCopyWith<$Res>
    implements $LivabilityScoreCopyWith<$Res> {
  factory _$$LivabilityScoreImplCopyWith(
    _$LivabilityScoreImpl value,
    $Res Function(_$LivabilityScoreImpl) then,
  ) = __$$LivabilityScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double score,
    @JsonKey(name: 'base_score') double baseScore,
    Location location,
    List<Factor> factors,
    @JsonKey(name: 'nearby_features')
    Map<FeatureType, List<FeatureDetail>> nearbyFeatures,
    String summary,
  });

  @override
  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$LivabilityScoreImplCopyWithImpl<$Res>
    extends _$LivabilityScoreCopyWithImpl<$Res, _$LivabilityScoreImpl>
    implements _$$LivabilityScoreImplCopyWith<$Res> {
  __$$LivabilityScoreImplCopyWithImpl(
    _$LivabilityScoreImpl _value,
    $Res Function(_$LivabilityScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LivabilityScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? baseScore = null,
    Object? location = null,
    Object? factors = null,
    Object? nearbyFeatures = null,
    Object? summary = null,
  }) {
    return _then(
      _$LivabilityScoreImpl(
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        baseScore: null == baseScore
            ? _value.baseScore
            : baseScore // ignore: cast_nullable_to_non_nullable
                  as double,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as Location,
        factors: null == factors
            ? _value._factors
            : factors // ignore: cast_nullable_to_non_nullable
                  as List<Factor>,
        nearbyFeatures: null == nearbyFeatures
            ? _value._nearbyFeatures
            : nearbyFeatures // ignore: cast_nullable_to_non_nullable
                  as Map<FeatureType, List<FeatureDetail>>,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LivabilityScoreImpl extends _LivabilityScore {
  const _$LivabilityScoreImpl({
    required this.score,
    @JsonKey(name: 'base_score') required this.baseScore,
    required this.location,
    required final List<Factor> factors,
    @JsonKey(name: 'nearby_features')
    required final Map<FeatureType, List<FeatureDetail>> nearbyFeatures,
    required this.summary,
  }) : _factors = factors,
       _nearbyFeatures = nearbyFeatures,
       super._();

  factory _$LivabilityScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$LivabilityScoreImplFromJson(json);

  @override
  final double score;
  @override
  @JsonKey(name: 'base_score')
  final double baseScore;
  @override
  final Location location;
  final List<Factor> _factors;
  @override
  List<Factor> get factors {
    if (_factors is EqualUnmodifiableListView) return _factors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_factors);
  }

  final Map<FeatureType, List<FeatureDetail>> _nearbyFeatures;
  @override
  @JsonKey(name: 'nearby_features')
  Map<FeatureType, List<FeatureDetail>> get nearbyFeatures {
    if (_nearbyFeatures is EqualUnmodifiableMapView) return _nearbyFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nearbyFeatures);
  }

  @override
  final String summary;

  @override
  String toString() {
    return 'LivabilityScore(score: $score, baseScore: $baseScore, location: $location, factors: $factors, nearbyFeatures: $nearbyFeatures, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LivabilityScoreImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.baseScore, baseScore) ||
                other.baseScore == baseScore) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._factors, _factors) &&
            const DeepCollectionEquality().equals(
              other._nearbyFeatures,
              _nearbyFeatures,
            ) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    baseScore,
    location,
    const DeepCollectionEquality().hash(_factors),
    const DeepCollectionEquality().hash(_nearbyFeatures),
    summary,
  );

  /// Create a copy of LivabilityScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LivabilityScoreImplCopyWith<_$LivabilityScoreImpl> get copyWith =>
      __$$LivabilityScoreImplCopyWithImpl<_$LivabilityScoreImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LivabilityScoreImplToJson(this);
  }
}

abstract class _LivabilityScore extends LivabilityScore {
  const factory _LivabilityScore({
    required final double score,
    @JsonKey(name: 'base_score') required final double baseScore,
    required final Location location,
    required final List<Factor> factors,
    @JsonKey(name: 'nearby_features')
    required final Map<FeatureType, List<FeatureDetail>> nearbyFeatures,
    required final String summary,
  }) = _$LivabilityScoreImpl;
  const _LivabilityScore._() : super._();

  factory _LivabilityScore.fromJson(Map<String, dynamic> json) =
      _$LivabilityScoreImpl.fromJson;

  @override
  double get score;
  @override
  @JsonKey(name: 'base_score')
  double get baseScore;
  @override
  Location get location;
  @override
  List<Factor> get factors;
  @override
  @JsonKey(name: 'nearby_features')
  Map<FeatureType, List<FeatureDetail>> get nearbyFeatures;
  @override
  String get summary;

  /// Create a copy of LivabilityScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LivabilityScoreImplCopyWith<_$LivabilityScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
