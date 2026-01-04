// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureDetailImpl _$$FeatureDetailImplFromJson(Map<String, dynamic> json) =>
    _$FeatureDetailImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['type'] as String,
      subtype: json['subtype'] as String?,
      distance: (json['distance'] as num).toDouble(),
      geometry: json['geometry'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$FeatureDetailImplToJson(_$FeatureDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'subtype': instance.subtype,
      'distance': instance.distance,
      'geometry': instance.geometry,
    };
