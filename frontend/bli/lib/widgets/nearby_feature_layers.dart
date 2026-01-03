import 'package:bli/services/api_service.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NearbyFeatureLayers extends StatelessWidget {
  final Map<String, List<FeatureDetail>> nearbyFeatures;

  const NearbyFeatureLayers({super.key, required this.nearbyFeatures});

  @override
  Widget build(BuildContext context) {
    if (nearbyFeatures.isEmpty) return const SizedBox.shrink();

    List<Marker> markers = [];
    List<Polygon> polygons = [];
    List<Polyline> polylines = [];

    nearbyFeatures.forEach((type, features) {
      for (var feature in features) {
        // Parse geometry
        var geom = feature.geometry;
        var geomType = geom['type'];
        var coords = geom['coordinates'];

        Color color = _getColorForType(type);
        IconData icon = _getIconForType(type, subtype: feature.subtype);

        if (geomType == 'Point') {
          // Point coordinates: [lon, lat]
          markers.add(
            Marker(
              point: LatLng(
                (coords[1] as num).toDouble(),
                (coords[0] as num).toDouble(),
              ),
              width: 30,
              height: 30,
              child: Icon(icon, color: color, size: 20),
            ),
          );
        } else if (geomType == 'Polygon') {
          // Polygon coordinates: [[[lon, lat], ...], ...]
          List<dynamic> rings = coords;
          if (rings.isNotEmpty) {
            List<LatLng> points = (rings[0] as List)
                .map(
                  (p) => LatLng(
                    (p[1] as num).toDouble(),
                    (p[0] as num).toDouble(),
                  ),
                )
                .toList();
            polygons.add(
              Polygon(
                points: points,
                color: color.withValues(alpha: 0.3),
                borderColor: color,
                borderStrokeWidth: 2,
              ),
            );
          }
        } else if (geomType == 'LineString') {
          // LineString: [[lon, lat], ...]
          List<LatLng> points = (coords as List)
              .map(
                (p) =>
                    LatLng((p[1] as num).toDouble(), (p[0] as num).toDouble()),
              )
              .toList();
          polylines.add(Polyline(points: points, color: color, strokeWidth: 3));
        } else if (geomType == 'MultiPolygon') {
          // MultiPolygon: [[[[lon, lat]...]], ...]
          List<dynamic> polys = coords;
          for (var poly in polys) {
            List<dynamic> rings = poly;
            if (rings.isNotEmpty) {
              List<LatLng> points = (rings[0] as List)
                  .map(
                    (p) => LatLng(
                      (p[1] as num).toDouble(),
                      (p[0] as num).toDouble(),
                    ),
                  )
                  .toList();
              polygons.add(
                Polygon(
                  points: points,
                  color: color.withValues(alpha: 0.3),
                  borderColor: color,
                  borderStrokeWidth: 2,
                ),
              );
            }
          }
        }
      }
    });

    return Stack(
      children: [
        if (polygons.isNotEmpty) PolygonLayer(polygons: polygons),
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'trees':
      case 'tree':
        return Colors.green;
      case 'parks':
      case 'park':
        return Colors.lightGreen;
      case 'amenities':
      case 'amenity':
        return Colors.blue;
      case 'public_transport':
        return Colors.indigo;
      case 'healthcare':
        return Colors.red;
      case 'accidents':
      case 'accident':
        return Colors.orange;
      case 'industrial':
        return AppColors.greyMedium;
      case 'major_roads':
      case 'major_road':
        return AppColors.black.withValues(alpha: 0.54);
      case 'bike_infrastructure':
        return Colors.cyan;
      case 'education':
        return Colors.purple;
      case 'sports_leisure':
        return Colors.amber;
      case 'pedestrian_infrastructure':
        return Colors.lime;
      case 'cultural_venues':
      case 'cultural_venue':
        return Colors.pink;
      case 'noise_sources':
      case 'noise_source':
        return Colors.deepOrange;
      default:
        return AppColors.greyLight;
    }
  }

  IconData _getIconForType(String type, {String? subtype}) {
    switch (type) {
      case 'trees':
      case 'tree':
        return Icons.nature;
      case 'parks':
      case 'park':
        return Icons.park;
      case 'amenities':
      case 'amenity':
        if (subtype != null) {
          switch (subtype.toLowerCase()) {
            case 'restaurant':
            case 'cafe':
            case 'fast_food':
            case 'food_court':
            case 'ice_cream':
              return Icons.restaurant;
            case 'school':
            case 'kindergarten':
            case 'college':
            case 'university':
              return Icons.school;
            case 'pub':
            case 'bar':
            case 'nightclub':
              return Icons.local_bar;
            case 'parking':
            case 'parking_space':
              return Icons.local_parking;
            case 'bank':
            case 'atm':
              return Icons.account_balance;
            case 'pharmacy':
              return Icons.local_pharmacy;
            case 'hospital':
            case 'clinic':
            case 'doctors':
              return Icons.local_hospital;
            case 'cinema':
            case 'theatre':
            case 'arts_centre':
              return Icons.movie;
            case 'place_of_worship':
              return Icons.church;
            case 'library':
              return Icons.local_library;
            case 'post_office':
              return Icons.local_post_office;
          }
        }
        return Icons.store;
      case 'public_transport':
        if (subtype != null) {
          if (subtype.contains('bus')) return Icons.directions_bus;
          if (subtype.contains('tram')) return Icons.tram;
          if (subtype.contains('train')) return Icons.train;
        }
        return Icons.directions_bus;
      case 'healthcare':
        if (subtype != null) {
          if (subtype.contains('hospital')) return Icons.local_hospital;
          if (subtype.contains('pharmacy')) return Icons.local_pharmacy;
          if (subtype.contains('doctors') || subtype.contains('clinic')) {
            return Icons.medical_services;
          }
        }
        return Icons.local_hospital;
      case 'accidents':
      case 'accident':
        return Icons.warning;
      case 'industrial':
        return Icons.factory;
      case 'major_roads':
      case 'major_road':
        return Icons.add_road;
      case 'bike_infrastructure':
        if (subtype != null) {
          if (subtype.contains('parking')) return Icons.local_parking;
          if (subtype.contains('rental')) return Icons.pedal_bike;
        }
        return Icons.directions_bike;
      case 'education':
        if (subtype != null) {
          if (subtype.contains('university') || subtype.contains('college')) {
            return Icons.account_balance;
          }
          if (subtype.contains('kindergarten')) return Icons.child_care;
          if (subtype.contains('library')) return Icons.local_library;
        }
        return Icons.school;
      case 'sports_leisure':
        if (subtype != null) {
          if (subtype.contains('swimming')) return Icons.pool;
          if (subtype.contains('playground')) return Icons.toys;
          if (subtype.contains('fitness')) return Icons.fitness_center;
        }
        return Icons.sports_soccer;
      case 'pedestrian_infrastructure':
        if (subtype != null) {
          if (subtype.contains('crossing')) {
            return Icons.transfer_within_a_station;
          }
          if (subtype.contains('pedestrian')) return Icons.directions_walk;
          if (subtype.contains('footway')) return Icons.hiking;
        }
        return Icons.accessibility_new;
      case 'cultural_venues':
      case 'cultural_venue':
        if (subtype != null) {
          if (subtype.contains('museum')) return Icons.museum;
          if (subtype.contains('gallery')) return Icons.museum;
          if (subtype.contains('theatre')) return Icons.theater_comedy;
          if (subtype.contains('cinema')) return Icons.movie;
          if (subtype.contains('artwork')) return Icons.brush;
          if (subtype.contains('arts_centre')) return Icons.palette;
          if (subtype.contains('community_centre')) return Icons.groups;
        }
        return Icons.location_city;
      case 'noise_sources':
      case 'noise_source':
        if (subtype != null) {
          if (subtype.contains('nightclub')) return Icons.nightlife;
          if (subtype.contains('bar') || subtype.contains('pub')) {
            return Icons.local_bar;
          }
          if (subtype.contains('fast_food')) return Icons.fastfood;
          if (subtype.contains('car_repair')) return Icons.car_repair;
        }
        return Icons.volume_up;
      default:
        return Icons.place;
    }
  }
}
