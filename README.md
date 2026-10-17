# reading_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

### API keys and local env

1. Copy the example env file and fill in your Google Books API key:

```bash
cp env.example.json env.json
```

2. Set `GOOGLE_BOOKS_API_KEY` inside `env.json`.

3. Run or build with dart defines loaded from that file:

```bash
flutter run --dart-define-from-file=env.json
```

```bash
flutter build apk --dart-define-from-file=env.json
```

`env.json`, Firebase config files (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`) and `.env` are gitignored. Keep them local only.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
