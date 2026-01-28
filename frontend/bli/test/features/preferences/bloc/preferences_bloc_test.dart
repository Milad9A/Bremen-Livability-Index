import 'package:bloc_test/bloc_test.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/bloc/preferences_event.dart';
import 'package:bli/features/preferences/bloc/preferences_state.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';

// Manual Mock for PreferencesService
class MockPreferencesService extends Fake implements PreferencesService {
  UserPreferences _localPrefs = UserPreferences.defaults;
  final Map<String, UserPreferences> _cloudPrefs = {};

  @override
  Future<UserPreferences> getLocalPreferences() async {
    return _localPrefs;
  }

  @override
  Future<void> saveLocalPreferences(UserPreferences preferences) async {
    _localPrefs = preferences;
  }

  @override
  Future<UserPreferences?> getCloudPreferences(String userId) async {
    return _cloudPrefs[userId];
  }

  @override
  Future<void> saveCloudPreferences(
    String userId,
    UserPreferences preferences,
  ) async {
    _cloudPrefs[userId] = preferences;
  }
}

void main() {
  group('PreferencesBloc', () {
    late MockPreferencesService mockService;
    late PreferencesBloc bloc;

    setUp(() {
      mockService = MockPreferencesService();
      bloc = PreferencesBloc(preferencesService: mockService);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const PreferencesState());
    });

    blocTest<PreferencesBloc, PreferencesState>(
      'emits loaded state on LoadPreferences',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadPreferences()),
      expect: () => [
        const PreferencesState(isLoading: true),
        const PreferencesState(
          isLoading: false,
          preferences: UserPreferences.defaults,
        ),
      ],
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'emits updated state on UpdateFactor',
      build: () => bloc,
      seed: () => const PreferencesState(preferences: UserPreferences.defaults),
      act: (bloc) => bloc.add(
        const UpdateFactor(factorKey: 'greenery', level: ImportanceLevel.high),
      ),
      expect: () => [
        isA<PreferencesState>().having(
          (s) => s.preferences.greenery,
          'greenery',
          ImportanceLevel.high,
        ),
      ],
      verify: (_) {
        // Verify it was saved locally (implied by MockService storing it,
        // but strictly we'd verify the call if we used Mockito.
        // With manual fake we trust the fake's state if we checked it,
        // but here we just check bloc state emission).
      },
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'emits default state on ResetToDefaults',
      build: () => bloc,
      seed: () => PreferencesState(
        preferences: const UserPreferences(greenery: ImportanceLevel.high),
      ),
      act: (bloc) => bloc.add(const ResetToDefaults()),
      expect: () => [
        const PreferencesState(preferences: UserPreferences.defaults),
      ],
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'handles UserAuthenticated by syncing cloud prefs (mocked empty cloud)',
      build: () => bloc,
      act: (bloc) => bloc.add(const UserAuthenticated(userId: 'test-user')),
      expect: () => [const PreferencesState(syncedUserId: 'test-user')],
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'handles UserLoggedOut',
      build: () => bloc,
      seed: () => const PreferencesState(syncedUserId: 'test-user'),
      act: (bloc) => bloc.add(const UserLoggedOut()),
      expect: () => [const PreferencesState(syncedUserId: null)],
      verify: (bloc) {
        expect(bloc.state.syncedUserId, isNull);
      },
    );
  });
}
