import 'package:bli/models/models.dart';
import 'package:bli/utils/feature_styles.dart';
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

    nearbyFeatures.forEach((key, features) {
      for (var feature in features) {
        // Parse geometry
        var geom = feature.geometry;
        var geomType = geom['type'];
        var coords = geom['coordinates'];

        Color color = FeatureStyles.getFeatureColor(feature.type);
        IconData icon = FeatureStyles.getFeatureIcon(
          feature.type,
          subtype: feature.subtype,
        );

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
}
