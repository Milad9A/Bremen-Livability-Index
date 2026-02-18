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
│  gis_data.trees                 │  gis_data.public_transport    │
│  gis_data.parks                 │  gis_data.healthcare          │
│  gis_data.amenities             │  gis_data.industrial_areas    │
│  gis_data.accidents             │  gis_data.major_roads         │
│  gis_data.bike_infrastructure   │  gis_data.education           │
│  gis_data.sports_leisure        │  gis_data.pedestrian_infra    │
│  gis_data.cultural_venues       │  gis_data.noise_sources       │
│  gis_data.railways              │  gis_data.gas_stations        │
│  gis_data.waste_facilities      │  gis_data.power_infrastructure│
│  gis_data.parking_lots          │  gis_data.airports            │
│  gis_data.construction_sites    │                               │
└─────────────────────────────────────────────────────────────────┘
```

### Technology Stack

| Layer | Technology | Purpose |
| ------- | ------------ | --------- |
| **Frontend** | Flutter 3.x | Cross-platform mobile & web app |
| **HTTP Client** | Dio 5.x | HTTP client with interceptors and error handling |
| **State Management** | flutter_bloc 9.x | BLoC pattern for reactive state management |
| **Code Generation** | Freezed + json_serializable | Immutable data models and BLoC state/events |
| **Testing** | Mockito + bloc_test | Mocking dependencies for unit tests and BLoC testing |
| **Backend** | FastAPI 0.115 | Async Python REST API |
| **ORM** | SQLModel + GeoAlchemy2 | Type-safe database access with PostGIS support |
| **Database** | PostgreSQL 16 + PostGIS 3.4 | Spatial database for geographic queries |
| **Geocoding** | OpenStreetMap Nominatim | Address-to-coordinate conversion |
| **Map Tiles** | CartoDB Voyager | Base map layer (clean, no POI icons) |

---

## Database Design

### Schema: `gis_data`

All spatial tables are stored in the `gis_data` schema with the following design principles:

1. **Geography Type**: All geometry columns use `GEOGRAPHY(type, 4326)` for accurate distance calculations in meters
2. **GIST Indexes**: Spatial indexes on all geometry columns for fast spatial queries
3. **SRID 4326**: WGS84 coordinate reference system (standard GPS coordinates)

### Entity-Relationship Diagram

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│      trees          │     │       parks         │     │     amenities       │
├─────────────────────┤     ├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ osm_id: BIGINT      │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ name: TEXT          │     │ name: TEXT          │
│ geometry: POINT     │     │ geometry: POLYGON   │     │ amenity_type: TEXT  │
│ created_at: TS      │     │ created_at: TS      │     │ geometry: POINT     │
└─────────────────────┘     └─────────────────────┘     │ created_at: TS      │
                                                        └─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│  public_transport   │     │     healthcare      │     │ bike_infrastructure │
├─────────────────────┤     ├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ osm_id: BIGINT      │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ name: TEXT          │     │ name: TEXT          │
│ transport_type: TEXT│     │ healthcare_type:TEXT│     │ infra_type: TEXT    │
│ geometry: POINT     │     │ geometry: POINT     │     │ geometry: GEOMETRY  │
│ created_at: TS      │     │ created_at: TS      │     │ created_at: TS      │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│     education       │     │   sports_leisure    │     │ pedestrian_infra    │
├─────────────────────┤     ├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ osm_id: BIGINT      │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ name: TEXT          │     │ name: TEXT          │
│ education_type: TEXT│     │ leisure_type: TEXT  │     │ infra_type: TEXT    │
│ geometry: POINT     │     │ geometry: POINT     │     │ geometry: GEOMETRY  │
│ created_at: TS      │     │ created_at: TS      │     │ created_at: TS      │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│  cultural_venues    │     │     accidents       │     │  industrial_areas   │
├─────────────────────┤     ├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ accident_id: TEXT   │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ severity: TEXT      │     │ name: TEXT          │
│ venue_type: TEXT    │     │ date: DATE          │     │ geometry: GEOMETRY  │
│ geometry: POINT     │     │ geometry: POINT     │     │ created_at: TS      │
│ created_at: TS      │     │ created_at: TS      │     └─────────────────────┘
└─────────────────────┘     └─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐
│    major_roads      │     │   noise_sources     │
├─────────────────────┤     ├─────────────────────┤
│ id: SERIAL PK       │     │ id: SERIAL PK       │
│ osm_id: BIGINT      │     │ osm_id: BIGINT      │
│ name: TEXT          │     │ name: TEXT          │
│ road_type: TEXT     │     │ noise_type: TEXT    │
│ geometry: GEOMETRY  │     │ geometry: POINT     │
│ created_at: TS      │     │ created_at: TS      │
└─────────────────────┘     └─────────────────────┘
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
│   ├── test_api.py       # Pytest API tests
│   └── test_scoring.py   # Scoring algorithm tests (58 tests)
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

### API Endpoints

The backend exposes a comprehensive REST API with the following endpoints:

#### Informational Endpoints

| Endpoint | Method | Description | Response |
|----------|--------|-------------|----------|
| `/` | GET | API information and available endpoints | `{"message", "version", "endpoints"}` |
| `/health` | GET | Health check (verifies API and database connectivity) | `{"status": "healthy", "database": "connected"}` |

#### Livability Analysis

| Endpoint | Method | Request Body | Response | Description |
|----------|--------|--------------|----------|-------------|
| `/analyze` | POST | `{latitude: float, longitude: float, preferences?: Dict}` | `LivabilityScoreResponse` | Calculate livability score (optional custom weights) |

**Example Response:**

```json
{
  "score": 72.5,
  "base_score": 40.0,
  "summary": "Good livability - friendly neighborhood",
  "factors": [
    {"factor": "Greenery", "value": 10.2, "description": "45 trees, 2 parks within 175m", "impact": "positive"},
    {"factor": "Amenities", "value": 8.5, "description": "12 amenities within 550m", "impact": "positive"},
    ...
  ],
  "nearby_features": {
    "trees": [...],
    "parks": [...],
    ...
  },
  "location": {"latitude": 53.0793, "longitude": 8.8017}
}
```

#### Preferences & Metadata

| Endpoint | Method | Response | Description |
|----------|--------|----------|-------------|
| `/preferences/defaults` | GET | `UserPreferences` | Get default importance levels and multipliers |

#### Geocoding & Address Search

| Endpoint | Method | Request Body | Response | Description |
|----------|--------|--------------|----------|-------------|
| `/geocode` | POST | `{query: string, limit?: int}` | `GeocodeResponse` | Search addresses and get coordinates |

**Example Response:**

```json
{
  "results": [
    {
      "display_name": "Marktplatz, 28195 Bremen, Germany",
      "latitude": 53.0793,
      "longitude": 8.8017,
      "address": {...},
      "type": "place",
      "importance": 0.85
    }
  ],
  "count": 1
}
```

#### User Management & Favorites (Firebase Integration)

| Endpoint | Method | Request Body | Response | Status | Description |
|----------|--------|--------------|----------|--------|-------------|
| `/users` | POST | `{id: string (Firebase UID), email?: string, display_name?: string, provider: string}` | `{"message", "user_id"}` | 201 | Create or update user record |
| `/users/{user_id}/favorites` | GET | - | `FavoritesListResponse` | 200 | Get all user's saved favorite locations |
| `/users/{user_id}/favorites` | POST | `{label: string, latitude: float, longitude: float, address?: string}` | `FavoriteResponse` | 201 | Add new favorite location |
| `/users/{user_id}/favorites/{favorite_id}` | DELETE | - | - | 204 | Delete a favorite location |

**Favorite Location Response Example:**

```json
{
  "id": 42,
  "label": "My Apartment",
  "latitude": 53.0793,
  "longitude": 8.8017,
  "address": "Example Street 123, 28195 Bremen",
  "created_at": "2025-12-15T10:30:00Z"
}
```

#### Authentication & Authorization

- **User Creation**: Triggered via Firebase Authentication (on client side)
  - Firebase UID is used as the primary identifier (`user_id`)
  - Multiple auth providers supported: Google, GitHub, Email/Password, Anonymous
  - Backend receives user metadata and stores it in the `users` table

- **Favorites Sync**: Authenticated via Firebase ID Token (client passes in Authorization header)
  - Firestore rules ensure users can only access their own favorites
  - Backend verifies user ownership before allowing delete operations

### Email Magic Link Flow (Deep Links)

The email sign-in flow uses Firebase Hosting to redirect users back to the app:

```
┌─────────────────────────────────────────────────────────────────────┐
│                      EMAIL MAGIC LINK FLOW                          │
└─────────────────────────────────────────────────────────────────────┘

