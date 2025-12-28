"""Ingest accident data from Unfallatlas Open Data portal.

Downloads CSV/Shapefile from: https://www.opengeodata.nrw.de/produkte/transport_verkehr/unfallatlas/
Filters for Bremen area and ingests into PostGIS database.
"""
import requests
import geopandas as gpd
import pandas as pd
import psycopg2
from config import settings
import os
import tempfile
import zipfile
import warnings

warnings.filterwarnings('ignore')

# Minimal logging
import logging
logging.getLogger('geopandas').setLevel(logging.WARNING)

# Open Data download URLs
DOWNLOAD_BASE_URL = "https://www.opengeodata.nrw.de/produkte/transport_verkehr/unfallatlas"
AVAILABLE_YEARS = [2024, 2023, 2022, 2021, 2020, 2019, 2018, 2017, 2016]

# Bremen bounding box in EPSG:25832 (UTM zone 32N)
# Converted from WGS84: (53.0, 8.5) to (53.2, 9.0)
BREMEN_BBOX_25832 = {
    "min_x": 460000,  # ~8.5° E
    "max_x": 510000,  # ~9.0° E
    "min_y": 5870000, # ~53.0° N
    "max_y": 5900000  # ~53.2° N
}

# Bremen bounding box in WGS84
BREMEN_BBOX_WGS84 = {
    "min_lon": 8.5,
    "max_lon": 9.0,
    "min_lat": 53.0,
    "max_lat": 53.2
}


def download_and_extract_data(year: int = 2024, format_type: str = "csv") -> str:
    """Download and extract Unfallatlas data for a specific year.
    
    Args:
        year: Year of data to download (default: 2024)
        format_type: 'csv' or 'shape'
    
    Returns:
        Path to extracted data file
    """
    if format_type == "csv":
        filename = f"Unfallorte{year}_EPSG25832_CSV.zip"
    else:
        filename = f"Unfallorte{year}_EPSG25832_Shape.zip"
    
    # Files are directly in the unfallatlas folder (no year subdirectory)
    url = f"{DOWNLOAD_BASE_URL}/{filename}"
    
    print(f"Downloading Unfallatlas data from: {url}")
    
    try:
        response = requests.get(url, timeout=120, stream=True)
        response.raise_for_status()
        
        # Create temp directory for extraction
        temp_dir = tempfile.mkdtemp(prefix="unfallatlas_")
        zip_path = os.path.join(temp_dir, filename)
        
        # Save zip file
        with open(zip_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"Downloaded {filename} ({os.path.getsize(zip_path) / 1024 / 1024:.1f} MB)")
        
        # Extract zip
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(temp_dir)
        
        # Find the extracted file
        for f in os.listdir(temp_dir):
            if f.endswith('.csv'):
                return os.path.join(temp_dir, f)
            elif f.endswith('.shp'):
                return os.path.join(temp_dir, f)
        
        # Check subdirectories
        for root, dirs, files in os.walk(temp_dir):
            for f in files:
                if f.endswith('.csv') or f.endswith('.shp'):
                    return os.path.join(root, f)
        
        raise FileNotFoundError("Could not find extracted data file")
        
    except requests.exceptions.RequestException as e:
        print(f"Failed to download data: {e}")
        raise


