# 🎬 CineScope

![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=for-the-badge&logo=swift)
![iOS](https://img.shields.io/badge/iOS-17.0+-blue?style=for-the-badge&logo=apple)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green?style=for-the-badge)
![Framework](https://img.shields.io/badge/Framework-SwiftUI-red?style=for-the-badge)
![Database](https://img.shields.io/badge/Database-Firebase-yellow?style=for-the-badge&logo=firebase)

CineScope is a modern, fully localized iOS application designed for movie enthusiasts. It allows users to discover movies, explore actor biographies, and manage personalized lists. Built with **SwiftUI**, **Combine**, and **Firebase**, the project demonstrates scalable iOS development practices, robust state management, and real-time database synchronization.

## ✨ Key Features

* **Advanced Localization (Bilingual):** Fully supports English and Turkish. Implemented dynamic, on-the-fly UI and API data translation using `String Catalogs` and SwiftUI's `.environment(\.locale)` without requiring app restarts.
* **Native Theme Management:** Includes Dark, Light, and System theme toggling, persistently stored via `@AppStorage`.
* **Reactive Search Architecture:** Built with `Combine` using operators like `debounce` and `removeDuplicates` to optimize TMDB API network calls and ensure a smooth, infinite-loop-free typing experience.
* **Real-time Cloud Synchronization:** Seamless integration with `Cloud Firestore` to manage user-specific "Favorites" and "Watchlists" across multiple devices and sessions.
* **Dynamic API Fetching (Single Source of Truth):** To maintain data freshness and language flexibility, the database stores only Movie IDs. Complete, localized movie data is fetched dynamically from the TMDB API upon viewing the library.
* **Modern UI/UX:** Utilizes SwiftUI's latest components including `NavigationStack`, `LazyVGrid`, `MatchedGeometryEffect` for custom tab bars, and comprehensive empty state designs.
* **Secure Key Management:** Follows strict security practices by ignoring sensitive API keys from version control.

## 🏛 Tech Stack & Architecture

This project strictly follows the **MVVM (Model-View-ViewModel)** architectural pattern to ensure a clean separation of concerns, testability, and maintainability.

* **UI Framework:** SwiftUI
* **Reactive Programming:** Combine
* **Backend as a Service (BaaS):** Firebase Authentication & Cloud Firestore
* **Networking:** URLSession (Custom `NetworkManager` Singleton)
* **Image Caching:** Custom `ImageCache` implementation to optimize memory and minimize redundant network requests.

## 📱 Screenshots

> **💡 Architecture Highlight:** The app features seamless real-time localization and theme switching. Below, you can see the dynamic data localization fetched directly from the TMDB API, along with our robust UI handling both **English/Light** and **Turkish/Dark** configurations perfectly.

| Discovery (Home & Actors) | Movie Deep Dive (Details & Cast) | Features (Search & Library) |
| :---: | :---: | :---: |
| ![Home Dark TR](https://github.com/semihtakilan/CineScopeApp/blob/main/HomeDarkTr.png?raw=true) | ![Movie Detail Dark TR](https://github.com/semihtakilan/CineScopeApp/blob/main/MovieDetailDarkTr.png?raw=true) | ![Search Dark TR](https://github.com/semihtakilan/CineScopeApp/blob/main/SearchDarkTr.png?raw=true) |
| ![Person Detail Light EN](https://github.com/semihtakilan/CineScopeApp/blob/main/PersonLightEn.png?raw=true) | ![Movie Detail Light EN](https://github.com/semihtakilan/CineScopeApp/blob/main/MovieDetailLightEn.png?raw=true) | ![Library Light EN](https://github.com/semihtakilan/CineScopeApp/blob/main/LibraryLightEn.png?raw=true) |

## 🚀 Installation & Setup

To run this project locally, you must provide your own API key for TMDB and configure your Firebase environment.

### 1. Clone the repository:
```bash
git clone [https://github.com/semihtakilan/CineScopeApp.git](https://github.com/semihtakilan/CineScopeApp.git)
cd CineScopeApp
```

### 2. Setup TMDB API Key:
For security reasons, the API key is excluded from this repository. You must create a local configuration file.
* Navigate to `CineScopeApp/Services/` in Xcode.
* Create a new Swift file named `APIKeys.swift`.
* Add the following structure and insert your TMDB API v3 Key:
  ```swift
  import Foundation

  struct APIKeys {
      static let tmdbKey = "YOUR_API_KEY_HERE"
  }
  ```

### 3. Setup Firebase:
* Create a new project on the [Firebase Console](https://console.firebase.google.com/).
* Register a new iOS app with the project's Bundle ID.
* Download the `GoogleService-Info.plist` file.
* Drag and drop the file into your Xcode project (inside the `App` folder).
* Enable **Email/Password Authentication** and **Cloud Firestore** in your Firebase console.

### 4. Build and Run:
* Open the project in **Xcode 15+**.
* Wait for the Swift Package Manager to resolve Firebase dependencies.
* Select a simulator (iOS 17.0+) or physical device and press `Cmd + R`.

## 👨‍💻 Author

**Semih TAKILAN**
Computer Engineering Student & iOS Developer  
[LinkedIn Profile](https://www.linkedin.com/in/semihtakilan) | [GitHub Profile](https://github.com/semihtakilan)
