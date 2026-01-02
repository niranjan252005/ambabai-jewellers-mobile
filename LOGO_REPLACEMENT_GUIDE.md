# 🏪 Ambabai Jewellers Logo Replacement Guide

## 📁 **FILES TO REPLACE WITH YOUR SHOP LOGO:**

### **1. App Icon (Main Phone Icon)**
**Location:** `mobile/assets/icon/app_icon.png`
**Size:** 1024x1024 pixels
**Format:** PNG with transparent background
**Usage:** App icon on phone home screen, app drawer, recent apps

### **2. In-App Logo (Used Throughout App)**
**Location:** `mobile/assets/images/logo.png`  
**Size:** 512x512 pixels
**Format:** PNG with transparent background
**Usage:** Splash screen, headers, navigation, admin panel

## 🎨 **LOGO DESIGN REQUIREMENTS:**

### **Technical Specs:**
- **Format:** PNG with transparent background
- **Quality:** High resolution (300 DPI recommended)
- **Style:** Clean, professional jewelry shop logo
- **Colors:** Should complement gold theme (#D4AF37)

### **Design Guidelines:**
- Include "Ambabai Jewellers" text if desired
- Simple, recognizable design that works at small sizes
- Avoid too much detail (will be hard to see when small)
- Consider how it looks on both light and dark backgrounds

## 🔄 **HOW TO REPLACE LOGOS:**

### **Method 1: Direct File Replacement**
1. **Prepare your logos** in the required sizes
2. **Replace files directly:**
   ```
   Your 1024x1024 logo → mobile/assets/icon/app_icon.png
   Your 512x512 logo → mobile/assets/images/logo.png
   ```
3. **Refresh Flutter assets:**
   ```bash
   cd mobile
   flutter pub get
   ```

### **Method 2: Using Placeholder Generator (Optional)**
1. **Run the placeholder generator:**
   ```bash
   cd mobile
   python create_placeholder_logos.py
   ```
2. **Replace the generated placeholders** with your actual logos
3. **Refresh assets** as above

## 📱 **WHERE YOUR LOGO APPEARS:**

### **App Icon Locations:**
- ✅ **Phone home screen** - Main app icon
- ✅ **App drawer** - In list of all apps  
- ✅ **Recent apps** - When switching between apps
- ✅ **App store** - When published (Google Play, etc.)

### **In-App Logo Locations:**
- ✅ **Splash screen** - First thing users see
- ✅ **Login screen** - Above login form
- ✅ **Register screen** - Above registration form
- ✅ **Dashboard** - In header/navigation
- ✅ **Admin panel** - Throughout admin interface
- ✅ **Share messages** - When sharing jewelry items
- ✅ **Error screens** - Fallback displays
- ✅ **Loading states** - While data loads

## 🛠️ **LOGO WIDGET SYSTEM:**

The app uses a flexible logo system with multiple widgets:

### **CustomLogo Widget:**
- **Default:** Uses your image logo (`assets/images/logo.png`)
- **Fallback:** Custom drawn diamond if image fails
- **Usage:** `CustomLogo(size: 50)`

### **ShopLogo Widget:**
- **Purpose:** Specifically for your shop logo image
- **Fallback:** Text-based "AJ" logo if image fails
- **Usage:** `ShopLogo(size: 100)`

### **TextLogo Widget:**
- **Purpose:** Text-based "SAJ" logo
- **Usage:** `TextLogo(fontSize: 24)`

### **BrandName Widget:**
- **Purpose:** "Ambabai Jewellers" text
- **Usage:** `BrandName(fontSize: 20)`

## 🎯 **TESTING YOUR LOGO:**

### **After Replacing Files:**
1. **Run the app:**
   ```bash
   cd mobile
   flutter run
   ```

2. **Check these screens:**
   - Splash screen (startup)
   - Login/register screens
   - Dashboard header
   - Admin panel
   - Share functionality

3. **Verify app icon:**
   - Install APK on device
   - Check home screen icon
   - Check app drawer icon

## 🚀 **BUILDING WITH YOUR LOGO:**

### **Debug Build (Testing):**
```bash
cd mobile
flutter build apk --debug
```

### **Release Build (Production):**
```bash
cd mobile
flutter build apk --release
```

### **Install on Device:**
```bash
flutter install
```

## 📋 **LOGO CHECKLIST:**

- [ ] **App icon created** (1024x1024 PNG)
- [ ] **Logo image created** (512x512 PNG)
- [ ] **Files replaced** in correct locations
- [ ] **Assets refreshed** (`flutter pub get`)
- [ ] **App tested** - logo appears correctly
- [ ] **APK built** with custom logo
- [ ] **Device tested** - app icon shows correctly

## 🎨 **LOGO CREATION TIPS:**

### **Tools You Can Use:**
- **Canva** - Easy online logo maker
- **GIMP** - Free image editor
- **Photoshop** - Professional image editor
- **Figma** - Online design tool

### **Design Ideas:**
- Shop name with jewelry elements
- Traditional Indian jewelry motifs
- Gold/silver color schemes
- Clean, modern typography
- Circular or square layouts

## 🔧 **TROUBLESHOOTING:**

### **Logo Not Showing:**
1. Check file paths are correct
2. Ensure PNG format with transparency
3. Run `flutter pub get` to refresh assets
4. Restart the app completely

### **Logo Looks Blurry:**
1. Increase image resolution
2. Use vector graphics if possible
3. Ensure proper sizing (1024x1024, 512x512)

### **App Icon Not Updating:**
1. Uninstall old app completely
2. Rebuild and reinstall APK
3. Clear device cache if needed

## 🎉 **FINAL RESULT:**

Once you replace the logo files, your **Ambabai Jewellers** branding will appear throughout the entire app:

- **Professional app icon** on phone
- **Consistent branding** throughout app
- **Custom shop identity** in all screens
- **Ready for app store** publication

**Your jewelry business will have a complete, professional mobile app with your own branding!** 🏪✨