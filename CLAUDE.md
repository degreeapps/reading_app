# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

"El Lectómetro" (`reading_app`): Flutter app (Dart SDK ^3.7) for kids/teens to track reading, write reading reports ("fichas") and share with friends. Backend is Firebase Auth + Cloud Firestore; book catalog comes from the Google Books API. README and UI strings are in Spanish. The repo is **public** (portfolio for recruiters): never commit secrets, personal data or noisy artifacts.

- Android applicationId / Firebase package: `com.degreeapps.lectometro`. The Dart package name is still `reading_app` (renaming it is optional and low priority).
- The owner is a senior developer (Java backend, ex-CTO, Flutter). Explain decisions briefly and propose a plan before large changes.

## Commands

```bash
flutter pub get
flutter run --dart-define-from-file=env.json     # env.json is gitignored; copy env.example.json and set GOOGLE_BOOKS_API_KEY
flutter analyze                                  # flutter_lints; build/, android/, ios/, web/ are excluded
flutter test                                     # all tests
flutter test test/widget_test.dart               # single file (add --plain-name "<name>" for a single test)
dart run build_runner build --delete-conflicting-outputs   # regenerate freezed / json_serializable / injectable code
firebase deploy --only firestore:rules           # deploy firestore.rules
```

Setup prerequisites not in the repo: `lib/firebase_options.dart` (gitignored; produced by `flutterfire configure`) and `google-services.json`. `main.dart` imports `firebase_options.dart`, so the app won't compile without it. The Google Books key is read via `String.fromEnvironment('GOOGLE_BOOKS_API_KEY')` in `google_books_api.dart`, so it only exists if you pass `--dart-define-from-file=env.json` (also needed for builds).

Generated files (`*.g.dart`, `*.freezed.dart`, `injection.config.dart`) are **committed**; regenerate and commit them after changing models, Bloc events/states, or `@injectable` classes.

`test/widget_test.dart` is the untouched Flutter counter template and fails against the real app (needs Firebase init); there are no real tests yet. Replace it with real tests rather than leaving it failing.

## Architecture

Feature-first Clean Architecture under `lib/features/{auth,books,home,profile}`, each split into `domain` (entities, repository interfaces, one use case per action), `data` (repository implementations, datasources) and `presentation` (Bloc, pages, widgets). `home` is presentation-only. `profile` covers both the user profile and the friends system. `lib/core` holds theme, animations, shared widgets and DI.

- **State**: `flutter_bloc` with three app-wide blocs (`AuthBloc`, `BookBloc`, `ProfileBloc`) provided at the root in `main.dart` via `MultiBlocProvider`, resolved from `getIt`. Events/states use `freezed` unions (consumed with `state.when(...)`).
- **DI**: `get_it` + `injectable`. Annotated classes are registered through the generated `lib/core/config/injection.config.dart`. Third-party instances (FirebaseAuth, Firestore, GoogleSignIn, GoogleBooksApi) are provided by `FirebaseModule` in `lib/core/config/injection.dart`. `configureDependencies()` initializes `GoogleSignIn.instance` (with the web `serverClientId`) before `getIt.init()`.
- **Navigation**: plain `MaterialApp` named `routes` in `main.dart`; `AuthWrapper` switches between `LoginPage` and `HomePage` from `AuthBloc` state. Routes needing arguments (e.g. `/book-ficha-form` takes a `Book` via `settings.arguments`) read them in the route builder.
- **Entities**: `json_serializable` entities live in each feature's `domain/entities`; they are mapped to/from Firestore documents in the `data` repositories.
- `ProfileRepositoryMemoryImpl` is an in-memory stand-in with its `@Injectable` annotation commented out; the Firestore `profile_repository_impl.dart` is the active one.
- **Firestore collections**: `book_fichas`, `books`, `friend_requests`, `user_profiles`. Security rules live in `firestore.rules` and are versioned.
- Keep the layering: `domain` must not import Flutter or Firebase.

## Workflow

GitFlow: `main` holds tagged releases only, daily work on `develop`, changes on `feature/*` branches. Version lives in `pubspec.yaml` and is displayed in-app via `AppVersionLabel` (`package_info_plus`).

- **Never** commit or push to `main`. Start every task from `develop` on a `feature/<short-name>` branch.
- **Do not run `git commit` or `git push` unless explicitly asked.** The owner reviews the diff and commits.
- Commit messages (when asked): Conventional Commits, in English.
- Versioning: `pubspec.yaml` uses `MAJOR.MINOR.PATCH+BUILD` (currently `0.1.x`; `1.0.0` is reserved for the first production release). Release tags are `vMAJOR.MINOR.PATCH` with no build number (e.g. `v0.1.0`). The existing tag `v.0.1.0+1` is a naming mistake and must be replaced by `v0.1.0`.
- Before finishing any task run `flutter analyze` and `flutter test` and report the result.

## Security

- **Never read, print, edit or commit**: `env.json`, `.env*`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, `lib/firebase_options.dart`, `key.properties`, `*.jks`, `*.keystore`, `local.properties`. These are listed in `.gitignore` and `.cursorignore` and denied in `.claude/settings.json`.
- Never hardcode API keys. The Google Books key is injected only via `--dart-define-from-file=env.json`.
- If a key or secret appears in code, logs or history, stop and tell the owner instead of working around it.
- Do not add new dependencies without saying why.

## UI conventions

- All user-facing strings in Spanish.
- The app must be usable on small screens (≈360×640 dp) and with large system font. Avoid fixed widths/heights for content; use `Expanded`/`Flexible`, scrollable containers (`SingleChildScrollView`, `ListView`) and `maxLines` + `TextOverflow` on text in constrained rows. Respect the system `textScaler`.
- Test new or changed screens at 360×640 with `textScaler` 1.3–2.0; no `RenderFlex overflowed` errors are acceptable.
- Reuse the theme in `lib/core` (Material 3, light/dark, Poppins) instead of ad-hoc styles.

## Testing

Use `bloc_test`/`mocktail`-style unit tests for use cases and Blocs, and widget tests for key flows. Mock Firebase and the Google Books API; tests must not touch real services. Prefer small tests next to the code they cover (`test/` mirrors `lib/`).

## Known issues and backlog

Fix these only when asked, one per branch:

- Layout overflows on small screens / large fonts (reported on a Mi A1): `login_page`, `register_page`, `friends_list_page`, `friend_requests_page`, `book_detail_page`, `books_tabs_page`.
- `MaterialApp` title is still `'Reading App'`; should be `'El Lectómetro'`.
- No real tests and no CI (goal: GitHub Actions running `flutter analyze` + `flutter test` on PRs).
- Android release builds are signed with the debug config; set up proper release signing before publishing.
- Firebase: dev/stg apps exist in the console without flavors in the code; either implement flavors or remove those apps. Old `reading_app` Firebase apps should be cleaned up.
- Security: restrict the Firebase and Google Books API keys (Android package `com.degreeapps.lectometro` + SHA-1) and consider Firebase App Check; harden `firestore.rules`.
- README: add screenshots under `docs/screenshots/` and uncomment the block.
