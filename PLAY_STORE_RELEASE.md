# QueueFlow Kumba - Play Store Release Checklist

## 1) Configure signing key

1. Create upload keystore (`.jks`) for release.
2. Copy `android/key.properties.example` to `android/key.properties`.
3. Fill in real keystore values.

## 2) Set API endpoint

Run with your backend URL:

```bash
flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com

# Optional for Google Maps screen:
# add to android/gradle.properties -> MAPS_API_KEY=YOUR_GOOGLE_MAPS_ANDROID_KEY
```

## 2.1) Get and set MAPS_API_KEY (Google Maps)

1. Open Google Cloud Console and create/select a project.
2. Enable **Maps SDK for Android** and **Places API** (optional but recommended).
3. Go to **APIs & Services > Credentials > Create credentials > API key**.
4. Restrict the key:
	- Application restriction: **Android apps**
	- Add package: `com.thequeue.queueflow`
	- Add SHA-1 fingerprint from your keystore/debug key
5. In `android/gradle.properties`, add:

```properties
MAPS_API_KEY=PASTE_YOUR_ANDROID_MAPS_KEY_HERE
```

6. Rebuild and run:

```bash
flutter clean
flutter pub get
flutter run -d <your-device-id>
```

For release builds:

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=https://api.yourdomain.com
```

## 3) Verify production behavior

- Sign in/sign up (email and phone)
- Session restore on app relaunch
- Dark/light mode persistence
- Queue actions and endpoint directives

## 4) Build Play Store artifact

```bash
flutter clean
flutter pub get
flutter build appbundle --release --dart-define=API_BASE_URL=https://api.yourdomain.com
```

Shareable testing APK:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.yourdomain.com
```

Output file:

- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/flutter-apk/app-release.apk`

## 5) Upload to Google Play Console

- Create app listing assets (icon, screenshots, privacy policy)
- Upload `app-release.aab`
- Roll out internal testing first
