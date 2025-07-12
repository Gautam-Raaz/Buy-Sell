# Buy & Sell App (OLX Clone)

A fully functional Buy and Sell marketplace app built using **Flutter** and **Firebase**, inspired by OLX. Users can post products, browse listings, filter by categories, chat via WhatsApp, and more.

## 📦 Download

[Download APK (v1.0.0)](https://github.com/Gautam-Raaz/Buy-Sell/releases/download/untagged-046629ac62aecd445860/app-release.apk)


---

## 🚀 Features

- 📸 Post products with image upload
- 🗃️ Product categories and filters
- 🧾 Product details screen
- 💬 Contact seller via WhatsApp
- 🔍 Search and sort products
- 🌐 Firebase Firestore as backend
- ☁️ Firebase Storage for image uploads
- 📱 Responsive UI (Mobile supported)
- 🧭 Navigation with `BottomNavigationBar` or `TabBar`

---

## 🧪 Screenshots

> Add screenshots here using:
> 
> ![Home Screen](screenshots/home.png)
> ![Product Detail](screenshots/detail.png)

---

## 🛠️ Tech Stack

- **Flutter** (UI toolkit)
- **Firebase Firestore (NoSQL DB)**
- **Firebase Storage**
- **Image Picker / File Picker**

---

## 🧾 Setup Instructions

### 🔧 Prerequisites

- Flutter SDK
- Firebase project set up (Android + iOS + Web)
- Firebase CLI (for deployment)
- WhatsApp number(s) for demo

### ⚙️ Firebase Setup

1. Create a project on [Firebase Console](https://console.firebase.google.com/)
2. Enable:
   - Firestore Database
   - Firebase Storage
3. Download `google-services.json` for Android
4. Download `GoogleService-Info.plist` for iOS

### 🧪 Run Locally

```
git clone https://github.com/your-username/your-repo.git
cd your-repo
flutter pub get
flutter run
```

---

## 📤 Deployment

### ✅ Android

1. Build the release APK:

```
flutter build apk --release
```

2. The APK will be located at:

```
build/app/outputs/flutter-apk/app-release.apk
```

3. Upload this APK to the Play Store using the Google Play Console.

---

### 🍏 iOS

1. Open the project in Xcode:

```
open ios/Runner.xcworkspace
```

2. Set the Bundle Identifier, configure signing, and add `GoogleService-Info.plist`.

3. Build → Archive → Upload using Xcode’s Organizer to App Store Connect.

---

## 💬 WhatsApp Integration

To allow users to contact sellers via WhatsApp using a URL:

```dart
final String message = "Hello! I'm interested in your product.";
final String url =
    "https://wa.me/91${phone.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}";

if (await canLaunchUrl(Uri.parse(url))) {
  await launchUrl(Uri.parse(url));
}
```

---

## 👨‍💻 Author

- **Name**: Gautam  
- **GitHub**: [https://github.com/Gautam-Raaz](https://github.com/Gautam-Raaz)  
- **Email**: gautamrajgr799@gmail.com

---

## 📄 License

This project is licensed under the Gautam License.

---

## ⭐️ Show Your Support

If you found this project helpful, please consider giving it a ⭐ on GitHub!
