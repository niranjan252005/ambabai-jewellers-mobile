const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcryptjs');

console.log('Setting up Jewelry App Database...');

const db = new sqlite3.Database('./jewelry.db');

db.serialize(() => {
  console.log('Creating tables...');
  
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
    brand TEXT,
    size TEXT,
    color TEXT,
    gender TEXT DEFAULT 'Unisex',
    is_certified INTEGER DEFAULT 0,
    is_handmade INTEGER DEFAULT 0,
    
    -- Melting Data
    purity TEXT,
    karat INTEGER,
    melting_weight REAL,
    melting_value REAL,
    wastage_percentage REAL DEFAULT 0,
    making_charges REAL DEFAULT 0,
    
    -- Additional Professional Fields
    sku TEXT UNIQUE,
    barcode TEXT,
    supplier TEXT,
    purchase_price REAL,
    margin_percentage REAL,
    discount_percentage REAL DEFAULT 0,
    tax_percentage REAL DEFAULT 0,
    
    -- Physical Properties
    length REAL,
    width REAL,
    thickness REAL,
    stone_weight REAL DEFAULT 0,
    stone_type TEXT,
    stone_count INTEGER DEFAULT 0,
    
    -- Business Fields
    warranty_months INTEGER DEFAULT 12,
    return_policy_days INTEGER DEFAULT 30,
    is_featured INTEGER DEFAULT 0,
    is_bestseller INTEGER DEFAULT 0,
    is_new_arrival INTEGER DEFAULT 0,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
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

  console.log('Creating default admin user...');
  
  // Create default admin user
  const adminPassword = bcrypt.hashSync('admin123', 10);
  db.run(`INSERT OR IGNORE INTO users (username, email, password, role, is_approved) 
          VALUES ('admin', 'admin@jewelry.com', ?, 'admin', 1)`, [adminPassword]);

  console.log('Adding sample jewelry items...');
  
  // Add some sample jewelry items
  const sampleItems = [
    // Gold Rings
    {
      name: 'Diamond Engagement Ring',
      description: 'Beautiful 1-carat diamond engagement ring in 18k yellow gold with brilliant cut diamond',
      price: 2500.00,
      category: 'Rings',
      material: '18k Gold',
      weight: 3.5,
      stock_quantity: 5,
      brand: 'Luxury Gems',
      size: '6',
      color: 'Yellow Gold',
      gender: 'Women',
      purity: '750',
      karat: 18,
      melting_weight: 2.8,
      melting_value: 168.00,
      wastage_percentage: 8.0,
      making_charges: 350.00,
      sku: 'LG-DER-001',
      supplier: 'Diamond Crafters Ltd',
      purchase_price: 1800.00,
      margin_percentage: 38.9,
      stone_weight: 0.7,
      stone_type: 'Diamond',
      stone_count: 1,
      warranty_months: 24,
      is_featured: 1
    },
    {
      name: 'Gold Wedding Band',
      description: 'Classic gold wedding band with smooth finish and comfort fit',
      price: 420.00,
      category: 'Rings',
      material: '14k Gold',
      weight: 4.2,
      stock_quantity: 15,
      brand: 'Eternal Love',
      size: '7',
      color: 'Yellow Gold',
      gender: 'Unisex',
      purity: '585',
      karat: 14,
      melting_weight: 4.2,
      melting_value: 210.00,
      wastage_percentage: 5.0,
      making_charges: 80.00,
      sku: 'EL-GWB-007',
      supplier: 'Gold Masters Inc',
      purchase_price: 320.00,
      margin_percentage: 31.3,
      warranty_months: 36,
      is_bestseller: 1
    },
    {
      name: 'Rose Gold Vintage Ring',
      description: 'Vintage-inspired rose gold ring with intricate filigree design',
      price: 680.00,
      category: 'Rings',
      material: 'Rose Gold',
      weight: 3.8,
      stock_quantity: 8,
      brand: 'Vintage Charm',
      size: '5.5',
      color: 'Rose Gold',
      gender: 'Women'
    },
    {
      name: 'Gold Signet Ring',
      description: 'Bold gold signet ring perfect for men, customizable engraving',
      price: 550.00,
      category: 'Rings',
      material: '14k Gold',
      weight: 6.2,
      stock_quantity: 10,
      brand: 'Gentleman\'s Choice',
      size: '10',
      color: 'Yellow Gold',
      gender: 'Men'
    },

    // Gold Necklaces
    {
      name: 'Gold Chain Necklace',
      description: 'Elegant 18k gold chain necklace with intricate Cuban link design',
      price: 850.00,
      category: 'Necklaces',
      material: '18k Gold',
      weight: 12.3,
      stock_quantity: 7,
      brand: 'Golden Links',
      size: '20 inches',
      color: 'Yellow Gold',
      gender: 'Unisex'
    },
    {
      name: 'Gold Heart Pendant',
      description: 'Romantic gold heart pendant with diamond accent on delicate chain',
      price: 390.00,
      category: 'Necklaces',
      material: '14k Gold',
      weight: 5.1,
      stock_quantity: 12,
      brand: 'Love Collection',
      size: '18 inches',
      color: 'Yellow Gold',
      gender: 'Women'
    },
    {
      name: 'Gold Cross Necklace',
      description: 'Spiritual gold cross necklace with detailed craftsmanship',
      price: 320.00,
      category: 'Necklaces',
      material: '14k Gold',
      weight: 4.5,
      stock_quantity: 9,
      brand: 'Faith Jewelry',
      size: '22 inches',
      color: 'Yellow Gold',
      gender: 'Unisex'
    },

    // Gold Earrings
    {
      name: 'Gold Hoop Earrings',
      description: 'Classic 14k gold hoop earrings, perfect for everyday wear',
      price: 180.00,
      category: 'Earrings',
      material: '14k Gold',
      weight: 2.1,
      stock_quantity: 12,
      brand: 'Daily Elegance',
      size: 'Medium',
      color: 'Yellow Gold',
      gender: 'Women'
    },
    {
      name: 'Gold Diamond Studs',
      description: 'Brilliant gold diamond stud earrings with secure backing',
      price: 750.00,
      category: 'Earrings',
      material: '18k Gold',
      weight: 1.8,
      stock_quantity: 6,
      brand: 'Diamond Dreams',
      size: '0.5 carat',
      color: 'White Gold',
      gender: 'Women'
    },
    {
      name: 'Gold Drop Earrings',
      description: 'Elegant gold drop earrings with pearl accents',
      price: 280.00,
      category: 'Earrings',
      material: '14k Gold',
      weight: 3.2,
      stock_quantity: 14,
      brand: 'Pearl Elegance',
      size: 'Long',
      color: 'Yellow Gold',
      gender: 'Women'
    },

    // Gold Bracelets
    {
      name: 'Gold Tennis Bracelet',
      description: 'Luxurious gold tennis bracelet with diamonds',
      price: 1200.00,
      category: 'Bracelets',
      material: '14k Gold',
      weight: 8.9,
      stock_quantity: 4,
      brand: 'Tennis Elite',
      size: '7 inches',
      color: 'Yellow Gold',
      gender: 'Women'
    },
    {
      name: 'Gold Chain Bracelet',
      description: 'Sturdy gold chain bracelet with secure clasp',
      price: 450.00,
      category: 'Bracelets',
      material: '14k Gold',
      weight: 6.7,
      stock_quantity: 11,
      brand: 'Chain Masters',
      size: '8 inches',
      color: 'Yellow Gold',
      gender: 'Men'
    },

    // Silver Rings
    {
      name: 'Silver Promise Ring',
      description: 'Romantic sterling silver promise ring with heart design and CZ stones',
      price: 89.00,
      category: 'Rings',
      material: 'Sterling Silver',
      weight: 2.7,
      stock_quantity: 18,
      brand: 'Promise Collection',
      size: '6',
      color: 'Silver',
      gender: 'Women'
    },
    {
      name: 'Silver Celtic Ring',
      description: 'Traditional Celtic knot design in sterling silver',
      price: 125.00,
      category: 'Rings',
      material: 'Sterling Silver',
      weight: 4.1,
      stock_quantity: 13,
      brand: 'Celtic Heritage',
      size: '8',
      color: 'Silver',
      gender: 'Unisex'
    },
    {
      name: 'Silver Stackable Rings',
      description: 'Set of 3 delicate silver stackable rings with different textures',
      price: 95.00,
      category: 'Rings',
      material: 'Sterling Silver',
      weight: 2.1,
      stock_quantity: 20,
      brand: 'Stack Style',
      size: '7',
      color: 'Silver',
      gender: 'Women'
    },

    // Silver Necklaces
    {
      name: 'Pearl Necklace',
      description: 'Elegant freshwater pearl necklace with sterling silver clasp',
      price: 450.00,
      category: 'Necklaces',
      material: 'Sterling Silver',
      weight: 15.2,
      stock_quantity: 8,
      brand: 'Ocean Pearls',
      size: '18 inches',
      color: 'Silver',
      gender: 'Women',
      purity: '925',
      melting_weight: 8.5,
      melting_value: 8.50,
      wastage_percentage: 3.0,
      making_charges: 120.00,
      sku: 'OP-PN-018',
      supplier: 'Pearl Artisans',
      purchase_price: 280.00,
      margin_percentage: 60.7,
      stone_weight: 6.7,
      stone_type: 'Freshwater Pearl',
      stone_count: 45,
      warranty_months: 18,
      is_new_arrival: 1
    },
    {
      name: 'Silver Pendant Necklace',
      description: 'Stunning silver pendant necklace with amethyst gemstone',
      price: 220.00,
      category: 'Necklaces',
      material: 'Sterling Silver',
      weight: 8.1,
      stock_quantity: 12,
      brand: 'Gemstone Gallery',
      size: '20 inches',
      color: 'Silver',
      gender: 'Women'
    },
    {
      name: 'Silver Locket Necklace',
      description: 'Vintage-style silver locket that opens to hold photos',
      price: 165.00,
      category: 'Necklaces',
      material: 'Sterling Silver',
      weight: 6.8,
      stock_quantity: 15,
      brand: 'Memory Keepers',
      size: '22 inches',
      color: 'Silver',
      gender: 'Women'
    },

    // Silver Earrings
    {
      name: 'Silver Stud Earrings',
      description: 'Beautiful sterling silver stud earrings with cubic zirconia',
      price: 95.00,
      category: 'Earrings',
      material: 'Sterling Silver',
      weight: 1.8,
      stock_quantity: 20,
      brand: 'Crystal Clear',
      size: 'Small',
      color: 'Silver',
      gender: 'Women'
    },
    {
      name: 'Silver Chandelier Earrings',
      description: 'Dramatic silver chandelier earrings with intricate design',
      price: 145.00,
      category: 'Earrings',
      material: 'Sterling Silver',
      weight: 4.2,
      stock_quantity: 8,
      brand: 'Statement Pieces',
      size: 'Large',
      color: 'Silver',
      gender: 'Women'
    },
    {
      name: 'Silver Hoop Earrings',
      description: 'Classic silver hoop earrings with hammered texture',
      price: 75.00,
      category: 'Earrings',
      material: 'Sterling Silver',
      weight: 2.5,
      stock_quantity: 25,
      brand: 'Everyday Silver',
      size: 'Medium',
      color: 'Silver',
      gender: 'Women'
    },

    // Silver Bracelets
    {
      name: 'Silver Chain Bracelet',
      description: 'Delicate sterling silver chain bracelet with heart charm',
      price: 125.00,
      category: 'Bracelets',
      material: 'Sterling Silver',
      weight: 5.4,
      stock_quantity: 10,
      brand: 'Charm Collection',
      size: '7 inches',
      color: 'Silver',
      gender: 'Women'
    },
    {
      name: 'Silver Cuff Bracelet',
      description: 'Bold silver cuff bracelet with engraved pattern',
      price: 185.00,
      category: 'Bracelets',
      material: 'Sterling Silver',
      weight: 12.3,
      stock_quantity: 7,
      brand: 'Bold Statements',
      size: 'Adjustable',
      color: 'Silver',
      gender: 'Unisex'
    },
    {
      name: 'Silver Tennis Bracelet',
      description: 'Elegant silver tennis bracelet with CZ stones',
      price: 320.00,
      category: 'Bracelets',
      material: 'Sterling Silver',
      weight: 8.7,
      stock_quantity: 6,
      brand: 'Tennis Elite Silver',
      size: '7.5 inches',
      color: 'Silver',
      gender: 'Women'
    }
  ];

  sampleItems.forEach(item => {
    db.run(
      `INSERT OR IGNORE INTO jewelry_items (name, description, price, category, material, weight, stock_quantity)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [item.name, item.description, item.price, item.category, item.material, item.weight, item.stock_quantity]
    );
  });

  console.log('Database setup complete!');
  console.log('Default admin credentials:');
  console.log('Email: admin@jewelry.com');
  console.log('Password: admin123');
});

db.close();