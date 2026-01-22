<div align="center">
  <img src="frontend/bli/assets/app_icon_rounded.png" alt="Bremen Livability Index Icon" width="128" height="128">

  # Bremen Livability Index (BLI)
</div>

[![Backend Tests](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/backend-tests.yml/badge.svg)](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/backend-tests.yml)
[![Frontend Tests](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/frontend-tests.yml/badge.svg)](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/frontend-tests.yml)
[![Build and Release Apps](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/build-release.yml/badge.svg)](https://github.com/Milad9A/Bremen-Livability-Index/actions/workflows/build-release.yml)
[![codecov](https://codecov.io/gh/Milad9A/Bremen-Livability-Index/graph/badge.svg)](https://codecov.io/gh/Milad9A/Bremen-Livability-Index)

A comprehensive geospatial platform featuring a **Flutter mobile & web application** and a **Python FastAPI backend**. It calculates Quality of Life scores for any location in Bremen, Germany, in real-time.

> 📖 **For in-depth technical details, see [TECHNICAL.md](TECHNICAL.md)** – covering system architecture, database design, scoring algorithm, and deployment.

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

> ⚠️ **Note:** Desktop builds are unsigned. You may need to verify them in your system security settings:
>
> - **Windows**: Click "More Info" → "Run anyway" in Windows Defender SmartScreen
> - **macOS**: Right-click the app → "Open" → "Open" (bypasses Gatekeeper)
> - **Linux**: Run `chmod +x bli` before running

> All platforms use the same backend API and provide the same core functionality.

## ✨ Features

- 🗺️ **Interactive Map** – Full-screen map (CartoDB) with "Liquid Glass" UI
- 🚀 **Splash & Start Screen** – Animated launch experience
- 📍 **Tap-to-Analyze** – Instant livability scoring for any location
- 🔍 **Address Search** – Find streets, landmarks, or neighborhoods
- 🔐 **Firebase Authentication** – Multi-provider login (Google, GitHub, Email, Phone, Guest)
- ❤️ **Save Favorites** – Store and manage favorite locations with backend sync

## 📊 Scoring System

Livability is calculated from **20 spatial factors** using proximity-based analysis. Score range: **0-100**.

**Positive Factors (9):** Greenery (trees & parks), Amenities, Public Transport, Healthcare, Bike Infrastructure, Education, Sports & Leisure, Pedestrian Infrastructure, Cultural Venues

**Negative Factors (11):** Traffic Accidents, Industrial Areas, Major Roads, Noise Sources, Railways, Gas Stations, Waste Facilities, Power Infrastructure, Large Parking Lots, Airports/Helipads, Construction Sites

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

### 3. Initialize Database Schema
```bash
python -m scripts.initialize_db
```

### 4. Ingest Data
```bash
python -m scripts.ingest_all_data
```

### 5. Start Server
```bash
./start_server.sh
```

API: `http://localhost:8000` | Docs: `http://localhost:8000/docs`

### 6. Run Flutter App
```bash
cd frontend/bli
flutter pub get
flutter run
```

## 📡 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | API info and available endpoints |
| `/health` | GET | Health check (API & database status) |
| `/analyze` | POST | Analyze location livability score |
| `/geocode` | POST | Search and geocode addresses |
| `/users` | POST | Create or update user (Firebase UID) |
| `/users/{user_id}/favorites` | GET | Get all user's favorite locations |
| `/users/{user_id}/favorites` | POST | Add new favorite location |
| `/users/{user_id}/favorites/{favorite_id}` | DELETE | Delete a favorite location |

**Interactive Docs:** [/docs](https://bremen-livability-backend.onrender.com/docs) (Swagger UI)

## 🏗️ Architecture

**Backend**: FastAPI + PostgreSQL/PostGIS | **Frontend**: Flutter (cross-platform) | **Data**: OpenStreetMap + Unfallatlas

> 📖 **Details:** [System Architecture](TECHNICAL.md#system-architecture), [Database Design](TECHNICAL.md#database-design), [Backend Implementation](TECHNICAL.md#backend-implementation) in TECHNICAL.md

## ☁️ Deployment

**Cloud Stack (Free Forever)**:
- [Neon.tech](https://neon.tech) (PostgreSQL + PostGIS)
- [Render.com](https://render.com) (Backend & Frontend)
- [Firebase Hosting](https://firebase.google.com/docs/hosting) (Email magic link redirects)

**CI/CD Pipeline:**
- **Backend changes** → Backend Tests run on GitHub Actions → Render deploys on commit
- **Frontend changes** → Frontend Tests run → Build workflow creates app releases → Render deploys on commit

Render deploys automatically on every push to `master`. GitHub Actions runs tests in parallel to catch issues early.

> 📖 **Details:** [Deployment Architecture](TECHNICAL.md#deployment-architecture) in TECHNICAL.md

## 💻 Flutter Development

### Running the App

```bash
cd frontend/bli
flutter pub get
flutter run              # Default device
flutter run -d chrome    # Web
flutter run -d emulator-5554  # Android emulator
flutter run -d "iPhone"  # iOS Device (requires Xcode)
```

### Firebase Setup

The app uses Firebase for authentication and favorites sync:

1. **Web**: Uses Firebase OAuth popup authentication (`signInWithPopup`) for Google/GitHub
2. **Mobile**: Uses native authentication packages with deep link handling
3. **Email Magic Links**: Firebase Hosting redirects email links to the web/mobile app
4. **Cross-Device Email Flow**: When a user clicks an email link on a different device/browser, the app prompts them to re-enter their email to complete authentication
5. **Android Release Signing**: Production builds are signed via GitHub Actions using repository secrets

**Authentication Providers**: Google, GitHub, Email (Magic Link), Phone, Anonymous (Guest)

**Email Deep Links Setup**:
- Firebase Hosting serves a redirect page at `bremen-livability-index.firebaseapp.com/login`
- Android: App Links configured in `AndroidManifest.xml` with SHA256 verification
- iOS: Falls back to web app (Universal Links require paid Apple Developer account)
- Cross-device: `DeepLinkService` detects missing email and shows `EmailLinkPromptScreen`

> See `firestore.rules` for database security rules

### API Configuration

The API URL is configured in `lib/core/services/api_service.dart`.

**Default**: Production Backend (`https://bremen-livability-backend.onrender.com`)

**To use local backend:**
1. Open `lib/core/services/api_service.dart`
2. Uncomment the localhost line and comment out the Render URL

> 📖 **Details:** [Frontend Implementation](TECHNICAL.md#frontend-implementation) in TECHNICAL.md

### Code Generation

If you modify data models (`lib/features/map/models/*.dart`), you must run the build runner to regenerate JSON serialization code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```


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

Coverage reports are automatically uploaded to [Codecov](https://codecov.io/gh/Milad9A/Bremen-Livability-Index) on every push.

## 🗃️ Data Sources & Resources

| Source | Description | License |
|--------|-------------|---------|
| [OpenStreetMap](https://www.openstreetmap.org) | Trees, parks, amenities, transport, healthcare, cycling, pedestrian infrastructure, education, sports, cultural venues | [ODbL 1.0](https://opendatacommons.org/licenses/odbl/) |
| [Unfallatlas](https://unfallatlas.statistikportal.de) | German traffic accident data (2019-2023) | [dl-de/by-2-0](https://www.govdata.de/dl-de/by-2-0) |

> 📖 **Full Details:** [External Resources & References](TECHNICAL.md#external-resources--references) in TECHNICAL.md

## 📄 License

This project is licensed under the [MIT License](LICENSE).
