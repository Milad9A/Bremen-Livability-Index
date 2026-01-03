-- Enable PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Create schema for spatial data
CREATE SCHEMA IF NOT EXISTS gis_data;

-- Table for trees (points)
CREATE TABLE IF NOT EXISTS gis_data.trees (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for parks (polygons)
CREATE TABLE IF NOT EXISTS gis_data.parks (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    geometry GEOGRAPHY(POLYGON, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for amenities (points)
CREATE TABLE IF NOT EXISTS gis_data.amenities (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    amenity_type TEXT,
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for traffic accidents
CREATE TABLE IF NOT EXISTS gis_data.accidents (
    id SERIAL PRIMARY KEY,
    accident_id TEXT,
    severity TEXT,
    date DATE,
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for public transport stops (positive factor)
CREATE TABLE IF NOT EXISTS gis_data.public_transport (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    transport_type TEXT, -- bus_stop, tram_stop
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for healthcare facilities (positive factor)
CREATE TABLE IF NOT EXISTS gis_data.healthcare (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    healthcare_type TEXT, -- hospital, pharmacy, doctors
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for industrial areas (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.industrial_areas (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for major roads (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.major_roads (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    road_type TEXT, -- primary, trunk, motorway
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for bike infrastructure (positive factor)
CREATE TABLE IF NOT EXISTS gis_data.bike_infrastructure (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    infra_type TEXT, -- cycleway, bike_lane, bicycle_parking, bicycle_rental
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for education facilities (positive factor)
CREATE TABLE IF NOT EXISTS gis_data.education (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    education_type TEXT, -- school, university, kindergarten, library
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for sports and leisure (positive factor)
CREATE TABLE IF NOT EXISTS gis_data.sports_leisure (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    leisure_type TEXT, -- sports_centre, swimming_pool, playground, pitch
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for pedestrian infrastructure (positive factor)
CREATE TABLE IF NOT EXISTS gis_data.pedestrian_infrastructure (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    infra_type TEXT, -- crossing, pedestrian_street, footway
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for cultural venues (positive factor)
CREATE TABLE IF NOT EXISTS gis_data.cultural_venues (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    venue_type TEXT, -- museum, theatre, cinema, gallery
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for noise sources (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.noise_sources (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    noise_type TEXT, -- nightclub, bar, pub
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for railway lines (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.railways (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    railway_type TEXT, -- rail, subway, tram, light_rail
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for gas stations (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.gas_stations (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    geometry GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for waste facilities (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.waste_facilities (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    waste_type TEXT, -- landfill, recycling, waste_transfer_station
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for power infrastructure (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.power_infrastructure (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    power_type TEXT, -- line, substation, plant
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for parking lots (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.parking_lots (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    parking_type TEXT, -- surface, multi-storey
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for airports/helipads (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.airports (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    airport_type TEXT, -- aerodrome, helipad
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for construction sites (negative factor)
CREATE TABLE IF NOT EXISTS gis_data.construction_sites (
    id SERIAL PRIMARY KEY,
    osm_id BIGINT,
    name TEXT,
    geometry GEOGRAPHY(GEOMETRY, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create spatial indexes
CREATE INDEX IF NOT EXISTS idx_trees_geometry ON gis_data.trees USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_parks_geometry ON gis_data.parks USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_amenities_geometry ON gis_data.amenities USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_accidents_geometry ON gis_data.accidents USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_public_transport_geometry ON gis_data.public_transport USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_healthcare_geometry ON gis_data.healthcare USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_industrial_areas_geometry ON gis_data.industrial_areas USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_major_roads_geometry ON gis_data.major_roads USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_bike_infrastructure_geometry ON gis_data.bike_infrastructure USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_education_geometry ON gis_data.education USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_sports_leisure_geometry ON gis_data.sports_leisure USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_pedestrian_infrastructure_geometry ON gis_data.pedestrian_infrastructure USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_cultural_venues_geometry ON gis_data.cultural_venues USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_noise_sources_geometry ON gis_data.noise_sources USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_railways_geometry ON gis_data.railways USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_gas_stations_geometry ON gis_data.gas_stations USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_waste_facilities_geometry ON gis_data.waste_facilities USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_power_infrastructure_geometry ON gis_data.power_infrastructure USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_parking_lots_geometry ON gis_data.parking_lots USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_airports_geometry ON gis_data.airports USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_construction_sites_geometry ON gis_data.construction_sites USING GIST(geometry);

-- Additional indexes
CREATE INDEX IF NOT EXISTS idx_amenities_type ON gis_data.amenities(amenity_type);
CREATE INDEX IF NOT EXISTS idx_accidents_date ON gis_data.accidents(date);
CREATE INDEX IF NOT EXISTS idx_public_transport_type ON gis_data.public_transport(transport_type);
CREATE INDEX IF NOT EXISTS idx_healthcare_type ON gis_data.healthcare(healthcare_type);
CREATE INDEX IF NOT EXISTS idx_major_roads_type ON gis_data.major_roads(road_type);
CREATE INDEX IF NOT EXISTS idx_bike_infrastructure_type ON gis_data.bike_infrastructure(infra_type);
CREATE INDEX IF NOT EXISTS idx_education_type ON gis_data.education(education_type);
CREATE INDEX IF NOT EXISTS idx_sports_leisure_type ON gis_data.sports_leisure(leisure_type);
CREATE INDEX IF NOT EXISTS idx_pedestrian_infrastructure_type ON gis_data.pedestrian_infrastructure(infra_type);
CREATE INDEX IF NOT EXISTS idx_cultural_venues_type ON gis_data.cultural_venues(venue_type);
CREATE INDEX IF NOT EXISTS idx_noise_sources_type ON gis_data.noise_sources(noise_type);
CREATE INDEX IF NOT EXISTS idx_railways_type ON gis_data.railways(railway_type);
CREATE INDEX IF NOT EXISTS idx_waste_facilities_type ON gis_data.waste_facilities(waste_type);
CREATE INDEX IF NOT EXISTS idx_power_infrastructure_type ON gis_data.power_infrastructure(power_type);
CREATE INDEX IF NOT EXISTS idx_parking_lots_type ON gis_data.parking_lots(parking_type);
CREATE INDEX IF NOT EXISTS idx_airports_type ON gis_data.airports(airport_type);


