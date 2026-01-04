import 'dart:convert';
import 'package:bli/features/map/models/livability_score.dart';
import 'package:bli/features/map/models/location.dart';
import 'package:bli/features/map/models/factor.dart';
import 'package:bli/features/map/models/feature_detail.dart';
import 'package:bli/features/map/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LivabilityScore', () {
    final score = LivabilityScore(
      score: 85.0,
      baseScore: 50.0,
      summary: "Excellent",
      location: const Location(latitude: 53.0, longitude: 8.8),
      factors: [
        const Factor(
          factor: MetricCategory.greenery,
          value: 0.8,
          description: 'High greenery',
          impact: 'Positive',
        ),
      ],
      nearbyFeatures: {
        'park': [
          FeatureDetail(
            name: 'Central Park',
            distance: 100,
            type: FeatureType.park,
            geometry: {
              'type': 'Point',
              'coordinates': [8.8, 53.0],
            },
          ),
        ],
      },
    );

    test('supports value equality', () {
      expect(
        score,
        equals(
          LivabilityScore(
            score: 85.0,
            baseScore: 50.0,
            summary: "Excellent",
            location: const Location(latitude: 53.0, longitude: 8.8),
            factors: [
              const Factor(
                factor: MetricCategory.greenery,
                value: 0.8,
                description: 'High greenery',
                impact: 'Positive',
              ),
            ],
            nearbyFeatures: {
              'park': [
                FeatureDetail(
                  name: 'Central Park',
                  distance: 100,
                  type: FeatureType.park,
                  geometry: {
                    'type': 'Point',
                    'coordinates': [8.8, 53.0],
                  },
                ),
              ],
            },
          ),
        ),
      );
    });

    test('scoreColor returns correct color hex', () {
      const high = LivabilityScore(
        score: 80.0,
        baseScore: 50.0,
        summary: "",
        location: Location(latitude: 0, longitude: 0),
        factors: [],
        nearbyFeatures: {},
      );
      expect(high.scoreColor, '#4CAF50');

      const medium = LivabilityScore(
        score: 60.0,
        baseScore: 50.0,
        summary: "",
        location: Location(latitude: 0, longitude: 0),
        factors: [],
        nearbyFeatures: {},
      );
      expect(medium.scoreColor, '#FF9800');

      const low = LivabilityScore(
        score: 40.0,
        baseScore: 50.0,
        summary: "",
        location: Location(latitude: 0, longitude: 0),
        factors: [],
        nearbyFeatures: {},
      );
      expect(low.scoreColor, '#F44336');
    });

    test('toJson', () {
      final json = score.toJson();
      expect(json['score'], 85.0);
      expect(json['base_score'], 50.0);
      expect(json['summary'], 'Excellent');
    });

    test('fromJson', () {
      final json = score.toJson();
      // Ensure nested objects are converted to proper definition for fromJson
      // by doing a decode/encode round trip, as toJson() might return object instances
      // for nested fields if explicitToJson is false.
      final jsonMap = jsonDecode(jsonEncode(json));
      expect(LivabilityScore.fromJson(jsonMap), score);
    });
  });
}
