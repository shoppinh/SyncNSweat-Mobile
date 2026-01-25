---
filename: dart-n-flutter.instructions.md
description: Instructions for writing Dart and Flutter code following the official recommendations.
applyTo: '**/*.dart'
---

# Dart & Flutter Instructions

These instructions provide recommended practices for writing Dart and Flutter code following official guidance.

- Follow Dart's null-safety and sound typing features.
- Prefer `const` where possible to reduce rebuilds.
- Use clear folder structure and naming conventions consistent with Flutter's project layout.
- Use `async`/`await` for asynchronous code and avoid blocking the UI thread.
- Prefer composition over inheritance for widgets; keep widgets small and focused.
- Choose an appropriate state management approach (Provider, Riverpod, Bloc, or others) and be consistent.
- Write unit, widget, and integration tests where applicable.
- Reuse a single `Dio`/`http` client or service for network requests; handle errors and retries gracefully.
- Use lints and static analysis (`analysis_options.yaml`) to enforce style and catch issues early.
- Document public APIs and complex business logic with clear comments and examples.
