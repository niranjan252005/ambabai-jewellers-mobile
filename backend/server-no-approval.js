const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const sqlite3 = require('sqlite3').verbose();
const multer = require('multer');
const path = require('path');
const nodemailer = require('nodemailer');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = 'jewelry_app_secret_key';

// Admin notification configuration
const ADMIN_EMAIL = 'barwadeniranjan@gmail.com';
const ADMIN_PHONE = '+917666993107';

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
        message = `🆕 NEW USER REGISTERED\n\nName: ${data.username}\nEmail: ${data.email}\nStatus: Auto-approved - can login immediately\n\nTime: ${new Date().toLocaleString()}`;
        break;
      case 'user_deleted':
        message = `🗑️ USER DELETED\n\nName: ${data.username}\nEmail: ${data.email}\nDeleted by: ${data.deletedBy}\n\nTime: ${new Date().toLocaleString()}`;
        break;
      default:
        message = `📱 JEWELRY APP NOTIFICATION\n\n${JSON.stringify(data, null, 2)}\n\nTime: ${new Date().toLocaleString()}`;
    }
    
    // Log to console and file
    logNotification(message);
    
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

// SQLite Database initialization
const db = new sqlite3.Database('jewelry.db');

// Initialize database tables
db.serialize(() => {
  // Users table
  db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT DEFAULT 'user',
    is_approved INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  // Jewelry items table
  db.run(`CREATE TABLE IF NOT EXISTS jewelry_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    category TEXT NOT NULL,
    material TEXT NOT NULL,
    weight REAL,
    stock_quantity INTEGER DEFAULT 0,
    image_path TEXT,
    brand TEXT,
    size TEXT,
    color TEXT,
    gender TEXT,
    is_certified INTEGER DEFAULT 0,
    is_handmade INTEGER DEFAULT 0,
    sku TEXT UNIQUE,
    purity TEXT,
    karat INTEGER,
    melting_weight REAL,
    melting_value REAL,
    wastage_percentage REAL,
    making_charges REAL,
    supplier TEXT,
    purchase_price REAL,
    margin_percentage REAL,
    stone_details TEXT,
    warranty_period TEXT,
    is_featured INTEGER DEFAULT 0,
    is_bestseller INTEGER DEFAULT 0,
    is_new_arrival INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  // Orders table
  db.run(`CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    jewelry_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    total_price REAL NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (jewelry_id) REFERENCES jewelry_items (id)
  )`);

  // Insert default admin user if not exists
  db.get("SELECT * FROM users WHERE email = 'admin@jewelry.com'", (err, row) => {
    if (!row) {
      const hashedPassword = bcrypt.hashSync('admin123', 10);
      db.run(`INSERT INTO users (username, email, password, role, is_approved) 
              VALUES (?, ?, ?, ?, ?)`, 
              ['admin', 'admin@jewelry.com', hashedPassword, 'admin', 1]);
      console.log('✅ Default admin user created');
    }
  });
});

console.log('🗄️ SQLite Database initialized (NO APPROVAL SYSTEM)');

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    server: 'Ambabai Jewellers API - No Approval System',
    adminEmails: ['barwadeniranjan@gmail.com', 'ambabaijewellers@gmail.com'],
    database: 'SQLite (No Approval Required)',
    approvalSystem: 'DISABLED - Users can login immediately'
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
    db.get("SELECT * FROM users WHERE email = ?", [email], async (err, row) => {
      if (err) {
        return res.status(500).json({ error: 'Database error' });
      }
      
      if (row) {
        return res.status(400).json({ error: 'User already exists' });
      }

      // Check if trying to register as admin
      if (role === 'admin') {
        // Count existing admins
        db.get("SELECT COUNT(*) as count FROM users WHERE role = 'admin'", (err, result) => {
          if (err) {
            return res.status(500).json({ error: 'Database error' });
          }
          
          // Limit to maximum 3 admins
          if (result.count >= 3) {
            return res.status(400).json({ error: 'Maximum number of admins reached' });
          }
          
          // Create admin user
          const hashedPassword = bcrypt.hashSync(password, 10);
          db.run(`INSERT INTO users (username, email, password, role, is_approved) 
                  VALUES (?, ?, ?, ?, ?)`, 
                  [username, email, hashedPassword, 'admin', 1], function(err) {
            if (err) {
              return res.status(500).json({ error: 'Failed to create admin user' });
            }
            
            res.json({ message: 'Admin registered successfully.' });
          });
        });
      } else {
        // Regular user registration - AUTO-APPROVED (NO APPROVAL NEEDED)
        const hashedPassword = bcrypt.hashSync(password, 10);
        
        db.run(`INSERT INTO users (username, email, password, role, is_approved) 
                VALUES (?, ?, ?, ?, ?)`, 
                [username, email, hashedPassword, 'user', 1], function(err) {
          if (err) {
            return res.status(500).json({ error: 'Failed to create user' });
          }
          
          // Send notification to admin about new user
          sendAdminNotification('new_user_registration', {
            username,
            email,
            message: 'New user registered and can login immediately (no approval required)'
          });
          
          res.json({ message: 'Account created successfully! You can now login immediately.' });
        });
      }
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  
  try {
    // Find user by email
    db.get("SELECT * FROM users WHERE email = ?", [email], async (err, user) => {
      if (err) {
        return res.status(500).json({ error: 'Database error' });
      }
      
      if (!user) {
        return res.status(400).json({ error: 'Invalid credentials' });
      }

      // Check password
      const validPassword = await bcrypt.compare(password, user.password);
      if (!validPassword) {
        return res.status(400).json({ error: 'Invalid credentials' });
      }

      // NO APPROVAL CHECK - ALL USERS CAN LOGIN IMMEDIATELY
      console.log(`✅ User login successful: ${user.email} (No approval required)`);

      // Generate JWT token
      const token = jwt.sign(
        { id: user.id, username: user.username, role: user.role },
        JWT_SECRET,
        { expiresIn: '24h' }
      );

      // Remove password from response
      delete user.password;

      res.json({ token, user });
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Users management routes
app.get('/api/users', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }

  db.all("SELECT id, username, email, role, is_approved, created_at FROM users WHERE role = 'user'", (err, users) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(users);
  });
});

app.delete('/api/users/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }

  const userId = req.params.id;

  // Get user info before deletion for notification
  db.get("SELECT * FROM users WHERE id = ?", [userId], (err, user) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Delete user
    db.run("DELETE FROM users WHERE id = ?", [userId], function(err) {
      if (err) {
        return res.status(500).json({ error: 'Failed to delete user' });
      }

      // Send notification
      sendAdminNotification('user_deleted', {
        username: user.username,
        email: user.email,
        deletedBy: req.user.username
      });

      res.json({ message: 'User deleted successfully' });
    });
  });
});

// Admin stats endpoint
app.get('/api/admin/stats', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }

  // Get stats from database
  const stats = {};
  
  db.get("SELECT COUNT(*) as count FROM jewelry_items", (err, result) => {
    stats.totalItems = result ? result.count : 0;
    
    db.get("SELECT COUNT(*) as count FROM users WHERE role = 'user'", (err, result) => {
      stats.totalUsers = result ? result.count : 0;
      stats.pendingUsers = 0; // No pending users since approval is disabled
      
      db.get("SELECT COUNT(*) as count FROM orders", (err, result) => {
        stats.totalOrders = result ? result.count : 0;
        
        db.get("SELECT SUM(total_price) as revenue FROM orders WHERE status != 'cancelled'", (err, result) => {
          stats.totalRevenue = result ? (result.revenue || 0) : 0;
          
          res.json(stats);
        });
      });
    });
  });
});

// Debug endpoint
app.get('/api/debug/users', (req, res) => {
  db.all("SELECT id, username, email, role, is_approved, created_at FROM users ORDER BY created_at DESC", (err, users) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    
    res.json({
      users,
      count: users.length,
      adminEmail: 'barwadeniranjan@gmail.com',
      database: 'SQLite (No Approval System)',
      approvalSystem: 'DISABLED'
    });
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🗄️ SQLite Database connected`);
  console.log(`📧 Admin notifications: ${ADMIN_EMAIL}`);
  console.log(`✅ NO APPROVAL SYSTEM - Users can login immediately!`);
});

module.exports = app;