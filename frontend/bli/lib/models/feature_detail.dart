import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_detail.freezed.dart';
part 'feature_detail.g.dart';

/// Represents a nearby feature with geometry for map display.
@freezed
class FeatureDetail with _$FeatureDetail {
  const factory FeatureDetail({
    int? id,
    String? name,
    required String type,
    String? subtype,
    required double distance,
    required Map<String, dynamic> geometry,
  }) = _FeatureDetail;

  factory FeatureDetail.fromJson(Map<String, dynamic> json) =>
      _$FeatureDetailFromJson(json);
}
