import 'dart:convert';

import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user preferences.
///
/// - For guests: Stores preferences locally using SharedPreferences
/// - For authenticated users: Syncs preferences to Firestore
class PreferencesService {
  static const String _localStorageKey = 'user_preferences';

  final FirebaseFirestore _firestore;
  final SharedPreferences? _sharedPreferences;

  PreferencesService({
    FirebaseFirestore? firestore,
    SharedPreferences? sharedPreferences,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _sharedPreferences = sharedPreferences;

  /// Get local preferences from SharedPreferences
  Future<UserPreferences> getLocalPreferences() async {
    try {
      final prefs = _sharedPreferences ?? await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_localStorageKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return UserPreferences.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error loading local preferences: $e');
    }
    return UserPreferences.defaults;
  }

  /// Save preferences locally to SharedPreferences
  Future<void> saveLocalPreferences(UserPreferences preferences) async {
    try {
      final prefs = _sharedPreferences ?? await SharedPreferences.getInstance();
      final jsonString = jsonEncode(preferences.toJson());
      await prefs.setString(_localStorageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving local preferences: $e');
      rethrow;
    }
  }

  /// Clear local preferences
  Future<void> clearLocalPreferences() async {
    try {
      final prefs = _sharedPreferences ?? await SharedPreferences.getInstance();
      await prefs.remove(_localStorageKey);
    } catch (e) {
      debugPrint('Error clearing local preferences: $e');
    }
  }

  /// Get Firestore document reference for user preferences
  DocumentReference<Map<String, dynamic>> _getPreferencesDoc(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('factor_settings');
  }

  /// Get preferences from Firestore for authenticated user
  Future<UserPreferences?> getCloudPreferences(String userId) async {
    try {
      final doc = await _getPreferencesDoc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserPreferences.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error loading cloud preferences: $e');
    }
    return null;
  }

  /// Save preferences to Firestore for authenticated user
  Future<void> saveCloudPreferences(
    String userId,
    UserPreferences preferences,
  ) async {
    try {
      await _getPreferencesDoc(userId).set({
        ...preferences.toJson(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving cloud preferences: $e');
      rethrow;
    }
  }

  /// Delete cloud preferences for a user
  Future<void> deleteCloudPreferences(String userId) async {
    try {
      await _getPreferencesDoc(userId).delete();
    } catch (e) {
      debugPrint('Error deleting cloud preferences: $e');
    }
  }

  /// Stream cloud preferences changes for a user
  Stream<UserPreferences?> watchCloudPreferences(String userId) {
    return _getPreferencesDoc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserPreferences.fromJson(snapshot.data()!);
      }
      return null;
    });
  }
}
