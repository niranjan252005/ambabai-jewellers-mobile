const sqlite3 = require('sqlite3').verbose();
const { admin, db, FirebaseService } = require('./services/firebase');
const bcrypt = require('bcryptjs');

async function migrateData() {
  console.log('🔥 Starting Firebase Migration...');
  
  try {
    const sqliteDb = new sqlite3.Database('./jewelry.db');
    
    // Migrate users
    console.log('👥 Migrating users...');
    await new Promise((resolve, reject) => {
      sqliteDb.all('SELECT * FROM users', async (err, users) => {
        if (err) {
          console.error('Error reading users:', err);
          reject(err);
          return;
        }
        
        if (users && users.length > 0) {
          for (const user of users) {
            try {
              await FirebaseService.users().add({
                username: user.username,
                name: user.username, // Use username as name
                email: user.email,
                password: user.password, // Already hashed
                role: user.role || 'user',
                is_approved: user.is_approved === 1,
                phone: user.phone || null,
                address: user.address || null,
                created_at: FirebaseService.serverTimestamp()
              });
              console.log(`✅ Migrated user: ${user.email}`);
            } catch (error) {
              console.error(`❌ Failed to migrate user ${user.email}:`, error);
            }
          }
          console.log(`✅ Migrated ${users.length} users`);
        } else {
          console.log('ℹ️ No users found to migrate');
        }
        resolve();
      });
    });

    // Migrate jewelry items
    console.log('💎 Migrating jewelry items...');
    await new Promise((resolve, reject) => {
      sqliteDb.all('SELECT * FROM jewelry_items', async (err, items) => {
        if (err) {
          console.error('Error reading jewelry items:', err);
          reject(err);
          return;
        }
        
        if (items && items.length > 0) {
          for (const item of items) {
            try {
              await FirebaseService.jewelryItems().add({
                name: item.name,
                description: item.description || '',
                price: parseFloat(item.price) || 0,
                category: item.category || 'Uncategorized',
                material: item.material || 'Unknown',
                weight: parseFloat(item.weight) || 0,
                image_url: item.image_url || '',
                stock_quantity: parseInt(item.stock_quantity) || 0,
                sku: item.sku || await FirebaseService.generateSKU(item.category || 'GEN', item.material || 'GEN'),
                
                // Melting data
                purity: item.purity || '22K',
                karat: parseInt(item.karat) || 22,
                melting_weight: parseFloat(item.melting_weight) || 0,
                melting_value: parseFloat(item.melting_value) || 0,
                wastage_percentage: parseFloat(item.wastage_percentage) || 8,
                making_charges: parseFloat(item.making_charges) || 0,
                
                // Business data
                brand: item.brand || 'Ambabai Jewellers',
                size: item.size || 'Standard',
                color: item.color || 'Gold',
                gender: item.gender || 'Unisex',
                certification: item.certification || 'BIS Hallmark',
                supplier: item.supplier || 'Local Supplier',
                purchase_price: parseFloat(item.purchase_price) || 0,
                margin_percentage: parseFloat(item.margin_percentage) || 20,
                
                created_at: FirebaseService.serverTimestamp()
              });
              console.log(`✅ Migrated item: ${item.name}`);
            } catch (error) {
              console.error(`❌ Failed to migrate item ${item.name}:`, error);
            }
          }
          console.log(`✅ Migrated ${items.length} jewelry items`);
        } else {
          console.log('ℹ️ No jewelry items found to migrate');
        }
        resolve();
      });
    });

    // Migrate orders
    console.log('📦 Migrating orders...');
    await new Promise((resolve, reject) => {
      sqliteDb.all('SELECT * FROM orders', async (err, orders) => {
        if (err) {
          console.error('Error reading orders:', err);
          reject(err);
          return;
        }
        
        if (orders && orders.length > 0) {
          for (const order of orders) {
            try {
              await FirebaseService.orders().add({
                user_id: order.user_id.toString(),
                jewelry_id: order.jewelry_id.toString(),
                quantity: parseInt(order.quantity) || 1,
                total_price: parseFloat(order.total_price) || 0,
                status: order.status || 'pending',
                created_at: FirebaseService.serverTimestamp()
              });
              console.log(`✅ Migrated order: ${order.id}`);
            } catch (error) {
              console.error(`❌ Failed to migrate order ${order.id}:`, error);
            }
          }
          console.log(`✅ Migrated ${orders.length} orders`);
        } else {
          console.log('ℹ️ No orders found to migrate');
        }
        resolve();
      });
    });

    // Create default admin user if not exists
    console.log('👑 Creating default admin user...');
    const adminQuery = await FirebaseService.users()
      .where('email', '==', 'admin@ambabaijewellers.com')
      .get();
    
    if (adminQuery.empty) {
      const adminPassword = await bcrypt.hash('admin123', 10);
      await FirebaseService.users().add({
        username: 'Niranjan Barwade',
        name: 'Niranjan Barwade',
        email: 'admin@ambabaijewellers.com',
        password: adminPassword,
        role: 'admin',
        is_approved: true,
        phone: '+917666993107',
        address: 'Vishal Nagar Hupari (416203)',
        created_at: FirebaseService.serverTimestamp()
      });
      console.log('✅ Created default admin user');
    } else {
      console.log('ℹ️ Admin user already exists');
    }

    sqliteDb.close();
    console.log('🎉 Migration completed successfully!');
    
  } catch (error) {
    console.error('❌ Migration failed:', error);
  }
}

// Run migration if this file is executed directly
if (require.main === module) {
  migrateData().then(() => {
    console.log('Migration script finished');
    process.exit(0);
  }).catch((error) => {
    console.error('Migration script failed:', error);
    process.exit(1);
  });
}

module.exports = { migrateData };