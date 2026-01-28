import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(),
  MockSpec<DocumentReference<Map<String, dynamic>>>(),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(),
])
import 'preferences_service_test.mocks.dart';

void main() {
  group('PreferencesService', () {
    late PreferencesService service;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockUsersCollection;
    late MockDocumentReference mockUserDoc;
    late MockCollectionReference mockPrefsCollection;
    late MockDocumentReference mockSettingsDoc;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockFirestore = MockFirebaseFirestore();
      mockUsersCollection = MockCollectionReference();
      mockUserDoc = MockDocumentReference();
      mockPrefsCollection = MockCollectionReference();
      mockSettingsDoc = MockDocumentReference();

      // Setup Firestore mock chain
      when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
      when(mockUsersCollection.doc(any)).thenReturn(mockUserDoc);
      when(
        mockUserDoc.collection('preferences'),
      ).thenReturn(mockPrefsCollection);
      when(
        mockPrefsCollection.doc('factor_settings'),
      ).thenReturn(mockSettingsDoc);

      service = PreferencesService(firestore: mockFirestore);
    });

    group('Local Storage', () {
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

    group('Cloud Storage', () {
      test('getCloudPreferences returns data when exists', () async {
        final mockSnapshot = MockDocumentSnapshot();
        when(mockSettingsDoc.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(true);
        when(
          mockSnapshot.data(),
        ).thenReturn({'greenery': 'high', 'noise': 'excluded'});

        final prefs = await service.getCloudPreferences('test-user');

        expect(prefs, isNotNull);
        expect(prefs?.greenery, ImportanceLevel.high);
        expect(prefs?.noise, ImportanceLevel.excluded);
      });

      test(
        'getCloudPreferences returns null when doc does not exist',
        () async {
          final mockSnapshot = MockDocumentSnapshot();
          when(mockSettingsDoc.get()).thenAnswer((_) async => mockSnapshot);
          when(mockSnapshot.exists).thenReturn(false);

          final prefs = await service.getCloudPreferences('test-user');

          expect(prefs, isNull);
        },
      );

      test('getCloudPreferences returns null on error', () async {
        when(mockSettingsDoc.get()).thenThrow(Exception('Firestore Error'));

        final prefs = await service.getCloudPreferences('test-user');

        expect(prefs, isNull);
      });

      test('saveCloudPreferences writes to firestore', () async {
        when(mockSettingsDoc.set(any)).thenAnswer((_) async {
          return;
        });

        final prefs = const UserPreferences(greenery: ImportanceLevel.high);
        await service.saveCloudPreferences('test-user', prefs);

        verify(
          mockSettingsDoc.set(
            argThat(
              predicate<Map<String, dynamic>>((data) {
                return data['greenery'] == 'high' && data['updated_at'] != null;
              }),
            ),
          ),
        ).called(1);
      });

      test('saveCloudPreferences rethrows error', () async {
        when(mockSettingsDoc.set(any)).thenThrow(Exception('Write Failed'));

        final prefs = const UserPreferences();
        expect(
          () => service.saveCloudPreferences('test-user', prefs),
          throwsException,
        );
      });

      test('deleteCloudPreferences deletes document', () async {
        when(mockSettingsDoc.delete()).thenAnswer((_) async {
          return;
        });

        await service.deleteCloudPreferences('test-user');

        verify(mockSettingsDoc.delete()).called(1);
      });
    });
  });
}
