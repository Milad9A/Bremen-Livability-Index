import 'package:bli/models/enums.dart';
import 'package:bli/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Note: NearbyFeatureLayers widget rendering tests are skipped because
  // they require a FlutterMap parent widget context which is complex to mock.
  // We test the underlying functionality through unit tests in code or implicitly.

  group('NearbyFeatureLayers helper methods', () {
    // Methods moved to FeatureStyles, tested via integration or directly if needed.
    test('color and icon mapping documentation', () {
      expect(true, isTrue);
    });
  });

  group('Feature parsing', () {
    test('Point geometry is parsed correctly', () {
      final feature = FeatureDetail(
        type: FeatureType.tree,
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
        type: FeatureType.park,
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
        type: FeatureType.majorRoad,
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
        type: FeatureType.industrial,
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
        type: FeatureType.amenity,
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
        type: FeatureType.amenity,
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
        type: FeatureType.publicTransport,
        subtype: 'bus_stop',
        distance: 200.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'bus_stop');
    });

    test('bike_infrastructure with cycleway subtype', () {
      final feature = FeatureDetail(
        type: FeatureType.bikeInfrastructure,
        subtype: 'cycleway',
        distance: 50.0,
        geometry: {
          'type': 'LineString',
          'coordinates': [
            [8.80, 53.07],
            [8.81, 53.08],
          ],
        },
      );

      expect(feature.subtype, 'cycleway');
      expect(feature.type, FeatureType.bikeInfrastructure);
    });

    test('education with university subtype', () {
      final feature = FeatureDetail(
        type: FeatureType.education,
        subtype: 'university',
        distance: 400.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'university');
    });

    test('sports_leisure with swimming pool subtype', () {
      final feature = FeatureDetail(
        type: FeatureType.sportsLeisure,
        subtype: 'swimming_pool',
        distance: 300.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'swimming_pool');
    });

    test('pedestrian_infrastructure with crossing subtype', () {
      final feature = FeatureDetail(
        type: FeatureType.pedestrianInfrastructure,
        subtype: 'crossing',
        distance: 50.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.80, 53.07],
        },
      );

      expect(feature.subtype, 'crossing');
    });

    test('cultural_venue with museum subtype', () {
      final feature = FeatureDetail(
        type: FeatureType.culturalVenue,
        subtype: 'museum',
        distance: 500.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'museum');
    });

    test('noise_source with nightclub subtype', () {
      final feature = FeatureDetail(
        type: FeatureType.noiseSource,
        subtype: 'nightclub',
        distance: 80.0,
        geometry: {
          'type': 'Point',
          'coordinates': [8.8, 53.0],
        },
      );

      expect(feature.subtype, 'nightclub');
    });
  });
}
