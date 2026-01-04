part of 'map_bloc.dart';

/// Immutable state for the map screen using freezed.
@freezed
class MapState with _$MapState {
  const factory MapState({
    LocationMarker? selectedMarker,
    LivabilityScore? currentScore,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool showSearch,
    @Default(false) bool showSlowLoadingMessage,
  }) = _MapState;

  /// Initial state with default values.
  factory MapState.initial() => const MapState();
}
