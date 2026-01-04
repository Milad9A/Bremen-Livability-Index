import 'package:freezed_annotation/freezed_annotation.dart';

enum MetricCategory {
  @JsonValue('Greenery')
  greenery,
  @JsonValue('Amenities')
  amenities,
  @JsonValue('Public Transport')
  publicTransport,
  @JsonValue('Healthcare')
  healthcare,
  @JsonValue('Education')
  education,
  @JsonValue('Sports & Leisure')
  sportsLeisure,
  @JsonValue('Cultural Venues')
  culturalVenues,
  @JsonValue('Traffic Safety')
  trafficSafety,
  @JsonValue('Industrial Area')
  industrialArea,
  @JsonValue('Major Road')
  majorRoad,
  @JsonValue('Noise Sources')
  noiseSources,
  @JsonValue('Bike Infrastructure')
  bikeInfrastructure,
  @JsonValue('Pedestrian Infrastructure')
  pedestrianInfrastructure,
  @JsonValue('Railway')
  railway,
  @JsonValue('Gas Station')
  gasStation,
  @JsonValue('Waste Facility')
  wasteFacility,
  @JsonValue('Power Infrastructure')
  powerInfrastructure,
  @JsonValue('Large Parking')
  largeParking,
  @JsonValue('Airport/Helipad')
  airport,
  @JsonValue('Construction Site')
  constructionSite,

  // Fallback for unexpected values
  @JsonValue('Unknown')
  unknown,
}

enum FeatureType {
  @JsonValue('tree')
  @JsonValue('trees')
  tree,

  @JsonValue('park')
  @JsonValue('parks')
  park,

  @JsonValue('amenity')
  @JsonValue('amenities')
  amenity,

  @JsonValue('public_transport')
  publicTransport,

  @JsonValue('healthcare')
  healthcare,

  @JsonValue('education')
  education,

  @JsonValue('sports_leisure')
  @JsonValue('sports')
  sportsLeisure,

  @JsonValue('cultural_venue')
  @JsonValue('cultural_venues')
  culturalVenue,

  @JsonValue('noise_source')
  @JsonValue('noise_sources')
  noiseSource,

  @JsonValue('accident')
  @JsonValue('accidents')
  accident,

  @JsonValue('industrial')
  industrial,

  @JsonValue('major_road')
  @JsonValue('major_roads')
  majorRoad,

  @JsonValue('railway')
  @JsonValue('railways')
  railway,

  @JsonValue('airport')
  @JsonValue('airports')
  airport,

  @JsonValue('construction_site')
  @JsonValue('construction_sites')
  constructionSite,

  @JsonValue('parking_lot')
  @JsonValue('parking_lots')
  parkingLot,

  @JsonValue('power_infrastructure')
  powerInfrastructure,

  @JsonValue('waste_facility')
  @JsonValue('waste_facilities')
  wasteFacility,

  @JsonValue('gas_station')
  @JsonValue('gas_stations')
  gasStation,

  @JsonValue('bike_infrastructure')
  bikeInfrastructure,

  @JsonValue('pedestrian_infrastructure')
  pedestrianInfrastructure,
}
