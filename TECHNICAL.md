# Technical Documentation

This document provides a comprehensive technical overview of the Bremen Livability Index project, covering the backend architecture, database design, data processing pipelines, scoring algorithms, and frontend implementation.

---

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Database Design](#database-design)
3. [Backend Implementation](#backend-implementation)
4. [Data Ingestion Pipeline](#data-ingestion-pipeline)
5. [Scoring Algorithm](#scoring-algorithm)
6. [Frontend Implementation](#frontend-implementation)
7. [Testing](#testing)
8. [Deployment Architecture](#deployment-architecture)

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT APPLICATIONS                      │
├───────────────────┬───────────────────┬─────────────────────────┤
│   Flutter Web     │  Flutter Android  │      Flutter iOS        │
│   (Render.com)    │  (GitHub APK)     │   (Local Build)         │
└─────────┬─────────┴─────────┬─────────┴───────────┬─────────────┘
          │                   │                     │
          └───────────────────┼─────────────────────┘
                              │ HTTPS
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      FASTAPI BACKEND                            │
│                      (Render.com)                               │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │   /analyze  │  │  /geocode   │  │       /health           │  │
│  │   Endpoint  │  │  Endpoint   │  │       Endpoint          │  │
│  └──────┬──────┘  └──────┬──────┘  └───────────────────────┬─┘  │
│         │                │                                 │    │
│  ┌──────▼──────┐  ┌──────▼──────┐                          │    │
│  │  SQLModel   │  │  Nominatim  │                          │    │
│  │    ORM      │  │   Geocoder  │                          │    │
│  └──────┬──────┘  └─────────────┘                          │    │
│         │                                                  │    │
│  ┌──────▼─────────────────────────────────────────────────┐│    │
│  │              GeoAlchemy2 + PostGIS Functions           ││    │
│  │   ST_DWithin, ST_Distance, ST_AsGeoJSON, ST_MakePoint  ││    │
│  └─────────────────────────────────────────────────────────┘    │
└────────────────────────────┬────────────────────────────────────┘
                             │ PostgreSQL Protocol
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                  POSTGRESQL + POSTGIS                           │
│                    (Neon.tech)                                  │
├─────────────────────────────────────────────────────────────────┤
│  gis_data.trees          │  gis_data.public_transport           │
│  gis_data.parks          │  gis_data.healthcare                 │
│  gis_data.amenities      │  gis_data.industrial_areas           │
│  gis_data.accidents      │  gis_data.major_roads                │
└─────────────────────────────────────────────────────────────────┘
```

### Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Frontend** | Flutter 3.x | Cross-platform mobile & web app |
| **Backend** | FastAPI 0.115 | Async Python REST API |
| **ORM** | SQLModel + GeoAlchemy2 | Type-safe database access with PostGIS support |
| **Database** | PostgreSQL 16 + PostGIS 3.4 | Spatial database for geographic queries |
| **Geocoding** | OpenStreetMap Nominatim | Address-to-coordinate conversion |
| **Map Tiles** | OpenStreetMap | Base map layer |

---

## Database Design

### Schema: `gis_data`

All spatial tables are stored in the `gis_data` schema with the following design principles:

1. **Geography Type**: All geometry columns use `GEOGRAPHY(type, 4326)` for accurate distance calculations in meters
2. **GIST Indexes**: Spatial indexes on all geometry columns for fast spatial queries
3. **SRID 4326**: WGS84 coordinate reference system (standard GPS coordinates)

### Entity-Relationship Diagram

```
┌─────────────────────┐     ┌─────────────────────┐
│      trees          │     │       parks         │
├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ name: TEXT          │
│ geometry: POINT     │     │ geometry: POLYGON   │
│ created_at: TS      │     │ created_at: TS      │
└─────────────────────┘     └─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐
│     amenities       │     │     accidents       │
├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ accident_id: TEXT   │
│ name: TEXT          │     │ severity: TEXT      │
│ amenity_type: TEXT  │     │ date: DATE          │
│ geometry: POINT     │     │ geometry: POINT     │
│ created_at: TS      │     │ created_at: TS      │
└─────────────────────┘     └─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐
│  public_transport   │     │     healthcare      │
├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ name: TEXT          │
│ transport_type: TEXT│     │ healthcare_type:TEXT│
│ geometry: POINT     │     │ geometry: POINT     │
│ created_at: TS      │     │ created_at: TS      │
└─────────────────────┘     └─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐
│  industrial_areas   │     │    major_roads      │
├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ name: TEXT          │
│ geometry: GEOMETRY  │     │ road_type: TEXT     │
│ created_at: TS      │     │ geometry: GEOMETRY  │
└─────────────────────┘     │ created_at: TS      │
                            └─────────────────────┘
```

### Spatial Indexes

Each table has a GIST index on its geometry column for O(log n) spatial query performance:

```sql
CREATE INDEX idx_trees_geometry ON gis_data.trees USING GIST(geometry);
CREATE INDEX idx_parks_geometry ON gis_data.parks USING GIST(geometry);
-- ... etc for all tables
```

Additional B-tree indexes on type columns:
```sql
CREATE INDEX idx_amenities_type ON gis_data.amenities(amenity_type);
CREATE INDEX idx_public_transport_type ON gis_data.public_transport(transport_type);
```

---

## Backend Implementation

### Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py           # FastAPI application & endpoints
│   ├── models.py         # Pydantic request/response models
│   └── db_models.py      # SQLModel ORM models
├── core/
│   ├── __init__.py
│   ├── database.py       # SQLModel engine & session management
│   ├── logging.py        # Structured logging configuration
│   └── scoring.py        # Livability scoring algorithm
├── services/
│   └── geocode.py        # Nominatim geocoding service
├── scripts/
│   ├── ingest_all_data.py
│   └── data_ingestion/
│       ├── ingest_osm_data.py      # OpenStreetMap data
│       └── ingest_unfallatlas.py   # German accident data
├── tests/
│   └── test_api.py       # Pytest API tests
├── config.py             # Pydantic settings configuration
├── init_db.sql           # Database schema
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

### ORM Layer (SQLModel + GeoAlchemy2)

The ORM provides type-safe database access with PostGIS support:

```python
# app/db_models.py
from sqlmodel import SQLModel, Field
from geoalchemy2 import Geography

class Tree(SQLModel, table=True):
    __tablename__ = "trees"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(sa_column=Column(BigInteger))
    name: Optional[str] = Field(sa_column=Column(Text))
    geometry: Any = Field(sa_column=Column(Geography("POINT", 4326)))
```

### Spatial Queries

The `/analyze` endpoint uses GeoAlchemy2 functions for spatial operations:

```python
from geoalchemy2.functions import ST_DWithin, ST_Distance, ST_AsGeoJSON

# Create query point
point = cast(ST_SetSRID(ST_MakePoint(lon, lat), 4326), Geography)

# Find features within radius
statement = (
    select(
        Tree.id,
        Tree.name,
        ST_AsGeoJSON(Tree.geometry).label("geojson"),
        ST_Distance(Tree.geometry, point).label("dist")
    )
    .where(ST_DWithin(Tree.geometry, point, 100))  # 100 meters
    .order_by("dist")
)
```

### Dependency Injection

Database sessions are injected into endpoints using FastAPI's dependency system:

```python
from fastapi import Depends
from core.database import get_session

@app.post("/analyze")
async def analyze_location(
    request: LocationRequest,
    session: Session = Depends(get_session)
):
    # session is automatically provided and cleaned up
```

---

## Data Ingestion Pipeline

### Data Sources

| Source | Type | Data | Note |
|--------|------|------|------|
| **OpenStreetMap** | Overpass API | Trees, parks, amenities, transport, healthcare, industrial, roads | Fetched on deployment |
| **Unfallatlas** | CSV Download | Traffic accidents | 2024 data (published yearly by Statistisches Bundesamt) |

### OpenStreetMap Ingestion

Uses the Overpass API to query OSM data within Bremen's bounding box:

```python
# Bremen bounding box
BREMEN_BBOX = {"south": 53.0, "west": 8.5, "north": 53.2, "east": 9.0}

# Example Overpass query for trees
query = f"""
[out:json][timeout:60];
(
  node["natural"="tree"]({bbox});
);
out center;
"""
```

**Retry Logic**: The Overpass API has rate limits, so the ingestion script includes exponential backoff:

```python
def query_with_retry(api, query, max_retries=5):
    for attempt in range(max_retries):
        try:
            return api.query(query)
        except Exception:
            wait_time = (2 ** attempt) + random.uniform(0, 1)
            time.sleep(wait_time)
```

### Unfallatlas Ingestion

German traffic accident data from the federal statistics office:

1. **Download**: CSV file from OpenData NRW portal
2. **Filter**: By `ULAND=4` (Bremen federal state code)
3. **Coordinate Transform**: EPSG:25832 (UTM) → EPSG:4326 (WGS84)
4. **Severity Mapping**: `UKATEGORIE` → `fatal/severe/minor`

```python
# Severity mapping
if category == 1: severity = "fatal"
elif category == 2: severity = "severe"
elif category == 3: severity = "minor"
```

---

## Scoring Algorithm

### Formula

```
Final Score = BASE_SCORE + Positive_Factors - Negative_Factors
            = 25 + (Greenery + Amenities + Transport + Healthcare)
                 - (Accidents + Industrial + Roads)
```

### Factor Weights & Radii

| Factor | Type | Max Points | Radius | Calculation |
|--------|------|------------|--------|-------------|
| **Greenery** | Positive | 25 | 100m | `min(12.5, log1p(trees) * 2.5) + min(12.5, parks * 4)` |
| **Amenities** | Positive | 25 | 500m | `min(25, log1p(count) * 4.5) + bonus_if_10+` |
| **Transport** | Positive | 15 | 300m | `min(15, log1p(stops) * 5)` |
| **Healthcare** | Positive | 10 | 500m | `min(10, facilities * 3)` |
| **Accidents** | Negative | -15 | 150m | `min(15, count * 3)` |
| **Industrial** | Negative | -15 | 200m | Binary: `15 if near else 0` |
| **Major Roads** | Negative | -10 | 100m | Binary: `10 if near else 0` |

### Logarithmic Scaling

For count-based factors, logarithmic scaling (`log1p`) prevents diminishing returns:

```python
# log1p(x) = log(1 + x)
# This ensures:
#   - First few items have high impact
#   - Additional items have decreasing marginal value
#   - Prevents score manipulation by dense areas

tree_score = min(12.5, math.log1p(tree_count) * 2.5)
```

**Example**: 
- 5 trees → `log1p(5) * 2.5 = 4.5 points`
- 50 trees → `log1p(50) * 2.5 = 9.8 points`
- 500 trees → `log1p(500) * 2.5 = 12.5 points` (capped)

### Score Ranges

| Range | Interpretation |
|-------|----------------|
| 80-100 | Excellent livability |
| 60-79 | Good livability |
| 40-59 | Average livability |
| 20-39 | Below average |
| 0-19 | Poor livability |

---

## Frontend Implementation

### Architecture

```
frontend/bli/lib/
├── main.dart                    # App entry point
├── models/
│   └── livability_score.dart    # Data models
├── screens/
│   └── map_screen.dart          # Main map view
├── services/
│   └── api_service.dart         # Backend API client
└── widgets/
    ├── address_search.dart      # Search logic wrapper
    ├── search_results_list.dart # Reusable search results list
    ├── floating_search_bar.dart # Collapsed floating search bar
    ├── loading_overlay.dart     # Glass-morphic loading indicator
    ├── nearby_feature_layers.dart  # Map markers
    ├── score_card.dart          # Score display
    └── glass_container.dart     # Reusable glass effect widget
```

### Map Rendering

Uses `flutter_map` package with OpenStreetMap tiles:

```dart
FlutterMap(
  mapController: _mapController,
  options: MapOptions(
    initialCenter: LatLng(53.0793, 8.8017), // Bremen center
    initialZoom: 13.0,
    onTap: _onMapTap,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
    // Feature markers layer
    MarkerLayer(markers: _nearbyMarkers),
  ],
)
```

### API Communication

```dart
class ApiService {
  static const String baseUrl = 'https://bremen-livability-backend.onrender.com';
  
  Future<LivabilityScore> analyzeLocation(double lat, double lon) async {
    final response = await http.post(
      Uri.parse('$baseUrl/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'latitude': lat, 'longitude': lon}),
    );
    return LivabilityScore.fromJson(jsonDecode(response.body));
  }
}

### User Interface (Glassmorphism)

The application uses a **Liquid Glass** design system:
- **Immersive Map**: Full-screen map with no app bar.
- **Floating Controls**: Search bar and buttons float above the map.
- **Glass Effect**: UI elements use `BackdropFilter` with blur (`sigmaX/Y: 10`) and semi-transparent white backgrounds (`opacity: 0.6`) to blend with the map.
- **Components**:
    - `GlassContainer`: Core widget providing the frosted glass look.
    - `FloatingSearchBar`: Collapsed state of the search bar.
    - `LoadingOverlay`: Glass-morphic loading indicator.

---

## Testing

### Backend Tests

Located in `backend/tests/`:

```bash
cd backend
source venv/bin/activate
pytest tests/ -v
```

### Flutter Tests

Located in `frontend/bli/test/`:

```
test/
├── api_service_test.dart        # Unit tests for models
├── score_card_test.dart         # Widget tests
└── nearby_feature_layers_test.dart  # Geometry parsing tests
```

**Run tests:**
```bash
cd frontend/bli
flutter test
```
---

## Deployment Architecture

### Supported Platforms

| Platform | Directory | Build Output |
|----------|-----------|---------------|
| **Web** | `web/` | Static site (Render) |
| **Android** | `android/` | APK (GitHub Release) |
| **iOS** | `ios/` | .app (local build) |
| **macOS** | `macos/` | .app (GitHub Release) |
| **Windows** | `windows/` | .exe (GitHub Release) |
| **Linux** | `linux/` | bundle (GitHub Release) |

### Production Environment

```
┌─────────────────────────────────────────────────────────────┐
│                     GITHUB REPOSITORY                       │
│                   (Source of Truth)                         │
└──────────────────────────┬──────────────────────────────────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
┌─────────────────┐ ┌─────────────┐ ┌───────────────────────┐
│  RENDER.COM     │ │ RENDER.COM  │ │    GITHUB ACTIONS     │
│  Backend        │ │ Frontend    │ │  App Builders         │
│  (Web Service)  │ │ (Static)    │ │  Android/Win/Mac/Lin  │
└────────┬────────┘ └─────────────┘ └───────────┬───────────┘
         │                                      │
         ▼                                      ▼
┌─────────────────┐                ┌────────────────────────┐
│   NEON.TECH     │                │    GITHUB RELEASES     │
│   PostgreSQL    │                │  - Android APK         │
│   + PostGIS     │                │  - Windows .exe        │
│                 │                │  - macOS .app          │
│                 │                │  - Linux bundle        │
└─────────────────┘                └────────────────────────┘
```

### Auto-Deployment Flow

1. **Push to `master`** triggers:
   - GitHub Actions runs backend tests (`backend-ci.yml`)
   - Render rebuilds backend from `Dockerfile`
   - Render rebuilds frontend static site
   - GitHub Actions runs Flutter tests, then builds all apps (Android, Windows, Linux, macOS) in `build-release.yml`

2. **First Deploy**: `entrypoint.sh` runs:
   ```bash
   # Initialize database schema
   psql $DATABASE_URL -f init_db.sql
   
   # Ingest all data
   python -m scripts.ingest_all_data
   
   # Start server
   uvicorn app.main:app --host 0.0.0.0 --port $PORT
   ```

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://user:pass@host/db` |
| `PORT` | Server port (set by Render) | `8000` |
| `CORS_ORIGINS` | Allowed CORS origins | `*` or `https://example.com` |
| `LOG_LEVEL` | Logging verbosity | `INFO` |

---

## Performance Considerations

### Spatial Query Optimization

1. **GIST Indexes**: All geometry columns are indexed with GIST for O(log n) lookups
2. **Geography Type**: Uses spherical calculations for accurate meter-based distances
3. **Radius Filtering**: `ST_DWithin` uses indexes efficiently (unlike ST_Distance < X)

### API Response Size

The `/analyze` endpoint returns full GeoJSON for each nearby feature. For dense areas:
- Trees: ~5-50 features
- Amenities: ~50-150 features
- Transport: ~5-20 features

### Database Connection Pooling

SQLModel engine uses connection pooling with `pool_pre_ping=True` to handle stale connections:

```python
engine = create_engine(
    settings.database_url,
    echo=False,
    pool_pre_ping=True  # Verify connections before use
)
```
