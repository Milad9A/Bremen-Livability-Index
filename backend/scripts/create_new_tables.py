"""Create new database tables for extended OSM metrics."""
import psycopg2
from config import settings

def create_tables():
    """Create the new tables for extended metrics."""
    conn = psycopg2.connect(settings.database_url)
    cursor = conn.cursor()

    tables_sql = """
    -- Table for bike infrastructure (positive factor)
    CREATE TABLE IF NOT EXISTS gis_data.bike_infrastructure (
        id SERIAL PRIMARY KEY,
        osm_id BIGINT,
        name TEXT,
        infra_type TEXT,
        geometry GEOGRAPHY(GEOMETRY, 4326),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Table for education facilities (positive factor)
    CREATE TABLE IF NOT EXISTS gis_data.education (
        id SERIAL PRIMARY KEY,
        osm_id BIGINT,
        name TEXT,
        education_type TEXT,
        geometry GEOGRAPHY(POINT, 4326),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Table for sports and leisure (positive factor)
    CREATE TABLE IF NOT EXISTS gis_data.sports_leisure (
        id SERIAL PRIMARY KEY,
        osm_id BIGINT,
        name TEXT,
        leisure_type TEXT,
        geometry GEOGRAPHY(POINT, 4326),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Table for pedestrian infrastructure (positive factor)
    CREATE TABLE IF NOT EXISTS gis_data.pedestrian_infrastructure (
        id SERIAL PRIMARY KEY,
        osm_id BIGINT,
        name TEXT,
        infra_type TEXT,
        geometry GEOGRAPHY(GEOMETRY, 4326),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Table for cultural venues (positive factor)
    CREATE TABLE IF NOT EXISTS gis_data.cultural_venues (
        id SERIAL PRIMARY KEY,
        osm_id BIGINT,
        name TEXT,
        venue_type TEXT,
        geometry GEOGRAPHY(POINT, 4326),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Table for noise sources (negative factor)
    CREATE TABLE IF NOT EXISTS gis_data.noise_sources (
        id SERIAL PRIMARY KEY,
        osm_id BIGINT,
        name TEXT,
        noise_type TEXT,
        geometry GEOGRAPHY(POINT, 4326),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Spatial indexes
    CREATE INDEX IF NOT EXISTS idx_bike_infrastructure_geometry ON gis_data.bike_infrastructure USING GIST(geometry);
    CREATE INDEX IF NOT EXISTS idx_education_geometry ON gis_data.education USING GIST(geometry);
    CREATE INDEX IF NOT EXISTS idx_sports_leisure_geometry ON gis_data.sports_leisure USING GIST(geometry);
    CREATE INDEX IF NOT EXISTS idx_pedestrian_infrastructure_geometry ON gis_data.pedestrian_infrastructure USING GIST(geometry);
    CREATE INDEX IF NOT EXISTS idx_cultural_venues_geometry ON gis_data.cultural_venues USING GIST(geometry);
    CREATE INDEX IF NOT EXISTS idx_noise_sources_geometry ON gis_data.noise_sources USING GIST(geometry);

    -- Type indexes
    CREATE INDEX IF NOT EXISTS idx_bike_infrastructure_type ON gis_data.bike_infrastructure(infra_type);
    CREATE INDEX IF NOT EXISTS idx_education_type ON gis_data.education(education_type);
    CREATE INDEX IF NOT EXISTS idx_sports_leisure_type ON gis_data.sports_leisure(leisure_type);
    CREATE INDEX IF NOT EXISTS idx_pedestrian_infrastructure_type ON gis_data.pedestrian_infrastructure(infra_type);
    CREATE INDEX IF NOT EXISTS idx_cultural_venues_type ON gis_data.cultural_venues(venue_type);
    CREATE INDEX IF NOT EXISTS idx_noise_sources_type ON gis_data.noise_sources(noise_type);
    """

    cursor.execute(tables_sql)
    conn.commit()
    cursor.close()
    conn.close()
    print("✅ New database tables created successfully")

if __name__ == "__main__":
    create_tables()
