<div align="center">
  <img src="frontend/bli/assets/app_icon_rounded.png" alt="Bremen Livability Index Icon" width="128" height="128">

  # Bremen Livability Index (BLI)
</div>

[![Backend CI](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/backend-ci.yml/badge.svg)](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/backend-ci.yml)
[![Build and Release Apps](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/build-release.yml/badge.svg)](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/build-release.yml)

A comprehensive geospatial platform featuring a **Flutter mobile & web application** and a **Python FastAPI backend**. It calculates Quality of Life scores for any location in Bremen, Germany, in real-time.

## 🌐 Live Applications

Access the Bremen Livability Index on multiple platforms:

### 🕸️ Web Application
**Live App:** [bremen-livability-frontend.onrender.com](https://bremen-livability-frontend.onrender.com)  
Run the full app directly in your browser—no installation required.

### 📡 API Endpoint
**Live API:** [bremen-livability-backend.onrender.com](https://bremen-livability-backend.onrender.com)  
**Docs:** [bremen-livability-backend.onrender.com/docs](https://bremen-livability-backend.onrender.com/docs)  
RESTful API for livability analysis and geocoding.

### 📱 & 🖥️ Native Applications

**Download the latest version for all platforms from [GitHub Releases](https://github.com/Milad9A/Bremen-Livability-Index/releases/latest).**

| Platform | File | Instructions |
|----------|------|--------------|
| **iOS** | `Runner.app` / Source | Run via Xcode / Flutter |
| **Android** | `BLI-Android.apk` | Install APK on device. |
| **Windows** | `BLI-Windows.zip` | Extract and run `bli.exe`. |
| **macOS** | `BLI-macOS.zip` | Extract and run `bli.app`. |
| **Linux** | `BLI-Linux.tar.gz` | Extract and run `./bundle/bli`. |

> ⚠️ **Note:** Desktop builds are unsigned. You may need to verify them in your system security settings (e.g., "Open Anyway" in Windows Defender or macOS Gatekeeper).

> All platforms use the same backend API and provide the same core functionality.

## ✨ Features

### 🗺️ Interactive Map
- **Immersive Design**: Full-screen map with "Liquid Glass" floating controls
- **Modern UI**: Frosted glass effects using custom `GlassContainer` widgets
- OpenStreetMap tiles for detailed geography
- Real-time marker placement

### 🚀 Splash & Start Screen
- **Native Splash Screen**: Platform-native splash with app icon on teal background
- **Animated Start Screen**: Smooth fade-in of title, subtitle, and "Get Started" button
- **Seamless Transition**: Icon position matches between splash and start screen for fluid UX

### 📍 Location Analysis
- **Tap-to-Analyze**: Click anywhere on the map for instant scoring
- **Address Search**: Search for streets, landmarks, or areas (e.g., "Bürgermeister-Smidt-Straße", "Schwachhausen")
- Instant livability score calculation
- Detailed breakdown of all 7 factors with visual indicators

##  Scoring System

The livability score is calculated using 7 spatial factors:

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
**Total Range:** 0-100

### Data Summary

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

## 🚀 Quick Start

### 1. Start Database
```bash
cd backend && docker-compose up -d
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
python -m scripts.ingest_all_data
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

## 📡 API Documentation

### Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | API info |
| `/health` | GET | Health check |
| `/analyze` | POST | Analyze location livability |
| `/geocode` | POST | Search addresses (OpenStreetMap) |

### Analyze Location

**Endpoint:** `POST /analyze`

Calculate livability score for a specific coordinate.

```bash
curl -X POST http://localhost:8000/analyze \
  -H "Content-Type: application/json" \
  -d '{"latitude": 53.0793, "longitude": 8.8017}'
```

**Example Response:**
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

```bash
curl -X POST http://localhost:8000/geocode \
  -H "Content-Type: application/json" \
  -d '{"query": "Bürgermeister-Smidt-Straße", "limit": 5}'
```

**Example Response:**
```json
{
  "results": [
    {
      "latitude": 53.0810562,
      "longitude": 8.8049425,
      "display_name": "Bürgermeister-Smidt-Straße, Bahnhofsvorstadt, Mitte, Bremen, 28195, Deutschland",
      "type": "secondary"
    }
  ],
  "count": 1
}
```

> **Note:** Geocoding uses the free OpenStreetMap Nominatim API with a rate limit of 1 request/second. Queries are automatically prioritized for Bremen, Germany results.

## 🏗️ Architecture

- **Backend**: FastAPI (Python) with SQLModel ORM + GeoAlchemy2 for PostGIS
- **Frontend**: Flutter mobile & web application ("BLI")
- **Database**: PostgreSQL 15 with PostGIS 3.3
- **Data Sources**: OpenStreetMap, German Accident Atlas (Unfallatlas)

### Project Structure

```
Project/
├── backend/
│   ├── app/                 # Main application code
│   ├── core/                # Business logic
│   ├── services/            # External services
│   ├── scripts/             # Data ingestion & utilities
│   ├── tests/               # API tests
│   ├── init_db.sql          # Database schema
│   └── requirements.txt
├── frontend/bli/            # Flutter app
│   ├── lib/                 # Dart source code
│   ├── test/                # Flutter tests
│   ├── android/             # Android platform
│   ├── ios/                 # iOS platform
│   ├── macos/               # macOS platform
│   ├── windows/             # Windows platform
│   ├── linux/               # Linux platform
│   └── web/                 # Web platform
├── .github/workflows/       # CI/CD workflows
├── docker-compose.yml
├── TECHNICAL.md             # Detailed technical documentation
└── README.md
```

> 📖 For in-depth technical details (database schema, scoring algorithm, data pipelines), see [TECHNICAL.md](TECHNICAL.md).

## ☁️ Deployment

### Cloud Setup (Free Forever)

1. **Database**: [Neon.tech](https://neon.tech) (PostgreSQL + PostGIS)
2. **Backend**: [Render.com](https://render.com) (Python FastAPI Web Service)
3. **Frontend**: [Render.com](https://render.com) (Static Site)

### Deployment Files

| File | Purpose |
|------|---------|
| `backend/docker-compose.yml` | **Local Development**: Runs local PostgreSQL/PostGIS database |
| `backend/Dockerfile` | **Cloud Backend**: Builds the API application container |
| `backend/render.yaml` | **Backend Config**: Render Web Service + Database connection |
| `frontend/bli/render.yaml` | **Frontend Config**: Render Static Site (Flutter Web) |

### Automated Deployment

The project uses a complete CI/CD pipeline:

1.  **Backend Deployment**:
    *   **Render** auto-deploys from `backend/Dockerfile` on push.
    *   `entrypoint.sh` initializes the DB and ingests data.

2.  **GitHub Actions Pipelines**:
    *   **Backend CI**: Runs `pytest` on push.
    *   **App Build & Release**: Runs tests & builds for Android, Windows, Linux, and macOS, then publishes to a single "Latest" release.

## 💻 Flutter Development

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- iOS Simulator (Mac), Android Emulator, or Chrome (for web)

### Running the App

```bash
cd frontend/bli
flutter pub get
flutter run              # Default device
flutter run -d chrome    # Web
flutter run -d emulator-5554  # Android emulator
flutter run -d "iPhone"  # iOS Device (requires Xcode)
```

### API Configuration

The API URL is configured in `lib/services/api_service.dart`.

**Default**: Production Backend (`https://bremen-livability-backend.onrender.com`)

**To use local backend:**
1. Open `lib/services/api_service.dart`
2. Uncomment the localhost line and comment out the Render URL

### Backend Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://postgres:postgres@localhost:5433/bremen_livability` |
| `PORT` | Server port (Render/Railway) | `8000` |
| `API_PORT` | Server port (local dev) | `8000` |
| `CORS_ORIGINS` | Allowed CORS origins (comma-separated or `*`) | `*` |
| `LOG_LEVEL` | Logging level (DEBUG, INFO, WARNING, ERROR) | `INFO` |

### App Icons

The app icon is generated from `assets/app_icon.png` using `flutter_launcher_icons`.

**To update the icon:**
```bash
# Replace assets/app_icon.png, then run:
dart run flutter_launcher_icons
```

### Android APK Installation

If you've downloaded the APK from [GitHub Releases](../../releases/tag/latest), follow these steps:

1. **Download the APK** from the [latest release](../../releases/tag/latest)
2. **Enable installation** on your Android device:
   - Go to **Settings** → **Security** → Enable **Unknown Sources**
   - Or on newer Android: **Settings** → **Apps** → **Special Access** → **Install Unknown Apps**
3. **Install**: Open the downloaded APK file and tap **Install**
4. **Launch**: Start exploring Bremen's livability!

> The APK is automatically built and updated on every push to the repository via GitHub Actions.


## 🧪 Testing

### Backend API Tests
```bash
cd backend
source venv/bin/activate
pytest tests/ -v
```

### Flutter Tests
```bash
cd frontend/bli
flutter test              # Run all tests
flutter test --coverage   # Generate coverage report
```

**Test Coverage:**
| File | Tests | Coverage |
|------|-------|----------|
| `api_service_test.dart` | 19 | Model parsing, utilities |
| `score_card_test.dart` | 6 | Widget rendering |
| `nearby_feature_layers_test.dart` | 8 | Geometry parsing |

### Postman Collection

A Postman collection is included in `backend/Bremen_Livability_Index.postman_collection.json`.

**Features:**
- **Environment Switching**: Use the `environment_mode` variable to switch between `local` and `deployed`
  - `deployed`: `https://bremen-livability-backend.onrender.com`
  - `local`: `http://127.0.0.1:8000`
- **Pre-configured Requests**: Analyze Location, Geocode Address, Health Check, and more

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| Database connection failed | `docker ps` to check container status |
| Port 8000 in use | `lsof -i :8000` then `kill -9 <PID>` |
| Overpass API timeout | Retry - the API has rate limits |
| Flutter build errors | Run `flutter clean && flutter pub get` |

## 📄 License

University project for educational purposes.

## 🙏 Acknowledgments

- OpenStreetMap contributors
- German Accident Atlas (Statistisches Bundesamt)
