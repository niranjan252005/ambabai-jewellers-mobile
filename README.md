# 💎 Ambabai Jewellers - Premium Jewelry Website

**श्री अंबाबाई ज्वेलर्स** - Your trusted jewelry partner since 2014

## 🏪 About Ambabai Jewellers

**Ambabai Jewellers** is a premium jewelry store located in Vishal Nagar, Hupari - 416203, Maharashtra. We specialize in exquisite gold and silver jewelry with over 10 years of experience in the industry.

### 📍 Store Information
- **Address:** Vishal Nagar, Hupari - 416203, Maharashtra, India
- **Phone:** +91 7666993107
- **Email:** ambabaijewellers@gmail.com
- **Owner:** Niranjan Barwade
- **Established:** 2014
- **Rating:** 4.9⭐ (2000+ Happy Customers)

## 🌐 Website Features

### 👥 For Customers
- **Professional Website** with beautiful jewelry showcase
- **Customer Registration** with admin approval system
- **Gold Collection** - Premium 18k & 22k gold jewelry
- **Silver Collection** - Elegant sterling silver pieces
- **Advanced Search** - Find jewelry by SKU, category, material
- **Image Zoom** - Detailed jewelry viewing
- **Mobile Responsive** - Works on all devices
- **Contact Information** - Direct access to store details

### 👨‍💼 For Admin
- **Complete Admin Panel** for jewelry management
- **Add Jewelry Items** with photo upload
- **Customer Approval System** with email notifications
- **Inventory Management** with stock tracking
- **Business Analytics** dashboard
- **User Management** - approve/reject customers

## 🚀 Technology Stack

### Backend
- **Node.js** with Express.js
- **SQLite** database
- **JWT** authentication
- **Multer** for file uploads
- **Nodemailer** for email notifications
- **bcryptjs** for password security

### Frontend
- **HTML5** with modern CSS3
- **Vanilla JavaScript** (no frameworks)
- **Responsive Design** for all devices
- **Professional UI/UX** for jewelry business

## 🔐 Access Credentials

### Admin Login
- **Email:** admin@ambabaijewellers.com
- **Password:** admin123
- **Role:** Full admin access

### Customer Registration
- New customers can register on the website
- Admin approval required
- Notifications sent to: barwadeniranjan@gmail.com

## 🛠️ Installation & Setup

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Local Development
```bash
# Clone the repository
git clone https://github.com/yourusername/ambabai-jewellers-website.git

# Navigate to project directory
cd ambabai-jewellers-website

# Install dependencies
cd backend && npm install

# Start the server
npm start

# Visit http://localhost:3000
```

### Environment Variables
Create a `.env` file in the backend directory:
```env
NODE_ENV=development
PORT=3000
JWT_SECRET=jewelry_app_secret_key
ADMIN_EMAIL=barwadeniranjan@gmail.com
```

## 🌐 Deployment

### Free Hosting Options

#### 1. Railway (Recommended)
```bash
# Deploy to Railway
1. Go to https://railway.app
2. Sign up with GitHub
3. Connect this repository
4. Auto-deploy with railway.json config
```

#### 2. Render
```bash
# Deploy to Render
1. Go to https://render.com
2. Connect GitHub repository
3. Use render.yaml configuration
4. Auto-deploy
```

#### 3. Vercel
```bash
# Deploy to Vercel
1. Go to https://vercel.com
2. Import GitHub repository
3. Use vercel.json configuration
4. Instant deployment
```

## 📱 Mobile App

This repository also includes a complete Flutter mobile app with the same features:

### Mobile App Features
- **Native Android/iOS** app
- **Offline Capability** with local database
- **Photo Upload** from camera/gallery
- **Share Functionality** with WhatsApp integration
- **Push Notifications** for admin approvals
- **Consistent Branding** with website

### Build Mobile App
```bash
# Navigate to mobile directory
cd mobile

# Install Flutter dependencies
flutter pub get

# Build APK
flutter build apk --release

# Build iOS (on macOS)
flutter build ios --release
```

## 🎨 Branding & Design

### Color Scheme
- **Primary Gold:** #D4AF37
- **Secondary Gold:** #B8941F
- **Dark Gray:** #2C2C2C
- **Background:** Linear gradients with professional appearance

