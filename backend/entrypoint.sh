#!/bin/bash
# Script to initialize database and start the server

echo "🚀 Starting Deployment Setup..."

# 1. Initialize Database Schema (safe to run multiple times, IF NOT EXISTS checks)
echo "Initializing Database Schema..."
python -m scripts.initialize_db

# 2. Check if any required tables are empty
# If any are empty, run full ingestion. Otherwise skip to save time.
NEEDS_INGEST=$(python - <<'PYCODE'
import os, psycopg2

tables = [
    "gis_data.trees",
    "gis_data.parks",
    "gis_data.amenities",
    "gis_data.public_transport",
    "gis_data.healthcare",
    "gis_data.industrial_areas",
    "gis_data.major_roads",
    "gis_data.bike_infrastructure",
    "gis_data.education",
    "gis_data.sports_leisure",
    "gis_data.pedestrian_infra",
    "gis_data.cultural_venues",
    "gis_data.noise_sources",
    "gis_data.accidents",
    "gis_data.railways",
    "gis_data.gas_stations",
    "gis_data.waste_facilities",
    "gis_data.power_infrastructure",
    "gis_data.parking_lots",
    "gis_data.airports",
    "gis_data.construction_sites",
]

conn = psycopg2.connect(os.environ["DATABASE_URL"])
cur = conn.cursor()
empty_tables = []
for tbl in tables:
    cur.execute(f"SELECT count(*) FROM {tbl}")
    count = cur.fetchone()[0]
    if count == 0:
        empty_tables.append(tbl)

conn.close()

if empty_tables:
    print("yes")
    print(", ".join(empty_tables))
else:
    print("no")
PYCODE
)

if [ "$(echo "$NEEDS_INGEST" | head -n1)" = "yes" ]; then
    echo "📦 Detected empty tables: $(echo "$NEEDS_INGEST" | tail -n1)"
    echo "Running full data ingestion..."
    python -m scripts.ingest_all_data
else
    echo "✅ All required tables have data. Skipping heavy ingestion."
    echo "   (To force re-ingest, run 'python -m scripts.ingest_all_data' in Shell)"
fi

# 3. Start the Server
echo "🚀 Starting Uvicorn Server..."
uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}
