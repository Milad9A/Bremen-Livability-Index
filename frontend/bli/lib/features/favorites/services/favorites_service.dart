import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavoritesService {
  final FirebaseFirestore _firestore;

  FavoritesService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getFavoritesCollection(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId).collection('favorites');
  }

  Stream<List<FavoriteAddress>> getFavorites(String userId) {
    return _getFavoritesCollection(
      userId,
    ).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        data['id'] = doc.id;
        return FavoriteAddress.fromJson(data);
      }).toList();
    });
  }

  Future<void> addFavorite(String userId, FavoriteAddress address) async {
    try {
      await _getFavoritesCollection(
        userId,
      ).doc(address.id).set(address.toJson());
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String userId, String addressId) async {
    try {
      await _getFavoritesCollection(userId).doc(addressId).delete();
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String userId, String addressId) async {
    try {
      final doc = await _getFavoritesCollection(userId).doc(addressId).get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking favorite: $e');
      return false;
    }
  }
}
