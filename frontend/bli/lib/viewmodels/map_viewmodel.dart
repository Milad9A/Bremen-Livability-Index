import 'dart:async';

import 'package:bli/models/models.dart';
import 'package:bli/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final MapController mapController = MapController();

  // Bremen center coordinates
  static const LatLng bremenCenter = LatLng(53.0793, 8.8017);

  // Bremen bounding box (approximate city limits)
  static const double bremenMinLat = 52.96;
  static const double bremenMaxLat = 53.22;
  static const double bremenMinLon = 8.48;
  static const double bremenMaxLon = 9.01;

  void Function(String message)? onShowMessage;

  bool isWithinBremen(LatLng point) {
    return point.latitude >= bremenMinLat &&
        point.latitude <= bremenMaxLat &&
        point.longitude >= bremenMinLon &&
        point.longitude <= bremenMaxLon;
  }

  // State
  LocationMarker? _selectedMarker;
  LivabilityScore? _currentScore;
  bool _isLoading = false;
  String? _errorMessage;
  bool _showSearch = false;
  bool _showSlowLoadingMessage = false;
  Timer? _slowLoadingTimer;

  // Getters
  LocationMarker? get selectedMarker => _selectedMarker;
  LivabilityScore? get currentScore => _currentScore;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get showSearch => _showSearch;
  bool get showSlowLoadingMessage => _showSlowLoadingMessage;

  MapViewModel() {
    _checkApiHealth();
  }

  @override
  void dispose() {
    _slowLoadingTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkApiHealth() async {
    final isHealthy = await _apiService.checkHealth();
    if (!isHealthy) {
      _errorMessage =
          'API server is not available. Please start the backend server.';
      notifyListeners();
    }
  }

  void toggleSearch(bool show) {
    _showSearch = show;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetMap() {
    mapController.move(bremenCenter, 13.0);
    _selectedMarker = null;
    _currentScore = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _startSlowLoadingTimer() {
    _slowLoadingTimer?.cancel();
    _slowLoadingTimer = Timer(const Duration(seconds: 10), () {
      if (_isLoading) {
        _showSlowLoadingMessage = true;
        notifyListeners();
      }
    });
  }

  void _stopSlowLoadingTimer() {
    _slowLoadingTimer?.cancel();
    if (_showSlowLoadingMessage) {
      _showSlowLoadingMessage = false;
      notifyListeners();
    }
  }

  Future<void> onMapTap(TapPosition tapPosition, LatLng point) async {
    // If search is active, tapping map should close it
    if (_showSearch) {
      _showSearch = false;
      notifyListeners();
      return;
    }

    // Check if the point is within Bremen's data coverage area
    if (!isWithinBremen(point)) {
      onShowMessage?.call(
        'Data is only available for Bremen. Please select a location within the city.',
      );
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _selectedMarker = LocationMarker(position: point);
    _currentScore = null;
    _showSlowLoadingMessage = false;
    notifyListeners();

    _startSlowLoadingTimer();

    try {
      final score = await _apiService.analyzeLocation(
        point.latitude,
        point.longitude,
      );

      _stopSlowLoadingTimer();
      _currentScore = score;
      _selectedMarker = LocationMarker(position: point, score: score.score);
      _isLoading = false;
    } catch (e) {
      _stopSlowLoadingTimer();
      _errorMessage = 'Failed to analyze location: $e';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> onLocationSelected(LatLng location, String addressName) async {
    mapController.move(location, 16.0);

    // Analyze the selected location
    _isLoading = true;
    _errorMessage = null;
    _selectedMarker = LocationMarker(position: location);
    _currentScore = null;
    _showSlowLoadingMessage = false;
    _showSearch = false;
    notifyListeners();

    _startSlowLoadingTimer();

    try {
      final score = await _apiService.analyzeLocation(
        location.latitude,
        location.longitude,
      );

      _stopSlowLoadingTimer();
      _currentScore = score;
      _selectedMarker = LocationMarker(position: location, score: score.score);
      _isLoading = false;
    } catch (e) {
      _stopSlowLoadingTimer();
      _errorMessage = 'Failed to analyze location: $e';
      _isLoading = false;
    }
    notifyListeners();
  }
}
