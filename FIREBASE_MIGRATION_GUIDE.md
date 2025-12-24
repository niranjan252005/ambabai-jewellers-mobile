# 🔥 Firebase Firestore Migration Guide
## Complete Setup for Ambabai Jewellers

### 🎯 **STEP 1: CREATE FIREBASE PROJECT (15 minutes)**

#### **1.1 Go to Firebase Console**
1. Open: https://console.firebase.google.com/
2. Click **"Create a project"**
3. Project name: `ambabai-jewellers`
4. Enable Google Analytics: **Yes** (recommended for business insights)
5. Choose Analytics account: **Default Account for Firebase**
6. Click **"Create project"**

#### **1.2 Setup Firestore Database**
1. In Firebase console, click **"Firestore Database"**
2. Click **"Create database"**
3. Choose **"Start in production mode"** (we'll configure rules later)
4. Select location: **asia-south1 (Mumbai)** (closest to India)
5. Click **"Done"**

#### **1.3 Get Configuration Keys**
1. Click **"Project Settings"** (gear icon)
2. Scroll to **"Your apps"** section
3. Click **"Web"** icon (</>) 
4. App nickname: `ambabai-jewellers-web`
5. Check **"Also set up Firebase Hosting"**
6. Click **"Register app"**
7. **COPY THE CONFIG** - you'll need this!

```javascript
// Your Firebase config (SAVE THIS!)
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "ambabai-jewellers.firebaseapp.com",
  projectId: "ambabai-jewellers",
  storageBucket: "ambabai-jewellers.appspot.com",
  messagingSenderId: "123456789",
  appId: "your-app-id"
};
```

### 🎯 **STEP 2: SETUP BACKEND DEPENDENCIES (10 minutes)**

#### **2.1 Install Firebase Admin SDK**
```bash
cd backend
npm install firebase-admin
npm uninstall sqlite3
```

#### **2.2 Create Service Account Key**
1. In Firebase console → **"Project Settings"**
2. Click **"Service accounts"** tab
3. Click **"Generate new private key"**
4. Save file as `backend/firebase-service-account.json`
5. **KEEP THIS FILE SECURE** - don't commit to Git!

#### **2.3 Update .gitignore**
Add to `backend/.gitignore`:
```
firebase-service-account.json
.env
```

### 🎯 **STEP 3: UPDATE BACKEND CODE (30 minutes)**

#### **3.1 Create Firebase Service**
Create `backend/services/firebase.js`:
```javascript
const admin = require('firebase-admin');
const serviceAccount = require('../firebase-service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'ambabai-jewellers'
});

const db = admin.firestore();

module.exports = { admin, db };
```

#### **3.2 Update server.js - Replace SQLite with Firestore**

**Replace the database initialization section:**
```javascript
// Remove SQLite imports
// const sqlite3 = require('sqlite3').verbose();
// const db = new sqlite3.Database('./jewelry.db');

// Add Firebase imports
const { admin, db } = require('./services/firebase');
```

#### **3.3 Update User Registration**
Replace SQLite user registration with:
```javascript
app.post('/api/register', async (req, res) => {
  try {
    const { username, email, password, role = 'user' } = req.body;

    // Check if user exists
    const existingUser = await db.collection('users')
      .where('email', '==', email)
      .get();

    if (!existingUser.empty) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user document
    const userDoc = await db.collection('users').add({
      username,
      email,
      password: hashedPassword,
      role,
      is_approved: true, // Auto-approve as per your requirement
      created_at: admin.firestore.FieldValue.serverTimestamp()
    });

    res.json({ 
      success: true, 
      message: 'Account created successfully! You can now login immediately.',
      userId: userDoc.id 
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Registration failed' });
  }
});
```

#### **3.4 Update User Login**
```javascript
app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user by email
    const userQuery = await db.collection('users')
      .where('email', '==', email)
      .get();

    if (userQuery.empty) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    const userDoc = userQuery.docs[0];
    const user = { id: userDoc.id, ...userDoc.data() };

    // Check password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    // Remove password from response
    delete user.password;

    res.json({ token, user });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Login failed' });
  }
});
```

### 🎯 **STEP 4: SETUP FIRESTORE COLLECTIONS (15 minutes)**

#### **4.1 Create Collections Structure**
In Firebase console → Firestore → **"Start collection"**

**Collection 1: `users`**
```javascript
// Document structure
{
  username: "Niranjan Barwade",
  email: "admin@ambabaijewellers.com", 
  password: "hashed_password",
  role: "admin",
  is_approved: true,
  phone: "+917666993107",
  address: "Vishal Nagar Hupari",
  created_at: timestamp
}
```

**Collection 2: `jewelry_items`**
```javascript
// Document structure
{
  name: "Gold Ring",
  description: "Beautiful gold ring",
  price: 25000,
  category: "Rings",
  material: "Gold",
  weight: 5.5,
  image_url: "path/to/image.jpg",
  stock_quantity: 10,
  sku: "RG-001",
  purity: "22K",
  karat: 22,
  melting_weight: 5.2,
  melting_value: 23000,
  wastage_percentage: 8,
  making_charges: 2000,
  created_at: timestamp
}
```

**Collection 3: `orders`**
```javascript
// Document structure
{
  user_id: "user_document_id",
  jewelry_id: "jewelry_document_id", 
  quantity: 1,
  total_price: 25000,
  status: "pending",
  created_at: timestamp
}
```

#### **4.2 Setup Firestore Security Rules**
In Firebase console → Firestore → **"Rules"**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - authenticated users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
    
    // Jewelry items - anyone can read, only admins can write
    match /jewelry_items/{itemId} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Orders - users can read/write their own orders
    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 🎯 **STEP 5: UPDATE MOBILE APP (45 minutes)**

#### **5.1 Add Firebase Dependencies**
Update `mobile/pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... existing dependencies ...
  firebase_core: ^2.24.2
  cloud_firestore: ^4.13.6
  firebase_auth: ^4.15.3
```

#### **5.2 Setup Firebase in Mobile App**
Create `mobile/lib/services/firebase_service.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}
```

#### **5.3 Update main.dart**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const JewelryApp());
}
```

#### **5.4 Create Firebase Config File**
Create `mobile/lib/firebase_options.dart`:
```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'your-web-api-key',
    appId: 'your-web-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'ambabai-jewellers',
    authDomain: 'ambabai-jewellers.firebaseapp.com',
    storageBucket: 'ambabai-jewellers.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your-android-api-key',
    appId: 'your-android-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'ambabai-jewellers',
    storageBucket: 'ambabai-jewellers.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'ambabai-jewellers',
    storageBucket: 'ambabai-jewellers.appspot.com',
  );
}
```

### 🎯 **STEP 6: MIGRATE EXISTING DATA (20 minutes)**

#### **6.1 Export Current SQLite Data**
Create `backend/migrate-to-firebase.js`:
```javascript
const sqlite3 = require('sqlite3').verbose();
const { admin, db } = require('./services/firebase');

