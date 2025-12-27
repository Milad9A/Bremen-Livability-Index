"""Run all data ingestion scripts."""
import sys
import warnings

warnings.filterwarnings('ignore')

from data_ingestion.ingest_osm_data import main as ingest_osm
from data_ingestion.ingest_unfallatlas import main as ingest_accident


def main():
    """Run all data ingestion scripts in sequence."""
    print("\n" + "=" * 50)
    print("🌍 Bremen Livability Index - Data Ingestion")
    print("=" * 50)
    
    try:
        # Step 1: OSM Data (trees, parks, amenities, transport, healthcare, industrial, roads)
        print("\n📍 Step 1/2: OpenStreetMap Data")
        print("-" * 40)
        ingest_osm()
        
        # Step 2: Accident Data
        print("\n🚗 Step 2/2: Accident Data")
        print("-" * 40)
        try:
            ingest_accident()
        except Exception as e:
            print(f"⚠️  Accident data failed: {e}")
        
        print("\n" + "=" * 50)
        print("✅ All data ingestion completed!")
        print("=" * 50 + "\n")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
