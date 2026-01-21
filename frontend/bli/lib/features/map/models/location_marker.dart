import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'location_marker.freezed.dart';

@freezed
class LocationMarker with _$LocationMarker {
  const factory LocationMarker({
    required LatLng position,
    double? score,
    String? address,
    DateTime? timestamp,
  }) = _LocationMarker;

  factory LocationMarker.now({
    required LatLng position,
    double? score,
    String? address,
  }) => LocationMarker(
    position: position,
    score: score,
    address: address,
    timestamp: DateTime.now(),
  );
}