1. User enters email → App calls sendSignInLinkToEmail()
                              │
                              ▼
2. Firebase sends email with link:
   https://bremen-livability-index.firebaseapp.com/login?oobCode=xxx
                              │
                              ▼
3. User clicks link → Firebase Hosting serves redirect page
                              │
         ┌────────────────────┼────────────────────┐
         │                    │                    │
         ▼                    ▼                    ▼
    [iOS Safari]        [Android App]          [Web App]
    Falls back to       App Links              JavaScript redirect
    web app             directly opens         to Render.com
                        app                    deployment
                              │
                              ▼
4. App receives link → Check for stored email
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
   [Email Found]        [No Email Found]     (Cross-device flow)
   Same device          Different device/    User clicked link on
                        browser              different device
         │                    │
         ▼                    ▼
   signInWithEmailLink   Show EmailLinkPromptScreen
   (email, link)         → User enters email
         │                    │
         ▼                    ▼
5. User is authenticated ✓
```

**Cross-Device Flow Implementation**:

- `DeepLinkService` detects email link parameters (`oobCode`, `mode`) in the URL
- If no stored email is found (cross-device scenario), dispatches `EmailLinkPendingEmail` event
- `AuthBloc` sets `pendingEmailLink` in state, triggering navigation to `EmailLinkPromptScreen`
- User enters email → `EmailLinkVerified` event completes authentication

**Configuration Files**:

- `firebase_hosting/.well-known/apple-app-site-association` - iOS Universal Links (requires paid account)
- `firebase_hosting/.well-known/assetlinks.json` - Android App Links (SHA256 fingerprint)
- `firebase_hosting/login/index.html` - Redirect page for web fallback
- `android/app/src/main/AndroidManifest.xml` - Android intent filters

**Note**: iOS Universal Links require a paid Apple Developer account ($99/year). Without it, iOS users are redirected to the web app which handles the cross-device flow.

---

## Data Ingestion Pipeline

### Data Sources Overview

| Source | Type | License | Data Categories |
|--------|------|---------|-----------------|
| **OpenStreetMap** | Overpass API | ODbL 1.0 | 12 feature categories (see below) |
| **Unfallatlas** | CSV Download | dl-de/by-2-0 | Traffic accidents (2019-2023) |

### OpenStreetMap Data Categories

The following table details all OSM features collected, their tags, and typical counts for Bremen:

| Category | OSM Tags | Description | Typical Count |
|----------|----------|-------------|---------------|
| **Trees** | `natural=tree` | Individual street and park trees | ~45,000 |
| **Parks** | `leisure=park` | Public parks and green spaces | ~300 |
| **Amenities** | `amenity=supermarket\|cafe\|restaurant\|bank\|post_office\|bakery\|butcher` | Daily-use facilities | ~2,000 |
| **Public Transport** | `highway=bus_stop`, `railway=tram_stop` | Bus and tram stops | ~1,200 |
| **Healthcare** | `amenity=hospital\|pharmacy\|doctors\|clinic` | Medical facilities | ~400 |
| **Industrial Areas** | `landuse=industrial` | Industrial zones (polygons) | ~150 |
| **Major Roads** | `highway=motorway\|trunk\|primary` | High-traffic roads | ~200 |
| **Bike Infrastructure** | `highway=cycleway`, `cycleway=*`, `amenity=bicycle_parking\|bicycle_rental` | Cycling facilities | ~3,000 |
| **Education** | `amenity=school\|university\|college\|kindergarten\|library` | Educational institutions | ~670 |
| **Sports & Leisure** | `leisure=sports_centre\|swimming_pool\|playground\|pitch\|fitness_centre` | Recreational facilities | ~680 |
| **Pedestrian Infrastructure** | `highway=pedestrian\|footway` | Pedestrian streets, footways (LineStrings only) | ~2,500 |
| **Cultural Venues** | `tourism=museum\|gallery`, `amenity=theatre\|cinema\|arts_centre\|community_centre` | Filtered cultural facilities | ~500 |
| **Noise Sources** | `amenity=nightclub\|bar\|pub\|fast_food\|car_repair` | Potential noise generators | ~200 |

### Bremen Bounding Box

All spatial queries are constrained to Bremen's administrative boundaries:

```python
BREMEN_BBOX = {
    "south": 53.0,   # Minimum latitude
    "west": 8.5,     # Minimum longitude  
    "north": 53.2,   # Maximum latitude
    "east": 9.0      # Maximum longitude
}
# Area: ~420 km² covering Bremen and Bremerhaven
```

### OpenStreetMap Ingestion

Uses the Overpass API to query OSM data within Bremen's bounding box:

```python
# Example Overpass query for trees
query = f"""
[out:json][timeout:60];
(
  node["natural"="tree"]({bbox});
);
out center;
"""
```

**Rate Limiting & Retry Logic**: The Overpass API has rate limits (max 2 requests/sec, 10,000 elements/request), so the ingestion script includes exponential backoff:

```python
def query_with_retry(api, query, max_retries=5):
    for attempt in range(max_retries):
        try:
            return api.query(query)
        except Exception:
            wait_time = (2 ** attempt) + random.uniform(0, 1)
            time.sleep(wait_time)
