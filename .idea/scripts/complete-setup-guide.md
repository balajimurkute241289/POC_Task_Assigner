# 🚀 Complete Flutter Mobile Setup Guide

## 📱 What We're Setting Up
- **Flutter SDK** for mobile app development
- **Android Studio** for Android development
- **Xcode** (if on Mac) for iOS development
- **VS Code** (optional) for code editing
- **Mobile emulators** for testing

## 🛠️ Step-by-Step Setup

### 1. **Download Flutter SDK**

**For Windows:**
1. Go to: https://docs.flutter.dev/get-started/install/windows
2. Download the Flutter SDK zip file
3. Extract to `C:\flutter` (recommended path)
4. Add `C:\flutter\bin` to your PATH environment variable

**For macOS:**
1. Go to: https://docs.flutter.dev/get-started/install/macos
2. Download the Flutter SDK zip file
3. Extract to your home directory: `~/flutter`
4. Add to PATH: `export PATH="$PATH:~/flutter/bin"`

**For Linux:**
1. Go to: https://docs.flutter.dev/get-started/install/linux
2. Download the Flutter SDK tar file
3. Extract to your home directory: `~/flutter`
4. Add to PATH: `export PATH="$PATH:~/flutter/bin"`

### 2. **Install Android Studio**

1. **Download Android Studio:**
   - Go to: https://developer.android.com/studio
   - Download the latest version for your OS

2. **Install Android Studio:**
   - Run the installer
   - Follow the setup wizard
   - Install Android SDK (required for Flutter)

3. **Configure Android SDK:**
   - Open Android Studio
   - Go to Tools → SDK Manager
   - Install Android SDK Platform-Tools
   - Install at least one Android SDK version (API 21 or higher)

4. **Set ANDROID_HOME environment variable:**
   - Windows: `C:\Users\<username>\AppData\Local\Android\Sdk`
   - macOS/Linux: `~/Library/Android/sdk` or `~/Android/Sdk`

### 3. **Install VS Code (Optional but Recommended)**

1. **Download VS Code:**
   - Go to: https://code.visualstudio.com/
   - Download for your OS

2. **Install Flutter Extension:**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Flutter"
   - Install the Flutter extension by Dart Code

### 4. **Verify Installation**

Run these commands in your terminal:

```bash
# Check Flutter installation
flutter --version

# Check Flutter doctor (this will tell you what's missing)
flutter doctor

# Check available devices
flutter devices
```

### 5. **Set Up Mobile Emulators**

**Android Emulator:**
1. Open Android Studio
2. Go to Tools → AVD Manager
3. Click "Create Virtual Device"
4. Select a device (e.g., Pixel 4)
5. Select a system image (e.g., API 30)
6. Click "Finish"

**iOS Simulator (macOS only):**
1. Install Xcode from App Store
2. Open Xcode
3. Go to Xcode → Preferences → Components
4. Download iOS Simulator
5. Open Simulator app

### 6. **Run the Demo App**

Once everything is set up:

```bash
# Navigate to your project
cd frontend

# Get dependencies
flutter pub get

# Run on Android emulator
flutter run

# Run on iOS simulator (macOS only)
flutter run -d ios

# Run on web browser
flutter run -d chrome

# Run on connected device
flutter run -d <device-id>
```

## 🔧 Troubleshooting

### Common Issues:

1. **"flutter command not found"**
   - Make sure Flutter is in your PATH
   - Restart your terminal/command prompt

2. **"Android SDK not found"**
   - Set ANDROID_HOME environment variable
   - Install Android SDK through Android Studio

3. **"No devices found"**
   - Start an emulator first
   - Connect a physical device with USB debugging enabled

4. **"Xcode not found" (macOS)**
   - Install Xcode from App Store
   - Accept Xcode license: `sudo xcodebuild -license accept`

### Flutter Doctor Output:

Run `flutter doctor` and fix any issues it reports:

```bash
flutter doctor -v
```

This will show you exactly what's missing and how to fix it.

## 📱 Testing on Physical Devices

### Android Device:
1. Enable Developer Options (tap Build Number 7 times)
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

### iOS Device (macOS only):
1. Open project in Xcode
2. Sign in with Apple Developer account
3. Select your device
4. Run: `flutter run`

## 🎯 Next Steps After Setup

1. **Run the demo app:**
   ```bash
   cd frontend
   flutter run
   ```

2. **Explore the features:**
   - GPS-based task completion
   - Role-based access control
   - Interactive task management
   - Map view with locations
   - Admin dashboard

3. **Customize the app:**
   - Modify mock data in `lib/services/mock_data_service.dart`
   - Change GPS coordinates
   - Add new tasks or users

## 📞 Support

If you encounter issues:
1. Check Flutter documentation: https://flutter.dev/docs
2. Run `flutter doctor` to identify problems
3. Check Flutter GitHub issues: https://github.com/flutter/flutter/issues

---

**🎉 Once setup is complete, you'll have a fully functional mobile task assignment app running on your device!**
