# PayZee
This is the cross-platform mobile application for the PayZee project, built with the Flutter framework. It enables users to access an end to end digital transaction system built on the foundation of E-Rupee.
**Maintained By**: [Rishi Chirchi](https://github.com/rishichirchi)

-----

## 🛠️ Requirements

Ensure you have the following installed:

  * **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
  * **Dart SDK** (comes with Flutter)
  * **Git** (for version control)
  * **Android Studio** or **VS Code** (with Flutter and Dart plugins)
  * \[Optional] **Xcode** (for iOS development on macOS)

To verify your environment setup, run:

```bash
flutter doctor
```

-----

## 📦 Installation Steps

### 1\. Clone the Repository

```bash
git clone https://github.com/1MindLabs/PayZee.git
cd PayZee
```

### 2\. Get Dependencies

```bash
flutter pub get
```

-----

## 🔧 Configuration (if applicable)

### Firebase (Optional)

If using Firebase:

  * Place `google-services.json` in `android/app/`
  * Place `GoogleService-Info.plist` in `ios/Runner/`

### Environment Variables (Optional)

If your app uses environment variables:

  * Create a `.env` file in the root directory.

Example contents:

```env
API_KEY=your_api_key
BASE_URL=https://api.example.com
```

-----

## 📱 Running the App

### ➤ On a Real Device

#### Android

1.  Enable **Developer Options** on your Android phone.
2.  Enable **USB Debugging** under Developer Options.
3.  Connect the phone via USB.
4.  Verify the device is detected:
    ```bash
    flutter devices
    ```
5.  Run the app:
    ```bash
    flutter run
    ```
    You may have to authorize the PC when prompted on your phone.

#### iOS (macOS only)

1.  Connect your iPhone.
2.  Trust the computer from the iPhone.
3.  Open `ios/Runner.xcworkspace` in Xcode.
4.  Set your team ID under **Signing & Capabilities**.
5.  Run:
    ```bash
    flutter run
    ```

### ➤ On an Emulator

#### Android Emulator

1.  Open Android Studio \> **Device Manager**.
2.  Create a new virtual device with preferred specs.
3.  Start the emulator.
4.  Run:
    ```bash
    flutter run
    ```

#### iOS Simulator (macOS only)

1.  Open Simulator from Xcode (Xcode \> Open Developer Tool \> Simulator).
2.  Run:
    ```bash
    flutter run
    ```

-----

## 🧪 Running Tests

```bash
flutter test
```

-----

## 🧼 Cleaning the Project

```bash
flutter clean
flutter pub get
```

-----

## 📁 Project Structure

```css
lib/
├── main.dart
├── common/
├── core/
├── features/
├── l10n/
```

-----

## 📦 Build for Release

### Android (APK)

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

-----

## 🧩 Common Issues

### Android license not accepted

```bash
flutter doctor --android-licenses
```

### Xcode build fails

  * Ensure CocoaPods is installed: `sudo gem install cocoapods`
  * Open project in Xcode and resolve signing issues

### Device not detected

  * Ensure USB debugging is enabled
  * Use `flutter doctor -v` for detailed info

-----

## 🙌 Contributions

Contributions are welcome\! Please open an issue or submit a pull request.

-----

## 📄 License

This project is licensed under the MIT License.

-----