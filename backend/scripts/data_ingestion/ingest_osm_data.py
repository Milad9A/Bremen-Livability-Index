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
    """Ingest amenity data."""
    print("Fetching amenities...")
    query = f'[out:json][timeout:300];node[amenity~"^(supermarket|school|cafe|restaurant|pharmacy|bank|post_office)$"]({get_bbox_str()});out body;'
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
        
        print("OSM data ingestion completed successfully")
    except Exception as e:
        print(f"❌ Error: {e}")
        raise
    finally:
        conn.close()

if __name__ == "__main__":
    main()
