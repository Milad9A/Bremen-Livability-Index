import 'package:bloc_test/bloc_test.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/bloc/preferences_event.dart';
import 'package:bli/features/preferences/bloc/preferences_state.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<PreferencesService>()])
import 'preferences_bloc_test.mocks.dart';

void main() {
  group('PreferencesBloc', () {
    late MockPreferencesService mockService;
    late PreferencesBloc bloc;

    setUp(() {
      mockService = MockPreferencesService();
      bloc = PreferencesBloc(preferencesService: mockService);

      // Default stubbing
      when(
        mockService.getLocalPreferences(),
      ).thenAnswer((_) async => UserPreferences.defaults);
      when(mockService.saveLocalPreferences(any)).thenAnswer((_) async {});
      when(mockService.getCloudPreferences(any)).thenAnswer((_) async => null);
      when(mockService.saveCloudPreferences(any, any)).thenAnswer((_) async {});
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const PreferencesState());
    });

    blocTest<PreferencesBloc, PreferencesState>(
      'emits loaded state on LoadPreferences success',
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
      'emits error state on LoadPreferences failure',
      build: () {
        when(
          mockService.getLocalPreferences(),
        ).thenThrow(Exception('Load failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadPreferences()),
      expect: () => [
        const PreferencesState(isLoading: true),
        const PreferencesState(
          isLoading: false,
          error: 'Failed to load preferences',
        ),
      ],
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'emits updated state on UpdateFactor and saves locally',
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
        verify(
          mockService.saveLocalPreferences(
            argThat(
              predicate<UserPreferences>(
                (p) => p.greenery == ImportanceLevel.high,
              ),
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'UpdateFactor also syncs to cloud if user is authenticated',
      build: () => bloc,
      seed: () => const PreferencesState(
        preferences: UserPreferences.defaults,
        syncedUserId: 'user-123',
      ),
      act: (bloc) => bloc.add(
        const UpdateFactor(factorKey: 'greenery', level: ImportanceLevel.high),
      ),
      verify: (_) {
        verify(
          mockService.saveCloudPreferences(
            'user-123',
            argThat(
              predicate<UserPreferences>(
                (p) => p.greenery == ImportanceLevel.high,
              ),
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'emits default state on ResetToDefaults and syncs if auth',
      build: () => bloc,
      seed: () => const PreferencesState(
        preferences: UserPreferences(greenery: ImportanceLevel.high),
        syncedUserId: 'user-123',
      ),
      act: (bloc) => bloc.add(const ResetToDefaults()),
      expect: () => [
        const PreferencesState(
          preferences: UserPreferences.defaults,
          syncedUserId: 'user-123',
        ),
        const PreferencesState(
          preferences: UserPreferences.defaults,
          syncedUserId: 'user-123',
          isSyncing: true,
        ),
        const PreferencesState(
          preferences: UserPreferences.defaults,
          syncedUserId: 'user-123',
          isSyncing: false,
        ),
      ],
      verify: (_) {
        verify(
          mockService.saveLocalPreferences(UserPreferences.defaults),
        ).called(1);
        verify(
          mockService.saveCloudPreferences(
            'user-123',
            UserPreferences.defaults,
          ),
        ).called(1);
      },
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'handles UserAuthenticated by loading cloud prefs',
      build: () {
        when(mockService.getCloudPreferences('user-123')).thenAnswer(
          (_) async => const UserPreferences(greenery: ImportanceLevel.low),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const UserAuthenticated(userId: 'user-123')),
      expect: () => [
        const PreferencesState(syncedUserId: 'user-123'),
        const PreferencesState(
          syncedUserId: 'user-123',
          preferences: UserPreferences(greenery: ImportanceLevel.low),
        ),
      ],
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'handles UserAuthenticated with no cloud prefs (uploads local)',
      build: () => bloc,
      seed: () => const PreferencesState(
        preferences: UserPreferences(greenery: ImportanceLevel.high),
      ),
      act: (bloc) => bloc.add(const UserAuthenticated(userId: 'user-123')),
      expect: () => [
        const PreferencesState(
          preferences: UserPreferences(greenery: ImportanceLevel.high),
          syncedUserId: 'user-123',
        ),
      ],
      verify: (_) {
        verify(
          mockService.saveCloudPreferences(
            'user-123',
            argThat(
              predicate<UserPreferences>(
                (p) => p.greenery == ImportanceLevel.high,
              ),
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'handles UserLoggedOut',
      build: () => bloc,
      seed: () => const PreferencesState(syncedUserId: 'test-user'),
      act: (bloc) => bloc.add(const UserLoggedOut()),
      expect: () => [const PreferencesState(syncedUserId: null)],
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'SyncToCloud emits syncing state and success',
      build: () => bloc,
      seed: () => const PreferencesState(syncedUserId: 'user-123'),
      act: (bloc) => bloc.add(const SyncToCloud(userId: 'user-123')),
      expect: () => [
        const PreferencesState(syncedUserId: 'user-123', isSyncing: true),
        const PreferencesState(syncedUserId: 'user-123', isSyncing: false),
      ],
    );

    blocTest<PreferencesBloc, PreferencesState>(
      'SyncToCloud emits error on failure',
      build: () {
        when(
          mockService.saveCloudPreferences(any, any),
        ).thenThrow(Exception('Sync failed'));
        return bloc;
      },
      seed: () => const PreferencesState(syncedUserId: 'user-123'),
      act: (bloc) => bloc.add(const SyncToCloud(userId: 'user-123')),
      expect: () => [
        const PreferencesState(syncedUserId: 'user-123', isSyncing: true),
        const PreferencesState(
          syncedUserId: 'user-123',
          isSyncing: false,
          error: 'Failed to sync preferences',
        ),
      ],
    );
  });
}