```

**Geometry Handling**:

- **Points**: Trees, amenities, transport stops → stored as `GEOGRAPHY(POINT, 4326)`
- **Lines**: Roads, cycleways, footways → stored as `GEOGRAPHY(LINESTRING, 4326)`
- **Polygons**: Parks, industrial areas → stored as `GEOGRAPHY(POLYGON, 4326)`

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
            = 40 + (Greenery + Amenities + Transport + Healthcare + Bike + Education + Sports + Pedestrian + Cultural)
                 - (Accidents + Industrial + Roads + Noise + Railway + GasStation + Waste + Power + Parking + Airport + Construction)

Theoretical Range: 40 + 60 - 57 = [0, 100] (clamped)
```

The base score of **40** provides a balanced starting point where most locations begin below average, encouraging exploration of high-quality areas. The 9 positive factors (max +60) and 11 negative factors (max -57) influence the final score. The UI displays this calculation breakdown as:

```
[Base: 40] [+Positive Total] [-Negative Total] = Final Score
```

### Dynamic Weighting

The system supports user-defined preferences, allowing personalized scoring. Base weights are adjusted by importance multipliers:

| Importance | Multiplier | Description |
|------------|------------|-------------|
| **High**   | 1.5x       | Factor impact increased by 50% |
| **Medium** | 1.0x       | Default weight |
| **Low**    | 0.5x       | Factor impact halved |
| **Off**    | 0.0x       | Factor completely excluded |

### Factor Weights & Radii

| Factor | Type | Max Points | Radius | Calculation |
|--------|------|------------|--------|-------------|
| **Greenery** | Positive | 14 | 175m | `min(9, log1p(trees) * 2.0) + min(5, parks * 2.5)` |
| **Amenities** | Positive | 10 | 550m | `min(10, log1p(count) * 2.8)` |
| **Transport** | Positive | 8 | 450m | `min(8, log1p(stops) * 3.5)` |
| **Healthcare** | Positive | 6 | 700m | `min(6, facilities * 2.5)` |
| **Bike Infrastructure** | Positive | 6 | 275m | `min(6, log1p(count) * 2.5)` |
| **Education** | Positive | 5 | 500m | `min(5, facilities * 1.5)` |
| **Sports & Leisure** | Positive | 4 | 700m | `min(4, log1p(count) * 1.8)` |
| **Pedestrian Infrastructure** | Positive | 3 | 275m | `min(3, log1p(count) * 1.2)` |
| **Cultural Venues** | Positive | 4 | 500m | `min(4, count * 2)` |
| **Accidents** | Negative | -8 | 120m | `min(8, count * 2)` |
| **Industrial** | Negative | -10 | 150m | Binary: `10 if near else 0` |
| **Major Roads** | Negative | -6 | 60m | Binary: `6 if near else 0` |
| **Noise Sources** | Negative | -6 | 75m | `min(6, count * 2)` |
| **Railways** | Negative | -5 | 100m | Binary: `5 if near else 0` |
| **Gas Stations** | Negative | -3 | 75m | Binary: `3 if near else 0` |
| **Waste Facilities** | Negative | -5 | 250m | Binary: `5 if near else 0` |
| **Power Infrastructure** | Negative | -3 | 75m | Binary: `3 if near else 0` |
| **Large Parking Lots** | Negative | -2 | 50m | Binary: `2 if near else 0` |
| **Airports/Helipads** | Negative | -7 | 600m | Binary: `7 if near else 0` |
| **Construction Sites** | Negative | -2 | 125m | Binary: `2 if near else 0` |

### Factor Explanations

Each metric captures a specific aspect of neighborhood livability:

#### Positive Factors

| Factor | Why It Matters | What We Measure |
|--------|----------------|-----------------|
| **Trees** | Urban trees improve air quality, reduce heat islands, provide shade, and enhance mental well-being. Studies show proximity to green elements reduces stress and increases property values. | Individual street and park trees within 175m radius |
| **Parks** | Access to green spaces promotes physical activity, social interaction, and provides refuge from urban density. WHO recommends living within 300m of green space. | Public parks and green areas within 175m radius |
| **Public Transport** | Good transit access reduces car dependency, lowers household transport costs, and improves mobility for non-drivers (elderly, youth, disabled). | Bus stops and tram stops within 450m walking distance |
| **Amenities** | Daily-use facilities reduce travel needs, support local economy, and create vibrant neighborhoods. Walkable amenities are a key indicator of "15-minute city" design. | Supermarkets, cafes, restaurants, bakeries, banks, post offices within 550m |
| **Healthcare** | Proximity to medical services is critical for emergencies and routine care. Especially important for elderly residents and families with children. | Hospitals, clinics, doctors' offices, pharmacies within 700m |
| **Bike Infrastructure** | Dedicated cycling facilities encourage sustainable transport, improve safety, and indicate progressive urban planning. Correlates with lower car dependency. | Cycleways, bike lanes, bicycle parking, bike rental stations within 275m |
| **Education** | Schools and libraries serve as community anchors. Proximity reduces commute stress for families and indicates family-friendly neighborhoods. | Schools, universities, kindergartens, libraries within 500m |
| **Sports & Leisure** | Recreational facilities promote active lifestyles and community building. Playgrounds indicate child-friendliness; gyms and pools serve adult fitness needs. | Sports centers, swimming pools, playgrounds, fitness centers, sports pitches within 700m |
| **Pedestrian Infrastructure** | Pedestrian zones and footways indicate walkability and pedestrian-friendly urban design. Dedicated walking areas encourage walking and reduce car dependency. | Pedestrian streets, dedicated footways within 275m (LineStrings only, no point crossings) |
| **Cultural Venues** | Museums, theaters, and community centers enrich quality of life, provide entertainment, and create cultural identity. Indicates neighborhood vibrancy. | Museums, galleries, theaters, cinemas, arts centers, community centers within 500m |

#### Negative Factors

