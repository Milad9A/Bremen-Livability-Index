import 'package:bli/models/enums.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FeatureStyles {
  // Color mapping for Factors (MetricCategory)
  static Color getFactorColor(MetricCategory category) {
    switch (category) {
      case MetricCategory.greenery:
        return Colors.green;
      case MetricCategory.amenities:
        return Colors.blue;
      case MetricCategory.publicTransport:
        return Colors.indigo;
      case MetricCategory.healthcare:
        return Colors.red;
      case MetricCategory.trafficSafety:
        return Colors.orange;
      case MetricCategory.industrialArea:
        return AppColors.greyMedium;
      case MetricCategory.majorRoad:
        return AppColors.black.withValues(alpha: 0.54);
      case MetricCategory.bikeInfrastructure:
        return Colors.cyan;
      case MetricCategory.education:
        return Colors.purple;
      case MetricCategory.sportsLeisure:
        return Colors.amber;
      case MetricCategory.pedestrianInfrastructure:
        return Colors.lime;
      case MetricCategory.culturalVenues:
        return Colors.pinkAccent;
      case MetricCategory.noiseSources:
        return Colors.deepOrange;
      case MetricCategory.railway:
        return Colors.blueGrey;
      case MetricCategory.gasStation:
        return Colors.deepOrange;
      case MetricCategory.wasteFacility:
        return Colors.brown;
      case MetricCategory.powerInfrastructure:
        return Colors.yellow[800]!;
      case MetricCategory.largeParking:
        return Colors.grey;
      case MetricCategory.airport:
        return Colors.blue;
      case MetricCategory.constructionSite:
        return Colors.orangeAccent;
      case MetricCategory.unknown:
        return AppColors.greyLight;
    }
  }

  // Icon mapping for Factors (MetricCategory)
  static IconData getFactorIcon(MetricCategory category) {
    switch (category) {
      case MetricCategory.greenery:
        return Icons.nature;
      case MetricCategory.amenities:
        return Icons.store;
      case MetricCategory.publicTransport:
        return Icons.directions_bus;
      case MetricCategory.healthcare:
        return Icons.local_hospital;
      case MetricCategory.bikeInfrastructure:
        return Icons.directions_bike;
      case MetricCategory.education:
        return Icons.school;
      case MetricCategory.sportsLeisure:
        return Icons.sports_soccer;
      case MetricCategory.pedestrianInfrastructure:
        return Icons.accessibility_new;
      case MetricCategory.culturalVenues:
        return Icons.palette;
      case MetricCategory.trafficSafety:
        return Icons.warning;
      case MetricCategory.industrialArea:
        return Icons.factory;
      case MetricCategory.majorRoad:
        return Icons.add_road;
      case MetricCategory.noiseSources:
        return Icons.volume_up;
      case MetricCategory.railway:
        return Icons.train;
      case MetricCategory.gasStation:
        return Icons.local_gas_station;
      case MetricCategory.wasteFacility:
        return Icons.delete;
      case MetricCategory.powerInfrastructure:
        return Icons.electrical_services;
      case MetricCategory.largeParking:
        return Icons.local_parking;
      case MetricCategory.airport:
        return Icons.flight;
      case MetricCategory.constructionSite:
        return Icons.construction;
      case MetricCategory.unknown:
        return Icons.help_outline;
    }
  }

  // Color mapping for Feature Types
  static Color getFeatureColor(FeatureType type) {
    switch (type) {
      case FeatureType.tree:
      case FeatureType.park:
        return Colors.green;
      case FeatureType.amenity:
        return Colors.blue;
      case FeatureType.publicTransport:
        return Colors.indigo;
      case FeatureType.healthcare:
        return Colors.red;
      case FeatureType.accident:
        return Colors.orange;
      case FeatureType.industrial:
        return AppColors.greyMedium;
      case FeatureType.majorRoad:
        return AppColors.black.withValues(alpha: 0.54);
      case FeatureType.bikeInfrastructure:
        return Colors.cyan;
      case FeatureType.education:
        return Colors.purple;
      case FeatureType.sportsLeisure:
        return Colors.amber;
      case FeatureType.pedestrianInfrastructure:
        return Colors.lime;
      case FeatureType.culturalVenue:
        return Colors.pinkAccent;
      case FeatureType.noiseSource:
        return Colors.deepOrange;
      case FeatureType.railway:
        return Colors.blueGrey;
      case FeatureType.gasStation:
        return Colors.deepOrange;
      case FeatureType.wasteFacility:
        return Colors.brown;
      case FeatureType.powerInfrastructure:
        return Colors.yellow[800]!;
      case FeatureType.parkingLot:
        return Colors.grey;
      case FeatureType.airport:
        return Colors.blue;
      case FeatureType.constructionSite:
        return Colors.orangeAccent;
      case FeatureType.unknown:
        return AppColors.greyMedium;
    }
  }

  static IconData getFeatureIcon(FeatureType type, {String? subtype}) {
    // If subtype is available, try to find a specific icon first
    if (subtype != null) {
      final sub = subtype.toLowerCase();
      // Amenities
      if (sub.contains('restaurant') ||
          sub.contains('cafe') ||
          sub.contains('food')) {
        return Icons.restaurant;
      }
      if (sub.contains('school') ||
          sub.contains('university') ||
          sub.contains('college')) {
        return Icons.school;
      }
      if (sub.contains('pub') || sub.contains('bar')) return Icons.local_bar;
      if (sub.contains('bank') || sub.contains('atm')) {
        return Icons.account_balance;
      }
      if (sub.contains('pharmacy')) return Icons.local_pharmacy;
      if (sub.contains('hospital') ||
          sub.contains('clinic') ||
          sub.contains('doctor')) {
        return Icons.local_hospital;
      }
      if (sub.contains('cinema') || sub.contains('theatre')) return Icons.movie;
      if (sub.contains('worship') || sub.contains('church')) {
        return Icons.church;
      }

      // Transport
      if (sub.contains('bus')) return Icons.directions_bus;
      if (sub.contains('tram')) return Icons.tram;
      if (sub.contains('train')) return Icons.train;

      // Education
      if (sub.contains('university')) return Icons.school;
      if (sub.contains('kindergarten')) return Icons.child_care;
      if (sub.contains('library')) return Icons.local_library;

      // Sports
      if (sub.contains('swimming')) return Icons.pool;
      if (sub.contains('playground')) return Icons.toys;
      if (sub.contains('fitness')) return Icons.fitness_center;
      if (sub.contains('pitch') || sub.contains('sports_centre')) {
        return Icons.stadium;
      }

      // Culture
      if (sub.contains('museum')) return Icons.museum;
      if (sub.contains('art')) return Icons.palette;
    }

    // Fallback to type-based icon if no specific subtype match
    switch (type) {
      case FeatureType.tree:
        return Icons.nature;
      case FeatureType.park:
        return Icons.park;
      case FeatureType.amenity:
        return Icons.store;
      case FeatureType.publicTransport:
        return Icons.directions_bus;
      case FeatureType.healthcare:
        return Icons.local_hospital;
      case FeatureType.bikeInfrastructure:
        return Icons.directions_bike;
      case FeatureType.education:
        return Icons.school;
      case FeatureType.sportsLeisure:
        return Icons.sports_soccer;
      case FeatureType.pedestrianInfrastructure:
        return Icons.accessibility_new;
      case FeatureType.culturalVenue:
        return Icons.location_city;
      case FeatureType.noiseSource:
        return Icons.volume_up;
      case FeatureType.accident:
        return Icons.warning;
      case FeatureType.industrial:
        return Icons.factory;
      case FeatureType.majorRoad:
        return Icons.add_road;
      case FeatureType.railway:
        return Icons.train;
      case FeatureType.gasStation:
        return Icons.local_gas_station;
      case FeatureType.wasteFacility:
        return Icons.delete;
      case FeatureType.powerInfrastructure:
        return Icons.electrical_services;
      case FeatureType.parkingLot:
        return Icons.local_parking;
      case FeatureType.airport:
        return Icons.flight;
      case FeatureType.constructionSite:
        return Icons.construction;
      case FeatureType.unknown:
        return Icons.help_outline;
    }
  }
}
