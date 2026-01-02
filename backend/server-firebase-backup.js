const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const multer = require('multer');
const path = require('path');
const nodemailer = require('nodemailer');
const fs = require('fs');

// Firebase imports
const { admin, db, FirebaseService } = require('./services/firebase');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = 'jewelry_app_secret_key';

// Admin notification configuration
const ADMIN_EMAIL = 'barwadeniranjan@gmail.com';
const ADMIN_PHONE = '+917666993107';

// Email configuration - For now using console notifications
const emailTransporter = nodemailer.createTransporter({
  service: 'gmail',
  auth: {
    user: 'your-email@gmail.com', // Replace with your Gmail
    pass: 'your-app-password' // Replace with Gmail App Password
  }
});

// For now, we'll use console notifications + file logging
const logNotification = (message) => {
  const timestamp = new Date().toLocaleString();
  const logMessage = `[${timestamp}] ${message}\n`;
  
  // Console notification
  console.log('\n🔔 ADMIN NOTIFICATION:');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(message);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  
  // File logging
  try {
    fs.appendFileSync('admin_notifications.log', logMessage);
  } catch (e) {
    console.log('Failed to write to log file:', e);
  }
};

// Notification functions
const sendAdminNotification = async (type, data) => {
  try {
    let message = '';
    
    switch (type) {
      case 'new_user_registration':
        message = `🆕 NEW USER REGISTERED\n\nName: ${data.username}\nEmail: ${data.email}\nStatus: ${data.message}\n\nTime: ${new Date().toLocaleString()}`;
        break;
      case 'user_deleted':
        message = `🗑️ USER DELETED\n\nName: ${data.username}\nEmail: ${data.email}\nDeleted by: ${data.deletedBy}\n\nTime: ${new Date().toLocaleString()}`;
        break;
      default:
        message = `📱 JEWELRY APP NOTIFICATION\n\n${JSON.stringify(data, null, 2)}\n\nTime: ${new Date().toLocaleString()}`;
    }
    
    // Log to console and file
    logNotification(message);
    
    // TODO: Send actual email notification
    // await emailTransporter.sendMail({
    //   from: 'jewelry-app@example.com',
    //   to: [ADMIN_EMAIL, 'ambabaijewellers@gmail.com'],
    //   subject: `Jewelry App: ${type.replace('_', ' ').toUpperCase()}`,
    //   text: message
    // });
    
  } catch (error) {
    console.error('Failed to send admin notification:', error);
  }
};

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// File upload configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = 'public/uploads';
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage });

// Firebase Database initialization
console.log('🔥 Initializing Firebase Firestore...');

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    server: 'Ambabai Jewellers API with Firebase Firestore',
    adminEmails: ['barwadeniranjan@gmail.com', 'ambabaijewellers@gmail.com'],
    database: 'Firebase Firestore'
  });
});

// Authentication middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
};

