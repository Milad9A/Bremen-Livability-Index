import 'package:latlong2/latlong.dart';

class LocationMarker {
  final LatLng position;
  final double? score;
  final DateTime timestamp;
  
  LocationMarker({
    required this.position,
    this.score,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

