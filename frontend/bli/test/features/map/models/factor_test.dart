import 'package:bli/features/map/models/factor.dart';
import 'package:bli/features/map/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Factor', () {
    const factor = Factor(
      factor: MetricCategory.greenery,
      value: 0.8,
      description: 'High greenery',
      impact: 'Positive',
    );

    test('supports value equality', () {
      expect(
        factor,
        equals(
          const Factor(
            factor: MetricCategory.greenery,
            value: 0.8,
            description: 'High greenery',
            impact: 'Positive',
          ),
        ),
      );
    });

    test('toJson', () {
      expect(factor.toJson(), {
        'factor': 'Greenery',
        'value': 0.8,
        'description': 'High greenery',
        'impact': 'Positive',
      });
    });

    test('fromJson', () {
      final json = {
        'factor': 'Greenery',
        'value': 0.8,
        'description': 'High greenery',
        'impact': 'Positive',
      };
      expect(Factor.fromJson(json), factor);
    });

    test('fromJson handles unknown enum values', () {
      final json = {
        'factor': 'UnknownMetric',
        'value': 0.8,
        'description': 'High greenery',
        'impact': 'Positive',
      };
      final result = Factor.fromJson(json);
      expect(result.factor, MetricCategory.unknown);
    });
  });
}
