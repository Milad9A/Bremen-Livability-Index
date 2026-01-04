import 'dart:async';

import 'package:bli/features/map/models/models.dart';
import 'package:bli/core/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_event.dart';
part 'map_state.dart';
part 'map_bloc.freezed.dart';

/// BLoC for managing map screen state.
class MapBloc extends Bloc<MapEvent, MapState> {
  final ApiService _apiService;
  final MapController mapController = MapController();
  Timer? _slowLoadingTimer;

  /// Callback for showing messages (e.g., SnackBar).
  void Function(String message)? onShowMessage;

  // Bremen center coordinates
  static const LatLng bremenCenter = LatLng(53.0793, 8.8017);

  // Bremen bounding box (approximate city limits)
  static const double bremenMinLat = 52.96;
  static const double bremenMaxLat = 53.22;
  static const double bremenMinLon = 8.48;
  static const double bremenMaxLon = 9.01;

  MapBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(MapState.initial()) {
    on<MapTapped>(_onMapTapped);
    on<SearchToggled>(_onSearchToggled);
    on<ErrorCleared>(_onErrorCleared);
    on<MapReset>(_onMapReset);
    on<LocationSelected>(_onLocationSelected);
    on<AnalysisSucceeded>(_onAnalysisSucceeded);
    on<AnalysisFailed>(_onAnalysisFailed);
    on<SlowLoadingTriggered>(_onSlowLoadingTriggered);

    _checkApiHealth();
  }

  /// Check if a point is within Bremen's data coverage area.
  bool isWithinBremen(LatLng point) {
    return point.latitude >= bremenMinLat &&
        point.latitude <= bremenMaxLat &&
        point.longitude >= bremenMinLon &&
        point.longitude <= bremenMaxLon;
  }

  Future<void> _checkApiHealth() async {
    final isHealthy = await _apiService.checkHealth();
    if (!isHealthy) {
      add(
        const AnalysisFailed(
          'API server is not available. Please start the backend server.',
        ),
      );
    }
  }

  void _startSlowLoadingTimer() {
    _slowLoadingTimer?.cancel();
    _slowLoadingTimer = Timer(const Duration(seconds: 10), () {
      if (state.isLoading) {
        add(const SlowLoadingTriggered());
      }
    });
  }

  void _stopSlowLoadingTimer() {
    _slowLoadingTimer?.cancel();
  }

  Future<void> _onMapTapped(MapTapped event, Emitter<MapState> emit) async {
    // If search is active, tapping map should close it
    if (state.showSearch) {
      emit(state.copyWith(showSearch: false));
      return;
    }

    // Check if the point is within Bremen's data coverage area
    if (!isWithinBremen(event.position)) {
      onShowMessage?.call(
        'Data is only available for Bremen. Please select a location within the city.',
      );
      return;
    }

    emit(
      MapState(
        isLoading: true,
        selectedMarker: LocationMarker(position: event.position),
        showSlowLoadingMessage: false,
      ),
    );

    _startSlowLoadingTimer();

    try {
      final score = await _apiService.analyzeLocation(
        event.position.latitude,
        event.position.longitude,
      );
      add(AnalysisSucceeded(score, event.position));
    } catch (e) {
      add(AnalysisFailed(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onSearchToggled(SearchToggled event, Emitter<MapState> emit) {
    emit(state.copyWith(showSearch: event.show));
  }

  void _onErrorCleared(ErrorCleared event, Emitter<MapState> emit) {
    emit(state.copyWith(errorMessage: null));
  }

  void _onMapReset(MapReset event, Emitter<MapState> emit) {
    // Only move/rotate if the map controller is attached to a map
    try {
      mapController.move(bremenCenter, 13.0);
      mapController.rotate(0);
    } catch (_) {
      // MapController not attached to a map widget yet
    }
    emit(MapState.initial());
  }

  Future<void> _onLocationSelected(
    LocationSelected event,
    Emitter<MapState> emit,
  ) async {
    mapController.move(event.location, 16.0);

    emit(
      MapState(
        isLoading: true,
        selectedMarker: LocationMarker(position: event.location),
        showSlowLoadingMessage: false,
        showSearch: false,
      ),
    );

    _startSlowLoadingTimer();

    try {
      final score = await _apiService.analyzeLocation(
        event.location.latitude,
        event.location.longitude,
      );
      add(AnalysisSucceeded(score, event.location));
    } catch (e) {
      add(AnalysisFailed(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onAnalysisSucceeded(AnalysisSucceeded event, Emitter<MapState> emit) {
    _stopSlowLoadingTimer();
    emit(
      state.copyWith(
        currentScore: event.score,
        selectedMarker: LocationMarker(
          position: event.position,
          score: event.score.score,
        ),
        isLoading: false,
        showSlowLoadingMessage: false,
      ),
    );
  }

  void _onAnalysisFailed(AnalysisFailed event, Emitter<MapState> emit) {
    _stopSlowLoadingTimer();
    emit(
      state.copyWith(
        errorMessage: event.errorMessage,
        isLoading: false,
        showSlowLoadingMessage: false,
      ),
    );
  }

  void _onSlowLoadingTriggered(
    SlowLoadingTriggered event,
    Emitter<MapState> emit,
  ) {
    if (state.isLoading) {
      emit(state.copyWith(showSlowLoadingMessage: true));
    }
  }

  @override
  Future<void> close() {
    _slowLoadingTimer?.cancel();
    return super.close();
  }
}