### Logo & Branding
- **Custom Diamond Logo** with SAJ symbol
- **Marathi Text:** श्री अंबाबाई ज्वेलर्स
- **Professional Typography** with gold accents
- **Consistent Branding** across all platforms

## 📊 Database Schema

### Users Table
- id, username, email, password, role, approved, phone, address, created_at

### Jewelry Table
- id, name, description, price, category, material, weight, stock_quantity, image_url, sku, brand, size, karat, purity, melting_weight, melting_value, created_at

## 🔧 API Endpoints

### Authentication
- `POST /api/register` - Customer registration
- `POST /api/login` - User login
- `POST /api/logout` - User logout

### Jewelry Management
- `GET /api/jewelry` - Get all jewelry items
- `POST /api/jewelry` - Add new jewelry item (admin)
- `PUT /api/jewelry/:id` - Update jewelry item (admin)
- `DELETE /api/jewelry/:id` - Delete jewelry item (admin)
- `GET /api/jewelry/search` - Search jewelry items

### Admin Functions
- `GET /api/admin/pending-users` - Get pending customer approvals
- `POST /api/admin/approve-user/:id` - Approve customer
- `DELETE /api/admin/reject-user/:id` - Reject customer
- `GET /api/admin/users` - Get all users

## 📧 Email Notifications

Admin receives email notifications for:
- New customer registrations
- Customer approval requests
- System alerts and updates

**Admin Email:** barwadeniranjan@gmail.com

## 🔒 Security Features

- **JWT Authentication** with secure tokens
- **Password Hashing** with bcryptjs
- **Role-based Access Control** (admin/customer)
- **Input Validation** and sanitization
- **File Upload Security** with type checking
- **CORS Protection** for API endpoints

## 📱 Responsive Design

### Supported Devices
- **Desktop** - Full-featured admin panel
- **Tablet** - Optimized layout and navigation
- **Mobile** - Touch-friendly interface
- **All Screen Sizes** - Fluid responsive design

## 🎯 Business Benefits

### Online Presence
- **Professional Website** for Ambabai Jewellers
- **24/7 Accessibility** for customers
- **SEO Optimized** for local search
- **Social Media Integration** ready

### Customer Management
- **Streamlined Registration** process
- **Admin Approval Workflow** for quality control
- **Customer Database** management
- **Email Communication** system

### Jewelry Showcase
- **Beautiful Product Display** with high-quality images
- **Organized Collections** by material and category
- **Detailed Information** including weight, purity, pricing
- **Search and Filter** capabilities

## 📈 Analytics & Insights

### Business Metrics
- Customer registration tracking
- Popular jewelry categories
- Search query analysis
- Admin activity monitoring

## 🆘 Support & Maintenance

### Technical Support
- **Documentation** - Comprehensive guides included
- **Error Logging** - Built-in error tracking
- **Database Backup** - Regular backup procedures
- **Security Updates** - Regular dependency updates

### Business Support
- **Admin Training** - Complete admin panel guide
- **Customer Support** - Help documentation
- **Feature Requests** - Continuous improvement

## 📞 Contact & Support

### Business Contact
- **Phone:** +91 7666993107
- **Email:** ambabaijewellers@gmail.com
- **WhatsApp:** +91 7666993107
- **Address:** Vishal Nagar, Hupari - 416203

### Technical Support
- **Admin Email:** barwadeniranjan@gmail.com
- **GitHub Issues:** Use repository issues for technical problems
- **Documentation:** Check deployment guides and documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Ambabai Jewellers** - For trusting us with their digital presence
- **Niranjan Barwade** - Owner and visionary behind the business
- **Customers** - 2000+ happy customers who inspire us
- **Community** - Hupari community support

---

## 🌟 Live Website

**Visit our live website:** [Coming Soon - Deploy to get live link]

### Quick Deploy
1. **Fork this repository**
2. **Choose hosting platform** (Railway, Render, Vercel)
3. **Connect GitHub repository**
4. **Auto-deploy** with included configurations
5. **Get live link** in minutes!

---

**💎 Ambabai Jewellers - Where tradition meets technology 💎**

**श्री अंबाबाई ज्वेलर्स - आपका विश्वसनीय आभूषण साझीदार**