import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:bli/features/map/models/enums.dart';

part 'factor.freezed.dart';
part 'factor.g.dart';

/// Represents a scoring factor with its value and impact.
@freezed
class Factor with _$Factor {
  const factory Factor({
    @JsonKey(unknownEnumValue: MetricCategory.unknown)
    required MetricCategory factor,
    required double value,
    required String description,
    required String impact,
  }) = _Factor;

  factory Factor.fromJson(Map<String, dynamic> json) => _$FactorFromJson(json);
}
