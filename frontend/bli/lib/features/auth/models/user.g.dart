// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['id'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      provider: $enumDecode(_$AppAuthProviderEnumMap, json['provider']),
      isAnonymous: json['isAnonymous'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'provider': _$AppAuthProviderEnumMap[instance.provider]!,
      'isAnonymous': instance.isAnonymous,
    };

const _$AppAuthProviderEnumMap = {
  AppAuthProvider.google: 'google',
  AppAuthProvider.github: 'github',
  AppAuthProvider.email: 'email',
  AppAuthProvider.guest: 'guest',
};
