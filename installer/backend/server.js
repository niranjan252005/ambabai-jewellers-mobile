const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const sqlite3 = require('sqlite3').verbose();
const multer = require('multer');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = 'jewelry_app_secret_key';

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

// Database initialization
const db = new sqlite3.Database('./jewelry.db');

// Initialize database tables
db.serialize(() => {
  // Users table
  db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT DEFAULT 'user',
    is_approved INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  // Jewelry items table
  db.run(`CREATE TABLE IF NOT EXISTS jewelry_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    category TEXT,
    material TEXT,
    weight REAL,
    image_url TEXT,
    stock_quantity INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  // Orders table
  db.run(`CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    jewelry_id INTEGER,
    quantity INTEGER DEFAULT 1,
    total_price REAL,
    status TEXT DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (jewelry_id) REFERENCES jewelry_items (id)
  )`);

  // Create default admin user
  const adminPassword = bcrypt.hashSync('admin123', 10);
  db.run(`INSERT OR IGNORE INTO users (username, email, password, role, is_approved) 
          VALUES ('admin', 'admin@jewelry.com', ?, 'admin', 1)`, [adminPassword]);
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
    // Check if trying to register as admin
    if (role === 'admin') {
      // Count existing admins
      db.get('SELECT COUNT(*) as count FROM users WHERE role = "admin"', (err, result) => {
        if (err) {
          return res.status(500).json({ error: 'Server error' });
        }
        
        // Limit to maximum 3 admins
        if (result.count >= 3) {
          return res.status(400).json({ error: 'Maximum number of admins reached' });
        }
        
        // Create admin user
        const hashedPassword = bcrypt.hashSync(password, 10);
        db.run(
          'INSERT INTO users (username, email, password, role, is_approved) VALUES (?, ?, ?, ?, ?)',
          [username, email, hashedPassword, 'admin', 1],
          function(err) {
            if (err) {
              return res.status(400).json({ error: 'User already exists' });
            }
            res.json({ message: 'Admin registered successfully.' });
          }
        );
      });
    } else {
      // Regular user registration
      const hashedPassword = await bcrypt.hash(password, 10);
      
      db.run(
        'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
        [username, email, hashedPassword],
        function(err) {
          if (err) {
            return res.status(400).json({ error: 'User already exists' });
          }
          res.json({ message: 'User registered successfully. Awaiting admin approval.' });
        }
      );
    }
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/login', (req, res) => {
  const { email, password } = req.body;
  
  db.get('SELECT * FROM users WHERE email = ?', [email], async (err, user) => {
    if (err || !user) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }
    
    if (user.role === 'user' && !user.is_approved) {
      return res.status(403).json({ error: 'Account not approved by admin' });
    }
    
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }
    
    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );
    
    res.json({
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  });
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

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});