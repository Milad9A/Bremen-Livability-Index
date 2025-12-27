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

-- Create spatial indexes
CREATE INDEX IF NOT EXISTS idx_trees_geometry ON gis_data.trees USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_parks_geometry ON gis_data.parks USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_amenities_geometry ON gis_data.amenities USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_accidents_geometry ON gis_data.accidents USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_public_transport_geometry ON gis_data.public_transport USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_healthcare_geometry ON gis_data.healthcare USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_industrial_areas_geometry ON gis_data.industrial_areas USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_major_roads_geometry ON gis_data.major_roads USING GIST(geometry);

-- Additional indexes
CREATE INDEX IF NOT EXISTS idx_amenities_type ON gis_data.amenities(amenity_type);
CREATE INDEX IF NOT EXISTS idx_accidents_date ON gis_data.accidents(date);
CREATE INDEX IF NOT EXISTS idx_public_transport_type ON gis_data.public_transport(transport_type);
CREATE INDEX IF NOT EXISTS idx_healthcare_type ON gis_data.healthcare(healthcare_type);
CREATE INDEX IF NOT EXISTS idx_major_roads_type ON gis_data.major_roads(road_type);


