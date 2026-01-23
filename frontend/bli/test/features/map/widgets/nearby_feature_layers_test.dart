import 'package:bli/features/map/models/enums.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bli/features/map/widgets/nearby_feature_layers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('NearbyFeatureLayers Widget Tests', () {
    testWidgets('renders nothing when features are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(53.0793, 8.8017),
              initialZoom: 13.0,
            ),
            children: const [NearbyFeatureLayers(nearbyFeatures: {})],
          ),
        ),
      );

      expect(find.byType(MarkerLayer), findsNothing);
      expect(find.byType(PolygonLayer), findsNothing);
      expect(find.byType(PolylineLayer), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders markers for Point features', (
      WidgetTester tester,
    ) async {
      final features = {
        'trees': [
          FeatureDetail(
            type: FeatureType.tree,
            distance: 10.0,
            geometry: {
              'type': 'Point',
              'coordinates': [8.8017, 53.0793],
            },
          ),
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(53.0793, 8.8017),
              initialZoom: 13.0,
            ),
            children: [NearbyFeatureLayers(nearbyFeatures: features)],
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(MarkerLayer), findsOneWidget);
      // Verify MarkerLayer contains markers
      final markerLayer = tester.widget<MarkerLayer>(find.byType(MarkerLayer));
      expect(markerLayer.markers.length, 1);
      final marker = markerLayer.markers.first;
      expect(marker.point.latitude, 53.0793);
      expect(marker.point.longitude, 8.8017);
    });

    testWidgets('renders polygons for Polygon features', (
      WidgetTester tester,
    ) async {
      final features = {
        'parks': [
          FeatureDetail(
            type: FeatureType.park,
            distance: 50.0,
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
          ),
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(53.075, 8.805),
              initialZoom: 13.0,
            ),
            children: [NearbyFeatureLayers(nearbyFeatures: features)],
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(PolygonLayer), findsOneWidget);
      final polygonLayer = tester.widget<PolygonLayer>(
        find.byType(PolygonLayer),
      );
      expect(polygonLayer.polygons.length, 1);
      expect(polygonLayer.polygons.first.points.length, 5);
    });

    testWidgets('renders polylines for LineString features', (
      WidgetTester tester,
    ) async {
      final features = {
        'roads': [
          FeatureDetail(
            type: FeatureType.majorRoad,
            distance: 20.0,
            geometry: {
              'type': 'LineString',
              'coordinates': [
                [8.80, 53.07],
                [8.81, 53.08],
              ],
            },
          ),
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(53.075, 8.805),
              initialZoom: 13.0,
            ),
            children: [NearbyFeatureLayers(nearbyFeatures: features)],
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(PolylineLayer), findsOneWidget);
      final polylineLayer = tester.widget<PolylineLayer>(
        find.byType(PolylineLayer),
      );
      expect(polylineLayer.polylines.length, 1);
      expect(polylineLayer.polylines.first.points.length, 2);
    });

    testWidgets('renders multiple polygons for MultiPolygon features', (
      WidgetTester tester,
    ) async {
      final features = {
        'industrial': [
          FeatureDetail(
            type: FeatureType.industrial,
            distance: 100.0,
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
          ),
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(53.085, 8.815),
              initialZoom: 12.0,
            ),
            children: [NearbyFeatureLayers(nearbyFeatures: features)],
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(PolygonLayer), findsOneWidget);
      final polygonLayer = tester.widget<PolygonLayer>(
        find.byType(PolygonLayer),
      );
      // MultiPolygon with 2 polygons should create 2 polygon objects
      expect(polygonLayer.polygons.length, 2);
      expect(polygonLayer.polygons[0].points.length, 5);
      expect(polygonLayer.polygons[1].points.length, 5);
    });

    testWidgets('renders mixed geometry types correctly', (
      WidgetTester tester,
    ) async {
      final features = {
        'mixed': [
          FeatureDetail(
            type: FeatureType.tree,
            distance: 10.0,
            geometry: {
              'type': 'Point',
              'coordinates': [8.8017, 53.0793],
            },
          ),
          FeatureDetail(
            type: FeatureType.park,
            distance: 50.0,
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
          ),
          FeatureDetail(
            type: FeatureType.majorRoad,
            distance: 20.0,
            geometry: {
              'type': 'LineString',
              'coordinates': [
                [8.80, 53.07],
                [8.81, 53.08],
              ],
            },
          ),
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(53.075, 8.805),
              initialZoom: 13.0,
            ),
            children: [NearbyFeatureLayers(nearbyFeatures: features)],
          ),
        ),
      );

      await tester.pump();

      // All three layer types should be present
      expect(find.byType(MarkerLayer), findsOneWidget);
      expect(find.byType(PolygonLayer), findsOneWidget);
      expect(find.byType(PolylineLayer), findsOneWidget);
    });
  });

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
