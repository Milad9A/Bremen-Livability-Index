import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/location_marker.dart';
import '../widgets/score_card.dart';

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

  Future<void> _onMapTap(TapPosition tapPosition, LatLng point) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedMarker = LocationMarker(position: point);
      _currentScore = null;
    });

    try {
      final score = await _apiService.analyzeLocation(
        point.latitude,
        point.longitude,
      );

      setState(() {
        _currentScore = score;
        _selectedMarker = LocationMarker(position: point, score: score.score);
        _isLoading = false;
      });
    } catch (e) {
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
                            ? _getScoreColor(_selectedMarker!.score!)
                            : Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_errorMessage != null)
            Positioned(
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
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_currentScore != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ScoreCard(score: _currentScore!),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.move(bremenCenter, 13.0);
          setState(() {
            _selectedMarker = null;
            _currentScore = null;
            _errorMessage = null;
          });
        },
        tooltip: 'Center on Bremen',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 70) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}
