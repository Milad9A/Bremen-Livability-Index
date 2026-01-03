"""Ingest OpenStreetMap data for Bremen livability scoring."""
import overpy
import psycopg2
from config import settings
import time
import random

# Bremen bounding box
BREMEN_BBOX = {"south": 53.0, "west": 8.5, "north": 53.2, "east": 9.0}

def get_bbox_str():
    return f"{BREMEN_BBOX['south']},{BREMEN_BBOX['west']},{BREMEN_BBOX['north']},{BREMEN_BBOX['east']}"

def query_with_retry(api, query, max_retries=5):
    """Query Overpass API with retry logic."""
    for attempt in range(max_retries):
        try:
            print(f"Querying Overpass API (attempt {attempt + 1}/{max_retries})...")
            return api.query(query)
        except (overpy.exception.OverpassTooManyRequests, overpy.exception.OverpassGatewayTimeout):
            if attempt < max_retries - 1:
                delay = 10 * (2 ** attempt) + random.uniform(0, 5)
                print(f"Timeout/overload. Waiting {delay:.1f}s...")
                time.sleep(delay)
            else:
                raise

def ingest_trees(api, conn):
    """Ingest tree data."""
    print("Fetching trees...")
    query = f"[out:json][timeout:300];node[natural=tree]({get_bbox_str()});out body;"
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.trees CASCADE;")
    
    for node in result.nodes:
        if node.lat and node.lon:
            name = node.tags.get("name", "") if hasattr(node, "tags") else ""
            cursor.execute("""
                INSERT INTO gis_data.trees (osm_id, name, geometry)
                VALUES (%s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, name, node.lon, node.lat))
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {len(result.nodes)} trees")

def ingest_parks(api, conn):
    """Ingest park data."""
    print("Fetching parks...")
    query = f'[out:json][timeout:300];way[leisure=park]({get_bbox_str()});out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.parks CASCADE;")
    
    count = 0
    for way in result.ways:
        if len(way.nodes) >= 3:
            coords = ", ".join([f"{n.lon} {n.lat}" for n in way.nodes])
            if way.nodes[0].lon != way.nodes[-1].lon or way.nodes[0].lat != way.nodes[-1].lat:
                coords += f", {way.nodes[0].lon} {way.nodes[0].lat}"
            try:
                cursor.execute("""
                    INSERT INTO gis_data.parks (osm_id, name, geometry)
                    VALUES (%s, %s, ST_GeomFromText(%s, 4326)::geography)
                """, (way.id, way.tags.get("name", ""), f"POLYGON(({coords}))"))
                count += 1
            except:
                continue
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} parks")

def ingest_amenities(api, conn):
    """Ingest amenity data (daily-use facilities, excludes school/pharmacy which are in Education/Healthcare)."""
    print("Fetching amenities...")
    query = f'[out:json][timeout:300];node[amenity~"^(supermarket|cafe|restaurant|bank|post_office|bakery|butcher)$"]({get_bbox_str()});out body;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.amenities CASCADE;")
    
    for node in result.nodes:
        if node.lat and node.lon:
            cursor.execute("""
                INSERT INTO gis_data.amenities (osm_id, name, amenity_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), node.tags.get("amenity", ""), node.lon, node.lat))
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {len(result.nodes)} amenities")

def ingest_public_transport(api, conn):
    """Ingest public transport stops (positive factor)."""
    print("Fetching public transport stops...")
    query = f'[out:json][timeout:300];(node[highway=bus_stop]({get_bbox_str()});node[railway=tram_stop]({get_bbox_str()}););out body;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.public_transport CASCADE;")
    
    for node in result.nodes:
        if node.lat and node.lon:
            transport_type = "tram_stop" if node.tags.get("railway") == "tram_stop" else "bus_stop"
            cursor.execute("""
                INSERT INTO gis_data.public_transport (osm_id, name, transport_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), transport_type, node.lon, node.lat))
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {len(result.nodes)} public transport stops")

def ingest_healthcare(api, conn):
    """Ingest healthcare facilities (positive factor)."""
    print("Fetching healthcare facilities...")
    query = f'[out:json][timeout:300];node[amenity~"^(hospital|pharmacy|doctors|clinic)$"]({get_bbox_str()});out body;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.healthcare CASCADE;")
    
    for node in result.nodes:
        if node.lat and node.lon:
            cursor.execute("""
                INSERT INTO gis_data.healthcare (osm_id, name, healthcare_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), node.tags.get("amenity", ""), node.lon, node.lat))
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {len(result.nodes)} healthcare facilities")

