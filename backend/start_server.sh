#!/bin/bash
# Script to start the backend server

echo "Starting Bremen Livability Index Backend Server..."
echo "=========================================="

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "   Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    echo "   Installing core dependencies (API only)..."
    echo "   For data ingestion, install GDAL first: brew install gdal"
    echo "   Then run: pip install -r requirements.txt"
    pip install -r requirements.txt
else
    echo "✅ Virtual environment found"
    source venv/bin/activate
    
    # Check if dependencies are installed
    if ! python3 -c "import fastapi" 2>/dev/null; then
        echo "⚠️  Dependencies not installed, installing now..."
        pip install -r requirements.txt
    else
        echo "✅ Dependencies already installed"
    fi
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found, using defaults"
    echo "   (Database: postgresql://postgres:postgres@localhost:5433/bremen_livability)"
fi

# Check if database is running
echo ""
echo "Checking database connection..."
python3 -c "
import psycopg2
from config import settings
try:
    conn = psycopg2.connect(settings.database_url)
    conn.close()
    print('✅ Database connection successful')
except Exception as e:
    print(f'❌ Database connection failed: {e}')
    print('   Make sure Docker is running: docker-compose up -d')
    exit(1)
" || exit 1

echo ""
echo "Starting FastAPI server..."
echo "Server will be available at: http://localhost:8000"
echo "API docs will be available at: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop the server"
echo "=========================================="
echo ""

python main.py