| Factor | Why It Matters | What We Measure |
|--------|----------------|-----------------|
| **Traffic Accidents** | Historical accident data reveals dangerous intersections and streets. High accident density indicates safety risks for pedestrians, cyclists, and drivers. | Police-reported accidents (2019-2023) within 120m, weighted by severity |
| **Industrial Areas** | Industrial zones generate noise, air pollution, heavy traffic, and visual blight. Residential proximity to industry correlates with lower health outcomes. | Industrial land use zones within 150m (binary detection) |
| **Major Roads** | Highways and primary roads produce constant noise, air pollution (particulates, NOx), and create pedestrian barriers. Living near major roads linked to respiratory issues. | Motorways, trunk roads, primary roads within 60m (binary detection) |
| **Noise Sources** | Nightclubs, bars, and car repair shops generate noise pollution that disrupts sleep and reduces quality of life, especially during evening hours. | Nightclubs, bars, pubs, fast food outlets, car repair shops within 75m |
| **Railways** | Active railway lines generate noise from passing trains and vibration. Level crossings create barriers and safety concerns for pedestrians. | Railway tracks and stations within 100m (binary detection) |
| **Gas Stations** | Petrol/gas stations produce fuel odors, attract vehicle traffic, and pose fire/explosion risks. Underground tanks may contaminate groundwater. | Fuel stations within 75m (binary detection) |
| **Waste Facilities** | Recycling centers, landfills, and waste processing sites generate odors, attract pests, and increase truck traffic. Visual blight reduces neighborhood appeal. | Recycling centers, landfills, waste processing within 250m (binary detection) |
| **Power Infrastructure** | High-voltage power lines and substations raise concerns about electromagnetic fields. Substations generate noise and visual impact. | Power lines, substations, transformers within 75m (binary detection) |
| **Large Parking Lots** | Surface parking lots create urban heat islands, generate traffic, and are visually unappealing. They indicate car-centric rather than pedestrian-friendly design. | Large parking facilities within 50m (binary detection) |
| **Airports/Helipads** | Aircraft noise significantly impacts quality of life. Airports generate air pollution and constant traffic from departing/arriving passengers. | Airports, heliports, aerodromes within 600m (binary detection) |
| **Construction Sites** | Active construction creates noise, dust, and traffic disruption. While temporary, they significantly impact short-term livability. | Active construction areas within 125m (binary detection) |
### Dynamic Weight Preferences

The scoring system now supports personalized factor weighting, allowing users to adjust the influence of each metric on the final score.

#### Preference Levels

Users can assign one of four importance levels to each of the 20 factors:

| Level | Multiplier | Effect |
|-------|------------|--------|
| **High** | 1.5x | Increases the factor's positive contribution or penalty by 50%. |
| **Medium** | 1.0x | Standard weight (Default). |
| **Low** | 0.5x | Decreases the factor's impact by 50%. |
| **Excluded** | 0.0x | Completely removes the factor from the score calculation and hides it from the UI/Map. |

#### Backend Implementation

The `calculate_score` method in `LivabilityScorer` accepts an optional `preferences` dictionary. It iterates through the factors, applying the corresponding multiplier before aggregation.

```python
# backend/core/scoring.py

IMPORTANCE_MULTIPLIERS = {
    "excluded": 0.0,
    "low": 0.5,
    "medium": 1.0,
    "high": 1.5
}

@classmethod
def get_multiplier(cls, preferences: Optional[Dict[str, str]], factor_key: str) -> float:
    """Get the importance multiplier for a factor based on user preferences."""
    if preferences is None:
        return 1.0  # Default to medium (1.0x)
    level = preferences.get(factor_key, "medium")
    return cls.IMPORTANCE_MULTIPLIERS.get(level, 1.0)

# Example application in calculate_score()
greenery = greenery_base * cls.get_multiplier(preferences, "greenery")
```

#### Frontend Implementation

- **Model**: `UserPreferences` class (freezed) holds the state of all 20 factors.
- **State Management**: `PreferencesBloc` manages loading (local/cloud), updating, and resetting preferences.
- **Persistence**:
  - **Guest**: Saved locally via `SharedPreferences`.
  - **Authenticated**: Synced to Firestore (`users/{uid}/preferences/factor_settings`).
- **UI**: `PreferencesScreen` provides segmented buttons for easy adjustment, and the Map updates in real-time based on the active configuration.

---

For count-based factors, logarithmic scaling (`log1p`) prevents diminishing returns:

```python
# log1p(x) = log(1 + x)
# This ensures:
#   - First few items have high impact
#   - Additional items have decreasing marginal value
#   - Prevents score manipulation by dense areas

tree_score = min(9.0, math.log1p(tree_count) * 2.0)
```

**Example**:

- 5 trees → `log1p(5) * 2.0 = 3.6 points`
- 50 trees → `log1p(50) * 2.0 = 7.8 points`
- 500 trees → `log1p(500) * 2.0 = 9.0 points` (capped)

### Score Ranges

| Range | Interpretation |
|-------|----------------|
| 80-100 | Excellent livability |
| 60-79 | Good livability |
| 40-59 | Average livability |
| 20-39 | Below average |
| 0-19 | Poor livability |

### Backend Implementation Details

The scoring algorithm is implemented in `backend/core/scoring.py` through the `LivabilityScorer` class, which is invoked by the `/analyze` endpoint in `backend/app/main.py`.

#### LivabilityScorer Class Architecture

```python
class LivabilityScorer:
    """Calculate livability score based on spatial factors."""
    
    # Constants define weights and radii
    WEIGHT_GREENERY = 14.0      # Max contribution
    PENALTY_INDUSTRIAL = 10.0   # Max penalty
    GREENERY_RADIUS = 175       # Search radius in meters
    BASE_SCORE = 40.0           # Starting point
    
    # Static methods for each factor calculation
    @staticmethod
    def calculate_greenery_score(tree_count: int, park_count: int) -> float: ...
    
    @staticmethod
    def calculate_industrial_penalty(in_industrial_area: bool) -> float: ...
    
    # Main scoring method
    @classmethod
    def calculate_score(cls, ...) -> Dict: ...
```

The class uses:
- **Class-level constants**: All weights (e.g., `WEIGHT_GREENERY = 14.0`) and search radii (e.g., `GREENERY_RADIUS = 175`) are defined as class attributes. The `/analyze` endpoint imports these constants to ensure spatial queries use the same radii as the scoring documentation.
- **Static methods**: Each factor has a dedicated calculation method (e.g., `calculate_greenery_score()`, `calculate_accident_penalty()`)
- **Type safety**: Method signatures specify exact parameter types and return `float` values

#### API Integration Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    /analyze Endpoint Request Flow                        │
└─────────────────────────────────────────────────────────────────────────┘

1. POST /analyze  ─────────────────────────────────────────────────────────►
   { "latitude": 53.0793, "longitude": 8.8017 }

2. Create PostGIS Point ───────────────────────────────────────────────────►
   point = cast(ST_SetSRID(ST_MakePoint(lon, lat), 4326), Geography)

3. Execute 21 Spatial Queries (parallel where possible) ──────────────────►
   ┌──────────────────────────────────────────────────────────────────┐
   │  For each feature type:                                          │
   │  SELECT id, name, ST_AsGeoJSON(geometry), ST_Distance(geom, pt) │
   │  FROM gis_data.<table>                                           │
   │  WHERE ST_DWithin(geometry, point, <radius>)                     │
   │  ORDER BY dist                                                   │
   └──────────────────────────────────────────────────────────────────┘

4. Aggregate Feature Counts ───────────────────────────────────────────────►
   tree_count=45, park_count=2, near_industrial=False, ...

5. Call LivabilityScorer.calculate_score() ────────────────────────────────►
   Returns: { score: 72.5, base_score: 40.0, factors: [...], summary: "..." }

6. Build Response with Nearby Features ────────────────────────────────────►
   LivabilityScoreResponse(score=72.5, nearby_features={trees: [...], ...})
