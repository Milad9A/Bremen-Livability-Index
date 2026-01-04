part of 'map_bloc.dart';

/// All map-related events using freezed union types.
@freezed
sealed class MapEvent with _$MapEvent {
  /// User tapped on the map at a specific location.
  const factory MapEvent.mapTapped(LatLng position) = MapTapped;

  /// Toggle search overlay visibility.
  const factory MapEvent.searchToggled(bool show) = SearchToggled;

  /// Clear the current error message.
  const factory MapEvent.errorCleared() = ErrorCleared;

  /// Reset map to initial state (Bremen center, clear selection).
  const factory MapEvent.mapReset() = MapReset;

  /// User selected a location from search results.
  const factory MapEvent.locationSelected(LatLng location, String addressName) =
      LocationSelected;

  /// Internal: API call succeeded. Not intended for external use.
  const factory MapEvent.analysisSucceeded(
    LivabilityScore score,
    LatLng position,
  ) = AnalysisSucceeded;

  /// Internal: API call failed. Not intended for external use.
  const factory MapEvent.analysisFailed(String errorMessage) = AnalysisFailed;

  /// Internal: Slow loading timer triggered. Not intended for external use.
  const factory MapEvent.slowLoadingTriggered() = SlowLoadingTriggered;
}