def ingest_industrial_areas(api, conn):
    """Ingest industrial areas (negative factor)."""
    print("Fetching industrial areas...")
    query = f'[out:json][timeout:300];way[landuse=industrial]({get_bbox_str()});out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.industrial_areas CASCADE;")
    
    count = 0
    for way in result.ways:
        if len(way.nodes) >= 3:
            coords = ", ".join([f"{n.lon} {n.lat}" for n in way.nodes])
            if way.nodes[0].lon != way.nodes[-1].lon or way.nodes[0].lat != way.nodes[-1].lat:
                coords += f", {way.nodes[0].lon} {way.nodes[0].lat}"
            try:
                cursor.execute("""
                    INSERT INTO gis_data.industrial_areas (osm_id, name, geometry)
                    VALUES (%s, %s, ST_GeomFromText(%s, 4326)::geography)
                """, (way.id, way.tags.get("name", ""), f"POLYGON(({coords}))"))
                count += 1
            except:
                continue
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} industrial areas")

def ingest_major_roads(api, conn):
    """Ingest major roads (negative factor)."""
    print("Fetching major roads...")
    query = f'[out:json][timeout:300];way[highway~"^(motorway|trunk|primary)$"]({get_bbox_str()});out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.major_roads CASCADE;")
    
    count = 0
    for way in result.ways:
        if len(way.nodes) >= 2:
            coords = ", ".join([f"{n.lon} {n.lat}" for n in way.nodes])
            try:
                cursor.execute("""
                    INSERT INTO gis_data.major_roads (osm_id, name, road_type, geometry)
                    VALUES (%s, %s, %s, ST_GeomFromText(%s, 4326)::geography)
                """, (way.id, way.tags.get("name", ""), way.tags.get("highway", ""), f"LINESTRING({coords})"))
                count += 1
            except:
                continue
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} major roads")


def ingest_bike_infrastructure(api, conn):
    """Ingest bike infrastructure (positive factor)."""
    print("Fetching bike infrastructure...")
    # Bike lanes and cycle paths
    query = f'[out:json][timeout:300];(way[highway=cycleway]({get_bbox_str()});way[cycleway~"."]({get_bbox_str()});node[amenity=bicycle_parking]({get_bbox_str()});node[amenity=bicycle_rental]({get_bbox_str()}););out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.bike_infrastructure CASCADE;")
    
    count = 0
    # Insert bike paths (ways)
    for way in result.ways:
        if len(way.nodes) >= 2:
            coords = ", ".join([f"{n.lon} {n.lat}" for n in way.nodes])
            bike_type = "cycleway" if way.tags.get("highway") == "cycleway" else "bike_lane"
            try:
                cursor.execute("""
                    INSERT INTO gis_data.bike_infrastructure (osm_id, name, infra_type, geometry)
                    VALUES (%s, %s, %s, ST_GeomFromText(%s, 4326)::geography)
                """, (way.id, way.tags.get("name", ""), bike_type, f"LINESTRING({coords})"))
                count += 1
            except:
                continue
    
    # Insert bike parking/rental (nodes)
    for node in result.nodes:
        if node.lat and node.lon:
            infra_type = node.tags.get("amenity", "bicycle_parking")
            cursor.execute("""
                INSERT INTO gis_data.bike_infrastructure (osm_id, name, infra_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), infra_type, node.lon, node.lat))
            count += 1
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} bike infrastructure elements")


def ingest_education(api, conn):
    """Ingest education facilities (positive factor)."""
    print("Fetching education facilities...")
    query = f'[out:json][timeout:300];(node[amenity~"^(school|university|college|kindergarten|library)$"]({get_bbox_str()});way[amenity~"^(school|university|college|kindergarten|library)$"]({get_bbox_str()}););out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.education CASCADE;")
    
    count = 0
    for node in result.nodes:
        if node.lat and node.lon:
            cursor.execute("""
                INSERT INTO gis_data.education (osm_id, name, education_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), node.tags.get("amenity", ""), node.lon, node.lat))
            count += 1
    
    # Also get centroids of ways (buildings)
    for way in result.ways:
        if len(way.nodes) >= 3:
            # Calculate centroid
            lats = [n.lat for n in way.nodes if n.lat]
            lons = [n.lon for n in way.nodes if n.lon]
            if lats and lons:
                centroid_lat = sum(lats) / len(lats)
                centroid_lon = sum(lons) / len(lons)
                cursor.execute("""
                    INSERT INTO gis_data.education (osm_id, name, education_type, geometry)
                    VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
                """, (way.id, way.tags.get("name", ""), way.tags.get("amenity", ""), centroid_lon, centroid_lat))
                count += 1
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} education facilities")


