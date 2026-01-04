// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocode_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeocodeResultImpl _$$GeocodeResultImplFromJson(Map<String, dynamic> json) =>
    _$GeocodeResultImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      displayName: json['display_name'] as String,
      address: json['address'] as Map<String, dynamic>,
      type: json['type'] as String,
      importance: (json['importance'] as num).toDouble(),
    );

Map<String, dynamic> _$$GeocodeResultImplToJson(_$GeocodeResultImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'display_name': instance.displayName,
      'address': instance.address,
      'type': instance.type,
      'importance': instance.importance,
    };
