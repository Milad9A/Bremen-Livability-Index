// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactorImpl _$$FactorImplFromJson(Map<String, dynamic> json) => _$FactorImpl(
  factor: $enumDecode(
    _$MetricCategoryEnumMap,
    json['factor'],
    unknownValue: MetricCategory.unknown,
  ),
  value: (json['value'] as num).toDouble(),
  description: json['description'] as String,
  impact: json['impact'] as String,
);

Map<String, dynamic> _$$FactorImplToJson(_$FactorImpl instance) =>
    <String, dynamic>{
      'factor': _$MetricCategoryEnumMap[instance.factor]!,
      'value': instance.value,
      'description': instance.description,
      'impact': instance.impact,
    };

const _$MetricCategoryEnumMap = {
  MetricCategory.greenery: 'Greenery',
  MetricCategory.amenities: 'Amenities',
  MetricCategory.publicTransport: 'Public Transport',
  MetricCategory.healthcare: 'Healthcare',
  MetricCategory.education: 'Education',
  MetricCategory.sportsLeisure: 'Sports & Leisure',
  MetricCategory.culturalVenues: 'Cultural Venues',
  MetricCategory.trafficSafety: 'Traffic Safety',
  MetricCategory.industrialArea: 'Industrial Area',
  MetricCategory.majorRoad: 'Major Road',
  MetricCategory.noiseSources: 'Noise Sources',
  MetricCategory.bikeInfrastructure: 'Bike Infrastructure',
  MetricCategory.pedestrianInfrastructure: 'Pedestrian Infrastructure',
  MetricCategory.railway: 'Railway',
  MetricCategory.gasStation: 'Gas Station',
  MetricCategory.wasteFacility: 'Waste Facility',
  MetricCategory.powerInfrastructure: 'Power Infrastructure',
  MetricCategory.largeParking: 'Large Parking',
  MetricCategory.airport: 'Airport/Helipad',
  MetricCategory.constructionSite: 'Construction Site',
  MetricCategory.unknown: 'Unknown',
};