```

#### Spatial Query Execution

The `/analyze` endpoint uses the `fetch_nearby_features()` helper function to execute spatial queries. Critically, **the search radii are imported from `LivabilityScorer` constants** to ensure consistency between queries and scoring documentation:

```python
from core.scoring import LivabilityScorer

# Example: Trees use the GREENERY_RADIUS constant (175m)
trees = fetch_nearby_features(
    session, Tree, point, 
    LivabilityScorer.GREENERY_RADIUS,  # Single source of truth
    "tree"
)

# Example: Amenities use AMENITIES_RADIUS (550m)
amenities = fetch_nearby_features(
    session, Amenity, point,
    LivabilityScorer.AMENITIES_RADIUS,
    "amenity",
    type_field="amenity_type"
)
```

The `fetch_nearby_features()` helper function executes spatial queries using GeoAlchemy2:

```python
def fetch_nearby_features(
    session: Session,
    model,              # ORM model (e.g., Tree, Park)
    point,              # PostGIS geography point
    radius: float,      # Search distance in meters (from LivabilityScorer)
    feature_type: str,  # Type label for response
    type_field: str = None,   # Optional subtype column
    name_field: str = "name"
) -> List[FeatureDetail]:
    """Execute spatial query and return feature details."""
    
    statement = (
        select(
            model.id,
            getattr(model, name_field).label("name"),
            ST_AsGeoJSON(model.geometry).label("geojson"),
            ST_Distance(model.geometry, point).label("dist")
        )
        .where(ST_DWithin(model.geometry, point, radius))
        .order_by("dist")
    )
    
    results = session.exec(statement).all()
    # Convert to FeatureDetail objects with distance
    return [FeatureDetail(...) for row in results]
```

> **Single Source of Truth**: All 21 spatial queries in `main.py` use `LivabilityScorer.*_RADIUS` constants. This ensures the query radii always match the factor documentation and descriptions shown in the API response.

**Key PostGIS Functions Used**:
- `ST_DWithin(geom1, geom2, distance)`: Returns true if geometries are within specified distance (meters for Geography type)
- `ST_Distance(geom1, geom2)`: Returns distance in meters between two geographies
- `ST_AsGeoJSON(geom)`: Converts geometry to GeoJSON for frontend display
- `ST_MakePoint(lon, lat)` + `ST_SetSRID(..., 4326)`: Creates a WGS84 point from coordinates

#### Factor Calculation Pipeline

Each factor follows a consistent calculation pattern:

**Count-Based Positive Factors** (with logarithmic scaling):
```python
@staticmethod
def calculate_amenities_score(amenity_count: int) -> float:
    """Calculate amenities score (0-10)."""
    if amenity_count == 0:
        return 0.0
    return min(10.0, math.log1p(amenity_count) * 2.8)
```

**Binary Negative Factors** (presence/absence):
```python
@staticmethod
def calculate_industrial_penalty(in_industrial_area: bool) -> float:
    """Calculate industrial area penalty (0-10)."""
    return 10.0 if in_industrial_area else 0.0
```

**Composite Factors** (combining multiple data sources):
```python
@staticmethod
def calculate_greenery_score(tree_count: int, park_count: int) -> float:
    """Calculate greenery score (0-14)."""
    tree_score = min(9.0, math.log1p(tree_count) * 2.0)
    park_score = min(5.0, park_count * 2.5)
    return tree_score + park_score
```

#### Score Aggregation and Clamping

The final score is computed in `calculate_score()`:

```python
# Sum all positive factor contributions
positive = (greenery + amenities + transport + healthcare + 
            bike_infra + education + sports + pedestrian + cultural)

# Sum all negative factor penalties
negative = (accident_penalty + industrial_penalty + roads_penalty + 
            noise_penalty + railway_penalty + gas_station_penalty + 
            waste_penalty + power_penalty + parking_penalty + 
            airport_penalty + construction_penalty)

# Apply formula with clamping to [0, 100]
final_score = max(0.0, min(100.0, cls.BASE_SCORE + positive - negative))
```

#### Response Generation

The scoring method generates three key outputs:

1. **factors** (`List[FactorBreakdown]`): Detailed breakdown for each contributing factor
   ```python
   FactorBreakdown(
       factor="Greenery",
       value=10.2,                              # Contribution amount
       description="45 trees, 2 parks within 175m",
       impact="positive"                        # or "negative"
   )
   ```

2. **summary** (`str`): Human-readable summary based on thresholds
   ```python
   summary_parts = []
   if greenery >= 10:
       summary_parts.append("Great greenery")
   if near_industrial:
       summary_parts.append("Industrial area nearby")
   summary = ". ".join(summary_parts) if summary_parts else "Average livability"
   ```

3. **nearby_features** (`Dict`): GeoJSON features for map display (added by `main.py`)
   ```python
   nearby_features = {
       "trees": [FeatureDetail(...), ...],
       "parks": [FeatureDetail(...), ...],
       ...
   }
   ```

---

## Frontend Implementation

### Architecture

```
frontend/bli/lib/
├── core/                   # Global / Shared
│   ├── services/           # ApiService, DeepLinkService
│   ├── theme/              # AppTheme
│   ├── utils/              # FeatureStyles
│   └── widgets/            # Shared widgets (GlassContainer, LoadingOverlay)
├── features/
│   ├── auth/               # Authentication Feature
│   │   ├── bloc/           # AuthBloc, AuthEvent, AuthState
│   │   ├── screens/        # AuthScreen, EmailLinkPromptScreen
│   │   └── services/       # AuthService (Firebase integration)
│   ├── map/                # Map Feature
│   │   ├── bloc/           # MapBloc, MapEvent, MapState
│   │   ├── models/         # Map-related models (Score, Marker, etc.)
│   │   ├── screens/        # MapScreen
│   │   └── widgets/        # ScoreCard, ScoreCardView, FloatingSearchBar, etc.
│   ├── onboarding/         # Onboarding Feature
│   │   └── screens/        # StartScreen
│   ├── favorites/          # Favorites Feature
│   │   ├── bloc/           # FavoritesBloc, FavoritesEvent, FavoritesState
│   │   └── models/         # Favorite location models
│   ├── preferences/        # Preferences Feature
│   │   ├── bloc/           # PreferencesBloc, PreferencesState
│   │   ├── screens/        # PreferencesScreen
│   │   └── services/       # PreferencesService
└── main.dart               # Entry point
```

### Code Generation

The project uses `freezed` and `json_serializable` to generate immutable data models and JSON serialization logic. Code generation is required whenever you modify models in `lib/models/`.

**Run build runner:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Watch mode (auto-rebuild on change):**

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

Generated files (`*.freezed.dart`, `*.g.dart`) are checked into the repository to ensure the app is buildable immediately after cloning.

### Splash Screen & Start Screen

The app uses a two-stage launch experience:

1. **Native Splash Screen** (`flutter_native_splash` package):
   - Configured in `pubspec.yaml`
   - Displays `app_icon.png` centered on teal (`#009688`) background
   - Platform-native implementation (Android, iOS, Web)

