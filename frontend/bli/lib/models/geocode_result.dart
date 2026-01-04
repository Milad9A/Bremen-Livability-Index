import 'package:freezed_annotation/freezed_annotation.dart';

part 'geocode_result.freezed.dart';
part 'geocode_result.g.dart';

/// Represents a geocoding result from address search.
@freezed
class GeocodeResult with _$GeocodeResult {
  const factory GeocodeResult({
    required double latitude,
    required double longitude,
    @JsonKey(name: 'display_name') required String displayName,
    required Map<String, dynamic> address,
    required String type,
    required double importance,
  }) = _GeocodeResult;

  factory GeocodeResult.fromJson(Map<String, dynamic> json) =>
      _$GeocodeResultFromJson(json);
}
