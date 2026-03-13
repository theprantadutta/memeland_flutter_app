# Memeland Flutter App

A Flutter mobile application for generating, discovering, and sharing memes. Features AI-powered meme generation, Google Sign-In, and a vibrant Material 3 design with light/dark theme support.

## Screenshots

_Coming soon_

## Tech Stack

| Category | Package |
|----------|---------|
| State Management | flutter_riverpod 3.x |
| Navigation | go_router 17.x |
| HTTP Client | dio 5.x |
| Auth | firebase_auth, google_sign_in |
| Push Notifications | firebase_messaging |
| Token Storage | flutter_secure_storage |
| Preferences | shared_preferences |
| UI | google_fonts, flutter_animate, cached_network_image |
| Sharing | share_plus |
| Environment | flutter_dotenv |

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.11+
- Android Studio or Xcode (for emulators)
- The [Memeland API](../memeland-dotnet-api) running locally
- Firebase project configured (already set up — project ID: `memeland-7125c`)

## Getting Started

### 1. Clone and navigate

```bash
cd memeland_flutter_app
```

### 2. Create the environment file

Create a `.env` file in the project root:

```env
API_BASE_URL_DEV=http://10.0.2.2:8010/api
API_BASE_URL_PROD=http://localhost:8010/api
```

| Variable | Description | Notes |
|----------|-------------|-------|
| `API_BASE_URL_DEV` | Backend URL for debug builds | `10.0.2.2` is Android emulator's alias for host `localhost` |
| `API_BASE_URL_PROD` | Backend URL for release builds | Set to your deployed API URL |

> **Platform-specific dev URLs:**
> - Android Emulator: `http://10.0.2.2:8010/api`
> - iOS Simulator: `http://localhost:8010/api`
> - Physical device: `http://<your-local-ip>:8010/api`
> - Chrome (Web): `http://localhost:8010/api`

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
# Make sure the Memeland API is running first (port 8010)

flutter run
```

### 5. Run on specific platform

```bash
flutter run -d chrome        # Web
flutter run -d emulator-5554 # Android emulator
flutter run -d iPhone        # iOS simulator
flutter run -d windows       # Windows desktop
```

## Firebase Setup

Firebase is pre-configured for this project. The following files are already in place:

- `lib/firebase_options.dart` — Platform-specific Firebase config
- `android/app/google-services.json` — Android Firebase config
- Android Gradle plugins configured

**If you need to reconfigure Firebase** for a different project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## App Screens

| Route | Screen | Description |
|-------|--------|-------------|
| `/` | Splash | Loading screen with initialization |
| `/auth` | Auth | Login / Register / Google Sign-In |
| `/home` | Home | Daily meme, topic chips, trending feed |
| `/meme-generator` | Meme Generator | Pick a topic, generate, save, share |
| `/saved-memes` | Saved Memes | Your saved meme collection |
| `/profile` | Profile | Avatar, theme switcher, logout |

## Authentication Flow

```
App Launch → Check stored JWT
  ├── Valid token → Refresh user info → /home
  ├── Expired token → Attempt refresh → /home or /auth
  └── No token → /auth

Auth Screen:
  ├── Email/Password → POST /api/auth/register or /login
  └── Google Sign-In → Firebase Auth → POST /api/auth/google
      → Store JWT + Refresh Token in FlutterSecureStorage
      → Navigate to /home
```

## Theme

The app uses Material 3 with a meme-friendly vibrant palette:

| Color | Hex | Usage |
|-------|-----|-------|
| Gold | `#FFD700` | Primary brand color |
| Deep Purple | `#6C3FAF` | Secondary / accents |
| Electric Blue | `#00B4D8` | Tertiary / highlights |

- **Light and dark modes** with full Material 3 color scheme generation
- **Typography:** Outfit (headings) + Plus Jakarta Sans (body) via Google Fonts
- **Theme persistence** via SharedPreferences — survives app restarts
- Switchable from the Profile screen (Light / System / Dark)

## Architecture

```
lib/
├── constants/              # SharedPreference keys
├── models/                 # Data models (User, Meme, Topic)
├── providers/              # Riverpod state management
│   ├── app_providers.dart        # Theme + Auth notifiers
│   ├── meme_providers.dart       # Meme data (FutureProviders)
│   └── navigation_providers.dart # Auth-based navigation state
├── router/                 # GoRouter with auth redirects
│   ├── app_router.dart
│   ├── app_navigation_state.dart
│   └── route_names.dart
├── screens/                # Full-page screens
│   ├── auth/
│   ├── home/
│   ├── meme_generator/
│   ├── saved_memes/
│   └── profile/
├── services/               # Business logic & API layer
│   ├── api_service.dart          # Dio client, JWT interceptor, token refresh
│   ├── backend_auth_service.dart # Auth state management
│   ├── google_sign_in_service.dart
│   ├── meme_service.dart
│   ├── sharing_service.dart
│   ├── notification_service.dart
│   └── error_handling_service.dart
├── theme/                  # Material 3 theme system
│   ├── app_colors.dart     # Brand palette
│   ├── app_theme.dart      # Light/dark ThemeData
│   ├── app_typography.dart # Google Fonts text theme
│   ├── app_spacing.dart    # Spacing/radius/sizing tokens
│   └── theme_extensions.dart
├── utils/                  # Validators, date formatting
├── widgets/                # Reusable components
│   ├── meme_card.dart
│   ├── topic_chip.dart
│   ├── loading_widget.dart
│   ├── app_error_widget.dart
│   └── auth_loading_screen.dart
└── main.dart               # Entry point (Firebase, ProviderScope, dotenv)
```

## Key Features

- **Email/Password + Google Sign-In** authentication
- **JWT token management** with automatic refresh on 401 responses
- **Meme generation** by topic (Programming, Work, Relationships, Gym, College, Gaming)
- **Save memes** to your personal collection
- **Share memes** via native OS share sheet (images + captions)
- **Daily meme** and **trending feed** on the home screen
- **Pull-to-refresh** on home screen
- **Light/Dark/System** theme with persistence
- **Animated auth screen** with flutter_animate
- **Cached network images** for fast meme loading
- **Auth-guarded navigation** — unauthenticated users redirected to login

## Troubleshooting

**"Connection refused" on Android emulator:**
Make sure `API_BASE_URL_DEV` uses `10.0.2.2` instead of `localhost`. The Android emulator runs in its own network namespace.

**Firebase initialization fails:**
Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in the correct locations. Run `flutterfire configure` to regenerate if needed.

**Google Sign-In fails on Android:**
Add your debug SHA-1 key to the Firebase Console:
```bash
cd android && ./gradlew signingReport
```
Copy the SHA-1 from the `debug` variant and add it to Firebase Console → Project Settings → Android app.
