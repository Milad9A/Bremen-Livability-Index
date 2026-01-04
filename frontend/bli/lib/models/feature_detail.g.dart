// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureDetailImpl _$$FeatureDetailImplFromJson(Map<String, dynamic> json) =>
    _$FeatureDetailImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: $enumDecode(_$FeatureTypeEnumMap, json['type']),
      subtype: json['subtype'] as String?,
      distance: (json['distance'] as num).toDouble(),
      geometry: json['geometry'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$FeatureDetailImplToJson(_$FeatureDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$FeatureTypeEnumMap[instance.type]!,
      'subtype': instance.subtype,
      'distance': instance.distance,
      'geometry': instance.geometry,
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
