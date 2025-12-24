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
// To enable email: Replace with your Gmail credentials
const emailTransporter = nodemailer.createTransport({
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
    if (type === 'new_user_registration') {
      const notificationMessage = `
🔔 NEW CUSTOMER REGISTRATION - AMBABAI JEWELLERS

👤 Customer Details:
   Name: ${data.username}
   Email: ${data.email}
   Phone: ${data.phone || 'Not provided'}
   Registration Time: ${new Date().toLocaleString()}

⚡ Action Required:
   Please login to approve this customer:
   🌐 Admin Panel: http://localhost:3000
   📱 Mobile App: Admin Panel → Manage Users

📧 Admin Email: ${ADMIN_EMAIL}
📞 Admin Phone: ${ADMIN_PHONE}
      `;
      
      // Console + File notification (always works)
      logNotification(notificationMessage);
      
      // Try email notification (if configured)
      try {
        await emailTransporter.sendMail({
          from: 'noreply@ambabaijewellers.com',
          to: ADMIN_EMAIL,
          subject: '🔔 New Customer Registration - Approval Required',
          text: notificationMessage
        });
        console.log('✅ Email notification sent successfully');
      } catch (emailError) {
        console.log('⚠️ Email not configured, using console notification only');
        console.log('To enable email: Update Gmail credentials in server.js');
      }
    }
  } catch (error) {
    console.error('❌ Failed to send admin notification:', error);
  }
};

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static('uploads'));
app.use(express.static('public'));

// Multer configuration for image uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
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

// Admin middleware
const requireAdmin = (req, res, next) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }
  next();
};

// Routes

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

// Jewelry items routes
app.get('/api/jewelry', authenticateToken, (req, res) => {
  db.all('SELECT * FROM jewelry_items ORDER BY created_at DESC', (err, items) => {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    res.json(items);
  });
});

// Search jewelry items by name, SKU, category, material, or description
app.get('/api/jewelry/search', authenticateToken, (req, res) => {
  const { q } = req.query; // search query
  
  if (!q || q.trim().length === 0) {
    return res.status(400).json({ error: 'Search query is required' });
  }
  
  const searchTerm = `%${q.trim()}%`;
  
  const query = `
    SELECT * FROM jewelry_items 
    WHERE name LIKE ? 
       OR sku LIKE ? 
       OR category LIKE ? 
       OR material LIKE ? 
       OR description LIKE ?
       OR brand LIKE ?
       OR color LIKE ?
    ORDER BY 
      CASE 
        WHEN sku LIKE ? THEN 1
        WHEN name LIKE ? THEN 2
        WHEN category LIKE ? THEN 3
        ELSE 4
      END,
      created_at DESC
  `;
  
  db.all(query, [
    searchTerm, searchTerm, searchTerm, searchTerm, searchTerm, searchTerm, searchTerm,
    searchTerm, searchTerm, searchTerm
  ], (err, items) => {
    if (err) {
      console.error('Search error:', err);
      return res.status(500).json({ error: 'Server error' });
    }
    
    res.json({
      query: q,
      count: items.length,
      items: items
    });
  });
});

// Handle jewelry creation with optional file upload
app.post('/api/jewelry', authenticateToken, requireAdmin, (req, res) => {
  // Use multer for multipart requests, otherwise parse normally
  const isMultipart = req.headers['content-type'] && req.headers['content-type'].includes('multipart/form-data');
  
  if (isMultipart) {
    upload.single('image')(req, res, (err) => {
      if (err) {
        return res.status(400).json({ error: 'File upload error: ' + err.message });
      }
      processJewelryCreation(req, res);
    });
  } else {
    processJewelryCreation(req, res);
  }
});

