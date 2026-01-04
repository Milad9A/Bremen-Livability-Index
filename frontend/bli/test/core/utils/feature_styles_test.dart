import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/core/utils/feature_styles.dart';
import 'package:bli/features/map/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureStyles', () {
    group('getFactorColor', () {
      test('returns a valid color for every MetricCategory', () {
        for (final category in MetricCategory.values) {
          final color = FeatureStyles.getFactorColor(category);
          expect(color, isA<Color>(), reason: 'Failed for $category');
        }
      });

      test('verifies specific color mappings', () {
        expect(
          FeatureStyles.getFactorColor(MetricCategory.greenery),
          Colors.green,
        );
        expect(
          FeatureStyles.getFactorColor(MetricCategory.industrialArea),
          AppColors.greyMedium,
        );
        expect(
          FeatureStyles.getFactorColor(MetricCategory.majorRoad),
          AppColors.black.withValues(alpha: 0.54),
        );
        expect(
          FeatureStyles.getFactorColor(MetricCategory.unknown),
          AppColors.greyLight,
        );
      });
    });

    group('getFactorIcon', () {
      test('returns a valid icon for every MetricCategory', () {
        for (final category in MetricCategory.values) {
          final icon = FeatureStyles.getFactorIcon(category);
          expect(icon, isA<IconData>(), reason: 'Failed for $category');
        }
      });

      test('verifies specific icon mappings', () {
        expect(
          FeatureStyles.getFactorIcon(MetricCategory.greenery),
          Icons.nature,
        );
        expect(
          FeatureStyles.getFactorIcon(MetricCategory.healthcare),
          Icons.local_hospital,
        );
        expect(
          FeatureStyles.getFactorIcon(MetricCategory.unknown),
          Icons.help_outline,
        );
      });
    });

    group('getFeatureColor', () {
      test('returns a valid color for every FeatureType', () {
        for (final type in FeatureType.values) {
          final color = FeatureStyles.getFeatureColor(type);
          expect(color, isA<Color>(), reason: 'Failed for $type');
        }
      });

      test('verifies specific color mappings', () {
        expect(FeatureStyles.getFeatureColor(FeatureType.park), Colors.green);
        expect(FeatureStyles.getFeatureColor(FeatureType.tree), Colors.green);
        expect(
          FeatureStyles.getFeatureColor(FeatureType.majorRoad).value,
          AppColors.black.withValues(alpha: 0.54).value,
        );
        expect(
          FeatureStyles.getFeatureColor(FeatureType.unknown),
          AppColors.greyMedium,
        );
      });
    });

    group('getFeatureIcon', () {
      test('returns a valid icon for every FeatureType (without subtype)', () {
        for (final type in FeatureType.values) {
          final icon = FeatureStyles.getFeatureIcon(type);
          expect(icon, isA<IconData>(), reason: 'Failed for $type');
        }
      });

      group('with subtypes', () {
        test('Amenities subtypes', () {
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.amenity,
              subtype: 'restaurant',
            ),
            Icons.restaurant,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.amenity,
              subtype: 'fast_food',
            ),
            Icons.restaurant,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.amenity,
              subtype: 'school',
            ),
            Icons.school,
          );
          expect(
            FeatureStyles.getFeatureIcon(FeatureType.amenity, subtype: 'bar'),
            Icons.local_bar,
          );
          expect(
            FeatureStyles.getFeatureIcon(FeatureType.amenity, subtype: 'bank'),
            Icons.account_balance,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.amenity,
              subtype: 'pharmacy',
            ),
            Icons.local_pharmacy,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.amenity,
              subtype: 'hospital',
            ),
            Icons.local_hospital,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.amenity,
              subtype: 'cinema',
            ),
            Icons.movie,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.amenity,
              subtype: 'place_of_worship',
            ),
            Icons.church,
          );
        });

        test('Transport subtypes', () {
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.publicTransport,
              subtype: 'bus_stop',
            ),
            Icons.directions_bus,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.publicTransport,
              subtype: 'tram',
            ),
            Icons.tram,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.publicTransport,
              subtype: 'train',
            ),
            Icons.train,
          );
        });

        test('Education subtypes', () {
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.education,
              subtype: 'university',
            ),
            Icons.school,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.education,
              subtype: 'kindergarten',
            ),
            Icons.child_care,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.education,
              subtype: 'library',
            ),
            Icons.local_library,
          );
        });

        test('Sports subtypes', () {
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.sportsLeisure,
              subtype: 'swimming_pool',
            ),
            Icons.pool,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.sportsLeisure,
              subtype: 'playground',
            ),
            Icons.toys,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.sportsLeisure,
              subtype: 'fitness_centre',
            ),
            Icons.fitness_center,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.sportsLeisure,
              subtype: 'pitch',
            ),
            Icons.stadium,
          );
        });

        test('Culture subtypes', () {
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.culturalVenue,
              subtype: 'museum',
            ),
            Icons.museum,
          );
          expect(
            FeatureStyles.getFeatureIcon(
              FeatureType.culturalVenue,
              subtype: 'arts_centre',
            ),
            Icons.palette,
          );
        });
      });

      test('falls back to type icon when subtype is not recognized', () {
        expect(
          FeatureStyles.getFeatureIcon(
            FeatureType.amenity,
            subtype: 'unknown_thing',
          ),
          Icons.store,
        );
      });
    });

    group('getSubtypeDisplayName', () {
      test('returns correct display name for specific mapped subtypes', () {
        final Map<String, String> testCases = {
          'tram_stop': 'Tram Stop',
          'restaurant': 'Restaurant',
          'hospital': 'Hospital',
          'school': 'School',
          'swimming_pool': 'Swimming Pool',
          'museum': 'Museum',
          'tree': 'Tree',
          'pedestrian': 'Pedestrian Zone',
          'industrial': 'Industrial Area',
        };

        testCases.forEach((subtype, expectedName) {
          expect(
            FeatureStyles.getSubtypeDisplayName(subtype, FeatureType.amenity),
            expectedName,
            reason: 'Failed for $subtype',
          );
        });
      });

      test('formats unknown subtype correctly (fallback logic)', () {
        // "some_random_subtype" -> "Some Random Subtype"
        expect(
          FeatureStyles.getSubtypeDisplayName(
            'some_random_subtype',
            FeatureType.amenity,
          ),
          'Some Random Subtype',
        );
        expect(
          FeatureStyles.getSubtypeDisplayName('one_word', FeatureType.amenity),
          'One Word',
        );
      });

      test('falls back to FeatureType name when subtype is null', () {
        expect(
          FeatureStyles.getSubtypeDisplayName(null, FeatureType.amenity),
          'Amenity',
        );
        expect(
          FeatureStyles.getSubtypeDisplayName(null, FeatureType.park),
          'Park',
        );
      });
    });

    group('getFeatureTypeDisplayName', () {
      test('returns a non-empty string for every FeatureType', () {
        for (final type in FeatureType.values) {
          final name = FeatureStyles.getFeatureTypeDisplayName(type);
          expect(name, isA<String>());
          expect(
            name.isNotEmpty,
            isTrue,
            reason: 'Name should not be empty for $type',
          );
        }
      });

      test('verifies specific display names', () {
        expect(
          FeatureStyles.getFeatureTypeDisplayName(FeatureType.tree),
          'Tree',
        );
        expect(
          FeatureStyles.getFeatureTypeDisplayName(FeatureType.majorRoad),
          'Major Road',
        );
        expect(
          FeatureStyles.getFeatureTypeDisplayName(FeatureType.unknown),
          'Unknown',
        );
      });
    });
  });
}
