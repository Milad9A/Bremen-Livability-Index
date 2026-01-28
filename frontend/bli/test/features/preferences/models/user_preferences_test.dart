import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserPreferences', () {
    test('defaults should have all factors set to medium', () {
      const prefs = UserPreferences.defaults;
      expect(prefs.greenery, ImportanceLevel.medium);
      expect(prefs.amenities, ImportanceLevel.medium);
      expect(prefs.publicTransport, ImportanceLevel.medium);
      // Check a few others to be sure
      expect(prefs.noise, ImportanceLevel.medium);
      expect(prefs.construction, ImportanceLevel.medium);
    });

    test('isCustomized returns false for default preferences', () {
      expect(UserPreferences.defaults.isCustomized, isFalse);
    });

    test('isCustomized returns true if any value is changed', () {
      final prefs = const UserPreferences().copyWith(
        greenery: ImportanceLevel.high,
      );
      expect(prefs.isCustomized, isTrue);
    });

    test('copyWith properly updates fields', () {
      const prefs = UserPreferences.defaults;
      final updated = prefs.copyWith(
        greenery: ImportanceLevel.high,
        noise: ImportanceLevel.low,
        industrial: ImportanceLevel.excluded,
      );

      expect(updated.greenery, ImportanceLevel.high);
      expect(updated.noise, ImportanceLevel.low);
      expect(updated.industrial, ImportanceLevel.excluded);
      // Others should remain medium
      expect(updated.amenities, ImportanceLevel.medium);
    });

    test('toJson converts preferences to string map', () {
      final prefs = const UserPreferences(
        greenery: ImportanceLevel.high,
        noise: ImportanceLevel.excluded,
      );

      final json = prefs.toJson();
      expect(json['greenery'], 'high');
      expect(json['noise'], 'excluded');
      expect(json['amenities'], 'medium'); // Default
    });

    test('fromJson parses string map correctly', () {
      final json = {
        'greenery': 'high',
        'noise': 'excluded',
        'amenities': 'medium',
      };

      final prefs = UserPreferences.fromJson(json);
      expect(prefs.greenery, ImportanceLevel.high);
      expect(prefs.noise, ImportanceLevel.excluded);
      expect(prefs.amenities, ImportanceLevel.medium);
    });

    test('fromJson handles missing keys by using defaults (medium)', () {
      final json = {'greenery': 'high'}; // Missing others
      final prefs = UserPreferences.fromJson(json);

      expect(prefs.greenery, ImportanceLevel.high);
      expect(prefs.amenities, ImportanceLevel.medium);
      expect(prefs.noise, ImportanceLevel.medium);
    });

    test('fromJson handles invalid values by falling back to medium', () {
      final json = {'greenery': 'INVALID_VALUE'};
      final prefs = UserPreferences.fromJson(json);

      expect(prefs.greenery, ImportanceLevel.medium);
    });

    test('ImportanceLevel label getter returns correct display text', () {
      expect(ImportanceLevel.excluded.label, 'Off');
      expect(ImportanceLevel.low.label, 'Low');
      expect(ImportanceLevel.medium.label, 'Med');
      expect(ImportanceLevel.high.label, 'High');
    });
  });
}
