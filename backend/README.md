# Backend - Bremen Livability Index API

FastAPI backend for the Bremen Livability Index, providing:
- Spatial analysis of livability scores based on 7 factors
- Address geocoding using OpenStreetMap Nominatim
- Real-time location scoring with PostGIS

## Quick Start

```bash
# 1. Start database
docker-compose up -d

# 2. Setup virtual environment
python3 -m venv venv
source venv/bin/activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Run ingestion
python ingest_all_data.py

# 5. Start server
./start_server.sh
```

API: `http://localhost:8000` | Docs: `http://localhost:8000/docs`

---

## Livability Scoring

The API calculates a 0-100 livability score based on 7 spatial factors:

### Positive Factors
| Factor | Weight | Radius | Data Source |
|--------|--------|--------|-------------|
| 🌳 Greenery | +25 | 100m | OSM trees, parks |
| 🏪 Amenities | +25 | 500m | OSM shops, cafes, schools |
| 🚍 Public Transport | +15 | 300m | OSM bus/tram stops |
| 🏥 Healthcare | +10 | 500m | OSM hospitals, pharmacies |

### Negative Factors
| Factor | Weight | Radius | Data Source |
|--------|--------|--------|-------------|
| 🚗 Accidents | -15 | 150m | Unfallatlas 2024 |
| 🏭 Industrial Areas | -15 | 200m | OSM industrial zones |
| 🛣️ Major Roads | -10 | 100m | OSM highways |

**Base Score:** 25 points

---

## Data Ingestion

```bash
python ingest_all_data.py
```

This fetches from OpenStreetMap and Unfallatlas:

| Data Type | Example Count |
|-----------|---------------|
| Trees | ~26,600 |
| Parks | ~260 |
| Amenities | ~1,260 |
| Public Transport | ~2,500 |
| Healthcare | ~490 |
| Industrial Areas | ~390 |
| Major Roads | ~2,160 |
| Accidents | ~2,080 |

---

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | API info |
| `/health` | GET | Health check |
| `/analyze` | POST | Analyze location |
| `/geocode` | POST | Geocode address to coordinates |

### Analyze Location

**Endpoint:** `POST /analyze`

Calculate livability score for a specific coordinate.

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
    {"factor": "Greenery", "value": 5.5, "description": "8 trees, 0 parks within 100m", "impact": "positive"},
    {"factor": "Amenities", "value": 22.7, "description": "78 amenities within 500m", "impact": "positive"},
    {"factor": "Public Transport", "value": 11.0, "description": "8 stops within 300m", "impact": "positive"},
    {"factor": "Healthcare", "value": 10.0, "description": "9 facilities within 500m", "impact": "positive"},
    {"factor": "Traffic Safety", "value": -15.0, "description": "14 accidents within 150m", "impact": "negative"}
  ],
  "summary": "Limited greenery. Excellent amenities. Good transit access. Traffic safety concerns"
}
```

### Geocode Address

**Endpoint:** `POST /geocode`

Convert an address to geographic coordinates using OpenStreetMap Nominatim.

#### Request
```bash
curl -X POST http://localhost:8000/geocode \
  -H "Content-Type: application/json" \
  -d '{"query": "Bürgermeister-Smidt-Straße", "limit": 5}'
```

#### Response
```json
{
  "results": [
    {
      "latitude": 53.0810562,
      "longitude": 8.8049425,
      "display_name": "Bürgermeister-Smidt-Straße, Bahnhofsvorstadt, Mitte, Bremen-Mitte, Stadtgebiet Bremen, Bremen, 28195, Deutschland",
      "address": {
        "road": "Bürgermeister-Smidt-Straße",
        "quarter": "Bahnhofsvorstadt",
        "suburb": "Mitte",
        "city": "Stadtgebiet Bremen",
        "state": "Bremen",
        "postcode": "28195",
        "country": "Deutschland"
      },
      "type": "secondary",
      "importance": 0.239
    }
  ],
  "count": 1
}
```

> **Note:** Geocoding uses the free OpenStreetMap Nominatim API with a rate limit of 1 request/second. Queries are automatically prioritized for Bremen, Germany results.

---

## Testing

---
## Postman Collection

A Postman collection is included in `Bremen_Livability_Index.postman_collection.json`.

**Features:**
-   **Environment Switching**: Use the `environment_mode` variable to switch between `local` and `deployed`.
    -   `deployed`: `https://bremen-livability-index.onrender.com`
    -   `local`: `http://127.0.0.1:8000`
-   **Pre-configured Requests**: Analyze Location, Health Check, and more.

---

## Troubleshooting

### Database Connection Failed
```bash
docker ps                    # Check if container running
docker-compose logs postgis  # View logs
```

### Port 8000 Already in Use
```bash
lsof -i :8000               # Find process
kill -9 <PID>               # Kill it
```
