
<div align="center">
  <img src="frontend/bli/assets/app_icon_rounded.png" alt="Bremen Livability Index Icon" width="120">

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

| Platform   | File                  | Instructions                |
| ---------- | --------------------- | --------------------------- |
| **iOS**    | `Runner.app` / Source | Run via Xcode / Flutter     |
| **Android**| `BLI-Android.apk`     | Install APK on device.      |
| **Windows**| `BLI-Windows.zip`     | Extract and run `bli.exe`.  |
| **macOS**  | `BLI-macOS.zip`       | Extract and run `bli.app`.  |
| **Linux**  | `BLI-Linux.tar.gz`    | Extract and run `./bundle/bli`. |

> ⚠️ **Note:** Desktop builds are unsigned. You may need to verify them in your system security settings:
>
> - **Windows**: Click "More Info" → "Run anyway" in Windows Defender SmartScreen
> - **macOS**: Right-click the app → "Open" → "Open" (bypasses Gatekeeper)
> - **Linux**: Run `chmod +x bli` before running
> All platforms use the same backend API and provide the same core functionality.
>
> 💡 **Desktop apps do not require login.** Firebase Authentication has limited support for desktop platforms (macOS sandboxing blocks keychain access, Windows/Linux lack OAuth support), so desktop users enter directly as guests. Sign-in is available on web and mobile.

## ✨ Features

- 🗺️ **Premium Map Experience** – Full-screen map with "Liquid Glass" UI, real-time background refraction, and tactile haptic feedback.
- 📍 **Instant Analysis** – Tap any location to calculate a detailed livability score based on 20+ spatial factors.
- ⚙️ **Personalized Scoring** – Customize factor importance to tailor scores to your lifestyle.
- � **Smart Search & Favorites** – "Apple-style" expandable search bar and cross-device sync.
- 🔐 **Secure & Reliable** – Multi-provider authentication on web/mobile (Google, GitHub, Email); desktop apps run without login. >90% test coverage.


## 📊 Scoring System

Livability is calculated from **20 spatial factors** using proximity-based analysis. Score range: **0-100**.

**Factors:**
- **Positive (9):** Greenery, Amenities, Public Transport, Healthcare, Bike Infra, Education, Sports, Pedestrian, Culture
- **Negative (11):** Accidents, Industry, Major Roads, Noise, Railways, Gas Stations, Waste, Power, Parking, Airports, Construction

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

**Interactive Docs:** [/docs](https://bremen-livability-backend.onrender.com/docs) (Swagger UI)

> 📖 **Full Endpoint Reference:** See [API Endpoints](TECHNICAL.md#api-endpoints) in TECHNICAL.md for request/response examples and authentication details.

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

## 🧪 Testing

### Run Tests

```bash
# Backend
cd backend && pytest

# Frontend
cd frontend/bli && flutter test
```

> 📖 **Full Testing Guide:** See [Testing](TECHNICAL.md#testing)  in TECHNICAL.md for coverage reports and test details.

## 🗃️ Data Sources & Resources

| Source                                              | Description                                                                 | License                                                      |
| --------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------ |
| [OpenStreetMap](https://www.openstreetmap.org)      | Trees, parks, amenities, transport, healthcare, cycling, pedestrian infrastructure, education, sports, cultural venues | [ODbL 1.0](https://opendatacommons.org/licenses/odbl/)       |
| [Unfallatlas](https://unfallatlas.statistikportal.de) | German traffic accident data (2019-2023)                                   | [dl-de/by-2-0](https://www.govdata.de/dl-de/by-2-0)          |

> 📖 **Full Details:** [External Resources & References](TECHNICAL.md#external-resources--references) in TECHNICAL.md

## 📄 License

This project is licensed under the [MIT License](LICENSE).
