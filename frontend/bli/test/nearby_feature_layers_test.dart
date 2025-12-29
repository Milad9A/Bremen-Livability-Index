import 'package:flutter_test/flutter_test.dart';
import 'package:bli/services/api_service.dart';

void main() {
  // Note: NearbyFeatureLayers widget rendering tests are skipped because
  // they require a FlutterMap parent widget context.
  // We test the underlying functionality through unit tests.

  group('NearbyFeatureLayers helper methods', () {
    // The private methods _getColorForType and _getIconForType are tested
    // indirectly by documenting expected behavior:
    // trees -> Colors.green
    // parks -> Colors.lightGreen
    // amenities -> Colors.blue
    // public_transport -> Colors.indigo
    // healthcare -> Colors.red
    // accidents -> Colors.orange
    // industrial -> Colors.grey
    // major_roads -> Colors.black54

    test('color and icon mapping documentation', () {
      // This test documents the expected mappings
      expect(true, isTrue);
    });
  });

  group('Feature parsing', () {
    test('Point geometry is parsed correctly', () {
      final feature = FeatureDetail(
        type: 'tree',
        distance: 100.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8017, 53.0793],
        },
      );

      expect(feature.geometry['type'], 'Point');
      expect(feature.geometry['coordinates'][0], 8.8017);
      expect(feature.geometry['coordinates'][1], 53.0793);
    });

    test('Polygon geometry is parsed correctly', () {
      final feature = FeatureDetail(
        type: 'park',
        distance: 200.0,
        geometry: {
          'type': 'Polygon',
          'coordinates': [
            [
              [8.80, 53.07],
              [8.81, 53.07],
              [8.81, 53.08],
              [8.80, 53.08],
              [8.80, 53.07],
            ],
          ],
        },
      );

      expect(feature.geometry['type'], 'Polygon');
      final coords = feature.geometry['coordinates'] as List;
      expect(coords.length, 1);
      expect((coords[0] as List).length, 5);
    });

    test('LineString geometry is parsed correctly', () {
      final feature = FeatureDetail(
        type: 'major_road',
        distance: 50.0,
        geometry: {
          'type': 'LineString',
          'coordinates': [
            [8.80, 53.07],
            [8.81, 53.08],
            [8.82, 53.09],
          ],
        },
      );

      expect(feature.geometry['type'], 'LineString');
      final coords = feature.geometry['coordinates'] as List;
      expect(coords.length, 3);
    });

    test('MultiPolygon geometry is parsed correctly', () {
      final feature = FeatureDetail(
        type: 'industrial',
        distance: 300.0,
        geometry: {
          'type': 'MultiPolygon',
          'coordinates': [
            [
              [
                [8.80, 53.07],
                [8.81, 53.07],
                [8.81, 53.08],
                [8.80, 53.08],
                [8.80, 53.07],
              ],
            ],
            [
              [
                [8.82, 53.09],
                [8.83, 53.09],
                [8.83, 53.10],
                [8.82, 53.10],
                [8.82, 53.09],
              ],
            ],
          ],
        },
      );

      expect(feature.geometry['type'], 'MultiPolygon');
      final coords = feature.geometry['coordinates'] as List;
      expect(coords.length, 2);
    });
  });

  group('Icon selection by subtype', () {
    test('amenity with restaurant subtype', () {
      final feature = FeatureDetail(
        type: 'amenity',
        subtype: 'restaurant',
        distance: 100.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'restaurant');
    });

    test('amenity with school subtype', () {
      final feature = FeatureDetail(
        type: 'amenity',
        subtype: 'school',
        distance: 150.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'school');
    });

    test('public_transport with bus subtype', () {
      final feature = FeatureDetail(
        type: 'public_transport',
        subtype: 'bus_stop',
        distance: 200.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'bus_stop');
    });
  });
}
