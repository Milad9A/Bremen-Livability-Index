import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/core/utils/feature_styles.dart';
import 'package:bli/features/map/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureStyles', () {
    group('getFactorColor', () {
      test('returns correct color for greenery', () {
        expect(
          FeatureStyles.getFactorColor(MetricCategory.greenery),
          Colors.green,
        );
      });

      test('returns correct color for industrial area', () {
        expect(
          FeatureStyles.getFactorColor(MetricCategory.industrialArea),
          AppColors.greyMedium,
        );
      });

      test('returns correct color for unknown', () {
        expect(
          FeatureStyles.getFactorColor(MetricCategory.unknown),
          AppColors.greyLight,
        );
      });
    });

    group('getFactorIcon', () {
      test('returns correct icon for greenery', () {
        expect(
          FeatureStyles.getFactorIcon(MetricCategory.greenery),
          Icons.nature,
        );
      });

      test('returns correct icon for healthcare', () {
        expect(
          FeatureStyles.getFactorIcon(MetricCategory.healthcare),
          Icons.local_hospital,
        );
      });
    });

    group('getFeatureColor', () {
      test('returns correct color for park', () {
        expect(FeatureStyles.getFeatureColor(FeatureType.park), Colors.green);
      });

      test('returns correct color for major road', () {
        expect(
          FeatureStyles.getFeatureColor(FeatureType.majorRoad).value,
          AppColors.black.withValues(alpha: 0.54).value,
        );
      });
    });

    group('getFeatureIcon', () {
      test('returns specific icon for restaurant subtype', () {
        expect(
          FeatureStyles.getFeatureIcon(
            FeatureType.amenity,
            subtype: 'restaurant',
          ),
          Icons.restaurant,
        );
      });

      test('returns specific icon for bus stop subtype', () {
        expect(
          FeatureStyles.getFeatureIcon(
            FeatureType.publicTransport,
            subtype: 'bus_stop',
          ),
          Icons.directions_bus,
        );
      });

      test('falls back to type icon when subtype is null', () {
        expect(FeatureStyles.getFeatureIcon(FeatureType.park), Icons.park);
      });

      test('falls back to type icon when subtype is not recognized', () {
        expect(
          FeatureStyles.getFeatureIcon(FeatureType.amenity, subtype: 'xyz'),
          Icons.store,
        );
      });
    });

    group('getSubtypeDisplayName', () {
      test('returns correct display name for known subtype', () {
        expect(
          FeatureStyles.getSubtypeDisplayName(
            'restaurant',
            FeatureType.amenity,
          ),
          'Restaurant',
        );
      });

      test('formats unknown subtype correctly', () {
        expect(
          FeatureStyles.getSubtypeDisplayName(
            'unknown_subtype',
            FeatureType.amenity,
          ),
          'Unknown Subtype',
        );
      });

      test('falls back to FeatureType name when subtype is null', () {
        expect(
          FeatureStyles.getSubtypeDisplayName(null, FeatureType.amenity),
          'Amenity',
        );
      });
    });
  });
}
