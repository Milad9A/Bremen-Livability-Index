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
|-------|------------|---------|
| **Frontend** | Flutter 3.x | Cross-platform mobile & web app |
| **HTTP Client** | Dio 5.x | HTTP client with interceptors and error handling |
| **Models** | Freezed + json_serializable | Immutable data classes with JSON serialization |
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
| **Traffic Accidents** | Historical accident data reveals dangerous intersections and streets. High accident density indicates safety risks for pedestrians, cyclists, and drivers. | Police-reported accidents (2019-2023) within 90m, weighted by severity |
| **Industrial Areas** | Industrial zones generate noise, air pollution, heavy traffic, and visual blight. Residential proximity to industry correlates with lower health outcomes. | Industrial land use zones within 125m (binary detection) |
| **Major Roads** | Highways and primary roads produce constant noise, air pollution (particulates, NOx), and create pedestrian barriers. Living near major roads linked to respiratory issues. | Motorways, trunk roads, primary roads within 40m (binary detection) |
| **Noise Sources** | Nightclubs, bars, and car repair shops generate noise pollution that disrupts sleep and reduces quality of life, especially during evening hours. | Nightclubs, bars, pubs, fast food outlets, car repair shops within 60m |
| **Railways** | Active railway lines generate noise from passing trains and vibration. Level crossings create barriers and safety concerns for pedestrians. | Railway tracks and stations within 75m (binary detection) |
| **Gas Stations** | Petrol/gas stations produce fuel odors, attract vehicle traffic, and pose fire/explosion risks. Underground tanks may contaminate groundwater. | Fuel stations within 50m (binary detection) |
| **Waste Facilities** | Recycling centers, landfills, and waste processing sites generate odors, attract pests, and increase truck traffic. Visual blight reduces neighborhood appeal. | Recycling centers, landfills, waste processing within 200m (binary detection) |
| **Power Infrastructure** | High-voltage power lines and substations raise concerns about electromagnetic fields. Substations generate noise and visual impact. | Power lines, substations, transformers within 50m (binary detection) |
| **Large Parking Lots** | Surface parking lots create urban heat islands, generate traffic, and are visually unappealing. They indicate car-centric rather than pedestrian-friendly design. | Large parking facilities within 30m (binary detection) |
| **Airports/Helipads** | Aircraft noise significantly impacts quality of life. Airports generate air pollution and constant traffic from departing/arriving passengers. | Airports, heliports, aerodromes within 500m (binary detection) |
| **Construction Sites** | Active construction creates noise, dust, and traffic disruption. While temporary, they significantly impact short-term livability. | Active construction areas within 100m (binary detection) |

### Logarithmic Scaling

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

---

## Frontend Implementation

### Architecture

```
frontend/bli/lib/
├── main.dart                    # App entry point
├── models/
│   ├── models.dart              # Barrel export for all models
│   ├── enums.dart               # Metric & feature enums
│   ├── factor.dart              # Scoring factor (Freezed)
│   ├── feature_detail.dart      # Nearby feature (Freezed)
│   ├── geocode_result.dart      # Search result (Freezed)
│   ├── livability_score.dart    # API response (Freezed)
│   ├── location.dart            # Coordinates (Freezed)
│   └── location_marker.dart     # Map marker (Freezed)
├── utils/
│   └── feature_styles.dart      # Shared styling logic (icons/colors)
├── screens/
│   ├── start_screen.dart        # Animated start screen
│   └── map_screen.dart          # Main map view
├── services/
│   └── api_service.dart         # Dio-based API client
├── viewmodels/
│   └── map_viewmodel.dart       # Map logic & state (MVVM)
├── theme/
│   └── app_theme.dart           # Design system (colors, text styles)
└── widgets/
    ├── address_search.dart      # Search logic wrapper
    ├── search_results_list.dart # Reusable search results list
    ├── floating_search_bar.dart # Collapsed floating search bar
    ├── loading_overlay.dart     # Glass-morphic loading indicator
    ├── nearby_feature_layers.dart  # Map markers
    ├── score_card.dart          # Score display
    └── glass_container.dart     # Reusable glass effect widget
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

  }
}

### State Management (MVVM)

The application uses the **Model-View-ViewModel (MVVM)** pattern with the `provider` package.

- **View (`MapScreen`)**: Stateless widget. Responsibilities:
  - Layout and UI rendering
  - Listening to ViewModel changes
  - Delegating user actions to ViewModel
- **ViewModel (`MapViewModel`)**: Extends `ChangeNotifier`. Responsibilities:
  - Holding UI state (`isLoading`, `currentScore`, `selectedMarker`)
  - Interacting with `ApiService` and `MapController`
  - Rebuilding the View via `notifyListeners()` when state changes

### User Interface (Glassmorphism & Theming)

The application uses a **Liquid Glass** design system supported by a centralized `AppTheme`:

- **Design System (`AppTheme`)**:
    - **Palette**: Centralized `AppColors` (Teal primary, specific semantic colors).
    - **Typography**: Unified `AppTextStyles` for consistency.
    - **Standardization**: Widgets access styles via `Theme.of(context)` or `AppColors`.

- **Visual Style**:
    - **Immersive Map**: Full-screen map with no app bar.
    - **Floating Controls**: Search bar and buttons float above the map.
    - **Glass Effect**: UI elements use `BackdropFilter` with blur (`sigmaX/Y: 10`) and semi-transparent backgrounds to blend with the map.
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

**Run with coverage:**
```bash
pytest tests/ --cov --cov-report=html --cov-report=term
```

Coverage configuration is in `backend/pyproject.toml`:
- **Source directories:** `app/`, `core/`, `services/`
- **Minimum threshold:** 50%
- **HTML report:** `backend/htmlcov/`

| Module | Coverage |
|--------|----------|
| `app/models.py` | 100% |
| `app/db_models.py` | 100% |
| `core/scoring.py` | ~99% |
| `services/geocode.py` | ~90% |
| `app/main.py` | ~89% |
| **Overall** | **~95%** |

### Flutter Tests

Located in `frontend/bli/test/`:

```
test/
├── api_service_test.dart           # API and model unit tests
├── score_card_test.dart            # ScoreCard widget tests
├── nearby_feature_layers_test.dart # Geometry parsing tests
├── widget_test.dart                # Basic widget tests
├── map_viewmodel_test.dart         # ViewModel unit tests
├── map_screen_test.dart            # MapScreen widget tests
├── glass_container_test.dart       # GlassContainer widget tests
├── loading_overlay_test.dart       # LoadingOverlay widget tests
├── floating_search_bar_test.dart   # FloatingSearchBar widget tests
└── search_results_list_test.dart   # SearchResultsList widget tests
```

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

| Module | Coverage |
|--------|----------|
| `widgets/score_card.dart` | 100% |
| `widgets/glass_container.dart` | 100% |
| `widgets/loading_overlay.dart` | 100% |
| `widgets/floating_search_bar.dart` | 100% |
| `widgets/search_results_list.dart` | 100% |
| `models/location_marker.dart` | 100% |
| `screens/map_screen.dart` | ~69% |
| `services/api_service.dart` | ~69% |
| `viewmodels/map_viewmodel.dart` | ~36% |
| **Overall** | **~59%** |

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
│   PostgreSQL    │                │  - Android APK         │
│   + PostGIS     │                │  - Windows .exe        │
│                 │                │  - macOS .app          │
│                 │                │  - Linux bundle        │
└─────────────────┘                └────────────────────────┘
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

3. **Render Deployment Process** (`entrypoint.sh`):
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
| **flutter_map** | [fleaflet.dev](https://fleaflet.dev) | 7.x |
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