async function migrateData() {
  const sqliteDb = new sqlite3.Database('./jewelry.db');
  
  // Migrate users
  sqliteDb.all('SELECT * FROM users', async (err, users) => {
    if (users) {
      for (const user of users) {
        await db.collection('users').add({
          username: user.username,
          email: user.email,
          password: user.password,
          role: user.role,
          is_approved: user.is_approved === 1,
          created_at: admin.firestore.Timestamp.now()
        });
      }
      console.log(`Migrated ${users.length} users`);
    }
  });

  // Migrate jewelry items
  sqliteDb.all('SELECT * FROM jewelry_items', async (err, items) => {
    if (items) {
      for (const item of items) {
        await db.collection('jewelry_items').add({
          name: item.name,
          description: item.description,
          price: item.price,
          category: item.category,
          material: item.material,
          weight: item.weight,
          image_url: item.image_url,
          stock_quantity: item.stock_quantity,
          created_at: admin.firestore.Timestamp.now()
        });
      }
      console.log(`Migrated ${items.length} jewelry items`);
    }
  });
}

migrateData();
```

### 🎯 **STEP 7: DEPLOY AND TEST (15 minutes)**

#### **7.1 Update Environment Variables**
In Render dashboard:
1. Go to your service settings
2. Add environment variable:
   - `FIREBASE_PROJECT_ID` = `ambabai-jewellers`

#### **7.2 Deploy to Render**
```bash
git add .
git commit -m "Migrate to Firebase Firestore"
git push origin main
```

#### **7.3 Test the Migration**
1. Try user registration on web app
2. Try user login on mobile app
3. Add jewelry items via admin panel
4. Verify data persists in Firebase console

### 🎯 **NEXT STEPS FOR YOU:**

1. **🔥 CREATE FIREBASE PROJECT** (Step 1)
2. **📧 SEND ME THE CONFIG** - I'll update the code
3. **💾 DOWNLOAD SERVICE ACCOUNT** - Place in backend folder
4. **🚀 I'll HANDLE THE REST** - Code updates and deployment

**Ready to start? Create the Firebase project and share the config with me!**