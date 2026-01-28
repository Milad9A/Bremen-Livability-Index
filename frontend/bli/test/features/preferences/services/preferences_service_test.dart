import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

void main() {
  group('PreferencesService (Local)', () {
    late PreferencesService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = PreferencesService(firestore: FakeFirebaseFirestore());
    });

    test('getLocalPreferences returns defaults when no data saved', () async {
      SharedPreferences.setMockInitialValues({});

      final prefs = await service.getLocalPreferences();
      expect(prefs, equals(UserPreferences.defaults));
    });

    test('getLocalPreferences returns saved data', () async {
      SharedPreferences.setMockInitialValues({
        'user_preferences': '{"greenery": "high", "noise": "low"}',
      });

      final prefs = await service.getLocalPreferences();
      expect(prefs.greenery, ImportanceLevel.high);
      expect(prefs.noise, ImportanceLevel.low);
      expect(prefs.amenities, ImportanceLevel.medium); // Default
    });

    test('saveLocalPreferences saves data correctly', () async {
      SharedPreferences.setMockInitialValues({});

      final prefs = const UserPreferences(
        greenery: ImportanceLevel.high,
        noise: ImportanceLevel.excluded,
      );

      await service.saveLocalPreferences(prefs);

      final sharedPrefs = await SharedPreferences.getInstance();
      final savedJson = sharedPrefs.getString('user_preferences');

      expect(savedJson, isNotNull);
      expect(savedJson, contains('"greenery":"high"'));
      expect(savedJson, contains('"noise":"excluded"'));
    });

    test('clearLocalPreferences removes saved data', () async {
      SharedPreferences.setMockInitialValues({
        'user_preferences': '{"greenery": "high"}',
      });

      await service.clearLocalPreferences();

      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getString('user_preferences'), isNull);
    });
  });
}