function processJewelryCreation(req, res) {
  console.log('Received request body:', req.body);
  console.log('Received file:', req.file);
  
  const { 
    name, description, price, category, material, weight, stock_quantity,
    brand, size, color, gender, is_certified, is_handmade,
    purity, karat, melting_weight, melting_value, wastage_percentage, making_charges,
    sku, supplier, purchase_price, stone_weight, stone_type, stone_count, warranty_months
  } = req.body;
  
  // Validate required fields
  if (!name || !price || !category || !material || !weight || !stock_quantity) {
    console.log('Missing required fields:', { name, price, category, material, weight, stock_quantity });
    return res.status(400).json({ 
      error: 'Missing required fields: name, price, category, material, weight, stock_quantity',
      received: { name, price, category, material, weight, stock_quantity }
    });
  }
  
  const image_url = req.file ? `/uploads/${req.file.filename}` : null;
  
  // Generate SKU if not provided
  const generatedSku = sku || `${category.substring(0,2).toUpperCase()}-${Date.now()}`;
  
  db.run(
    `INSERT INTO jewelry_items (
      name, description, price, category, material, weight, image_url, stock_quantity, 
      brand, size, color, gender, is_certified, is_handmade,
      purity, karat, melting_weight, melting_value, wastage_percentage, making_charges,
      sku, supplier, purchase_price, stone_weight, stone_type, stone_count, warranty_months
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      name, 
      description || '', 
      parseFloat(price), 
      category, 
      material, 
      parseFloat(weight), 
      image_url, 
      parseInt(stock_quantity), 
      brand || null, 
      size || null, 
      color || null, 
      gender || 'Unisex', 
      is_certified === 'true' ? 1 : 0, 
      is_handmade === 'true' ? 1 : 0,
      purity || null,
      karat ? parseInt(karat) : null,
      melting_weight ? parseFloat(melting_weight) : null,
      melting_value ? parseFloat(melting_value) : null,
      wastage_percentage ? parseFloat(wastage_percentage) : null,
      making_charges ? parseFloat(making_charges) : null,
      generatedSku,
      supplier || null,
      purchase_price ? parseFloat(purchase_price) : null,
      stone_weight ? parseFloat(stone_weight) : null,
      stone_type || null,
      stone_count ? parseInt(stone_count) : null,
      warranty_months ? parseInt(warranty_months) : 12
    ],
    function(err) {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).json({ error: 'Database error: ' + err.message });
      }
      console.log('Successfully added item with ID:', this.lastID);
      res.json({ id: this.lastID, message: 'Jewelry item created successfully', sku: generatedSku });
    }
  );
}

app.delete('/api/jewelry/:id', authenticateToken, requireAdmin, (req, res) => {
  const jewelryId = req.params.id;
  
  // Check if item exists and get image URL for cleanup
  db.get('SELECT image_url FROM jewelry_items WHERE id = ?', [jewelryId], (err, item) => {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    
    if (!item) {
      return res.status(404).json({ error: 'Jewelry item not found' });
    }
    
    // Delete the item
    db.run('DELETE FROM jewelry_items WHERE id = ?', [jewelryId], function(err) {
      if (err) {
        return res.status(500).json({ error: 'Server error' });
      }
      
      // TODO: Delete image file from uploads folder if needed
      // const fs = require('fs');
      // if (item.image_url) {
      //   fs.unlink(`./uploads/${path.basename(item.image_url)}`, () => {});
      // }
      
      res.json({ message: 'Jewelry item deleted successfully' });
    });
  });
});

app.put('/api/jewelry/:id', authenticateToken, requireAdmin, upload.single('image'), (req, res) => {
  const jewelryId = req.params.id;
  const { name, description, price, category, material, weight, stock_quantity } = req.body;
  const image_url = req.file ? `/uploads/${req.file.filename}` : null;
  
  // Build update query dynamically
  let updateFields = [];
  let updateValues = [];
  
  if (name) { updateFields.push('name = ?'); updateValues.push(name); }
  if (description !== undefined) { updateFields.push('description = ?'); updateValues.push(description); }
  if (price) { updateFields.push('price = ?'); updateValues.push(price); }
  if (category) { updateFields.push('category = ?'); updateValues.push(category); }
  if (material) { updateFields.push('material = ?'); updateValues.push(material); }
  if (weight) { updateFields.push('weight = ?'); updateValues.push(weight); }
  if (stock_quantity !== undefined) { updateFields.push('stock_quantity = ?'); updateValues.push(stock_quantity); }
  if (image_url) { updateFields.push('image_url = ?'); updateValues.push(image_url); }
  
  if (updateFields.length === 0) {
    return res.status(400).json({ error: 'No fields to update' });
  }
  
  updateValues.push(jewelryId);
  
  const query = `UPDATE jewelry_items SET ${updateFields.join(', ')} WHERE id = ?`;
  
  db.run(query, updateValues, function(err) {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    
    if (this.changes === 0) {
      return res.status(404).json({ error: 'Jewelry item not found' });
    }
    
    res.json({ message: 'Jewelry item updated successfully' });
  });
});

// Orders routes
app.post('/api/orders', authenticateToken, (req, res) => {
  const { jewelry_id, quantity } = req.body;
  const user_id = req.user.id;
  
  // Get jewelry item details
  db.get('SELECT * FROM jewelry_items WHERE id = ?', [jewelry_id], (err, item) => {
    if (err || !item) {
      return res.status(404).json({ error: 'Jewelry item not found' });
    }
    
    if (item.stock_quantity < quantity) {
      return res.status(400).json({ error: 'Insufficient stock' });
    }
    
    const total_price = item.price * quantity;
    
    db.run(
      'INSERT INTO orders (user_id, jewelry_id, quantity, total_price) VALUES (?, ?, ?, ?)',
      [user_id, jewelry_id, quantity, total_price],
      function(err) {
        if (err) {
          return res.status(500).json({ error: 'Server error' });
        }
        
        // Update stock
        db.run(
          'UPDATE jewelry_items SET stock_quantity = stock_quantity - ? WHERE id = ?',
          [quantity, jewelry_id]
        );
        
        res.json({ id: this.lastID, message: 'Order placed successfully' });
      }
    );
  });
});

app.get('/api/orders', authenticateToken, (req, res) => {
  let query = `
    SELECT o.*, j.name as jewelry_name, j.image_url, u.username
    FROM orders o
    JOIN jewelry_items j ON o.jewelry_id = j.id
    JOIN users u ON o.user_id = u.id
  `;
  
  if (req.user.role !== 'admin') {
    query += ' WHERE o.user_id = ?';
    db.all(query, [req.user.id], (err, orders) => {
      if (err) {
        return res.status(500).json({ error: 'Server error' });
      }
      res.json(orders);
    });
  } else {
    query += ' ORDER BY o.created_at DESC';
    db.all(query, (err, orders) => {
      if (err) {
        return res.status(500).json({ error: 'Server error' });
      }
      res.json(orders);
    });
  }
});

// Admin routes
app.get('/api/admin/users', authenticateToken, requireAdmin, (req, res) => {
  db.all('SELECT id, username, email, role, is_approved, created_at FROM users', (err, users) => {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    res.json(users);
  });
});

app.put('/api/admin/users/:id/approve', authenticateToken, requireAdmin, (req, res) => {
  const userId = req.params.id;
  
  db.run('UPDATE users SET is_approved = 1 WHERE id = ?', [userId], function(err) {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    res.json({ message: 'User approved successfully' });
  });
});

// Admin statistics endpoint
app.get('/api/admin/stats', authenticateToken, requireAdmin, (req, res) => {
  const stats = {};
  
  // Get total jewelry items
  db.get('SELECT COUNT(*) as total FROM jewelry_items', (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    stats.totalItems = result.total;
    
    // Get total users
    db.get('SELECT COUNT(*) as total FROM users WHERE role = "user"', (err, result) => {
      if (err) {
        return res.status(500).json({ error: 'Server error' });
      }
      stats.totalUsers = result.total;
      
      // Get pending users
      db.get('SELECT COUNT(*) as total FROM users WHERE role = "user" AND is_approved = 0', (err, result) => {
        if (err) {
          return res.status(500).json({ error: 'Server error' });
        }
        stats.pendingUsers = result.total;
        
        // Get total orders
        db.get('SELECT COUNT(*) as total FROM orders', (err, result) => {
          if (err) {
            return res.status(500).json({ error: 'Server error' });
          }
          stats.totalOrders = result.total;
          
          // Get total revenue
          db.get('SELECT SUM(total_price) as revenue FROM orders WHERE status != "cancelled"', (err, result) => {
            if (err) {
              return res.status(500).json({ error: 'Server error' });
            }
            stats.totalRevenue = result.revenue || 0;
            
            // Get items by category
            db.all('SELECT category, COUNT(*) as count FROM jewelry_items GROUP BY category', (err, categories) => {
              if (err) {
                return res.status(500).json({ error: 'Server error' });
              }
              stats.itemsByCategory = categories;
              
              // Get items by material
              db.all('SELECT material, COUNT(*) as count FROM jewelry_items GROUP BY material', (err, materials) => {
                if (err) {
                  return res.status(500).json({ error: 'Server error' });
                }
                stats.itemsByMaterial = materials;
                
                res.json(stats);
              });
            });
          });
        });
      });
    });
  });
});

// Photo sharing route
app.get('/api/jewelry/:id/share', authenticateToken, (req, res) => {
  const jewelryId = req.params.id;
  
  db.get('SELECT * FROM jewelry_items WHERE id = ?', [jewelryId], (err, item) => {
    if (err || !item) {
      return res.status(404).json({ error: 'Jewelry item not found' });
    }
    
    // Create shareable content with image
    const shareData = {
      item: item,
      shareUrl: `${req.protocol}://${req.get('host')}/share/${jewelryId}`,
      imageUrl: item.image_url ? `${req.protocol}://${req.get('host')}/${item.image_url}` : null,
      shopInfo: {
        name: 'Ambabai Jewellers',
        phone: '+91 7666993107',
        email: 'ambabaijewellers@gmail.com',
        address: 'Vishal Nagar, Hupari - 416203'
      }
    };
    
    res.json(shareData);
  });
});