2. **Animated Start Screen** (`screens/start_screen.dart`):
   - Displays after Flutter engine loads
   - Icon position matches native splash for seamless transition
   - Animated elements:
     - Title slides down from above with fade-in
     - "Get Started" button fades in
   - Uses `SingleTickerProviderStateMixin` for efficient animation

```dart
// Animation timeline
// 0ms:    Start screen appears (static icon)
// 250ms:  Text animation begins
// 1050ms: All animations complete, user can tap "Get Started"
```

### Map Rendering

Uses `flutter_map` package with CartoDB Voyager tiles (clean style without POI icons):

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
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      subdomains: ['a', 'b', 'c', 'd'],
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

### State Management (BLoC)

The application uses the **BLoC (Business Logic Component)** pattern with `flutter_bloc`.

- **Events (`MapEvent`, `AuthEvent`, `FavoritesEvent`)**: Freezed sealed unions representing user actions
- **State (`MapState`, `AuthState`, `FavoritesState`)**: Freezed immutable state classes with automatic copyWith generation
- **BLoCs (`MapBloc`, `AuthBloc`, `FavoritesBloc`)**: Handle events and emit new states

**Authentication Flow:**
- `AuthBloc` manages user login/logout using Firebase Authentication
- Supports multi-provider auth: Google, GitHub, Email, Guest (Anonymous)
- **Desktop apps (macOS, Windows, Linux)**: Authentication is bypassed entirely; users enter as local guests without Firebase. This is because Firebase Auth has limited desktop support:
  - **macOS**: `signInAnonymously()` fails with a `keychain-error` due to sandboxing restrictions that prevent keychain access
  - **Windows/Linux**: `signInWithProvider()` (used for Google/GitHub OAuth) throws "Operation is not supported on non-mobile systems"
- Auth state is persisted and checked on app startup
- Cross-device email flow: `pendingEmailLink` state triggers `EmailLinkPromptScreen`

**Favorites Management:**
- `FavoritesBloc` manages favorite locations stored in Firestore
- Syncs with authenticated user's Firestore collection
- Persists locally and updates on user actions

```dart
// Example: Handling a map tap
on<MapTapped>((event, emit) async {
  emit(state.copyWith(isLoading: true));
  final score = await _apiService.analyzeLocation(event.position);
  emit(state.copyWith(currentScore: score, isLoading: false));
});

// Example: Handling authentication
on<GoogleSignIn>((event, emit) async {
  emit(AuthState.loading());
  final user = await _authService.signInWithGoogle();
  emit(AuthState.authenticated(user: user));
});
```

**View (BlocBuilder)** uses `BlocBuilder<MapBloc, MapState>` to rebuild on state changes.

### User Interface (Liquid Glass Design)

The application uses Apple's **Liquid Glass** design language, implemented via the `liquid_glass_easy` package:

- **Design System (`AppTheme`)**:
  - **Palette**: Centralized `AppColors` including a standardized **Feature Palette** for map markers (e.g., Cyan for Education, Teal for Culture), ensuring no hardcoded colors.
  - **Typography**: Unified `AppTextStyles` for consistency.
  - **Standardization**: Widgets access styles via `Theme.of(context)` or `AppColors`.

- **Visual Style**:
  - **Immersive Map**: Full-screen map with no app bar.
  - **Liquid Glass Lenses**: UI controls (search, profile, location buttons) use `LiquidGlass` widgets with:
    - `magnification: 1.05` for subtle depth
    - `distortion: 0.10` for realtime background refraction
    - **Interactive Feedback**: All glass buttons feature:
      - **Scale Animations**: Shrink on press, bounce back on release.
      - **"Breathe" Effect**: On long press, buttons shrink then slowly expand to 115% before restoring.
      - **Haptic Feedback**: `HapticFeedback.lightImpact()` on press for tactile confirmation.
  - **Animated Search Bar**: The search button morphs into a full-width search bar using a unified `LiquidGlass` lens. The expansion is driven by an `AnimationController` synced with an `AnimatedSwitcher` for smooth content transitions (icon ↔ input field).

- **Key Components**:
  - `LiquidGlassView`: Manages the stack of glass lenses over the map background to optimize performance.
  - `LiquidGlass`: Core widget providing the frosted glass look with real-time background sampling.
  - `GlassContainer`: Fallback frosted glass widget (for areas outside `LiquidGlassView`).
  - `ScoreCardView`: Displays livability score breakdown.
  - `AddressSearchWidget`: Search input with debounced geocoding.

### Firebase Setup

The app uses Firebase for authentication and favorites sync:

1. **Web**: Uses Firebase OAuth popup authentication (`signInWithPopup`) for Google/GitHub
2. **Mobile**: Uses native authentication packages with deep link handling
3. **Desktop (macOS, Windows, Linux)**: Authentication is disabled; users enter directly as local guests. Firebase Auth has limited support for desktop platforms—macOS sandboxing causes `keychain-error` on anonymous sign-in, and Windows/Linux do not support `signInWithProvider()` for OAuth flows (Google, GitHub). The `AuthService.signInAsGuest()` method returns a local `AppUser.guest()` instance without contacting Firebase.
4. **Email Magic Links**: Firebase Hosting redirects email links to the web/mobile app
5. **Cross-Device Email Flow**: When a user clicks an email link on a different device/browser, the app prompts them to re-enter their email to complete authentication
6. **Android Release Signing**: Production builds are signed via GitHub Actions using repository secrets

**Authentication Providers (Web/Mobile only)**: Google, GitHub, Email (Magic Link), Anonymous (Guest)

**Email Deep Links Setup**:
- Firebase Hosting serves a redirect page at `bremen-livability-index.firebaseapp.com/login`
- Android: App Links configured in `AndroidManifest.xml` with SHA256 verification
- iOS: Falls back to web app (Universal Links require paid Apple Developer account)
- Cross-device: `DeepLinkService` detects missing email and shows `EmailLinkPromptScreen`

### API Configuration

The API URL is configured in `lib/core/services/api_service.dart`.

**Default**: Production Backend (`https://bremen-livability-backend.onrender.com`)

**To use local backend:**
1. Open `lib/core/services/api_service.dart`
2. Uncomment the localhost line and comment out the Render URL

### Code Generation

If you modify data models (`lib/features/map/models/*.dart`), you must run the build runner to regenerate JSON serialization code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Responsive UI
- The application uses `LayoutBuilder` and `MediaQuery` to adapt to different screen sizes.
- **Constraints**:
  - `AuthScreen` limits content width to 600px on tablet/desktop for better readability.
  - `FavoritesScreen` adapts list view padding and card dimensions.
  - `StartScreen` scales illustrations and text based on available height.

---

## Testing

### Backend Tests

Located in `backend/tests/`:

### Frontend Tests

Located in `frontend/bli/test/`:

- **Auth Feature (`test/features/auth/`)**:
  - `auth_bloc_test.dart`: 100% coverage of authentication logic (Google, GitHub, Email, Guest).
  - `auth_screen_test.dart`: Widget tests for UI rendering and responsiveness.
  - `email_auth_screen_test.dart`: Tests for email input and validation.
  
