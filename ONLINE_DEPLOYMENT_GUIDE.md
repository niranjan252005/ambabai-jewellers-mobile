# 🚀 AMBABAI JEWELLERS - ONLINE DEPLOYMENT GUIDE

## 📧 UPDATED NOTIFICATION SYSTEM
✅ **Dual Email Notifications:** Approval requests now go to BOTH:
- `barwadeniranjan@gmail.com`
- `ambabaijewellers@gmail.com`

---

## 🌐 DEPLOYMENT OPTIONS

### Option 1: Railway (Recommended - Easy & Free)

#### Step 1: Deploy to Railway
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Deploy from backend folder
cd backend
railway init
railway up
```

#### Step 2: Get Your URL
After deployment, Railway will give you a URL like:
`https://ambabai-jewellers-production.railway.app`

---

### Option 2: Render (Alternative - Also Free)

#### Step 1: Create Render Account
1. Go to https://render.com
2. Sign up with GitHub
3. Connect your repository

#### Step 2: Deploy
1. Click "New Web Service"
2. Connect your GitHub repo
3. Use these settings:
   - **Build Command:** `cd backend && npm install`
   - **Start Command:** `cd backend && npm start`
   - **Environment:** Node

---

### Option 3: Heroku (Classic Option)

#### Step 1: Install Heroku CLI
```bash
# Install Heroku CLI
npm install -g heroku

# Login to Heroku
heroku login

# Create app
cd backend
heroku create ambabai-jewellers

# Deploy
git init
git add .
git commit -m "Deploy Ambabai Jewellers"
git push heroku main
```

---

## 📱 UPDATE MOBILE APP

### Step 1: Update Server URL
Run the Python script:
```bash
python update-mobile-server.py
```

Or manually edit `mobile/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://your-deployed-url.railway.app/api';
```

### Step 2: Rebuild Mobile App
```bash
cd mobile
flutter packages pub get
flutter build apk --release
```

---

## 🧪 TESTING YOUR DEPLOYMENT

### Test Server Health
Visit: `https://your-deployed-url.railway.app/api/health`

Should return:
```json
{
  "status": "OK",
  "server": "Ambabai Jewellers API",
  "adminEmails": ["barwadeniranjan@gmail.com", "ambabaijewellers@gmail.com"]
}
```

### Test Admin Panel
Visit: `https://your-deployed-url.railway.app`
- Login: `admin@ambabaijewellers.com`
- Password: `admin123`

### Test Notifications
Visit: `https://your-deployed-url.railway.app/api/test-notification`

---

## 📧 EMAIL CONFIGURATION (Optional)

To enable actual email sending, update `backend/server.js`:

```javascript
const emailTransporter = nodemailer.createTransporter({
  service: 'gmail',
  auth: {
    user: 'your-gmail@gmail.com',
    pass: 'your-app-password'  // Gmail App Password
  }
});
```

### Gmail App Password Setup:
1. Enable 2FA on Gmail
2. Go to Google Account Settings
3. Security → App Passwords
4. Generate password for "Mail"
5. Use this password in server.js

---

## 🎯 QUICK DEPLOYMENT (EASIEST)

### Using Railway (Recommended):

1. **Install Railway CLI:**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login and Deploy:**
   ```bash
   railway login
   cd backend
   railway init
   railway up
   ```

3. **Copy Your URL** (e.g., `https://ambabai-jewellers-production.railway.app`)

4. **Update Mobile App:**
   ```bash
   python update-mobile-server.py
   # Enter your Railway URL when prompted
   ```

5. **Build Mobile App:**
   ```bash
   cd mobile
   flutter build apk --release
   ```

6. **Test Everything:**
   - Visit your Railway URL
   - Test admin login
   - Test mobile app
   - Register a test user to verify dual email notifications

---

## ✅ DEPLOYMENT CHECKLIST

- [ ] Backend deployed to cloud service
- [ ] Server URL obtained (e.g., Railway/Render/Heroku)
- [ ] Mobile app updated with new server URL
- [ ] Mobile app rebuilt (APK generated)
- [ ] Admin panel tested online
- [ ] Dual email notifications working
- [ ] Test user registration completed
- [ ] Mobile app tested with online server

---

## 🎊 AFTER DEPLOYMENT

### Your customers will be able to:
- ✅ Download and install your mobile app
- ✅ Register from anywhere in the world
- ✅ Browse jewelry catalog online
- ✅ Place orders 24/7
- ✅ Share jewelry items with photos

### You will receive:
- ✅ Email notifications at both addresses when customers register
- ✅ Email notifications for new orders
- ✅ Access to admin panel from anywhere
- ✅ Real-time order and user management

### Your app will be:
- ✅ Available 24/7 online
- ✅ Accessible from anywhere
- ✅ Professional and reliable
- ✅ Fully branded for Ambabai Jewellers

---

## 🆘 NEED HELP?

If you encounter any issues:

1. **Check server health:** Visit `your-url/api/health`
2. **Check logs:** Use Railway/Render dashboard
3. **Test locally first:** Ensure everything works on localhost
4. **Verify mobile app URL:** Check `api_service.dart` has correct URL

**Your Ambabai Jewellers app is ready to go online! 🚀**