def load_and_filter_bremen(data_path: str) -> gpd.GeoDataFrame:
    """Load data file and filter for Bremen area.
    
    Args:
        data_path: Path to CSV or Shapefile
    
    Returns:
        GeoDataFrame with Bremen accidents only
    """
    print(f"Loading data from: {data_path}")
    
    if data_path.endswith('.csv'):
        # Load CSV and create geometry
        df = pd.read_csv(data_path, sep=';', encoding='utf-8')
        print(f"Loaded CSV with {len(df)} records and columns: {list(df.columns)}")
        
        # Find coordinate columns (typically XGCSWGS84, YGCSWGS84 or LINREFX, LINREFY)
        x_col = None
        y_col = None
        
        # Check for WGS84 coordinates first
        for col in df.columns:
            if 'XGCSWGS84' in col.upper() or 'XWGS84' in col.upper():
                x_col = col
            if 'YGCSWGS84' in col.upper() or 'YWGS84' in col.upper():
                y_col = col
        
        # Fallback to UTM coordinates
        if x_col is None or y_col is None:
            for col in df.columns:
                if 'LINREFX' in col.upper() or col.upper() == 'X':
                    x_col = col
                if 'LINREFY' in col.upper() or col.upper() == 'Y':
                    y_col = col
        
        if x_col is None or y_col is None:
            print(f"Could not find coordinate columns. Available: {list(df.columns)}")
            raise ValueError("No coordinate columns found in CSV")
        
        print(f"Using coordinate columns: X={x_col}, Y={y_col}")
        
        # First filter by ULAND (federal state code) if available
        # ULAND=4 is Bremen
        if 'ULAND' in df.columns:
            df = df[df['ULAND'] == 4]
            print(f"Filtered by ULAND=4 (Bremen): {len(df)} records")
        
        # Convert coordinate columns - handle German decimal format (comma instead of period)
        if df[x_col].dtype == object:  # String type
            df[x_col] = df[x_col].str.replace(',', '.', regex=False)
            df[y_col] = df[y_col].str.replace(',', '.', regex=False)
        
        df[x_col] = pd.to_numeric(df[x_col], errors='coerce')
        df[y_col] = pd.to_numeric(df[y_col], errors='coerce')
        
        # Filter out invalid coordinates
        df = df.dropna(subset=[x_col, y_col])
        df = df[(df[x_col] != 0) & (df[y_col] != 0)]
        
        # Check if coordinates are in WGS84 or UTM
        sample_x = df[x_col].iloc[0] if len(df) > 0 else 0
        
        if sample_x < 180:  # WGS84 coordinates
            print("Detected WGS84 coordinates")
            # Filter for Bremen bbox
            df_bremen = df[
                (df[x_col] >= BREMEN_BBOX_WGS84["min_lon"]) &
                (df[x_col] <= BREMEN_BBOX_WGS84["max_lon"]) &
                (df[y_col] >= BREMEN_BBOX_WGS84["min_lat"]) &
                (df[y_col] <= BREMEN_BBOX_WGS84["max_lat"])
            ]
            gdf = gpd.GeoDataFrame(
                df_bremen,
                geometry=gpd.points_from_xy(df_bremen[x_col], df_bremen[y_col]),
                crs="EPSG:4326"
            )
        else:  # UTM coordinates (EPSG:25832)
            print("Detected UTM coordinates (EPSG:25832)")
            # Filter for Bremen bbox in UTM
            df_bremen = df[
                (df[x_col] >= BREMEN_BBOX_25832["min_x"]) &
                (df[x_col] <= BREMEN_BBOX_25832["max_x"]) &
                (df[y_col] >= BREMEN_BBOX_25832["min_y"]) &
                (df[y_col] <= BREMEN_BBOX_25832["max_y"])
            ]
            gdf = gpd.GeoDataFrame(
                df_bremen,
                geometry=gpd.points_from_xy(df_bremen[x_col], df_bremen[y_col]),
                crs="EPSG:25832"
            )
            # Convert to WGS84
            gdf = gdf.to_crs("EPSG:4326")
        
    else:
        # Load Shapefile
        gdf = gpd.read_file(data_path)
        print(f"Loaded Shapefile with {len(gdf)} records")
        
        # Filter for Bremen bbox
        if gdf.crs and gdf.crs.to_epsg() != 4326:
            # Convert bbox to source CRS for filtering
            gdf_wgs84 = gdf.to_crs("EPSG:4326")
        else:
            gdf_wgs84 = gdf
        
        # Spatial filter
        gdf_bremen = gdf_wgs84.cx[
            BREMEN_BBOX_WGS84["min_lon"]:BREMEN_BBOX_WGS84["max_lon"],
            BREMEN_BBOX_WGS84["min_lat"]:BREMEN_BBOX_WGS84["max_lat"]
        ]
        gdf = gdf_bremen
    
    print(f"✅ Filtered {len(gdf)} accidents in Bremen area")
    return gdf


