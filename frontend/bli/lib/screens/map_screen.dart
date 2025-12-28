import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/location_marker.dart';
import '../widgets/score_card.dart';
import '../widgets/address_search.dart';
import '../widgets/nearby_feature_layers.dart';

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
  bool _showSearch = false;
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
      setState(() {
        _errorMessage =
            'API server is not available. Please start the backend server.';
      });
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
    // Move map to selected location
    _mapController.move(location, 15.0);

    // Analyze the selected location
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedMarker = LocationMarker(position: location);
      _currentScore = null;
      _showSlowLoadingMessage = false;
    });

    _startSlowLoadingTimer();

    try {
      final score = await _apiService.analyzeLocation(
        location.latitude,
        location.longitude,
      );

      _stopSlowLoadingTimer();
      setState(() {
        _currentScore = score;
        _selectedMarker = LocationMarker(
          position: location,
          score: score.score,
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bremen Livability Index'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
              });
            },
            tooltip: 'Search address',
            icon: Icon(_showSearch ? Icons.close : Icons.search),
          ),
          IconButton(
            onPressed: () {
              _mapController.move(bremenCenter, 13.0);
              setState(() {
                _selectedMarker = null;
                _currentScore = null;
                _errorMessage = null;
              });
            },
            tooltip: 'Center on Bremen',
            icon: const Icon(Icons.my_location),
          ),
        ],
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
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
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        color: _selectedMarker!.score != null
                            ? getScoreColor(_selectedMarker!.score!)
                            : Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_errorMessage != null)
            ErrorBanner(
              message: _errorMessage!,
              onDismiss: () {
                setState(() {
                  _errorMessage = null;
                });
              },
            ),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  if (_showSlowLoadingMessage) ...const [SizedBox(height: 20)],
                  if (_showSlowLoadingMessage)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.blue[700],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Server is starting up...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'The server may take up to 50 seconds to wake up after being idle.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          if (_currentScore != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ScoreCard(score: _currentScore!),
            ),
          if (_showSearch)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: AddressSearchWidget(
                onLocationSelected: _onLocationSelected,
                onClose: () {
                  setState(() {
                    _showSearch = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Card(
        color: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[900]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(message, style: TextStyle(color: Colors.red[900])),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: onDismiss),
            ],
          ),
        ),
      ),
    );
  }
}
