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
      $enumDecode(_$FeatureTypeEnumMap, k),
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
  'nearby_features': instance.nearbyFeatures.map(
    (k, e) => MapEntry(_$FeatureTypeEnumMap[k]!, e),
  ),
  'summary': instance.summary,
};

const _$FeatureTypeEnumMap = {
  FeatureType.tree: 'tree',
  FeatureType.park: 'park',
  FeatureType.amenity: 'amenity',
  FeatureType.publicTransport: 'public_transport',
  FeatureType.healthcare: 'healthcare',
  FeatureType.education: 'education',
  FeatureType.sportsLeisure: 'sports_leisure',
  FeatureType.culturalVenue: 'cultural_venue',
  FeatureType.noiseSource: 'noise_source',
  FeatureType.accident: 'accident',
  FeatureType.industrial: 'industrial',
  FeatureType.majorRoad: 'major_road',
  FeatureType.railway: 'railway',
  FeatureType.airport: 'airport',
  FeatureType.constructionSite: 'construction_site',
  FeatureType.parkingLot: 'parking_lot',
  FeatureType.powerInfrastructure: 'power_infrastructure',
  FeatureType.wasteFacility: 'waste_facility',
  FeatureType.gasStation: 'gas_station',
  FeatureType.bikeInfrastructure: 'bike_infrastructure',
  FeatureType.pedestrianInfrastructure: 'pedestrian_infrastructure',
};
