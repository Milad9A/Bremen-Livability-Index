# BLI - Bremen Livability Index (Frontend)

The mobile and web application for the Bremen Livability Index, built with **Flutter**.

## Features

- 🗺️ **Interactive Map**: View Bremen using OpenStreetMap.
- 👆 **Tap to Analyze**: Tap any location to get a real-time livability score.
- 📊 **Detailed Breakdown**: See scores for all 7 factors (Greenery, Shops, Safety, etc.).
- 🚦 **Visual Indicators**: Color-coded markers (Green/Orange/Red) based on the score.
- 🌐 **Web Support**: Fully functional as a web application.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- iOS Simulator (Mac), Android Emulator, or Chrome (for web).

### Installation

1. Resolve dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   # Or for web
   flutter run -d chrome
   ```

## Configuration

The API URL is configured in `lib/services/api_service.dart`.
By default, it points to the **Production Backend** on Render:
`https://bremen-livability-index.onrender.com`

To use a local backend:
1. Open `lib/services/api_service.dart`.
2. Uncomment the localhost line and comment out the Render URL.

## Deployment (Web)

The frontend is configured to deploy as a **Static Site** on Render.

| File | Purpose |
|------|---------|
| `render_build.sh` | Installs Flutter and builds the web app on Render |
| `render.yaml` | Service configuration for the Static Site |

**Deploy Manual Steps:**
1. Create a **New Static Site** on Render.
2. Link your repository.
3. Settings:
   - **Root Directory**: `frontend/bli`
   - **Build Command**: `./render_build.sh`
   - **Publish Directory**: `build/web`
   - **Rewrites**: Source `/*` -> Destination `/index.html`

## Assets & Icons

The app icon is generated from `assets/app_icon.png` using `flutter_launcher_icons`.

**To update the icon:**
1. Replace `assets/app_icon.png`.
2. Run generation command:
   ```bash
   dart run flutter_launcher_icons
   ```

## Dependencies

- `flutter_map`: For map rendering.
- `latlong2`: Geospatial coordinates.
- `http`: API requests.
- `provider`: State management.
- `flutter_launcher_icons`: Icon generation.
