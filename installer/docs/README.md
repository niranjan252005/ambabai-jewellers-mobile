# Jewelry Mobile App

A Flutter mobile application for jewelry items with admin and user roles.

## Architecture
- **Frontend**: Flutter (Mobile)
- **Backend**: Node.js + Express
- **Database**: SQLite (Local)
- **Authentication**: JWT (Local)

## Features
- Beautiful jewelry item cards
- Admin panel for managing items
- User ordering system
- Role-based access control

## Project Structure
```
jewelry-app/
├── mobile/          # Flutter mobile app
├── backend/         # Node.js Express server
└── README.md
```

## Getting Started

### Backend Setup
```bash
cd backend
npm install
node install.js  # Initialize database with sample data
npm start        # Server runs on http://localhost:3000
```

### Mobile Setup
```bash
cd mobile
flutter pub get
flutter run
```

### Web Demo & Testing
- **Main Demo**: Open http://localhost:3000 in your browser
- **Photo Upload Test**: Open test_photo_upload.html in your browser
- **Login Credentials**: admin@jewelry.com / admin123

## User Roles
- **Admin**: Full access to manage jewelry items, users, and orders
  - Add, edit, and delete jewelry items
  - Approve user registrations
  - View and manage all orders
  - Limited to maximum 3 admin accounts
- **User**: View items and place orders (access granted by admin)

## Key Features

### 📱 Mobile App Features
- **Beautiful Jewelry Cards**: Elegant display with images, prices, and details
- **Photo Upload**: Camera/gallery integration for adding jewelry photos
- **Dashboard Navigation**: Gold/Silver collections with category filtering
- **Image Zoom**: Interactive image viewing with zoom functionality
- **Admin Panel**: Complete management interface for jewelry items
- **Order Management**: Place and track jewelry orders
- **User Authentication**: Secure login with role-based access

### 🌐 Web Demo Features
- **Interactive Dashboard**: Login and browse jewelry collections
- **Photo Upload Interface**: Drag-drop and browse photo selection
- **Real-time Preview**: Image preview before uploading
- **Form Validation**: File type and size validation
- **Admin Tools**: Add, edit, and delete jewelry items
- **Responsive Design**: Works on desktop and mobile browsers

### 💎 Jewelry Data Features
- **Comprehensive Details**: Name, description, price, category, material
- **Melting Data**: Purity, karat, melting weight/value, wastage percentage
- **Business Fields**: SKU, supplier, purchase price, margin calculations
- **Physical Properties**: Weight, dimensions, stone details
- **Professional Features**: Warranty, certifications, featured items

### 🔐 Security & Access
- **Role-based Access Control**: Admin and user roles with different permissions
- **User Approval System**: Admins must approve new user registrations
- **JWT Authentication**: Secure token-based authentication
- **Admin Limitations**: Maximum 3 admin accounts allowed
- **File Upload Security**: Image validation and size limits