def ingest_sports_leisure(api, conn):
    """Ingest sports and leisure facilities (positive factor)."""
    print("Fetching sports and leisure facilities...")
    query = f'[out:json][timeout:300];(node[leisure~"^(sports_centre|swimming_pool|playground|fitness_centre|pitch)$"]({get_bbox_str()});node[sport]({get_bbox_str()});way[leisure~"^(sports_centre|swimming_pool|playground|fitness_centre|pitch)$"]({get_bbox_str()}););out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.sports_leisure CASCADE;")
    
    count = 0
    seen_ids = set()
    
    for node in result.nodes:
        if node.lat and node.lon and node.id not in seen_ids:
            seen_ids.add(node.id)
            leisure_type = node.tags.get("leisure", node.tags.get("sport", "sports"))
            cursor.execute("""
                INSERT INTO gis_data.sports_leisure (osm_id, name, leisure_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), leisure_type, node.lon, node.lat))
            count += 1
    
    for way in result.ways:
        if len(way.nodes) >= 3 and way.id not in seen_ids:
            seen_ids.add(way.id)
            lats = [n.lat for n in way.nodes if n.lat]
            lons = [n.lon for n in way.nodes if n.lon]
            if lats and lons:
                centroid_lat = sum(lats) / len(lats)
                centroid_lon = sum(lons) / len(lons)
                leisure_type = way.tags.get("leisure", way.tags.get("sport", "sports"))
                cursor.execute("""
                    INSERT INTO gis_data.sports_leisure (osm_id, name, leisure_type, geometry)
                    VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
                """, (way.id, way.tags.get("name", ""), leisure_type, centroid_lon, centroid_lat))
                count += 1
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} sports/leisure facilities")


def ingest_pedestrian_infrastructure(api, conn):
    """Ingest pedestrian infrastructure (positive factor for walkability)."""
    print("Fetching pedestrian infrastructure...")
    # Query for crossings, pedestrian streets, footways, and pedestrian areas
    query = f'[out:json][timeout:300];(node[highway=crossing]({get_bbox_str()});way[highway=pedestrian]({get_bbox_str()});way[highway=footway]({get_bbox_str()});way[footway=crossing]({get_bbox_str()});node[crossing]({get_bbox_str()}););out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.pedestrian_infrastructure CASCADE;")
    
    count = 0
    for node in result.nodes:
        if node.lat and node.lon:
            infra_type = node.tags.get("highway", node.tags.get("crossing", "crossing"))
            cursor.execute("""
                INSERT INTO gis_data.pedestrian_infrastructure (osm_id, name, infra_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), infra_type, node.lon, node.lat))
            count += 1
    
    for way in result.ways:
        if len(way.nodes) >= 2:
            infra_type = way.tags.get("highway", way.tags.get("footway", "pedestrian"))
            coords = ", ".join([f"{n.lon} {n.lat}" for n in way.nodes])
            geom_str = f"LINESTRING({coords})"
            try:
                cursor.execute("""
                    INSERT INTO gis_data.pedestrian_infrastructure (osm_id, name, infra_type, geometry)
                    VALUES (%s, %s, %s, ST_GeomFromText(%s, 4326)::geography)
                """, (way.id, way.tags.get("name", ""), infra_type, geom_str))
                count += 1
            except:
                continue
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} pedestrian infrastructure features")


