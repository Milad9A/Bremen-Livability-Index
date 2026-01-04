// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactorImpl _$$FactorImplFromJson(Map<String, dynamic> json) => _$FactorImpl(
  factor: json['factor'] as String,
  value: (json['value'] as num).toDouble(),
  description: json['description'] as String,
  impact: json['impact'] as String,
);

Map<String, dynamic> _$$FactorImplToJson(_$FactorImpl instance) =>
    <String, dynamic>{
      'factor': instance.factor,
      'value': instance.value,
      'description': instance.description,
      'impact': instance.impact,
    };
