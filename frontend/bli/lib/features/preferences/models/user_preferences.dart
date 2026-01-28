/// Importance level for scoring factors.
///
/// - [excluded]: Factor is completely ignored (0x multiplier)
/// - [low]: Factor has reduced impact (0.5x multiplier)
/// - [medium]: Default importance (1.0x multiplier)
/// - [high]: Factor has increased impact (1.5x multiplier)
enum ImportanceLevel {
  excluded,
  low,
  medium,
  high;

  /// Convert to JSON string value
  String toJson() => name;

  /// Parse from JSON string
  static ImportanceLevel fromJson(String value) {
    return ImportanceLevel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ImportanceLevel.medium,
    );
  }

  /// Human-readable label
  String get label {
    switch (this) {
      case ImportanceLevel.excluded:
        return 'Off';
      case ImportanceLevel.low:
        return 'Low';
      case ImportanceLevel.medium:
        return 'Med';
      case ImportanceLevel.high:
        return 'High';
    }
  }
}

/// User preferences for factor importance levels.
///
/// All factors default to [ImportanceLevel.medium] which applies
/// a 1.0x multiplier (standard scoring behavior).
class UserPreferences {
  // Positive factors
  final ImportanceLevel greenery;
  final ImportanceLevel amenities;
  final ImportanceLevel publicTransport;
  final ImportanceLevel healthcare;
  final ImportanceLevel bikeInfrastructure;
  final ImportanceLevel education;
  final ImportanceLevel sportsLeisure;
  final ImportanceLevel pedestrianInfrastructure;
  final ImportanceLevel cultural;

  // Negative factors
  final ImportanceLevel accidents;
  final ImportanceLevel industrial;
  final ImportanceLevel majorRoads;
  final ImportanceLevel noise;
  final ImportanceLevel railway;
  final ImportanceLevel gasStation;
  final ImportanceLevel waste;
  final ImportanceLevel power;
  final ImportanceLevel parking;
  final ImportanceLevel airport;
  final ImportanceLevel construction;

  const UserPreferences({
    this.greenery = ImportanceLevel.medium,
    this.amenities = ImportanceLevel.medium,
    this.publicTransport = ImportanceLevel.medium,
    this.healthcare = ImportanceLevel.medium,
    this.bikeInfrastructure = ImportanceLevel.medium,
    this.education = ImportanceLevel.medium,
    this.sportsLeisure = ImportanceLevel.medium,
    this.pedestrianInfrastructure = ImportanceLevel.medium,
    this.cultural = ImportanceLevel.medium,
    this.accidents = ImportanceLevel.medium,
    this.industrial = ImportanceLevel.medium,
    this.majorRoads = ImportanceLevel.medium,
    this.noise = ImportanceLevel.medium,
    this.railway = ImportanceLevel.medium,
    this.gasStation = ImportanceLevel.medium,
    this.waste = ImportanceLevel.medium,
    this.power = ImportanceLevel.medium,
    this.parking = ImportanceLevel.medium,
    this.airport = ImportanceLevel.medium,
    this.construction = ImportanceLevel.medium,
  });

  /// Default preferences with all factors set to medium
  static const UserPreferences defaults = UserPreferences();

  /// Check if preferences differ from defaults
  bool get isCustomized => this != defaults;

  /// Convert to JSON map for API requests
  Map<String, String> toJson() {
    return {
      'greenery': greenery.toJson(),
      'amenities': amenities.toJson(),
      'public_transport': publicTransport.toJson(),
      'healthcare': healthcare.toJson(),
      'bike_infrastructure': bikeInfrastructure.toJson(),
      'education': education.toJson(),
      'sports_leisure': sportsLeisure.toJson(),
      'pedestrian_infrastructure': pedestrianInfrastructure.toJson(),
      'cultural': cultural.toJson(),
      'accidents': accidents.toJson(),
      'industrial': industrial.toJson(),
      'major_roads': majorRoads.toJson(),
      'noise': noise.toJson(),
      'railway': railway.toJson(),
      'gas_station': gasStation.toJson(),
      'waste': waste.toJson(),
      'power': power.toJson(),
      'parking': parking.toJson(),
      'airport': airport.toJson(),
      'construction': construction.toJson(),
    };
  }

