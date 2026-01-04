import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:bli/models/enums.dart';
import 'package:bli/models/factor.dart';
import 'package:bli/models/feature_detail.dart';
import 'package:bli/models/location.dart';

part 'livability_score.freezed.dart';
part 'livability_score.g.dart';

/// Represents the complete livability score response from the API.
@freezed
class LivabilityScore with _$LivabilityScore {
  const LivabilityScore._();

  const factory LivabilityScore({
    required double score,
    @JsonKey(name: 'base_score') required double baseScore,
    required Location location,
    required List<Factor> factors,
    @JsonKey(name: 'nearby_features')
    required Map<FeatureType, List<FeatureDetail>> nearbyFeatures,
    required String summary,
  }) = _LivabilityScore;

  factory LivabilityScore.fromJson(Map<String, dynamic> json) =>
      _$LivabilityScoreFromJson(json);

  /// Get color based on score
  String get scoreColor {
    if (score >= 70) return '#4CAF50'; // Green
    if (score >= 50) return '#FF9800'; // Orange
    return '#F44336'; // Red
  }
}