// Public share page (for shared links)
app.get('/share/:id', (req, res) => {
  const jewelryId = req.params.id;
  
  db.get('SELECT * FROM jewelry_items WHERE id = ?', [jewelryId], (err, item) => {
    if (err || !item) {
      return res.status(404).send('Item not found');
    }
    
    const shareHtml = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>${item.name} - Ambabai Jewellers</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
            .container { max-width: 600px; margin: 0 auto; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
            .header { background: #D4AF37; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; }
            .image { width: 100%; height: 300px; object-fit: cover; border-radius: 8px; }
            .price { font-size: 24px; font-weight: bold; color: #D4AF37; margin: 10px 0; }
            .details { margin: 15px 0; }
            .shop-info { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 20px; }
            .contact { margin: 5px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>श्री अंबाबाई ज्वेलर्स</h1>
                <p>Ambabai Jewellers</p>
            </div>
            <div class="content">
                ${item.image_url ? `<img src="/${item.image_url}" alt="${item.name}" class="image">` : ''}
                <h2>${item.name}</h2>
                <div class="price">₹${item.price.toLocaleString()}</div>
                <div class="details">
                    <p><strong>Description:</strong> ${item.description || 'Beautiful jewelry piece'}</p>
                    <p><strong>Category:</strong> ${item.category || 'Jewelry'}</p>
                    <p><strong>Material:</strong> ${item.material || 'Premium'}</p>
                    ${item.weight ? `<p><strong>Weight:</strong> ${item.weight}g</p>` : ''}
                </div>
                <div class="shop-info">
                    <h3>Contact Us</h3>
                    <div class="contact">📞 +91 7666993107</div>
                    <div class="contact">📧 ambabaijewellers@gmail.com</div>
                    <div class="contact">📍 Vishal Nagar, Hupari - 416203</div>
                </div>
            </div>
        </div>
    </body>
    </html>
    `;
    
    res.send(shareHtml);
  });
});

// Users management routes
app.get('/api/users', authenticateToken, requireAdmin, (req, res) => {
  db.all('SELECT id, username, email, role, is_approved, created_at FROM users ORDER BY created_at DESC', (err, users) => {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    res.json(users);
  });
});

// Admin notification routes
app.get('/api/admin/notifications', authenticateToken, requireAdmin, (req, res) => {
  // Get all users for management (no pending approval needed)
  db.all('SELECT * FROM users WHERE role = "user" ORDER BY created_at DESC', (err, users) => {
    if (err) {
      return res.status(500).json({ error: 'Server error' });
    }
    
    res.json({
      users: users,
      count: users.length,
      message: 'All users can login immediately. You can delete users if needed.'
    });
  });
});

// Delete user route (replaces approve user)
app.delete('/api/admin/delete-user/:id', authenticateToken, requireAdmin, (req, res) => {
  const userId = req.params.id;
  
  // Prevent admin from deleting themselves
  if (parseInt(userId) === req.user.id) {
    return res.status(400).json({ error: 'Cannot delete your own account' });
  }
  
  // Get user info before deletion for notification
  db.get('SELECT username, email FROM users WHERE id = ?', [userId], (err, user) => {
    if (err || !user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Delete the user
    db.run('DELETE FROM users WHERE id = ?', [userId], function(err) {
      if (err) {
        return res.status(500).json({ error: 'Server error' });
      }
      
      if (this.changes === 0) {
        return res.status(404).json({ error: 'User not found' });
      }
      
      // Send notification about user deletion
      sendAdminNotification('user_deleted', {
        username: user.username,
        email: user.email,
        deletedBy: req.user.username
      });
      
      res.json({ message: 'User deleted successfully' });
    });
  });
});

// Test notification route
app.get('/api/test-notification', (req, res) => {
  sendAdminNotification('new_user_registration', {
    username: 'Test Customer',
    email: 'test@example.com',
    phone: '+91 9876543210'
  });
  
  res.json({ 
    message: 'Test notification sent!',
    adminEmail: ADMIN_EMAIL,
    checkConsole: 'Check server console for notification'
  });
});

// Debug route to check all users (no auth required for debugging)
app.get('/api/debug/all-users', (req, res) => {
  db.all('SELECT id, username, email, role, is_approved, created_at FROM users ORDER BY created_at DESC', (err, users) => {
    if (err) {
      return res.status(500).json({ error: 'Database error', details: err.message });
    }
    
    res.json({
      users: users,
      count: users.length,
      message: 'All users can login immediately. No approval needed.',
      adminEmails: ADMIN_EMAILS
    });
  });
});

// Debug route to see all users
app.get('/api/debug/all-users', (req, res) => {
  db.all('SELECT id, username, email, role, is_approved, created_at FROM users ORDER BY created_at DESC', (err, users) => {
    if (err) {
      return res.status(500).json({ error: 'Database error', details: err.message });
    }
    
    res.json({
      allUsers: users,
      count: users.length,
      adminEmail: ADMIN_EMAIL,
      serverDatabase: 'This shows users in server database'
    });
  });
});

// Health check route
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    server: 'Ambabai Jewellers API',
    adminEmail: ADMIN_EMAIL 
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Ambabai Jewellers Server running on port ${PORT}`);
  console.log(`📱 Admin Panel: http://localhost:${PORT}`);
  console.log(`📧 Admin Notifications: ${ADMIN_EMAIL}`);
  console.log(`📞 Admin Phone: ${ADMIN_PHONE}`);
  console.log(`🧪 Test Notification: http://localhost:${PORT}/api/test-notification`);
  console.log(`\n💡 To enable email notifications:`);
  console.log(`   1. Update Gmail credentials in server.js`);
  console.log(`   2. Enable 2FA and create App Password`);
  console.log(`   3. Restart server\n`);
});