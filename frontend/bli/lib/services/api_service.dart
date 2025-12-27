import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Update this to match your backend URL
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
}

class LivabilityScore {
  final double score;
  final Location location;
  final List<Factor> factors;
  final String summary;

  LivabilityScore({
    required this.score,
    required this.location,
    required this.factors,
    required this.summary,
  });

  factory LivabilityScore.fromJson(Map<String, dynamic> json) {
    return LivabilityScore(
      score: (json['score'] as num).toDouble(),
      location: Location.fromJson(json['location']),
      factors: (json['factors'] as List)
          .map((f) => Factor.fromJson(f))
          .toList(),
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
