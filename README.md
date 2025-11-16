# SyncNSweat Mobile

Flutter companion application for the SyncNSweat FastAPI backend. It mirrors the backend feature-set: authentication, onboarding, workout scheduling, Spotify playlist recommendations, and workout history.

## Requirements
- Flutter 3.22+
- Dart 3.3+
- Backend: `SyncNSweat-BE` running locally (default `http://localhost:8000/api/v1`).

## Getting Started
```bash
cd "c:/Dev/Projects won't earn any penny/SyncNSweat/SyncNSweat-Mobile"
flutter create .            # generates platform folders if missing
flutter pub get
flutter run -d chrome       # or ios/android/windows
```

If the project folder already contains the platform directories (android/ios/web/etc.), skip the `flutter create .` step.

## Environment Configuration
Override the API base URL via Dart defines when running the app:
```bash
flutter run --dart-define=API_BASE_URL=https://your-host/api/v1
```

## Project Layout
```
lib/
  core/        # app config, http client, storage helpers
  data/        # DTOs + repositories hitting FastAPI endpoints
  features/    # UI + controllers organized per domain
  router/      # GoRouter configuration
  app.dart     # root widget, theme, routers
  main.dart    # entrypoint and bootstrap
```

## Tests
```bash
flutter test
```

## Backend Endpoint Coverage
Refer to `ARCHITECTURE_PLAN.md` for the mapping between Flutter modules and FastAPI endpoints.
