import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/location_marker.dart';
import '../widgets/score_card.dart';
import '../widgets/address_search.dart';
import '../widgets/nearby_feature_layers.dart';
import '../widgets/glass_container.dart';
import '../widgets/floating_search_bar.dart';
import '../widgets/loading_overlay.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final ApiService _apiService = ApiService();

  // Bremen center coordinates
  static const LatLng bremenCenter = LatLng(53.0793, 8.8017);

  LocationMarker? _selectedMarker;
  LivabilityScore? _currentScore;
  bool _isLoading = false;
  String? _errorMessage;
  bool _showSearch = false; // Controls if the full search widget is active
  bool _showSlowLoadingMessage = false;
  Timer? _slowLoadingTimer;

  @override
  void initState() {
    super.initState();
    _checkApiHealth();
  }

  Future<void> _checkApiHealth() async {
    final isHealthy = await _apiService.checkHealth();
    if (!isHealthy && mounted) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'API server is not available. Please start the backend server.';
        });
      }
    }
  }

  void _startSlowLoadingTimer() {
    _slowLoadingTimer?.cancel();
    _slowLoadingTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        setState(() {
          _showSlowLoadingMessage = true;
        });
      }
    });
  }

  void _stopSlowLoadingTimer() {
    _slowLoadingTimer?.cancel();
    if (_showSlowLoadingMessage) {
      setState(() {
        _showSlowLoadingMessage = false;
      });
    }
  }

  @override
  void dispose() {
    _slowLoadingTimer?.cancel();
    super.dispose();
  }

  Future<void> _onMapTap(TapPosition tapPosition, LatLng point) async {
    // If search is active, tapping map should close it
    if (_showSearch) {
      setState(() {
        _showSearch = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedMarker = LocationMarker(position: point);
      _currentScore = null;
      _showSlowLoadingMessage = false;
    });

    _startSlowLoadingTimer();

    try {
      final score = await _apiService.analyzeLocation(
        point.latitude,
        point.longitude,
      );

      _stopSlowLoadingTimer();
      setState(() {
        _currentScore = score;
        _selectedMarker = LocationMarker(position: point, score: score.score);
        _isLoading = false;
      });
    } catch (e) {
      _stopSlowLoadingTimer();
      setState(() {
        _errorMessage = 'Failed to analyze location: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _onLocationSelected(LatLng location, String addressName) async {
    _mapController.move(location, 16.0);

    // Analyze the selected location
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedMarker = LocationMarker(position: location);
      _currentScore = null;
      _showSlowLoadingMessage = false;
      _showSearch = false;
    });

    _startSlowLoadingTimer();

    try {
      final score = await _apiService.analyzeLocation(
        location.latitude,
        location.longitude,
      );

      _stopSlowLoadingTimer();
      if (mounted) {
        setState(() {
          _currentScore = score;
          _selectedMarker = LocationMarker(
            position: location,
            score: score.score,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      _stopSlowLoadingTimer();
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to analyze location: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent map from resizing when keyboard opens
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: bremenCenter,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.bli',
                maxZoom: 19,
              ),
              if (_currentScore != null)
                NearbyFeatureLayers(
                  nearbyFeatures: _currentScore!.nearbyFeatures,
                ),
              if (_selectedMarker != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedMarker!.position,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.location_on,
                        color: _selectedMarker!.score != null
                            ? getScoreColor(_selectedMarker!.score!)
                            : Colors.teal,
                        size: 50,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 80, // Leave space for the location button on the right
            child: _showSearch
                ? AddressSearchWidget(
                    onLocationSelected: _onLocationSelected,
                    onClose: () {
                      setState(() {
                        _showSearch = false;
                      });
                    },
                  )
                : FloatingSearchBar(
                    onTap: () {
                      setState(() {
                        _showSearch = true;
                      });
                    },
                  ),
          ),

          if (_errorMessage != null)
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  80, // push down below search
              left: 16,
              right: 16,
              child: Card(
                color: Colors.red[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[900]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _errorMessage = null),
                        color: Colors.red[900],
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_isLoading)
            LoadingOverlay(showSlowLoadingMessage: _showSlowLoadingMessage),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _mapController.move(bremenCenter, 13.0);
                setState(() {
                  _selectedMarker = null;
                  _currentScore = null;
                  _errorMessage = null;
                });
              },
              child: GlassContainer(
                borderRadius: 30, // Circle
                padding: const EdgeInsets.all(14),
                child: Icon(Icons.my_location, color: Colors.teal[800]),
              ),
            ),
          ),

          if (_currentScore != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: ScoreCard(score: _currentScore!),
            ),
        ],
      ),
    );
  }
}