def ingest_cultural_venues(api, conn):
    """Ingest cultural venues (positive factor)."""
    print("Fetching cultural venues...")
    query = f'[out:json][timeout:300];(node[tourism~"^(museum|gallery|artwork)$"]({get_bbox_str()});node[amenity~"^(theatre|cinema|arts_centre|community_centre)$"]({get_bbox_str()});way[tourism~"^(museum|gallery)$"]({get_bbox_str()});way[amenity~"^(theatre|cinema|arts_centre|community_centre)$"]({get_bbox_str()}););out body;>;out skel qt;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.cultural_venues CASCADE;")
    
    count = 0
    for node in result.nodes:
        if node.lat and node.lon:
            venue_type = node.tags.get("tourism", node.tags.get("amenity", "cultural"))
            cursor.execute("""
                INSERT INTO gis_data.cultural_venues (osm_id, name, venue_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), venue_type, node.lon, node.lat))
            count += 1
    
    for way in result.ways:
        if len(way.nodes) >= 3:
            lats = [n.lat for n in way.nodes if n.lat]
            lons = [n.lon for n in way.nodes if n.lon]
            if lats and lons:
                centroid_lat = sum(lats) / len(lats)
                centroid_lon = sum(lons) / len(lons)
                venue_type = way.tags.get("tourism", way.tags.get("amenity", "cultural"))
                cursor.execute("""
                    INSERT INTO gis_data.cultural_venues (osm_id, name, venue_type, geometry)
                    VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
                """, (way.id, way.tags.get("name", ""), venue_type, centroid_lon, centroid_lat))
                count += 1
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} cultural venues")


def ingest_noise_sources(api, conn):
    """Ingest potential noise sources (negative factor)."""
    print("Fetching noise sources...")
    query = f'[out:json][timeout:300];(node[amenity~"^(nightclub|bar|pub|fast_food)$"]({get_bbox_str()});node[shop=car_repair]({get_bbox_str()}););out body;'
    result = query_with_retry(api, query)
    
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE gis_data.noise_sources CASCADE;")
    
    count = 0
    for node in result.nodes:
        if node.lat and node.lon:
            noise_type = node.tags.get("amenity", node.tags.get("shop", "noise_source"))
            cursor.execute("""
                INSERT INTO gis_data.noise_sources (osm_id, name, noise_type, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
            """, (node.id, node.tags.get("name", ""), noise_type, node.lon, node.lat))
            count += 1
    
    conn.commit()
    cursor.close()
    print(f"✅ Inserted {count} noise sources")

def main():
    """Main ingestion function."""
    api = overpy.Overpass()
    conn = psycopg2.connect(settings.database_url)
    
    try:
        ingest_trees(api, conn)
        time.sleep(3)
        
        ingest_parks(api, conn)
        time.sleep(3)
        
        ingest_amenities(api, conn)
        time.sleep(3)
        
        ingest_public_transport(api, conn)
        time.sleep(3)
        
        ingest_healthcare(api, conn)
        time.sleep(3)
        
        ingest_industrial_areas(api, conn)
        time.sleep(3)
        
        ingest_major_roads(api, conn)
        time.sleep(3)
        
        ingest_bike_infrastructure(api, conn)
        time.sleep(3)
        
        ingest_education(api, conn)
        time.sleep(3)
        
        ingest_sports_leisure(api, conn)
        time.sleep(3)
        
        ingest_pedestrian_infrastructure(api, conn)
        time.sleep(3)
        
        ingest_cultural_venues(api, conn)
        time.sleep(3)
        
        ingest_noise_sources(api, conn)
        
        print("OSM data ingestion completed successfully")
    except Exception as e:
        print(f"❌ Error: {e}")
        raise
    finally:
        conn.close()

if __name__ == "__main__":
    main()