// Auth routes
app.post('/api/register', async (req, res) => {
  const { username, email, password, role } = req.body;
  
  try {
    // Check if user already exists
    const existingUserQuery = await FirebaseService.users()
      .where('email', '==', email)
      .get();

    if (!existingUserQuery.empty) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Check if trying to register as admin
    if (role === 'admin') {
      // Count existing admins
      const adminQuery = await FirebaseService.users()
        .where('role', '==', 'admin')
        .get();
      
      // Limit to maximum 3 admins
      if (adminQuery.size >= 3) {
        return res.status(400).json({ error: 'Maximum number of admins reached' });
      }
      
      // Create admin user
      const hashedPassword = await bcrypt.hash(password, 10);
      await FirebaseService.users().add({
        username,
        name: username,
        email,
        password: hashedPassword,
        role: 'admin',
        is_approved: true,
        created_at: FirebaseService.serverTimestamp()
      });
      
      res.json({ message: 'Admin registered successfully.' });
    } else {
      // Regular user registration - auto-approved
      const hashedPassword = await bcrypt.hash(password, 10);
      
      await FirebaseService.users().add({
        username,
        name: username,
        email,
        password: hashedPassword,
        role: 'user',
        is_approved: true, // Auto-approve new users
        created_at: FirebaseService.serverTimestamp()
      });
      
      // Send notification to admin about new user
      sendAdminNotification('new_user_registration', {
        username,
        email,
        message: 'New user registered and can login immediately'
      });
      
      res.json({ message: 'Account created successfully! You can now login.' });
    }
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  
  try {
    // Find user by email
    const userQuery = await FirebaseService.users()
      .where('email', '==', email)
      .get();

    if (userQuery.empty) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    const userDoc = userQuery.docs[0];
    const user = FirebaseService.docToObject(userDoc);

    // Check password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    // Remove password from response
    delete user.password;

    res.json({ token, user });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Routes
const jewelryRoutes = require('./routes/jewelry');
const userRoutes = require('./routes/users');
const orderRoutes = require('./routes/orders');

// Use routes
app.use('/api/jewelry', authenticateToken, jewelryRoutes);
app.use('/api/users', authenticateToken, userRoutes);
app.use('/api/orders', authenticateToken, orderRoutes);

// Admin stats endpoint
app.get('/api/admin/stats', authenticateToken, async (req, res) => {
  try {
    // Get total jewelry items
    const itemsSnapshot = await FirebaseService.jewelryItems().get();
    const totalItems = itemsSnapshot.size;
    
    // Get total users
    const usersSnapshot = await FirebaseService.users()
      .where('role', '==', 'user')
      .get();
    const totalUsers = usersSnapshot.size;
    
    // Get pending users (should be 0 since auto-approval)
    const pendingUsersSnapshot = await FirebaseService.users()
      .where('role', '==', 'user')
      .where('is_approved', '==', false)
      .get();
    const pendingUsers = pendingUsersSnapshot.size;
    
    // Get total orders
    const ordersSnapshot = await FirebaseService.orders().get();
    const totalOrders = ordersSnapshot.size;
    
    // Get total revenue
    const orders = FirebaseService.queryToArray(ordersSnapshot);
    const totalRevenue = orders
      .filter(order => order.status !== 'cancelled')
      .reduce((sum, order) => sum + (order.total_price || 0), 0);
    
    res.json({
      totalItems,
      totalUsers,
      pendingUsers,
      totalOrders,
      totalRevenue
    });
  } catch (error) {
    console.error('Error fetching admin stats:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Share routes
app.get('/api/share/jewelry/:id', async (req, res) => {
  try {
    const jewelryId = req.params.id;
    
    const itemDoc = await FirebaseService.jewelryItems().doc(jewelryId).get();
    if (!itemDoc.exists) {
      return res.status(404).json({ error: 'Jewelry item not found' });
    }
    
    const item = FirebaseService.docToObject(itemDoc);
    
    // Return item data for sharing
    res.json({
      success: true,
      item: {
        id: item.id,
        name: item.name,
        description: item.description,
        price: item.price,
        category: item.category,
        material: item.material,
        weight: item.weight,
        image_url: item.image_url,
        sku: item.sku
      },
      share_url: `${req.protocol}://${req.get('host')}/share/jewelry/${jewelryId}`
    });
  } catch (error) {
    console.error('Error fetching item for sharing:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Public share page (HTML)
app.get('/share/jewelry/:id', async (req, res) => {
  try {
    const jewelryId = req.params.id;
    
    const itemDoc = await FirebaseService.jewelryItems().doc(jewelryId).get();
    if (!itemDoc.exists) {
      return res.status(404).send('Item not found');
    }
    
    const item = FirebaseService.docToObject(itemDoc);
    
    // Generate HTML page for sharing
    const html = `
      <!DOCTYPE html>
      <html>
      <head>
        <title>${item.name} - Ambabai Jewellers</title>
        <meta property="og:title" content="${item.name}" />
        <meta property="og:description" content="${item.description}" />
        <meta property="og:image" content="${req.protocol}://${req.get('host')}${item.image_url}" />
        <meta property="og:url" content="${req.protocol}://${req.get('host')}/share/jewelry/${jewelryId}" />
        <style>
          body { font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; }
          .item-card { border: 1px solid #ddd; border-radius: 8px; padding: 20px; }
          .item-image { width: 100%; max-width: 400px; height: auto; border-radius: 8px; }
          .price { color: #d4af37; font-size: 24px; font-weight: bold; }
          .details { margin-top: 15px; }
          .detail-row { margin: 5px 0; }
        </style>
      </head>
      <body>
        <div class="item-card">
          <h1>${item.name}</h1>
          ${item.image_url ? `<img src="${item.image_url}" alt="${item.name}" class="item-image" />` : ''}
          <p class="price">₹${item.price}</p>
          <p>${item.description}</p>
          <div class="details">
            <div class="detail-row"><strong>Category:</strong> ${item.category}</div>
            <div class="detail-row"><strong>Material:</strong> ${item.material}</div>
            <div class="detail-row"><strong>Weight:</strong> ${item.weight}g</div>
            <div class="detail-row"><strong>SKU:</strong> ${item.sku}</div>
          </div>
          <p><strong>Contact Ambabai Jewellers:</strong> +91 7666993107</p>
        </div>
      </body>
      </html>
    `;
    
    res.send(html);
  } catch (error) {
    console.error('Error generating share page:', error);
    res.status(500).send('Error loading item');
  }
});

// Debug endpoints for checking database
app.get('/api/debug/users', async (req, res) => {
  try {
    const usersSnapshot = await FirebaseService.users()
      .orderBy('created_at', 'desc')
      .get();
    
    const users = FirebaseService.queryToArray(usersSnapshot);
    users.forEach(user => delete user.password); // Remove passwords
    
    res.json({
      users,
      count: users.length,
      adminEmail: 'barwadeniranjan@gmail.com',
      database: 'Firebase Firestore'
    });
  } catch (error) {
    console.error('Error in debug users:', error);
    res.status(500).json({ error: 'Database error', details: error.message });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🔥 Firebase Firestore connected`);
  console.log(`📧 Admin notifications: ${ADMIN_EMAIL}`);
});

module.exports = app;