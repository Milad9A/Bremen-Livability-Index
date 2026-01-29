import 'package:bli/features/preferences/bloc/preferences_event.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreferencesEvent', () {
    test('supports value comparisons', () {
      // LoadPreferences
      expect(
        const LoadPreferences(userId: '1'),
        isNot(equals(const LoadPreferences(userId: '2'))),
      );

      // UpdateFactor
      expect(
        const UpdateFactor(factorKey: 'noise', level: ImportanceLevel.high),
        isNot(
          equals(
            const UpdateFactor(factorKey: 'noise', level: ImportanceLevel.low),
          ),
        ),
      );

      // ResetToDefaults
      expect(const ResetToDefaults(), isA<ResetToDefaults>());

      // SyncToCloud
      expect(
        const SyncToCloud(userId: '1'),
        isNot(equals(const SyncToCloud(userId: '2'))),
      );

      // UserAuthenticated
      expect(
        const UserAuthenticated(userId: '1'),
        isNot(equals(const UserAuthenticated(userId: '2'))),
      );

      // UserLoggedOut
      expect(const UserLoggedOut(), isA<UserLoggedOut>());
    });

    test('instantiates correctly', () {
      const event1 = LoadPreferences(userId: '123');
      expect(event1.userId, '123');

      const event2 = UpdateFactor(
        factorKey: 'safety',
        level: ImportanceLevel.medium,
      );
      expect(event2.factorKey, 'safety');
      expect(event2.level, ImportanceLevel.medium);

      const event3 = SyncToCloud(userId: 'abc');
      expect(event3.userId, 'abc');

      const event4 = UserAuthenticated(userId: 'xyz');
      expect(event4.userId, 'xyz');
    });
  });
}
