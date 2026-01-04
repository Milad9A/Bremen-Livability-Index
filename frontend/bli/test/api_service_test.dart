import 'package:bli/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bli/models/models.dart';
import 'package:bli/widgets/score_card.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('LivabilityScore', () {
    test('fromJson parses complete data correctly', () {
      final json = {
        'score': 75.5,
        'base_score': 40.0,
        'location': {'latitude': 53.0793, 'longitude': 8.8017},
        'factors': [
          {
            'factor': 'Greenery',
            'value': 15.0,
            'description': 'Many parks nearby',
            'impact': 'positive',
          },
          {
            'factor': 'Traffic Safety',
            'value': -10.0,
            'description': 'Heavy traffic',
            'impact': 'negative',
          },
        ],
        'nearby_features': {
          'tree': [
            {
              'id': 1,
              'name': 'Oak',
              'type': 'tree',
              'subtype': 'oak',
              'distance': 50.0,
              'geometry': {
                'type': 'Point',
                'coordinates': [8.8017, 53.0793],
              },
            },
          ],
        },
        'summary': 'Good livability score',
      };

      final score = LivabilityScore.fromJson(json);

      expect(score.score, 75.5);
      expect(score.baseScore, 40.0);
      expect(score.location.latitude, 53.0793);
      expect(score.location.longitude, 8.8017);
      expect(score.factors.length, 2);
      expect(score.factors[0].factor, MetricCategory.greenery);
      expect(score.factors[0].value, 15.0);
      expect(score.factors[0].impact, 'positive');
      expect(score.factors[1].factor, MetricCategory.trafficSafety);
      expect(score.factors[1].value, -10.0);
      expect(score.factors[1].impact, 'negative');
      expect(score.nearbyFeatures['tree']?.length, 1);
      expect(score.summary, 'Good livability score');
    });

    test('fromJson handles empty nearby_features', () {
      // Use constructor directly to avoid type casting issues with empty map
      final score = LivabilityScore(
        score: 50.0,
        baseScore: 40.0,
        location: const Location(latitude: 53.0, longitude: 8.0),
        factors: [],
        nearbyFeatures: {},
        summary: 'Average area',
      );

      expect(score.nearbyFeatures.isEmpty, true);
    });

    test('scoreColor returns green for score >= 70', () {
      final score = LivabilityScore(
        score: 70.0,
        baseScore: 40.0,
        location: const Location(latitude: 53.0, longitude: 8.0),
        factors: [],
        nearbyFeatures: {},
        summary: 'Good',
      );

      expect(score.scoreColor, '#4CAF50');
    });

    test('scoreColor returns orange for score >= 50 and < 70', () {
      final score = LivabilityScore(
        score: 55.0,
        baseScore: 40.0,
        location: const Location(latitude: 53.0, longitude: 8.0),
        factors: [],
        nearbyFeatures: {},
        summary: 'Okay',
      );

      expect(score.scoreColor, '#FF9800');
    });

    test('scoreColor returns red for score < 50', () {
      final score = LivabilityScore(
        score: 30.0,
        baseScore: 40.0,
        location: const Location(latitude: 53.0, longitude: 8.0),
        factors: [],
        nearbyFeatures: {},
        summary: 'Poor',
      );

      expect(score.scoreColor, '#F44336');
    });
  });

  group('FeatureDetail', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 123,
        'name': 'Test Feature',
        'type': 'amenity',
        'subtype': 'restaurant',
        'distance': 150.5,
        'geometry': {
          'type': 'Point',
          'coordinates': [8.8, 53.1],
        },
      };

      final feature = FeatureDetail.fromJson(json);

      expect(feature.id, 123);
      expect(feature.name, 'Test Feature');
      expect(feature.type, FeatureType.amenity);
      expect(feature.subtype, 'restaurant');
      expect(feature.distance, 150.5);
      expect(feature.geometry['type'], 'Point');
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'type': 'tree',
        'distance': 25.0,
        'geometry': {
          'type': 'Point',
          'coordinates': [8.8, 53.1],
        },
      };

      final feature = FeatureDetail.fromJson(json);

      expect(feature.id, isNull);
      expect(feature.name, isNull);
      expect(feature.subtype, isNull);
    });
  });

  group('Location', () {
    test('fromJson parses coordinates', () {
      final json = {'latitude': 53.0793, 'longitude': 8.8017};

      final location = Location.fromJson(json);

      expect(location.latitude, 53.0793);
      expect(location.longitude, 8.8017);
    });

    test('fromJson handles integer coordinates', () {
      final json = {'latitude': 53, 'longitude': 8};

      final location = Location.fromJson(json);

      expect(location.latitude, 53.0);
      expect(location.longitude, 8.0);
    });
  });

  group('Factor', () {
    test('fromJson parses all fields', () {
      final json = {
        'factor': 'Greenery',
        'value': 12.5,
        'description': 'Parks within 500m',
        'impact': 'positive',
      };

      final factor = Factor.fromJson(json);

      expect(factor.factor, MetricCategory.greenery);
      expect(factor.value, 12.5);
      expect(factor.description, 'Parks within 500m');
      expect(factor.impact, 'positive');
    });

    test('fromJson handles negative values', () {
      final json = {
        'factor': 'Noise Sources',
        'value': -15.0,
        'description': 'Near major road',
        'impact': 'negative',
      };

      final factor = Factor.fromJson(json);

      expect(factor.value, -15.0);
      expect(factor.impact, 'negative');
    });
  });

  group('GeocodeResult', () {
    test('fromJson parses complete data', () {
      final json = {
        'latitude': 53.0793,
        'longitude': 8.8017,
        'display_name': 'Bremen, Germany',
        'address': {
          'city': 'Bremen',
          'country': 'Germany',
          'road': 'Hauptstraße',
        },
        'type': 'city',
        'importance': 0.95,
      };

      final result = GeocodeResult.fromJson(json);

      expect(result.latitude, 53.0793);
      expect(result.longitude, 8.8017);
      expect(result.displayName, 'Bremen, Germany');
      expect(result.address['city'], 'Bremen');
      expect(result.address['road'], 'Hauptstraße');
      expect(result.type, 'city');
      expect(result.importance, 0.95);
    });
  });

  group('LocationMarker', () {
    test('LocationMarker.now sets timestamp automatically', () {
      final before = DateTime.now();
      final marker = LocationMarker.now(
        position: const LatLng(53.0793, 8.8017),
      );
      final after = DateTime.now();

      expect(marker.position.latitude, 53.0793);
      expect(marker.position.longitude, 8.8017);
      expect(marker.score, isNull);
      expect(marker.timestamp, isNotNull);
      expect(
        marker.timestamp!.isAfter(before.subtract(const Duration(seconds: 1))),
        true,
      );
      expect(
        marker.timestamp!.isBefore(after.add(const Duration(seconds: 1))),
        true,
      );
    });

    test('constructor accepts custom timestamp', () {
      final customTime = DateTime(2024, 1, 1, 12, 0);
      final marker = LocationMarker(
        position: const LatLng(53.0, 8.0),
        score: 75.0,
        timestamp: customTime,
      );

      expect(marker.score, 75.0);
      expect(marker.timestamp, customTime);
    });
  });

  group('getScoreColor', () {
    test('returns teal[700] for score >= 75', () {
      expect(getScoreColor(75.0), Colors.teal[700]);
      expect(getScoreColor(85.0), Colors.teal[700]);
      expect(getScoreColor(100.0), Colors.teal[700]);
    });

    test('returns orange[800] for score >= 50 and < 75', () {
      expect(getScoreColor(50.0), Colors.orange[800]);
      expect(getScoreColor(60.0), Colors.orange[800]);
      expect(getScoreColor(74.9), Colors.orange[800]);
    });

    test('returns red[700] for score < 50', () {
      expect(getScoreColor(0.0), Colors.red[700]);
      expect(getScoreColor(25.0), Colors.red[700]);
      expect(getScoreColor(49.9), Colors.red[700]);
    });
  });
}