- **Favorites Feature (`test/features/favorites/`)**:
  - `favorites_screen_test.dart`: Tests for loading states, empty states, list rendering, and interactions.
  - `favorites_bloc_test.dart`: (If implemented) Logic tests for adding/removing favorites.

- **Map Feature (`test/features/map/`)**: Tests for map markers and interactions.


**Run tests:**

```bash
cd backend
source venv/bin/activate
pytest tests/ -v
```

**Run with coverage:**

```bash
pytest tests/ --cov --cov-report=html --cov-report=term
```

Coverage configuration is in `backend/pyproject.toml`:

- **Source directories:** `app/`, `core/`, `services/`
- **Minimum threshold:** 50%
- **HTML report:** `backend/htmlcov/`

**Coverage Summary:**

| Module | Coverage |
|--------|----------|
| `app/models.py` | 100% |
| `app/db_models.py` | 100% |
| `core/scoring.py` | 100% |
| `core/database.py` | 100% |
| `services/geocode.py` | 90% |
| `app/main.py` | 91% |
| **Overall** | **98%** |

### Flutter Tests

The project employs a comprehensive testing strategy using `flutter_test`, `bloc_test`, and `mockito`.

**Test Types:**

- **Unit Tests**: For core logic, models, and services (mocking external dependencies like `Dio`)
- **Widget Tests**: For UI components and screens
- **BLoC Tests**: For state management logic (Map, Auth, Favorites)
- **Integration Tests**: For complete user workflows

Located in `frontend/bli/test/`:

```
test/
├── core/
│   ├── services/           # api_service_test.dart, auth_service_test.dart
│   ├── theme/              # app_theme_test.dart (15 tests)
│   ├── utils/              # feature_styles_test.dart (25 tests)
│   └── widgets/            # glass_container, loading_overlay tests
└── features/
    ├── auth/
    │   └── bloc/           # auth_bloc_test.dart (15+ tests)
    ├── map/
    │   ├── bloc/           # map_bloc_test.dart (20+ tests)
    │   ├── screens/        # map_screen_test.dart (~25 tests)
    │   └── widgets/        # ScoreCardView, ScoreCard, FloatingSearchBar, AddressSearch,
    │                       # NearbyFeatures, MapControlButtons, ProfileSheet tests (50+ tests)
    ├── favorites/
    │   └── bloc/           # favorites_bloc_test.dart (10+ tests)
    ├── preferences/
    │   ├── bloc/           # preferences_bloc_test.dart
    │   └── services/       # preferences_service_test.dart
    └── onboarding/
        ├── screens/        # start_screen_test.dart
        └── widgets/        # start_screen_title_test.dart, start_screen_actions_test.dart (20+ tests)
```

**Test Statistics:**

- **Total Tests**: 354+
- **Execution Time**: ~15-20 seconds
- **Status**: ✅ All passing

**Run tests:**

```bash
cd frontend/bli
flutter test
```

**Run with coverage:**

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Coverage Summary:**

| Module | Coverage |
|--------|----------|
| `features/map/widgets/score_card.dart` (ScoreCard) | 100% |
| `features/map/widgets/score_card_view.dart` (ScoreCardView) | 100% |
| `core/widgets/glass_container.dart` | 100% |
| `core/widgets/loading_overlay.dart` | 100% |
| `features/map/widgets/floating_search_bar.dart` | 100% |
| `features/map/widgets/search_results_list.dart` | 100% |
| `features/map/models/location_marker.dart` | 100% |
| `features/map/models/livability_score.dart` | 100% |
| `features/map/models/factor.dart` | 100% |
| `features/map/models/location.dart` | 100% |
| `features/map/widgets/nearby_feature_layers.dart` | 100% |
| `core/utils/feature_styles.dart` | 100% |
| `features/map/screens/map_screen.dart` | ~90% |
| `core/services/api_service.dart` | ~69% |
| `features/map/bloc/map_bloc.dart` | ~95% |
| `features/auth/bloc/auth_bloc.dart` | ~90% |
| `features/auth/services/auth_service.dart` | ~93% |
| `features/map/widgets/map_control_buttons.dart` | 100% |
| `features/map/widgets/profile_sheet.dart` | ~90% |
| `features/onboarding/widgets/start_screen_title.dart` | 100% |
| `features/onboarding/widgets/start_screen_actions.dart` | 100% |
| **Overall** | **~90%** |
| **Total Tests** | **354+ tests** |

### CI/CD Coverage

