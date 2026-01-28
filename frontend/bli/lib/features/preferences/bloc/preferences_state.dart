import 'package:bli/features/preferences/models/user_preferences.dart';

/// State for the preferences bloc
class PreferencesState {
  final UserPreferences preferences;
  final bool isLoading;
  final bool isSyncing;
  final String? error;
  final String? syncedUserId;

  const PreferencesState({
    this.preferences = const UserPreferences(),
    this.isLoading = false,
    this.isSyncing = false,
    this.error,
    this.syncedUserId,
  });

  /// Whether the preferences differ from defaults
  bool get isCustomized => preferences.isCustomized;

  /// Whether we're synced to a cloud account
  bool get isSyncedToCloud => syncedUserId != null;

  PreferencesState copyWith({
    UserPreferences? preferences,
    bool? isLoading,
    bool? isSyncing,
    String? error,
    String? syncedUserId,
    bool clearError = false,
    bool clearSyncedUserId = false,
  }) {
    return PreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      error: clearError ? null : (error ?? this.error),
      syncedUserId: clearSyncedUserId
          ? null
          : (syncedUserId ?? this.syncedUserId),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferencesState &&
          preferences == other.preferences &&
          isLoading == other.isLoading &&
          isSyncing == other.isSyncing &&
          error == other.error &&
          syncedUserId == other.syncedUserId;

  @override
  int get hashCode =>
      Object.hash(preferences, isLoading, isSyncing, error, syncedUserId);
}
