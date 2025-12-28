# Bremen Livability Index

A comprehensive geospatial platform featuring a **Flutter mobile & web application** and a **Python FastAPI backend**. It calculates Quality of Life scores for any location in Bremen, Germany, in real-time.

## Project Overview

The Bremen Livability Index allows users to tap any location on a map of Bremen and receive an immediate Quality of Life score (0-100) based on 7 spatial factors.

### Scoring Factors

| Factor | Type | Weight | Radius | Source |
|--------|------|--------|--------|--------|
| 🌳 Greenery | Positive | +25 | 100m | OSM trees, parks |
| 🏪 Amenities | Positive | +25 | 500m | OSM shops, cafes, schools |
| 🚍 Public Transport | Positive | +15 | 300m | OSM bus/tram stops |
| 🏥 Healthcare | Positive | +10 | 500m | OSM hospitals, pharmacies |
| 🚗 Accidents | Negative | -15 | 150m | Unfallatlas 2024 |
| 🏭 Industrial Areas | Negative | -15 | 200m | OSM industrial zones |
| 🛣️ Major Roads | Negative | -10 | 100m | OSM highways |

**Base Score:** 25 points

## Architecture

- **Backend**: FastAPI (Python) with PostGIS spatial database
- **Frontend**: Flutter mobile & web application ("BLI")
- **Database**: PostgreSQL 15 with PostGIS 3.3
- **Data Sources**: OpenStreetMap, German Accident Atlas (Unfallatlas)

## Deployment

| File | Purpose |
|------|---------|
| `docker-compose.yml` | **Local Development**: Runs local PostgreSQL/PostGIS database |
| `backend/Dockerfile` | **Cloud Backend**: Builds the API application container |
| `backend/render.yaml` | **Backend Config**: Render Web Service + Database connection |
| `frontend/bli/render.yaml` | **Frontend Config**: Render Static Site (Flutter Web) |

### Cloud Setup (Free Forever)

1. **Database**: [Neon.tech](https://neon.tech) (PostgreSQL + PostGIS)
2. **Backend**: [Render.com](https://render.com) (Python FastAPI Web Service)
3. **Frontend**: [Render.com](https://render.com) (Static Site)

## Quick Start

### 1. Start Database
```bash
docker-compose up -d
```

### 2. Setup Backend
```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Ingest Data
```bash
python ingest_all_data.py
```

### 4. Start Server
```bash
./start_server.sh
```

API: `http://localhost:8000` | Docs: `http://localhost:8000/docs`

### 5. Run Flutter App
```bash
cd frontend/bli
flutter pub get
flutter run
```

## Data Summary

| Data Type | Count |
|-----------|-------|
| Trees | ~26,600 |
| Parks | ~260 |
| Amenities | ~1,260 |
| Public Transport | ~2,500 |
| Healthcare | ~490 |
| Industrial Areas | ~390 |
| Major Roads | ~2,160 |
| Accidents | ~2,080 |

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | API info |
| `/health` | GET | Health check |
| `/analyze` | POST | Analyze location |

### Example Request
```bash
curl -X POST http://localhost:8000/analyze \
  -H "Content-Type: application/json" \
  -d '{"latitude": 53.0793, "longitude": 8.8017}'
```

### Example Response
```json
{
  "score": 59.1,
  "location": {"latitude": 53.0793, "longitude": 8.8017},
  "factors": [
    {"factor": "Greenery", "value": 5.5, "impact": "positive"},
    {"factor": "Amenities", "value": 22.7, "impact": "positive"},
    {"factor": "Public Transport", "value": 11.0, "impact": "positive"},
    {"factor": "Healthcare", "value": 10.0, "impact": "positive"},
    {"factor": "Traffic Safety", "value": -15.0, "impact": "negative"}
  ],
  "summary": "Limited greenery. Excellent amenities. Good transit access."
}
```

## Testing

```bash
cd backend
python test_api.py
```

## Project Structure

```
Project/
├── backend/
│   ├── data_ingestion/      # Data import scripts
│   ├── main.py              # FastAPI application
│   ├── scoring.py           # 7-factor scoring algorithm
│   ├── init_db.sql          # Database schema
│   └── requirements.txt
├── frontend/bli/            # Flutter app
├── docker-compose.yml
└── README.md
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Database connection failed | `docker ps` to check container |
| Port 8000 in use | `lsof -i :8000` then `kill -9 <PID>` |
| Overpass API timeout | Retry - the API has rate limits |

## License

University project for educational purposes.

## Acknowledgments

- OpenStreetMap contributors
- German Accident Atlas (Statistisches Bundesamt)

## Production Deployment (Automated)

The project is configured for **Render** (App) + **Neon** (DB) with full automation.

1. **Push to GitHub**: Render auto-deploys using `backend/Dockerfile`.
2. **Auto-Setup**: The `entrypoint.sh` script runs automatically inside the cloud container to:
   - Initialize database tables (if missing).
   - Ingest all OSM data (first run only).
   - Start the API server.

**Live API**: `https://bremen-livability-index.onrender.com`
