import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/services/favorites_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(),
  MockSpec<DocumentReference<Map<String, dynamic>>>(),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(),
  MockSpec<QuerySnapshot<Map<String, dynamic>>>(),
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(),
  MockSpec<Query<Map<String, dynamic>>>(),
])
import 'favorites_service_test.mocks.dart';

void main() {
  group('FavoritesService', () {
    late MockFirebaseFirestore mockFirestore;
    late FavoritesService favoritesService;
    late MockCollectionReference mockUsersCollection;
    late MockDocumentReference mockUserDoc;
    late MockCollectionReference mockFavoritesCollection;
    late MockQuery mockQuery;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockUsersCollection = MockCollectionReference();
      mockUserDoc = MockDocumentReference();
      mockFavoritesCollection = MockCollectionReference();
      mockQuery = MockQuery();

      // Setup chain of mocks
      when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
      when(mockUsersCollection.doc(any)).thenReturn(mockUserDoc);
      when(
        mockUserDoc.collection('favorites'),
      ).thenReturn(mockFavoritesCollection);

      favoritesService = FavoritesService(firestore: mockFirestore);
    });

    final testUserId = 'test-uid';
    final testAddress = FavoriteAddress(
      id: 'addr-1',
      label: 'Home',
      latitude: 10.0,
      longitude: 20.0,
      address: '123 Fake St',
      createdAt: DateTime.now(),
    );

    group('getFavorites', () {
      test('emits list of favorites from snapshot', () {
        // Arrange
        final mockSnapshot = MockQuerySnapshot();
        final mockDocSnapshot = MockQueryDocumentSnapshot();

        when(
          mockFavoritesCollection.orderBy('createdAt', descending: true),
        ).thenReturn(mockQuery);
        when(
          mockQuery.snapshots(),
        ).thenAnswer((_) => Stream.value(mockSnapshot));
        when(mockSnapshot.docs).thenReturn([mockDocSnapshot]);

        when(mockDocSnapshot.id).thenReturn('addr-1');
        when(mockDocSnapshot.data()).thenReturn({
          'label': 'Home',
          'latitude': 10.0,
          'longitude': 20.0,
          'address': '123 Fake St',
          'createdAt': testAddress.createdAt.toIso8601String(),
        });

        // Act
        final stream = favoritesService.getFavorites(testUserId);

        // Assert
        expect(stream, emits(isA<List<FavoriteAddress>>()));
      });
    });

    group('addFavorite', () {
      test('sets document in favorites collection', () async {
        // Arrange
        final mockDocRef = MockDocumentReference();
        when(mockFavoritesCollection.doc(any)).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenAnswer((_) async {});

        // Act
        await favoritesService.addFavorite(testUserId, testAddress);

        // Assert
        verify(mockFavoritesCollection.doc(testAddress.id)).called(1);
        verify(mockDocRef.set(any)).called(1);
      });

      test('rethrows exception on failure', () async {
        // Arrange
        final mockDocRef = MockDocumentReference();
        when(mockFavoritesCollection.doc(any)).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenThrow(Exception('Add failed'));

        // Act & Assert
        expect(
          () => favoritesService.addFavorite(testUserId, testAddress),
          throwsException,
        );
      });
    });

    group('removeFavorite', () {
      test('deletes document from favorites collection', () async {
        // Arrange
        final mockDocRef = MockDocumentReference();
        when(mockFavoritesCollection.doc(any)).thenReturn(mockDocRef);
        when(mockDocRef.delete()).thenAnswer((_) async {});

        // Act
        await favoritesService.removeFavorite(testUserId, 'addr-1');

        // Assert
        verify(mockFavoritesCollection.doc('addr-1')).called(1);
        verify(mockDocRef.delete()).called(1);
      });
    });

    group('isFavorite', () {
      test('returns true if document exists', () async {
        // Arrange
        final mockDocRef = MockDocumentReference();
        final mockDocSnapshot = MockDocumentSnapshot();

        when(mockFavoritesCollection.doc(any)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);

        // Act
        final result = await favoritesService.isFavorite(testUserId, 'addr-1');

        // Assert
        expect(result, true);
      });

      test('returns false if document does not exist', () async {
        // Arrange
        final mockDocRef = MockDocumentReference();
        final mockDocSnapshot = MockDocumentSnapshot();

        when(mockFavoritesCollection.doc(any)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(false);

        // Act
        final result = await favoritesService.isFavorite(testUserId, 'addr-1');

        // Assert
        expect(result, false);
      });

      test('returns false on error', () async {
        // Arrange
        final mockDocRef = MockDocumentReference();
        when(mockFavoritesCollection.doc(any)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenThrow(Exception('Get failed'));

        // Act
        final result = await favoritesService.isFavorite(testUserId, 'addr-1');

        // Assert
        expect(result, false);
      });
    });
  });
}