Test coverage is automatically collected on every push via GitHub Actions and uploaded to [Codecov](https://codecov.io/gh/Milad9A/Bremen-Livability-Index).

**Workflow files:**

- `.github/workflows/backend-tests.yml` - Runs on `backend/**` changes
- `.github/workflows/frontend-tests.yml` - Runs on `frontend/**` changes
- `.github/workflows/build-release.yml` - Builds apps after Frontend Tests pass

**Coverage collection:**

1. **Backend tests** with `pytest-cov` → uploads `coverage.xml`
2. **Frontend tests** with `flutter test --coverage` → uploads `lcov.info`

Build releases only proceed if Frontend Tests pass (via `workflow_run` trigger in `build-release.yml`).
Render deployments only proceed after relevant CI checks pass.

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
│   PostgreSQL    │                │  - Android APK (signed)│
│   + PostGIS     │                │  - Windows .exe        │
│                 │                │  - macOS .app          │
│                 │                │  - Linux bundle        │
└─────────────────┘                └────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    FIREBASE HOSTING                         │
│              (Email Magic Link Redirects)                   │
├─────────────────────────────────────────────────────────────┤
│  /.well-known/apple-app-site-association → iOS Universal   │
│  /.well-known/assetlinks.json → Android App Links          │
│  /login/ → Redirect page (web fallback)                    │
└─────────────────────────────────────────────────────────────┘
```

### Auto-Deployment Flow

1. **Push to `master`** triggers:
   - **GitHub Actions**: Path-filtered test workflows run in parallel
     - `backend/**` changes → `backend-tests.yml`
     - `frontend/**` changes → `frontend-tests.yml`
   - **Render**: Deploys immediately on commit ("On Commit" trigger)

2. **Build and Release** (frontend changes only):
   - Triggered by `workflow_run` after Frontend Tests pass
   - Builds Android, Windows, Linux, macOS apps
   - Creates GitHub Release with all artifacts

### Android Release Signing

Production APKs are signed using GitHub Actions secrets:

| Secret | Description |
|--------|-------------|
| `KEYSTORE_BASE64` | Base64-encoded upload keystore (`.jks` file) |
| `KEY_ALIAS` | Keystore alias name |
| `KEY_PASSWORD` | Key password |
| `STORE_PASSWORD` | Keystore password |

**Build process** (`build-release.yml`):

1. Decode keystore from `KEYSTORE_BASE64` secret
2. Create `key.properties` with credentials
3. Build signed APK with `flutter build apk --release`

### macOS Build Notes

- **CocoaPods Caching**: Firebase dependencies are cached to reduce build time (~20 min savings)
- **Ad-hoc Signing**: Builds are signed with `codesign -s -` for distribution
- **Gatekeeper**: Users must right-click → Open to bypass Gatekeeper on first launch

### Firebase Hosting Deployment

Email magic link redirects are hosted on Firebase Hosting:

```bash
cd frontend/bli/firebase_hosting
firebase deploy --only hosting --project bremen-livability-index
```

**Deployed files**:

- `/.well-known/apple-app-site-association` - iOS app verification
- `/.well-known/assetlinks.json` - Android app verification (SHA256)
- `/login/index.html` - Redirect page with mobile/web detection

### Render Deployment Process

   ```bash
   # 1. Initialize database schema (safe to run repeatedly - uses IF NOT EXISTS)
   python -m scripts.initialize_db
   
   # 2. Check if any required tables are empty (avoids re-ingesting 150k+ records)
   if ANY of these tables are empty:
     gis_data.trees, parks, amenities, public_transport, healthcare,
     industrial_areas, major_roads, bike_infrastructure, education,
     sports_leisure, pedestrian_infra, cultural_venues, noise_sources,
     accidents, railways, gas_stations, waste_facilities,
     power_infrastructure, parking_lots, airports, construction_sites
     → run python -m scripts.ingest_all_data (full OSM + Unfallatlas ingestion)
   else:
     skip ingestion (data persists in Neon.tech across deploys)
   
   # 3. Start server
   uvicorn app.main:app --host 0.0.0.0 --port $PORT
   ```

   **Key Points:**
   - Database schema is idempotent (`CREATE TABLE IF NOT EXISTS`)
   - Data ingestion only runs on first deploy, after database reset, or when any required table is empty
   - Neon.tech database persists data across Render deploys
   - Subsequent deploys take ~10 seconds (schema check + server start)

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://user:pass@host/db` |
| `PORT` | Server port (set by Render) | `8000` |
| `CORS_ORIGINS` | Allowed CORS origins | `*` or `https://example.com` |
| `LOG_LEVEL` | Logging verbosity | `INFO` |

### Testing in Production

GitHub Actions runs tests on every push, independent of Render deployment:

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `backend-tests.yml` | `backend/**` changes | Runs pytest against test database |
| `frontend-tests.yml` | `frontend/**` changes | Runs Flutter tests |
| `build-release.yml` | After frontend tests pass | Builds app releases |

Tests run in isolated environments with their own databases (GitHub Actions PostgreSQL service). Production data in Neon.tech is never affected by tests.

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

---

## External Resources & References

### OpenStreetMap Resources

| Resource | URL | Purpose |
|----------|-----|---------|
| **Overpass API** | [overpass-api.de](https://overpass-api.de) | Primary data query endpoint |
| **Overpass Turbo** | [overpass-turbo.eu](https://overpass-turbo.eu) | Interactive query testing tool |
| **OSM Wiki** | [wiki.openstreetmap.org/wiki/Map_features](https://wiki.openstreetmap.org/wiki/Map_features) | Tag documentation |
| **TagInfo** | [taginfo.openstreetmap.org](https://taginfo.openstreetmap.org) | Tag usage statistics |

### Traffic Accident Data

| Resource | URL | Purpose |
|----------|-----|---------|
| **Unfallatlas** | [unfallatlas.statistikportal.de](https://unfallatlas.statistikportal.de) | Official German accident statistics portal |
| **Download Portal** | [unfallatlas.statistikportal.de/_opendata](https://unfallatlas.statistikportal.de/_opendata2024.html) | CSV/GeoJSON data downloads |
| **License Info** | dl-de/by-2-0 | [datenlizenz-deutschland.de](https://www.govdata.de/dl-de/by-2-0) |

**Data Fields Used**:

- `XGCSWGS84`, `YGCSWGS84`: WGS84 coordinates
- `UKATEGORIE`: Accident severity (1=fatal, 2=serious injury, 3=minor injury)
- `UJAHR`: Year (2019-2023)
- `ULAND`: State code (filter: 04 = Bremen)

### Framework & Library Documentation

| Technology | Documentation | Version Used |
|------------|---------------|--------------|
| **FastAPI** | [fastapi.tiangolo.com](https://fastapi.tiangolo.com) | 0.115.x |
| **SQLModel** | [sqlmodel.tiangolo.com](https://sqlmodel.tiangolo.com) | 0.0.x |
| **GeoAlchemy2** | [geoalchemy-2.readthedocs.io](https://geoalchemy-2.readthedocs.io) | 0.15.x |
| **PostGIS** | [postgis.net/documentation](https://postgis.net/documentation) | 3.4 |
| **Flutter** | [flutter.dev/docs](https://flutter.dev/docs) | 3.x |
| **Dio** | [pub.dev/packages/dio](https://pub.dev/packages/dio) | 5.x |
| **Freezed** | [pub.dev/packages/freezed](https://pub.dev/packages/freezed) | 2.x |
| **flutter_map** | [fleaflet.dev](https://fleaflet.dev) | 8.x |
| **liquid_glass_easy** | [pub.dev/packages/liquid_glass_easy](https://pub.dev/packages/liquid_glass_easy) | 1.1.x |
| **Overpy** | [pypi.org/project/overpy](https://pypi.org/project/overpy/) | 0.7 |

### Spatial Function Reference

Key PostGIS functions used in the scoring algorithm:

| Function | Purpose | Example |
|----------|---------|---------|
| `ST_SetSRID(ST_MakePoint())` | Create point geometry | `ST_SetSRID(ST_MakePoint(8.8, 53.0), 4326)` |
| `ST_DWithin()` | Find features within distance | `ST_DWithin(geom, point, 300)` |
| `ST_Distance()` | Calculate distance in meters | `ST_Distance(geom::geography, point::geography)` |
| `ST_Intersects()` | Check geometry intersection | `ST_Intersects(polygon, point)` |
| `ST_AsGeoJSON()` | Convert to GeoJSON | `ST_AsGeoJSON(geom)` |

### Bremen-Specific Resources

| Resource | URL | Description |
|----------|-----|-------------|
| **Geoportal Bremen** | [geoportal.bremen.de](https://www.geoportal.bremen.de) | Official Bremen geodata portal |
| **OpenData Bremen** | [daten.bremen.de](https://daten.bremen.de) | Bremen open data catalog |
| **Bremen OSM Community** | [wiki.openstreetmap.org/wiki/Bremen](https://wiki.openstreetmap.org/wiki/Bremen) | Local mapping guidelines |

---

## License

This project is developed as part of the Geodatenverarbeitung course at the University of Bremen.
OpenStreetMap data is licensed under [ODbL 1.0](https://opendatacommons.org/licenses/odbl/).
Unfallatlas data is licensed under [dl-de/by-2-0](https://www.govdata.de/dl-de/by-2-0).
