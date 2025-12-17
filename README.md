# Flutter Firebase Phone Number Verification

A complete Flutter application demonstrating phone number verification using Firebase Authentication. This project utilizes the **BLoC (Business Logic Component)** pattern for state management and clean architecture principles.

## 📱 Demo

<div align="center">
  <img src="screenshots%20/screen_record.gif" width="300" />
</div>

## 📸 Screenshots

|                         Onboarding                         |                        Phone Entry                         |                        Verification                        |
| :--------------------------------------------------------: | :--------------------------------------------------------: | :--------------------------------------------------------: |
| <img src="screenshots%20/screen_shot_1.png" width="300" /> | <img src="screenshots%20/screen_shot_2.png" width="300" /> | <img src="screenshots%20/screen_shot_3.png" width="300" /> |

## ✨ Features

- **Phone Number Authentication:** Secure login using Firebase Phone Auth.
- **Onboarding Flow:** Smooth onboarding experience for new users.
- **State Management:** Built with `flutter_bloc` for predictable state management.
- **Clean Architecture:** Organized code structure separating presentation, domain, and data layers.
- **Auto-verification:** Supports automatic SMS code retrieval on Android.

## 🛠 Project Structure

The project follows a feature-based structure ensuring scalability and maintainability.

```
lib/
├── core/                   # Core functionality and services
│   └── services/           # External services (e.g., PhoneNumberService)
├── features/               # Feature-based modules
│   └── onboarding/         # Onboarding and Authentication feature
│       ├── application/    # BLoC / Cubits (State Management)
│       └── presentation/   # UI Screens and Widgets
├── app.dart                # Main App Widget & Global Providers
└── main.dart               # Entry point
```

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- A [Firebase Project](https://console.firebase.google.com/) configured.

### Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd flutter_firebase_pnv
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**

   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files to the respective `android/app` and `ios/Runner` directories.
   - Alternatively, use [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) to configure the project.

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
