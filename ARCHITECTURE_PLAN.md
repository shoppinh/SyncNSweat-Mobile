# SyncNSweat Mobile Architecture Plan

## Goals
- Provide a Flutter client that consumes the FastAPI backend in `SyncNSweat-BE`.
- Mirror all critical backend capabilities: authentication, onboarding, workout scheduling, exercise management, and Spotify integrations.
- Establish a scalable, testable structure using modern Flutter patterns (Riverpod for state, GoRouter for navigation, Dio for networking).

## High-Level Layers
1. **core/** – Environment config, HTTP clients, error handling, secure storage, logging utilities.
2. **data/** – DTOs + repositories interacting with backend endpoints.
3. **features/** – Presentation (widgets/screens) and controllers for each user-facing capability.
4. **app.dart** – Root widget with dependency bootstrap, routing, theming.
5. **main.dart** – Entrypoint that wires up environment + providers.

## Backend Endpoint Coverage
| Backend Route | Mobile Responsibility |
| ------------- | --------------------- |
| `POST /api/v1/auth/register` | Sign-up screen collects email, password, name. |
| `POST /api/v1/auth/login` | Email/password login, stores JWT for future calls. |
| `GET /api/v1/auth/spotify/login` & `GET /api/v1/auth/spotify/callback` | WebView/deep-link flow to connect Spotify. |
| `GET/POST/PUT /api/v1/profiles/me` | Onboarding forms + profile settings. |
| `GET/POST/PUT /api/v1/profiles/me/preferences` | Equipment, goals, music preferences UI. |
| `GET /api/v1/workouts/today` | Home screen shows today's workout, exercises, playlist. |
| `POST /api/v1/workouts/schedule` | Trigger weekly schedule generation/regeneration. |
| `POST /api/v1/workouts/suggest-workout-schedule` | AI-powered instant suggestion action. |
| `GET /api/v1/workouts` & `GET /api/v1/workouts/{id}` | History view + detail page. |
| `POST/PUT/DELETE /api/v1/workouts/{workout_id}/exercises` | Exercise swapping/editing interactions. |
| `POST /api/v1/workouts/{workout_id}/exercises/{exercise_id}/swap` | "Swap exercise" action button. |
| `GET /api/v1/playlists/spotify/*` | Playlist recommendations, refresh, list display. |
| `GET /api/v1/exercises`, `/search` | Exercise explorer for manual selection. |

## Feature Modules
- `features/auth` – Login, registration, Spotify connect, token persistence.
- `features/onboarding` – Multi-step flow capturing profile + preferences.
- `features/home` – Dashboard with today's workout, quick actions (regenerate schedule, refresh playlist).
- `features/workout_detail` – Exercise list, swap, mark complete, rest timer.
- `features/playlist` – Playlist previews and refresh button.
- `features/history` – Past workouts calendar/list.
- `features/settings` – Manage account, logout, Spotify status.

Each feature includes:
- `controllers/` – Riverpod notifiers handling orchestration.
- `widgets/` – Reusable UI components.
- `views/` – Screens wired into GoRouter routes.

## Data & Networking
- `core/network/api_client.dart` – Configured Dio instance with interceptors for JWT auth and logging.
- `core/storage/secure_storage.dart` – Wrapper around `flutter_secure_storage` for tokens + refresh data.
- `data/repositories/*.dart` – One repository per backend domain, mapping JSON to strongly typed models in `data/models`.
- Error model mapping to FastAPI error responses sprinkled across repositories.

## State Management
- Riverpod 3 with `AsyncNotifier`s for data-fetching use cases (auth, workouts, playlists).
- Global `ProviderContainer` bootstrapped in `main.dart`; use `ProviderScope` for overrides/testing.

## Routing
- GoRouter with the following routes:
  - `/auth` (login/register toggle) – guards redirect to `/home` when authenticated
  - `/onboarding/profile`, `/onboarding/preferences`
  - `/home`
  - `/workouts/:id`
  - `/history`
  - `/settings`
  - `/spotify/connect` – hosted WebView for OAuth

## Offline & Caching (Phase 2 target)
- Cache last fetched workouts + exercises via `hive` boxes for offline reading.
- Persist onboarding progress steps locally.

## Testing Strategy
- `test/` directory with:
  - Repository tests mocking Dio responses.
  - Widget tests for login/onboarding flows (Golden optional later).

This document serves as the initial blueprint before scaffolding files.
