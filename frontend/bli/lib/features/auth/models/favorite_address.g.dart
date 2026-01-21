// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteAddressImpl _$$FavoriteAddressImplFromJson(
  Map<String, dynamic> json,
) => _$FavoriteAddressImpl(
  id: json['id'] as String,
  label: json['label'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$FavoriteAddressImplToJson(
  _$FavoriteAddressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'createdAt': instance.createdAt.toIso8601String(),
};
