
# Real-Time Safety & Trust Companion — MVP1 (Flutter)

This repo is a **ready-to-build Flutter app** implementing MVP1:
- Start Trip → Live Tracking (map, ETA, deviation, SOS) → Arrived
- IGI Airport → Connaught Place (Delhi) simulated route
- **Deviation detection** if off-route > 500 m (toggle to simulate)
- **GitHub Actions** builds a **release APK** and publishes it as an artifact

## Get a downloadable APK (no Android Studio needed)
1. Create a new GitHub repo and upload all files from this folder.
2. In GitHub → **Actions** → enable workflows.
3. Wait for **Build Android APK** to complete.
4. Download `app-release.apk` from the run’s **Artifacts**.

> The workflow runs `flutter create . --platforms=android` to generate missing Android scaffolding before building.

## Local build (optional)
```bash
flutter create . --platforms=android
flutter pub get
flutter test
flutter build apk --release
# APK: build/app/outputs/flutter-apk/app-release.apk
```

## App overview
- `lib/screens/start_trip.dart` — Destination entry, Start/Share
- `lib/screens/active_trip.dart` — Live map, ETA, deviation banner (>500 m), SOS
- `lib/screens/arrived.dart` — Arrived screen
- `lib/services/location_service.dart` — Simulated GPS along route
- `test/geo_test.dart` — Unit tests

Config:
- Deviation threshold: `DEVIATION_KM = 0.5`
- Simulated speed: `28 km/h`
