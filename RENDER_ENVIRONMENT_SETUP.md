# 🔧 Render Environment Variables Setup

## 🎯 **CRITICAL STEP: Configure Firebase Credentials**

Your Firebase backend is deployed but needs environment variables to work. Here's exactly what to do:

### **STEP 1: Go to Render Dashboard**
1. Open: https://dashboard.render.com/
2. Find your service: **`ambabai-jewellers`**
3. Click on the service name
4. Go to **"Environment"** tab

### **STEP 2: Add Environment Variables**

Click **"Add Environment Variable"** and add these **6 variables**:

#### **Variable 1:**
- **Key:** `FIREBASE_PROJECT_ID`
- **Value:** `ambabai-jewellers`

#### **Variable 2:**
- **Key:** `FIREBASE_PRIVATE_KEY_ID`
- **Value:** `[Copy from your firebase-service-account.json file]`

#### **Variable 3:**
- **Key:** `FIREBASE_PRIVATE_KEY`
- **Value:** `[Copy the entire private_key from json file - including quotes and \n]`

#### **Variable 4:**
- **Key:** `FIREBASE_CLIENT_EMAIL`
- **Value:** `[Copy client_email from json file]`

#### **Variable 5:**
- **Key:** `FIREBASE_CLIENT_ID`
- **Value:** `[Copy client_id from json file]`

#### **Variable 6:**
- **Key:** `FIREBASE_CLIENT_CERT_URL`
- **Value:** `[Copy client_x509_cert_url from json file]`

### **STEP 3: How to Find Values in JSON File**

Open your `backend/firebase-service-account.json` file and copy these values:

```json
{
  "type": "service_account",
  "project_id": "ambabai-jewellers", ← Copy this
  "private_key_id": "abc123def456...", ← Copy this
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIB...\n-----END PRIVATE KEY-----\n", ← Copy this (entire thing)
  "client_email": "firebase-adminsdk-xyz@ambabai-jewellers.iam.gserviceaccount.com", ← Copy this
  "client_id": "123456789012345678901", ← Copy this
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xyz%40ambabai-jewellers.iam.gserviceaccount.com" ← Copy this
}
```

### **STEP 4: Save and Deploy**

1. Click **"Save Changes"** in Render
2. Render will **automatically redeploy** with new environment variables
3. Wait **2-3 minutes** for deployment to complete

### **STEP 5: Test the System**

1. **Check server status:** https://ambabai-jewellers.onrender.com/api/health
2. **Try user registration** on mobile app
3. **Verify in Firebase Console:** https://console.firebase.google.com/project/ambabai-jewellers/firestore

## 🔍 **VERIFICATION CHECKLIST:**

- [ ] All 6 environment variables added to Render
- [ ] Render deployment completed successfully
- [ ] Health endpoint returns Firebase status
- [ ] Mobile app can register users
- [ ] Data appears in Firebase Console

## 🚨 **TROUBLESHOOTING:**

**If deployment fails:**
- Check that all 6 environment variables are set
- Verify private_key includes the full key with \n characters
- Ensure no extra spaces in variable values

**If mobile app can't connect:**
- Wait for server to wake up (30 seconds first request)
- Check server logs in Render dashboard
- Verify Firebase project is active

## 🎉 **SUCCESS INDICATORS:**

When working correctly:
- ✅ **Health endpoint** shows "Firebase Firestore"
- ✅ **User registration** works on mobile app
- ✅ **Data persists** in Firebase Console
- ✅ **No more SQLite data loss**

**Your jewelry business now has enterprise-grade database infrastructure!** 🔥