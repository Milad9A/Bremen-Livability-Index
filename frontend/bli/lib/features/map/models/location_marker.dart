import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'location_marker.freezed.dart';

/// Represents a marker on the map with optional score.
@freezed
class LocationMarker with _$LocationMarker {
  const factory LocationMarker({
    required LatLng position,
    double? score,
    DateTime? timestamp,
  }) = _LocationMarker;

  /// Factory with default timestamp
  factory LocationMarker.now({required LatLng position, double? score}) =>
      LocationMarker(
        position: position,
        score: score,
        timestamp: DateTime.now(),
      );
}
