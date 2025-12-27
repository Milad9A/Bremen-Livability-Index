# Bremen Livability Index - Frontend

The mobile application for the Bremen Livability Index, built with **Flutter**.

## Features

- 🗺️ **Interactive Map**: View Bremen using OpenStreetMap.
- 👆 **Tap to Analyze**: Tap any location to get a real-time livability score.
- 📊 **Detailed Breakdown**: See scores for all 7 factors (Greenery, Shops, Safety, etc.).
- 🚦 **Visual Indicators**: Color-coded markers (Green/Orange/Red) based on the score.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- iOS Simulator (Mac) or Android Emulator.

### Installation

1. Resolve dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Configuration

The API URL is configured in `lib/services/api_service.dart`.
By default, it points to the **Production Backend** on Render:
`https://bremen-livability-index.onrender.com`

To use a local backend:
1. Open `lib/services/api_service.dart`.
2. Uncomment the localhost line and comment out the Render URL.

## Dependencies

- `flutter_map`: For map rendering.
- `latlong2`: Geospatial coordinates.
- `http`: API requests.
- `provider`: State management.
