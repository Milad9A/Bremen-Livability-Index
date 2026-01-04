// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livability_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LivabilityScoreImpl _$$LivabilityScoreImplFromJson(
  Map<String, dynamic> json,
) => _$LivabilityScoreImpl(
  score: (json['score'] as num).toDouble(),
  baseScore: (json['base_score'] as num).toDouble(),
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  factors: (json['factors'] as List<dynamic>)
      .map((e) => Factor.fromJson(e as Map<String, dynamic>))
      .toList(),
  nearbyFeatures: (json['nearby_features'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => FeatureDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  summary: json['summary'] as String,
);

Map<String, dynamic> _$$LivabilityScoreImplToJson(
  _$LivabilityScoreImpl instance,
) => <String, dynamic>{
  'score': instance.score,
  'base_score': instance.baseScore,
  'location': instance.location,
  'factors': instance.factors,
  'nearby_features': instance.nearbyFeatures,
  'summary': instance.summary,
};
