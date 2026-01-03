<div align="center">
  <img src="frontend/bli/assets/app_icon_rounded.png" alt="Bremen Livability Index Icon" width="128" height="128">

  # Bremen Livability Index (BLI)
</div>

[![Tests](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/tests.yml/badge.svg)](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/tests.yml)
[![Build and Release Apps](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/build-release.yml/badge.svg)](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/build-release.yml)
[![codecov](https://codecov.io/gh/Milad9A/Bremen-Livability-Index/graph/badge.svg)](https://codecov.io/gh/Milad9A/Bremen-Livability-Index)

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

- 🗺️ **Interactive Map** – Full-screen OpenStreetMap with "Liquid Glass" UI
- 🚀 **Splash & Start Screen** – Animated launch experience
- 📍 **Tap-to-Analyze** – Instant livability scoring for any location
- 🔍 **Address Search** – Find streets, landmarks, or neighborhoods

## 📊 Scoring System

Livability is calculated from **13 spatial factors** using proximity-based analysis. Score range: **0-100**.

**Positive Factors:** Greenery (trees & parks), Amenities, Public Transport, Healthcare, Bike Infrastructure, Education, Sports & Leisure, Pedestrian Infrastructure, Cultural Venues

**Negative Factors:** Traffic Accidents, Industrial Areas, Major Roads, Noise Sources

> 📖 **Details:** [Scoring Algorithm](TECHNICAL.md#scoring-algorithm) in TECHNICAL.md

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

## 📡 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/analyze` | POST | Analyze location livability |
| `/geocode` | POST | Search addresses |
| `/health` | GET | Health check |

**Interactive Docs:** [/docs](https://bremen-livability-backend.onrender.com/docs) (Swagger UI)

## 🏗️ Architecture

**Backend**: FastAPI + PostgreSQL/PostGIS | **Frontend**: Flutter (cross-platform) | **Data**: OpenStreetMap + Unfallatlas

> 📖 **Details:** [System Architecture](TECHNICAL.md#system-architecture), [Database Design](TECHNICAL.md#database-design), [Backend Implementation](TECHNICAL.md#backend-implementation) in TECHNICAL.md

## ☁️ Deployment

**Cloud Stack (Free Forever)**: [Neon.tech](https://neon.tech) (PostgreSQL) + [Render.com](https://render.com) (Backend & Frontend)

Auto-deployment is configured via GitHub Actions and Render webhooks. On push to `master`: tests run (backend + frontend), containers rebuild, and apps are published to GitHub Releases only after all tests pass.

> 📖 **Details:** [Deployment Architecture](TECHNICAL.md#deployment-architecture) in TECHNICAL.md

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

> 📖 **Details:** [Frontend Implementation](TECHNICAL.md#frontend-implementation) in TECHNICAL.md


## 🧪 Testing

### Run Tests

```bash
# Backend (Python)
cd backend
source venv/bin/activate
pytest tests/ -v

# Backend with coverage
pytest tests/ --cov --cov-report=html
open htmlcov/index.html

# Frontend (Flutter)
cd frontend/bli
flutter test

# Frontend with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage

| Component | Tests | Coverage |
|-----------|-------|----------|
| **Backend** | 11 | ~93% |
| **Frontend** | 70 | ~52% |

Coverage reports are automatically uploaded to [Codecov](https://codecov.io/gh/Milad9A/Bremen-Livability-Index) on every push.

## � Data Sources & Resources

### Primary Data Sources

| Source | Description | License |
|--------|-------------|---------|
| [OpenStreetMap](https://www.openstreetmap.org) | Trees, parks, amenities, transport, healthcare, cycling, pedestrian infrastructure, education, sports, cultural venues | [ODbL 1.0](https://opendatacommons.org/licenses/odbl/) |
| [Unfallatlas](https://unfallatlas.statistikportal.de) | German traffic accident data (2019-2023) | [dl-de/by-2-0](https://www.govdata.de/dl-de/by-2-0) |

### Useful Tools

| Tool | URL | Purpose |
|------|-----|---------|
| Overpass Turbo | [overpass-turbo.eu](https://overpass-turbo.eu) | Test OSM queries interactively |
| TagInfo | [taginfo.openstreetmap.org](https://taginfo.openstreetmap.org) | Explore OSM tag usage statistics |
| Geoportal Bremen | [geoportal.bremen.de](https://www.geoportal.bremen.de) | Official Bremen geodata |

> 📖 **Full Details:** [External Resources & References](TECHNICAL.md#external-resources--references) in TECHNICAL.md

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| Database connection failed | `docker ps` to check container status |
| Port 8000 in use | `lsof -i :8000` then `kill -9 <PID>` |
| Overpass API timeout | Retry - the API has rate limits |
| Flutter build errors | Run `flutter clean && flutter pub get` |

## 📄 License

University project for educational purposes.  
OpenStreetMap data: [ODbL 1.0](https://opendatacommons.org/licenses/odbl/) | Unfallatlas data: [dl-de/by-2-0](https://www.govdata.de/dl-de/by-2-0)

## 🙏 Acknowledgments

- [OpenStreetMap](https://www.openstreetmap.org) contributors
- [German Accident Atlas](https://unfallatlas.statistikportal.de) (Statistisches Bundesamt)
- [Overpass API](https://overpass-api.de) maintainers
