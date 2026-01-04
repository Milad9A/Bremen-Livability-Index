import 'package:freezed_annotation/freezed_annotation.dart';

enum MetricCategory {
  @JsonValue('Greenery')
  greenery(['trees', 'parks']),
  @JsonValue('Amenities')
  amenities(['amenities']),
  @JsonValue('Public Transport')
  publicTransport(['public_transport']),
  @JsonValue('Healthcare')
  healthcare(['healthcare']),
  @JsonValue('Education')
  education(['education']),
  @JsonValue('Sports & Leisure')
  sportsLeisure(['sports_leisure']),
  @JsonValue('Cultural Venues')
  culturalVenues(['cultural_venues']),
  @JsonValue('Traffic Safety')
  trafficSafety(['accidents']),
  @JsonValue('Industrial Area')
  industrialArea(['industrial']),
  @JsonValue('Major Road')
  majorRoad(['major_roads']),
  @JsonValue('Noise Sources')
  noiseSources(['noise_sources']),
  @JsonValue('Bike Infrastructure')
  bikeInfrastructure(['bike_infrastructure']),
  @JsonValue('Pedestrian Infrastructure')
  pedestrianInfrastructure(['pedestrian_infrastructure']),
  @JsonValue('Railway')
  railway(['railways']),
  @JsonValue('Gas Station')
  gasStation(['gas_stations']),
  @JsonValue('Waste Facility')
  wasteFacility(['waste_facilities']),
  @JsonValue('Power Infrastructure')
  powerInfrastructure(['power_infrastructure']),
  @JsonValue('Large Parking')
  largeParking(['parking_lots']),
  @JsonValue('Airport/Helipad')
  airport(['airports']),
  @JsonValue('Construction Site')
  constructionSite(['construction_sites']),

  // Fallback for unexpected values
  @JsonValue('Unknown')
  unknown([]);

  /// The API response keys for nearby features that belong to this category.
  final List<String> featureKeys;

  const MetricCategory(this.featureKeys);
}

enum FeatureType {
  @JsonValue('tree')
  tree,

  @JsonValue('park')
  park,

  @JsonValue('amenity')
  amenity,

  @JsonValue('public_transport')
  publicTransport,

  @JsonValue('healthcare')
  healthcare,

  @JsonValue('education')
  education,

  @JsonValue('sports_leisure')
  sportsLeisure,

  @JsonValue('cultural_venue')
  culturalVenue,

  @JsonValue('noise_source')
  noiseSource,

  @JsonValue('accident')
  accident,

  @JsonValue('industrial')
  industrial,

  @JsonValue('major_road')
  majorRoad,

  @JsonValue('railway')
  railway,

  @JsonValue('airport')
  airport,

  @JsonValue('construction_site')
  constructionSite,

  @JsonValue('parking_lot')
  parkingLot,

  @JsonValue('power_infrastructure')
  powerInfrastructure,

  @JsonValue('waste_facility')
  wasteFacility,

  @JsonValue('gas_station')
  gasStation,

  @JsonValue('bike_infrastructure')
  bikeInfrastructure,

  @JsonValue('pedestrian_infrastructure')
  pedestrianInfrastructure,

  // Fallback
  @JsonValue('unknown')
  unknown,
}
