# F.I.T. – Finally I Train

![F.I.T. Splash Concept](https://img.shields.io/badge/Status-In%20Development-success?style=for-the-badge) ![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter) ![Firebase](https://img.shields.io/badge/Firebase-Offline%20First-FFCA28?style=for-the-badge&logo=firebase)

**"Your gym bro who is actually organized."**

F.I.T. is a premium, AMOLED-first, high-performance fitness operating system built in Flutter. Designed to eliminate the friction from workout logging, it features true-black OLED aesthetics, micro-plate progression mathematics, and rigorous offline-first architecture so it works flawlessly deep inside cellular dead-zones (a.k.a your gym).

---

## ⚡ Core Features

*   **Frictionless Keypad:** Custom-built oversized numpad with intelligent `+1.25kg` micro-plate quick-actions for rapid data entry without keyboard popping delays.
*   **Progressive Overload Engine:** Mathematically calculates linear progression automatically using 1.25kg steps, ensuring sustained, plateau-free lifting.
*   **AMOLED True-Black UI:** Battery-optimized interface (`#000000` base) paired with High Voltage Lime (`#CCFF00`) and Electric Cyan (`#00E5FF`).
*   **Offline-First Architecture:** Backed by Cloud Firestore with unrestricted local caching. Train in airplane mode; syncs seamlessly upon reconnection.
*   **"Finally I Train" Splash Experience:** A dynamic, humorous initialization sequence that mocks fitness cliches while gracefully pre-loading your split data.

## 🛠 Tech Stack

*   **Framework:** Flutter (Dart)
*   **State Management:** Riverpod (`flutter_riverpod`)
*   **Backend:** Firebase (Cloud Firestore)
*   **Typography:** Google Fonts (`Plus Jakarta Sans` w/ Tabular Figures)

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.16 or higher recommended)
* Android Studio / Xcode
* A Firebase Project (for cloud sync)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Systemiq-in/fit-finally-i-train.git
    cd fit-finally-i-train
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Firebase & Environment:**
    You must provide your own Firebase configuration files. These files are strictly ignored by Git to protect API keys.
    *   **Android:** Place your `google-services.json` in `android/app/`
    *   **iOS:** Place your `GoogleService-Info.plist` in `ios/Runner/`
    *   **Web/Global:** Generate `firebase_options.dart` using the `flutterfire cli` in the `lib/` directory.

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 🔐 Security Notice

This repository is configured to **strictly ignore** sensitive files:
*   `.env` and `.env.*`
*   `google-services.json`
*   `GoogleService-Info.plist`
*   `firebase_options.dart`

**Never** commit your Firebase configuration files or private API keys to version control.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
