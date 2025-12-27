#!/bin/bash
# Script to initialize database and start the server

echo "🚀 Starting Deployment Setup..."

# 1. Initialize Database Schema (safe to run multiple times, IF NOT EXISTS checks)
echo "Initializing Database Schema..."
python initialize_db.py

# 2. Check if trees table is empty
# If empty, run ingestion. If populated, skip to save time.
# This prevents re-ingesting 30k trees on every deploy.
ROW_COUNT=$(python -c "import psycopg2, os; conn = psycopg2.connect(os.environ['DATABASE_URL']); cur = conn.cursor(); cur.execute('SELECT count(*) FROM gis_data.trees'); print(cur.fetchone()[0])")

echo "Found $ROW_COUNT trees in database."

if [ "$ROW_COUNT" -eq "0" ]; then
    echo "📦 Database tables empty. Running full data ingestion..."
    python ingest_all_data.py
else
    echo "✅ Database populated. Skipping heavy ingestion."
    echo "   (To force re-ingest, run 'python ingest_all_data.py' in Shell)"
fi

# 3. Start the Server
echo "🚀 Starting Uvicorn Server..."
uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
