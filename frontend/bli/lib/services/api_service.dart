import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Production (Render)
  // static const String baseUrl = 'https://bremen-livability-index.onrender.com';
  // Local (Emulator: 10.0.2.2:8000, iOS: localhost:8000)
  static const String baseUrl = 'http://localhost:8000';

  Future<LivabilityScore> analyzeLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LivabilityScore.fromJson(data);
      } else {
        throw Exception('Failed to analyze location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to API: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<GeocodeResult>> geocodeAddress(
    String query, {
    int limit = 5,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/geocode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query, 'limit': limit}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List)
            .map((r) => GeocodeResult.fromJson(r))
            .toList();
      } else {
        throw Exception('Failed to geocode address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error geocoding address: $e');
    }
  }
}

class LivabilityScore {
  final double score;
  final Location location;
  final List<Factor> factors;
  final Map<String, List<FeatureDetail>> nearbyFeatures;
  final String summary;

  LivabilityScore({
    required this.score,
    required this.location,
    required this.factors,
    required this.nearbyFeatures,
    required this.summary,
  });

  factory LivabilityScore.fromJson(Map<String, dynamic> json) {
    var featuresJson = json['nearby_features'] as Map<String, dynamic>? ?? {};
    var features = featuresJson.map((key, value) {
      var list = (value as List).map((i) => FeatureDetail.fromJson(i)).toList();
      return MapEntry(key, list);
    });

    return LivabilityScore(
      score: (json['score'] as num).toDouble(),
      location: Location.fromJson(json['location']),
      factors: (json['factors'] as List)
          .map((f) => Factor.fromJson(f))
          .toList(),
      nearbyFeatures: features,
      summary: json['summary'] as String,
    );
  }

  // Get color based on score
  String get scoreColor {
    if (score >= 70) return '#4CAF50'; // Green
    if (score >= 50) return '#FF9800'; // Orange
    return '#F44336'; // Red
  }
}

class FeatureDetail {
  final int? id;
  final String? name;
  final String type;
  final String? subtype;
  final double distance;
  final Map<String, dynamic> geometry;

  FeatureDetail({
    this.id,
    this.name,
    required this.type,
    this.subtype,
    required this.distance,
    required this.geometry,
  });

  factory FeatureDetail.fromJson(Map<String, dynamic> json) {
    return FeatureDetail(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String,
      subtype: json['subtype'] as String?,
      distance: (json['distance'] as num).toDouble(),
      geometry: json['geometry'] as Map<String, dynamic>,
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class Factor {
  final String factor;
  final double value;
  final String description;
  final String impact;

  Factor({
    required this.factor,
    required this.value,
    required this.description,
    required this.impact,
  });

  factory Factor.fromJson(Map<String, dynamic> json) {
    return Factor(
      factor: json['factor'] as String,
      value: (json['value'] as num).toDouble(),
      description: json['description'] as String,
      impact: json['impact'] as String,
    );
  }
}

class GeocodeResult {
  final double latitude;
  final double longitude;
  final String displayName;
  final Map<String, dynamic> address;
  final String type;
  final double importance;

  GeocodeResult({
    required this.latitude,
    required this.longitude,
    required this.displayName,
    required this.address,
    required this.type,
    required this.importance,
  });

  factory GeocodeResult.fromJson(Map<String, dynamic> json) {
    return GeocodeResult(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      displayName: json['display_name'] as String,
      address: json['address'] as Map<String, dynamic>,
      type: json['type'] as String,
      importance: (json['importance'] as num).toDouble(),
    );
  }
}
