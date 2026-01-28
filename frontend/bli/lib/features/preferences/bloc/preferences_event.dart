import 'package:bli/features/preferences/models/user_preferences.dart';

/// Base class for preferences events
sealed class PreferencesEvent {
  const PreferencesEvent();
}

/// Load preferences from local storage or Firestore
class LoadPreferences extends PreferencesEvent {
  final String? userId;
  const LoadPreferences({this.userId});
}

/// Update a single factor's importance level
class UpdateFactor extends PreferencesEvent {
  final String factorKey;
  final ImportanceLevel level;
  const UpdateFactor({required this.factorKey, required this.level});
}

/// Reset all preferences to defaults
class ResetToDefaults extends PreferencesEvent {
  const ResetToDefaults();
}

/// Sync preferences to Firestore (for authenticated users)
class SyncToCloud extends PreferencesEvent {
  final String userId;
  const SyncToCloud({required this.userId});
}

/// User logged in - load cloud preferences and merge
class UserAuthenticated extends PreferencesEvent {
  final String userId;
  const UserAuthenticated({required this.userId});
}

/// User logged out - keep local preferences, stop cloud sync
class UserLoggedOut extends PreferencesEvent {
  const UserLoggedOut();
}
