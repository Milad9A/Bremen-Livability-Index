import 'dart:async';

import 'package:bli/features/preferences/bloc/preferences_event.dart';
import 'package:bli/features/preferences/bloc/preferences_state.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc for managing user scoring preferences.
///
/// - Loads preferences from local storage on init
/// - Syncs to Firestore when user is authenticated
/// - Auto-saves locally on every change
/// - Auto-syncs to cloud for authenticated users
class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesService _preferencesService;
  StreamSubscription<UserPreferences?>? _cloudSubscription;

  PreferencesBloc({required PreferencesService preferencesService})
    : _preferencesService = preferencesService,
      super(const PreferencesState()) {
    on<LoadPreferences>(_onLoadPreferences);
    on<UpdateFactor>(_onUpdateFactor);
    on<ResetToDefaults>(_onResetToDefaults);
    on<SyncToCloud>(_onSyncToCloud);
    on<UserAuthenticated>(_onUserAuthenticated);
    on<UserLoggedOut>(_onUserLoggedOut);
  }

  Future<void> _onLoadPreferences(
    LoadPreferences event,
    Emitter<PreferencesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final localPrefs = await _preferencesService.getLocalPreferences();
      emit(state.copyWith(preferences: localPrefs, isLoading: false));

      if (event.userId != null) {
        add(UserAuthenticated(userId: event.userId!));
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
      emit(
        state.copyWith(isLoading: false, error: 'Failed to load preferences'),
      );
    }
  }

  Future<void> _onUpdateFactor(
    UpdateFactor event,
    Emitter<PreferencesState> emit,
  ) async {
    final updatedPrefs = _updateFactorByKey(
      state.preferences,
      event.factorKey,
      event.level,
    );

    emit(state.copyWith(preferences: updatedPrefs));

    await _preferencesService.saveLocalPreferences(updatedPrefs);

    if (state.syncedUserId != null) {
      add(SyncToCloud(userId: state.syncedUserId!));
    }
  }

  Future<void> _onResetToDefaults(
    ResetToDefaults event,
    Emitter<PreferencesState> emit,
  ) async {
    emit(state.copyWith(preferences: UserPreferences.defaults));

    await _preferencesService.saveLocalPreferences(UserPreferences.defaults);

    if (state.syncedUserId != null) {
      add(SyncToCloud(userId: state.syncedUserId!));
    }
  }

  Future<void> _onSyncToCloud(
    SyncToCloud event,
    Emitter<PreferencesState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));

    try {
      await _preferencesService.saveCloudPreferences(
        event.userId,
        state.preferences,
      );
      emit(state.copyWith(isSyncing: false));
    } catch (e) {
      debugPrint('Error syncing to cloud: $e');
      emit(
        state.copyWith(isSyncing: false, error: 'Failed to sync preferences'),
      );
    }
  }

  Future<void> _onUserAuthenticated(
    UserAuthenticated event,
    Emitter<PreferencesState> emit,
  ) async {
    emit(state.copyWith(syncedUserId: event.userId));

    await _cloudSubscription?.cancel();

    try {
      final cloudPrefs = await _preferencesService.getCloudPreferences(
        event.userId,
      );

      if (cloudPrefs != null) {
        emit(state.copyWith(preferences: cloudPrefs));
        await _preferencesService.saveLocalPreferences(cloudPrefs);
      } else {
        await _preferencesService.saveCloudPreferences(
          event.userId,
          state.preferences,
        );
      }
    } catch (e) {
      debugPrint('Error syncing on auth: $e');
    }
  }

  Future<void> _onUserLoggedOut(
    UserLoggedOut event,
    Emitter<PreferencesState> emit,
  ) async {
    await _cloudSubscription?.cancel();
    _cloudSubscription = null;

    emit(state.copyWith(clearSyncedUserId: true));
  }

  /// Helper to update a specific factor in preferences
  UserPreferences _updateFactorByKey(
    UserPreferences prefs,
    String key,
    ImportanceLevel level,
  ) {
    switch (key) {
      case 'greenery':
        return prefs.copyWith(greenery: level);
      case 'amenities':
        return prefs.copyWith(amenities: level);
      case 'public_transport':
        return prefs.copyWith(publicTransport: level);
      case 'healthcare':
        return prefs.copyWith(healthcare: level);
      case 'bike_infrastructure':
        return prefs.copyWith(bikeInfrastructure: level);
      case 'education':
        return prefs.copyWith(education: level);
      case 'sports_leisure':
        return prefs.copyWith(sportsLeisure: level);
      case 'pedestrian_infrastructure':
        return prefs.copyWith(pedestrianInfrastructure: level);
      case 'cultural':
        return prefs.copyWith(cultural: level);
      case 'accidents':
        return prefs.copyWith(accidents: level);
      case 'industrial':
        return prefs.copyWith(industrial: level);
      case 'major_roads':
        return prefs.copyWith(majorRoads: level);
      case 'noise':
        return prefs.copyWith(noise: level);
      case 'railway':
        return prefs.copyWith(railway: level);
      case 'gas_station':
        return prefs.copyWith(gasStation: level);
      case 'waste':
        return prefs.copyWith(waste: level);
      case 'power':
        return prefs.copyWith(power: level);
      case 'parking':
        return prefs.copyWith(parking: level);
      case 'airport':
        return prefs.copyWith(airport: level);
      case 'construction':
        return prefs.copyWith(construction: level);
      default:
        return prefs;
    }
  }

  @override
  Future<void> close() {
    _cloudSubscription?.cancel();
    return super.close();
  }
}
