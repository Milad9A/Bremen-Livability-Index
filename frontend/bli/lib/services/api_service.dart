import 'package:bli/models/models.dart';
import 'package:dio/dio.dart';

class ApiService {
  // Production (Render)
  static const String baseUrl =
      'https://bremen-livability-backend.onrender.com';
  // Local (Emulator: 10.0.2.2:8000, iOS: localhost:8000)
  // static const String baseUrl = 'http://localhost:8000';

  final Dio _dio;

  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  Future<LivabilityScore> analyzeLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _dio.post(
        '/analyze',
        data: {'latitude': latitude, 'longitude': longitude},
      );

      return LivabilityScore.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to analyze location: ${e.message}');
    } catch (e) {
      throw Exception('Error connecting to API: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
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
      final response = await _dio.post(
        '/geocode',
        data: {'query': query, 'limit': limit},
      );

      return (response.data['results'] as List)
          .map((r) => GeocodeResult.fromJson(r))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to geocode address: ${e.message}');
    } catch (e) {
      throw Exception('Error geocoding address: $e');
    }
  }
}