  /// Parse from JSON map
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      greenery: ImportanceLevel.fromJson(json['greenery'] ?? 'medium'),
      amenities: ImportanceLevel.fromJson(json['amenities'] ?? 'medium'),
      publicTransport: ImportanceLevel.fromJson(
        json['public_transport'] ?? 'medium',
      ),
      healthcare: ImportanceLevel.fromJson(json['healthcare'] ?? 'medium'),
      bikeInfrastructure: ImportanceLevel.fromJson(
        json['bike_infrastructure'] ?? 'medium',
      ),
      education: ImportanceLevel.fromJson(json['education'] ?? 'medium'),
      sportsLeisure: ImportanceLevel.fromJson(
        json['sports_leisure'] ?? 'medium',
      ),
      pedestrianInfrastructure: ImportanceLevel.fromJson(
        json['pedestrian_infrastructure'] ?? 'medium',
      ),
      cultural: ImportanceLevel.fromJson(json['cultural'] ?? 'medium'),
      accidents: ImportanceLevel.fromJson(json['accidents'] ?? 'medium'),
      industrial: ImportanceLevel.fromJson(json['industrial'] ?? 'medium'),
      majorRoads: ImportanceLevel.fromJson(json['major_roads'] ?? 'medium'),
      noise: ImportanceLevel.fromJson(json['noise'] ?? 'medium'),
      railway: ImportanceLevel.fromJson(json['railway'] ?? 'medium'),
      gasStation: ImportanceLevel.fromJson(json['gas_station'] ?? 'medium'),
      waste: ImportanceLevel.fromJson(json['waste'] ?? 'medium'),
      power: ImportanceLevel.fromJson(json['power'] ?? 'medium'),
      parking: ImportanceLevel.fromJson(json['parking'] ?? 'medium'),
      airport: ImportanceLevel.fromJson(json['airport'] ?? 'medium'),
      construction: ImportanceLevel.fromJson(json['construction'] ?? 'medium'),
    );
  }

  /// Create a copy with updated fields
  UserPreferences copyWith({
    ImportanceLevel? greenery,
    ImportanceLevel? amenities,
    ImportanceLevel? publicTransport,
    ImportanceLevel? healthcare,
    ImportanceLevel? bikeInfrastructure,
    ImportanceLevel? education,
    ImportanceLevel? sportsLeisure,
    ImportanceLevel? pedestrianInfrastructure,
    ImportanceLevel? cultural,
    ImportanceLevel? accidents,
    ImportanceLevel? industrial,
    ImportanceLevel? majorRoads,
    ImportanceLevel? noise,
    ImportanceLevel? railway,
    ImportanceLevel? gasStation,
    ImportanceLevel? waste,
    ImportanceLevel? power,
    ImportanceLevel? parking,
    ImportanceLevel? airport,
    ImportanceLevel? construction,
  }) {
    return UserPreferences(
      greenery: greenery ?? this.greenery,
      amenities: amenities ?? this.amenities,
      publicTransport: publicTransport ?? this.publicTransport,
      healthcare: healthcare ?? this.healthcare,
      bikeInfrastructure: bikeInfrastructure ?? this.bikeInfrastructure,
      education: education ?? this.education,
      sportsLeisure: sportsLeisure ?? this.sportsLeisure,
      pedestrianInfrastructure:
          pedestrianInfrastructure ?? this.pedestrianInfrastructure,
      cultural: cultural ?? this.cultural,
      accidents: accidents ?? this.accidents,
      industrial: industrial ?? this.industrial,
      majorRoads: majorRoads ?? this.majorRoads,
      noise: noise ?? this.noise,
      railway: railway ?? this.railway,
      gasStation: gasStation ?? this.gasStation,
      waste: waste ?? this.waste,
      power: power ?? this.power,
      parking: parking ?? this.parking,
      airport: airport ?? this.airport,
      construction: construction ?? this.construction,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferences &&
          greenery == other.greenery &&
          amenities == other.amenities &&
          publicTransport == other.publicTransport &&
          healthcare == other.healthcare &&
          bikeInfrastructure == other.bikeInfrastructure &&
          education == other.education &&
          sportsLeisure == other.sportsLeisure &&
          pedestrianInfrastructure == other.pedestrianInfrastructure &&
          cultural == other.cultural &&
          accidents == other.accidents &&
          industrial == other.industrial &&
          majorRoads == other.majorRoads &&
          noise == other.noise &&
          railway == other.railway &&
          gasStation == other.gasStation &&
          waste == other.waste &&
          power == other.power &&
          parking == other.parking &&
          airport == other.airport &&
          construction == other.construction;

  @override
  int get hashCode => Object.hash(
    greenery,
    amenities,
    publicTransport,
    healthcare,
    bikeInfrastructure,
    education,
    sportsLeisure,
    pedestrianInfrastructure,
    cultural,
    accidents,
    industrial,
    majorRoads,
    noise,
    railway,
    gasStation,
    waste,
    power,
    parking,
    airport,
    construction,
  );
}