def ingest_accident_data(gdf: gpd.GeoDataFrame, conn) -> int:
    """Ingest accident data into database.
    
    Args:
        gdf: GeoDataFrame with accident data
        conn: Database connection
    
    Returns:
        Number of records inserted
    """
    if gdf is None or len(gdf) == 0:
        print("No accident data to ingest")
        return 0
    
    # Ensure CRS is WGS84
    if gdf.crs is None or gdf.crs.to_epsg() != 4326:
        if gdf.crs is not None:
            gdf = gdf.to_crs("EPSG:4326")
        else:
            gdf.set_crs("EPSG:4326", inplace=True)
    
    # Use autocommit for individual inserts to avoid transaction abort cascade
    conn.autocommit = True
    cursor = conn.cursor()
    
    # Truncate existing data
    cursor.execute("TRUNCATE TABLE gis_data.accidents CASCADE;")
    
    inserted_count = 0
    skipped_count = 0
    
    for idx, row in gdf.iterrows():
        try:
            # Get coordinates
            if row.geometry is None:
                skipped_count += 1
                continue
                
            if row.geometry.geom_type == "Point":
                lon = row.geometry.x
                lat = row.geometry.y
            else:
                centroid = row.geometry.centroid
                lon = centroid.x
                lat = centroid.y
            
            # Extract accident ID - use UIDENTSTLAE which is the full unique ID
            accident_id = None
            for col in ["UIDENTSTLAE", "OBJECTID", "OID_", "gml_id", "id"]:
                if col in gdf.columns and pd.notna(row.get(col)):
                    accident_id = str(row[col])
                    break
            
            if accident_id is None:
                accident_id = f"unfallatlas_{idx}"
            
            # Extract severity (UKATEGORIE: 1=fatal, 2=severe, 3=minor)
            severity = "unknown"
            if "UKATEGORIE" in gdf.columns:
                cat = row.get("UKATEGORIE")
                if cat == 1:
                    severity = "fatal"
                elif cat == 2:
                    severity = "severe"
                elif cat == 3:
                    severity = "minor"
            
            # Extract date/year - database expects DATE type, not just year
            date = None
            year_value = None
            for col in ["UJAHR", "Jahr", "year"]:
                if col in gdf.columns and pd.notna(row.get(col)):
                    year_value = int(row[col])
                    break
            
            # Convert year to proper date format (use Jan 1st of that year)
            if year_value:
                date = f"{year_value}-01-01"
            
            cursor.execute("""
                INSERT INTO gis_data.accidents (accident_id, severity, date, geometry)
                VALUES (%s, %s, %s, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography)
                ON CONFLICT DO NOTHING
            """, (accident_id, severity, date, lon, lat))
            inserted_count += 1
            
        except Exception as e:
            skipped_count += 1
            if skipped_count <= 5:  # Only log first 5 errors
                print(f"Failed to insert accident {idx}: {e}")
            continue
    
    cursor.close()
    conn.autocommit = False
    
    if skipped_count > 5:
        print(f"... and {skipped_count - 5} more errors")
    
    print(f"✅ Inserted {inserted_count} accidents from Unfallatlas (skipped {skipped_count})")
    return inserted_count


def main(year: int = 2024):
    """Main ingestion function.
    
    Args:
        year: Year of data to fetch (default: most recent)
    """
    print("=" * 60)
    print(f"Unfallatlas Data Ingestion (Year: {year})")
    print("=" * 60)
    
    try:
        # Step 1: Download data
        data_path = download_and_extract_data(year=year, format_type="csv")
        
        # Step 2: Load and filter for Bremen
        gdf = load_and_filter_bremen(data_path)
        
        if len(gdf) == 0:
            print("No accidents found in Bremen area")
            return
        
        # Step 3: Connect to database and ingest
        conn = psycopg2.connect(settings.database_url)
        
        try:
            count = ingest_accident_data(gdf, conn)
            print(f"✅ Successfully ingested {count} accidents")
        finally:
            conn.close()
        
        # Cleanup temp files
        import shutil
        temp_dir = os.path.dirname(data_path)
        shutil.rmtree(temp_dir, ignore_errors=True)
        
    except Exception as e:
        print(f"❌ Error during ingestion: {e}")
        raise


if __name__ == "__main__":
    import sys
    year = int(sys.argv[1]) if len(sys.argv) > 1 else 2024
    main(year=year)
