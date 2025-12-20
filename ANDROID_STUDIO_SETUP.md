# 📱 Android Studio Setup Guide

## 🎯 **Complete Android Studio Configuration**

Since you've downloaded Android Studio, let's complete the setup to build your mobile APK.

---

## 🔧 **Step 1: Install Android Studio**

### **If not already installed:**
1. **Run the Android Studio installer** you downloaded
2. **Choose "Standard" installation** (recommended)
3. **Let it download** Android SDK and other components
4. **Complete the setup wizard**

### **If already installed:**
- **Open Android Studio**
- **Skip to Step 2**

---

## 🛠️ **Step 2: Install Required SDK Components**

### **Open SDK Manager:**
1. **Open Android Studio**
2. **Go to**: Tools → SDK Manager
3. **Or click**: Configure → SDK Manager (from welcome screen)

### **Install Required Components:**

#### **SDK Platforms Tab:**
- ✅ **Android 14.0 (API 34)** - Latest stable
- ✅ **Android 13.0 (API 33)** - Widely supported
- ✅ **Android 12.0 (API 31)** - Good compatibility

#### **SDK Tools Tab:**
- ✅ **Android SDK Build-Tools** (latest)
- ✅ **Android SDK Command-line Tools** (latest) - **REQUIRED**
- ✅ **Android SDK Platform-Tools** (latest)
- ✅ **Android Emulator** (optional, for testing)
- ✅ **Intel x86 Emulator Accelerator (HAXM)** (optional)

### **Apply Changes:**
1. **Click "Apply"**
2. **Accept licenses**
3. **Wait for download** (may take 10-15 minutes)

---

## 🌍 **Step 3: Set Environment Variables**

### **Automatic Setup (Run our script):**
```bash
complete-android-setup.bat
```

### **Manual Setup:**
1. **Find Android SDK path** (usually: `C:\Users\YourName\AppData\Local\Android\Sdk`)
2. **Add environment variables:**
   - **ANDROID_HOME**: `C:\Users\YourName\AppData\Local\Android\Sdk`
   - **ANDROID_SDK_ROOT**: `C:\Users\YourName\AppData\Local\Android\Sdk`
3. **Add to PATH:**
   - `%ANDROID_HOME%\tools`
   - `%ANDROID_HOME%\tools\bin`
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\cmdline-tools\latest\bin`

---

## ✅ **Step 4: Accept Android Licenses**

### **Run License Acceptance:**
```bash
flutter doctor --android-licenses
```

**Accept all licenses** by typing `y` when prompted.

---

## 🔍 **Step 5: Verify Setup**

### **Check Flutter Doctor:**
```bash
flutter doctor
```

**Expected output:**
```
[√] Flutter (Channel stable, 3.38.5)
[√] Windows Version (11 Home Single Language 64-bit)
[√] Android toolchain - develop for Android devices (Android SDK version 36.1.0)
[√] Chrome - develop for the web
[√] Connected device (3 available)
[√] Network resources
```

---

## 🚀 **Step 6: Build Your Mobile App**

### **Once setup is complete:**
```bash
# Run our automated build script
build-now.bat

# Or manual commands:
cd mobile
flutter pub get
flutter build apk --release
```

---

## 📱 **Expected Build Output**

### **After successful build:**
```
mobile/build/app/outputs/flutter-apk/
├── app-debug.apk           # Debug version (larger file)
└── app-release.apk         # Release version (optimized)
```

### **File sizes (approximate):**
- **Debug APK**: ~50-80 MB
- **Release APK**: ~20-40 MB

---

## 📲 **Step 7: Install on Your Phone**

### **Transfer APK to phone:**
1. **USB Cable**: Copy APK to phone storage
2. **Email**: Send APK as attachment
3. **Cloud Storage**: Upload and download on phone
4. **ADB**: `adb install app-release.apk` (if ADB enabled)

### **Install on Android phone:**
1. **Enable "Unknown Sources"** in Settings → Security
2. **Tap the APK file** in file manager
3. **Tap "Install"**
4. **Open "Jewelry Store" app**

---

## 🔧 **Troubleshooting**

### **Common Issues & Solutions:**

#### **"Android SDK not found"**
- **Solution**: Install Android Studio with SDK
- **Check**: SDK Manager has required components

#### **"cmdline-tools component is missing"**
- **Solution**: Install "Android SDK Command-line Tools" in SDK Manager
- **Path**: Tools → SDK Manager → SDK Tools tab

#### **"Android license status unknown"**
- **Solution**: Run `flutter doctor --android-licenses`
- **Accept**: All licenses by typing `y`

#### **"Build failed with Gradle error"**
- **Solution**: Update Android Gradle Plugin
- **Check**: Internet connection for downloads

#### **"No connected devices"**
- **Solution**: Enable USB Debugging on phone
- **Or**: Use `flutter build apk` instead of `flutter run`

---

## 📊 **Setup Checklist**

### **Before Building:**
- [ ] Android Studio installed
- [ ] SDK components downloaded
- [ ] Command-line tools installed
- [ ] Environment variables set
- [ ] Licenses accepted
- [ ] Flutter doctor shows green checkmarks

### **Build Process:**
- [ ] Navigate to mobile folder
- [ ] Run `flutter pub get`
- [ ] Run `flutter build apk --release`
- [ ] Find APK in build/app/outputs/flutter-apk/
- [ ] Transfer to phone and install

---

## 🎯 **Quick Commands Summary**

### **Setup Commands:**
```bash
# Check Flutter status
flutter doctor

# Accept Android licenses
flutter doctor --android-licenses

# Run our setup script
complete-android-setup.bat
```

### **Build Commands:**
```bash
# Automated build
build-now.bat

# Manual build
cd mobile
flutter pub get
flutter build apk --release
```

---

## 📞 **Need Help?**

### **If you encounter issues:**

1. **Run Flutter Doctor**: `flutter doctor -v` (verbose output)
2. **Check Android Studio**: SDK Manager has all required components
3. **Verify Paths**: Environment variables are set correctly
4. **Restart Terminal**: After setting environment variables
5. **Check Internet**: Required for downloading dependencies

### **Common Solutions:**
- **Restart Android Studio** after installing components
- **Restart Terminal** after setting environment variables
- **Run as Administrator** if permission issues
- **Check Antivirus** - may block SDK downloads

---

## 🎉 **Success Indicators**

### **You'll know setup is complete when:**
- ✅ `flutter doctor` shows green checkmarks for Android
- ✅ `flutter build apk` completes without errors
- ✅ APK file is generated in build folder
- ✅ APK installs and runs on your phone

---

## 🚀 **Ready to Build!**

Once Android Studio is properly configured, your jewelry mobile app will build successfully and you'll have a professional APK ready to install on any Android device!

**Let's build your jewelry empire!** 💎📱✨